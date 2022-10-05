local  QBCore = exports['qb-core']:GetCoreObject()

local StoreHit = nil
local doorsLocked = false
local CityLocked = false
local GrapeLocked = false
local PalLocked = false

local function LockCity()
    TriggerEvent('qb-doorlock:client:setState', source, Config.CityDoor, true, src, false, false)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.CityDoor, true, false, false, true)
    TriggerServerEvent('qb-doorlock:server:updateState', Config.CitySec, true, false, false, true)
    CityLocked = true
end

local function UnlockCity()
    TriggerEvent('qb-doorlock:client:setState', source, Config.CityDoor, false, src, false, false)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.CityDoor, false, false, false, true)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.CitySec, false, false, false, true)
    CityLocked = false
end

local function LockGrape()
    TriggerEvent('qb-doorlock:client:setState', source, Config.GrapeDoor, true, src, false, false)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeDoor, true, false, false, true)
    TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeSec, true, false, false, true)
    GrapeLocked = true
end

local function UnlockGrape()
    TriggerEvent('qb-doorlock:client:setState', source, Config.GrapeDoor, false, src, false, false)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeDoor, false, false, false, false)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeSec, false, false, false, false)
    GrapeLocked = false
end

local function LockPal()
    TriggerServerEvent('qb-doorlock:server:updateState', Config.PalDoor, true, false, false, false)
    TriggerServerEvent('qb-doorlock:server:updateState', Config.PalSec, true, false, false, false)
    PalLocked = true
end

local function UnlockPal()
    TriggerServerEvent('qb-doorlock:server:updateState', Config.PalDoor, false, false, false, false)
    -- TriggerServerEvent('qb-doorlock:server:updateState', Config.PalSec, false, false, false, false)
    PalLocked = false
end

local function LockAll()
    LockCity()
    LockGrape()
    LockPal()
    if CityLocked then
        if GrapeLocked then
            if PalLocked then
                doorsLocked = true
            end
        end
    end
end

local function UnlockAll()
    UnlockCity()
    UnlockGrape()
    UnlockPal()
    if not CityLocked then
        if not GrapeLocked then
            if not PalLocked then
                doorsLocked = false
            end
        end
    end
end

CreateThread(function()
    local loopDone = false
    while true do
        Wait(1000)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then
            if not doorsLocked then
                if not StoreHit then
                    Wait(30000)
                    LockAll()
                    loopDone = false
                    print('Vangellico Jewelers Locked')
                end
            else
                Wait(5000)
            end
        elseif GetClockHours() >= 6 and GetClockHours() <= 18 then
            if not loopDone then
                Wait(30000)
                UnlockAll()
                loopDone = true
                print('Vangellico Jewelers Unlocked')
            else
                Wait(5000)
            end
        end
    end
end)

RegisterNetEvent('qb-jewelery:client:ElectricBox', function()

    
    -- QBCore.Functions.Notify("Door Hacked! Should be opening soon..", 'success')

    if Config.Doorlock == "ox" then
        exports['okokNotify']:Alert("That's It!", "The doors hacked, it should be opening soon..", 5000, 'criminal')
        TriggerServerEvent('qb-jewelery:client:Door')
    elseif Config.Doorlock == "qb" then
        exports['okokNotify']:Alert("That's It!", "The doors hacked, it should be opening soon..", 5000, 'criminal') 
        if StoreHit == "city" then
            UnlockCity()
            print('City Jewelers Unlocked')
            Wait(Config.Cooldown)
            StoreHit = nil
            if GetClockHours() >= 18 or GetClockHours() <= 6 then
                LockCity()
            end
        elseif StoreHit == "grape" then
            UnlockGrape()
            print('Grapeseed Jewelers Unlocked')
            Wait(Config.Cooldown)
            StoreHit = nil
            if GetClockHours() >= 18 or GetClockHours() <= 6 then
                LockGrape()
            end
        elseif StoreHit == "pal" then
            UnlockPal()
            print('Paleto Jewelers Unlocked')
            Wait(Config.Cooldown)
            StoreHit = nil
            if GetClockHours() >= 18 or GetClockHours() <= 6 then
                LockPal()
            end
        elseif StoreHit == "all" then
            UnlockCity()
            UnlockGrape()
            UnlockPal()
            print('Vangellico Jewelers Unlocked')
            Wait(Config.Cooldown)
            StoreHit = nil
            if GetClockHours() >= 18 or GetClockHours() <= 6 then
                LockCity()
                LockGrape()
                LockPal()
            end
        end
    end



    -- Police Call / Needs Configuring

    --[[if math.random(1,100) < 80 then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = data.coords,
            title = '10-36 - Suspicious Activity',
            message = 'A '..data.sex..' robbing a store at '..data.street, 
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 769, 
                scale = 0.9, 
                colour = 0,
                flashes = true, 
                text = '911 - Suspicious Activity',
                time = (5*60*1000),
                sound = 1,
            }
        })
    end]]

