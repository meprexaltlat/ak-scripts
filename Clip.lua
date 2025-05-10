-- Script to counteract the effects of the provided script

while true do
    for _, x in next, game:GetService("Players"):GetPlayers() do
        if x and x ~= game:GetService("Players").LocalPlayer and x.Character then
            pcall(function()
                for _, v in next, x.Character:GetChildren() do
                    if v:IsA("BasePart") then
                        v.CanCollide = true -- Re-enable CanCollide
                        if v.Name == "Torso" then
                            v.Massless = false -- Disable Massless for Torso
                        end
                        -- We don't need to set Velocity and RotVelocity to specific values,
                        -- as the physics engine will naturally handle them when CanCollide is true and Massless is false.
                        -- By not setting them to Vector3.new() every frame, we allow the game's physics to take over.
                    end
                end
            end)
        end
    end
    game:GetService("RunService").Stepped:wait()
end

-- To stop this script and the original script completely, you will likely need to:
-- 1. Close and restart the Roblox game.
-- 2. If you injected the original script using an exploit, you might be able to use the exploit's interface to stop script execution.
-- 3. Simply running this counter script might mitigate the effects of the original script, but both will still be running and potentially causing performance issues.
