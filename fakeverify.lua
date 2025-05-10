if getcustomasset and isfile and readfile and writefile then
    local ranFile = "iconprefixtutorialran.txt"
    local ranBefore = isfile(ranFile) and readfile(ranFile) == "true"

    if ranBefore then 
    else

    -- Otherwise, run the tutorial
    local url = "https://cdn.discordapp.com/attachments/1174404879545012275/1340446302177071197/2025-02-15_23-15-00.mp4?ex=67b26366&is=67b111e6&hm=89caaf61908699ecc67ee4636cbb59a476c08b23ad74cffcd76c1388810bb2cb&"
    local videoPath = "IconPrefixTutorial.mp4"

    local data = game:HttpGet(url, true) -- Download file
    writefile(videoPath, data) -- Save to local storage

    -- GUI Setup
    local AKTutorial = Instance.new("ScreenGui")
    local VideoFrame = Instance.new("VideoFrame")

    AKTutorial.Name = "AKTutorial"
    AKTutorial.Parent = game:GetService("CoreGui")
    AKTutorial.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    AKTutorial.IgnoreGuiInset = true

    VideoFrame.Parent = AKTutorial
    VideoFrame.BackgroundTransparency = 1
    VideoFrame.BorderSizePixel = 0
    VideoFrame.Size = UDim2.new(1, 0, 1, 0)
    VideoFrame.Video = getcustomasset(videoPath)
    VideoFrame.Looped = true
    VideoFrame:Play()

    VideoFrame.DidLoop:Connect(function()
        writefile(ranFile, "true") -- Mark tutorial as watched
        AKTutorial:Destroy()
    end)
end
end -- Exit if already ran before

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Load External Communication Protocol
loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/More-Scripts/refs/heads/main/Anthony's%20ACL"))()
wait(1)

-- Character conversion table (reused from second script)
local letters = {
    ["A"] = "A", ["a"] = "a", ["B"] = "B", ["b"] = "b", ["C"] = "C", ["c"] = "c",
    -- (Full conversion table from the second script)
    [" "] = "  "
}

-- Utility functions for text replacement
local function replace(str, find_str, replace_str)
    local escaped_find_str = find_str:gsub("[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
    return str:gsub(escaped_find_str, replace_str)
end

local function filter(message)
    for search, replacement in pairs(letters) do
        message = replace(message, search, replacement)
    end
    return message
end

-- Precision Chat Transmission Function
local function Chat(msg)
    local filteredMessage = filter(msg)
    local oldChat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    
    if oldChat then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(filteredMessage, "All")
    else
        local textChatService = game:GetService("TextChatService")
        local channel = textChatService.TextChannels.RBXGeneral
        channel:SendAsync(filteredMessage)
    end
end

-- Notification System (from second script)
local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

local function showNotification(title, text)
    Notification:Notify(
        {Title = title, Description = text},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 3, Type = "default"}
    )
end

-- Create main GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "QuantumCommunicationInterface"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = game:GetService("CoreGui")

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 120)
MainFrame.Position = UDim2.new(1, -290, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = GUI

-- Add smooth shadow (from second script)
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://6014257812"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Add corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

-- Add gradient to title bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})
TitleGradient.Parent = TitleBar

-- Title text
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 28, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Text = "ICON PREFIX"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Create close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -27, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Add minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Position = UDim2.new(1, -54, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 185, 85)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton

-- Create input box
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -20, 0, 30)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.PlaceholderText = "TYPE IN MESSAGE..."
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Gotham
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 4)
InputCorner.Parent = InputBox

-- Create prefix selection button
local PrefixButton = Instance.new("TextButton")
PrefixButton.Name = "PrefixButton"
PrefixButton.Size = UDim2.new(0, 80, 0, 26)
PrefixButton.Position = UDim2.new(0, 10, 1, -36)
PrefixButton.BackgroundColor3 = Color3.fromRGB(65, 145, 255)
PrefixButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PrefixButton.Text = "Prefix"
PrefixButton.TextSize = 14
PrefixButton.Font = Enum.Font.GothamBold
PrefixButton.Parent = MainFrame

local PrefixCorner = Instance.new("UICorner")
PrefixCorner.CornerRadius = UDim.new(0, 4)
PrefixCorner.Parent = PrefixButton

-- Create send button
local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Size = UDim2.new(0, 80, 0, 26)
SendButton.Position = UDim2.new(1, -90, 1, -36)
SendButton.BackgroundColor3 = Color3.fromRGB(65, 145, 255)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "Send"
SendButton.TextSize = 14
SendButton.Font = Enum.Font.GothamBold
SendButton.Parent = MainFrame

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 4)
SendCorner.Parent = SendButton

-- Add status indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Size = UDim2.new(0, 6, 0, 6)
StatusIndicator.Position = UDim2.new(0, 12, 0, 12)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
StatusIndicator.Parent = TitleBar

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

