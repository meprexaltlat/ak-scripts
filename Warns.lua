local players = game:GetService("Players")
local warnCommand: string = '/warns'
local warnAllCommand: string = '/warnall'
local Admins = {"dgthgcnfhhbsd", "AliKhammas1234", "AliKhammas", "iannnnnnnnnnnnn_n", "simhean", "AK_ADMEN1"} -- Add admins here

for _, adminName in pairs(Admins) do
    local admin = game.Players:FindFirstChild(adminName)
    if admin then
        admin.Chatted:Connect(function(message)
            local command = string.sub(message, 1, 6)
            if string.lower(command) == string.lower(warnCommand) then
                local Victim = string.sub(message, 8):gsub("^%s*(.-)%s*$", "%1") -- Trim spaces
                for _, player in pairs(players:GetPlayers()) do
                    if Victim:lower() == player.DisplayName:lower() or Victim:lower() == player.Name:lower() then
                        for i = 1, 100 do -- Use 100 as the limit for a single victim
                            game:GetService("ReplicatedStorage").Notification.PlayerSelectedEvent:FireServer(player.Name)
                        end
                        wait(15)
                    end
                end
            elseif string.lower(command) == string.lower(warnAllCommand) then
                for _, player in pairs(players:GetPlayers()) do
                    for i = 1, 100 do -- Use 100 as the limit for all players
                        game:GetService("ReplicatedStorage").Notification.PlayerSelectedEvent:FireServer(player.Name)
                    end
                end
                wait(15) -- Optional: wait after warning all players
            end
        end)
    end
end
