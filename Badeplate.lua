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
secondBaseplate.Transparency = 1 -- Invisible baseplate
secondBaseplate.Parent = game.Workspace

-- Smooth surface for the baseplate
secondBaseplate.TopSurface = Enum.SurfaceType.Smooth
secondBaseplate.BottomSurface = Enum.SurfaceType.Smooth

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BaseplateToggleGUI"
screenGui.ResetOnSpawn = false -- Don't reset GUI on respawn
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the smaller toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40) -- Smaller size
toggleButton.Position = UDim2.new(0.1, 0, 0.9, 0)
toggleButton.Text = "Toggle Baseplate"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

-- Styling for curved corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleButton

-- Make the button draggable
local dragging
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- Noclip functionality (disable collision for character parts)
local function noclipUpdate()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = (part == secondBaseplate) -- Only enable collision with second baseplate
        end
    end
end

-- Clear any existing velocity and force-related objects
local function clearForces()
    for _, child in pairs(humanoidRootPart:GetChildren()) do
        if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyPosition") then
            child:Destroy() -- Remove any forces that could push the player up
        end
    end
end

-- Slowly float the player upwards
local function floatUp()
    clearForces() -- Remove any existing forces before applying new ones

    -- Apply a BodyVelocity to float the player upwards
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 2, 0) -- Adjusted to float upwards at a slower speed
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Only affect the Y axis
    bodyVelocity.Parent = humanoidRootPart

    -- Automatically remove BodyVelocity after a short delay to stop floating
    game:GetService("Debris"):AddItem(bodyVelocity, 2) -- Float for 2 seconds
end

-- Store deleted parts to restore them later
local deletedParts = {}

-- Delete all parts on the second baseplate and store them for restoration
local function deletePartsOnBaseplate()
    for _, part in pairs(game.Workspace:GetChildren()) do
        if part:IsA("BasePart") and part ~= secondBaseplate and part.Position.Y <= secondBaseplate.Position.Y + 1 then
            table.insert(deletedParts, part)
            part.Parent = nil -- Temporarily remove parts
        end
    end
end

-- Restore all parts that were deleted from the second baseplate
local function restorePartsOnBaseplate()
    for _, part in pairs(deletedParts) do
        part.Parent = game.Workspace -- Restore parts
    end
    deletedParts = {} -- Clear deleted parts table
end

-- Toggle baseplate visibility and handle floating
local baseplateVisible = true

toggleButton.MouseButton1Click:Connect(function()
    baseplateVisible = not baseplateVisible
    if baseplateVisible then
        -- On first toggle: teleport to the baseplate and disable jumping
        secondBaseplate.Transparency = 1 -- Invisible baseplate
        secondBaseplate.CanCollide = true
        deletePartsOnBaseplate() -- Remove interfering parts
        clearForces() -- Ensure no external forces are affecting the character
    else
        -- On second toggle: enable noclip and float the player up
        restorePartsOnBaseplate() -- Restore deleted parts
        floatUp() -- Slowly float up
        noclipUpdate() -- Enable noclip while floating
    end
end)

-- Continuously ensure the player can noclip through everything except second baseplate
game:GetService("RunService").Stepped:Connect(function()
    noclipUpdate()
end)

-- Handle respawn and reapply changes
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")

    -- Reapply noclip, baseplate behavior, and jumping behavior after respawn
    noclipUpdate()
    clearForces()
end

-- Connect respawn event
player.CharacterAdded:Connect(onCharacterAdded)
