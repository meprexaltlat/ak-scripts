local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Table to store players using AK
local AKUsers = {}

-- Commands that don't need "all" appended (added ".hi" here)
local defaultAllCommands = {
    ".kill", ".jump", ".spin", ".unspin", ".speed",
    ".freeze", ".unfreeze", ".follow", ".unfollow",
    ".fling", ".fling2", ".unorbit", ".trip", ".re", ".hi", ".privland", ".privland", ".invert", ".js", ".js2", ".knock", ".scare", ".privland", ".warn", ".suspend", ".spam", ".rejoin"
}

-- Commands that require a target
local requireTargetCommands = {
    ".kick", ".bring"
}

-- Special commands
local specialCommands = {
    ".chat", ".spin", ".speed"
}

-- Variables to store GUI elements
local selectedPlayer = "all"
local gui = nil 
local playerList = nil

-- Table to keep track of active notifications for stacking
local activeNotifications = {}

-- Remove spaces from a string
local function modifyString(randomText)
    local modified = ""
    for char in randomText:gmatch(".") do
        if char ~= " " then
            modified = modified .. char
        end
    end
    return modified
end

-- Helper function to create a strong, larger ripple effect.
local function createRippleEffect(button, x, y, multiplier)
    multiplier = multiplier or 2.5
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.ZIndex = (button.ZIndex or 1) + 1
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    ripple.Parent = button
    local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * multiplier
    local tween = TweenService:Create(ripple, TweenInfo.new(0.5), {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Angepasste Funktion für Dragging (spezifisch für PC/Maus):
local function makeDraggable(gui, handle)
    local dragging = false
    local dragStartPos = nil
    local startPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartPos = input.Position
            startPos = gui.AbsolutePosition
        end
    end)

    -- Auch wenn sich die Maus außerhalb des GUIs befindet, sollte das Dragging fortgesetzt werden
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            -- Wir setzen hier die neue Position direkt; gui.Position wird dabei relativ zum ScreenGui gesetzt.
            local parentGui = gui.Parent
            if parentGui then
                -- Berechne die neue UDim2 Position, indem Offset addiert wird (ohne Skalierung zu ändern)
                local newX = startPos.X + delta.X
                local newY = startPos.Y + delta.Y
                -- Die Position des ScreenGuis lässt sich über AbsolutePosition nicht direkt verändern,
                -- daher stellen wir gui.Position basierend auf Pixeloffsets ein.
                gui.Position = UDim2.new(0, newX, 0, newY)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Funktion, um alle aktiven Notifications bei Änderungen neu anzuordnen
local function updateNotificationPositions()
    for i, notif in ipairs(activeNotifications) do
        local targetY = 10 + ((i-1) * (36 + 10)) -- 36 = Höhe der Notification, 10px Abstand
        TweenService:Create(notif, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Position = UDim2.new(0, 10, 0, targetY)
        }):Play()
    end
end

