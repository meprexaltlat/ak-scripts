local players = game:GetService("Players")

local killCommand: string = '/warn'
local Admins = {"dgthgcnfhhbsd","AliKhammas"} --Put your name there
for i,v in pairs(Admins) do
    game.Players[v].Chatted:Connect(function(Chat)
        local CheckIfCommand = string.sub(Chat,1,5)
        if string.match(killCommand, CheckIfCommand) then
            for _, CurrentAdmin in pairs (Admins)do
                if game.Players.LocalPlayer.Name == CurrentAdmin then
                    local Victim = string.sub(Chat,7,#Chat)
                    for i,v in pairs(game.Players:GetPlayers()) do
                        if Victim:lower() == v.DisplayName:lower() or Victim:lower() == v.Name:lower() then
                            game:GetService("ReplicatedStorage").Notification.PlayerSelectedEvent:FireServer(v.Name)
                        end
                    end
                end
            end
        end
end)
end
