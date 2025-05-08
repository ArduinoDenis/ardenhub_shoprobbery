Config = {}

-- General settings
Config.UseTarget = false -- Use target system instead of markers (if available)
Config.CooldownTime = 60 -- Cooldown time between robberies (in seconds)
Config.PoliceRequired = {
    shop = 1, -- Police officers required for shop robbery
    bank = 1  -- Police officers required for bank robbery
}

-- Discord webhook for logs
Config.WebhookURL = "https://discord.com/api/webhooks/" -- Insert your Discord webhook URL

-- Blip settings
Config.Blips = {
    shop = {
        sprite = 110,
        color = 1,
        scale = 0.7,
        display = 4,
        shortRange = true,
        name = "Robbable Store"
    },
    bank = {
        sprite = 110,
        color = 1,
        scale = 0.8,
        display = 4,
        shortRange = true,
        name = "Robbable Bank"
    }
}

-- Marker settings
Config.Marker = {
    type = 0,
    size = {x = 1.0, y = 1.0, z = 1.0},
    color = {r = 255, g = 0, b = 0, a = 100},
    bobUpAndDown = false,
    faceCamera = false,
    rotate = false,
    drawDistance = 50.0
}

-- Robbable shop locations
Config.Shops = {
    {
        name = "24/7 Store - Innocence Blvd",
        coords = vector3(28.288, -1339.537, 30.497),
        heading = 0.0,
        minReward = 3000,
        maxReward = 8000,
        robberyTime = 60, -- Time in seconds to complete the robbery
        cooldown = true
    },
    {
        name = "24/7 Store - Clinton Ave",
        coords = vector3(378.176, 333.438, 104.566),
        heading = 0.0,
        minReward = 3000,
        maxReward = 8000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "24/7 Store - Palomino Fwy",
        coords = vector3(2548.883, 384.850, 109.623),
        heading = 0.0,
        minReward = 3000,
        maxReward = 8000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "24/7 Store - Senora Fwy",
        coords = vector3(1707.821, 4920.279, 43.063),
        heading = 0.0,
        minReward = 3000,
        maxReward = 8000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "24/7 Store - Great Ocean Hwy",
        coords = vector3(1734.851, 6420.838, 36.037),
        heading = 0.0,
        minReward = 3000,
        maxReward = 8000,
        robberyTime = 60,
        cooldown = true
    }
}

-- Robbable bank locations
Config.Banks = {
    {
        name = "Fleeca Bank - Legion Square",
        coords = vector3(147.04, -1044.94, 30.37),
        heading = 250.0,
        minReward = 15000,
        maxReward = 30000,
        robberyTime = 60, -- Time in seconds to complete the robbery
        cooldown = true
    },
    {
        name = "Fleeca Bank - Alta",
        coords = vector3(311.58, -283.35, 55.16),
        heading = 250.0,
        minReward = 15000,
        maxReward = 30000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "Fleeca Bank - Burton",
        coords = vector3(-353.41, -54.5, 50.04),
        heading = 250.0,
        minReward = 15000,
        maxReward = 30000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "Fleeca Bank - Rockford Hills",
        coords = vector3(-1211.43, -335.69, 38.78),
        heading = 296.0,
        minReward = 15000,
        maxReward = 30000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "Fleeca Bank - Highway",
        coords = vector3(-2957.66, 481.45, 16.7),
        heading = 358.0,
        minReward = 15000,
        maxReward = 30000,
        robberyTime = 60,
        cooldown = true
    },
    {
        name = "Central Bank",
        coords = vector3(253.25, 228.44, 102.68),
        heading = 70.0,
        minReward = 25000,
        maxReward = 50000,
        robberyTime = 60,
        cooldown = true
    }
}

-- Notifications
Config.Notifications = {
    ['start_robbery'] = 'You have started a robbery! Complete the process in %s seconds',
    ['cancel_robbery'] = 'Robbery cancelled!',
    ['robbery_complete'] = 'Robbery completed! You received $%s',
    ['robbery_progress'] = 'Robbery in progress: %s%%',
    ['police_required'] = 'Not enough police officers on duty (%s required)',
    ['cooldown_active'] = 'This location was recently robbed, try again later',
    ['robbery_already_active'] = 'There is already a robbery in progress'
}