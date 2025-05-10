local isLooping = false

local function onChatMessageReceived(message)
    if message:lower() == "/boomboxraid on" then
        isLooping = true
        print("Loop is now ON")
    elseif message:lower() == "/boomboxraid off" then
        isLooping = false
        print("Loop is now OFF")
    end
end

local player = game.Players.LocalPlayer

player.Chatted:Connect(function(message)
    onChatMessageReceived(message)
end)

while true do
    wait() -- Wait for the next frame

    if isLooping then
        local backpack = player.Backpack

        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = player.Character
                tool.Parent = workspace
            end
        end

        game.ReplicatedStorage.GiveBox:FireServer()
    end
end
