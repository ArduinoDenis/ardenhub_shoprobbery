local ESX = exports['es_extended']:getSharedObject()
local robberyActive = false
local currentRobbery = nil
local robberyBlips = {}

-- Function to create blip
local function CreateRobberyBlip(coords, type)
    local blipConfig = Config.Blips[type]
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    
    SetBlipSprite(blip, blipConfig.sprite)
    SetBlipColour(blip, blipConfig.color)
    SetBlipScale(blip, blipConfig.scale)
    SetBlipAsShortRange(blip, blipConfig.shortRange)
    SetBlipDisplay(blip, blipConfig.display)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipConfig.name)
    EndTextCommandSetBlipName(blip)
    
    return blip
end

-- Create blips for all robbable locations
local function CreateAllBlips()
    -- Create blips for shops
    for i, shop in ipairs(Config.Shops) do
        local blip = CreateRobberyBlip(shop.coords, "shop")
        table.insert(robberyBlips, blip)
    end
    
    -- Create blips for banks
    for i, bank in ipairs(Config.Banks) do
        local blip = CreateRobberyBlip(bank.coords, "bank")
        table.insert(robberyBlips, blip)
    end
end

-- Function to show notification
local function ShowNotification(message)
    lib.notify({
        id = 'system_robbery',
        title = 'Robbery System',
        description = message,
        showDuration = false,
        position = 'center-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'fa-solid fa-sack-dollar',
        iconColor = '#C53030'
    })
end

-- Function to start robbery
local function StartRobbery(location, type)
    if robberyActive then
        ShowNotification(Config.Notifications['robbery_already_active'])
        return
    end
    
    ESX.TriggerServerCallback('ardenhub_shoprobbery:canRob', function(canRob, reason)
        if canRob then
            robberyActive = true
            currentRobbery = location
            
            -- Notify robbery start
            ShowNotification(string.format(Config.Notifications['start_robbery'], location.robberyTime))
            
            -- Notify police
            TriggerServerEvent('ardenhub_shoprobbery:notifyPolice', location, type)
            
            -- Start robbery process
            local success = lib.progressBar({
                duration = location.robberyTime * 1000,
                label = 'Robbery in progress...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true
                },
                anim = {
                    dict = 'anim@heists@ornate_bank@grab_cash',
                    clip = 'grab'
                },
            })
            
            -- Check if progressBar was completed successfully
            if success then
                -- Robbery completed successfully
                TriggerServerEvent('ardenhub_shoprobbery:finishRobbery', location)
            else
                -- Robbery cancelled by user
                ShowNotification(Config.Notifications['cancel_robbery'])
                TriggerServerEvent('ardenhub_shoprobbery:cancelRobbery', location)
            end
            
            -- Reset robbery state
            robberyActive = false
            currentRobbery = nil
        else
            ShowNotification(reason)
        end
    end, type)
end

-- Create interaction points for shops
local function SetupShopPoints()
    for i, shop in ipairs(Config.Shops) do
        if Config.UseTarget then
            -- Use target system if enabled
            exports.ox_target:addBoxZone({
                coords = shop.coords,
                size = vector3(1.5, 1.5, 2.0),
                rotation = shop.heading,
                debug = false,
                options = {
                    {
                        name = 'shop_robbery_' .. i,
                        icon = 'fas fa-mask',
                        label = 'Rob the store',
                        onSelect = function()
                            StartRobbery(shop, 'shop')
                        end,
                        canInteract = function()
                            return not robberyActive
                        end
                    }
                }
            })
        else
            -- Create interaction point with lib.points
            lib.points.new({
                coords = shop.coords,
                distance = 3.5,
                onEnter = function()
                    lib.showTextUI('[E] - Rob the store', {
                        position = "right-center",
                        icon = 'fa-solid fa-sack-dollar',
                        style = {
                            borderRadius = 0,
                            backgroundColor = '#48BB78',
                            color = 'white'
                        }
                    })
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                nearby = function()
                    if IsControlJustReleased(0, 38) then -- E key
                        StartRobbery(shop, 'shop')
                    end
                    
                    -- Draw marker
                    DrawMarker(
                        Config.Marker.type,
                        shop.coords.x, shop.coords.y, shop.coords.z - 1.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z,
                        Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a,
                        Config.Marker.bobUpAndDown, Config.Marker.faceCamera, 2, Config.Marker.rotate, nil, nil, false
                    )
                end
            })
        end
    end
end

-- Create interaction points for banks
local function SetupBankPoints()
    for i, bank in ipairs(Config.Banks) do
        if Config.UseTarget then
            -- Use target system if enabled
            exports.ox_target:addBoxZone({
                coords = bank.coords,
                size = vector3(1.5, 1.5, 2.0),
                rotation = bank.heading,
                debug = false,
                options = {
                    {
                        name = 'bank_robbery_' .. i,
                        icon = 'fas fa-mask',
                        label = 'Rob the bank',
                        onSelect = function()
                            StartRobbery(bank, 'bank')
                        end,
                        canInteract = function()
                            return not robberyActive
                        end
                    }
                }
            })
        else
            -- Create interaction point with lib.points
            lib.points.new({
                coords = bank.coords,
                distance = 3.5,
                onEnter = function()
                    lib.showTextUI('[E] - Rob the bank', {
                        position = "right-center",
                        icon = 'fa-solid fa-sack-dollar',
                        style = {
                            borderRadius = 0,
                            backgroundColor = '#48BB78',
                            color = 'white'
                        }
                    })
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                nearby = function()
                    if IsControlJustReleased(0, 38) then -- E key
                        StartRobbery(bank, 'bank')
                    end
                    
                    -- Draw marker
                    DrawMarker(
                        Config.Marker.type,
                        bank.coords.x, bank.coords.y, bank.coords.z - 1.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z,
                        Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a,
                        Config.Marker.bobUpAndDown, Config.Marker.faceCamera, 2, Config.Marker.rotate, nil, nil, false
                    )
                end
            })
        end
    end
end

-- Initialization
CreateThread(function()
    -- Wait for player to load
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    
    -- Create map blips
    CreateAllBlips()
    
    -- Setup interaction points
    SetupShopPoints()
    SetupBankPoints()
end)

-- Event handling
RegisterNetEvent('ardenhub_shoprobbery:robberyComplete')
AddEventHandler('ardenhub_shoprobbery:robberyComplete', function(reward)
    ShowNotification(string.format(Config.Notifications['robbery_complete'], reward))
end)

-- Event for police notification
RegisterNetEvent('ardenhub_shoprobbery:policeAlert')
AddEventHandler('ardenhub_shoprobbery:policeAlert', function(location, type)
    local playerJob = ESX.GetPlayerData().job
    
    if playerJob and playerJob.name == 'police' then
        local locationType = type == 'shop' and 'store' or 'bank'
        lib.notify({
            id = 'system_robbery_police',
            title = 'Police Dispatch',
            description = 'Robbery in progress at ' .. location.name,
            showDuration = false,
            position = 'center-right',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            icon = 'fa-solid fa-handcuffs',
            iconColor = '#C53030'
        })
        
        -- Create temporary blip on map
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 161) -- Alarm sprite
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 3) -- Yellow color
        
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Robbery in progress: ' .. location.name)
        EndTextCommandSetBlipName(blip)
        
        -- Remove blip after 60 seconds
        SetTimeout(60000, function()
            RemoveBlip(blip)
        end)
    end
end)