local  QBCore = exports['qb-core']:GetCoreObject()

local StoreHit = nil
local doorsLocked = false
local CityLocked = false
local GrapeLocked = false
local PalLocked = false

----------------------- FUNCTIONS -----------------------

local function LockCity() -- Locks Los Santos Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.CityDoor, true, src, false, false)
    TriggerEvent('qb-doorlock:client:setState', source, Config.CitySec, true, src, false, false)
    if StoreHit == 'city' or StoreHit == 'all' then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.CityDoor, true, false, false, true)
        if StoreHit == 'all' then
            TriggerServerEvent('qb-doorlock:server:updateState', Config.CitySec, true, false, false, true)
        end
        print('City Jewelers Locked')
    end
    CityLocked = true
end

local function UnlockCity() -- Unlocks Los Santos Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.CityDoor, false, src, false, false)
    if StoreHit then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.CityDoor, false, false, false, true)
        print('City Jewelers Unlocked')
        if StoreHit == 'all' then -- Checks if the second door was lockpicked and relocks at close
            TriggerServerEvent('qb-doorlock:server:updateState', Config.CityDoor, false, false, false, true)
            TriggerEvent('qb-doorlock:client:setState', source, Config.CitySec, false, src, false, false)
        end
    end
    CityLocked = false
end

local function LockGrape() -- Locks Grapeseed Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.GrapeDoor, true, src, false, false)
    TriggerEvent('qb-doorlock:client:setState', source, Config.GrapeSec, true, src, false, false)
    if StoreHit == 'grape' or StoreHit == 'all' then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeDoor, true, false, false, true)
        if StoreHit == 'all' then
            TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeSec, true, false, false, true)
        end
        print('Grapeseed Jewelers Locked')
    end
    GrapeLocked = true
end

local function UnlockGrape() -- Unlocks Grapeseed Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.GrapeDoor, false, src, false, false)
    if StoreHit then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeDoor, false, false, false, true)
        print('Grapeseed Jewelers Unlocked')
        if StoreHit == 'all' then -- Checks if the second door was lockpicked and relocks at close
            TriggerServerEvent('qb-doorlock:server:updateState', Config.GrapeDoor, false, false, false, true)
            TriggerEvent('qb-doorlock:client:setState', source, Config.GrapeSec, false, src, false, false)
        end
    end
    GrapeLocked = false
end

local function LockPal() -- Locks Paleto Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.PalDoor, true, src, false, false)
    TriggerEvent('qb-doorlock:client:setState', source, Config.PalSec, true, src, false, false)
    if StoreHit == 'pal' or StoreHit == 'all' then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.PalDoor, true, false, false, true)
        if StoreHit == 'all' then
            TriggerServerEvent('qb-doorlock:server:updateState', Config.PalSec, true, false, false, true)
        end
        print('Paleto Jewelers Locked')
    end
    PalLocked = true
end

local function UnlockPal() -- Unlocks Paleto Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.PalDoor, false, src, false, false)
    if StoreHit then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.PalDoor, false, false, false, true)
        print('Paleto Jewelers Unlocked')
        if StoreHit == 'all' then -- Checks if the second door was lockpicked and relocks at close
            TriggerServerEvent('qb-doorlock:server:updateState', Config.PalSec, false, false, false, true)
            TriggerEvent('qb-doorlock:client:setState', source, Config.PalSec, false, src, false, false)
        end
    end
    PalLocked = false
end

local function LockAll() -- Locks all stores and returns variable to stop the day/night thread below
    LockCity()
    LockGrape()
    LockPal()
    if CityLocked then
        if GrapeLocked then
            if PalLocked then
                print('Vangellico Jewelers Locked')
                doorsLocked = true
            end
        end
    end
end

local function UnlockAll() -- Unlocks all stores and returns variable to stop the day/night thread below
    UnlockCity()
    UnlockGrape()
    UnlockPal()
    if not CityLocked then
        if not GrapeLocked then
            if not PalLocked then
                print('Vangellico Jewelers Unlocked')
                doorsLocked = false
            end
        end
    end
end

local function startAnim()
    CreateThread(function()
        local ped = PlayerPedId()
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
            Citizen.Wait(0)
        end
        attachObject()
        TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
    end)
