
-- Configuration
local Config = {
    ANIMATION = {
        TOTAL_DURATION = 9,
        FADE_IN = 2,
        DISPLAY_TIME = 5,
        FADE_OUT = 2,
        BOUNCE_STRENGTH = 20,
        SPIN_SPEED = 360
    },
    SIZES = {
        INITIAL = UDim2.new(0, 0, 0, 0),
        DISPLAY = UDim2.new(0, 200, 0, 100),
        FINAL = UDim2.new(0, 250, 0, 125)
    },
    COLORS = {
        TITLE = Color3.fromRGB(180, 180, 180),
        SNOWFLAKE = Color3.fromRGB(255, 255, 255)
    },
    AUDIO = {
        ID = "rbxassetid://9046392150"
    },
    DECALS = {
        SNOWFLAKE = "http://www.roblox.com/asset/?id=5689866"
    },
    SNOWFALL = {
        AMOUNT = 30,
        SPEED = 0.01,
        MIN_SIZE = 100,
        MAX_SIZE = 150,
        START_DELAY = 0.6
    }
}

-- Services
local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting")
}

-- Create enhanced blur and lighting effects
local function createAtmosphere()
    local atmosphere = Instance.new("ColorCorrectionEffect")
    atmosphere.Parent = Services.Lighting
    atmosphere.Brightness = 0
    atmosphere.Contrast = 0
    atmosphere.TintColor = Color3.fromRGB(255, 255, 255)
    
    local blur = Instance.new("BlurEffect")
    blur.Parent = Services.Lighting
    blur.Size = 0
    
    return atmosphere, blur
end

-- Create snowfall effect
local function createSnowfall(parent)
    local snowflakes = {}
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Create multiple snowflakes
    for i = 1, Config.SNOWFALL.AMOUNT do
        local data = {
            speed = Config.SNOWFALL.SPEED,
            rotSpeed = math.random(-2, 2),
            currentX = math.random(), -- Random starting X position
            currentY = 0, -- All start at top
            swayOffset = math.random() * math.pi * 2,
            swayAmount = 0.001,
            isMoving = false -- Start not moving
        }
        
        local flake = Instance.new("ImageLabel")
        flake.Image = Config.DECALS.SNOWFLAKE
        
        local size = math.random(Config.SNOWFALL.MIN_SIZE, Config.SNOWFALL.MAX_SIZE)
        flake.Size = UDim2.new(0, size, 0, size)
        flake.Position = UDim2.new(data.currentX, 4555, data.currentY, 3555)
        flake.BackgroundTransparency = 1
        flake.ImageColor3 = Config.COLORS.SNOWFLAKE
        flake.ImageTransparency = 0.1
        flake.Parent = container
        flake.ZIndex = -5
        
        table.insert(snowflakes, {
            instance = flake,
            data = data
        })
    end
    
    -- Movement function
    local function updateSnowflakes()
        for _, snowflake in ipairs(snowflakes) do
            local flake = snowflake.instance
            local data = snowflake.data
            
            if data.isMoving then
                -- Update Y position (falling)
                data.currentY = data.currentY + data.speed
                
                -- Very slight X sway
                local sway = math.sin(tick() + data.swayOffset) * data.swayAmount
                
                -- Reset position if snowflake goes off screen
                if data.currentY > 1.2 then
                    data.currentY = -0.2
                    data.currentX = math.random()
                end
                
                flake.Position = UDim2.new(data.currentX + sway, 0, data.currentY, 0)
                flake.Rotation = (flake.Rotation + data.rotSpeed) % 360
            end
        end
    end
    
    -- Function to start snowfall with delay between each snowflake
    local function startSnowfall()
        for i, snowflake in ipairs(snowflakes) do
            task.delay(i * Config.SNOWFALL.START_DELAY, function()
                snowflake.data.isMoving = true
            end)
        end
    end
    
    return updateSnowflakes, startSnowfall, snowflakes
end

