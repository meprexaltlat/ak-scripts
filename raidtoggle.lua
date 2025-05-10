local isKittyRaidLooping = false
local isBoomboxRaidLooping = false

local function processChatCommand(msg)
    if string.lower(msg) == "/kittyraid on" then
        isKittyRaidLooping = true
        print("Kitty Raid Loop is now ON")
    elseif string.lower(msg) == "/kittyraid off" then
        isKittyRaidLooping = false
        print("Kitty Raid Loop is now OFF")
    elseif string.lower(msg) == "/boomboxraid on" then
        isBoomboxRaidLooping = true
        print("Boombox Raid Loop is now ON")
    elseif string.lower(msg) == "/boomboxraid off" then
        isBoomboxRaidLooping = false
        print("Boombox Raid Loop is now OFF")
    -- Add your commands here --
    elseif string.lower(msg) == "/yourcommand" then
        -- Add functionality for your custom command here
    end
end

game:GetService("Players").LocalPlayer.Chatted:Connect(processChatCommand)

local function raidLoop()
    while true do
        wait() -- Wait for the next frame
        local backpack = game.Players.LocalPlayer.Backpack

        if isKittyRaidLooping or isBoomboxRaidLooping then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = game.Players.LocalPlayer.Character
                    tool.Parent = workspace
                end
            end
        end

        if isKittyRaidLooping then
            game.ReplicatedStorage.GiveCat:FireServer()
        end

        if isBoomboxRaidLooping then
            game.ReplicatedStorage.GiveBox:FireServer()
        end

        -- Add logic for other raid loops or functionalities here --
    end
end

raidLoop() -- Start the raid loop
