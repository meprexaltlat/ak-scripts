local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolManagerGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Position = UDim2.new(0.8, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius to main frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Add corner radius to title bar (just top corners)
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Fix the bottom corners of title bar
local bottomFix = Instance.new("Frame")
bottomFix.Size = UDim2.new(1, 0, 0, 10)
bottomFix.Position = UDim2.new(0, 0, 1, -10)
bottomFix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bottomFix.BorderSizePixel = 0
bottomFix.Parent = titleBar

-- Create title text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0) -- Added position to fix text alignment
titleText.BackgroundTransparency = 1
titleText.Text = "Lag Server"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left -- Fixed text alignment
titleText.Parent = titleBar

-- Create minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(1, -52, 0.5, -12)
minimizeButton.AnchorPoint = Vector2.new(0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 14
minimizeButton.Parent = titleBar

-- Add corner radius to minimize button
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- Create close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -26, 0.5, -12)
closeButton.AnchorPoint = Vector2.new(0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

-- Add corner radius to close button
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Create content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 180, 0, 30)
toggleButton.Position = UDim2.new(0.5, -90, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamSemibold
toggleButton.TextSize = 14
toggleButton.Parent = contentFrame

-- Add corner radius to toggle button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

-- Create Aura Remover toggle checkbox (enlarged)
local auraFrame = Instance.new("Frame")
auraFrame.Name = "AuraFrame"
auraFrame.Size = UDim2.new(1, 0, 0, 30)
auraFrame.Position = UDim2.new(0, 0, 0, 45)
auraFrame.BackgroundTransparency = 1
auraFrame.Parent = contentFrame

-- Create checkbox background (enlarged)
local auraCheckbox = Instance.new("Frame")
auraCheckbox.Name = "AuraCheckbox"
auraCheckbox.Size = UDim2.new(0, 24, 0, 24) -- Made bigger
auraCheckbox.Position = UDim2.new(0, 0, 0.5, -12)
auraCheckbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
auraCheckbox.BorderSizePixel = 0
auraCheckbox.Parent = auraFrame

-- Add corner radius to checkbox
local checkboxCorner = Instance.new("UICorner")
checkboxCorner.CornerRadius = UDim.new(0, 4)
checkboxCorner.Parent = auraCheckbox

-- Create checkbox indicator (now hidden by default as requested)
local checkboxIndicator = Instance.new("Frame")
checkboxIndicator.Name = "CheckboxIndicator"
checkboxIndicator.Size = UDim2.new(0.7, 0, 0.7, 0)
checkboxIndicator.Position = UDim2.new(0.5, 0, 0.5, 0)
checkboxIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
checkboxIndicator.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
checkboxIndicator.BorderSizePixel = 0
checkboxIndicator.Visible = false  -- Off by default now
checkboxIndicator.Parent = auraCheckbox

-- Add corner radius to checkbox indicator
local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 2)
indicatorCorner.Parent = checkboxIndicator

-- Create checkbox label (enlarged text)
local auraLabel = Instance.new("TextLabel")
auraLabel.Name = "AuraLabel"
auraLabel.Size = UDim2.new(1, -34, 1, 0)
auraLabel.Position = UDim2.new(0, 34, 0, 0)
auraLabel.BackgroundTransparency = 1
auraLabel.Text = "Anti Lag"
auraLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
auraLabel.Font = Enum.Font.Gotham
auraLabel.TextSize = 14 -- Made text bigger
auraLabel.TextXAlignment = Enum.TextXAlignment.Left
auraLabel.Parent = auraFrame

-- Add drop shadow to main frame
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.Parent = mainFrame

-- Status indicator text (moved more to the right)
local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(0.7, 0, 0, 15)
statusText.Position = UDim2.new(0.3, 0, 1, -18) -- Moved more to the right
statusText.BackgroundTransparency = 1
statusText.Text = "Ready"
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 10
statusText.Parent = contentFrame

-- Create minimized state
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Size = UDim2.new(0, 120, 0, 30)
minimizedFrame.Position = UDim2.new(0.8, 0, 0.5, 0)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false
minimizedFrame.Parent = screenGui

-- Add corner radius to minimized frame
local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 8)
minimizedCorner.Parent = minimizedFrame

