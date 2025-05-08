local ESX = exports['es_extended']:getSharedObject()

local robbedLocations = {}

-- Function to send logs to Discord
local function SendDiscordLog(message, color)
    if Config.WebhookURL == "YOUR_WEBHOOK_URL_HERE" then
        return -- Webhook not configured
    end
    
    local embed = {
        {
            ["color"] = color or 16711680, -- Default red
            ["title"] = "Robbery System",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "ArdenHub Shop Robbery | " .. os.date("%d/%m/%Y %H:%M:%S")
            }
        }
    }
    
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Check if player can rob
ESX.RegisterServerCallback('ardenhub_shoprobbery:canRob', function(source, cb, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cops = 0
    
    -- Count online police officers
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'sheriff' then
            cops = cops + 1
        end
    end
    
    -- Check if there are enough police officers
    if cops < Config.PoliceRequired[type] then
        cb(false, string.format(Config.Notifications['police_required'], Config.PoliceRequired[type]))
        return
    end
    
    cb(true)
end)

-- Event to notify police
RegisterServerEvent('ardenhub_shoprobbery:notifyPolice')
AddEventHandler('ardenhub_shoprobbery:notifyPolice', function(location, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Discord log
    SendDiscordLog(GetPlayerName(source) .. " has started a robbery at " .. location.name, 16776960) -- Yellow color
    
    -- Notify all police officers
    TriggerClientEvent('ardenhub_shoprobbery:policeAlert', -1, location, type)
end)

-- Event to complete robbery
RegisterServerEvent('ardenhub_shoprobbery:finishRobbery')
AddEventHandler('ardenhub_shoprobbery:finishRobbery', function(location)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Calculate reward
    local reward = math.random(location.minReward, location.maxReward)
    
    -- Add black_money to player
    xPlayer.addAccountMoney('black_money', reward)
    
    -- Set cooldown
    if location.cooldown then
        robbedLocations[location.name] = os.time() + Config.CooldownTime
    end
    
    -- Notify player
    TriggerClientEvent('ardenhub_shoprobbery:robberyComplete', source, reward)
    
    -- Discord log
    SendDiscordLog(GetPlayerName(source) .. " has completed a robbery at " .. location.name .. " and received $" .. reward .. " in dirty money", 65280) -- Green color
end)

-- Event to cancel robbery
RegisterServerEvent('ardenhub_shoprobbery:cancelRobbery')
AddEventHandler('ardenhub_shoprobbery:cancelRobbery', function(location)
    -- Discord log
    SendDiscordLog(GetPlayerName(source) .. " has cancelled a robbery at " .. location.name, 16711680) -- Red color
end)

-- Check cooldowns
CreateThread(function()
    while true do
        Wait(60000) -- Check every minute
        
        local currentTime = os.time()
        for location, time in pairs(robbedLocations) do
            if currentTime > time then
                robbedLocations[location] = nil
            end
        end
    end
end)