local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Define the filename for saving position
local filename = "saved_position.txt"

-- Function to save the player's position to a file
local function SavePositionToFile(position)
    local positionData = HttpService:JSONEncode({
        x = position.X,
        y = position.Y,
        z = position.Z
    })

    -- Write the position data to the file
    writefile(filename, positionData)
    print("[INFO] Position saved to file:", positionData)
end

-- Function to load the saved position from the file
local function LoadPositionFromFile()
    if isfile(filename) then
        local positionData = readfile(filename)
        local decodedData = HttpService:JSONDecode(positionData)
        if decodedData.x and decodedData.y and decodedData.z then
            return Vector3.new(decodedData.x, decodedData.y, decodedData.z)
        else
            print("[ERROR] Invalid position data in file.")
        end
    else
        print("[INFO] Position file not found.")
    end
    return nil
end

-- Get the local player
local player = Players.LocalPlayer

-- Teleport to the saved position if the file exists
local function TeleportToSavedPosition()
    local savedPosition = LoadPositionFromFile()
    if savedPosition then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Teleport the player to the saved position
            local humanoidRootPart = character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(savedPosition)
            print("[INFO] Teleported to saved position:", savedPosition)

            -- Delete the file after successful teleport
            delfile(filename)
            print("[INFO] Position file deleted after teleport.")
        else
            print("[ERROR] Character not found to teleport.")
        end
    else
        print("[INFO] No saved position found, skipping teleport.")
    end
end

-- Function to handle rejoin
local function RejoinGame()
    local gameId = game.PlaceId
    local jobId = game.JobId

    print("[INFO] Rejoining game...")
    TeleportService:TeleportToPlaceInstance(gameId, jobId, player)
end

-- Listen for the !rejoin command in the chat
player.Chatted:Connect(function(message)
    if message:lower() == "!rejoin" then
        print("[INFO] Rejoin command received.")

        -- Save current position to file
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local position = character.HumanoidRootPart.Position
            SavePositionToFile(position)
        else
            print("[ERROR] HumanoidRootPart not found.")
            return
        end

        -- Rejoin the game
        RejoinGame()
    end
end)

-- Check if a saved position exists on script execution
if isfile(filename) then
    TeleportToSavedPosition()
else
    print("[INFO] No saved position file on script execution.")
end
