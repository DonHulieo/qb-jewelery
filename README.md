# qb-jewelery
Don's Jewelery Store robbery script for QBCore

## Credits
- Holiday95 for the original fork
- FjamZoo for the thermite animations
- QBCore Framework and Developers for original qb-jewelery

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [ps-ui](https://github.com/Project-Sloth/ps-ui)
- [okokNotify](https://okok.tebex.io/package/4724993)

## Features
- 3 Jewelery Store Locations // City, Grapeseed & Paleto
- Doors auto lock after 6pm at night and unlock at 6am.
- Can't hit store during the day... (Good place to put your mining jewels buyer ped!)
- Thermite hack to open unlock doors at night.
- Lockpick into the second room at the city Vangelico's and then hack the PC to unlock all the stores for 5 minutes.

## To Do
- Place qb-jewelery/doors/Jewelery Stores.lua in qb-doorlock/configs

## Why Autolock?
In almost all the QBCore roleplay servers I've played on, have used some cool jewelery robbery scripts but every one that involves a thermite hack for the doors leaves the unlocking of the doors to the city police's discretion. Why can't I enter the store during the day and sell some of this rare mining gems I have? Well miners and esteemed "Jewelers" fret no more! You can sell during the day, from 6am to 6pm.

## How it Works

- Using FiveM natives GetClockHours() qb-jewelery now runs a thread to check if the store has either been locked, robbed or both.
```lua
CreateThread(function()
    local loopDone = false 
    while true do
        Wait(1000)
        if GetClockHours() >= 18 or GetClockHours() <= 6 then -- Hours are in 24 hour time so 18 is 6pm
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
```
- GetClockHours() is also used as the native to stop the thermite hack and case smashing as well meaning they can't be done while the doors are UNLOCKED, if you want to change the time of day the locks update, make sure to update all the if statements referencing GetClockHours(). Keep in mind that one day/night cycle in GTA is 48 minutes, so night time is only 24.

- The (front) doors lock toggle need to be function only as leaving police the ability to lock or unlock the door could mess up the auto locks. Your FRONT door configs should look a little something like this;
```lua
Config.DoorList['jewelery-citymain'] = {
    doorType = 'double',
    locked = true, -- Has to be set true
    cantUnlock = true, -- Has to be set true
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 9467943, objYaw = 306.00003051758, objCoords = vec3(-630.426514, -238.437546, 38.206532)},
        {objName = 1425919976, objYaw = 306.00003051758, objCoords = vec3(-631.955383, -236.333267, 38.206532)}
    },
    doorRate = 1.0,
}
```
- The function for toggling the doors has both serverside and clientside events to ensure when you thermite hack, the doors are open for your accomplices and when it closes up for the day, it's actually locked.
```lua
local function LockCity() -- Locks Los Santos Vangelico's
    TriggerEvent('qb-doorlock:client:setState', source, Config.CityDoor, true, src, false, false) -- Clientside / Should happen everytime someone loads into the server
    TriggerEvent('qb-doorlock:client:setState', source, Config.CitySec, true, src, false, false)
    if StoreHit == 'city' or StoreHit == 'all' then -- Check if the stores have been robbed or hacked
        TriggerServerEvent('qb-doorlock:server:updateState', Config.CityDoor, true, false, false, true) -- If it's robbed, unlocks main doors for all players
        if StoreHit == 'all' then
            TriggerServerEvent('qb-doorlock:server:updateState', Config.CitySec, true, false, false, true) -- If it's hacked, unlocks all doors for all players
        end
        print('City Jewelers Locked')
    end
    CityLocked = true
end
```

## Plans
- Create item for hacking (currently just checks if your holding a phone, jl-laptop maybe?).
- Update animation for hacking.
- Add police calls.

## Store Locations

All store locations are for GigZ Jewelers' except for the base GTA one. It's a free map, link below:

- [GigZ Jewelers](https://forum.cfx.re/t/mlo-jewel-store-by-gigz/4857261/24)

## Support
I'll happily provide any help I can, preferably join my discord and ask for support. If enough people show interest, I'll create a dedicated support channel with tickets. 
- [Discord](https://discord.gg/tVA58nbBuk) 
