-- LocalScript

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SwordName = "Sword"  -- Replace with the exact name of your sword tool
local ReachDistance = 300  -- Increase the reach distance to 300

local function hitPlayer(targetPlayer, sword)
    if targetPlayer ~= LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        local targetHumanoid = targetPlayer.Character.Humanoid
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        local distance = (targetHRP.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance <= ReachDistance then
            -- Run this in a separate thread to apply damage simultaneously
            spawn(function()
                -- Loop until the player's health is zero
                while targetHumanoid.Health > 0 do
                    -- Simulate the hit by creating a touch event
                    firetouchinterest(sword.Handle, targetHRP, 0)  -- Simulate touching the player
                    firetouchinterest(sword.Handle, targetHRP, 1)  -- Release the touch
                    wait(0.05)  -- Faster hit frequency
                end
            end)
        end
    end
end

local function increaseSwordDamage(sword)
    -- Assuming the sword has a "Damage" property, increase it
    local damageProperty = sword:FindFirstChild("Damage")  -- Replace "Damage" with the correct property name if it exists
    if damageProperty and damageProperty:IsA("NumberValue") then
        damageProperty.Value = math.huge  -- Set to a very high value to ensure a one-hit kill
    end
end

local function extendSwordReach()
    -- Get the sword from the player's backpack or character
    local sword = LocalPlayer.Backpack:FindFirstChild(SwordName) or LocalPlayer.Character:FindFirstChild(SwordName)

    if not sword then
        print("Sword not found!")
        return
    end

    -- Equip the sword if it's in the backpack
    if sword.Parent == LocalPlayer.Backpack then
        LocalPlayer.Character.Humanoid:EquipTool(sword)
    end

    -- Increase the sword's damage
    increaseSwordDamage(sword)

    -- Loop through all players and check if they are within reach, damaging them simultaneously
    for _, player in pairs(Players:GetPlayers()) do
        hitPlayer(player, sword)
    end
end

-- Call the function to extend sword reach and "hit" everyone within reach
extendSwordReach()
