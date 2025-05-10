local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Create a large second baseplate (invisible)
local secondBaseplatePosition = Vector3.new(108.033035, -6, -24.9428463)
local secondBaseplate = Instance.new("Part")
secondBaseplate.Size = Vector3.new(1024, 1, 1024)
secondBaseplate.Position = secondBaseplatePosition
secondBaseplate.Anchored = true
secondBaseplate.Name = "SecondBaseplate"
secondBaseplate.BrickColor = BrickColor.new("Medium green")
secondBaseplate.Material = Enum.Material.Grass
secondBaseplate.CanCollide = true
secondBaseplate.Transparency = 1
secondBaseplate.Parent = game.Workspace

-- Smooth surface for the baseplate
secondBaseplate.TopSurface = Enum.SurfaceType.Smooth
secondBaseplate.BottomSurface = Enum.SurfaceType.Smooth

-- Create the invisible barrier above the player
local invisibleBarrier = Instance.new("Part")
invisibleBarrier.Size = Vector3.new(1024, 5, 1024) -- thick enough to block the player
invisibleBarrier.Anchored = true
invisibleBarrier.CanCollide = true -- blocks player movement when floating down
invisibleBarrier.Transparency = 1
invisibleBarrier.Name = "InvisibleBarrier"
invisibleBarrier.Parent = game.Workspace

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BaseplateControlGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create a frame for GUI elements
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 120)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)  -- Adjust starting position for better visibility
frame.BackgroundTransparency = 0.25
frame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(45, 45, 45)
frame.Parent = screenGui

-- Add a UI corner for rounded edges
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Enable frame drag functionality
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, mousePos, framePos

local function updateInput(input)
    local delta = input.Position - mousePos
    frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Make professional GUI elements
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 160, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Baseplate Control"
titleLabel.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = frame

local titleLabelCorner = Instance.new("UICorner")
titleLabelCorner.CornerRadius = UDim.new(0, 10)
titleLabelCorner.Parent = titleLabel

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 30)
toggleButton.Position = UDim2.new(0.5, -70, 0.3, 0)
toggleButton.Text = "Sneak Up"
toggleButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = frame

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0, 8)
toggleButtonCorner.Parent = toggleButton

local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0, 60, 0, 30)
upButton.Position = UDim2.new(0.25, -30, 0.7, 0)
upButton.Text = "↑"
upButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
upButton.TextSize = 20
upButton.Font = Enum.Font.SourceSansBold
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.Parent = frame

local upButtonCorner = Instance.new("UICorner")
upButtonCorner.CornerRadius = UDim.new(0, 8)
upButtonCorner.Parent = upButton

local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0, 60, 0, 30)
downButton.Position = UDim2.new(0.75, -30, 0.7, 0)
downButton.Text = "↓"
downButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
downButton.TextSize = 20
downButton.Font = Enum.Font.SourceSansBold
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.Parent = frame

local downButtonCorner = Instance.new("UICorner")
downButtonCorner.CornerRadius = UDim.new(0, 8)
downButtonCorner.Parent = downButton

-- Function to move the baseplate up
local function moveBaseplateUp()
    if not isFloatingUp then  -- Only move baseplate when floating down
        secondBaseplate.Position = secondBaseplate.Position + Vector3.new(0, 1, 0) -- Adjust step as needed
    end
end

-- Function to move the baseplate down
local function moveBaseplateDown()
    if not isFloatingUp then  -- Only move baseplate when floating down
        secondBaseplate.Position = secondBaseplate.Position - Vector3.new(0, 1, 0) -- Adjust step as needed
    end
end

-- Connect buttons to functions
upButton.MouseButton1Click:Connect(moveBaseplateUp)
downButton.MouseButton1Click:Connect(moveBaseplateDown)

-- Function to disable jumping while floating down
local function disableJump()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
end

-- Function to enable jumping while floating up
local function enableJump()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end

-- Float functionality
local function clearForces()
    for _, child in pairs(humanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyPosition") then
            child:Destroy()
        end
    end
end

local function noclipUpdate()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function float(up)
    noclipUpdate()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, up and 2 or -2, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = humanoidRootPart
    game:GetService("Debris"):AddItem(bodyVelocity, 2)
end

local isFloatingUp = false  -- Start with "Sneak Up" (floating down initially)

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    isFloatingUp = not isFloatingUp
    if isFloatingUp then
        toggleButton.Text = "Sneak Down"  -- Change the text to "Sneak Down" when floating up
        enableJump()                      -- Enable jumping when floating up
        float(true)
        local existingBarrier = game.Workspace:FindFirstChild("InvisibleBarrier")
        if existingBarrier then
            existingBarrier:Destroy()  -- Remove invisible barrier when floating up
        end
    else
        toggleButton.Text = "Sneak Up"  -- Change text back to "Sneak Up" when floating down
        disableJump()                   -- Disable jumping when floating down
        float(false)
        if not game.Workspace:FindFirstChild("InvisibleBarrier") then
            invisibleBarrier = Instance.new("Part")
            invisibleBarrier.Size = Vector3.new(1024, 5, 1024)
            invisibleBarrier.Anchored = true
            invisibleBarrier.CanCollide = true  -- Ensure it blocks player movement when floating down
            invisibleBarrier.Transparency = 1
            invisibleBarrier.Name = "InvisibleBarrier"
            invisibleBarrier.Parent = game.Workspace
        end
    end
end)

-- Update the position of the invisible barrier above the player
game:GetService("RunService").Stepped:Connect(function()
    noclipUpdate()
    local existingBarrier = game.Workspace:FindFirstChild("InvisibleBarrier")
    if existingBarrier then
        existingBarrier.Position = humanoidRootPart.Position + Vector3.new(0, 5, 0)
    end
end)

-- Handle respawn and reapply changes with updated float function
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    clearForces()
    noclipUpdate()
    if isFloatingUp then
        enableJump()
        float(true)
    else
        disableJump()
        float(false)
    end
end

-- Connect respawn event
player.CharacterAdded:Connect(onCharacterAdded)

-- Start by floating the player down (disable jumping when floating down)
disableJump()
float(false)
