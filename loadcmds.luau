local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not _G.cmds then
    _G.cmds = {}
end

local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AKAdminNotifications")
if existingGui then
    existingGui:Destroy()
end

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "AKAdminNotifications"
NotificationGui.ResetOnSpawn = false
NotificationGui.Parent = LocalPlayer:WaitForChild("PlayerGui")


local function createNotification(title, text, duration, suggestion, suggestionCallback, offset)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 120) -- Increased size
    notification.Position = UDim2.new(1, 50, 0.02 + (offset or 0), 0)
    notification.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    notification.BackgroundTransparency = 0
    notification.BorderSizePixel = 0
    notification.Parent = NotificationGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = notification

    local titleAccent = Instance.new("Frame")
    titleAccent.Size = UDim2.new(0, 3, 0, 20)
    titleAccent.Position = UDim2.new(0, 10, 0, 8)
    titleAccent.BackgroundColor3 = Color3.fromRGB(65, 165, 255)
    titleAccent.BorderSizePixel = 0
    titleAccent.Parent = notification

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = titleAccent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 20)
    titleLabel.Position = UDim2.new(0, 20, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = notification

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 60) -- Increased size to fit more text
    messageLabel.Position = UDim2.new(0, 10, 0, 30) -- Adjusted position
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextSize = 14 -- Increased text size
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Text = text
    messageLabel.Parent = notification

    if suggestion then
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, -20, 0, 25)
        buttonContainer.Position = UDim2.new(0, 10, 1, -33)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = notification

        local yesButton = Instance.new("TextButton")
        yesButton.Size = UDim2.new(0.48, 0, 1, 0)
        yesButton.Position = UDim2.new(0, 0, 0, 0)
        yesButton.BackgroundColor3 = Color3.fromRGB(65, 165, 255)
        yesButton.Text = "Yes"
        yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        yesButton.Font = Enum.Font.GothamBold
        yesButton.TextSize = 13
        yesButton.AutoButtonColor = false
        yesButton.Parent = buttonContainer

        local yesCorner = Instance.new("UICorner")
        yesCorner.CornerRadius = UDim.new(0, 6)
        yesCorner.Parent = yesButton

        local noButton = Instance.new("TextButton")
        noButton.Size = UDim2.new(0.48, 0, 1, 0)
        noButton.Position = UDim2.new(0.52, 0, 0, 0)
        noButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        noButton.Text = "No"
        noButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        noButton.Font = Enum.Font.GothamBold
        noButton.TextSize = 13
        noButton.AutoButtonColor = false
        noButton.Parent = buttonContainer

        local noCorner = Instance.new("UICorner")
        noCorner.CornerRadius = UDim.new(0, 6)
        noCorner.Parent = noButton

        local function createHoverEffect(button, defaultColor, hoverColor)
            button.MouseEnter:Connect(function()
                TweenService:Create(button, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = hoverColor}
                ):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = defaultColor}
                ):Play()
            end)
        end

        createHoverEffect(yesButton, 
            Color3.fromRGB(65, 165, 255), 
            Color3.fromRGB(85, 175, 255)
        )
        createHoverEffect(noButton, 
            Color3.fromRGB(45, 45, 55), 
            Color3.fromRGB(55, 55, 65)
        )

        yesButton.MouseButton1Click:Connect(function()
            if suggestionCallback then
                suggestionCallback(true)
            end
            notification:Destroy()
        end)

        noButton.MouseButton1Click:Connect(function()
            if suggestionCallback then
                suggestionCallback(false)
            end
            notification:Destroy()
        end)
    end

    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.BackgroundColor3 = Color3.fromRGB(65, 165, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = notification

    local slideTween = TweenService:Create(notification,
        TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 0.02 + (offset or 0), 0)}
    )
    slideTween:Play()

    local progressTween = TweenService:Create(progressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0, 2)}
    )
    progressTween:Play()

    task.delay(duration, function()
        local slideOutTween = TweenService:Create(notification,
            TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In),
           {Position = UDim2.new(1, 50, 0.02 + (offset or 0), 0)}
        )
        slideOutTween:Play()
        
        slideOutTween.Completed:Wait()
        notification:Destroy()
    end)
end