-- Create background snowflake
local function createBackgroundSnowflake(parent)
    local snowflake = Instance.new("ImageLabel")
    snowflake.Image = Config.DECALS.SNOWFLAKE
    snowflake.Size = UDim2.new(2, 0, 2, 0) -- Changed to maintain aspect ratio
    snowflake.Position = UDim2.new(0.5, 0, 0.5, 0)
    snowflake.AnchorPoint = Vector2.new(0.5, 0.5)
    snowflake.BackgroundTransparency = 1
    snowflake.ImageTransparency = 0.9
    snowflake.ImageColor3 = Config.COLORS.SNOWFLAKE
    snowflake.ZIndex = -1
    snowflake.Parent = parent
    snowflake.SizeConstraint = Enum.SizeConstraint.RelativeYY -- Added to maintain aspect ratio
    
    -- Update pulse animation sizes
    local function pulseAnimation()
        local TweenService = game:GetService("TweenService")
        
        local pulseOut = TweenService:Create(snowflake,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size = UDim2.new(2.2, 0, 2.2, 0)} -- Adjusted for aspect ratio
        )
        
        local pulseIn = TweenService:Create(snowflake,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size = UDim2.new(2, 0, 2, 0)} -- Adjusted for aspect ratio
        )
        
        pulseOut.Completed:Connect(function()
            pulseIn:Play()
        end)
        
        pulseIn.Completed:Connect(function()
            pulseOut:Play()
        end)
        
        pulseOut:Play()
    end
    
    pulseAnimation()
    return snowflake
end

-- Enhanced intro animation
local function playIntro()
    local atmosphere, blur = createAtmosphere()
    local connections = {}
    
    -- Create UI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = Services.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    local mainText = Instance.new("TextLabel")
    mainText.Size = Config.SIZES.INITIAL
    mainText.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainText.AnchorPoint = Vector2.new(0.5, 0.5)
    mainText.BackgroundTransparency = 1
    mainText.Font = Enum.Font.GothamBlack
    mainText.Text = "AK"
    mainText.TextColor3 = Config.COLORS.TITLE
    mainText.TextSize = 90
    mainText.TextTransparency = 1
    mainText.Parent = mainFrame
    
    local bgSnowflake = createBackgroundSnowflake(mainText)
    local updateSnowflakes, startSnowfall, snowflakes = createSnowfall(mainFrame)
    
    -- Animation sequence
    local function animate()
        -- Play audio
        local sound = Instance.new("Sound")
        sound.SoundId = Config.AUDIO.ID
        sound.Parent = workspace
        sound:Play()
        
        -- Add snowfall update connection
        table.insert(connections, Services.RunService.RenderStepped:Connect(updateSnowflakes))
        
        -- Make snowflakes visible and start them falling
        for _, snowflake in ipairs(snowflakes) do
            snowflake.instance.Visible = true
        end
        startSnowfall()
        
        -- Rotate background snowflake
        local function updateSnowflake()
            bgSnowflake.Rotation = (bgSnowflake.Rotation + 0.5) % 360
        end
        table.insert(connections, Services.RunService.RenderStepped:Connect(updateSnowflake))
        
        -- Initial bounce-in animation
        local bounceIn = Services.TweenService:Create(mainText,
            TweenInfo.new(Config.ANIMATION.FADE_IN, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
            {Size = Config.SIZES.DISPLAY, TextTransparency = 0}
        )
        bounceIn:Play()
        
        -- Fun hover animation
        task.wait(Config.ANIMATION.FADE_IN)
        
        local function hoverAnimation()
            local hoverUp = Services.TweenService:Create(mainText,
                TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Position = mainText.Position + UDim2.new(0, 0, -0.02, 0)}
            )
            
            local hoverDown = Services.TweenService:Create(mainText,
                TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Position = mainText.Position + UDim2.new(0, 0, 0.02, 0)}
            )
            
            hoverUp.Completed:Connect(function()
                hoverDown:Play()
            end)
            
            hoverDown.Completed:Connect(function()
                hoverUp:Play()
            end)
            
            hoverUp:Play()
        end
        
        hoverAnimation()
        
        -- Cleanup with fade out
        task.wait(Config.ANIMATION.DISPLAY_TIME)
        
        -- Fade out snowflakes first
        for _, snowflake in ipairs(snowflakes) do
            local fadeOutTween = Services.TweenService:Create(
                snowflake.instance,
                TweenInfo.new(Config.ANIMATION.FADE_OUT, Enum.EasingStyle.Linear),
                {ImageTransparency = 1}
            )
            fadeOutTween:Play()
        end
        
        -- Fade out main text
        local fadeOut = Services.TweenService:Create(mainText,
            TweenInfo.new(Config.ANIMATION.FADE_OUT, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {TextTransparency = 1, Size = Config.SIZES.FINAL, Rotation = 360}
        )
        fadeOut:Play()
        
        task.wait(Config.ANIMATION.FADE_OUT)
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        sound:Destroy()
        screenGui:Destroy()
    end
    
    animate()
end

-- Execute with error handling
local success, err = pcall(playIntro)
if not success then
    warn("Error during intro animation:", err)
end
