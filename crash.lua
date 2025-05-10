local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- Configuration
local CONFIG = {
    TAG_SIZE = UDim2.new(0, 120, 0, 40),
    TAG_OFFSET = Vector3.new(0, 2.4, 0),
    MAX_DISTANCE = 1000000,
    SCALE_DISTANCE = 150,
    WHITELIST_UPDATE_INTERVAL = 5,
    MAX_RETRY_ATTEMPTS = 10,
    RETRY_DELAY = 3,
    TELEPORT_DISTANCE = 5,
    TELEPORT_HEIGHT = 0.5
}

local RankColors = {
    ["AK OWNER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(255, 215, 0)
    },
    ["AK SCRIPTER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(138, 43, 226)
    },
    ["AK SUPPORTER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(0, 191, 255)
    },
    ["AK STAFF"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(50, 205, 50)
    },
    ["AK ADVERTISER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(255, 69, 0)
    },
    ["AK TRIAL"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(169, 169, 169)
    },
    ["AK USER"] = {
        primary = Color3.fromRGB(20, 20, 20),
        accent = Color3.fromRGB(65, 105, 225)
    }
}

-- Whitelist cache system
local WhitelistCache = {
    data = nil,
    lastUpdate = 0,
    updateInterval = CONFIG.WHITELIST_UPDATE_INTERVAL
}

