
Config.DoorList['jewelery-citymain'] = {
    doorType = 'double',
    locked = true,
    cantUnlock = true,
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 9467943, objYaw = 306.00003051758, objCoords = vec3(-630.426514, -238.437546, 38.206532)},
        {objName = 1425919976, objYaw = 306.00003051758, objCoords = vec3(-631.955383, -236.333267, 38.206532)}
    },
    doorRate = 1.0,
}

Config.DoorList['jewelery-citysec'] = {
    objYaw = 36.000022888184,
    doorRate = 1.0,
    locked = true,
    fixText = false,
    pickable = true,
    authorizedJobs = { ['police'] = 0 },
    items = { ['lockpick'] = 1, ['advancedlockpick'] = 1 },
    objCoords = vec3(-629.133850, -230.151703, 38.206585),
    distance = 1.5,
    doorType = 'door',
    objName = 1335309163,
}

Config.DoorList['jewelery-grapemain'] = {
    doorType = 'double',
    locked = true,
    cantUnlock = true,
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 9467943, objYaw = 98.17839050293, objCoords = vec3(1653.285522, 4884.148438, 42.309845)},
        {objName = 1425919976, objYaw = 98.17839050293, objCoords = vec3(1653.655518, 4881.573730, 42.309845)}
    },
    doorRate = 1.0,
}

Config.DoorList['jewelery-grapesec'] = {
    pickable = true,
    objCoords = vec3(1648.274902, 4877.423340, 42.309898),
    objName = 1335309163,
    doorRate = 1.0,
    distance = 1,
    authorizedJobs = { ['police'] = 0 },
    items = { ['lockpick'] = 1, ['advancedlockpick'] = 1 },
    doorType = 'door',
    objYaw = 188.17839050293,
    fixText = false,
    doorLabel = 'sec',
    locked = true,
}

Config.DoorList['jewelery-palmain'] = {
    doorType = 'double',
    locked = true,
    cantUnlock = true,
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 1425919976, objYaw = 314.90930175781, objCoords = vec3(-383.837921, 6044.059082, 31.658920)},
        {objName = 9467943, objYaw = 314.90930175781, objCoords = vec3(-382.001617, 6042.216797, 31.658920)}
    },
    doorRate = 1.0,
}

Config.DoorList['jewelery-palsec'] = {
    doorType = 'door',
    locked = true,
    doorRate = 1.0,
    pickable = true,
    distance = 1.5,
    objYaw = 44.909275054932,
    fixText = false,
    authorizedJobs = { ['police'] = 0 },
    items = { ['lockpick'] = 1, ['advancedlockpick'] = 1 },
    objCoords = vec3(-382.007721, 6050.603027, 31.658974),
    objName = 1335309163,
}