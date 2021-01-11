ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local sleep = 1000

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Ruq.locations) do
            local elements = {}
            local pPed = PlayerPedId()
            local pos = GetEntityCoords(pPed)
            local dist = GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true)
            if dist < 1.5 then
                sleep = 1
                DrawText3D(v.x, v.y, v.z, "Press ~g~[E]~s~ to access your clothes.")
                if IsControlJustPressed(0, 38) then
                    ESX.UI.Menu.CloseAll()
                    table.insert(elements, {label = "My clothes", value = "myclothes"})
                    table.insert(elements, {label = "Remove clothe", value = "removeclothe"})
                    table.insert(elements, {label = "Close the menu", value = "close"})

                    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "menu", {
                        title = "Clothe menu",
                        align = "top-left",
                        elements = elements
                    }, function(data, menu)
                        if data.current.value == "myclothes" then
                            ESX.TriggerServerCallback("nos_clothes:getPlayerDressing", function(dressing)
                                local elements = {}

                                for i = 1, #dressing, 1 do
                                    table.insert(elements, {
                                        label = dressing[i],
                                        value = i
                                    })
                                end

                                ESX.UI.Menu.Open("default", GetCurrentResourceName(), "menu1", {
                                    title = "Your clothes",
                                    align = "top-left",
                                    elements = elements
                                }, function(data1, menu1)
                                    TriggerEvent("skinchanger:getSkin", function(skin)
                                        ESX.TriggerServerCallback("nos_clothes:getPlayerOutfit", function(clothes)
                                            TriggerEvent("skinchanger:loadClothes", skin, clothes)
                                            TriggerEvent("esx_skin:setLastSkin", skin)
                
                                            TriggerEvent("skinchanger:getSkin", function(skin)
                                                TriggerServerEvent("esx_skin:save", skin)
                                            end)
                                        end, data1.current.value)
                                    end)
                                end, function(data1, menu1)
                                    menu1.close()
                                end)
                            end)
                        elseif data.current.value == "removeclothe" then
                            ESX.TriggerServerCallback("nos_clothes:getPlayerDressing", function(dressing)
                                local elements = {}

                                for i = 1, #dressing, 1 do
                                    table.insert(elements, {
                                        label = dressing[i],
                                        value = i
                                    })
                                end

                                ESX.UI.Menu.Open("default", GetCurrentResourceName(), "menu2", {
                                    title = "Remove clothe",
                                    align = "top-left",
                                    elements = elements
                                }, function(data2, menu2)
                                    menu2.close()
                                    TriggerServerEvent("nos_clothes:removeOutfit", data2.current.value)
                                    ESX.ShowNotification("Removed clothe successfully.")
                                end, function(data2, menu2)
                                    menu2.close()
                                end)
                            end)
                        elseif data.current.value == "close" then
                            ESX.UI.Menu.CloseAll()
                        end
                    end, function(data, menu)
                        menu.close()
                    end)
                end
            elseif dist < 10 then
                sleep = 1
                DrawMarker(20, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 205, 50, 128, true, false, 2, true, nil, nil, false)
            end
        end

        Citizen.Wait(sleep)
    end
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