local function createNotificationUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "TagNotification"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 140)
    frame.Position = UDim2.new(0.5, -140, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = Lighting

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 16
    title.Text = "Tag Visibility Settings"
    title.Parent = frame

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(0.9, 0, 0, 40)
    message.Position = UDim2.new(0.05, 0, 0.35, 0)
    message.BackgroundTransparency = 1
    message.Font = Enum.Font.Gotham
    message.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    message.TextSize = 14
    message.TextWrapped = true
    message.Text = "Would you like to display your rank tag above your character?"
    message.Parent = frame

    local function createButton(text, position, color)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.35, 0, 0, 30)
        button.Position = position
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 14
        button.Text = text
        button.AutoButtonColor = true
        button.Parent = frame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        return button
    end

    local yesButton = createButton("Yes", UDim2.new(0.1, 0, 0.7, 0), Color3.fromRGB(46, 204, 113))
    local noButton = createButton("No", UDim2.new(0.55, 0, 0.7, 0), Color3.fromRGB(231, 76, 60))

    frame.BackgroundTransparency = 1
    title.TextTransparency = 1
    message.TextTransparency = 1
    yesButton.BackgroundTransparency = 1
    noButton.BackgroundTransparency = 1
    yesButton.TextTransparency = 1
    noButton.TextTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(message, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(yesButton, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(noButton, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(yesButton, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(noButton, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    return gui, yesButton, noButton, blur
end

local function fetchWhitelist()
    local currentTime = os.time()
    if WhitelistCache.data and (currentTime - WhitelistCache.lastUpdate) < WhitelistCache.updateInterval then
        return WhitelistCache.data
    end

    local success, result = pcall(function()
        local response = game:HttpGet("https://raw.githubusercontent.com/AKadminlol/AK-ADMIN/refs/heads/main/AK%20ADMIN.json")
        return HttpService:JSONDecode(response)
    end)

    if success and result then
        WhitelistCache.data = result
        WhitelistCache.lastUpdate = currentTime
        return result
    end
    return nil
end

local function isWhitelisted(player)
    local whitelistData = fetchWhitelist()
    return whitelistData and whitelistData.whitelisted and table.find(whitelistData.whitelisted, player.Name) ~= nil
end

local function teleportToPlayer(targetPlayer)
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    local targetCharacter = targetPlayer.Character
    
    if not (character and targetCharacter) then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    
    if not (humanoid and hrp and targetHRP) then return end
    
    local targetCFrame = targetHRP.CFrame
    local teleportPosition = targetCFrame.Position - (targetCFrame.LookVector * CONFIG.TELEPORT_DISTANCE)
    teleportPosition = teleportPosition + Vector3.new(0, CONFIG.TELEPORT_HEIGHT, 0)
    
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(1, 1, 1)
    effect.CFrame = hrp.CFrame
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.5
    effect.Shape = Enum.PartType.Ball
    effect.Material = Enum.Material.Neon
    effect.Color = Color3.fromRGB(255, 255, 255)
    effect.Parent = workspace
    
    TweenService:Create(effect, TweenInfo.new(0.5), {
        Size = Vector3.new(0, 0, 0),
        Transparency = 1
    }):Play()
    
    hrp.CFrame = CFrame.new(teleportPosition, targetHRP.Position)
    
    local arrivalEffect = effect:Clone()
    arrivalEffect.CFrame = CFrame.new(teleportPosition)
    arrivalEffect.Parent = workspace
    
    TweenService:Create(arrivalEffect, TweenInfo.new(0.5), {
        Size = Vector3.new(0, 0, 0),
        Transparency = 1
    }):Play()
    
    game:GetService("Debris"):AddItem(effect, 0.5)
    game:GetService("Debris"):AddItem(arrivalEffect, 0.5)
end

local function attachTagToHead(character, player, rankText)
    local head = character:WaitForChild("Head", 5)
    if not head then return end
    
    local existingTag = head:FindFirstChild("RankTag")
    if existingTag then existingTag:Destroy() end
    
    local tag = Instance.new("BillboardGui")
    tag.Name = "RankTag"
    tag.Size = CONFIG.TAG_SIZE
    tag.StudsOffset = CONFIG.TAG_OFFSET
    tag.AlwaysOnTop = true
    tag.MaxDistance = CONFIG.MAX_DISTANCE
    tag.Parent = head

    local container = Instance.new("TextButton")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 0.2
    container.BackgroundColor3 = RankColors[rankText].primary
    container.BorderSizePixel = 0
    container.Text = ""
    container.Parent = tag

    -- Add crown for AK OWNER
    if rankText == "AK OWNER" then
        local crown = Instance.new("TextLabel")
        crown.Size = UDim2.new(1, 0, 0.5, 0)
        crown.Position = UDim2.new(0, 0, -0.4, 0)
        crown.BackgroundTransparency = 1
        crown.Text = "👑"
        crown.TextSize = 20
        crown.TextColor3 = RankColors[rankText].accent
        crown.Font = Enum.Font.GothamBold
        crown.Parent = container
    end
    
    container.MouseButton1Click:Connect(function()
        if player ~= Players.LocalPlayer then
            teleportToPlayer(player)
        end
    end)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = container

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0.7, 0, 0, 2.5)
    accent.Position = UDim2.new(0.5, 0, 0, 0)
    accent.BackgroundColor3 = RankColors[rankText].accent
    accent.BorderSizePixel = 0
    accent.Parent = container

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = accent

    accent.AnchorPoint = Vector2.new(0.5, 0.5)
    accent.Position = UDim2.new(0.5, 0, 0, 0)

    -- Add rank text
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Size = UDim2.new(1, 0, 1, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = rankText
    rankLabel.TextColor3 = RankColors[rankText].accent
    rankLabel.TextSize = 14
    rankLabel.Font = Enum.Font.GothamBold
    rankLabel.Parent = container

    local tweenInfo = TweenInfo.new(
        0.7,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    )

    local tween = TweenService:Create(accent, tweenInfo, {Position = UDim2.new(0.5, 0, 1, 0)
    })
    tween:Play()

    local rankLabel = Instance.new("TextLabel")
    rankLabel.Size = UDim2.new(1, 0, 0.6, 0)
    rankLabel.Position = UDim2.new(0, 0, 0.1, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = rankText
    rankLabel.TextColor3 = Color3.new(1, 1, 1)
    rankLabel.TextSize = 17
    rankLabel.Font = Enum.Font.SourceSansBold
    rankLabel.Parent = container

    local maxDistance = 50
    local minSize = 8
    local maxSize = 17

    game:GetService("RunService").Heartbeat:Connect(function()
        local localPlayer = game.Players.LocalPlayer
        local localPlayerHead = localPlayer.Character and localPlayer.Character:WaitForChild("Head")
        
        if localPlayer and localPlayerHead and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHumanoidRootPart then
                local distance = (localPlayerHead.Position - targetHumanoidRootPart.Position).Magnitude
                local newSize = math.clamp(maxSize - ((distance / maxDistance) * (maxSize - minSize)), minSize, maxSize)
                rankLabel.TextSize = newSize
            end
        end
    end)

    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, 0, 0.4, 0)
    userLabel.Position = UDim2.new(0, 0, 0.6, 0)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@" .. player.Name
    userLabel.TextColor3 = RankColors[rankText].accent
    userLabel.TextSize = 8
    userLabel.Font = Enum.Font.GothamBold
    userLabel.Parent = container

    tag.Parent = head

    local playerHead = player.Character:WaitForChild("Head")
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")

    game:GetService("RunService").Heartbeat:Connect(function()
        local localPlayer = game.Players.LocalPlayer
        local localPlayerHead = localPlayer.Character and localPlayer.Character:WaitForChild("Head")
        
        if localPlayer and localPlayerHead and player.Character and playerHead and humanoidRootPart then
            local distance = (localPlayerHead.Position - humanoidRootPart.Position).Magnitude
            if distance > maxDistance then
                userLabel.Visible = false
            else
                userLabel.Visible = true
            end
        end
    end)

    local connection = RunService.Heartbeat:Connect(function()
        if not (character and character:FindFirstChild("Head") and Players.LocalPlayer.Character) then return end
        
        local localCharacter = Players.LocalPlayer.Character
        local localHead = localCharacter:FindFirstChild("Head")
        if not localHead then return end
        
        local distance = (head.Position - localHead.Position).Magnitude
        local scale = math.clamp(1 - (distance / CONFIG.SCALE_DISTANCE), 0.5, 2)
        
        tag.Size = UDim2.new(0, CONFIG.TAG_SIZE.X.Offset * scale, 0, CONFIG.TAG_SIZE.Y.Offset * scale)
    end)

    tag.AncestryChanged:Connect(function(_, parent)
        if not parent then
            connection:Disconnect()
        end
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.5), {
            BackgroundTransparency = 0
        }):Play()
    end)

    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2
        }):Play()
    end)