-- Create minimized title text
local minimizedText = Instance.new("TextLabel")
minimizedText.Name = "MinimizedText"
minimizedText.Size = UDim2.new(0.7, 0, 1, 0)
minimizedText.BackgroundTransparency = 1
minimizedText.Text = "Lag Server"
minimizedText.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedText.Font = Enum.Font.GothamBold
minimizedText.TextSize = 12
minimizedText.Parent = minimizedFrame

-- Create restore button for minimized state
local restoreButton = Instance.new("TextButton")
restoreButton.Name = "RestoreButton"
restoreButton.Size = UDim2.new(0, 24, 0, 24)
restoreButton.Position = UDim2.new(1, -26, 0.5, -12)
restoreButton.AnchorPoint = Vector2.new(0, 0)
restoreButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
restoreButton.BorderSizePixel = 0
restoreButton.Text = "▢"
restoreButton.TextColor3 = Color3.fromRGB(200, 200, 200)
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 14
restoreButton.Parent = minimizedFrame

-- Add corner radius to restore button
local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 6)
restoreCorner.Parent = restoreButton

-- Variables
local toolsEquipped = false
local removeAuras = false  -- Start with Anti Lag off as requested
local tools = {}
local auraRemovalConnection
local isMinimized = false

-- Reference events - Use WaitForChild with error handling
local ModifyUsername
local toolEvent
local targetModifiedUsername = "YournothimbuddyXD"  -- The username from the original script

-- Try to get the RemoteEvents with more robust error handling
pcall(function()
    ModifyUsername = ReplicatedStorage:WaitForChild("ModifyUsername", 10)
end)

pcall(function()
    toolEvent = ReplicatedStorage:WaitForChild("ToolEvent", 10)
end)

-- Custom dragging implementation
local dragging = false
local dragInput
local dragStart
local startPos
local minimizedDragging = false
local minimizedDragStart
local minimizedStartPos

-- Function to remove items with 'aura' in their name
local function removeAuraItems()
    if not removeAuras or not player.Character then return end
    
    local auraItemsFound = false
    for _, item in pairs(player.Character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Tool") or item:IsA("BasePart") or item:IsA("Shirt") or item:IsA("Pants") then
            if string.find(string.lower(item.Name), "aura") then
                item:Destroy()
                auraItemsFound = true
            end
        end
    end
    
    -- Also check other players for aura items and remove them
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            for _, item in pairs(otherPlayer.Character:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Tool") or item:IsA("BasePart") or item:IsA("Shirt") or item:IsA("Pants") then
                    if string.find(string.lower(item.Name), "aura") then
                        item:Destroy()
                        auraItemsFound = true
                    end
                end
            end
        end
    end
    
    if auraItemsFound then
        statusText.Text = "Aura items removed"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(0.01) -- Using task.wait instead of wait for better performance
        statusText.Text = toolsEquipped and "Running" or "Ready"
        statusText.TextColor3 = toolsEquipped and Color3.fromRGB(40, 180, 120) or Color3.fromRGB(150, 150, 150)
    end
end

-- Set up aura removal function that can run independently
local function startAuraRemoval()
    -- Disconnect existing connection if any
    if auraRemovalConnection then
        auraRemovalConnection:Disconnect()
    end
    
    -- Create new connection
    auraRemovalConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if removeAuras then
            removeAuraItems()
        end
    end)
end

-- Start the aura removal monitoring immediately but it will only act when removeAuras is true
startAuraRemoval()

-- Set up dragging for the main frame
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

-- Set up dragging for the minimized frame
minimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        minimizedDragging = true
        minimizedDragStart = input.Position
        minimizedStartPos = minimizedFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                minimizedDragging = false
            end
        end)
    end
end)

-- This allows dragging to continue even if the mouse moves off the frames
userInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        if minimizedDragging then
            local delta = input.Position - minimizedDragStart
            minimizedFrame.Position = UDim2.new(minimizedStartPos.X.Scale, minimizedStartPos.X.Offset + delta.X, minimizedStartPos.Y.Scale, minimizedStartPos.Y.Offset + delta.Y)
        end
    end
end)

-- Handle aura checkbox toggle
auraCheckbox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        removeAuras = not removeAuras
        checkboxIndicator.Visible = removeAuras
        
        if removeAuras then
            statusText.Text = "Anti Lag active"
            statusText.TextColor3 = Color3.fromRGB(40, 180, 120)
        else
            statusText.Text = "Anti Lag off"
            statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        task.wait(0.01)
        if toolsEquipped then
            statusText.Text = "Running"
            statusText.TextColor3 = Color3.fromRGB(40, 180, 120)
        else
            statusText.Text = "Ready"
            statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