-- Funktion, um Notification mit Stapelung und Animation anzuzeigen
local function showNotification(text)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, -20, 0, 36)
    local targetY = 10 + (#activeNotifications * (36 + 10))
    notification.Position = UDim2.new(0, 10, 0, -40)  -- Start außerhalb des Bildschirms (oben)
    notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    notification.BorderSizePixel = 0
    notification.ZIndex = 10

    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 6)
    notifCorner.Parent = notification

    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = Color3.fromRGB(80, 80, 80)
    notifStroke.Thickness = 1
    notifStroke.Parent = notification

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 8, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://9072944922" -- Info icon
    icon.ZIndex = 11
    icon.Parent = notification

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -36, 1, 0)
    label.Position = UDim2.new(0, 34, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 11
    label.Parent = notification

    notification.Parent = gui.MainFrame

    table.insert(activeNotifications, notification)

    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 10, 0, targetY)
    })
    tweenIn:Play()

    task.delay(2, function()
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 10, 0, -40),
            BackgroundTransparency = 1
        })
        tweenOut:Play()

        TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(icon, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        TweenService:Create(notifStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()

        tweenOut.Completed:Connect(function()
            notification:Destroy()
            for i, notif in ipairs(activeNotifications) do
                if notif == notification then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            updateNotificationPositions()
        end)
    end)
end

-- Funktion zum Senden eines Chat-Commands
local function sendCommand(command, target, extraParam)
    local finalCommand = ""
    if command == ".bring" and target == "all" then
        finalCommand = ".bring"
    elseif table.find(defaultAllCommands, command) and target == "all" then
        finalCommand = command
    elseif command == ".chat" then
        finalCommand = string.format("%s %s %s", command, target, extraParam)
    elseif command == ".kick" and extraParam then
        finalCommand = string.format("%s %s %s", command, target, extraParam)
    elseif table.find(specialCommands, command) and extraParam then
        finalCommand = string.format("%s %s %s", command, target, extraParam)
    else
        finalCommand = string.format("%s %s", command, target)
    end

    Players:Chat(finalCommand)
    showNotification("Command sent: " .. finalCommand)
end

-- Funktion zum Erstellen eines Spieler-Buttons mit Ripple-Effekt
local function createPlayerButton(player)
    local button = Instance.new("Frame")
    button.Size = UDim2.new(1, -10, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Name = player.Name

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 70)
    stroke.Thickness = 1
    stroke.Parent = button

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 28, 0, 28)
    avatar.Position = UDim2.new(0, 4, 0, 4)
    avatar.BackgroundColor3 = Color3.new(1, 1, 1)
    avatar.BackgroundTransparency = 1

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Color3.fromRGB(100, 100, 100)
    avatarStroke.Thickness = 1
    avatarStroke.Parent = avatar

    local userId = player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    avatar.Image = content
    avatar.Parent = button

    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -38, 0, 16)
    displayName.Position = UDim2.new(0, 36, 0, 2)
    displayName.BackgroundTransparency = 1
    displayName.Text = player.DisplayName
    displayName.TextColor3 = Color3.new(1, 1, 1)
    displayName.TextSize = 12
    displayName.Font = Enum.Font.GothamBold
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.Parent = button

    local username = Instance.new("TextLabel")
    username.Size = UDim2.new(1, -38, 0, 14)
    username.Position = UDim2.new(0, 36, 0, 18)
    username.BackgroundTransparency = 1
    username.Text = "@" .. player.Name
    username.TextColor3 = Color3.fromRGB(180, 180, 180)
    username.TextSize = 10
    username.Font = Enum.Font.Gotham
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = button

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(1, -12, 0, 14)
    statusDot.BackgroundColor3 = Color3.fromRGB(80, 220, 100)
    statusDot.Parent = button

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusDot

    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = button

    clickButton.MouseButton1Down:Connect(function(x, y)
        createRippleEffect(button, x, y)
    end)

    clickButton.MouseButton1Click:Connect(function()
        selectedPlayer = player.Name
        for _, btn in ipairs(playerList:GetChildren()) do
            if btn:IsA("Frame") and btn:FindFirstChildOfClass("UIStroke") then
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(70, 70, 70)
            end
        end

        local allPlayersButton = gui.MainFrame:FindFirstChild("ContentFrame"):FindFirstChild("AllButton")
        if allPlayersButton then
            allPlayersButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            allPlayersButton:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(70, 70, 70)
        end

        button.BackgroundColor3 = Color3.fromRGB(0, 110, 240)
        button:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 140, 255)
        showNotification("Selected: " .. player.Name)
    end)

    clickButton.MouseEnter:Connect(function()
        if selectedPlayer ~= player.Name then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            }):Play()
        end
    end)

    clickButton.MouseLeave:Connect(function()
        if selectedPlayer ~= player.Name then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            }):Play()
        end
    end)

    button.Parent = playerList
    return button
end