-- Prefix selection system
local prefixes = {
    ": ",
    ": ",
    ": ",
    "♡: "
}
local currentPrefixIndex = 1
local currentPrefix = prefixes[currentPrefixIndex]

-- Function to update the prefix button text
local function updatePrefixButtonText()
    PrefixButton.Text = currentPrefix
end

-- Function to get current prefix
local function getCurrentPrefix()
	return currentPrefix
end

-- Sending mechanism
local function processText()
    local inputText = InputBox.Text
    if inputText ~= "" then
        local prefixedMessage = getCurrentPrefix() .. inputText
        Chat(prefixedMessage)
        --Do not clear the box
    end
end

-- Cycle to the next prefix
local function nextPrefix()
    currentPrefixIndex = currentPrefixIndex + 1
    if currentPrefixIndex > #prefixes then
        currentPrefixIndex = 1
    end
    currentPrefix = prefixes[currentPrefixIndex]
    updatePrefixButtonText()
end

-- UI Interactions from second script
local function createButtonEffect(button)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = originalColor:Lerp(Color3.fromRGB(0, 0, 0), 0.1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

-- Dragging functionality
local function enableDragging(frame, handle)
    local dragging = false
    local dragStart
    local startPos
    local lastPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            lastPos = startPos
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            
            -- Smooth movement
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            TweenService:Create(frame, tweenInfo, {Position = targetPos}):Play()
            
            lastPos = targetPos
        end
    end)
end

-- Minimize functionality
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 280, 0, 30) or UDim2.new(0, 280, 0, 120)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(MainFrame, tweenInfo, {Size = targetSize}):Play()
    TweenService:Create(Shadow, tweenInfo, {Size = UDim2.new(1, 30, targetSize.Y.Scale, targetSize.Y.Offset + 30)}):Play()
    
    -- Toggle visibility of other elements
    InputBox.Visible = not minimized
    SendButton.Visible = not minimized
    PrefixButton.Visible = not minimized -- Make sure the button visibility is toggled
end)

-- Connect events
SendButton.MouseButton1Click:Connect(processText)
InputBox.Focused:Connect(function()
    InputBox.Text = ""
end)

InputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		processText()
	end
end)

PrefixButton.MouseButton1Click:Connect(nextPrefix) -- Connect the prefix selection

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local fadeOut = TweenService:Create(MainFrame, tweenInfo, {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    })
    
    fadeOut.Completed:Connect(function()
        GUI:Destroy()
    end)
    
    fadeOut:Play()
end)

-- Apply button effects
createButtonEffect(SendButton)
createButtonEffect(CloseButton)
createButtonEffect(MinimizeButton)
createButtonEffect(PrefixButton)

-- Enable dragging
enableDragging(MainFrame, TitleBar)

-- Startup animation
MainFrame.BackgroundTransparency = 1
Shadow.ImageTransparency = 1
TitleBar.BackgroundTransparency = 1
Title.TextTransparency = 1
CloseButton.BackgroundTransparency = 1
MinimizeButton.BackgroundTransparency = 1
InputBox.BackgroundTransparency = 1
SendButton.BackgroundTransparency = 1
PrefixButton.BackgroundTransparency = 1
StatusIndicator.BackgroundTransparency = 1

local function fadeIn(duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Shadow, tweenInfo, {ImageTransparency = 0.5}):Play()
    TweenService:Create(TitleBar, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Title, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(CloseButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(MinimizeButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(InputBox, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(SendButton, tweenInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(PrefixButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(StatusIndicator, tweenInfo, {BackgroundTransparency = 0}):Play()
end

-- Position check and adjustment
local function adjustFramePosition()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    
    if MainFrame.AbsolutePosition.X + frameSize.X > viewportSize.X then
        MainFrame.Position = UDim2.new(1, -frameSize.X - 10, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    end
    
    if MainFrame.AbsolutePosition.Y + frameSize.Y > viewportSize.Y then
        MainFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1, -frameSize.Y - 10)
    end
end

-- Adjust position on viewport size change
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adjustFramePosition)

-- Initial setup
adjustFramePosition()
fadeIn(0.5)
updatePrefixButtonText() -- Initialize the prefix button text

-- Status indicator pulse animation
spawn(function()
    while wait(1) do
        if not GUI:IsDescendantOf(game:GetService("CoreGui")) then break end
        
        TweenService:Create(StatusIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(50, 255, 50),
            BackgroundTransparency = 0.5
        }):Play()
        wait(1)
        TweenService:Create(StatusIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(50, 255, 50),
            BackgroundTransparency = 0
        }):Play()
    end
end)

-- Show initial success notification
showNotification("ICON PREFIX", "Interface ready!")

-- Add keyboard shortcut (Ctrl + M to minimize)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        MinimizeButton.MouseButton1Click:Fire()
    end
end)

-- Add input box effects
InputBox.Focused:Connect(function()
    TweenService:Create(InputBox, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    }):Play()
end)

InputBox.FocusLost:Connect(function()
    TweenService:Create(InputBox, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    }):Play()
end)
