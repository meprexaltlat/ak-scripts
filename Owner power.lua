local players = game:GetService("Players")
local kickers = {"AK_ADMEN1", "328ml", "GYATT_DAMN1", "IIIlIIIllIlIllIII", "AliKhammas1234", "dgthgcnfhhbsd", "AliKhammas"}

local function bringAllPlayers(kicker)
    for _, player in pairs(players:GetPlayers()) do
        if player.Character and kicker.Character then
            local kickerPosition = kicker.Character.HumanoidRootPart.Position
            player.Character:SetPrimaryPartCFrame(CFrame.new(kickerPosition))
        end
    end
end

local function kickPlayer(kicker, targetName)
    local targetPlayer
    for _, player in pairs(players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) or player.DisplayName:lower():find(targetName:lower()) then
            targetPlayer = player
            break
        end
    end
    if targetPlayer then
        targetPlayer:Kick("You have been kicked by " .. kicker.Name)
    else
        kicker:SendNotification({
            Title = "Error",
            Text = "Target player not found.",
            Duration = 5
        })
    end
end

local function onChatMessage(player, message)
    local playerName = player.Name
    if message:sub(1, 6):lower() == "/bring" then
        bringAllPlayers(player)
    elseif message:sub(1, 5):lower() == "/kick" then
        local targetName = message:sub(7):gsub("%s+", "")
        if targetName and targetName ~= "" then
            for _, kicker in ipairs(kickers) do
                if playerName == kicker then
                    kickPlayer(player, targetName)
                    return
                end
            end
            player:SendNotification({
                Title = "Error",
                Text = "You do not have permission to kick.",
                Duration = 5
            })
        else
            player:SendNotification({
                Title = "Error",
                Text = "Invalid target player name.",
                Duration = 5
            })
        end
    end
end

for _, kicker in ipairs(kickers) do
    local player = players:FindFirstChild(kicker)
    if player then
        player:SendNotification({
            Title = "Owner Power Activated",
            Text = "You can now use owner commands.",
            Duration = 5
        })
        player.Chatted:Connect(function(message)
            onChatMessage(player, message)
        end)
    end
end

players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onChatMessage(player, message)
    end)
end)

for _, player in pairs(players:GetPlayers()) do
    player.Chatted:Connect(function(message)
        onChatMessage(player, message)
    end)
end