-- Funktion, um das erweiterte GUI zu erstellen
local function createAKListGUI()
    local newGui = Instance.new("ScreenGui")
    newGui.Name = "AKListGUI"
    newGui.ResetOnSpawn = false

    local mainWidth, mainHeight = 320, 430
    local mainPosX, mainPosY = -mainWidth/2, -mainHeight/2

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, mainWidth, 0, mainHeight)
    mainFrame.Position = UDim2.new(0.5, mainPosX, 0.5, mainPosY)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = newGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = mainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    local cornerFix = Instance.new("Frame")
    cornerFix.Size = UDim2.new(1, 0, 0, 10)
    cornerFix.Position = UDim2.new(0, 0, 1, -10)
    cornerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    cornerFix.BorderSizePixel = 0
    cornerFix.Parent = titleBar

    makeDraggable(mainFrame, titleBar)

    local logoIcon = Instance.new("ImageLabel")
    logoIcon.Size = UDim2.new(0, 20, 0, 20)
    logoIcon.Position = UDim2.new(0, 8, 0, 10)
    logoIcon.BackgroundTransparency = 1
    logoIcon.Image = "rbxassetid://10889394904"
    logoIcon.ImageColor3 = Color3.fromRGB(0, 160, 255)
    logoIcon.Parent = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -90, 1, 0)
    titleText.Position = UDim2.new(0, 36, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "OWNER CMDS PANEL"
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local textGradient = Instance.new("UIGradient")
    textGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    textGradient.Parent = titleText

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -34, 0, 8)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton

    closeButton.MouseButton1Down:Connect(function(x, y)
        createRippleEffect(closeButton, x, y)
    end)

    closeButton.MouseButton1Click:Connect(function()
        local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
            Position = UDim2.new(
                mainFrame.Position.X.Scale,
                mainFrame.Position.X.Offset,
                mainFrame.Position.Y.Scale,
                mainFrame.Position.Y.Offset + 10
            )
        })
        fadeTween:Play()
        for _, child in pairs(mainFrame:GetDescendants()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("ImageButton") then
                if child.BackgroundTransparency < 1 then
                    TweenService:Create(child, TweenInfo.new(0.3), {
                        BackgroundTransparency = 1
                    }):Play()
                end

                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.3), {
                        TextTransparency = 1
                    }):Play()
                end

                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    TweenService:Create(child, TweenInfo.new(0.3), {
                        ImageTransparency = 1
                    }):Play()
                end

                if child:FindFirstChildOfClass("UIStroke") then
                    TweenService:Create(child:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.3), {
                        Transparency = 1
                    }):Play()
                end
            end
        end

        task.delay(0.3, function()
            newGui:Destroy()
        end)
    end)

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.Position = UDim2.new(1, -64, 0, 8)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
    minimizeButton.Text = "–"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 18
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Parent = titleBar

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minimizeButton

    minimizeButton.MouseButton1Down:Connect(function(x, y)
        createRippleEffect(minimizeButton, x, y)
    end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -50)
    contentFrame.Position = UDim2.new(0, 10, 0, 45)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentFrame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
    })
    gradient.Rotation = 90
    gradient.Parent = contentFrame

    local allButton = Instance.new("Frame")
    allButton.Name = "AllButton"
    allButton.Size = UDim2.new(1, -14, 0, 32)
    allButton.Position = UDim2.new(0, 7, 0, 7)
    allButton.BackgroundColor3 = Color3.fromRGB(0, 110, 240)
    allButton.Parent = contentFrame

    local allCorner = Instance.new("UICorner")
    allCorner.CornerRadius = UDim.new(0, 6)
    allCorner.Parent = allButton

    local allStroke = Instance.new("UIStroke")
    allStroke.Color = Color3.fromRGB(0, 140, 255)
    allStroke.Thickness = 1
    allStroke.Parent = allButton

    local globeIcon = Instance.new("ImageLabel")
    globeIcon.Size = UDim2.new(0, 20, 0, 20)
    globeIcon.Position = UDim2.new(0, 5, 0, 6)
    globeIcon.BackgroundTransparency = 1
    globeIcon.Image = "rbxassetid://9080434865"
    globeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    globeIcon.Parent = allButton

    local allText = Instance.new("TextLabel")
    allText.Size = UDim2.new(1, -30, 1, 0)
    allText.Position = UDim2.new(0, 30, 0, 0)
    allText.BackgroundTransparency = 1
    allText.Text = "All Players"
    allText.TextColor3 = Color3.new(1, 1, 1)
    allText.TextSize = 14
    allText.Font = Enum.Font.GothamBold
    allText.TextXAlignment = Enum.TextXAlignment.Left
    allText.Parent = allButton

    local allClickButton = Instance.new("TextButton")
    allClickButton.Size = UDim2.new(1, 0, 1, 0)
    allClickButton.BackgroundTransparency = 1
    allClickButton.Text = ""
    allClickButton.Parent = allButton

    allClickButton.MouseButton1Down:Connect(function(x, y)
        createRippleEffect(allClickButton, x, y)
    end)

    allClickButton.MouseButton1Click:Connect(function()
        selectedPlayer = "all"
        for _, btn in ipairs(contentFrame.PlayerList:GetChildren()) do
            if btn:IsA("Frame") and btn:FindFirstChildOfClass("UIStroke") then
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(70, 70, 70)
            end
        end
        allButton.BackgroundColor3 = Color3.fromRGB(0, 110, 240)
        allButton:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 140, 255)
        showNotification("Selected: All Players")
    end)

    local function createSectionHeader(text, posY, headerHeight)
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, -14, 0, headerHeight)
        header.Position = UDim2.new(0, 7, 0, posY)
        header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        header.BackgroundTransparency = 0.6

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 4)
        headerCorner.Parent = header

        local headerLabel = Instance.new("TextLabel")
        headerLabel.Size = UDim2.new(1, -10, 1, 0)
        headerLabel.Position = UDim2.new(0, 10, 0, 0)
        headerLabel.BackgroundTransparency = 1
        headerLabel.Text = text
        headerLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        headerLabel.TextSize = 12
        headerLabel.Font = Enum.Font.GothamBold
        headerLabel.TextXAlignment = Enum.TextXAlignment.Left
        headerLabel.Parent = header

        header.Parent = contentFrame
        return header
    end

    createSectionHeader("SELECTED PLAYERS", 42, 24)

    local scrollingList = Instance.new("ScrollingFrame")
    scrollingList.Name = "PlayerList"
    scrollingList.Size = UDim2.new(1, -14, 0, 120)
    scrollingList.Position = UDim2.new(0, 7, 0, 70)
    scrollingList.BackgroundTransparency = 1
    scrollingList.ScrollBarThickness = 3
    scrollingList.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
    scrollingList.ClipsDescendants = true
    scrollingList.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingList.Parent = contentFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = scrollingList

    createSectionHeader("AVAILABLE COMMANDS", 200, 24)

    local cmdScroll = Instance.new("ScrollingFrame")
    cmdScroll.Size = UDim2.new(1, -14, 0, 110)
    cmdScroll.Position = UDim2.new(0, 7, 0, 230)
    cmdScroll.BackgroundTransparency = 1
    cmdScroll.ScrollBarThickness = 3
    cmdScroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
    cmdScroll.ClipsDescendants = true
    cmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    cmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    cmdScroll.Parent = contentFrame

    local cmdLayout = Instance.new("UIGridLayout")
    cmdLayout.CellSize = UDim2.new(0.5, -4, 0, 28)
    cmdLayout.CellPadding = UDim2.new(0, 6, 0, 6)
    cmdLayout.Parent = cmdScroll

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -14, 0, 35)
    inputFrame.Position = UDim2.new(0, 7, 0, 345)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = contentFrame

    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0.49, 0, 1, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    speedFrame.Parent = inputFrame

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 6)
    speedCorner.Parent = speedFrame

    local speedInput = Instance.new("TextBox")
    speedInput.Size = UDim2.new(1, -12, 1, 0)
    speedInput.Position = UDim2.new(0, 6, 0, 0)
    speedInput.BackgroundTransparency = 1
    speedInput.Text = "16"
    speedInput.PlaceholderText = "Speed"
    speedInput.TextColor3 = Color3.new(1, 1, 1)
    speedInput.TextSize = 14
    speedInput.Font = Enum.Font.GothamMedium
    speedInput.Parent = speedFrame

    local chatFrame = Instance.new("Frame")
    chatFrame.Size = UDim2.new(0.49, 0, 1, 0)
    chatFrame.Position = UDim2.new(0.51, 0, 0, 0)
    chatFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    chatFrame.Parent = inputFrame

    local chatCorner = Instance.new("UICorner")
    chatCorner.CornerRadius = UDim.new(0, 6)
    chatCorner.Parent = chatFrame

    local chatInput = Instance.new("TextBox")
    chatInput.Size = UDim2.new(1, -12, 1, 0)
    chatInput.Position = UDim2.new(0, 6, 0, 0)
    chatInput.BackgroundTransparency = 1
    chatInput.PlaceholderText = "Chat message..."
    chatInput.Text = ""
    chatInput.TextColor3 = Color3.new(1, 1, 1)
    chatInput.TextSize = 14
    chatInput.Font = Enum.Font.GothamMedium
    chatInput.ClearTextOnFocus = false
    chatInput.Parent = chatFrame

    allClickButton.MouseButton1Down:Connect(function(x, y)
        createRippleEffect(allClickButton, x, y)
    end)

    allClickButton.MouseButton1Click:Connect(function()
        selectedPlayer = "all"
        for _, btn in ipairs(scrollingList:GetChildren()) do
            if btn:IsA("Frame") and btn:FindFirstChildOfClass("UIStroke") then
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(70, 70, 70)
            end
        end
        allButton.BackgroundColor3 = Color3.fromRGB(0, 110, 240)
        allButton:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 140, 255)
        showNotification("Selected: All Players")
    end)

    local function createCommandButton(cmd)
        local cmdButton = Instance.new("Frame")
        cmdButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

        local cmdBtnCorner = Instance.new("UICorner")
        cmdBtnCorner.CornerRadius = UDim.new(0, 6)
        cmdBtnCorner.Parent = cmdButton

        local cmdText = Instance.new("TextLabel")
        cmdText.Size = UDim2.new(1, -16, 1, 0)
        cmdText.Position = UDim2.new(0, 8, 0, 0)
        cmdText.BackgroundTransparency = 1
        cmdText.Text = cmd
        cmdText.TextColor3 = Color3.new(1, 1, 1)
        cmdText.TextSize = 14
        cmdText.Font = Enum.Font.GothamMedium
        cmdText.TextXAlignment = Enum.TextXAlignment.Left
        cmdText.Parent = cmdButton

        local clickableBtn = Instance.new("TextButton")
        clickableBtn.Size = UDim2.new(1, 0, 1, 0)
        clickableBtn.BackgroundTransparency = 1
        clickableBtn.Text = ""
        clickableBtn.Parent = cmdButton

        clickableBtn.MouseButton1Down:Connect(function(x, y)
            createRippleEffect(cmdButton, x, y)
        end)

        clickableBtn.MouseEnter:Connect(function()
            TweenService:Create(cmdButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            }):Play()
        end)

        clickableBtn.MouseLeave:Connect(function()
            TweenService:Create(cmdButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            }):Play()
        end)

        clickableBtn.MouseButton1Click:Connect(function()
            if cmd == ".speed" then
                sendCommand(cmd, selectedPlayer, speedInput.Text)
            elseif cmd == ".chat" then
                if chatInput.Text == "" then
                    showNotification("Please enter a chat message")
                else
                    sendCommand(cmd, selectedPlayer, chatInput.Text)
                    chatInput.Text = ""
                end
            else
                sendCommand(cmd, selectedPlayer)
            end

            TweenService:Create(cmdButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(0, 110, 240)
            }):Play()

            task.delay(0.1, function()
                TweenService:Create(cmdButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)
        end)

        cmdButton.Parent = cmdScroll
    end

    for _, cmd in ipairs(defaultAllCommands) do
        createCommandButton(cmd)
    end

    for _, cmd in ipairs(requireTargetCommands) do
        createCommandButton(cmd)
    end

    createCommandButton(".chat")

    local isMinimized = false
    local originalSize = mainFrame.Size

    minimizeButton.MouseButton1Click:Connect(function()
        if not isMinimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)
            }):Play()
            contentFrame.Visible = false
            isMinimized = true
            showNotification("GUI Minimized")
        else
            contentFrame.Visible = true
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = originalSize
            }):Play()
            isMinimized = false
            showNotification("GUI Expanded")
        end
    end)

    return newGui, scrollingList
