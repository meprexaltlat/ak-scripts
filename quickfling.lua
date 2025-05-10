local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local AllBool = false

local function GetPlayer(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^"..Name) or x.DisplayName:lower():match("^"..Name) then
                    return x
                end
            end
        end
    end
end

local function Message(_Title, _Text, Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local function FPos(RootPart, Character, BasePart, Pos, Ang)
    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
end

local function SFBasePart(RootPart, Character, Humanoid, BasePart, THumanoid, TCharacter, TargetPlayer)
    local TimeToWait = 1.5 -- Reduced from 2
    local Time = tick()
    local Angle = 0
    
    repeat
        if RootPart and THumanoid then
            if BasePart.Velocity.Magnitude < 50 then
                Angle += 125 -- Increased from 100
                
                for i = 1, 3 do -- Reduced iterations
                    FPos(RootPart, Character, BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                    FPos(RootPart, Character, BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                end
            else
                for i = 1, 3 do -- Reduced iterations
                    FPos(RootPart, Character, BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0))
                    task.wait()
                    FPos(RootPart, Character, BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0,0,0))
                    task.wait()
                end
            end
        else
            break
        end
    until BasePart.Velocity.Magnitude > 400 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
end

local function SkidFling(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    
    if not (Character and Humanoid and RootPart) then return Message("Error", "Random error", 5) end
    
    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    
    if THumanoid and THumanoid.Sit and not AllBool then
        return Message("Error", "Target is sitting", 5)
    end
    
    workspace.CurrentCamera.CameraSubject = THead or TRootPart or THumanoid
    
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
    
    workspace.FallenPartsDestroyHeight = 0/0
    
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    if TRootPart and THead and (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
        SFBasePart(RootPart, Character, Humanoid, THead, THumanoid, TCharacter, TargetPlayer)
    else
        SFBasePart(RootPart, Character, Humanoid, TRootPart or THead, THumanoid, TCharacter, TargetPlayer)
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    
    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
        Humanoid:ChangeState("GettingUp")
        for _, x in pairs(Character:GetChildren()) do
            if x:IsA("BasePart") then
                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
            end
        end
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

local Targets = {"All"}

if not Targets[1] then return end

for _, x in next, Targets do GetPlayer(x) end

if AllBool then
    for _, x in next, Players:GetPlayers() do
        if x ~= Player and x.UserId ~= 1414978355 then
            SkidFling(x)
        end
    end
else
    for _, x in next, Targets do
        local TPlayer = GetPlayer(x)
        if TPlayer and TPlayer ~= Player then
            if TPlayer.UserId ~= 1414978355 then
                SkidFling(TPlayer)
            else
                Message("Error", "User is whitelisted! (Owner)", 5)
            end
        elseif not TPlayer then
            Message("Error", "Username Invalid", 5)
        end
    end
end
