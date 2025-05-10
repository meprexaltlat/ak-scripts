-- Store the player and initial position
for _, b in pairs(Workspace:GetChildren()) do
    if b.Name == game.Players.LocalPlayer.Name then
        for _, v in pairs(Workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4, 3, 221)

local player = game.Players.LocalPlayer
local initialPosition = player.Character and player.Character:WaitForChild("HumanoidRootPart").Position

-- Control variables
local scriptActive = true
local firingInterval = 0.00000000000000001 -- Set to very low for max firing speed
local batchSize = 100000 -- Number of prompts to fire per cycle
local floatingActive = false -- Flag to manage floating state
local unannoyExecuted = false -- Flag to prevent multiple reset after /unannoy

-- Store original walk speed and jump power
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Tweening Service
local TweenService = game:GetService("TweenService")

-- Function to fire large batches of proximity prompts named "Activate" for other players only, with ultra-high frequency
local function fireOtherPlayersPrompts()
    while scriptActive do
        local promptsToFire = {}
        
        for _, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Name == "Activate" and not v:IsDescendantOf(player.Character) then
                table.insert(promptsToFire, v)
                
                -- Stop searching when batch size is reached
                if #promptsToFire >= batchSize then 
                    break
                end
            end
        end

        -- Fire each prompt in the batch
        for _, prompt in ipairs(promptsToFire) do
            fireproximityprompt(prompt)
            print("Fired proximity prompt at:", prompt.Parent.Name) -- Debug output
        end

        wait(firingInterval) -- Dynamic firing interval based on UI setting
    end
end

-- Function to reset the player every 9 seconds
local function resetPlayer()
    while scriptActive do
        wait(9) -- Wait for 9 seconds before resetting
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character:FindFirstChild("Humanoid").Health = 0
        end
    end
end

-- Function to float back to the initial position after respawn
local function floatBackToInitialPosition()
    player.CharacterAdded:Connect(function()
        if not scriptActive then return end -- Prevent floating if script is deactivated
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Set target position and create a tween to smoothly move back
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear) -- 2 seconds for smooth float-back
        local goal = {CFrame = CFrame.new(initialPosition)}
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)

        tween:Play() -- Start the tween to float back

        -- Once the tween completes, anchor the player
        tween.Completed:Connect(function()
            humanoidRootPart.Anchored = true
            floatingActive = true -- Set floating state to true
        end)
    end)
end

-- Function to freeze the player in place
local function freezePlayer()
    while scriptActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
        local humanoidRootPart = player.Character.HumanoidRootPart
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        -- Lock the player in the initial position
        humanoidRootPart.CFrame = CFrame.new(initialPosition)
        humanoidRootPart.Anchored = true
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)

        -- Disable any movement inputs
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end

        wait(0.01) -- Frequent update for strict immobility
    end
end

-- Function to stop all script activities
local function stopScriptFunctions()
    -- Restore player movement
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.JumpPower = originalJumpPower
        end

        -- Stop floating if it is active
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Anchored = false -- Allow normal movement
            floatingActive = false -- Set floating state to false
        end
    end

    scriptActive = false -- Stop other script activities
    print("Script deactivated.") -- Confirmation message

    -- Reset player once after deactivation
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character:FindFirstChild("Humanoid").Health = 0
    end
end

-- Listen for "/unannoy" command in chat to turn off the script
local function setupChatCommand()
    game.Players.LocalPlayer.Chatted:Connect(function(message)
        if message:lower() == "/unannoy" and scriptActive and not unannoyExecuted then
            unannoyExecuted = true -- Prevent multiple executions
            stopScriptFunctions()  -- Ensure all running functions stop
        end
    end)
end

-- Start the float-back, prompt firing, and reset functions
floatBackToInitialPosition()
spawn(fireOtherPlayersPrompts)
spawn(resetPlayer)
spawn(freezePlayer)

-- Initialize chat command listener
setupChatCommand()
