local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local totalNotifications = 999999 -- Total number of notifications to send (very high number)
local notificationLimit = 100 -- Set the maximum number of notifications per cycle

local sentNotifications = 0 -- Track how many notifications have been sent

while sentNotifications < totalNotifications do
    local count = 0
    for _, player in pairs(players:GetPlayers()) do
        if sentNotifications < totalNotifications and count < notificationLimit then
            ReplicatedStorage.Notification.PlayerSelectedEvent:FireServer(player.Name)
            sentNotifications = sentNotifications + 1
            count = count + 1
        else
            break
        end
    end
end