end)

RegisterNetEvent('qb-jewelery:client:thermitecity', function()
    QBCore.Functions.TriggerCallback('qb-jewellery:server:getCops', function(cops)
        if GetClockHours() <= 6 or GetClockHours() >= 18 then
            if cops >= Config.RequiredCops then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                for k,v in pairs(Config.Jewelery['city']) do
                    local Dist = #(coords - vector3(v['coords'].x, v['coords'].y, v['coords'].z))
                    if Dist <= 1.5 then
                        QBCore.Functions.TriggerCallback('qb-jewelery:server:GetItemsNeeded', function(hasItem)
                            if hasItem then
                                SetEntityHeading(ped, Config.Jewelery['city'][k]['coords'].w)
                                -- TriggerServerEvent('qb-bankrobbery:server:RemovePaletoDoorItem')
                                exports['memorygame']:thermiteminigame(Config.ThermiteSettings.correctBlocks, Config.ThermiteSettings.incorrectBlocks, Config.ThermiteSettings.timetoShow, Config.ThermiteSettings.timetoLose,
                                function() -- success
                                    exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'criminal')
                                    -- QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                    local loc = Config.Jewelery['city'][k]['anim']
                                    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
                                    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                                    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), loc.x, loc.y, loc.z,  true,  true, false)
                                    SetEntityCollision(bag, false, true)
                                    NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                                    NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                                    NetworkStartSynchronisedScene(bagscene)
                                    Wait(1500)
                                    local x, y, z = table.unpack(GetEntityCoords(ped))
                                    local thermal_charge = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.2,  true,  true, true)
                                
                                    SetEntityCollision(thermal_charge, false, true)
                                    AttachEntityToEntity(thermal_charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                                    Wait(4000)
                                    TriggerServerEvent('qb-jewelery:server:RemoveDoorItem')
                                    -- TriggerServerEvent('QBCore:Server:RemoveItem', 'thermite', 1)
                                    -- TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['thermite'], 'remove')
                                
                                    DetachEntity(thermal_charge, 1, 1)
                                    FreezeEntityPosition(thermal_charge, true)
                                    Wait(100)
                                    DeleteObject(bag)
                                    ClearPedTasks(ped)
                                
                                    Wait(100)
                                    RequestNamedPtfxAsset('scr_ornate_heist')
                                    while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
                                        Wait(1)
                                    end
                                    -- ptfx = vector3(Config.Jewelery['thermite'][k]['effect'].x, Config.Jewelery['thermite'][k]['effect'].y, Config.Jewelery['thermite'][k]['effect'].z)
                                    local termcoords = GetEntityCoords(thermal_charge)
                                    ptfx = vector3(termcoords.x, termcoords.y + 1.0, termcoords.z)

                                    SetPtfxAssetNextCall('scr_ornate_heist')
                                    local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', ptfx, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
                                    Wait(3000)
                                    StopParticleFxLooped(effect, 0)
                                    StoreHit = "city"
                                    DeleteObject(thermal_charge)
                                    TriggerEvent('qb-jewelery:client:ElectricBox')
                                end,
                                function() -- failure
                                    exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                    -- QBCore.Functions.Notify("You Failure!", 'error', 4500)
                                    StoreHit = nil
                                end)
                            else
                                exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                                -- QBCore.Functions.Notify("You don't have the correct items!", 'error')
                            end
                        end, "thermite")
                    end
                end
            else
                exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'criminal')
                -- QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
            end
        elseif GetClockHours() >= 6 and GetClockHours() <= 18 then
            exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 5000, 'criminal')
        end
    end)
