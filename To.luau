local prefix = "!"
local chatcmd = "to"
game.Players.LocalPlayer.Chatted:Connect(function(msg)
	local lowerCmd = msg:lower()
	if lowerCmd:sub(1, #prefix + #chatcmd) == prefix .. chatcmd then
		local targetPlayer = lowerCmd:sub(#prefix + #chatcmd + 2)
		for i, v in pairs(game.Players:GetChildren()) do
			local playerName = v.Name:lower()
			local playerDisplayName = v.DisplayName:lower()
			if playerName:find(targetPlayer) or playerDisplayName:find(targetPlayer) then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
				break 
			end
		end
	end
end)
