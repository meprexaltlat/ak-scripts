local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")
local UIGradient = Instance.new("UIGradient")
local DragBar = Instance.new("Frame")
local DragLabel = Instance.new("TextLabel")
local MainUICorner = Instance.new("UICorner")

-- Configuration
local config = {
    blockingEnabled = false,
    defaultGravity = 192.2,
    baseHeight = 3,
    positions = {
        -- Increased separation between legs by adjusting X and Z coordinates
        leftUpperLeg = CFrame.new(-10000000, 15, 25000000),    -- Moved further left and forward
        rightUpperLeg = CFrame.new(10000000, 15, 25000000),    -- Moved further right and forward
        leftLowerLeg = CFrame.new(-10000000, 15, -25000000),   -- Moved further left and backward
        rightLowerLeg = CFrame.new(10000000, 15, -25000000),   -- Moved further right and backward
        upperTorso = CFrame.new(101, 3, -2150002),
        lowerTorso = CFrame.new(101, 3, -2150002),
        head = CFrame.new(101, 3, -2152),
        leftArm = CFrame.new(-7500, 13, -7500),
        rightArm = CFrame.new(7500, 13, 7500)
    },
    lastPosition = nil,
    shouldAnchor = false,
    disablePosition = nil
}

-- GUI Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.8, 0, 0.5, -50)
MainFrame.Size = UDim2.new(0, 250, 0, 130) -- Increased Size
MainFrame.BorderSizePixel = 0

MainUICorner.Parent = MainFrame
MainUICorner.CornerRadius = UDim.new(0, 10)

DragBar.Name = "DragBar"
DragBar.Parent = MainFrame
DragBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DragBar.Size = UDim2.new(1, 0, 0, 20)
DragBar.BorderSizePixel = 0

DragLabel.Name = "DragLabel"
DragLabel.Parent = DragBar
DragLabel.BackgroundTransparency = 1
DragLabel.Size = UDim2.new(1, 0, 1, 0)
DragLabel.Font = Enum.Font.GothamBold
DragLabel.Text = "Block Map made by AK"
DragLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DragLabel.TextSize = 14
DragLabel.TextXAlignment = Enum.TextXAlignment.Left
DragLabel.TextYAlignment = Enum.TextYAlignment.Center
DragLabel.Position = UDim2.new(0.02,0,0,0)



ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ENABLE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18.000

UICorner.Parent = ToggleButton
UICorner.CornerRadius = UDim.new(0, 8)

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.7, 0)
StatusLabel.Size = UDim2.new(1, 0, 0.3, 0)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.Text = "Status: Disabled"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 14.000

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
}
UIGradient.Parent = MainFrame
UIGradient.Rotation = 90

-- Anti-Deletion Functions
local function createAntiVoidPart()
    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = Vector3.new(1000, 1, 1000)
    part.Position = Vector3.new(0, -10, 0)
    part.CanCollide = true
    part.Transparency = 1
    part.Parent = workspace
    return part
end

local function protectCharacter(character)
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
            part.Massless = true
            part.CanCollide = true
            part.CanTouch = false
            part.CanQuery = false
            part.Anchored = config.shouldAnchor
        end
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid.BreakJointsOnDeath = false
    end
end

local function updateCharacterState()
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local function updatePart(part, position)
        if part then
            part.CFrame = position
            part.Anchored = config.shouldAnchor
            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    updatePart(character:FindFirstChild("LeftUpperLeg"), config.positions.leftUpperLeg)
    updatePart(character:FindFirstChild("RightUpperLeg"), config.positions.rightUpperLeg)
    updatePart(character:FindFirstChild("LeftLowerLeg"), config.positions.leftLowerLeg)
    updatePart(character:FindFirstChild("RightLowerLeg"), config.positions.rightLowerLeg)
    updatePart(character:FindFirstChild("UpperTorso"), config.positions.upperTorso)
    updatePart(character:FindFirstChild("LowerTorso"), config.positions.lowerTorso)
    updatePart(character:FindFirstChild("Head"), config.positions.head)
    updatePart(character:FindFirstChild("LeftUpperArm"), config.positions.leftArm)
    updatePart(character:FindFirstChild("RightUpperArm"), config.positions.rightArm)
    
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
        humanoid.WalkSpeed = 20
        humanoid.HipHeight = 2
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    if hrp then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            if config.lastPosition then
                local newPos = config.lastPosition + moveDirection
                hrp.CFrame = CFrame.new(newPos.X, config.baseHeight, newPos.Z)
                config.lastPosition = newPos
            else
                config.lastPosition = hrp.Position
            end
        elseif not config.lastPosition then
            config.lastPosition = hrp.Position
        end
        
        hrp.CFrame = CFrame.new(hrp.Position.X, config.baseHeight, hrp.Position.Z)
        hrp.Anchored = config.shouldAnchor
    end
    
    ReplicatedStorage.RagdollEvent:FireServer()
end

local function toggleBlocking()
    config.blockingEnabled = not config.blockingEnabled
    
    if config.blockingEnabled then
        ToggleButton.Text = "DISABLE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        StatusLabel.Text = "Status: Enabled"
        workspace.Gravity = 0
        config.lastPosition = nil
        config.shouldAnchor = false
        
        createAntiVoidPart()
        protectCharacter(Players.LocalPlayer.Character)
        
        spawn(function()
            wait(2)
            config.shouldAnchor = true
        end)
        
        RunService:BindToRenderStep("UpdateCharacter1", Enum.RenderPriority.First.Value, updateCharacterState)
        
        spawn(function()
            while config.blockingEnabled do
                protectCharacter(Players.LocalPlayer.Character)
                updateCharacterState()
                RunService.Heartbeat:Wait()
            end
        end)
        
    else
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            config.disablePosition = character.HumanoidRootPart.Position
        end
        
        config.shouldAnchor = false
        
        spawn(function()
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                    humanoid.AutoRotate = true
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                        part.CanCollide = true
                        part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0, 0.3, 1, 1)
                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
                
                ReplicatedStorage.UnragdollEvent:FireServer()
                
                wait(0.1)
                if config.disablePosition and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = CFrame.new(config.disablePosition)
                    character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        
        ToggleButton.Text = "ENABLE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        StatusLabel.Text = "Status: Disabled"
        RunService:UnbindFromRenderStep("UpdateCharacter1")
        workspace.Gravity = config.defaultGravity
    end
end

-- Event Connections
ToggleButton.MouseButton1Click:Connect(toggleBlocking)

-- Draggable Frame
local dragging
local dragInput
local dragStart
local startPos

DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
