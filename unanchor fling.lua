-- Enhanced Unanchored Fling GUI
-- Version: 4.0

-- Instances:
local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local Box = Instance.new("TextBox")
local ButtonsFrame = Instance.new("Frame")
local FlingButton = Instance.new("TextButton")
local ViewButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

-- Corner & Shadow Effects
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1.5
    stroke.Color = color or Color3.fromRGB(80, 80, 80)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(35, 35, 45)),
        ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(25, 25, 35))
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

-- Properties:
Gui.Name = "UnanchoredFlingGUI"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 10

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.36, 0, 0.36, 0)
Main.Size = UDim2.new(0.16, 0, 0.18, 0)
Main.Active = true
Main.Draggable = false -- We'll implement custom dragging
Main.ClipsDescendants = true
CreateCorner(Main, 10)
CreateStroke(Main, 1.5, Color3.fromRGB(80, 80, 100))
CreateGradient(Main)

-- Top Bar
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0.15, 0)
CreateCorner(TopBar, 10)
CreateGradient(TopBar, Color3.fromRGB(40, 40, 60), Color3.fromRGB(30, 30, 50), 90)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.02, 0, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Unanchored Fling"
Title.TextColor3 = Color3.fromRGB(230, 230, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BackgroundTransparency = 0.5
CloseButton.Position = UDim2.new(0.9, 0, 0.2, 0)
CloseButton.Size = UDim2.new(0.08, 0, 0.6, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.AutoButtonColor = true
CreateCorner(CloseButton, 8)

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
MinimizeButton.BackgroundTransparency = 0.5
MinimizeButton.Position = UDim2.new(0.8, 0, 0.2, 0)
MinimizeButton.Size = UDim2.new(0.08, 0, 0.6, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.AutoButtonColor = true
CreateCorner(MinimizeButton, 8)

Box.Name = "Box"
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Box.Position = UDim2.new(0.05, 0, 0.2, 0)
Box.Size = UDim2.new(0.9, 0, 0.15, 0)
Box.Font = Enum.Font.Gotham
Box.PlaceholderText = "Enter player name..."
Box.Text = ""
Box.TextColor3 = Color3.fromRGB(230, 230, 250)
Box.TextSize = 14
Box.ClearTextOnFocus = true
CreateCorner(Box, 8)
CreateStroke(Box, 1.2, Color3.fromRGB(80, 80, 120))

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = Main
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusLabel.BackgroundTransparency = 0.6
StatusLabel.Position = UDim2.new(0.05, 0, 0.38, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0.12, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
StatusLabel.TextSize = 13
CreateCorner(StatusLabel, 6)

-- Buttons Frame
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = Main
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Position = UDim2.new(0.05, 0, 0.52, 0)
ButtonsFrame.Size = UDim2.new(0.9, 0, 0.44, 0)

FlingButton.Name = "FlingButton"
FlingButton.Parent = ButtonsFrame
FlingButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FlingButton.Position = UDim2.new(0, 0, 0, 0)
FlingButton.Size = UDim2.new(1, 0, 0.48, 0)
FlingButton.Font = Enum.Font.GothamSemibold
FlingButton.Text = "Unanchor Fling"
FlingButton.TextColor3 = Color3.fromRGB(230, 230, 250)
FlingButton.TextSize = 14
CreateCorner(FlingButton, 8)
CreateGradient(FlingButton, Color3.fromRGB(70, 70, 120), Color3.fromRGB(50, 50, 90))

ViewButton.Name = "ViewButton"
ViewButton.Parent = ButtonsFrame
ViewButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ViewButton.Position = UDim2.new(0, 0, 0.52, 0)
ViewButton.Size = UDim2.new(1, 0, 0.48, 0)
ViewButton.Font = Enum.Font.GothamSemibold
ViewButton.Text = "View Target"
ViewButton.TextColor3 = Color3.fromRGB(230, 230, 250)
ViewButton.TextSize = 14
CreateCorner(ViewButton, 8)
CreateGradient(ViewButton, Color3.fromRGB(70, 70, 120), Color3.fromRGB(50, 50, 90))

-- Toggle Button (Show when minimized)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Gui
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ToggleButton.Position = UDim2.new(0.01, 0, 0.9, 0)
ToggleButton.Size = UDim2.new(0.04, 0, 0.04, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "UF"
ToggleButton.TextColor3 = Color3.fromRGB(230, 230, 250)
ToggleButton.TextSize = 14
ToggleButton.Visible = false
CreateCorner(ToggleButton, 8)
CreateStroke(ToggleButton, 1.2, Color3.fromRGB(80, 80, 120))
CreateGradient(ToggleButton, Color3.fromRGB(50, 50, 80), Color3.fromRGB(30, 30, 60))

-- Scripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Dragging Functionality
local function EnableDragging(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            
            -- Smooth transition
            local tween = TweenService:Create(
                frame, 
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = targetPos}
            )
            tween:Play()
        end
    end)
end

EnableDragging(Main, TopBar)

-- Minimize/Close Animation Functions
local function AnimateFrameClose()
    local tween = TweenService:Create(
        Main,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.01, 0, 0.9, 0)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        Gui:Destroy()
    end)
end

-- Updated Minimize Animation Function
local function AnimateMinimize()
    -- Store current position and size before minimizing
    originalPosition = Main.Position
    originalSize = Main.Size
    
    local tween = TweenService:Create(
        Main,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.01, 0, 0.9, 0)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        Main.Visible = false
        ToggleButton.Visible = true
        
    end)
end

-- Updated Restore Animation Function
local function AnimateRestore()
    Main.Size = UDim2.new(0, 0, 0, 0)
    -- Start from the toggle button's position
    Main.Position = UDim2.new(ToggleButton.Position.X.Scale, 0, ToggleButton.Position.Y.Scale, 0)
    Main.Visible = true
    
    local tween = TweenService:Create(
        Main,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = originalSize, Position = originalPosition}
    )
    tween:Play()
    ToggleButton.Visible = false
end

-- Set up the core functionality (from the original script)
local character
local humanoidRootPart

local mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
        if Main.Visible then
            AnimateMinimize()
        else
            AnimateRestore()
        end
    end
end)

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }

    Network.RetainPart = function(Part)
        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        if v:IsDescendantOf(LocalPlayer.Character) then
            return
        end
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local blackHoleActive = false
local DescendantAddedConnection
local targetPlayerName = ""

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        FlingButton.Text = "Stop Flinging"
        StatusLabel.Text = "Status: Flinging " .. targetPlayerName
        StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        
        -- Button effect
        TweenService:Create(FlingButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(180, 70, 70)
        }):Play()
        
        for _, v in ipairs(Workspace:GetDescendants()) do
            ForcePart(v)
        end

        DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then
                ForcePart(v)
            end
        end)

        spawn(function()
            while blackHoleActive and RunService.RenderStepped:Wait() do
                if humanoidRootPart then
                    Attachment1.WorldCFrame = humanoidRootPart.CFrame
                end
            end
        end)
    else
        FlingButton.Text = "Unanchor Fling"
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
        
        -- Reset button color
        TweenService:Create(FlingButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        }):Play()
        
        if DescendantAddedConnection then
            DescendantAddedConnection:Disconnect()
        end
    end
