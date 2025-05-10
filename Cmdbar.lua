-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Create the Frame to hold the command bar and logo
local commandFrame = Instance.new("Frame")
commandFrame.Parent = screenGui
commandFrame.Size = UDim2.new(0.35, 0, 0.07, 0)  -- Adjusted width to fit better
commandFrame.Position = UDim2.new(0.5, 0, 0.8, 0)  -- Position slightly higher
commandFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
commandFrame.BorderSizePixel = 0
commandFrame.BackgroundTransparency = 0.2
commandFrame.ClipsDescendants = true
commandFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Add corner curve to the Frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)  -- Set curve radius
corner.Parent = commandFrame

-- Add shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Parent = commandFrame
shadow.Size = UDim2.new(1, 15, 1, 15)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"  -- Shadow image
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6  -- Slightly transparent shadow
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Add the AK cmdbar logo
local logoLabel = Instance.new("TextLabel")
logoLabel.Parent = commandFrame
logoLabel.Size = UDim2.new(0.2, 0, 1, 0)  -- Small size at the left
logoLabel.Position = UDim2.new(0, 5, 0, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "AK cmdbar"
logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 12  -- Adjusted text size to fit better
logoLabel.TextScaled = true  -- Allow the text to scale

-- Create the Command Bar (TextBox)
local commandBar = Instance.new("TextBox")
commandBar.Parent = commandFrame
commandBar.Size = UDim2.new(0.75, 0, 1, 0)  -- Adjusted width to fit the new frame size
commandBar.Position = UDim2.new(0.25, 0, 0, 0)  -- Centered next to the logo
commandBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
commandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
commandBar.PlaceholderText = "Enter command..."
commandBar.Text = ""
commandBar.Font = Enum.Font.GothamBold
commandBar.TextSize = 18
commandBar.BorderSizePixel = 0

-- Add curve to the TextBox as well
local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 10)  -- Curve only
textCorner.Parent = commandBar

-- Commands Table
local cmds = {
    ["jobidjoiner"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Jobidjoiner",
    ["bring"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/Bring",
    ["antilag"] = "https://raw.githubusercontent.com/xSejker/AntilagFixedd/main/README.md",
    ["antibang"] = "https://pastebin.com/raw/5iSqpqf6",
    ["chaoshub"] = "https://raw.githubusercontent.com/Vcsk/AstralHub/main/Loader.lua",
    ["warn all"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Warnall",
    ["aimbot"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/aimbot",
    ["warnpower"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Warns",
    ["protonadmin"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/protonadmin",
    ["triviabooth"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/triviabooth",
    ["chatbot"] = "https://raw.githubusercontent.com/Guerric9018/chatbothub/main/ChatbotHub.lua",
    ["givepower"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/givepower",
    ["walkonwalls"] = "https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/WalkOnWalls",
    ["cmdbar"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Cmdbar",
    ["ad"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/Ad",
    ["chatquiz"] = "https://raw.githubusercontent.com/Damian-11/quizbot/master/quizbot.luau",
    ["shiftlock"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Shiftlock",
    ["nofriends"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Nofriends",
    ["invis"] = "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Invisible%20Gui",
    ["serverhopmost"] = "https://raw.githubusercontent.com/Alikhammass/emoji/main/Serverhopmost",
    ["serverhoplow"] = "https://raw.githubusercontent.com/Alikhammass/emoji/main/Serverhoplow",
    ["bbhub"] = "https://raw.githubusercontent.com/Salmon-B0T/SalmonHub/main/SalmonHub.lua",
    ["getoutmyinv"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/getoutmyinv",
    ["platespin"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/Platespin",
    ["kronefling"] = "https://raw.githubusercontent.com/Alikhammass/antifling./main/loopfling",
    ["gimmetools"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/gimmetools",
    ["oof"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/oof",
    ["mcfling"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Micupfling",
    ["cmds"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/cmds",
    ["antilog"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/antilogger",
    ["donttouchme"] = "https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI",
    ["serverhop"] = "https://raw.githubusercontent.com/Alikhammass/emoji/main/serverhop",
    ["afk"] = "https://raw.githubusercontent.com/2dgeneralspam1/scripts-and-stuff/master/scripts/LoadstringypVvhJBq4QNz",
    ["ftao"] = "https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua",
    ["iy"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
    ["emoji"] = "https://raw.githubusercontent.com/Alikhammass/emoji/main/emo",
    ["f3x"] = "https://raw.githubusercontent.com/Alikhammass/antifling./main/F3x",
    ["f3x sun"] = "https://raw.githubusercontent.com/Alikhammass/antifling./refs/heads/main/F3x%20Sun",
    ["f3x house"] = "https://raw.githubusercontent.com/Alikhammass/antifling./refs/heads/main/F3x%20house",
    ["f3x triangle"] = "https://raw.githubusercontent.com/Alikhammass/antifling./refs/heads/main/F3x%20Traingle",
    ["f3x ufo"] = "https://raw.githubusercontent.com/Alikhammass/antifling./refs/heads/main/F3x%20UFO",
    ["bypasser"] = "https://raw.githubusercontent.com/shadow62x/catbypass/main/upfix",
    ["bladeball"] = "https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/Loader.lua",
    ["nonofling"] = "https://raw.githubusercontent.com/Alikhammass/antifling./main/Antifling",
    ["infect"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Infect",
    ["swordreach"] = "https://raw.githubusercontent.com/Alikhammass/emoji/main/swordreach",
    ["byebye all"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/quickfling",
    ["pltiger"] = "https://raw.githubusercontent.com/H17S32/Tiger_Admin/main/Tiger%20Admin%203.0",
    ["fps"] = "https://raw.githubusercontent.com/insanedude59/MiscReleases/main/Roblox/UWPFPSBooster.lua",
    ["rejoin"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/rejoin",
    ["walkonvoid"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/Walkonvoid",
    ["hkill"] = "https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/Handle%20kills"
}

-- Command Bar Functionality
commandBar.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local command = commandBar.Text:lower()
        commandBar.Text = ""

        local url = cmds[command]
        if url then
            loadstring(game:HttpGet(url))()
        else
            print("Command not recognized.")
        end
    end
end)
