local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI Erstellung
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local DragBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")

-- GUI zum CoreGui hinzufügen
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Hauptframe
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.BorderSizePixel = 0

-- DragBar
DragBar.Name = "DragBar"
DragBar.Parent = MainFrame
DragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DragBar.Size = UDim2.new(1, 0, 0, 25)
DragBar.BorderSizePixel = 0

-- Titel
Title.Parent = DragBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Invisible toggle"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
CloseButton.Parent = DragBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(1, -20, 0, 5)
CloseButton.Size = UDim2.new(0, 15, 0, 15)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Toggle Button
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 45)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ACTIVATE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

-- Variablen
local Dragging = false
local DragStart = nil
local StartPos = nil
local BodyLifted = false
local UpdateConnection = nil

-- Liste der Körperteile die angehoben werden
local bodyParts = {
    "UpperTorso",
    "LowerTorso",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "LeftFoot",
    "RightUpperLeg",
    "RightLowerLeg",
    "RightFoot"
}

-- Liste der Körperteile die unten bleiben sollen
local stationaryParts = {
    "Head",
    "HumanoidRootPart"
}

-- Drag Funktionalität für PC und Mobile
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end

local function updateDrag(input)
    if Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end

local function stopDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end

DragBar.InputBegan:Connect(startDrag)
UserInputService.InputChanged:Connect(updateDrag)
UserInputService.InputEnded:Connect(stopDrag)

-- Close Button Funktion
CloseButton.MouseButton1Click:Connect(function()
    if BodyLifted then
        BodyLifted = false
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
    end
    ScreenGui:Destroy()
end)

-- Body Update Funktion
local function UpdateBody()
    local player = Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoidRootPart and humanoid then
            -- Normale Bewegungsgeschwindigkeit beibehalten
            humanoid.WalkSpeed = 16
            
            -- Körperteile anheben
            for _, partName in ipairs(bodyParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    if BodyLifted then
                        local currentPos = part.Position
                        part.CFrame = part.CFrame * CFrame.new(0, 10, 0)
                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
            
            -- Stationäre Teile an ihrer Position halten
            for _, partName in ipairs(stationaryParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    if partName == "HumanoidRootPart" then
                        local currentPos = part.Position
                        part.CFrame = CFrame.new(currentPos.X, currentPos.Y, currentPos.Z)
                    end
                end
            end
        end
    end
end

-- Toggle Button Funktion
ToggleButton.MouseButton1Click:Connect(function()
    BodyLifted = not BodyLifted
    
    if BodyLifted then
        ToggleButton.Text = "DEACTIVATE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        
        -- Start Update Loop
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        UpdateConnection = RunService.Heartbeat:Connect(UpdateBody)
        
        -- Ragdoll Event
        ReplicatedStorage.RagdollEvent:FireServer()
    else
        ToggleButton.Text = "ACTIVATE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 45)
        
        -- Stop Update Loop
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        
        -- Reset Body Position
        local character = Players.LocalPlayer.Character
        if character then
            for _, partName in ipairs(bodyParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    part.CFrame = part.CFrame * CFrame.new(0, -10, 0)
                end
            end
        end
        
        -- Unragdoll Event
        ReplicatedStorage.UnragdollEvent:FireServer()
    end
end)
