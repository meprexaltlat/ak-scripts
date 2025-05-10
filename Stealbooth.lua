-- Function to make all proximity prompts visible
local function showAllProximityPrompts()
    for _, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.Enabled = true -- Set Enabled to true to show the prompt
            print("Made proximity prompt visible at:", v.Parent.Name) -- Debug output
        end
    end
end

-- Call the function to show all proximity prompts
showAllProximityPrompts()

-- Confirmation message
print("All proximity prompts are now visible.")