end

-- Chat-Aktivierungscode, damit der Script Spieler "findet"
local message = "AKADMIN-AntiTags"
local modifiedMessage = modifyString(message)

gui, playerList = createAKListGUI()
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Chat-Listener für jeden Spieler (Script "findet" sie)
local function setupChatListener(player)
    player.Chatted:Connect(function(msg)
        if modifyString(msg) == modifiedMessage and not AKUsers[player.Name] then
            AKUsers[player.Name] = true
            local button = createPlayerButton(player)
            button.Position = UDim2.new(-1, 0, 0, button.Position.Y.Offset)
            button.BackgroundTransparency = 1

            for _, child in pairs(button:GetDescendants()) do
                if child:IsA("TextLabel") then
                    child.TextTransparency = 1
                elseif child:IsA("ImageLabel") then
                    child.ImageTransparency = 1
                elseif child:IsA("UIStroke") then
                    child.Transparency = 1
                end
            end

            TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, button.Position.Y.Offset),
                BackgroundTransparency = 0
            }):Play()

            for _, child in pairs(button:GetDescendants()) do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        TextTransparency = 0
                    }):Play()
                elseif child:IsA("ImageLabel") then
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        ImageTransparency = 0
                    }):Play()
                elseif child:IsA("UIStroke") then
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = 0
                    }):Play()
                end
            end

            showNotification("Player " .. player.Name .. " using AK Admin")
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupChatListener(player)
end

Players.PlayerAdded:Connect(setupChatListener)

Players.PlayerRemoving:Connect(function(player)
    if AKUsers[player.Name] then
        AKUsers[player.Name] = nil
        local button = playerList:FindFirstChild(player.Name)
        if button then
            TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, 0, 0, button.Position.Y.Offset),
                BackgroundTransparency = 1
            }):Play()

            for _, child in pairs(button:GetDescendants()) do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        TextTransparency = 1
                    }):Play()
                elseif child:IsA("ImageLabel") then
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        ImageTransparency = 1
                    }):Play()
                elseif child:IsA("UIStroke") then
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = 1
                    }):Play()
                end
            end

            task.delay(0.3, function()
                button:Destroy()
            end)

            showNotification("Player " .. player.Name .. " left the game")
        end
    end
end)
