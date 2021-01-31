ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterServerCallback("ruq_clothes:getPlayerDressing", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent("esx_datastore:getDataStore", "property", xPlayer.getIdentifier(), function(store)
		local count  = store.count("dressing")
		local labels = {}

		for i = 1, count, 1 do
			local entry = store.get("dressing", i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback("ruq_clothes:getPlayerOutfit", function(source, cb, num)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent("esx_datastore:getDataStore", "property", xPlayer.getIdentifier(), function(store)
		local outfit = store.get("dressing", num)
		cb(outfit.skin)
	end)
end)

RegisterNetEvent("ruq_clothes:removeOutfit")
AddEventHandler("ruq_clothes:removeOutfit", function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent("esx_datastore:getDataStore", "property", xPlayer.getIdentifier(), function(store)
		local dressing = store.get("dressing") or {}

		table.remove(dressing, label)
		store.set("dressing", dressing)
	end)
end)
