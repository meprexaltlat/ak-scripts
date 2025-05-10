local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Variables
local BlacklistedPlayers, WhitelistedPlayers, ModsTable, kroneTable = {}, {}, {}, {}
local BLSV, WLSV, MDSV, KRONE = false, false, false, false
local Settings = {Distance = 18, Globals = {"Executions", "List"}}
local Blacklist, kroneUserids = {}, {4710732523, 354902977}
local scriptEnabled = false
local SavedPosition = nil
local CF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local DraggableFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local Shadow = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")

if game:GetService("RunService"):IsStudio() then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

DraggableFrame.Name = "DraggableFrame"
DraggableFrame.Parent = ScreenGui
DraggableFrame.BackgroundTransparency = 1
DraggableFrame.Position = UDim2.new(0.5, -75, 0.1, 0)
DraggableFrame.Size = UDim2.new(0, 150, 0, 50)
DraggableFrame.Active = true
DraggableFrame.Draggable = true

Shadow.Name = "Shadow"
Shadow.Parent = DraggableFrame
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.Position = UDim2.new(0, 2, 0, 2)
Shadow.Size = UDim2.new(1, 0, 1, 0)
Shadow.ZIndex = 0

UICorner_2.Parent = Shadow
UICorner_2.CornerRadius = UDim.new(0, 8)

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = DraggableFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ENABLE SCRIPT"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.AutoButtonColor = false

UICorner.Parent = ToggleButton
UICorner.CornerRadius = UDim.new(0, 8)

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 0))
}
UIGradient.Parent = ToggleButton

-- Functions
local function checkBlacklist(player)
    if table.find(Blacklist, player.UserId) then
        table.insert(BlacklistedPlayers, player)
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Blacklisted Player Detected: " .. player.DisplayName, "All")
        BLSV = true
    end
end

local function checkKrone(player)
    if table.find(kroneUserids, player.UserId) then
        table.insert(kroneTable, player)
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(" silly goose | owner Detected: " .. player.DisplayName, "All")
        KRONE = true
    end
end

local function checkWhitelist(player)
end

local function checkAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            checkBlacklist(player)
            checkKrone(player)
            checkWhitelist(player)
        end
    end
end

local function buttonEffect()
    local originalSize = ToggleButton.Size
    ToggleButton:TweenSize(
        UDim2.new(0.95, 0, 0.95, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.1,
        true
    )
    wait(0.1)
    ToggleButton:TweenSize(
        originalSize,
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.1,
        true
    )
end

local function shhhlol(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid.RootPart

    local im = TargetPlayer.Character
    local so = im:FindFirstChildOfClass("Humanoid")
    local sorry = so and so.RootPart
    local please = im:FindFirstChild("Head")
    local stop = im:FindFirstChildOfClass("stop")
    local it = stop and stop:FindFirstChild("it")

    if Character and Humanoid and RootPart then
        if please then
            workspace.CurrentCamera.CameraSubject = please
        elseif not please and it then
            workspace.CurrentCamera.CameraSubject = it
        else
            workspace.CurrentCamera.CameraSubject = so
        end
        
        if not im:FindFirstChildWhichIsA("BasePart") then return end

        local function mmmm(comkid, Pos, Ang)
            RootPart.CFrame = CFrame.new(comkid.Position) * Pos * Ang
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function wtf(comkid)
            local TimeToWait = 0.134
            local Time = tick()
            
            local Att1 = Instance.new("Attachment", RootPart)
            local Att2 = Instance.new("Attachment", sorry)

            repeat
                if RootPart and so then
                    if comkid.Velocity.Magnitude < 30 then
                        mmmm(
                            comkid,
                            CFrame.new(0, 1.5, 0) + so.MoveDirection * comkid.Velocity.Magnitude / 5,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        RunService.Heartbeat:wait()

                        mmmm(
                            comkid,
                            CFrame.new(0, 1.5, 0) + so.MoveDirection * comkid.Velocity.Magnitude / 1.25,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        RunService.Heartbeat:wait()

                        mmmm(
                            comkid,
                            CFrame.new(0, -1.5, 0) + so.MoveDirection * comkid.Velocity.Magnitude / 1.25,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        RunService.Heartbeat:wait()
                    else
                        mmmm(comkid, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(0), 0, 0))
                        RunService.Heartbeat:wait()
                    end
                else
                    break
                end
            until comkid.Velocity.Magnitude > 1000 or 
                  comkid.Parent ~= TargetPlayer.Character or
                  TargetPlayer.Parent ~= Players or
                  not TargetPlayer.Character == im or
                  Humanoid.Health <= 0 or
                  tick() > Time + TimeToWait or
                  not scriptEnabled

            Att1:Destroy()
            Att2:Destroy()
            
            if game.PlaceId == 417267366 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5524, 36, -17126.50)
            else
                LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPosition or CF
            end
        end

        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(-9e99, 9e99, -9e99)
        BV.MaxForce = Vector3.new(-9e9, 9e9, -9e9)

        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position)
        BodyGyro.D = 9e8
        BodyGyro.MaxTorque = Vector3.new(-9e9, 9e9, -9e9)
        BodyGyro.P = -9e9

        local BodyPosition = Instance.new("BodyPosition")
        BodyPosition.Position = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
        BodyPosition.D = 9e8
        BodyPosition.MaxForce = Vector3.new(-9e9, 9e9, -9e9)
        BodyPosition.P = -9e9

        if sorry and please then
            if (sorry.CFrame.p - please.CFrame.p).Magnitude > 5 then
                wtf(please)
            else
                wtf(sorry)
            end
        elseif sorry and not please then
            wtf(sorry)
        elseif not sorry and please then
            wtf(please)
        elseif not sorry and not please and stop and it then
            wtf(it)
        end

        BV:Destroy()
        BodyGyro:Destroy()
        BodyPosition:Destroy()
        
        for _, x in next, Character:GetDescendants() do
            if x:IsA("BasePart") then
                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
            end
        end
        
        Humanoid:ChangeState("GettingUp")
        workspace.CurrentCamera.CameraSubject = Humanoid
    end
end

local function enableScript()
    coroutine.wrap(function()
        while scriptEnabled do
            pcall(function()
                for _, z in pairs(Players:GetPlayers()) do
                    if z ~= LocalPlayer and not table.find(WhitelistedPlayers, tostring(z.UserId)) then
                        if LocalPlayer.Character and 
                           LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and 
                           z and z.Character and 
                           z.Character:FindFirstChildOfClass("Humanoid").Sit == false then
                            shhhlol(z)
                            wait()
                        end
                    end
                end
            end)
            wait()
        end
    end)()
end

-- Event Connections
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        checkBlacklist(player)
        checkKrone(player)
        checkWhitelist(player)
    end
end)

RunService.Stepped:Connect(function()
    if not scriptEnabled then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit == true then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
        for _, z in next, LocalPlayer.Character:GetChildren() do
            if z:IsA("BasePart") then
                z.CanCollide = false
            end
        end
    end
end)

-- Button Events
ToggleButton.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    buttonEffect()

    if scriptEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            SavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
        
        ToggleButton.Text = "Fling all OFF"
        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 0))
        }
        enableScript()
    else
        wait(0.1) -- Small delay to ensure proper teleport
        if SavedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPosition
        end
        
        ToggleButton.Text = "Fling all ON"
        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 0))
        }
    end
end)

-- Initialize
checkAllPlayers()
