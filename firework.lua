-- Optimized Firework Script - Place in StarterPlayerScripts (LocalScript)
-- This script will run once when the player joins the game to trigger a firework sequence.
-- It fixes the camera during the fireworks display and instantly restores it afterwards.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ToolEvent = ReplicatedStorage:WaitForChild("ToolEvent")
local DeleteInventoryEvent = ReplicatedStorage:WaitForChild("DeleteInventory")

local Camera = workspace.CurrentCamera

local function runFireworkScript()
    local plr = Players.LocalPlayer
    if not plr then return end

    local char = plr.Character or plr.CharacterAdded:Wait()
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("HumanoidRootPart not found in character. Firework script may not function correctly.")
        return
    end

    local oldCFrame = hrp.CFrame
    local originalCameraType = Camera.CameraType

    if ToolEvent then
        ToolEvent:FireServer("FireworkLaunch")
    else
        warn("ToolEvent not found in ReplicatedStorage. Firework launch may not be triggered.")
        return
    end

    Camera.CameraType = Enum.CameraType.Fixed

    hrp.CFrame = CFrame.new(oldCFrame.Position.X, oldCFrame.Position.Y - 170, oldCFrame.Position.Z)
    task.wait(1)

    local firework = plr.Backpack:FindFirstChild("FireworkLaunch")
    if firework then
        firework.Parent = char
        firework:Activate()
    else
        warn("FireworkLaunch tool not found in Backpack. Firework activation may fail.")
    end

    hrp.CFrame = oldCFrame -- Restore character position immediately
    Camera.CameraType = originalCameraType -- **Instantly restore camera type after teleporting back**

    task.wait(3.5) -- Wait for firework display to finish (camera is already restored)

    if DeleteInventoryEvent then
        DeleteInventoryEvent:FireServer()
    else
        warn("DeleteInventory event not found in ReplicatedStorage. Inventory may not be deleted.")
    end
end

print("Running Firework Script...")
runFireworkScript()