local function suggestClosestCommand(input)
    if not input then return nil end
    local closestCommand = nil
    local highestScore = -math.huge
    
    if _G.cmds[input] then
        return input
    end
    
    for cmd in pairs(_G.cmds) do
        local score = 0
        local inputLower = input:lower()
        local cmdLower = cmd:lower()
        local inputLen = #inputLower
        local cmdLen = #cmdLower
        
        if inputLower == cmdLower then
            return cmd
        end
        
        if cmdLower:sub(1, inputLen) == inputLower then
            score = score + 25
        end

        local function levenshteinDistance(s1, s2)
            local len1 = #s1
            local len2 = #s2
            local d = {}
            
            for i = 0, len1 do d[i] = {[0] = i} end
            for j = 0, len2 do d[0][j] = j end
            
            for j = 1, len2 do
                for i = 1, len1 do
                    local cost = (s1:sub(i,i) == s2:sub(j,j)) and 0 or 1
                    d[i][j] = math.min(
                        d[i-1][j] + 1,
                        d[i][j-1] + 1,
                        d[i-1][j-1] + cost
                    )
                end
            end
            
            return d[len1][len2]
        end
        
        local distance = levenshteinDistance(inputLower, cmdLower)
        score = score - (distance * 5)

        local lengthDiff = math.abs(inputLen - cmdLen)
        score = score - (lengthDiff * 2)

        local lastFoundIndex = 0
        local consecutiveMatches = 0
        for i = 1, inputLen do
            local char = inputLower:sub(i,i)
            local found = cmdLower:find(char, lastFoundIndex+1)
            if found then
                score = score + (2 - (found - i) * 0.5)
                if found == lastFoundIndex + 1 then
                    consecutiveMatches = consecutiveMatches + 1
                    score = score + (consecutiveMatches * 2)
                else
                    consecutiveMatches = 0
                end
                lastFoundIndex = found
            end
        end

        local commonPrefix = 0
        for i = 1, math.min(inputLen, cmdLen) do
            if inputLower:sub(i, i) == cmdLower:sub(i,i) then
                commonPrefix = commonPrefix + 1
            else
                break
            end
        end
        score = score + (commonPrefix * 4)

        if score > highestScore then
            highestScore = score
            closestCommand = cmd
        end
    end
    
    return highestScore > 10 and closestCommand or nil
end

local function executeCommand(command)
    if _G.cmds[command] then
        createNotification(
            "Success",
            "Executed command: " .. command,
            3,
            false,
            nil,
            0
        )
    else
        local suggestion = suggestClosestCommand(command)
        if suggestion then
            createNotification(
                "Command Suggestion",
                "Did you mean: " .. suggestion .. "?",
                10,
                true,
                function(accepted)
                    if accepted then
                        if _G.cmds[suggestion] then
                            local success, errorMessage = pcall(function()
                                loadstring(game:HttpGet(_G.cmds[suggestion]))()
                            end)
                            if success then
                                createNotification(
                                    "Success",
                                    "Executed command: " .. suggestion,
                                    3,
                                    false,
                                    nil,
                                    0
                                )
                            else
                                createNotification(
                                    "Error",
                                    "Failed to execute command: " .. suggestion,
                                    5,
                                    false,
                                    nil,
                                    0
                                )
                            end
                        end
                    end
                end,
                0
            )
        end
    end
end


local function loadCommandBar()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/OBaqt1nbJz1NipM92jv/6qQE2IF1FGovyLEEepBn/refs/heads/main/Cmdsbar"))()
    
end


task.wait(1)

local function showNotificationsSequentially()
	local welcomeMessage = function()
        createNotification(
            "AK ADMIN",
            "Welcome to AK ADMIN! click the AK ADMIN Active GUI or type in !cmds in the chat to see available commands. The toggle for the command bar is F6",
            10,
            false,
            nil,
            0
        )
    end
    
    welcomeMessage()
	loadCommandBar()
end

showNotificationsSequentially()

local lastInput = ""

LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1, 1) == "!" then
        local command = msg:sub(2):lower():gsub("^%s*", ""):gsub("%s*$", "")
        executeCommand("!" .. command)
        lastInput = command
        return
    end
end)

local function updateSuggestion(input)
    if input == "" then return end
    local suggestion = suggestClosestCommand("!" .. input)
    if suggestion then
         for _, child in pairs(NotificationGui:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "ProgressBar" then
                child:Destroy()
            end
        end
        createNotification(
            "Command Suggestion",
            "Did you mean: " .. suggestion .. "?",
            10,
            true,
            function(accepted)
                if accepted then
                    if _G.cmds[suggestion] then
                        local success, errorMessage = pcall(function()
                            loadstring(game:HttpGet(_G.cmds[suggestion]))()
                        end)
                        if success then
                            createNotification(
                                "Success",
                                "Executed command: " .. suggestion,
                                3,
                                false,
                                nil,
                                0
                            )
                        else
                            createNotification(
                                "Error",
                                "Failed to execute command: " .. suggestion,
                                5,
                                false,
                                nil,
                                0
                            )
                        end
                    end
                end
            end,
             0
        )
    else
        for _, child in pairs(NotificationGui:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "ProgressBar" then
                child:Destroy()
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    if not character then return end
    local chatBox = LocalPlayer.PlayerGui:WaitForChild("Chat"):WaitForChild("Frame"):WaitForChild("ChatBar")
    local textBox = chatBox:WaitForChild("Box")
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local currentText = textBox.Text
        if currentText:sub(1,1) == "!" then
            local input = currentText:sub(2):lower()
            if input ~= lastInput then
                updateSuggestion(input)
                lastInput = input
            end
        end
    end)
end)
