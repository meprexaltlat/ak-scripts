-- Ensure this script runs in a LocalScript

-- Load the Clone Illusion animation
local Anim = Instance.new("Animation")
Anim.AnimationId = "rbxassetid://215384594"  -- Animation ID for Clone Illusion

-- Define the humanoid and animation track outside the function to reuse
local player = game.Players.LocalPlayer

-- Function to display a notification
local function notify(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Notification";
        Text = message;
        Duration = 5;
    })
end

-- Check if the player's character is R6
local function isR6(character)
    return character:FindFirstChild("Torso") and character:FindFirstChild("Left Arm")
end

-- Function to start the animation
local function startCloneIllusion(track)
    print("Starting Clone Illusion")  -- Debug print
    track:Play(.5, 1, 1e7)  -- Play the animation in a loop
end

-- Function to stop the animation
local function stopCloneIllusion(track)
    print("Stopping Clone Illusion")  -- Debug print
    track:Stop()  -- Stop the animation
end

-- Function to add smooth spinning
local function addSpinning(character, speed)
    local torso = character:WaitForChild("Torso")
    
    -- Check if a spinner already exists, remove it
    local existingSpinner = torso:FindFirstChild("BodyAngularVelocity")
    if existingSpinner then
        existingSpinner:Destroy()
    end

    -- Add a new BodyAngularVelocity to make the character spin
    local spinner = Instance.new("BodyAngularVelocity")
    spinner.AngularVelocity = Vector3.new(0, speed, 0)  -- Spin on the Y-axis
    spinner.MaxTorque = Vector3.new(0, math.huge, 0)    -- Allow unlimited rotation torque on the Y-axis
    spinner.P = 1250                                    -- Smooth out the rotation
    spinner.Parent = torso
end

-- Initialize the script
local function initialize()
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Check if the character is in R6
    if not isR6(character) then
        notify("You need to be in R6 to use Clone Illusion.")
        return -- Stop executing the script if not R6
    end
    
    local humanoid = character:WaitForChild("Humanoid")
    local track = humanoid:LoadAnimation(Anim)
    
    -- Start the animation and spinning immediately when the script runs
    startCloneIllusion(track)
    addSpinning(character, 100) -- Start spinning with speed 100

    -- Function to handle the chat command
    local function onChatted(message)
        -- Check if the message is a command
        if message:sub(1, 1) == "!" then
            local command = message:lower()
            if command == "!unclone" then
                stopCloneIllusion(track)
                -- Stop spinning
                local torso = character:FindFirstChild("Torso")
                if torso then
                    local spinner = torso:FindFirstChild("BodyAngularVelocity")
                    if spinner then
                        spinner:Destroy()
                    end
                end
            end
        end
    end

    -- Connect the onChatted function to the player's Chatted event
    player.Chatted:Connect(onChatted)
    
    -- Handling character respawn to reinitialize the humanoid and track
    player.CharacterAdded:Connect(function(char)
        if not isR6(char) then
            notify("You need to be in R6 to use Clone Illusion.")
            return -- Stop executing the script if not R6
        end

        humanoid = char:WaitForChild("Humanoid")
        track = humanoid:LoadAnimation(Anim)
        startCloneIllusion(track)  -- Restart the animation upon character respawn
        addSpinning(char, 100)    -- Restart spinning upon respawn
    end)
end

-- Run the initialization function
initialize()
