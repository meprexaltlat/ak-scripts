local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Create a lighter blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.IgnoreGuiInset = true

-- Background gradient
local backgroundGradient = Instance.new("Frame")
backgroundGradient.Parent = screenGui
backgroundGradient.Size = UDim2.new(1, 0, 1, 0)
backgroundGradient.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
backgroundGradient.BackgroundTransparency = 1

local gradientEffect = Instance.new("UIGradient")
gradientEffect.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
})
gradientEffect.Rotation = 45
gradientEffect.Parent = backgroundGradient

-- Main frame
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 200)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 20)
frameCorner.Parent = frame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = frame
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Choose Platform"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.new(1, 1, 1)

-- Mobile button
local mobileButton = Instance.new("TextButton")
mobileButton.Parent = frame
mobileButton.Size = UDim2.new(0.4, 0, 0, 40)
mobileButton.Position = UDim2.new(0.1, 0, 0.55, 0)
mobileButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
mobileButton.BackgroundTransparency = 0.4
mobileButton.Text = "Mobile"
mobileButton.Font = Enum.Font.GothamBold
mobileButton.TextSize = 18
mobileButton.TextColor3 = Color3.new(1, 1, 1)
mobileButton.TextTransparency = 0

local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 10)
mobileCorner.Parent = mobileButton

-- PC button
local pcButton = Instance.new("TextButton")
pcButton.Parent = frame
pcButton.Size = UDim2.new(0.4, 0, 0, 40)
pcButton.Position = UDim2.new(0.55, 0, 0.55, 0)
pcButton.BackgroundColor3 = Color3.fromRGB(200, 50, 100)
pcButton.BackgroundTransparency = 0.4
pcButton.Text = "PC"
pcButton.Font = Enum.Font.GothamBold
pcButton.TextSize = 18
pcButton.TextColor3 = Color3.new(1, 1, 1)
pcButton.TextTransparency = 0

local pcCorner = Instance.new("UICorner")
pcCorner.CornerRadius = UDim.new(0, 10)
pcCorner.Parent = pcButton

-- Fade-out function
local function fadeOutGui(callback)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    -- Elements that need background transparency fade
    local backgroundElements = {backgroundGradient, frame, mobileButton, pcButton}
    for _, element in ipairs(backgroundElements) do
        TweenService:Create(element, tweenInfo, {BackgroundTransparency = 1}):Play()
    end

    -- Elements that need text transparency fade
    local textElements = {titleLabel, mobileButton, pcButton}
    for _, element in ipairs(textElements) do
        TweenService:Create(element, tweenInfo, {TextTransparency = 1}):Play()
    end

    -- Fade out the blur effect
    local blurTween = TweenService:Create(blur, tweenInfo, {Size = 0})
    blurTween:Play()

    delay(0.6, function()
        callback()
        screenGui:Destroy()
        blur:Destroy()
    end)
end

-- Button click handlers
mobileButton.MouseButton1Click:Connect(function()
    fadeOutGui(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OBaqt1nbJz1NipM92jv/6qQE2IF1FGovyLEEepBn/refs/heads/main/supermanfly.luau"))()
    end)
end)

pcButton.MouseButton1Click:Connect(function()
    fadeOutGui(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OBaqt1nbJz1NipM92jv/6qQE2IF1FGovyLEEepBn/refs/heads/main/supermanflyjj.lua"))()
    end)
end)

-- Initial fade-in animation
local function initializeFadeIn()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    -- Set initial transparency
    backgroundGradient.BackgroundTransparency = 1
    frame.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    mobileButton.BackgroundTransparency = 1
    mobileButton.TextTransparency = 1
    pcButton.BackgroundTransparency = 1
    pcButton.TextTransparency = 1

    -- Fade in elements
    TweenService:Create(backgroundGradient, tweenInfo, {BackgroundTransparency = 0.7}):Play()
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.3}):Play()
    TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(mobileButton, tweenInfo, {BackgroundTransparency = 0.4, TextTransparency = 0}):Play()
    TweenService:Create(pcButton, tweenInfo, {BackgroundTransparency = 0.4, TextTransparency = 0}):Play()

    -- Blur effect fade-in
    local blurTween = TweenService:Create(blur, tweenInfo, {Size = 6})
    blurTween:Play()
end

-- Start fade-in
initializeFadeIn()