end

local function createTag(player, rankText, showPrompt)
    if showPrompt and player == Players.LocalPlayer then
        local gui, yesButton, noButton, blur = createNotificationUI()
        gui.Parent = player:WaitForChild("PlayerGui")
        
        local function cleanup()
            TweenService:Create(gui.Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            blur:Destroy()
            task.wait(0.5)
            gui:Destroy()
        end
        
        yesButton.MouseButton1Click:Connect(function()
            cleanup()
            if player.Character then
                attachTagToHead(player.Character, player, rankText)
            end
            player.CharacterAdded:Connect(function(character)
                attachTagToHead(character, player, rankText)
            end)
        end)
        
        noButton.MouseButton1Click:Connect(function()
            cleanup()
        end)
    else
        if player.Character then
            attachTagToHead(player.Character, player, rankText)
        end
        player.CharacterAdded:Connect(function(character)
            attachTagToHead(character, player, rankText)
        end)
    end
end

local Advertisers = {"Vlafz195", "6736_45", "goekaycool", "goekayball", "goekayball2"}
local FreeTrial = {}
local Scripters = {"GYATT_DAMN1", "328ml", "29Kyooo", "BloxiAstra", "ImOn_ValveIndex"}
local Owners = {"Xeni_he07", "AliKhammas1234", "AliKhammas", "I_LOVEYOU12210", "AK_ADMEN1", "YournothimbuddyXD", "AK_ADMEN2"}
local Supporter = {"Robloxian74630436"}
local AKStaff = {"goekaycool"}

local function applyPlayerTag(player)
    local function attemptTagApplication()
        local showPrompt = player == Players.LocalPlayer
        if table.find(Owners, player.Name) then
            createTag(player, "AK OWNER", showPrompt)
        elseif table.find(Scripters, player.Name) then
            createTag(player, "AK SCRIPTER", showPrompt)
        elseif table.find(Supporter, player.Name) then
            createTag(player, "AK SUPPORTER", showPrompt)
        elseif table.find(AKStaff, player.Name) then
            createTag(player, "AK STAFF", showPrompt)
        elseif table.find(Advertisers, player.Name) then
            createTag(player, "AK ADVERTISER", showPrompt)
        elseif table.find(FreeTrial, player.Name) then
            createTag(player, "AK TRIAL", showPrompt)
        elseif isWhitelisted(player) then
            createTag(player, "AK USER", showPrompt)
        end
    end
    
    local attempts = 0
    local function retryTagApplication()
        attempts = attempts + 1
        local success = pcall(attemptTagApplication)
        
        if not success and attempts < CONFIG.MAX_RETRY_ATTEMPTS then
            task.wait(CONFIG.RETRY_DELAY)
            retryTagApplication()
        end
    end
    
    retryTagApplication()
end

for _, player in pairs(Players:GetPlayers()) do
    task.spawn(function()
        applyPlayerTag(player)
    end)
end

Players.PlayerAdded:Connect(function(player)
    task.spawn(function()
        applyPlayerTag(player)
    end)
end)

local success, error = pcall(function()
    task.spawn(function()
        while true do
            fetchWhitelist()
            task.wait(CONFIG.WHITELIST_UPDATE_INTERVAL)
        end
    end)
end)

if not success then
    warn("[Tag System] Initialization Error:", error)
    
    task.wait(5)
    for _, player in pairs(Players:GetPlayers()) do
        task.spawn(function()
            applyPlayerTag(player)
        end)
    end
end

return {
    refreshTags = function()
        for _, player in pairs(Players:GetPlayers()) do
            task.spawn(function()
                applyPlayerTag(player)
            end)
        end
    end,
    
    updateWhitelist = function()
        WhitelistCache.data = nil
        WhitelistCache.lastUpdate = 0
        return fetchWhitelist()
    end,
    
    forceTag = function(player, rankType)
        if RankColors[rankType] then
            createTag(player, rankType, player == Players.LocalPlayer)
            return true
        end
        return false
    end,
    
    teleportTo = function(player)
        if player ~= Players.LocalPlayer then
            teleportToPlayer(player)
        end
    end
}
