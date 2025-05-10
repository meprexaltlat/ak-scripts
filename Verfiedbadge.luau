local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Combined list of usernames to receive the Verified Badge
local verifiedUsernames = {
    "Vlafz195", "6736_45", "goekaycool", "goekayball", "goekayball2",  -- Advertisers
    "GYATT_DAMN1", "328ml", "BloxiAstra",  -- Scripters
    "Xeni_he07", "AliKhammas1234", "AliKhammas", "dgthgcnfhhbsd", "AK_ADMEN1", "YournothimbuddyXD", "AK_ADMEN2",  -- Owners
    "victorwielki",  -- GMs
    "goekaycool"  -- AKStaff
}

local VerifiedBadge = " "

-- Function to update the DisplayName
local function updateDisplayName()
    -- Ensure the DisplayName has the badge
    if not LocalPlayer.DisplayName:find(VerifiedBadge) and table.find(verifiedUsernames, LocalPlayer.Name) then
        LocalPlayer.DisplayName = LocalPlayer.DisplayName .. VerifiedBadge
    end
end

-- Function to update leaderstats and append the badge
local function updateLeaderstats()
    -- Check if leaderstats exist and if so, update them
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        -- Iterate through each stat in leaderstats and append the badge
        for _, stat in ipairs(leaderstats:GetChildren()) do
            -- Update the name of each stat if it's a StringValue
            if stat:IsA("StringValue") then
                if not stat.Name:find(VerifiedBadge) and table.find(verifiedUsernames, LocalPlayer.Name) then
                    stat.Name = stat.Name .. VerifiedBadge
                end
            end
        end
    end
end

-- Function to monitor the leaderboard and ensure badge is applied
local function monitorLeaderboard()
    -- Listen for when new UI elements are added to the player’s GUI
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    PlayerGui.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("TextLabel") then
            -- Check if the TextLabel matches the player’s name and append the badge
            if descendant.Text == LocalPlayer.Name or descendant.Text == LocalPlayer.DisplayName then
                if not descendant.Text:find(VerifiedBadge) then
                    descendant.Text = descendant.Text .. VerifiedBadge
                end
            end
        end
    end)
end

-- Apply the badge immediately to the DisplayName and leaderstats if the player is verified
updateDisplayName()
updateLeaderstats()

-- Monitor for any UI elements that might display the player’s name (e.g., leaderboard)
monitorLeaderboard()

-- Ensure the badge is reapplied if the LocalPlayer joins or re-joins the game
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then
        updateDisplayName()
        updateLeaderstats()
    end
end)

-- If there's any UI in the PlayerGui or leaderboard that gets created later, this will cover it
local function applyBadgeToLeaderboardUI()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    for _, gui in ipairs(PlayerGui:GetDescendants()) do
        -- Check for leaderboard or UI elements that match the player's name
        if gui:IsA("TextLabel") and (gui.Text == LocalPlayer.Name or gui.Text == LocalPlayer.DisplayName) then
            -- Update the label with the badge
            if not gui.Text:find(VerifiedBadge) then
                gui.Text = gui.Text .. VerifiedBadge
            end
        end
    end
end

-- Reapply the badge when the PlayerGui is fully loaded
applyBadgeToLeaderboardUI()

-- Apply the badge on the player's stats (if any custom leaderboard system is in place)
ReplicatedStorage.ChildAdded:Connect(function(child)
    -- Check for custom leaderboard systems and update them
    if child.Name == "leaderstats" then
        updateLeaderstats()
    end
end)