end)

RegisterNetEvent('qb-jewelery:client:thermitegrape', function()
    QBCore.Functions.TriggerCallback('qb-jewellery:server:getCops', function(cops)
        if GetClockHours() <= 6 or GetClockHours() >= 18 then
            if cops >= Config.RequiredCops then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                for k,v in pairs(Config.Jewelery['grape']) do
                    local Dist = #(coords - vector3(v['coords'].x, v['coords'].y, v['coords'].z))
                    if Dist <= 1.5 then
                        QBCore.Functions.TriggerCallback('qb-jewelery:server:GetItemsNeeded', function(hasItem)
                            if hasItem then
                                SetEntityHeading(ped, Config.Jewelery['grape'][k]['coords'].w)
                                -- TriggerServerEvent('qb-bankrobbery:server:RemovePaletoDoorItem')
                                exports['memorygame']:thermiteminigame(Config.ThermiteSettings.correctBlocks, Config.ThermiteSettings.incorrectBlocks, Config.ThermiteSettings.timetoShow, Config.ThermiteSettings.timetoLose,
                                function() -- success
                                    exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'criminal')
                                    -- QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                    local loc = Config.Jewelery['grape'][k]['anim']
                                    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
                                    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                                    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), loc.x, loc.y, loc.z,  true,  true, false)
                                    SetEntityCollision(bag, false, true)
                                    NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                                    NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                                    NetworkStartSynchronisedScene(bagscene)
                                    Wait(1500)
                                    local x, y, z = table.unpack(GetEntityCoords(ped))
                                    local thermal_charge = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.2,  true,  true, true)
                                
                                    SetEntityCollision(thermal_charge, false, true)
                                    AttachEntityToEntity(thermal_charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                                    Wait(4000)

                                    TriggerServerEvent('qb-jewelery:server:RemoveDoorItem')
                                    -- TriggerServerEvent('QBCore:Server:RemoveItem', 'thermite', 1)
                                    -- TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['thermite'], 'remove')
                                
                                    DetachEntity(thermal_charge, 1, 1)
                                    FreezeEntityPosition(thermal_charge, true)
                                    Wait(100)
                                    DeleteObject(bag)
                                    ClearPedTasks(ped)
                                
                                    Wait(100)
                                    RequestNamedPtfxAsset('scr_ornate_heist')
                                    while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
                                        Wait(1)
                                    end
                                    -- ptfx = vector3(Config.Jewelery['grape'][k]['effect'].x, Config.Jewelery['grape'][k]['effect'].y, Config.Jewelery['grape'][k]['effect'].z)
                                    local termcoords = GetEntityCoords(thermal_charge)
                                    ptfx = vector3(termcoords.x, termcoords.y + 1.0, termcoords.z)

                                    SetPtfxAssetNextCall('scr_ornate_heist')
                                    local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', ptfx, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
                                    Wait(3000)
                                    StopParticleFxLooped(effect, 0)
                                    StoreHit = "grape"
                                    DeleteObject(thermal_charge)
                                    TriggerEvent('qb-jewelery:client:ElectricBox')
                                end,
                                function() -- failure
                                    exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                    -- QBCore.Functions.Notify("You Failure!", 'error', 4500)
                                    StoreHit = nil
                                end)
                            else
                                exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                                -- QBCore.Functions.Notify("You don't have the correct items!", 'error')
                            end
                        end, "thermite")
                    end
                end
            else
                exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'criminal')
                -- QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
            end
        elseif GetClockHours() >= 6 and GetClockHours() <= 18 then
            exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 5000, 'criminal')
        end
    end)
end)

