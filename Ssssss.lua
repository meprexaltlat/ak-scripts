local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local setclipboard = setclipboard or function() warn("Clipboard function not available") end

-- Utility functions
local function tween(inst, props, time)
    return TweenService:Create(inst, TweenInfo.new(time or 0.5, Enum.EasingStyle.Quart), props):Play()
end

local function new(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end

-- Sound effects setup using verified professional sounds
local function createSound(id, volume)
    local sound = new("Sound", {
        SoundId = "rbxassetid://" .. id,
        Volume = volume or 0.5,
        Parent = workspace
    })
    return sound
end

local sounds = {
    slideDown = createSound("12222200", 0.15),     -- Soft slide
    success = createSound("12222216", 0.25),       -- Clean success tone
    failure = createSound("12222225", 0.25),       -- Professional error
    slideUp = createSound("12222200", 0.15)        -- Soft slide
}

-- Cleanup existing GUI
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "PremiumAuthGui" then
        v:Destroy()
    end
end

-- Create main GUI
local gui = new("ScreenGui", {
    Name = "PremiumAuthGui",
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    Parent = CoreGui
})

-- Main container
local main = new("Frame", {
    Size = UDim2.new(0.4, 0, 0, 50),
    Position = UDim2.new(0.5, 0, -0.2, 0),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BackgroundTransparency = 0,
    Parent = gui
})

new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = main })
new("UIStroke", {
    Color = Color3.fromRGB(80, 80, 90),
    Thickness = 2,
    Transparency = 0,
    Parent = main
})

-- Player profile picture
local player = Players.LocalPlayer
local userId = player.UserId

local profilePic = new("ImageLabel", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 10, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundTransparency = 1,
    Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", userId),
    Parent = main
})

-- Text elements with initial transparency
local title = new("TextLabel", {
    Size = UDim2.new(1, -70, 0, 20),
    Position = UDim2.new(0.5, 20, 0, 3),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    Text = "AUTHORIZATION",
    TextTransparency = 1,
    Parent = main
})

local status = new("TextLabel", {
    Size = UDim2.new(1, -70, 0, 15),
    Position = UDim2.new(0.5, 20, 0, 25),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(200, 200, 200),
    TextSize = 16,
    Font = Enum.Font.GothamMedium,
    Text = "Verifying access...",
    TextTransparency = 1,
    Parent = main
})

-- Progress bar
local progressBg = new("Frame", {
    Size = UDim2.new(0.8, 0, 0, 3),
    Position = UDim2.new(0.5, 20, 1, -5),
    AnchorPoint = Vector2.new(0.5, 1),
    BackgroundColor3 = Color3.fromRGB(45, 45, 50),
    BackgroundTransparency = 0,
    Parent = main
})

new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progressBg })

local progress = new("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(90, 160, 255),
    BackgroundTransparency = 0,
    Parent = progressBg
})

new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = progress })

-- Animation sequence
local function animate()
    local scriptURL = "https://raw.githubusercontent.com/fjkdvbjkfvjkfbvjkfbvjkdfhdfjkhvuldfhv/deinemudda/refs/heads/main/deinemudda"

    -- Smooth slide down with sound
    sounds.slideDown:Play()
    tween(main, { Position = UDim2.new(0.5, 0, 0, 10) }, 1.2) -- Slower slide down
    task.wait(0.3)
    tween(title, { TextTransparency = 0 }, 0.4)
    task.wait(0.2)
    tween(status, { TextTransparency = 0 }, 0.4)
    tween(progress, { Size = UDim2.new(1, 0, 1, 0) }, 0.8)

    -- Check whitelist
    local whitelistURL = "https://raw.githubusercontent.com/AKadminlol/AK-ADMIN/refs/heads/main/AK%20ADMIN.json"

    local success, result = pcall(function()
        local response = game:HttpGet(whitelistURL)
        local data = HttpService:JSONDecode(response)
        return table.find(data.whitelisted or {}, player.Name) ~= nil
    end)

    task.wait(0.5) -- Brief pause before result

    if success and result then
        sounds.success:Play()
        status.Text = "Access Granted!"
        tween(status, { TextColor3 = Color3.fromRGB(100, 255, 150) }, 0.4)
        tween(progress, { BackgroundColor3 = Color3.fromRGB(100, 255, 150) }, 0.4)
        pcall(function()
            loadstring(game:HttpGet(scriptURL))()
        end)
    else
        sounds.failure:Play()
        status.Text = "Access Denied! Discord link copied."
        setclipboard("https://discord.com/invite/bgWY2zEV7z")
        tween(status, { TextColor3 = Color3.fromRGB(255, 100, 100) }, 0.4)
        tween(progress, { BackgroundColor3 = Color3.fromRGB(255, 100, 100) }, 0.4)
    end

    task.wait(1.5) -- Brief display time

    -- Smooth slide up with sound
    sounds.slideUp:Play()
    tween(main, { Position = UDim2.new(0.5, 0, -0.2, 0) }, 1) -- Slower slide up
    task.wait(1.1)
    gui:Destroy()
end

animate()