end

local function attachObject()
    local ped = PlayerPedId()
    tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(tab, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

local function stopAnim()
    local ped = PlayerPedId()
    StopAnimTask(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
    DeleteEntity(tab)
end

local function IsWearingHandshoes() -- Glove check
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

----------------------- EVENTS ----------------------- [ These are really messy I know, if you could help it'd be heavily appreciated as I'm still learning! ]

RegisterNetEvent('qb-jewelery:client:ElectricBox', function()

    if StoreHit == "city" then
        if Config.Notify == "ok" then
            exports['okokNotify']:Alert("That's It!", "The fuses are blown, the doors should open soon..", 5000, 'success')
        elseif Config.Notify == "qb" then
            QBCore.Functions.Notify("Fuses blown! Should be opening soon..", 'success')
        else
            print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
        end
        UnlockCity()
        Wait(Config.Cooldown)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then
            LockCity()
        end
        StoreHit = nil
    elseif StoreHit == "grape" then
        if Config.Notify == "ok" then
            exports['okokNotify']:Alert("That's It!", "The fuses are blown, the doors should open soon..", 5000, 'success')
        elseif Config.Notify == "qb" then
            QBCore.Functions.Notify("Fuses blown! Should be opening soon..", 'success')
        else
            print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
        end
        UnlockGrape()
        Wait(Config.Cooldown)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then
            LockGrape()
        end
        StoreHit = nil
    elseif StoreHit == "pal" then
        if Config.Notify == "ok" then
            exports['okokNotify']:Alert("That's It!", "The fuses are blown, the doors should open soon..", 5000, 'success')
        elseif Config.Notify == "qb" then
            QBCore.Functions.Notify("Fuses blown! Should be opening soon..", 'success')
        else
            print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
        end
        UnlockPal()
        Wait(Config.Cooldown)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then
            LockPal()
        end
        StoreHit = nil
    elseif StoreHit == "all" then
        if Config.Notify == "ok" then
            exports['okokNotify']:Alert("Well Well Well", "Looks like that unlocked all the Vangelico dorrs across the city..", 5000, 'success')
        elseif Config.Notify == "qb" then
            QBCore.Functions.Notify("Did I just unlock all the doors?", 'success')
        else
            print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
        end
        UnlockAll()
        Wait(Config.Cooldown)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then
            LockAll()
        end
        StoreHit = nil
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
                                if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                                elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                                    if Config.Notify == "ok" then
                                        exports['okokNotify']:Alert("FUCK!", Lang:t('error.fingerprints'), 3500, 'error')
                                    elseif Config.Notify == "qb" then
                                        QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
                                    else
                                        print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
                                    end
                                end
                                SetEntityHeading(ped, Config.Jewelery['city'][k]['coords'].w)
                                exports['ps-ui']:Thermite(function(success) -- success
                                    if success then
                                        if Config.Notify == "ok" then     
                                            exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'success')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                        end
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
                                    else
                                        if Config.Notify ==  "ok" then
                                            exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("You Failure!", 'error', 4500)
                                        end
                                        StoreHit = nil
                                    end
                                end, Config.ThermiteSettings.time, Config.ThermiteSettings.gridsize, Config.ThermiteSettings.incorrectBlocks)
                            else
                                if Config.Notify ==  "ok" then
                                    exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                                elseif Config.Notify == "qb" then
                                    QBCore.Functions.Notify("You don't have the correct items!", 'error')
                                end
                            end
                        end, "thermite")
                    else
                        if Config.Notify ==  "ok" then
                            exports['okokNotify']:Alert("Oh Lol..", "I just can't quite reach..", 3500, 'error')
                        elseif Config.Notify == "qb" then
                            QBCore.Functions.Notify("Too far away!", 'error', 3500)
                        end
                    end
                end
            else
                if Config.Notify ==  "ok" then
                    exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'error')
                elseif Config.Notify == "qb" then
                    QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
                end
            end
        else
            if Config.Notify ==  "ok" then
                exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 4500, 'error')
            elseif Config.Notify == "qb" then
                QBCore.Functions.Notify("I should come back and try this at night...", 'error', 4500)
            end
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
                                if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                                elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                                    if Config.Notify == "ok" then
                                        exports['okokNotify']:Alert("FUCK!", Lang:t('error.fingerprints'), 3500, 'error')
                                    elseif Config.Notify == "qb" then
                                        QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
                                    else
                                        print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
                                    end
                                end
                                SetEntityHeading(ped, Config.Jewelery['grape'][k]['coords'].w)
                                exports['ps-ui']:Thermite(function(success) -- success
                                    if success then 
                                        if Config.Notify == "ok" then     
                                            exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'success')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                        end
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
                                    else
                                        if Config.Notify ==  "ok" then
                                            exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("You Failure!", 'error', 4500)
                                        end
                                        StoreHit = nil
                                    end
                                end, Config.ThermiteSettings.time, Config.ThermiteSettings.gridsize, Config.ThermiteSettings.incorrectBlocks)
                            else
                                if Config.Notify ==  "ok" then
                                    exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                                elseif Config.Notify == "qb" then
                                    QBCore.Functions.Notify("You don't have the correct items!", 'error')
                                end
                            end
                        end, "thermite")
                    else
                        if Config.Notify ==  "ok" then
                            exports['okokNotify']:Alert("Oh Lol..", "I just can't quite reach..", 3500, 'error')
                        elseif Config.Notify == "qb" then
                            QBCore.Functions.Notify("Too far away!", 'error', 3500)
                        end
                    end
                end
            else
                if Config.Notify ==  "ok" then
                    exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'error')
                elseif Config.Notify == "qb" then
                    QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
                end
            end
        else
            if Config.Notify ==  "ok" then
                exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 4500, 'error')
            elseif Config.Notify == "qb" then
                QBCore.Functions.Notify("I should come back and try this at night...", 'error', 4500)
            end
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
                                if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                                elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                                    if Config.Notify == "ok" then
                                        exports['okokNotify']:Alert("FUCK!", Lang:t('error.fingerprints'), 3500, 'error')
                                    elseif Config.Notify == "qb" then
                                        QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
                                    else
                                        print('Notifications aren\'t configured, please set this. i.e Config.Notify = "qb"')
                                    end
                                end
                                SetEntityHeading(ped, Config.Jewelery['pal'][k]['coords'].w)
                                exports['ps-ui']:Thermite(function(success)
                                    if success then
                                        if Config.Notify == "ok" then     
                                            exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'success')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                        end
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
                                    else
                                        if Config.Notify ==  "ok" then
                                            exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("You Failure!", 'error', 4500)
                                        end
                                        StoreHit = nil
                                    end
                                end, Config.ThermiteSettings.time, Config.ThermiteSettings.gridsize, Config.ThermiteSettings.incorrectBlocks)
                            else
                                if Config.Notify ==  "ok" then
                                    exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                                elseif Config.Notify == "qb" then
                                    QBCore.Functions.Notify("You don't have the correct items!", 'error')
                                end
                            end
                        end, "thermite")
                    else
                        if Config.Notify ==  "ok" then
                            exports['okokNotify']:Alert("Oh Lol..", "I just can't quite reach..", 3500, 'error')
                        elseif Config.Notify == "qb" then
                            QBCore.Functions.Notify("Too far away!", 'error', 3500)
                        end
                    end
                end
            else
                if Config.Notify ==  "ok" then
                    exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'error')
                elseif Config.Notify == "qb" then
                    QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
                end
            end
        else
            if Config.Notify ==  "ok" then
                exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 4500, 'error')
            elseif Config.Notify == "qb" then
                QBCore.Functions.Notify("I should come back and try this at night...", 'error', 4500)
            end
        end
    end)