end)

auraLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        removeAuras = not removeAuras
        checkboxIndicator.Visible = removeAuras
        
        if removeAuras then
            statusText.Text = "Anti Lag active"
            statusText.TextColor3 = Color3.fromRGB(40, 180, 120)
        else
            statusText.Text = "Anti Lag off"
            statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        task.wait(0.01)
        if toolsEquipped then
            statusText.Text = "Running"
            statusText.TextColor3 = Color3.fromRGB(40, 180, 120)
        else
            statusText.Text = "Ready"
            statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        minimizedDragging = false
    end
end)

-- Minimize button functionality
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
    isMinimized = true
    -- Match minimized frame position with main frame
    minimizedFrame.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
end)

-- Restore button functionality
restoreButton.MouseButton1Click:Connect(function()
    minimizedFrame.Visible = false
    mainFrame.Visible = true
    isMinimized = false
    -- Match main frame position with minimized frame
    mainFrame.Position = UDim2.new(minimizedFrame.Position.X.Scale, minimizedFrame.Position.X.Offset, minimizedFrame.Position.Y.Scale, minimizedFrame.Position.Y.Offset)
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    -- Clean up any connections
    if auraRemovalConnection then
        auraRemovalConnection:Disconnect()
    end
    toolsEquipped = false
end)

-- Function to fire ModifyUsername with proper error handling
local function fireModifyUsername()
    -- Make sure ModifyUsername exists and is valid
    if not ModifyUsername or typeof(ModifyUsername) ~= "Instance" or not ModifyUsername:IsA("RemoteEvent") then
        -- Attempt to find it again
        local success, result = pcall(function()
            return ReplicatedStorage:WaitForChild("ModifyUsername", 2)
        end)
        if success and result then
            ModifyUsername = result
        else
            return false -- Can't find the event
        end
    end
    
    -- Now fire the event safely
    local success = pcall(function()
        local args = {
            [1] = targetModifiedUsername
        }
        ModifyUsername:FireServer(unpack(args))
    end)
    
    return success
end

-- Function to fire Tool event with proper error handling
local function fireToolEvent(toolName)
    -- Make sure toolEvent exists and is valid
    if not toolEvent or typeof(toolEvent) ~= "Instance" or not toolEvent:IsA("RemoteEvent") then
        -- Attempt to find it again
        local success, result = pcall(function()
            return ReplicatedStorage:WaitForChild("ToolEvent", 2)
        end)
        if success and result then
            toolEvent = result
        else
            return false -- Can't find the event
        end
    end
    
    -- Now fire the event safely
    local success = pcall(function()
        local args = {
            [1] = toolName
        }
        toolEvent:FireServer(unpack(args))
    end)
    
    return success
end

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    toolsEquipped = not toolsEquipped
    
    if toolsEquipped then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 120)
        statusText.Text = "Running"
        statusText.TextColor3 = Color3.fromRGB(40, 180, 120)
        
        -- Fire Motor event
        fireToolEvent("Motor")
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        statusText.Text = "Ready"
        statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    
    -- Tool equipping and unequipping logic
    if toolsEquipped then
        -- Thread for tool equipping/unequipping - now much faster and all tools at once
        task.spawn(function()
            while toolsEquipped do
                -- Fire ModifyUsername with robust error handling
                fireModifyUsername()
                
                -- Get all tools in backpack
                tools = {}
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(tools, tool)
                    end
                end
                
                -- Equip all tools at once
                if #tools > 0 and player.Character then
                    for _, tool in pairs(tools) do
                        if not toolsEquipped then break end  -- Exit if toggled off
                        tool.Parent = player.Character
                    end
                end
                
                -- Unequip all tools at once
                if player.Character then
                    for _, tool in pairs(player.Character:GetChildren()) do
                        if not toolsEquipped then break end  -- Exit if toggled off
                        if tool:IsA("Tool") then
                            tool.Parent = player.Backpack
                        end
                    end
                end
                
                -- Extremely minimal wait time between cycles
                task.wait()  -- Using task.wait instead of wait for better performance
            end
        end)
    end
end)
