-- Variables (previous variables remain the same)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local isSpectating = false
local isLoopTping = false
local targetLoop = nil

-- Previous functions remain the same (findPlayer, toggleLoopTp, toggleSpectate)

-- Enhanced GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("Frame")
local Input = Instance.new("TextBox")
local LoopTpButton = Instance.new("TextButton")
local SpectateButton = Instance.new("TextButton")
local Status = Instance.new("TextLabel")
local UICorner_Main = Instance.new("UICorner")
local UICorner_Top = Instance.new("UICorner")

-- GUI Styling
local THEME = {
    Background = Color3.fromRGB(40, 40, 40),
    TopBar = Color3.fromRGB(30, 30, 30),
    Button = Color3.fromRGB(60, 60, 60),
    ButtonHover = Color3.fromRGB(70, 70, 70),
    Text = Color3.fromRGB(255, 255, 255),
    Input = Color3.fromRGB(50, 50, 50),
    Active = Color3.fromRGB(0, 170, 127),
    Inactive = Color3.fromRGB(200, 70, 70)
}

-- GUI Setup
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.8, 0, 0.5, 0)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.Parent = ScreenGui
UICorner_Main.CornerRadius = UDim.new(0, 8)
UICorner_Main.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = THEME.TopBar
TopBar.Parent = MainFrame
UICorner_Top.CornerRadius = UDim.new(0, 8)
UICorner_Top.Parent = TopBar

Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Player Tracker"
Title.TextColor3 = THEME.Text
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

Input.Size = UDim2.new(1, 0, 0, 30)
Input.Position = UDim2.new(0, 0, 0, 0)
Input.BackgroundColor3 = THEME.Input
Input.PlaceholderText = "Enter player name"
Input.Text = ""
Input.TextColor3 = THEME.Text
Input.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
Input.Font = Enum.Font.Gotham
Input.Parent = Container
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 35)
Status.BackgroundTransparency = 1
Status.Text = "Inactive"
Status.TextColor3 = THEME.Text
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = Container

local function createButton(name, pos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.48, 0, 0, 30)
    button.Position = pos
    button.BackgroundColor3 = THEME.Button
    button.Text = name
    button.TextColor3 = THEME.Text
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover Effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ButtonHover}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Button}):Play()
    end)
    
    return button
end

LoopTpButton = createButton("Loop TP", UDim2.new(0, 0, 0, 65))
SpectateButton = createButton("Spectate", UDim2.new(0.52, 0, 0, 65))

-- Make GUI Draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Update button states with animation
local function updateButtons()
    local loopColor = isLoopTping and THEME.Active or THEME.Inactive
    local spectateColor = isSpectating and THEME.Active or THEME.Inactive
    
    TweenService:Create(LoopTpButton, TweenInfo.new(0.3), {BackgroundColor3 = loopColor}):Play()
    TweenService:Create(SpectateButton, TweenInfo.new(0.3), {BackgroundColor3 = spectateColor}):Play()
    Status.Text = isLoopTping and "Loop TP Active" or "Inactive"
end

-- Function to find player by partial name
local function findPlayer(target)
    local players = Players:GetPlayers()
    
    for _, player in pairs(players) do
        local lowerTarget = string.lower(target)
        local lowerUsername = string.lower(player.Name)
        local lowerDisplayName = string.lower(player.DisplayName)
        
        if string.sub(lowerUsername, 1, #lowerTarget) == lowerTarget or 
           string.sub(lowerDisplayName, 1, #lowerTarget) == lowerTarget then
            return player
        end
    end
    return nil
end

-- Function to toggle loop teleport
local function toggleLoopTp(target)
    local player = findPlayer(target)
    
    if player then
        if not isLoopTping then
            -- Start loop teleport
            isLoopTping = true
            targetLoop = player
                        local args = {
        [1] = "Wand"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("ToolEvent"):FireServer(unpack(args))
    wait(2.5)
    
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        tool.Parent = game.Players.LocalPlayer.Character
    end
            -- Create loop
            RunService.Heartbeat:Connect(function()
                if isLoopTping and targetLoop and LocalPlayer.Character and targetLoop.Character then
                    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetHRP = targetLoop.Character:FindFirstChild("HumanoidRootPart")
                    
                    if humanoidRootPart and targetHRP then
            if player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                        humanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(-1.2, -2.5, -5.35)
elseif player.Character.Humanoid.MoveDirection.Magnitude < 1 then
       game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                        humanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(-1.2, -7.5, 1.35)

end
                    end
                end
            end)
        else
            -- Stop loop teleport
            isLoopTping = false
            targetLoop = nil
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    else
        print("Player not found!")
    end
end

-- Function to toggle spectate
local function toggleSpectate(target)
    local player = findPlayer(target)
    
    if player then
        if not isSpectating then
            -- Start spectating
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = player.Character.Humanoid
                isSpectating = true
            end
        else
            -- Stop spectating
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
                isSpectating = false
            end
        end
    else
        print("Player not found!")
    end
end
-- Button Connections
LoopTpButton.MouseButton1Click:Connect(function()
    toggleLoopTp(Input.Text)
    updateButtons()
end)

SpectateButton.MouseButton1Click:Connect(function()
    toggleSpectate(Input.Text)
    updateButtons()
end)

-- Initial setup
updateButtons()
