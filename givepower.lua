local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer -- Script executor

local warnCommand = '/warns'
local spamWarnCommand = '/spamwarns'
local unspamCommand = '/unspam'
local givePowerCommand = '/givepower'
local removePowerCommand = '/removepower'
local cmdsCommand = '/cmds'
local silentChatCommand = '/silentchat'
local loudChatCommand = '/loudchat'

local playersWithPower = {}
local activeSpamWarns = {}
local blacklist = {}
local maxAttempts = 4
local notificationLimit = 100
local notificationInterval = 0.1
local oldChat = false
local isSilent = false -- New variable to control chat behavior

-- Check if the old chat system is being used
if ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents') then
    oldChat = true
end

-- Function to send a message
local function Chat(msg, player)
    if not isSilent then -- Check if chat is not in silent mode
        if oldChat then
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        else
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
        end
    end
end

-- Function to find a player by partial name (must match start of display name or username)
local function findPlayerByPartialName(partialName)
    partialName = string.lower(partialName)
    for _, player in ipairs(Players:GetPlayers()) do
        local displayNameLower = string.lower(player.DisplayName)
        local usernameLower = string.lower(player.Name)

        if displayNameLower:sub(1, #partialName) == partialName or usernameLower:sub(1, #partialName) == partialName then
            return player
        end
    end
    return nil
end

-- Function to spam warn all players
local function spamWarnAll(player)
    while activeSpamWarns[player.Name] do
        local sentNotifications = 0
        for _, victimPlayer in ipairs(Players:GetPlayers()) do
            if not activeSpamWarns[player.Name] then return end

            if sentNotifications < notificationLimit then
                ReplicatedStorage.Notification.PlayerSelectedEvent:FireServer(victimPlayer.Name)
                sentNotifications = sentNotifications + 1
            else
                break
            end
        end
        wait(notificationInterval)
    end
end

-- Function to spam warn a specific player
local function spamWarnPlayer(player, targetPlayer)
    while activeSpamWarns[targetPlayer.Name] do
        local sentNotifications = 0
        if sentNotifications < notificationLimit then
            ReplicatedStorage.Notification.PlayerSelectedEvent:FireServer(targetPlayer.Name)
            sentNotifications = sentNotifications + 1
        end
        wait(notificationInterval)
    end
end

-- Function to track blacklist attempts
local function trackBlacklist(player)
    if not blacklist[player.Name] then
        blacklist[player.Name] = { attempts = 0, isBlacklisted = false }
    end

    local data = blacklist[player.Name]
    data.attempts = data.attempts + 1

    if data.attempts >= maxAttempts then
        data.isBlacklisted = true
        Chat("🚫 You have been blacklisted, " .. player.DisplayName .. ".", player)
        Chat(player.DisplayName .. " has been blacklisted for unauthorized command usage.", player)
    else
        Chat("❌ " .. player.DisplayName .. ", you are not authorized to use this command. Attempt " .. data.attempts .. "/" .. maxAttempts .. ".", player)
    end
end

-- Function to handle chat commands (only detect exact commands)
local function onPlayerChatted(player, message)
    if blacklist[player.Name] and blacklist[player.Name].isBlacklisted then return end

    -- Only process messages that start with an exact matching command
    local args = message:split(" ")
    local command = string.lower(args[1])

    -- Filter to only handle the exact predefined commands
    local validCommands = {
        [string.lower(warnCommand)] = true,
        [string.lower(spamWarnCommand)] = true,
        [string.lower(unspamCommand)] = true,
        [string.lower(givePowerCommand)] = true,
        [string.lower(removePowerCommand)] = true,
        [string.lower(cmdsCommand)] = true,
        [string.lower(silentChatCommand)] = true,
        [string.lower(loudChatCommand)] = true
    }

    if not validCommands[command] then
        return -- Ignore all other messages/commands that are not in the list
    end

    -- Silent chat command
    if command == string.lower(silentChatCommand) and player == localPlayer then
        isSilent = true
        Chat("🔕 Silent chat mode activated.", player) -- Optional notification
        return

    -- Loud chat command
    elseif command == string.lower(loudChatCommand) and player == localPlayer then
        isSilent = false
        Chat("🔊 Loud chat mode activated.", player) -- Optional notification
        return
    end

    -- Give power command (only the script executor can use)
    if command == string.lower(givePowerCommand) and player == localPlayer and args[2] then
        local targetPlayer = findPlayerByPartialName(args[2])
        if targetPlayer then
            if not playersWithPower[targetPlayer.Name] then
                playersWithPower[targetPlayer.Name] = true
                Chat("✨ " .. targetPlayer.DisplayName .. " has been given power by " .. player.DisplayName .. ".", targetPlayer)
                Chat("Type '/cmds' to see your available commands.", targetPlayer)
            else
                Chat("⚠️ " .. targetPlayer.DisplayName .. " already has power.", player)
            end
        else
            Chat("❌ Player not found: " .. args[2], player)
        end

    -- Remove power command (only the script executor can use)
    elseif command == string.lower(removePowerCommand) and player == localPlayer and args[2] then
        local targetPlayer = findPlayerByPartialName(args[2])
        if targetPlayer then
            if playersWithPower[targetPlayer.Name] then
                playersWithPower[targetPlayer.Name] = nil
                Chat("⚡ " .. targetPlayer.DisplayName .. " has had their power removed by " .. player.DisplayName .. ".", targetPlayer)
            else
                Chat("❌ " .. targetPlayer.DisplayName .. " does not have power.", player)
            end
        else
            Chat("❌ Player not found: " .. args[2], player)
        end

    -- Warn command
    elseif command == string.lower(warnCommand) then
        if playersWithPower[player.Name] then
            if args[2] == "all" then
                for _, victimPlayer in ipairs(Players:GetPlayers()) do
                    ReplicatedStorage.Notification.PlayerSelectedEvent:FireServer(victimPlayer.Name)
                end
                Chat("⚠️ You warned everyone in the server.", player)
            elseif args[2] then
                local victimPlayer = findPlayerByPartialName(args[2])
                if victimPlayer then
                    ReplicatedStorage.Notification.PlayerSelectedEvent:FireServer(victimPlayer.Name)
                    Chat("⚠️ You warned " .. victimPlayer.DisplayName .. ".", player)
                else
                    Chat("❌ Player not found: " .. args[2], player)
                end
            else
                Chat("⚠️ Specify a player to warn or use '/warns all' to warn everyone.", player)
            end
        else
            trackBlacklist(player)
        end

    -- Spam warn command
    elseif command == string.lower(spamWarnCommand) then
        if playersWithPower[player.Name] then
            if args[2] == "all" then
                if not activeSpamWarns[player.Name] then
                    activeSpamWarns[player.Name] = true
                    Chat("⚡ You are now spam-warning all players.", player)
                    spamWarnAll(player)
                else
                    Chat("⚠️ You are already spam-warning all players.", player)
                end
            elseif args[2] then
                local targetPlayer = findPlayerByPartialName(args[2])
                if targetPlayer then
                    if not activeSpamWarns[targetPlayer.Name] then
                        activeSpamWarns[targetPlayer.Name] = true
                        Chat("⚡ You are now spam-warning " .. targetPlayer.DisplayName .. ".", player)
                        spamWarnPlayer(player, targetPlayer)
                    else
                        Chat("⚠️ " .. targetPlayer.DisplayName .. " is already being spam-warned.", player)
                    end
                else
                    Chat("❌ Player not found: " .. args[2], player)
                end
            end
        else
            trackBlacklist(player)
        end

    -- Unspam command
    elseif command == string.lower(unspamCommand) then
        if playersWithPower[player.Name] then
            if args[2] then
                local targetPlayer = findPlayerByPartialName(args[2])
                if targetPlayer and activeSpamWarns[targetPlayer.Name] then
                    activeSpamWarns[targetPlayer.Name] = false
                    Chat("⛔ You stopped spam-warning " .. targetPlayer.DisplayName .. ".", player)
                elseif targetPlayer then
                    Chat("⚠️ " .. targetPlayer.DisplayName .. " is not being spam-warned.", player)
                else
                    Chat("❌ Player not found: " .. args[2], player)
                end
            elseif activeSpamWarns[player.Name] then
                activeSpamWarns[player.Name] = false
                Chat("⛔ You have stopped all spam-warnings.", player)
            end
        else
            trackBlacklist(player)
        end

    -- Cmds command (List available commands)
    elseif command == string.lower(cmdsCommand) and playersWithPower[player.Name] then
        Chat("📜 Your available commands:\n📜 /warns [player]\n📜 /warns all\n📜 /spamwarns all\n📜 /spamwarns [player]\n📜 /unspam\n📜 /unspam [player]\n📜", player)
    else
        trackBlacklist(player)
    end
end

-- Connect the Chatted event handler for all current players
for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(message) onPlayerChatted(player, message) end)
end

-- Connect the Chatted event handler for players joining later
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message) onPlayerChatted(player, message) end)
end)

-- Give power to the script executor (local player)
playersWithPower[localPlayer.Name] = true
Chat("✨ You have been granted power automatically.", localPlayer)