end

local function getPlayer(name)
    local lowerName = string.lower(name)
    local bestMatch = nil
    local bestMatchLength = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        local playerName = string.lower(p.Name)
        local lowerDisplayName = string.lower(p.DisplayName)

        if string.sub(playerName, 1, #lowerName) == lowerName or string.sub(lowerDisplayName, 1, #lowerName) == lowerName then
            local matchLength = math.min(#lowerName, #playerName)
            if matchLength < bestMatchLength then
                bestMatch = p
                bestMatchLength = matchLength
            end
        end
    end

    return bestMatch
end

-- Button click effects
local function ButtonEffect(button)
    local originalColor = button.BackgroundColor3
    
    TweenService:Create(button, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(100, 100, 140)
    }):Play()
    
    wait(0.1)
    
    TweenService:Create(button, TweenInfo.new(0.1), {
        BackgroundColor3 = originalColor
    }):Play()
end

local function onFlingButtonClicked()
    ButtonEffect(FlingButton)
    
    local playerName = Box.Text
    if playerName ~= "" then
        local targetPlayer = getPlayer(playerName)
        if targetPlayer then
            targetPlayerName = targetPlayer.Name
            Box.Text = targetPlayer.Name
            local function applyBallFling(targetCharacter)
                humanoidRootPart = targetCharacter:WaitForChild("HumanoidRootPart")
                toggleBlackHole()
            end

            local targetCharacter = targetPlayer.Character
            if targetCharacter then
                applyBallFling(targetCharacter)
            else
                StatusLabel.Text = "Player not found"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                wait(1)
                StatusLabel.Text = "Status: Idle"
                StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
            end

            targetPlayer.CharacterAdded:Connect(function(newCharacter)
                if blackHoleActive then
                    applyBallFling(newCharacter)
                end
            end)
        else
            StatusLabel.Text = "Player not found"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            wait(1)
            StatusLabel.Text = "Status: Idle"
            StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
        end
    else
        StatusLabel.Text = "Enter a player name"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
        wait(1)
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
    end
end

-- View button script
local viewing = false
local camera = Workspace.CurrentCamera

local function onViewButtonClicked()
    ButtonEffect(ViewButton)
    
    viewing = not viewing
    local playerName = Box.Text
    local targetPlayer = getPlayer(playerName)
    
    if viewing then
        if targetPlayer and targetPlayer.Character then
            ViewButton.Text = "Stop Viewing"
            
            -- Button effect
            TweenService:Create(ViewButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(70, 70, 180)
            }):Play()
            
            camera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
            targetPlayer.CharacterAdded:Connect(function(newCharacter)
                if viewing then
                    camera.CameraSubject = newCharacter:FindFirstChild("Humanoid")
                end
            end)
        else
            StatusLabel.Text = "Player not found"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            viewing = false
            wait(1)
            StatusLabel.Text = "Status: Idle"
            StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
        end
    else
        ViewButton.Text = "View Target"
        StatusLabel.Text = "Status: Idle"
        
        -- Reset button color
        TweenService:Create(ViewButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        }):Play()
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
end

