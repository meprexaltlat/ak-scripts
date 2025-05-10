local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local function teleportToMouse()
    local character = Player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local mousePosition = Mouse.Hit.Position
            humanoidRootPart.CFrame = CFrame.new(mousePosition + Vector3.new(0, 3, 0))
        end
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
        teleportToMouse()
    end
end)
