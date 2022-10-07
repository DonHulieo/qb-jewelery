local QBCore = exports['qb-core']:GetCoreObject()

--[[RegisterNetEvent('qb-jewelery:server:RemoveDoorItem', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.DoorItem
    Player.Functions.RemoveItem(item, 1, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
end)]]

RegisterNetEvent('qb-jewelery:server:RemoveDoorItem', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local item = Config.DoorItem
    if not Player then return end
    Player.Functions.RemoveItem(item, 1)
end)

QBCore.Functions.CreateCallback('qb-jewelery:server:GetItemsNeeded', function(source, cb, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then 
        local Themite = Player.Functions.GetItemByName(item)
        if Themite ~= nil then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)