-- Connect button events
FlingButton.MouseButton1Click:Connect(onFlingButtonClicked)
ViewButton.MouseButton1Click:Connect(onViewButtonClicked)
CloseButton.MouseButton1Click:Connect(AnimateFrameClose)
MinimizeButton.MouseButton1Click:Connect(AnimateMinimize)
ToggleButton.MouseButton1Click:Connect(AnimateRestore)

-- Button hover effects
local function SetupButtonHoverEffects(button)
    local originalColor = button.BackgroundColor3
    local hoverColor = Color3.fromRGB(
        math.min(originalColor.R * 255 + 20, 255) / 255,
        math.min(originalColor.G * 255 + 20, 255) / 255,
        math.min(originalColor.B * 255 + 20, 255) / 255
    )
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

SetupButtonHoverEffects(FlingButton)
SetupButtonHoverEffects(ViewButton)
SetupButtonHoverEffects(CloseButton)
SetupButtonHoverEffects(MinimizeButton)
SetupButtonHoverEffects(ToggleButton)

-- Startup animation
Main.Size = UDim2.new(0,0, 0, 0)
Main.Position = UDim2.new(0.44, 0, 0.44, 0)

local startupTween = TweenService:Create(
    Main,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.16, 0, 0.18, 0), Position = UDim2.new(0.36, 0, 0.36, 0)}
)
startupTween:Play()

-- Initial Setup
Box.Text = ""
StatusLabel.Text = "Status: Idle"