end)

RegisterNetEvent('qb-jewelery:client:pchack', function()
    QBCore.Functions.TriggerCallback('qb-jewellery:server:getCops', function(cops)
        if GetClockHours() <= 6 or GetClockHours() >= 18 then
            if cops >= Config.RequiredCops then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                for k,v in pairs(Config.Jewelery['pc']) do
                    local Dist = #(coords - vector3(v['coords'].x, v['coords'].y, v['coords'].z))
                    if Dist <= 1.5 then
                        QBCore.Functions.TriggerCallback('qb-jewelery:server:GetItemsNeeded', function(hasItem)
                            if hasItem then
                                if Config.Notify == "ok" then     
                                    exports['okokNotify']:Alert("What's This?", "I wonder what I'll find on here..?", 3500, 'info')
                                elseif Config.Notify == "qb" then
                                    QBCore.Functions.Notify("What's this?", 'success', 3500)
                                end
                                startAnim()
                                --[[if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", targetPosition)
                                elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", targetPosition)
                                    if Config.Notify == "ok" then     
                                        exports['okokNotify']:Alert("Just Put This Here..", "Should I be wearing protection?", 3500, 'success')
                                    elseif Config.Notify == "qb" then
                                        QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                    end
                                end]]
                                Wait(500)
                                if Config.Notify == "ok" then     
                                    exports['okokNotify']:Alert("@^^%$#", "connecting to security system...", 3500, 'success')
                                elseif Config.Notify == "qb" then
                                    QBCore.Functions.Notify("connecting to security system...", 'success', 3500)
                                end
                                Wait(2000)
                                exports['ps-ui']:VarHack(function(success)
                                    if success then
                                        stopAnim()
                                        StoreHit = "all"
                                        TriggerEvent('qb-jewelery:client:ElectricBox')
                                    else
                                        if Config.Notify == "ok" then     
                                            exports['okokNotify']:Alert("Oh Shit!", "I'll have to try that again..", 4500, 'error')
                                        elseif Config.Notify == "qb" then
                                            QBCore.Functions.Notify("I'll have to try that again..", 'error', 3500)
                                        end
                                        stopAnim()
                                        FreezeEntityPosition(ped, false)
                                        StoreHit = nil
                                    end
                                end, Config.VarHackSettings.blocks, Config.VarHackSettings.time)
                            else
                                exports['okokNotify']:Alert("Oh Damn..", "I should come back and try something else..", 5000, 'criminal')
                            end
                        end, "phone")
                    else
                        exports['okokNotify']:Alert("Oh Lol..", "I just can't quite reach..", 3500, 'error')
                    end
                end
            else
                exports['okokNotify']:Alert("Hmmm..", "Something doesn't seem to right..", 5000, 'criminal')
            end
        else
            exports['okokNotify']:Alert("Oh Shit..", "I should come back and try this at night...", 5000, 'criminal')
        end
    end)
end)

