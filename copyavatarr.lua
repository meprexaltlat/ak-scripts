local isCopying = false
local isCopyingNearest = false
local originalAvatar = nil -- To store the original avatar state

game.Players.LocalPlayer.Chatted:Connect(function(message)
    -- Check if the message starts with "!copy "
    if message:sub(1, 6) == "!copy " then
        -- Extract the command after "!copy "
        local command = message:sub(7)

        -- Command to copy all player usernames
        if command == "all" then
            if not isCopying then
                isCopying = true
                print("Started copying usernames of all players in the server.")

                -- Continuously copy all player usernames in a loop without any significant delay
                while isCopying do
                    for _, player in pairs(game.Players:GetPlayers()) do
                        game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(player.Name)
                    end

                    wait(0.05) -- Reduced wait time for faster copying (lowered to 0.05 seconds)
                end
            else
                warn("Already copying all usernames. Use '!uncopy' to stop.")
            end

        else
            -- Check for specific player name matching
            local found = false
            for _, v in pairs(game.Players:GetChildren()) do
                if v.Name:sub(1, #command):lower() == command:lower() or v.DisplayName:sub(1, #command):lower() == command:lower() then
                    game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(v.Name)
                    game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(v.DisplayName)
                    found = true
                end
            end

            if not found then
                warn("No player found with that name. Use '!copy all' to copy all usernames.")
            end
        end

    -- Command to stop all copying activities
    elseif message == "!uncopy" then
        -- Stop all ongoing copying activities immediately
        isCopying = false
        isCopyingNearest = false

        if isCopying or isCopyingNearest then
            print("Stopped all copying activities.")
        else
            warn("Not currently copying usernames or avatars.")
        end

    -- Command to start copying the nearest player's avatar
    elseif message == "!copynearest" then
        if not isCopyingNearest then
            isCopyingNearest = true
            print("Started copying the nearest player's avatar.")

            -- Store the original avatar before copying
            if not originalAvatar then
                originalAvatar = game.Players.LocalPlayer.CharacterAppearance
            end

            -- Continuously check for the nearest player, excluding the local player
            while isCopyingNearest do
                local closestPlayer = nil
                local closestDistance = math.huge

                -- Find the nearest player (excluding the local player)
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end

                -- If a closest player is found, send their username to the server
                if closestPlayer then
                    game:GetService("ReplicatedStorage").ModifyUserEvent:FireServer(closestPlayer.Name)
                end

                wait(0.05) -- Reduced wait time for faster checking (lowered to 0.05 seconds)
            end
        else
            warn("Already copying the nearest player's avatar. Use '!uncopy' to stop.")
        end
    end
end)
