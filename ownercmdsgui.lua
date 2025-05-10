-- Create the GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "CommandListGUI"
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- Top Bar (for dragging)
local topBar = Instance.new("Frame", mainFrame)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBar.BorderSizePixel = 0

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", topBar)
title.Name = "Title"
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Command List"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeButton = Instance.new("TextButton", topBar)
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local closeButtonCorner = Instance.new("UICorner", closeButton)
closeButtonCorner.CornerRadius = UDim.new(0, 8)

-- Scrolling Frame for Commands
local commandList = Instance.new("ScrollingFrame", mainFrame)
commandList.Name = "CommandList"
commandList.Size = UDim2.new(1, -20, 1, -40)
commandList.Position = UDim2.new(0, 10, 0, 35)
commandList.CanvasSize = UDim2.new(0, 0, 0, 0)
commandList.ScrollBarThickness = 6
commandList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
commandList.BackgroundTransparency = 1

-- UI List Layout
local uiListLayout = Instance.new("UIListLayout", commandList)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)

-- Add Commands to List

local commands = {
    {".rejoin", "Teleports you back to the server."},
    {".fast", "Increases your walk speed."},
    {".normal", "Resets your walk speed to normal."},
    {".slow", "Decreases your walk speed."},
    {".unfloat", "Disables floating."},
    {".float", "Makes you float."},
    {".void", "Teleports you to a distant location."},
    {".jump", "Makes you jump."},
    {".trip", "Makes you trip."},
    {".sit", "Makes you sit down."},
    {".freeze [player]", "Freezes a player in place."},
    {".unfreeze", "Unfreezes all frozen players."},
    {".kick [player]", "Kicks a player from the game."},
    {".kill", "Kills your character."},
    {".bring [player]", "Teleports a player to you."},
    {".js", "Executes JavaScript code (WIP)."},
    {".js2", "Executes JavaScript code (WIP)."},
    {".invert", "Inverts player controls (WIP)."},
    {".uninvert", "Uninverts player controls (WIP)."},
    {".spin", "Makes the player spin (WIP)."},
    {".unspin", "Stops the player from spinning (WIP)."},
    {".disablejump", "Disables the player's jump (WIP)."},
    {".unenablejump", "Enables the player's jump (WIP)."},
    {".squeak", "Makes a squeak sound (WIP)."},
    {".bighead", "Makes the player's head big (WIP)."},
    {".tiny", "Makes the player tiny (WIP)."},
    {".big", "Makes the player big (WIP)."},
    {".sillyhat", "Gives the player a silly hat (WIP)."},
    {".suspend", "Suspends voice chat (WIP)."},
    {".control [player]", "Controls a player (WIP)."},
    {".uncontrol", "Stops controlling a player (WIP)."},
    {".walktome [player]", "Walks to a player."},
    {".smartwalktome [player]", "Walks to a player, avoiding obstacles."},
    {".ad", "Shows an advertisement (WIP)."},
    {".ownercmds", "Opens this command list."},
    {".crash", "Crashes the server (Extremely Dangerous)."}
}

for _, command in pairs(commands) do
    local commandFrame = Instance.new("Frame", commandList)
    commandFrame.Size = UDim2.new(1, 0, 0, 30)
    commandFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    commandFrame.BorderSizePixel = 0

    local commandCorner = Instance.new("UICorner", commandFrame)
    commandCorner.CornerRadius = UDim.new(0, 8)

    local commandName = Instance.new("TextLabel", commandFrame)
    commandName.Size = UDim2.new(0.4, 0, 1, 0)
    commandName.BackgroundTransparency = 1
    commandName.Text = command[1]
    commandName.TextColor3 = Color3.fromRGB(255, 255, 255)
    commandName.Font = Enum.Font.Gotham
    commandName.TextSize = 12
    commandName.TextXAlignment = Enum.TextXAlignment.Left
    commandName.Position = UDim2.new(0.05, 0, 0, 0)

    local commandDesc = Instance.new("TextLabel", commandFrame)
    commandDesc.Size = UDim2.new(0.55, -10, 1, 0)
    commandDesc.BackgroundTransparency = 1
    commandDesc.Text = command[2]
    commandDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    commandDesc.Font = Enum.Font.Gotham
    commandDesc.TextSize = 12
    commandDesc.TextXAlignment = Enum.TextXAlignment.Left
    commandDesc.Position = UDim2.new(0.4, 5, 0, 0)
end

-- Adjust CanvasSize
commandList.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)

-- Dragging Functionality (Touch + Mouse Support)
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

topBar.InputBegan:Connect(function(input)
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

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Close Button Functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
