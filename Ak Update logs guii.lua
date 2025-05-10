local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Constants for styling
local THEME = {
    PRIMARY_BACKGROUND = Color3.fromRGB(22, 27, 34),
    SECONDARY_BACKGROUND = Color3.fromRGB(30, 37, 46),
    ACCENT = Color3.fromRGB(88, 166, 255),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(201, 209, 217),
    DANGER = Color3.fromRGB(248, 81, 73),
    SUCCESS = Color3.fromRGB(63, 185, 80),
}

local FONTS = {
    TITLE = Enum.Font.GothamBlack,
    HEADING = Enum.Font.GothamBold,
    BODY = Enum.Font.GothamMedium,
}

local commands = {
    "+ Added cmd: !shapeshifter (only r6)"
    "+ Added cmd: !blockmap (look in the discord for the bundle)"
    -- Add more commands here
}

-- Utility functions
local function createTween(object, properties, duration)
    return TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
        properties
    )
end

-- Component creation functions
local function createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014543999"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(50, 50, 50, 50)
    shadow.Parent = parent
    return shadow
end

local function createCommandItem(command)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = THEME.SECONDARY_BACKGROUND
    container.BackgroundTransparency = 0.3
    container.Size = UDim2.new(1, 0, 0, 40)
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = container
    
    local iconContainer = Instance.new("Frame")
    iconContainer.BackgroundColor3 = THEME.SUCCESS
    iconContainer.Size = UDim2.new(0, 24, 0, 24)
    iconContainer.Position = UDim2.new(0, 12, 0.5, 0)
    iconContainer.AnchorPoint = Vector2.new(0, 0.5)
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconContainer
    
    local icon = Instance.new("TextLabel")
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.Font = FONTS.HEADING
    icon.Text = "+"
    icon.TextColor3 = THEME.TEXT_PRIMARY
    icon.TextSize = 16
    icon.Parent = iconContainer
    
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 48, 0, 0)
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Font = FONTS.BODY
    textLabel.Text = command:match("^%+ Added cmd: (.+)") or command
    textLabel.TextColor3 = THEME.TEXT_SECONDARY
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = container
    
    iconContainer.Parent = container
    
    -- Hover effects
    local function onHover()
        createTween(container, {BackgroundTransparency = 0.1}, 0.2):Play()
    end
    
    local function onUnhover()
        createTween(container, {BackgroundTransparency = 0.3}, 0.2):Play()
    end
    
    container.MouseEnter:Connect(onHover)
    container.MouseLeave:Connect(onUnhover)
    
    return container
end

-- Main GUI creation
local function createUpdateLogGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "EnhancedUpdateLogGui"
    gui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = THEME.PRIMARY_BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, 0, 0, 20)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.Size = UDim2.new(0, 500, 0, 0) -- Height will be set dynamically
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Create shadow
    createShadow(mainFrame)
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = THEME.SECONDARY_BACKGROUND
    header.BackgroundTransparency = 0.5
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 24, 0, 0)
    title.Size = UDim2.new(1, -48, 1, 0)
    title.Font = FONTS.TITLE
    title.Text = "Update Log"
    title.TextColor3 = THEME.TEXT_PRIMARY
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.BackgroundColor3 = THEME.DANGER
    closeButton.BackgroundTransparency = 0.9
    closeButton.Position = UDim2.new(1, -44, 0, 14)
    closeButton.Size = UDim2.new(0, 32, 0, 32)
    closeButton.Font = FONTS.HEADING
    closeButton.Text = "×"
    closeButton.TextColor3 = THEME.DANGER
    closeButton.TextSize = 24
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 24, 0, 72)
    contentContainer.Size = UDim2.new(1, -48, 1, -84)
    contentContainer.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = contentContainer
    
    -- Add commands
    for _, command in ipairs(commands) do
        local commandItem = createCommandItem(command)
        commandItem.Parent = contentContainer
    end
    
    -- Calculate and set frame height
    local contentHeight = (#commands * 48) + ((#commands - 1) * 8) -- Item height + padding
    local frameHeight = contentHeight + 96 -- Add header height and padding
    mainFrame.Size = UDim2.new(0, 500, 0, math.clamp(frameHeight, 180, 600))
    
    -- Animations and effects
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
    
    local function animateIn()
        mainFrame.Position = UDim2.new(1.5, 0, 0, 20)
        mainFrame.Parent = gui
        createTween(mainFrame, {Position = UDim2.new(0.5, 0, 0, 20)}, 0.6):Play()
        createTween(blur, {Size = 20}, 0.6):Play()
    end
    
    local function animateOut()
        local outTween = createTween(mainFrame, {Position = UDim2.new(-0.5, 0, 0, 20)}, 0.6)
        local blurTween = createTween(blur, {Size = 0}, 0.6)
        
        outTween:Play()
        blurTween:Play()
        
        blurTween.Completed:Connect(function()
            blur:Destroy()
            gui:Destroy()
        end)
    end
    
    -- Close button effects
    closeButton.MouseEnter:Connect(function()
        createTween(closeButton, {BackgroundTransparency = 0.7}, 0.2):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        createTween(closeButton, {BackgroundTransparency = 0.9}, 0.2):Play()
    end)
    
    closeButton.MouseButton1Click:Connect(animateOut)
    
    -- Initialize
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    animateIn()
    
    return gui
end

-- Create the GUI
createUpdateLogGui()