RegisterNetEvent('qb-jewelery:client:thermitepal', function()
    QBCore.Functions.TriggerCallback('qb-jewellery:server:getCops', function(cops)
        if GetClockHours() <= 6 or GetClockHours() >= 18 then
            if cops >= Config.RequiredCops then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                for k,v in pairs(Config.Jewelery['pal']) do
                    local Dist = #(coords - vector3(v['coords'].x, v['coords'].y, v['coords'].z))
                    if Dist <= 1.5 then
                        QBCore.Functions.TriggerCallback('qb-jewelery:server:GetItemsNeeded', function(hasItem)
                            if hasItem then
                                SetEntityHeading(ped, Config.Jewelery['pal'][k]['coords'].w)
                                -- TriggerServerEvent('qb-bankrobbery:server:RemovePaletoDoorItem')
                                exports['memorygame']:thermiteminigame(Config.ThermiteSettings.correctBlocks, Config.ThermiteSettings.incorrectBlocks, Config.ThermiteSettings.timetoShow, Config.ThermiteSettings.timetoLose,
                                function() -- success
                                    exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'criminal')
                                    -- QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                    local loc = Config.Jewelery['pal'][k]['anim']
                                    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
                                    local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                                    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), loc.x, loc.y, loc.z,  true,  true, false)
                                    SetEntityCollision(bag, false, true)
                                    NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                                    NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                                    NetworkStartSynchronisedScene(bagscene)
                                    Wait(1500)
                                    local x, y, z = table.unpack(GetEntityCoords(ped))
                                    local thermal_charge = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.2,  true,  true, true)
                                
                                    SetEntityCollision(thermal_charge, false, true)
                                    AttachEntityToEntity(thermal_charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                                    Wait(4000)

                                    TriggerServerEvent('qb-jewelery:server:RemoveDoorItem')
                                    -- TriggerServerEvent('QBCore:Server:RemoveItem', 'thermite', 1)
                                    -- TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['thermite'], 'remove')
                                
                                    DetachEntity(thermal_charge, 1, 1)
                                    FreezeEntityPosition(thermal_charge, true)
                                    Wait(100)
                                    DeleteObject(bag)
                                    ClearPedTasks(ped)
                                
                                    Wait(100)
                                    RequestNamedPtfxAsset('scr_ornate_heist')
                                    while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
                                        Wait(1)
                                    end
                                    -- ptfx = vector3(Config.Jewelery['pal'][k]['effect'].x, Config.Jewelery['pal'][k]['effect'].y, Config.Jewelery['pal'][k]['effect'].z)
                                    local termcoords = GetEntityCoords(thermal_charge)
                                    ptfx = vector3(termcoords.x, termcoords.y + 1.0, termcoords.z)

                                    SetPtfxAssetNextCall('scr_ornate_heist')
                                    local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', ptfx, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
                                    Wait(3000)
                                    StopParticleFxLooped(effect, 0)
                                    StoreHit = "pal"
                                    DeleteObject(thermal_charge)
                                    TriggerEvent('qb-jewelery:client:ElectricBox')
                                end,
                                function() -- failure
                                    exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                    -- QBCore.Functions.Notify("You Failure!", 'error', 4500)
                                    StoreHit = nil
                                end)
                            else
                                exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                                -- QBCore.Functions.Notify("You don't have the correct items!", 'error')
                            end
                        end, "thermite")
                    end
                end
            else
                exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'criminal')
                -- QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
            end
        elseif GetClockHours() >= 6 and GetClockHours() <= 18 then
            exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 5000, 'criminal')
        end
    end)
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("jewcity", vector3(-595.89, -283.63, 50.32), 0.4, 0.8, {
    name = "jewcity",
    heading = 300.0,
    debugPoly = true,
    minZ=50.12,
    maxZ=51.32,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:thermitecity",
            icon = 'fas fa-bug',
            label = 'Hack Box',
            item = 'thermite',
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("jewgrape", vector3(1645.07, 4868.05, 42.03), 0.4, 0.8, {
    name = "jewgrape",
    heading = 8.0,
    debugPoly = true,
    minZ=41.23,
    maxZ=42.53,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:thermitegrape",
            icon = 'fas fa-bug',
            label = 'Hack Box',
            item = 'thermite',
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("jewpal", vector3(-368.49, 6055.19, 31.5), 0.4, 0.8, {
    name = "jewpal",
    heading = 314.0,
    debugPoly = true,
    minZ=32.4,
    maxZ=31.2,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:thermitebox",
            icon = 'fas fa-bug',
            label = 'Hack Box',
            item = 'thermite',
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)