----------------------- THREADS -----------------------

CreateThread(function()
    local loopDone = false
    while true do
        Wait(1000)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then
            if not doorsLocked then
                if not StoreHit then
                    Wait(1000)
                    LockAll()
                    loopDone = false
                end
            else
                Wait(5000)
            end
        elseif GetClockHours() >= 6 and GetClockHours() <= 18 then
            if not loopDone then
                Wait(1000)
                UnlockAll()
                loopDone = true
            else
                Wait(5000)
            end
        end
    end
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("jewpc", vector3(-631.04, -230.63, 38.06), 0.4, 0.6, {
    name = "jewpc",
    heading = 37.0,
    debugPoly = false,
    minZ=37.56,
    maxZ=38.56,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:pchack",
            icon = 'fas fa-bug',
            label = 'Hack Security System',
            item = 'phone',
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("jewcity", vector3(-595.89, -283.63, 50.32), 0.4, 0.8, {
    name = "jewcity",
    heading = 300.0,
    debugPoly = false,
    minZ=50.12,
    maxZ=51.32,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:thermitecity",
            icon = 'fas fa-bug',
            label = 'Blow Fuse Box',
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
    debugPoly = false,
    minZ=41.23,
    maxZ=42.53,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:thermitegrape",
            icon = 'fas fa-bug',
            label = 'Blow Fuse Box',
            item = 'thermite',
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("jewpal", vector3(-368.47, 6055.21, 31.5), 0.4, 0.8, {
    name = "jewpal",
    heading = 135.0,
    debugPoly = false,
    minZ=31.2,
    maxZ=32.4,
    }, {
        options = {
            {
            type = "client",
            event = "qb-jewelery:client:thermitepal",
            icon = 'fas fa-bug',
            label = 'Blow Fuse Box',
            item = 'thermite',
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)
