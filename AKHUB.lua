--[[
__________ __          __   _______          ________  
\______   \  |  __ ___/  |_ \   _  \   ___  _\_____  \ 
 |     ___/  | |  |  \   __\/  /_\  \  \  \/ / _(__  < 
 |    |   |  |_|  |  /|  |  \  \_/   \  \   / /       \
 |____|   |____/____/ |__|   \_____  /   \_/ /______  /
                                   \/               \/ 
         
            -- // • MAIN DETAILS • \\ --

            --// • Credits: Shlexware
            --// • Owner: r4ge2
            --// • Version: 3.6
            --// • Libraries & Modules: 1
            --// • Developers: r4ge2
            --// • Average Load Time: 0 - 5


--]]




local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()


local Window = OrionLib:MakeWindow({
    Name = "AK HUB  |  universal",
    HidePremium = false,
    IntroEnabled = false,
    SaveConfig = true,
    ConfigFolder = "PLUT0-V3"
    
})


local mainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7733960981",
    PremiumOnly = false
})

local playSection = mainTab:AddSection({
    Name = "Player"
})

local mveSection = mainTab:AddSection({
    Name = "movement"
})


local funTab = Window:MakeTab({
    Name = "fun",
    Icon = "rbxassetid://7743868000",
    PremiumOnly = false
})


local camSection = mainTab:AddSection({
    Name = "Camera"
})

local visSection = mainTab:AddSection({
    Name = "ESP"
})

local miscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://7733942651",
    PremiumOnly = false
})

local mageSection = miscTab:AddSection({
    Name = "Game"
})

local mcuSection = miscTab:AddSection({
    Name = "Visuals"
})

local tpSection = mainTab:AddSection({
    Name = "teleport"
})


local pltargetTab = Window:MakeTab({
    Name = "target",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local isLockedOn = false
local targetPlayer = nil
local lockEnabled = false
local smoothingFactor = 0.1
local bodyPartSelected = "Head"
local toggleKey = Enum.KeyCode.Q


local function isR6(character)
    return character:FindFirstChild("Torso") ~= nil and character:FindFirstChild("Left Arm") ~= nil
end


local function getBodyPart(character, part)
    if isR6(character) then
        local r6Parts = {
            Head = "Head",
            LeftUpperArm = "Left Arm",
            RightUpperArm = "Right Arm",
            LeftUpperLeg = "Left Leg",
            RightUpperLeg = "Right Leg",
            UpperTorso = "Torso",
        }
        return r6Parts[part] or "Head"
    else
        return part
    end
end


local function getNearestPlayerToMouse()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local mousePosition = Mouse.Hit.p

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPosition = player.Character.Head.Position
            local distance = (headPosition - mousePosition).Magnitude

            if distance < shortestDistance then
                nearestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return nearestPlayer
end


local function toggleLockOnPlayer()
    if not lockEnabled then return end

    if isLockedOn then
        isLockedOn = false
        targetPlayer = nil
    else
        targetPlayer = getNearestPlayerToMouse()
        if targetPlayer and targetPlayer.Character then
            local part = getBodyPart(targetPlayer.Character, bodyPartSelected)
            if targetPlayer.Character:FindFirstChild(part) then
                isLockedOn = true
            end
        end
    end
end


RunService.RenderStepped:Connect(function()
    if lockEnabled and isLockedOn and targetPlayer and targetPlayer.Character then
        local partName = getBodyPart(targetPlayer.Character, bodyPartSelected)
        local part = targetPlayer.Character:FindFirstChild(partName)

        if part and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local targetPosition = part.Position
            local cameraPosition = Camera.CFrame.Position

            Camera.CFrame = CFrame.new(cameraPosition, targetPosition) * CFrame.new(0, 0, smoothingFactor)
        else
            isLockedOn = false
            targetPlayer = nil
        end
    end
end)

camSection:AddButton({
    Name = "[Q] to AimLock",
    Callback = function()
        lockEnabled = not lockEnabled
        if not lockEnabled then
            isLockedOn = false
            targetPlayer = nil
        end

        camSection:UpdateButton("Enable Lock", {
            Name = lockEnabled and "Disable Lock" or "Enable Lock",
        })
    end
})


camSection:AddDropdown({
    Name = "AimLock on bodyparts",
    Default = "Head",
    Options = {"Head", "UpperTorso", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg", "LeftUpperArm"},
    Callback = function(part)
        bodyPartSelected = part 
    end
})

camSection:AddBind({
    Name = "AimLock keybind",
    Default = Enum.KeyCode.Q,
    Hold = false,
    Callback = function()
        toggleLockOnPlayer()
    end    
})

local teleportEnabled = false
local teleportOffset = 5 


local function toggleTeleport()
    teleportEnabled = not teleportEnabled
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end 
    if input.KeyCode == Enum.KeyCode.E and teleportEnabled then
        local mouse = game.Players.LocalPlayer:GetMouse()
        if mouse.Target then
            game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + teleportOffset, mouse.Hit.z)
        end
    end
end)


playSection:AddButton({
    Name = "[E] to Teleport",
    Callback = function()
        toggleTeleport()
    end
})


local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer
local noclipEnabled = false


local function setNoClipState(enabled)
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide ~= not enabled then
                part.CanCollide = not enabled 
            end
        end
    end
end


local function monitorCharacter()
    while noclipEnabled do
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false 
                end
            end
        end
        task.wait(0.2)
    end
end


local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    setNoClipState(noclipEnabled)
    if noclipEnabled then
        task.spawn(monitorCharacter) 
    end
end


LocalPlayer.CharacterAdded:Connect(function()
    if noclipEnabled then
        task.wait(0.5) 
        setNoClipState(noclipEnabled)
        task.spawn(monitorCharacter) 
    end
end)


playSection:AddButton({
    Name = "No Clip",
    Callback = toggleNoClip
})

local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
    end
end

playSection:AddButton({
    Name = "Infinite Jump",
    Callback = toggleInfiniteJump
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)



local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "ESPFolder"
local selectedColor = Color3.fromRGB(255, 0, 0)  

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.Parent = espFolder
    highlight.FillTransparency = 1  
    highlight.OutlineColor = selectedColor  
end

local function removeESP(player)
    for _, item in ipairs(espFolder:GetChildren()) do
        if item.Adornee and item.Adornee.Parent == player.Character then
            item:Destroy()
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createESP(player)
            end
        end
    else
        for _, item in ipairs(espFolder:GetChildren()) do
            item:Destroy()
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= game.Players.LocalPlayer then
        createESP(player)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        removeESP(player)
    end
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            if espEnabled then
                createESP(player)
            end
        end)
    end
end

visSection:AddButton({
    Name = "ESP (outline)",
    Callback = toggleESP
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera


local nameESPEnabled = false
local tracerESPEnabled = false


local nameESPObjects = {}
local tracerLines = {}


local function createNameESP(character)
    local head = character:FindFirstChild("Head")
    if not head then return end

    if nameESPObjects[character] then return end

    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "NameESP"
    billboard.Size = UDim2.new(0, 80, 0, 40) 
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = character.Name
    textLabel.TextColor3 = Color3.new(0, 1, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.Code 
    textLabel.BackgroundTransparency = 1

    nameESPObjects[character] = billboard
end


local function removeNameESP(character)
    if nameESPObjects[character] then
        nameESPObjects[character]:Destroy()
        nameESPObjects[character] = nil
    end
end

local function createTracer(playerCharacter)
    local line = Drawing.new("Line")
    line.Color = Color3.new(1, 1, 1)
    line.Thickness = 1
    line.Transparency = 1
    tracerLines[playerCharacter] = line
end


local function removeTracer(playerCharacter)
    if tracerLines[playerCharacter] then
        tracerLines[playerCharacter]:Remove()
        tracerLines[playerCharacter] = nil
    end
end


local function updateTracers()
    for playerCharacter, line in pairs(tracerLines) do
        if not playerCharacter:FindFirstChild("HumanoidRootPart") then
            line.Visible = false
        else
            local rootPosition = playerCharacter.HumanoidRootPart.Position
            local screenPos, onScreen = camera:WorldToViewportPoint(rootPosition)
            if onScreen then
                local origin = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2) 
                line.From = origin
                line.To = Vector2.new(screenPos.X, screenPos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        end
    end
end


local function toggleNameESP()
    nameESPEnabled = not nameESPEnabled
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            local character = v.Character or v.CharacterAdded:Wait()
            if nameESPEnabled then
                createNameESP(character)
            else
                removeNameESP(character)
            end
        end
    end
end

local function toggleTracerESP()
    tracerESPEnabled = not tracerESPEnabled
    if tracerESPEnabled then
        RunService.RenderStepped:Connect(updateTracers)
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player then
                local character = v.Character or v.CharacterAdded:Wait()
                createTracer(character)
            end
        end
    else
        for _, line in pairs(tracerLines) do
            line:Remove()
        end
        tracerLines = {}
    end
end


Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(character)
        if nameESPEnabled then
            createNameESP(character)
        end
        if tracerESPEnabled then
            createTracer(character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(removingPlayer)
    if removingPlayer.Character then
        removeNameESP(removingPlayer.Character)
        removeTracer(removingPlayer.Character)
    end
end)


visSection:AddButton({
    Name = "ESP (name)",
    Callback = toggleNameESP
})

visSection:AddButton({
    Name = "ESP (tracer)",
    Callback = toggleTracerESP
})


local selectedColor = Color3.fromRGB(255, 0, 0) 

local function UpdateESPColor()
    for _, billboard in pairs(nameESPObjects) do
        if billboard and billboard:FindFirstChild("TextLabel") then
            billboard.TextLabel.TextColor3 = selectedColor
        end
    end

    for _, tracer in pairs(tracerLines) do
        if tracer then
            tracer.Color = selectedColor
        end
    end

    if espEnabled then
        for _, item in ipairs(espFolder:GetChildren()) do
            item.OutlineColor = selectedColor
        end
    end
end


visSection:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),  
    Callback = function(Value)
        selectedColor = Value 
        UpdateESPColor()      
    end
})


local spinning = false
local spinSpeed = 0
local spinConnection = nil

local function startSpinning()
    spinConnection = RunService.RenderStepped:Connect(function()
        if spinning then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end)
end



local UsersInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local SPEED_MULTIPLIER = 30
local JUMP_POWER = 60
local JUMP_GAP = 0.3

local character = game.Players.LocalPlayer.Character

local isRolling = false
local ball = character:WaitForChild("HumanoidRootPart")

local function toggleRolling()
    isRolling = not isRolling
    if isRolling then
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(5, 5, 5)
        for i, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        local humanoid = character:WaitForChild("Humanoid")
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {character}
        
        RunService.RenderStepped:Connect(function(delta)
            if not isRolling then return end
            ball.CanCollide = true
            humanoid.PlatformStand = true
            if UsersInputService:GetFocusedTextBox() then return end
            if UsersInputService:IsKeyDown("W") then
                ball.RotVelocity -= Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
            end
            if UsersInputService:IsKeyDown("A") then
                ball.RotVelocity -= Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
            end
            if UsersInputService:IsKeyDown("S") then
                ball.RotVelocity += Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
            end
            if UsersInputService:IsKeyDown("D") then
                ball.RotVelocity += Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
            end
        end)

        UsersInputService.JumpRequest:Connect(function()
            local result = workspace:Raycast(
                ball.Position,
                Vector3.new(
                    0,
                    -((ball.Size.Y/2) + JUMP_GAP),
                    0
                ),
                params
            )
            if result then
                ball.Velocity = ball.Velocity + Vector3.new(0, JUMP_POWER, 0)
            end
        end)

        Camera.CameraSubject = ball
    else
        ball.Shape = Enum.PartType.Block
        ball.Size = Vector3.new(2, 2, 2) -- Default size, adjust if necessary
        for i, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        Camera.CameraSubject = character:FindFirstChildOfClass("Humanoid")
    end
end

funTab:AddButton({
    Name = "Roll",
    Callback = function()
        toggleRolling()
    end
})


local function stopSpinning()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

local function toggleSpin()
    spinning = not spinning
    if spinning then
        spinSpeed = 400 
        startSpinning()
    else
        stopSpinning()
    end
end

funTab:AddButton({
    Name = "Spin",
    Callback = toggleSpin
})


mcuSection:AddButton({
    Name = "Fog Remover",
    Callback = function()
        fogRemoverActive = not fogRemoverActive
        
        if fogRemoverActive then
           
            local lighting = game:GetService("Lighting")
            lighting.FogStart = math.huge
            lighting.FogEnd = math.huge
            lighting.FogColor = Color3.fromRGB(255, 255, 255)
        else
            
            local lighting = game:GetService("Lighting")
            lighting.FogStart = 0
            lighting.FogEnd = 10000
            lighting.FogColor = Color3.fromRGB(128, 128, 128) 
        end
    end
})


mcuSection:AddButton({
    Name = "Low GFX",
    Callback = function()
        local decalsyeeted = true
        local g = game
        local w = g.Workspace
        local l = g.Lighting
        local t = w.Terrain
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 0
        l.GlobalShadows = false
        l.FogEnd = 9e9
        l.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        for i,v in pairs(g:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") and decalsyeeted then 
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then 
                v.Lifetime = NumberRange.new(0)
            end
        end
    end    
})


local originalFOV = workspace.CurrentCamera.FieldOfView 


camSection:AddSlider({
    Name = "FOV",
    Min = 70,  
    Max = 120, 
    Default = game.Workspace.CurrentCamera.FieldOfView, 
    Increment = 1,  
    Callback = function(value)
        game.Workspace.CurrentCamera.FieldOfView = value
    end
})


camSection:AddButton({
    Name = "Reset FOV",
    Callback = function()
        workspace.CurrentCamera.FieldOfView = originalFOV
    end
})


local function toggleLighting()
    if isBright then
        
        game.Lighting.Brightness = originalLighting.Brightness
        game.Lighting.Ambient = originalLighting.Ambient
        game.Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        isBright = false
    else
       
        game.Lighting.Brightness = 2
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        isBright = true
    end
end


mcuSection:AddButton({
    Name = "full bright",
    Callback = function()
        toggleLighting()
    end
})



local originalGravity = workspace.Gravity

funTab:AddSlider({
	Name = "Gravity",
	Min = 0,
	Max = 200,
	Default = 196.2,  
	Increment = 0.1,
	ValueName = "Gravity",
	Callback = function(value)
		workspace.Gravity = value
	end    
})


funTab:AddButton({
	Name = "Reset Gravity",
	Callback = function()
		workspace.Gravity = originalGravity
		GravitySlider:Set(originalGravity)  
	end
})


FLYING = false
QEfly = false
iyflyspeed = 1.4
vehicleflyspeed = 1.4
flyEnabled = false 

local function getRoot(char)
    local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    return rootPart
end

function sFLY(vfly)
    if not flyEnabled then return end 
    repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and getRoot(game.Players.LocalPlayer.Character) and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat wait() until game.Players.LocalPlayer:GetMouse()

    local T = getRoot(game.Players.LocalPlayer.Character)
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = T.CFrame
        BV.velocity = Vector3.new(0, 0, 0)
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            repeat wait()
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E ~= 0) then
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.velocity = Vector3.new(0, 0, 0)
                end
                BG.cframe = workspace.CurrentCamera.CoordinateFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end

    local function setFlyingAnimation()
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if humanoid then
            humanoid.PlatformStand = true
        end
    end

    game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 's' then
            CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'a' then
            CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'd' then 
            CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif QEfly and KEY:lower() == 'e' then
            CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed) * 2
        elseif QEfly and KEY:lower() == 'q' then
            CONTROL.E = - (vfly and vehicleflyspeed or iyflyspeed) * 2
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)

    game.Players.LocalPlayer:GetMouse().KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = 0
        elseif KEY:lower() == 's' then
            CONTROL.B = 0
        elseif KEY:lower() == 'a' then
            CONTROL.L = 0
        elseif KEY:lower() == 'd' then
            CONTROL.R = 0
        elseif KEY:lower() == 'e' then
            CONTROL.Q = 0
        elseif KEY:lower() == 'q' then
            CONTROL.E = 0
        end
    end)

    FLY()
    setFlyingAnimation() 
end

function NOFLY()
    FLYING = false
    if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

playSection:AddButton({
    Name = "[X] to fly",
    Default = false,
    Callback = function()
        flyEnabled = not flyEnabled 
        if not flyEnabled then
            NOFLY() 
        end
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        if flyEnabled then 
            if FLYING then
                NOFLY()
            else
                sFLY()
            end
        end
    end
end)


playSection:AddSlider({
    Name = "Fly Speed",
    Min = 1.4,
    Max = 20,
    Color = Color3.fromRGB(0, 255, 0),
    Default = 1.4,
    Increment = 0.5,
    ValueName = "Speed",
    Callback = function(value)
        iyflyspeed = value
        vehicleflyspeed = value
    end
})
  
mveSection:AddSlider({
    Name = "Speed Power",
    Min = 20,
    Max = 500,
    Color = Color3.fromRGB(0, 255, 0),
    Default = 20,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(s)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = s
        end
    end
})

mveSection:AddSlider({
    Name = "Jump Power",
    Min = 60,
    Max = 300,
    Default = 60,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(s)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = s
        end
    end
})





mageSection:AddButton({
    Name = "Force Reset",
    Callback = function()
       
        local player = game.Players.LocalPlayer
       
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
})

local toggleState = false
local toggleConnection


mageSection:AddButton({
    Name = "anti-fling",
    Callback = function()
        toggleState = not toggleState
        if toggleState then

            
            local Services = setmetatable({}, {__index = function(Self, Index)
                local NewService = game.GetService(game, Index)
                if NewService then
                    Self[Index] = NewService
                end
                return NewService
            end})

          
            local LocalPlayer = Services.Players.LocalPlayer

        
            local function PlayerAdded(Player)
                local Detected = false
                local Character;
                local PrimaryPart;

                local function CharacterAdded(NewCharacter)
                    Character = NewCharacter
                    repeat
                        wait()
                        PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
                    until PrimaryPart
                    Detected = false
                end

                CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
                Player.CharacterAdded:Connect(CharacterAdded)
                Services.RunService.Heartbeat:Connect(function()
                    if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
                        if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                            if Detected == false then
                                print("someone did something i guess")
                            end
                            Detected = true
                            for i,v in ipairs(Character:GetDescendants()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                    v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                                end
                            end
                            PrimaryPart.CanCollide = false
                            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                        end
                    end
                end)
            end

            -- // Event Listeners \\ --
            for i,v in ipairs(Services.Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    PlayerAdded(v)
                end
            end
            Services.Players.PlayerAdded:Connect(PlayerAdded)

            local LastPosition = nil
            toggleConnection = Services.RunService.Heartbeat:Connect(function()
                pcall(function()
                    local PrimaryPart = LocalPlayer.Character.PrimaryPart
                    if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                        PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.CFrame = LastPosition
                    elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
                        LastPosition = PrimaryPart.CFrame
                    end
                end)
            end)

        else
            if toggleConnection then
                toggleConnection:Disconnect()
            end
        end
    end
})


mcuSection:AddButton({
    Name = "Set Day-time",
    Callback = function()

        local lighting = game:GetService("Lighting")
        lighting.ClockTime = 14
    end
})


mcuSection:AddButton({
    Name = "Set Night-time",
    Callback = function()
        
        local lighting = game:GetService("Lighting")
        
        lighting.ClockTime = 20
    end
})


local isLightingEnabled = false  

local function ToggleLightingEffects()
    local Light = game.Lighting  

    if isLightingEnabled then

        for _, v in pairs(Light:GetChildren()) do
            v:Destroy()
        end
        Light.Brightness = 2
        Light.ExposureCompensation = 0
    else

        local Sky = Instance.new("Sky")
        local Bloom = Instance.new("BloomEffect")
        local Blur = Instance.new("BlurEffect")
        local ColorC = Instance.new("ColorCorrectionEffect")
        local SunRays = Instance.new("SunRaysEffect")

        Light.Brightness = 2.25
        Light.ExposureCompensation = 0.1
        Light.ClockTime = 17.55

        Sky.SkyboxBk = "http://www.roblox.com/asset/?id=144933338"
        Sky.SkyboxDn = "http://www.roblox.com/asset/?id=144931530"
        Sky.SkyboxFt = "http://www.roblox.com/asset/?id=144933262"
        Sky.SkyboxLf = "http://www.roblox.com/asset/?id=144933244"
        Sky.SkyboxRt = "http://www.roblox.com/asset/?id=144933299"
        Sky.SkyboxUp = "http://www.roblox.com/asset/?id=144931564"
        Sky.StarCount = 5000
        Sky.SunAngularSize = 5
        Sky.Parent = Light

        Bloom.Intensity = 0.3
        Bloom.Size = 10
        Bloom.Threshold = 0.8
        Bloom.Parent = Light

        Blur.Size = 5
        Blur.Parent = Light

        ColorC.Brightness = 0
        ColorC.Contrast = 0.1
        ColorC.Saturation = 0.25
        ColorC.TintColor = Color3.fromRGB(255, 255, 255)
        ColorC.Parent = Light

        SunRays.Intensity = 0.1
        SunRays.Spread = 0.8
        SunRays.Parent = Light
    end
end

mcuSection:AddButton({
    Name = "shaders",
    Callback = function()
 
        isLightingEnabled = not isLightingEnabled
   
        ToggleLightingEffects()
    end
})

local activated = false
local runningCoroutine = nil


local function startLoop()
    runningCoroutine = coroutine.create(function()
        while activated do
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
            game:GetService("RunService").RenderStepped:Wait()
        end
    end)
    coroutine.resume(runningCoroutine)
end


local function stopLoop()
    activated = false
    if runningCoroutine then  
        repeat wait() until coroutine.status(runningCoroutine) == "dead"
        runningCoroutine = nil
    end
end


local function toggleActivation()
    if activated then
        stopLoop()
    else
        activated = true
        startLoop()
    end
end

mageSection:AddButton({
    Name = "enable reset",
    Callback = function()
        toggleActivation()
    end
})
   
-- Define the script to execute
local function executeScript()
    local clone_transparency = 1 --Set Value How you want to fake body be transparenty.

local Motors = {
    ["Left Hip"] = 0,
    ["Neck"] = 0,
    ["Left Shoulder"] = 0,
    ["Right Hip"] = 0,
    ["Right Shoulder"] = 0
}
local TS = game:GetService("TweenService")
local count2, maxcount2, count

local function getnext(tbl, number)
    local c = 100
    local rtrnv = 0
    for i, v in pairs(tbl) do
        if i > number and i - number < c then
            c = i - number
            rtrnv = i
        end
    end
    return rtrnv
end

local function kftotbl(kf)
    local tbl3 = {}
    for i, v in pairs(kf:GetDescendants()) do
        if v:IsA("Pose") then
            tbl3[string.sub(v.Name, 1, 1) .. string.sub(v.Name, #v.Name, #v.Name)] = v.CFrame
        end
    end
    return tbl3
end

local function getSpeed(lastTimeStamp, currentTimeStamp)
    if currentTimeStamp == 0 then return 0 end
    return math.abs(lastTimeStamp - currentTimeStamp)
end

local function getAnimation(animationId)
    local animationObject
    local S, E = pcall(function()
        animationObject = game:GetObjects(animationId)[1]
    end)
    return animationObject
end

local Main = {}
Main.__index = Main

function Main.LoadDummy(DummyChar)
    local metatable = {}
    setmetatable(metatable, Main)
    metatable.char = DummyChar
    return metatable
end

function Main:LoadAnimation(animationId)
    local Character = self.char
    local animationObject = getAnimation(animationId)
    if animationObject == nil then return end
    print(animationObject)
    local metatable = {}
    setmetatable(metatable, Main)
    metatable.char = Character
    metatable.animObject = animationObject
    return metatable
end

function Main:Play()
    local Character = self.char
    local animationObject = self.animObject
    local Looped = true
    local anim = {}
    for i, v in pairs(animationObject:GetChildren()) do
        if v:IsA("Keyframe") then
            anim[v.Time] = kftotbl(v)
        end
    end
    local LH = Character.Torso["Left Hip"].C0
    local RH = Character.Torso["Right Hip"].C0
    local LS = Character.Torso["Left Shoulder"].C0
    local RS = Character.Torso["Right Shoulder"].C0
    local RoH = Character.HumanoidRootPart["RootJoint"].C0
    local N = Character.Torso["Neck"].C0
    count = -1
    local lastTimeStamp = 0
    local char = Character
    self.played = false
    local times = {
        Lg = 0,
        Rg = 0,
        Lm = 0,
        Rm = 0,
        To = 0,
        Hd = 0
    }
    local timepassed = 0
    local lasttime = tick()
    while task.wait() do
        timepassed = tick() - lasttime
        if self.played then
            Character.Torso["Left Hip"].C0 = LH
            Character.Torso["Right Hip"].C0 = RH
            Character.Torso["Left Shoulder"].C0 = LS
            Character.Torso["Right Shoulder"].C0 = RS
            Character.HumanoidRootPart["RootJoint"].C0 = RoH
            Character.Torso["Neck"].C0 = N
            break
        end
        if not Looped then
            self.played = true
        end
        for i, oasjdadlasdkadkldjkl in pairs(anim) do
            local asdf = getnext(anim, count)
            local v = anim[asdf]
            count2 = 0
            maxcount2 = asdf - count
            count = asdf
            wait(asdf - count)
            count2 = maxcount2
            if v["Lg"] then
                local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Lg + getSpeed(lastTimeStamp, asdf))
                times.Lg = 0
                TS:Create(Character.Torso["Left Hip"], Ti, { C0 = LH * v["Lg"] }):Play()
            else
                times.Lg = times.Lg + getSpeed(lastTimeStamp, asdf)
            end
            if v["Rg"] then
                local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Rg + getSpeed(lastTimeStamp, asdf))
                times.Rg = 0
                TS:Create(Character.Torso["Right Hip"], Ti, { C0 = RH * v["Rg"] }):Play()
            else
                times.Rg = times.Rg + getSpeed(lastTimeStamp, asdf)
            end
            if v["Lm"] then
                local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Lm + getSpeed(lastTimeStamp, asdf))
                times.Lm = 0
                TS:Create(Character.Torso["Left Shoulder"], Ti, { C0 = LS * v["Lm"] }):Play()
            else
                times.Lm = times.Lm + getSpeed(lastTimeStamp, asdf)
            end
            if v["Rm"] then
                local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Rm + getSpeed(lastTimeStamp, asdf))
                times.Rm = 0
                TS:Create(Character.Torso["Right Shoulder"], Ti, { C0 = RS * v["Rm"] }):Play()
            else
                times.Rm = times.Rm + getSpeed(lastTimeStamp, asdf)
            end
            if v["To"] then
                local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.To + getSpeed(lastTimeStamp, asdf))
                times.To = 0
                TS:Create(Character.HumanoidRootPart["RootJoint"], Ti, { C0 = RoH * v["To"] }):Play()
            else
                times.To = times.To + getSpeed(lastTimeStamp, asdf)
            end
            if v["Hd"] then
                local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Hd + getSpeed(lastTimeStamp, asdf))
                times.Hd = 0
                TS:Create(Character.Torso["Neck"], Ti, { C0 = N * v["Hd"] }):Play()
            else
                times.Hd = times.Hd + getSpeed(lastTimeStamp, asdf)
            end
            task.wait(getSpeed(lastTimeStamp, asdf))
            lastTimeStamp = asdf
        end
    end
end

function Main:Stop()
    self.played = true
end

local animationplayer = Main
local LoadedAnimationTable = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
game.Players.LocalPlayer.Character.Archivable = true
local FakeCharacter = game.Players.LocalPlayer.Character:Clone()
Player.Character:BreakJoints()
Player.Character = nil
local Connection
Connection = game.Workspace.DescendantAdded:Connect(function(c)
    if c.Name == "Animate" and c.Parent == Player.Character then
        c.Enabled = false
        Connection:Disconnect()
    end
end)
repeat task.wait() until game.Players.LocalPlayer.Character
task.wait(0.1)
local RealChar = Player.Character
RealChar.Archivable = true
FakeCharacter.Name = Player.Name .. "_Fake"
FakeCharacter.Parent = workspace
local rig = animationplayer.LoadDummy(FakeCharacter)

-- Comment out the following lines to not load and play any animation
-- local track = rig:LoadAnimation("rbxassetid://17603135849")
-- coroutine.wrap(function()
--     track:Play()
-- end)()

task.spawn(function()
    for i, LS in ipairs(FakeCharacter:GetChildren()) do
        if LS:IsA("LocalScript") then
            LS.Enabled = false
            task.wait(0.1)
            LS.Enabled = false
        end
    end
end)

for i, Part in ipairs(FakeCharacter:GetDescendants()) do
    if Part:IsA("BasePart") then
        Part.Transparency = clone_transparency
    end
end

for i, Decal in ipairs(FakeCharacter:GetDescendants()) do
    if Decal:IsA("Decal") then
        Decal.Transparency = clone_transparency
    end
end

Player.Character = FakeCharacter

local function MotorAngle()
    if RealChar:FindFirstChild("Torso") then
        for MotorName, Motor6DAngle in pairs(Motors) do
            if RealChar:FindFirstChild("Torso"):FindFirstChild(MotorName) then
                RealChar:FindFirstChild("Torso"):FindFirstChild(MotorName).CurrentAngle = Motor6DAngle
            end
        end
    end
end

local function SetAngles()
    if FakeCharacter:FindFirstChild("Torso") then
        for MotorName, Motor6DAngle in pairs(Motors) do
            if FakeCharacter:FindFirstChild("Torso"):FindFirstChild(MotorName) then
                local Motor = FakeCharacter:FindFirstChild("Torso"):FindFirstChild(MotorName)
                local rx, ry, rz = Motor.Part1.CFrame:ToObjectSpace(FakeCharacter:FindFirstChild("Torso").CFrame):ToOrientation()
                if Motor.Name == "Right Shoulder" then
                    Motors[MotorName] = -rx
                end
                if Motor.Name == "Left Shoulder" then
                    Motors[MotorName] = rx
                end
                if Motor.Name == "Right Hip" then
                    Motors[MotorName] = -rx
                end
                if Motor.Name == "Left Hip" then
                    Motors[MotorName] = rx
                end
                if Motor.Name == "Neck" then
                    Motors[MotorName] = -ry
                end
            end
        end
    end
end

local function BaseCol()
    for i, Part in ipairs(RealChar:GetChildren()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = false
        end
    end
    for i, Part in ipairs(FakeCharacter:GetChildren()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = false
        end
    end
end

RunService.Heartbeat:Connect(function()
    SetAngles()
    MotorAngle()
    pcall(function()
    RealChar.HumanoidRootPart.CFrame = FakeCharacter.Torso.CFrame
end)
end)

RunService.PreSimulation:Connect(function()
    BaseCol()
end)

--[[
    FE SAD
    made by MyWorld#4430
    discord.gg/pYVHtSJmEY
    works on R6, R15, no hats needed
    controls: F to fly
]]

if "its sad enough to use MyWorld's reanimate" then
    --reanimate by MyWorld#4430 discord.gg/pYVHtSJmEY
    local Vector3_101 = Vector3.new(1, 0, 1)
    local netless_Y = Vector3.new(0, 25.1, 0)
    local function getNetlessVelocity(realPartVelocity) --edit this if you have a better netless method
        local netlessVelocity = realPartVelocity * Vector3_101
        local mag = netlessVelocity.Magnitude
        if mag > 0.1 then
            netlessVelocity *= 100 / mag
        end
        netlessVelocity += netless_Y
        return netlessVelocity
    end
    local simradius = "shp" --simulation radius (net bypass) method
    --"shp" - sethiddenproperty
    --"ssr" - setsimulationradius
    --false - disable
    local noclipAllParts = true --set it to true if you want noclip
    local flingpart = "HumanoidRootPart" --the part that will be used to fling (ctrl + F "fling function")
    local antiragdoll = true --removes hingeConstraints and ballSocketConstraints from your character
    local newanimate = true --disables the animate script and enables after reanimation
    local discharscripts = true --disables all localScripts parented to your character before reanimation
    local R15toR6 = true --tries to convert your character to r6 if its r15
    local hatcollide = true --makes hats cancollide (credit to ShownApe) (works only with reanimate method 0)
    local humState16 = true --enables collisions for limbs before the humanoid dies (using hum:ChangeState)
    local addtools = false --puts all tools from backpack to character and lets you hold them after reanimation
    local hedafterneck = true --disable aligns for head and enable after neck is removed
    local loadtime = game:GetService("Players").RespawnTime + 0.5 --anti respawn delay
    local method = 1 --reanimation method
    --methods:
    --0 - breakJoints (takes [loadtime] seconds to laod)
    --1 - limbs
    --2 - limbs + anti respawn
    --3 - limbs + breakJoints after [loadtime] seconds
    --4 - remove humanoid + breakJoints
    --5 - remove humanoid + limbs
    local alignmode = 3 --AlignPosition mode
    --modes:
    --1 - AlignPosition rigidity enabled true
    --2 - 2 AlignPositions rigidity enabled both true and false
    --3 - AlignPosition rigidity enabled false
    
    local lp = game:GetService("Players").LocalPlayer
    local rs = game:GetService("RunService")
    local stepped = rs.Stepped
    local heartbeat = rs.Heartbeat
    local renderstepped = rs.RenderStepped
    local sg = game:GetService("StarterGui")
    local ws = game:GetService("Workspace")
    local cf = CFrame.new
    local v3 = Vector3.new
    local v3_0 = v3(0, 0, 0)
    local inf = math.huge
    
    local c = lp.Character
    
    if not (c and c.Parent) then
    	return
    end
    
    c.Destroying:Connect(function()
    	c = nil
    end)
    
    local function gp(parent, name, className)
    	if typeof(parent) == "Instance" then
    		for i, v in pairs(parent:GetChildren()) do
    			if (v.Name == name) and v:IsA(className) then
    				return v
    			end
    		end
    	end
    	return nil
    end
    
    local function align(Part0, Part1)
    	Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)
    
    	local att0 = Instance.new("Attachment", Part0)
    	att0.Orientation = v3_0
    	att0.Position = v3_0
    	att0.Name = "att0_" .. Part0.Name
    	local att1 = Instance.new("Attachment", Part1)
    	att1.Orientation = v3_0
    	att1.Position = v3_0
    	att1.Name = "att1_" .. Part1.Name
    
    	if (alignmode == 1) or (alignmode == 2) then
    		local ape = Instance.new("AlignPosition", att0)
    		ape.ApplyAtCenterOfMass = false
    		ape.MaxForce = inf
    		ape.MaxVelocity = inf
    		ape.ReactionForceEnabled = false
    		ape.Responsiveness = 200
    		ape.Attachment1 = att1
    		ape.Attachment0 = att0
    		ape.Name = "AlignPositionRtrue"
    		ape.RigidityEnabled = true
    	end
    
    	if (alignmode == 2) or (alignmode == 3) then
    		local apd = Instance.new("AlignPosition", att0)
    		apd.ApplyAtCenterOfMass = false
    		apd.MaxForce = inf
    		apd.MaxVelocity = inf
    		apd.ReactionForceEnabled = false
    		apd.Responsiveness = 200
    		apd.Attachment1 = att1
    		apd.Attachment0 = att0
    		apd.Name = "AlignPositionRfalse"
    		apd.RigidityEnabled = false
    	end
    
    	local ao = Instance.new("AlignOrientation", att0)
    	ao.MaxAngularVelocity = inf
    	ao.MaxTorque = inf
    	ao.PrimaryAxisOnly = false
    	ao.ReactionTorqueEnabled = false
    	ao.Responsiveness = 200
    	ao.Attachment1 = att1
    	ao.Attachment0 = att0
    	ao.RigidityEnabled = false
    
    	if type(getNetlessVelocity) == "function" then
    	    local realVelocity = v3_0
            local steppedcon = stepped:Connect(function()
                Part0.Velocity = realVelocity
            end)
            local heartbeatcon = heartbeat:Connect(function()
                realVelocity = Part0.Velocity
                Part0.Velocity = getNetlessVelocity(realVelocity)
            end)
            Part0.Destroying:Connect(function()
                Part0 = nil
                steppedcon:Disconnect()
                heartbeatcon:Disconnect()
            end)
        end
    end
    
    local function respawnrequest()
    	local ccfr = ws.CurrentCamera.CFrame
    	local c = lp.Character
    	lp.Character = nil
    	lp.Character = c
    	local con = nil
    	con = ws.CurrentCamera.Changed:Connect(function(prop)
    	    if (prop ~= "Parent") and (prop ~= "CFrame") then
    	        return
    	    end
    	    ws.CurrentCamera.CFrame = ccfr
    	    con:Disconnect()
        end)
    end
    
    local destroyhum = (method == 4) or (method == 5)
    local breakjoints = (method == 0) or (method == 4)
    local antirespawn = (method == 0) or (method == 2) or (method == 3)
    
    hatcollide = hatcollide and (method == 0)
    
    addtools = addtools and gp(lp, "Backpack", "Backpack")
    
    local fenv = getfenv()
    local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
    local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.set_simulation_rad or fenv.setsimulationrad
    
    if shp and (simradius == "shp") then
    	spawn(function()
    		while c and heartbeat:Wait() do
    			shp(lp, "SimulationRadius", inf)
    		end
    	end)
    elseif ssr and (simradius == "ssr") then
    	spawn(function()
    		while c and heartbeat:Wait() do
    			ssr(inf)
    		end
    	end)
    end
    
    antiragdoll = antiragdoll and function(v)
    	if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
    		v.Parent = nil
    	end
    end
    
    if antiragdoll then
    	for i, v in pairs(c:GetDescendants()) do
    		antiragdoll(v)
    	end
    	c.DescendantAdded:Connect(antiragdoll)
    end
    
    if antirespawn then
    	respawnrequest()
    end
    
    if method == 0 then
    	wait(loadtime)
    	if not c then
    		return
    	end
    end
    
    if discharscripts then
    	for i, v in pairs(c:GetChildren()) do
    		if v:IsA("LocalScript") then
    			v.Disabled = true
    		end
    	end
    elseif newanimate then
    	local animate = gp(c, "Animate", "LocalScript")
    	if animate and (not animate.Disabled) then
    		animate.Disabled = true
    	else
    		newanimate = false
    	end
    end
    
    if addtools then
    	for i, v in pairs(addtools:GetChildren()) do
    		if v:IsA("Tool") then
    			v.Parent = c
    		end
    	end
    end
    
    pcall(function()
    	settings().Physics.AllowSleep = false
    	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    end)
    
    local OLDscripts = {}
    
    for i, v in pairs(c:GetDescendants()) do
    	if v.ClassName == "Script" then
    		table.insert(OLDscripts, v)
    	end
    end
    
    local scriptNames = {}
    
    for i, v in pairs(c:GetDescendants()) do
    	if v:IsA("BasePart") then
    		local newName = tostring(i)
    		local exists = true
    		while exists do
    			exists = false
    			for i, v in pairs(OLDscripts) do
    				if v.Name == newName then
    					exists = true
    				end
    			end
    			if exists then
    				newName = newName .. "_"    
    			end
    		end
    		table.insert(scriptNames, newName)
    		Instance.new("Script", v).Name = newName
    	end
    end
    
    c.Archivable = true
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
    	for i, v in pairs(hum:GetPlayingAnimationTracks()) do
    		v:Stop()
    	end
    end
    local cl = c:Clone()
    if hum and humState16 then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        if destroyhum then
            wait(1.6)
        end
    end
    if hum and hum.Parent and destroyhum then
        hum:Destroy()
    end
    
    if not c then
        return
    end
    
    local head = gp(c, "Head", "BasePart")
    local torso = gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart")
    local root = gp(c, "HumanoidRootPart", "BasePart")
    if hatcollide and c:FindFirstChildOfClass("Accessory") then
        local anything = c:FindFirstChildOfClass("BodyColors") or gp(c, "Health", "Script")
        if not (torso and root and anything) then
            return
        end
        torso:Destroy()
        root:Destroy()
        if shp then
            for i,v in pairs(c:GetChildren()) do
                if v:IsA("Accessory") then
                    shp(v, "BackendAccoutrementState", 0)
                end 
            end
        end
        anything:Destroy()
    end
    
    for i, v in pairs(cl:GetDescendants()) do
    	if v:IsA("BasePart") then
    		v.Transparency = 1
    		v.Anchored = false
    	end
    end
    
    local model = Instance.new("Model", c)
    model.Name = model.ClassName
    
    model.Destroying:Connect(function()
    	model = nil
    end)
    
    for i, v in pairs(c:GetChildren()) do
    	if v ~= model then
    		if addtools and v:IsA("Tool") then
    			for i1, v1 in pairs(v:GetDescendants()) do
    				if v1 and v1.Parent and v1:IsA("BasePart") then
    					local bv = Instance.new("BodyVelocity", v1)
    					bv.Velocity = v3_0
    					bv.MaxForce = v3(1000, 1000, 1000)
    					bv.P = 1250
    					bv.Name = "bv_" .. v.Name
    				end
    			end
    		end
    		v.Parent = model
    	end
    end
    
    if breakjoints then
    	model:BreakJoints()
    else
    	if head and torso then
    		for i, v in pairs(model:GetDescendants()) do
    			if v:IsA("Weld") or v:IsA("Snap") or v:IsA("Glue") or v:IsA("Motor") or v:IsA("Motor6D") then
    				local save = false
    				if (v.Part0 == torso) and (v.Part1 == head) then
    					save = true
    				end
    				if (v.Part0 == head) and (v.Part1 == torso) then
    					save = true
    				end
    				if save then
    					if hedafterneck then
    						hedafterneck = v
    					end
    				else
    					v:Destroy()
    				end
    			end
    		end
    	end
    	if method == 3 then
    		spawn(function()
    			wait(loadtime)
    			if model then
    				model:BreakJoints()
    			end
    		end)
    	end
    end
    
    cl.Parent = c
    for i, v in pairs(cl:GetChildren()) do
    	v.Parent = c
    end
    cl:Destroy()
    
    local noclipmodel = (noclipAllParts and c) or model
    local noclipcon = nil
    local function uncollide()
    	if noclipmodel then
    		for i, v in pairs(noclipmodel:GetDescendants()) do
    		    if v:IsA("BasePart") then
    			    v.CanCollide = false
    		    end
    		end
    	else
    		noclipcon:Disconnect()
    	end
    end
    noclipcon = stepped:Connect(uncollide)
    uncollide()
    
    for i, scr in pairs(model:GetDescendants()) do
    	if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
    		local Part0 = scr.Parent
    		if Part0:IsA("BasePart") then
    			for i1, scr1 in pairs(c:GetDescendants()) do
    				if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
    					local Part1 = scr1.Parent
    					if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
    						align(Part0, Part1)
    						break
    					end
    				end
    			end
    		end
    	end
    end
    
    if (typeof(hedafterneck) == "Instance") and head then
    	local aligns = {}
    	local con = nil
    	con = hedafterneck.Changed:Connect(function(prop)
    	    if (prop == "Parent") and not hedafterneck.Parent then
    	        con:Disconnect()
        		for i, v in pairs(aligns) do
        			v.Enabled = true
        		end
    		end
    	end)
    	for i, v in pairs(head:GetDescendants()) do
    		if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
    			i = tostring(i)
    			aligns[i] = v
    			v.Destroying:Connect(function()
    			    aligns[i] = nil
    			end)
    			v.Enabled = false
    		end
    	end
    end
    
    for i, v in pairs(c:GetDescendants()) do
    	if v and v.Parent then
    		if v.ClassName == "Script" then
    			if table.find(scriptNames, v.Name) then
    				v:Destroy()
    			end
    		elseif not v:IsDescendantOf(model) then
    			if v:IsA("Decal") then
    				v.Transparency = 1
    			elseif v:IsA("ForceField") then
    				v.Visible = false
    			elseif v:IsA("Sound") then
    				v.Playing = false
    			elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
    				v.Enabled = false
    			end
    		end
    	end
    end
    
    if newanimate then
    	local animate = gp(c, "Animate", "LocalScript")
    	if animate then
    		animate.Disabled = false
    	end
    end
    
    if addtools then
    	for i, v in pairs(c:GetChildren()) do
    		if v:IsA("Tool") then
    			v.Parent = addtools
    		end
    	end
    end
    
    local hum0 = model:FindFirstChildOfClass("Humanoid")
    if hum0 then
        hum0.Destroying:Connect(function()
            hum0 = nil
        end)
    end
    
    local hum1 = c:FindFirstChildOfClass("Humanoid")
    if hum1 then
        hum1.Destroying:Connect(function()
            hum1 = nil
        end)
    end
    
    if hum1 then
    	ws.CurrentCamera.CameraSubject = hum1
    	local camSubCon = nil
    	local function camSubFunc()
    		camSubCon:Disconnect()
    		if c and hum1 then
    			ws.CurrentCamera.CameraSubject = hum1
    		end
    	end
    	camSubCon = renderstepped:Connect(camSubFunc)
    	if hum0 then
    		hum0.Changed:Connect(function(prop)
    			if hum1 and (prop == "Jump") then
    				hum1.Jump = hum0.Jump
    			end
    		end)
    	else
    		respawnrequest()
    	end
    end
    
    local rb = Instance.new("BindableEvent", c)
    rb.Event:Connect(function()
    	rb:Destroy()
    	sg:SetCore("ResetButtonCallback", true)
    	if destroyhum then
    		c:BreakJoints()
    		return
    	end
    	if hum0 and (hum0.Health > 0) then
    		model:BreakJoints()
    		hum0.Health = 0
    	end
    	if antirespawn then
    	    respawnrequest()
    	end
    end)
    sg:SetCore("ResetButtonCallback", rb)
    
    spawn(function()
    	while c do
    		if hum0 and hum1 then
    			hum1.Jump = hum0.Jump
    		end
    		wait()
    	end
    	sg:SetCore("ResetButtonCallback", true)
    end)
    
    R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
    if R15toR6 then
        local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
    	if part then
    	    local cfr = part.CFrame
    		local R6parts = { 
    			head = {
    				Name = "Head",
    				Size = v3(2, 1, 1),
    				R15 = {
    					Head = 0
    				}
    			},
    			torso = {
    				Name = "Torso",
    				Size = v3(2, 2, 1),
    				R15 = {
    					UpperTorso = 0.2,
    					LowerTorso = -0.8
    				}
    			},
    			root = {
    				Name = "HumanoidRootPart",
    				Size = v3(2, 2, 1),
    				R15 = {
    					HumanoidRootPart = 0
    				}
    			},
    			leftArm = {
    				Name = "Left Arm",
    				Size = v3(1, 2, 1),
    				R15 = {
    					LeftHand = -0.85,
    					LeftLowerArm = -0.2,
    					LeftUpperArm = 0.4
    				}
    			},
    			rightArm = {
    				Name = "Right Arm",
    				Size = v3(1, 2, 1),
    				R15 = {
    					RightHand = -0.85,
    					RightLowerArm = -0.2,
    					RightUpperArm = 0.4
    				}
    			},
    			leftLeg = {
    				Name = "Left Leg",
    				Size = v3(1, 2, 1),
    				R15 = {
    					LeftFoot = -0.85,
    					LeftLowerLeg = -0.15,
    					LeftUpperLeg = 0.6
    				}
    			},
    			rightLeg = {
    				Name = "Right Leg",
    				Size = v3(1, 2, 1),
    				R15 = {
    					RightFoot = -0.85,
    					RightLowerLeg = -0.15,
    					RightUpperLeg = 0.6
    				}
    			}
    		}
    		for i, v in pairs(c:GetChildren()) do
    			if v:IsA("BasePart") then
    				for i1, v1 in pairs(v:GetChildren()) do
    					if v1:IsA("Motor6D") then
    						v1.Part0 = nil
    					end
    				end
    			end
    		end
    		part.Archivable = true
    		for i, v in pairs(R6parts) do
    			local part = part:Clone()
    			part:ClearAllChildren()
    			part.Name = v.Name
    			part.Size = v.Size
    			part.CFrame = cfr
    			part.Anchored = false
    			part.Transparency = 1
    			part.CanCollide = false
    			for i1, v1 in pairs(v.R15) do
    				local R15part = gp(c, i1, "BasePart")
    				local att = gp(R15part, "att1_" .. i1, "Attachment")
    				if R15part then
    					local weld = Instance.new("Weld", R15part)
    					weld.Name = "Weld_" .. i1
    					weld.Part0 = part
    					weld.Part1 = R15part
    					weld.C0 = cf(0, v1, 0)
    					weld.C1 = cf(0, 0, 0)
    					R15part.Massless = true
    					R15part.Name = "R15_" .. i1
    					R15part.Parent = part
    					if att then
    						att.Parent = part
    						att.Position = v3(0, v1, 0)
    					end
    				end
    			end
    			part.Parent = c
    			R6parts[i] = part
    		end
    		local R6joints = {
    			neck = {
    				Parent = R6parts.torso,
    				Name = "Neck",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.head,
    				C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
    				C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
    			},
    			rootJoint = {
    				Parent = R6parts.root,
    				Name = "RootJoint" ,
    				Part0 = R6parts.root,
    				Part1 = R6parts.torso,
    				C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
    				C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
    			},
    			rightShoulder = {
    				Parent = R6parts.torso,
    				Name = "Right Shoulder",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.rightArm,
    				C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    				C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
    			},
    			leftShoulder = {
    				Parent = R6parts.torso,
    				Name = "Left Shoulder",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.leftArm,
    				C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
    				C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    			},
    			rightHip = {
    				Parent = R6parts.torso,
    				Name = "Right Hip",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.rightLeg,
    				C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    				C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
    			},
    			leftHip = {
    				Parent = R6parts.torso,
    				Name = "Left Hip" ,
    				Part0 = R6parts.torso,
    				Part1 = R6parts.leftLeg,
    				C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
    				C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    			}
    		}
    		for i, v in pairs(R6joints) do
    			local joint = Instance.new("Motor6D")
    			for prop, val in pairs(v) do
    				joint[prop] = val
    			end
    			R6joints[i] = joint
    		end
    		hum1.RigType = Enum.HumanoidRigType.R6
    		hum1.HipHeight = 0
    	end
    end
    
    --fling function
    --usage: fling([part or CFrame or Vector3], [fling duration (seconds)], [rotation velocity (Vector3)])
    
    local flingpart0 = gp(model, flingpart, "BasePart")
    local flingpart1 = gp(c, flingpart, "BasePart")
    
    local fling = function() end
    if flingpart0 and flingpart1 then
        flingpart0.Destroying:Connect(function()
            flingpart0 = nil
            fling = function() end
        end)
        flingpart1.Destroying:Connect(function()
            flingpart1 = nil
            fling = function() end
        end)
        --flingpart1.Archivable = true
        local att0 = gp(flingpart0, "att0_" .. flingpart0.Name, "Attachment")
        local att1 = gp(flingpart1, "att1_" .. flingpart1.Name, "Attachment")
        if att0 and att1 then
            fling = function(target, duration, rotVelocity)
                if (typeof(target) == "Instance" and target:IsA("BasePart")) or (typeof(target) == "CFrame") then
                    target = target.Position
                elseif typeof(target) ~= "Vector3" then
                    return
                end
                if type(duration) ~= number then
                    duration = tonumber(duration) or 0.5
                end
                if typeof(rotVelocity) ~= "Vector3" then
                    rotVelocity = v3(20000, 20000, 20000)
                end
                if not (target and flingpart0 and flingpart1 and att0 and att1) then
                    return
                end
                local flingpart = flingpart0:Clone()
                flingpart.Transparency = 1
                flingpart.Size = v3(0.01, 0.01, 0.01)
                flingpart.CanCollide = false
                flingpart.Name = "flingpart_" .. flingpart0.Name
                flingpart.Anchored = true
                flingpart.Destroying:Connect(function()
                    flingpart = nil
                end)
                flingpart.Parent = flingpart1
                if flingpart0.Transparency > 0.5 then
                    flingpart0.Transparency = 0.5
                end
                att1.Parent = flingpart
                for i, v in pairs(att0:GetChildren()) do
                    if v:IsA("AlignOrientation") then
                        v.Enabled = false
                    end
                end
                local con = nil
                con = heartbeat:Connect(function()
                    if target and flingpart and flingpart0 and flingpart1 and att0 and att1 then
                        flingpart0.RotVelocity = rotVelocity
                        flingpart.Position = target
                    else
                        con:Disconnect()
                    end
                end)
                local steppedRotVel = v3(
                    ((target.X > 0) and -1) or 1,
                    ((target.Y > 0) and -1) or 1,
                    ((target.Z > 0) and -1) or 1
                )
                local con = nil
                con = stepped:Connect(function()
                    if target and flingpart and flingpart0 and flingpart1 and att0 and att1 then
                        flingpart0.RotVelocity = steppedRotVel
                        flingpart.Position = target
                    else
                        con:Disconnect()
                    end
                end)
                wait(duration)
                target = nil
                if not (flingpart and flingpart0 and flingpart1 and att0 and att1) then
                    return
                end
                flingpart0.RotVelocity = v3_0
                att1.Parent = flingpart1
                for i, v in pairs(att0:GetChildren()) do
                    if v:IsA("AlignOrientation") then
                        v.Enabled = true
                    end
                end
                flingpart:Destroy()
            end
        end
    end
end

--end of reanimate

local lp = game:GetService("Players").LocalPlayer

local ws = game:GetService("Workspace")

local c = lp.Character
if not (c and c.Parent) then
	return print("character not found")
end
c:GetPropertyChangedSignal("Parent"):Connect(function()
    if not (c and c.Parent) then
        c = nil
    end
end)

--getPart function

local function gp(parent, name, className)
	local ret = nil
	pcall(function()
		for i, v in pairs(parent:GetChildren()) do
			if (v.Name == name) and v:IsA(className) then
				ret = v
				break
			end
		end
	end)
	return ret
end

--check if reanimate loaded

local model = gp(c, "Model", "Model")
if not model then return print("model not found") end

--find body parts

local head = gp(c, "Head", "BasePart")
if not head then return print("head not found") end

local torso = gp(c, "Torso", "BasePart")
if not torso then return print("torso not found") end

local humanoidRootPart = gp(c, "HumanoidRootPart", "BasePart")
if not humanoidRootPart then return print("humanoid root part not found") end

local leftArm = gp(c, "Left Arm", "BasePart")
if not leftArm then return print("left arm not found") end

local rightArm = gp(c, "Right Arm", "BasePart")
if not rightArm then return print("right arm not found") end

local leftLeg = gp(c, "Left Leg", "BasePart")
if not leftLeg then return print("left leg not found") end

local rightLeg = gp(c, "Right Leg", "BasePart")
if not rightLeg then return print("right leg not found") end

--find rig joints

local neck = gp(torso, "Neck", "Motor6D")
if not neck then return print("neck not found") end

local rootJoint = gp(humanoidRootPart, "RootJoint", "Motor6D")
if not rootJoint then return print("root joint not found") end

local leftShoulder = gp(torso, "Left Shoulder", "Motor6D")
if not leftShoulder then return print("left shoulder not found") end

local rightShoulder = gp(torso, "Right Shoulder", "Motor6D")
if not rightShoulder then return print("right shoulder not found") end

local leftHip = gp(torso, "Left Hip", "Motor6D")
if not leftHip then return print("left hip not found") end

local rightHip = gp(torso, "Right Hip", "Motor6D")
if not rightHip then return print("right hip not found") end

--humanoid

local hum = c:FindFirstChildOfClass("Humanoid")
if not hum then return print("humanoid not found") end

local animate = gp(c, "Animate", "LocalScript")
if animate then
	animate.Disabled = true
end

for i, v in pairs(hum:GetPlayingAnimationTracks()) do
	v:Stop()
end

--60 fps

local fps = 60
local event = Instance.new("BindableEvent", c)
event.Name = "60 fps"
local floor = math.floor
fps = 1 / fps
local tf = 0
local con = nil
con = game:GetService("RunService").RenderStepped:Connect(function(s)
	if not c then
		con:Disconnect()
		return
	end
	tf += s
	if tf >= fps then
		for i=1, floor(tf / fps) do
			event:Fire(c)
		end
		tf = 0
	end
end)
local event = event.Event

local function stopIfRemoved(instance)
    if not (instance and instance.Parent) then
        c = nil
        return
    end
    instance:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (instance and instance.Parent) then
            c = nil
        end
    end)
end
stopIfRemoved(c)
stopIfRemoved(hum)
for i, v in pairs({head, torso, leftArm, rightArm, leftLeg, rightLeg, humanoidRootPart}) do
    stopIfRemoved(v)
end
for i, v in pairs({neck, rootJoint, leftShoulder, rightShoulder, leftHip, rightHip}) do
    stopIfRemoved(v)
end
if not c then
    return
end
uis = game:GetService("UserInputService")
local flying = false
uis.InputBegan:Connect(function(keycode)
    if uis:GetFocusedTextBox() then
        return
    end
	keycode = keycode.KeyCode
	if keycode == Enum.KeyCode.F then
	    flying = not flying
	end
end)
hum.WalkSpeed = 50
hum.HipHeight = 5
hum.JumpPower = 0
hum.CameraOffset = Vector3.new(0, -3, 0)
local flyspeed = 1
local cf, v3, euler, sin, sine = CFrame.new, Vector3.new, CFrame.fromEulerAnglesXYZ, math.sin, 0
while event:Wait() do
    sine += 1
    hum.PlatformStand = flying
    humanoidRootPart.Anchored = flying
    if flying then
        humanoidRootPart.Velocity = v3(0, 0, 0)
        local flycf = humanoidRootPart.CFrame
        local fb = ((uis:IsKeyDown("W") and flyspeed) or 0) + ((uis:IsKeyDown("S") and -flyspeed) or 0)
    	local lr = ((uis:IsKeyDown("A") and -flyspeed) or 0) + ((uis:IsKeyDown("D") and flyspeed) or 0)
    	local camcf = ws.CurrentCamera.CFrame
    	flycf += camcf.lookVector * fb
    	flycf += camcf.rightVector * lr
    	humanoidRootPart.CFrame = flycf
    end
    if humanoidRootPart.Velocity.Y < -20 then
        humanoidRootPart.Velocity = v3(0, -20, 0)
    end
    if humanoidRootPart.Velocity.Magnitude > 1 then -- walk
        neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.2217304763960306, 0.17453292519943295 * sin(sine * 0.025), -3.1590459461097367), 0.2) 
        rootJoint.C0 = rootJoint.C0:Lerp(cf(0, -2 + 0.5 * sin(sine * 0.05), 2) * euler(-2.443460952792061 + -0.08726646259971647 * sin((sine + 10) * 0.05), 0.05235987755982989 * sin(sine * 0.025), -3.1590459461097367 + -0.08726646259971647 * sin(sine * 0.025)), 0.2) 
        leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.5, 0) * euler(-0.12217304763960307 * sin((sine + 25) * 0.05), -1.5882496193148399 + -0.17453292519943295 * sin((sine + 20) * 0.05), -2.0943951023931953), 0.2) 
        rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5, 0) * euler(-0.12217304763960307 * sin((sine + 25) * 0.05), 1.5707963267948966 + 0.17453292519943295 * sin((sine + 20) * 0.05), 2.0943951023931953), 0.2) 
        leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1, 0) * euler(0, -1.5882496193148399, 0.3490658503988659 + -0.17453292519943295 * sin((sine + 30) * 0.05)), 0.2) 
        rightHip.C0 = rightHip.C0:Lerp(cf(1, -1, 0) * euler(0, 1.5707963267948966, -0.3490658503988659 + 0.17453292519943295 * sin((sine + 40) * 0.05)), 0.2) 
    else
        neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-2.0943951023931953 + -0.2617993877991494 * sin((sine + 20) * 0.05), 0.3490658503988659 * sin(sine * 0.025), -3.1590459461097367), 0.2) 
        rootJoint.C0 = rootJoint.C0:Lerp(cf(0, -2 + 1 * sin(sine * 0.05), 0) * euler(-2.792526803190927 + -0.08726646259971647 * sin((sine + 10) * 0.05), 0.05235987755982989 * sin(sine * 0.025), -3.1590459461097367 + -0.08726646259971647 * sin(sine * 0.025)), 0.2) 
        leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.5, 0) * euler(-0.12217304763960307 * sin((sine + 25) * 0.05), -1.5882496193148399 + -0.17453292519943295 * sin((sine + 20) * 0.05), -1.2217304763960306), 0.2) 
        rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5, 0) * euler(-0.12217304763960307 * sin((sine + 25) * 0.05), 1.5707963267948966 + 0.17453292519943295 * sin((sine + 20) * 0.05), 1.2217304763960306), 0.2) 
        leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1, 0) * euler(0, -1.5882496193148399, -1.2217304763960306 + -0.17453292519943295 * sin((sine + 30) * 0.05)), 0.2) 
        rightHip.C0 = rightHip.C0:Lerp(cf(1, -1, 0) * euler(0, 1.5707963267948966, 1.2217304763960306 + 0.17453292519943295 * sin((sine + 40) * 0.05)), 0.2) 
    end
end
    print("loading that mf...")

end


funTab:AddButton({
    Name = "Float (R6)",
    Callback = executeScript
})


miscTab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})



----------------------------------------------


local infoTab = Window:MakeTab({
    Name = "externals",
    Icon = "rbxassetid://7734053426",
    PremiumOnly = false
})

infoTab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})

infoTab:AddButton({
	Name = "Nameless Admin",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
	end
})

infoTab:AddButton({
	Name = "Dex Explorer 2.0 (Raspberry Pi)",
	Callback = function()
		loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
	end
})


infoTab:AddButton({
	Name = "Audio Logger",
	Callback = function()
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua'),true))()
	end
})

infoTab:AddButton({
	Name = "DarkDex 4.0 (Moon & Courtney)",
	Callback = function()
		loadstring(game:HttpGet("https://gist.githubusercontent.com/DinosaurXxX/b757fe011e7e600c0873f967fe427dc2/raw/ee5324771f017073fc30e640323ac2a9b3bfc550/dark%2520dex%2520v4"))()
	end
})

infoTab:AddButton({
	Name = "DarkDex 4.0 (Moon & Courtney)",
	Callback = function()
		loadstring(game:HttpGet("https://gist.githubusercontent.com/DinosaurXxX/b757fe011e7e600c0873f967fe427dc2/raw/ee5324771f017073fc30e640323ac2a9b3bfc550/dark%2520dex%2520v4"))()
	end
})

infoTab:AddButton({
	Name = "System Broken",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
	end
})


----------------------------------------------

local selectedPlayer = nil
local espEnabled = false
local espBox = nil
local bangActive = false
local BGanimationTrack = nil
local speed = 10


local function findClosestMatch(input)
    local inputLower = input:lower()
    local closestMatch = nil
    local shortestDistance = math.huge

    for _, player in pairs(game.Players:GetPlayers()) do
        local playerNameLower = player.Name:lower()
        local displayNameLower = player.DisplayName:lower()

        if playerNameLower:find(inputLower) or displayNameLower:find(inputLower) then
            local distance = math.min(
                #playerNameLower - #inputLower,
                #displayNameLower - #inputLower
            )

            if distance < shortestDistance then
                closestMatch = player
                shortestDistance = distance
            end
        end
    end

    return closestMatch
end

local function notify(title, text, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Time = duration or 5
    })
end


local highlightEnabled = false
local highlightEffect = nil
local espColor = Color3.fromRGB(255, 0, 255)  
local espTransparency = 0.3  


local function toggleESP()
    if not selectedPlayer then
        notify("Error", "No player selected!", 5)
        return
    end

    highlightEnabled = not highlightEnabled

    if highlightEnabled then
        local target = selectedPlayer.Character
        if target then
            
            highlightEffect = Instance.new("Highlight")
            highlightEffect.Name = "PlayerHighlight"
            highlightEffect.Adornee = target
            highlightEffect.FillColor = espColor
            highlightEffect.FillTransparency = espTransparency
            highlightEffect.OutlineColor = Color3.fromRGB(255, 255, 255)  
            highlightEffect.OutlineTransparency = 0  
            highlightEffect.Parent = target
        end
    else
        
        if highlightEffect then
            highlightEffect:Destroy()
            highlightEffect = nil
        end
    end
end



local viewing = false
local function toggleView()
    if not selectedPlayer then
        notify("Error", "No player selected!", 5)
        return
    end

    viewing = not viewing
    if viewing then
        game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
    else
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    end
end


local function teleportToPlayer()
    if not selectedPlayer then
        notify("Error", "No player selected!", 5)
        return
    end

    local targetRoot = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame
    else
        notify("Error", "Target not valid!", 5)
    end
end

local function toggleBang()
    if nbangActive then
        if BGanimationTrack then
            BGanimationTrack:Stop()
        end
        nbangActive = false
    else
        
        nbangActive = true
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        
        pcall(function()
            if humanoid.Parent:FindFirstChild("Pants") then
                humanoid.Parent.Pants:Destroy()
            end
            if humanoid.Parent:FindFirstChild("Shirt") then
                humanoid.Parent.Shirt:Destroy()
            end
        end)

        
        local animationId
        if humanoid.RigType == Enum.HumanoidRigType.R15 then
            animationId = 'rbxassetid://5918726674' 
        else
            animationId = 'rbxassetid://148840371' 
        end

        
        local clapAnimation = Instance.new('Animation')
        clapAnimation.AnimationId = animationId

        BGanimationTrack = humanoid:LoadAnimation(clapAnimation)
        BGanimationTrack:Play()
        BGanimationTrack:AdjustSpeed(5)

        
        spawn(function()
            while nbangActive do
                wait()
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPart = selectedPlayer.Character.HumanoidRootPart
                    local offsetPosition = targetPart.CFrame * CFrame.new(0, 0, 1.1) 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = offsetPosition
                else
                   
                    nbangActive = false
                end
            end

           
            if BGanimationTrack then
                BGanimationTrack:Stop()
            end
        end)
    end
end


local function lockOn(targetInput)
    local player = findClosestMatch(targetInput)
    if player then
        selectedPlayer = player
        notify("Locked On", "Player " .. player.Name .. " has been locked on!", 5)
    else
        notify("Error", "Player either left or doesn't exist!", 5)
    end
end


local function unlockPlayer()
    if selectedPlayer then
        notify("Unlocked", "Player " .. selectedPlayer.Name .. " has been unlocked!", 5)
        selectedPlayer = nil
    else
        notify("Error", "No player is locked on!", 5)
    end
end



local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local bangActive = false
local bangAnimation
local animationTrack
local faceBangConnection


local function isR15(character)
    return character:FindFirstChild("UpperTorso") ~= nil
end

local function getTorso(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart")
end

local function toggleFaceBang()
    if bangActive then

        bangActive = false
        if animationTrack then
            animationTrack:Stop()
            animationTrack:Destroy()
        end
        if faceBangConnection then
            faceBangConnection:Disconnect()
        end
    else

        if not selectedPlayer or not selectedPlayer.Character then
            return OrionLib:MakeNotification({
                Name = "Face Bang",
                Content = "Selected player is invalid!",
                Time = 5,
            })
        end

        local speaker = Players.LocalPlayer
        if not speaker.Character then
            return OrionLib:MakeNotification({
                Name = "Face Bang",
                Content = "Your character is not loaded!",
                Time = 5,
            })
        end

        local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end

        bangActive = true
        bangAnimation = Instance.new("Animation")
        bangAnimation.AnimationId = isR15(speaker.Character) and "rbxassetid://5918726674" or "rbxassetid://148840371"
        animationTrack = humanoid:LoadAnimation(bangAnimation)
        animationTrack:Play(0.1, 1, 1)
        animationTrack:AdjustSpeed(5)

        local bangDied = humanoid.Died:Connect(function()
            animationTrack:Stop()
            bangAnimation:Destroy()
            bangDied:Disconnect()
            bangActive = false
        end)

        local bangOffset = CFrame.new(0, 2.3, -1.1)

        faceBangConnection = RunService.Heartbeat:Connect(function()
            if not bangActive then return end

            local targetRoot = getTorso(selectedPlayer.Character)
            local speakerRoot = getRoot(speaker.Character)

            if targetRoot and speakerRoot then
                speakerRoot.CFrame = targetRoot.CFrame * bangOffset * CFrame.Angles(0, math.pi, 0)
                speakerRoot.Velocity = Vector3.new(0, 0, 0)
            else
                bangActive = false
                faceBangConnection:Disconnect()
                OrionLib:MakeNotification({
                    Name = "Face Bang",
                    Content = "Target player is missing essential parts!",
                    Time = 5,
                })
            end
        end)
    end
end

local TweenService = game:GetService("TweenService")
local stopTeleport = true
local followActive = false

local function tweenToPosition(part, targetPosition, targetLookPosition, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(part, tweenInfo, {CFrame = CFrame.new(targetPosition, targetLookPosition)})
    tween:Play()
    tween.Completed:Wait()
end

local function toggleFollow()
    if not selectedPlayer then
        notify("Error", "No player selected!", 5)
        return
    end

    followActive = not followActive
    stopTeleport = not followActive

    if followActive then
        coroutine.wrap(function()
            local moveForward = true 

            while not stopTeleport do
                if selectedPlayer and selectedPlayer.Character then
                    local targetHumanoidRootPart = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local playerHumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                    if targetHumanoidRootPart and playerHumanoidRootPart then
                        local targetCFrame = targetHumanoidRootPart.CFrame
                        local targetPosition

                        if moveForward then
                            targetPosition = targetCFrame.Position - targetCFrame.LookVector * 1 
                        else
                            targetPosition = targetCFrame.Position - targetCFrame.LookVector * 5 
                        end

                        tweenToPosition(playerHumanoidRootPart, targetPosition, targetCFrame.Position, 0.1)

                        moveForward = not moveForward
                    else
                        notify("Error", "Target lost or invalid!", 5)
                        stopTeleport = true
                        followActive = false
                        return
                    end
                else
                    notify("Error", "Selected player is invalid!", 5)
                    stopTeleport = true
                    followActive = false
                    return
                end

                wait(0) 
            end
        end)()
    end
end

local function SkidFling(TargetPlayer)
    local Character = game.Players.LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return notify("Error Occurred", "Target is sitting", 5)
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        else
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return notify("Error Occurred", "Target is missing everything", 5)
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
    else
        return notify("Error Occurred", "Random error", 5)
    end
end


pltargetTab:AddTextbox({
    Name = "Player to Target:",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        lockOn(value)
    end
})


pltargetTab:AddButton({
    Name = "View",
    Callback = function()
        toggleView()
    end
})

pltargetTab:AddButton({
    Name = "GoTo",
    Callback = function()
        teleportToPlayer()
    end
})

pltargetTab:AddButton({
    Name = "Fling",
    Callback = function()
        if selectedPlayer then
            SkidFling(selectedPlayer)
        else
            notify("Error", "No player selected!", 5)
        end
    end
})


pltargetTab:AddButton({
    Name = "Bang",
    Callback = function()
        toggleBang()
    end
})

pltargetTab:AddButton({
    Name = "TpBang",
    Callback = function()
        toggleFollow()
    end
})

pltargetTab:AddButton({
    Name = "FaceBang",
    Callback = function()
        toggleFaceBang()
    end
})

pltargetTab:AddButton({
    Name = "ESP",
    Callback = function()
        toggleESP()
    end
})

pltargetTab:AddButton({
    Name = "remove Target",
    Callback = function()
        unlockPlayer()
    end
})

pltargetTab:AddSlider({
    Name = "Bang Speed",
    Min = 5,
    Max = 30,
    Default = 5,  
    Increment = 0.5,
    Callback = function(speed)
        if bangActive and animationTrack then
            animationTrack:AdjustSpeed(speed)
        end
        if nbangActive and BGanimationTrack then
            BGanimationTrack:AdjustSpeed(speed)
        end
    end
})


playSection:AddButton({
    Name = "enable-chat-Tabs",
    Callback = function()
        function chat(msg)

            if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
            else
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
            end
        
        end
        
        local chatTab = Window:MakeTab({
            Name = "Chat Stuff",
            Icon = "rbxassetid://7734063416",
            PremiumOnly = false
        })
        
        chatTab:AddLabel("                                      CHAT BYPASS")
        
        local method = nil
        
        chatTab:AddDropdown({
            Name = "Method",
            Options = {"ěx́ǎḿṕĺě", "éxạmṕĺe", "ẹ̲х̲ạ̲ṃ̲р̲ḷ̲ẹ̲", "e>x>a>m>p>l>e", "￵example", "3></-\\/\\/\\p|_3"},
            Callback = function(val)
                method = val
            end
        })
        
        function bypasstext(text, method)
            if method == 1 then
                local function addAccents(word)
                    local accents = {
                        a = "ǎ",
                        b = "ḃ",
                        c = "ć",
                        d = "d́",
                        e = "ě",
                        f = "ḟ",
                        g = "ġ",
                        h = "ḣ",
                        i = "í",
                        j = "j́",
                        k = "ḱ",
                        l = "ĺ",
                        m = "ḿ",
                        n = "n̋",
                        o = "ō",
                        p = "ṕ",
                        q = "q́",
                        r = "ŕ",
                        s = "ś",
                        t = "t̋",
                        u = "ū",
                        v = "v̇",
                        w = "ẃ",
                        x = "x́",
                        y = "ý",
                        z = "ź",
                        A = "Ǎ",
                        B = "Ḃ",
                        C = "Ć",
                        D = "D́",
                        E = "Ě",
                        F = "Ḟ",
                        G = "Ġ",
                        H = "Ḣ",
                        I = "Í",
                        J = "J́",
                        K = "Ḱ",
                        L = "Ĺ",
                        M = "Ḿ",
                        N = "N̋",
                        O = "Ō",
                        P = "Ṕ",
                        Q = "Q́",
                        R = "Ŕ",
                        S = "Ś",
                        T = "T̋",
                        U = "Ū",
                        V = "V̇",
                        W = "Ẃ",
                        X = "X́",
                        Y = "Ý",
                        Z = "Ź"
                    }
        
                    local bypassedWord = ""
                    for i = 1, #word do
                        local letter = word:sub(i, i)
                        if accents[letter] then
                            bypassedWord = bypassedWord .. accents[letter]
                        else
                            bypassedWord = bypassedWord .. letter
                        end
                    end
        
                    return bypassedWord
                end
        
                local function bypassString(input)
                    local words = {}
                    for word in string.gmatch(input, "%S+") do
                        table.insert(words, addAccents(word))
                    end
                    return table.concat(words, " ")
                end
        
                return bypassString(text)
            elseif method == 2 then
                local function addAccents2(word)
                    local accents2 = {
                        a = "ạ",
                        b = "ḃ",
                        c = "c",
                        d = "d́",
                        e = "e",
                        f = "ḟ",
                        g = "ġ",
                        h = "ḣ",
                        i = "i",
                        j = "j́",
                        k = "ḳ",
                        l = "ĺ",
                        m = "m",
                        n = "n̋",
                        o = "o",
                        p = "ṕ",
                        q = "q́",
                        r = "ŕ",
                        s = "ṣ",
                        t = "t",
                        u = "ụ",
                        v = "v̇",
                        w = "ẃ",
                        x = "x́",
                        y = "y",
                        z = "z",
                        A = "Ạ",
                        B = "Ḃ",
                        C = "C",
                        D = "D́",
                        E = "E",
                        F = "Ḟ",
                        G = "Ġ",
                        H = "Ḣ",
                        I = "I",
                        J = "J́",
                        K = "Ḱ",
                        L = "Ĺ",
                        M = "M",
                        N = "N",
                        O = "O",
                        P = "Ṕ",
                        Q = "Q́",
                        R = "Ŕ",
                        S = "Ṣ",
                        T = "T",
                        U = "Ụ",
                        V = "V̇",
                        W = "Ẃ",
                        X = "X́",
                        Y = "Y",
                        Z = "Z"
                    }
        
                    local bypassedWord = ""
                    for i = 1, #word do
                        local letter = word:sub(i, i)
                        if accents2[letter] then
                            bypassedWord = bypassedWord .. accents2[letter]
                        else
                            bypassedWord = bypassedWord .. letter
                        end
                    end
        
                    return bypassedWord
                end
        
                local function bypassString(input)
                    local words = {}
                    for word in string.gmatch(input, "%S+") do
                        table.insert(words, addAccents2(word))
                    end
                    return table.concat(words, " ")
                end
        
                return bypassString(text)
            elseif method == 3 then
                local function addAccents3(word)
                    local accents3 = {
                        a = "ạ̲",
                        b = "ḅ̲",
                        c = "с̲",
                        d = "ḍ̲",
                        e = "ẹ̲",
                        f = "f̲",
                        g = "ɡ̲",
                        h = "ḥ̲",
                        i = "ị̲",
                        j = "ј̲",
                        k = "ḳ̲",
                        l = "ḷ̲",
                        m = "ṃ̲",
                        n = "ṇ̲",
                        o = "ọ̲",
                        p = "р̲",
                        q = "q̲",
                        r = "ṛ̲",
                        s = "ṣ̲",
                        t = "ṭ̲",
                        u = "ụ̲",
                        v = "ṿ̲",
                        w = "ẉ̲",
                        x = "х̲",
                        y = "ỵ̲",
                        z = "ẓ̲",
                        A = "Ạ̲",
                        B = "Ḅ̲",
                        C = "С̲",
                        D = "Ḍ̲",
                        E = "Ẹ̲",
                        F = "F̲",
                        G = "Ɡ̲",
                        H = "Ḥ̲",
                        I = "Ị̲",
                        J = "Ј̲",
                        K = "Ḳ̲",
                        L = "Ḷ̲",
                        M = "Ṃ̲",
                        N = "Ṇ̲",
                        O = "Ọ̲",
                        P = "Р̲",
                        Q = "Q̲",
                        R = "Ṛ̲",
                        S = "Ṣ̲",
                        T = "Ṭ̲",
                        U = "Ụ̲",
                        V = "Ṿ̲",
                        W = "Ẉ̲",
                        X = "Х̲",
                        Y = "Ỵ̲",
                        Z = "Ẓ̲"
                    }
        
                    local bypassedWord = ""
                    for i = 1, #word do
                        local letter = word:sub(i, i)
                        if accents3[letter] then
                            bypassedWord = bypassedWord .. accents3[letter]
                        else
                            bypassedWord = bypassedWord .. letter
                        end
                    end
        
                    return bypassedWord
                end
        
                local function bypassString(input)
                    local words = {}
                    for word in string.gmatch(input, "%S+") do
                        table.insert(words, addAccents3(word))
                    end
                    return table.concat(words, " ")
                end
        
                return bypassString(text)
            elseif method == 4 then
                local function modifyText(input)
                    local modifiedText = ""
                    for i = 1, #input do
                        modifiedText = modifiedText .. string.sub(input, i, i) .. ">"
                    end
        
                    return modifiedText
                end
        
                return modifyText(text)
            elseif method == 5 then
                local function addAccents5(word)
                    local accents5 = {
                        a = "a",
                        b = "b￵￵",
                        c = "c￵￵",
                        d = "d",
                        e = "￵￵e",
                        f = "￵￵󠀕f￵￵",
                        g = "g",
                        h = "h￵￵",
                        i = "￵￵i",
                        j = "￵￵j￵￵",
                        k = "k",
                        l = "l￵￵",
                        m = "m",
                        n = "n",
                        o = "o￵￵",
                        p = "p",
                        q = "q￵￵",
                        r = "￵￵r￵￵",
                        s = "￵￵s",
                        t = "￵￵t￵￵",
                        u = "u",
                        v = "v",
                        w = "w",
                        x = "x",
                        y = "y",
                        z = "￵￵z￵￵󠀕",
                        A = "A￵￵󠀕",
                        B = "B",
                        C = "C",
                        D = "￵￵D",
                        E = "￵￵E￵￵󠀕",
                        F = "F￵￵",
                        G = "￵￵G",
                        H = "H",
                        I = "￵￵I",
                        J = "￵￵J",
                        K = "K",
                        L = "￵￵L",
                        M = "M￵￵",
                        N = "N￵￵",
                        O = "O",
                        P = "P￵￵",
                        Q = "Q",
                        R = "￵￵R",
                        S = "S",
                        T = "T",
                        U = "￵￵U",
                        V = "V",
                        W = "W￵￵",
                        X = "￵￵X",
                        Y = "￵￵Y",
                        Z = "Z￵￵󠀕"
                    }
        
                    local bypassedWord = ""
                    for i = 1, #word do
                        local letter = word:sub(i, i)
                        if accents5[letter] then
                            bypassedWord = bypassedWord .. accents5[letter]
                        else
                            bypassedWord = bypassedWord .. letter
                        end
                    end
        
                    return bypassedWord
                end
        
                local function bypassString(input)
                    local words = {}
                    for word in string.gmatch(input, "%S+") do
                        table.insert(words, addAccents5(word))
                    end
                    return table.concat(words, "")
                end
        
                return bypassString(text)
            elseif method == 6 then
                local function addAccents6(word)
                    local accents6 = {
                        a = "/-\\",
                        b = "L3",
                        c = "C",
                        d = "CL",
                        e = "3",
                        f = "F",
                        g = "G",
                        h = "|-|",
                        i = "L",
                        j = "J",
                        k = "L<",
                        l = "|_",
                        m = "/\\/\\",
                        n = "/\\/",
                        o = "0",
                        p = "P",
                        q = "Q",
                        r = "R",
                        s = "$",
                        t = "T",
                        u = "|_|",
                        v = "\\/",
                        w = "\\/\\/",
                        x = "><",
                        y = "Y",
                        z = "Z"
                    }
        
                    local bypassedWord = ""
                    for i = 1, #word do
                        local letter = word:sub(i, i):lower()
                        if accents6[letter] then
                            bypassedWord = bypassedWord .. accents6[letter]
                        else
                            bypassedWord = bypassedWord .. letter
                        end
                    end
        
                    return bypassedWord
                end
        
                local function bypassString(input)
                    local words = {}
                    for word in string.gmatch(input, "%S+") do
                        table.insert(words, addAccents6(word))
                    end
                    return table.concat(words, " ")
                end
        
                return bypassString(text)
            end
        end
        
        chatTab:AddTextbox({
            Name = "Chat",
            TextDisappear = true,
            Callback = function(val)
                if val ~= "" then
                    if method == "ěx́ǎḿṕĺě" then
                        chat(bypasstext(val, 1))
                    elseif method == "éxạmṕĺe" then
                        chat(bypasstext(val, 2))
                    elseif method == "ẹ̲х̲ạ̲ṃ̲р̲ḷ̲ẹ̲" then
                        chat(bypasstext(val, 3))
                    elseif method == "e>x>a>m>p>l>e" then
                        chat(bypasstext(val, 4))
                    elseif method == "￵example" then
                        chat(bypasstext(val, 5))
                    elseif method == "3></-\\/\\/\\p|_3" then
                        chat(bypasstext(val, 6))
                    else
                        OrionLib:MakeNotification({
                            Name = "Ops.",
                            Content = "Looks like you didn't select a method!",
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    end
                else
                    OrionLib:MakeNotification({
                        Name = "Oops.",
                        Content = "Looks like you didn't enter any text!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
            end
        })
        
        local autobypass = false
        local textBox = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox
        
        chatTab:AddToggle({
            Name = "Auto Bypass",
            Default = false,
            Callback = function(val)
                autobypass = val
        
                if val == true then
                    OrionLib:MakeNotification({
                        Name = "Auto Bypass",
                        Content = "Auto bypass has been enabled!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                else
                    OrionLib:MakeNotification({
                        Name = "Auto Bypass",
                        Content = "Auto bypass has been disabled!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
        
                textBox.FocusLost:Connect(function(enter)
                    if enter and autobypass then
                        if textBox.Text ~= "" then
                            if method == "ěx́ǎḿṕĺě" then
                                chat(bypasstext(textBox.Text, 1))
                                textBox.Text = ""
                            elseif method == "éxạmṕĺe" then
                                chat(bypasstext(textBox.Text, 2))
                                textBox.Text = ""
                            elseif method == "ẹ̲х̲ạ̲ṃ̲р̲ḷ̲ẹ̲" then
                                chat(bypasstext(textBox.Text, 3))
                                textBox.Text = ""
                            elseif method == "e>x>a>m>p>l>e" then
                                chat(bypasstext(textBox.Text, 4))
                                textBox.Text = ""
                            elseif method == "￵example" then
                                chat(bypasstext(textBox.Text, 5))
                                textBox.Text = ""
                            elseif method == "3></-\\/\\/\\p|_3" then
                                chat(bypasstext(textBox.Text, 6))
                                textBox.Text = ""
                            else
                                OrionLib:MakeNotification({
                                    Name = "Ops.",
                                    Content = "Looks like you didn't select a method!",
                                    Image = "rbxassetid://4483345998",
                                    Time = 5
                                })
                            end
                        end
                    end
                end)
            end
        })
        
        chatTab:AddLabel("                                         CHAT LOG")
        
        local logging = false
        local webhook = ""
        
        function sendToWebhook(msg, username)
        
            local data = {
                content = msg,
                username = username
            }
        
            local requestData = {
                Url = webhook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                },
                Body = game:GetService("HttpService"):JSONEncode(data)
            }
        
            request(requestData)
        
        end
        
        chatTab:AddTextbox({
            Name = "Webhook",
            TextDisappear = false,
            Callback = function(val)
                webhook = val
            end
        })
        
        chatTab:AddToggle({
            Name = "Log",
            Default = false,
            Callback = function(val)
                if webhook == "" then
                    OrionLib:MakeNotification({
                        Name = "Oops.",
                        Content = "Looks like you didn't enter any webhook url!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                    return
                else
                    logging = val
        
                    if val == true then
                        OrionLib:MakeNotification({
                            Name = "Started logging",
                            Content = "Started logging messages at the given webhook!",
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    else
                        OrionLib:MakeNotification({
                            Name = "Stopped logging",
                            Content = "Stopped logging messages at the given webhook!",
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    end
                end
            end
        })
        
        chatTab:AddLabel("                                        CHAT SPAM")
        
        local spamMessage = ""
        local spamInterval = 1
        local spaming = false
        
        chatTab:AddTextbox({
            Name = "Message",
            TextDisappear = false,
            Callback = function(val)
                spamMessage = val
            end
        })
        
        chatTab:AddSlider({
            Name = "Interval",
            Min = spamInterval,
            Max = 100,
            Default = spamInterval,
            Increasmemt = 1,
            ValueName = "seconds",
            Callback = function(val)
                spamInterval = val
            end
        })
        
        chatTab:AddToggle({
            Name = "Spam",
            Default = false,
            Callback = function(val)
                if spamMessage == "" then
                    OrionLib:MakeNotification({
                        Name = "Ops.",
                        Content = "Looks like you didn't enter any text!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                else
                    spaming = val
        
                    if spaming then
                        repeat wait(spamInterval)
                            chat(spamMessage)
                        until spaming == false
                    end
                end
            end
        })
        
        chatTab:AddLabel("                                            OTHER")
        
        chatTab:AddButton({
            Name = "Tall Message",
            Callback = function()
                chat("".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. " ".. "\u{000D}" .. "")
            end
        })
        
        chatTab:AddButton({
            Name = "Fix Filter",
            Callback = function()
                chat("abcdefg()!")
            end
        })
        
        local botTab = Window:MakeTab({
            Name = "Chatbot",
            Icon = "rbxassetid://7733965118",
            PremiumOnly = false
        })
        
        
        local apiKey = ""
        local isChatbotEnabled = false
        local responseDistance = 5
        local botTemperature = 1
        local botModel = "llama3-8b-8192"
        local personality = "Default"
        local blacklist = {}
        
        function isBlacklisted(name)
            for _, blacklisted in pairs(blacklist) do
                if name == blacklisted then
                    return true
                end
            end
        
            return false
        end
        
        function askChatbot(msg, plrname)
            local requestData = {
                model = botModel,
                temperature = botTemperature,
                messages = {
                    {
                        role = "system",
                        content = "answer with short response(200 characters max) while following roblox chat filter. your personality: " .. personality
                    },
                    {
                        role = "user",
                        content = "My Name Is " .. plrname
                    },
                    {
                        role = "user",
                        content = msg
                    }
                }
            }
        
            local response = request({
                Url = "https://api.groq.com/openai/v1/chat/completions",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] = "Bearer " .. apiKey
                },
                Body = game:GetService("HttpService"):JSONEncode(requestData)
            })
        
            if #game:GetService("HttpService"):JSONDecode(response.Body).choices[1].message.content >= 200 then
                print("Response has reached the character limit!")
            else
                return game:GetService("HttpService"):JSONDecode(response.Body).choices[1].message.content
            end
        end
        
        botTab:AddTextbox({
            Name = "Groq api key",
            TextDisappear = false,
            Callback = function(val)
                apiKey = val
            end
        })
        
        botTab:AddSlider({
            Name = "Response Distance",
            Min = 0,
            Max = 100,
            Default = 5,
            Increasmemt = 1,
            ValueName = "studs",
            Callback = function(val)
                responseDistance = val
            end
        })
        
        botTab:AddDropdown({
            Name = "Model",
            Default = botModel,
            Options = {"gemma2-9b-it", "gemma-7b-it", "llama3-groq-70b-8192-tool-use-preview", "llama3-groq-8b-8192-tool-use-preview", "llama-3.1-70b-versatile", "llama-3.1-8b-instant", "llama-3.2-11b-vision-preview", "llama-3.2-90b-vision-preview", "llama3-70b-8192", "llama3-8b-8192"},
            Callback = function(val)
                botModel = val
            end
        })
        
        botTab:AddDropdown({
            Name = "Personality",
            Default = personality,
            Options = {"Default", "Aggressive", "Happy", "Criminal", "Indian Scammer", "Nerd", "Sarcastic", "Stupid"},
            Callback = function(val)
                personality = val
            end
        })
        
        botTab:AddTextbox({
            Name = "Custom Personality",
            TextDisappear = false,
            Callback = function(val)
                personality = val
            end
        })
        
        botTab:AddTextbox({
            Name = "Prompt",
            TextDisappear = true,
            Callback = function(val)
                OrionLib:MakeNotification({
                    Name = "Response From ChatBot",
                    Content = askChatbot(val, game.Players.LocalPlayer.Name),
                    Image = "rbxassetid://4483345998",
                    Time = 15
                })
            end
        })
        
        botTab:AddSlider({
            Name = "Temperature",
            Min = 0,
            Max = 2,
            Default = botTemperature,
            Increment = 0.01,
            Callback = function(val)
                botTemperature = val
            end
        })
        
        botTab:AddTextbox({
            Name = "Blacklist",
            TextDisappear = true,
            Callback = function(val)
                if game.Players:FindFirstChild(val) then
                    table.insert(blacklist, val)
        
                    OrionLib:MakeNotification({
                        Name = "Blacklist",
                        Content = "Player has been blacklisted!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
            end
        })
        
        botTab:AddTextbox({
            Name = "Whitelist",
            TextDisappear = true,
            Callback = function(val)
                for i, name in pairs(blacklist) do
                    if name == val then
                        table.remove(blacklist, i)
        
                        OrionLib:MakeNotification({
                            Name = "Whitelist",
                            Content = "Player has been whitelisted!",
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    end
                end
            end
        })
        
        botTab:AddToggle({
            Name = "Enabled",
            Default = false,
            Callback = function(val)
                isChatbotEnabled = val
        
                if val == true then
                    OrionLib:MakeNotification({
                        Name = "Ai ChatBot",
                        Content = "ChatBot has been enabled!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                elseif val == false then
                    OrionLib:MakeNotification({
                        Name = "Ai ChatBot",
                        Content = "ChatBot has been disabled!",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
            end
        })
        
        
        
        for _, player in pairs(game.Players:GetPlayers()) do
            player.Chatted:Connect(function(message)
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if isChatbotEnabled and distance <= responseDistance and player.Name ~= game.Players.LocalPlayer.Name and not isBlacklisted(player.Name) then
                    chat(askChatbot(message, player.Name))
                end
        
                if logging then
                    sendToWebhook("```" .. message .. "```", player.Name)
                end
            end)
        end
        
        game.Players.PlayerAdded:Connect(function(player)
            player.Chatted:Connect(function(message)
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if isChatbotEnabled and distance <= responseDistance and player.Name ~= game.Players.LocalPlayer.Name and not isBlacklisted(player.Name) then
                    chat(askChatbot(message, player.Name))
                end
        
                if logging then
                    sendToWebhook("```" .. message .. "```", player.Name)
                end
            end)
        end)
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

local hiddenfling = false
local flingThread


local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1

    while hiddenfling do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end


mageSection:AddButton({
    Name = "Touch Fling",
    Callback = function()
        hiddenfling = not hiddenfling

        if hiddenfling then
            
            OrionLib:MakeNotification({
                Name = "Fling Toggle On",
                Content = "Touch Fling is now ON!",
                Image = "rbxassetid://7734063416", 
                Time = 5
            })
          
            flingThread = coroutine.create(fling)
            coroutine.resume(flingThread)
        else
           
            OrionLib:MakeNotification({
                Name = "Fling Toggle Off",
                Content = "Touch Fling is now OFF!",
                Image = "rbxassetid://7734063416", 
                Time = 5
            })
            hiddenfling = false  
        end
    end
})

local voidProtectionEnabled = false

local function ToggleVoidProtection(bool)
    if bool then
        game.Workspace.FallenPartsDestroyHeight = 0/0  
    else
        game.Workspace.FallenPartsDestroyHeight = -500  
    end
end

mageSection:AddButton({
    Name = "anti-void",
    Callback = function()

        voidProtectionEnabled = not voidProtectionEnabled

        ToggleVoidProtection(voidProtectionEnabled)
    end
})

                   
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local savedPosition = nil


player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

tpSection:AddButton({
    Name = "Save Position",
    Callback = function()
        if humanoidRootPart then
            savedPosition = humanoidRootPart.Position
            OrionLib:MakeNotification({
                Name = "Position Saved",
                Content = "Your position has been saved at: " .. tostring(savedPosition),
                Image = "rbxassetid://4483345998",  
                Time = 5
            })
        end
    end
})

tpSection:AddButton({
    Name = "GoTo Saved Position",
    Callback = function()
        if savedPosition then

            if humanoidRootPart then
                
                humanoidRootPart.CFrame = CFrame.new(savedPosition)
                OrionLib:MakeNotification({
                    Name = "Teleport Successful",
                    Content = "You have been teleported to your saved position.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "HumanoidRootPart not found! Teleportation failed.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No position has been saved!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

tpSection:AddButton({
    Name = "Clear Saved Position",
    Callback = function()
        savedPosition = nil
        OrionLib:MakeNotification({
            Name = "Position Cleared",
            Content = "Your saved position has been cleared.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

funTab:AddButton({
    Name = "go insane",
    Callback = function()
        local plr = game.Players.LocalPlayer  
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            task.wait()
            plr.Character.Humanoid:ChangeState(0) 
            local bav = Instance.new("BodyAngularVelocity")  
            bav.Parent = plr.Character.HumanoidRootPart  
            bav.Name = "Spin"  
            bav.MaxTorque = Vector3.new(0, math.huge, 0)  
            bav.AngularVelocity = Vector3.new(0, 150, 0)  
            task.wait(3) 
            plr.Character.Humanoid:ChangeState(15)  
        end
    end
})

local animSection = funTab:AddSection({
    Name = "R6 FE animations"
})


local weirdAnimationPlaying = false
local weirdCurrentAnim = nil
animSection:AddButton({
    Name = "weird",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local AnimationId = "215384594"  
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://"..AnimationId
            
            if not weirdCurrentAnim then
                weirdCurrentAnim = humanoid:LoadAnimation(Anim)
            end
            
            if weirdAnimationPlaying then
                weirdCurrentAnim:Stop()
                weirdAnimationPlaying = false
            else
                weirdCurrentAnim:Play(0)
                weirdCurrentAnim:AdjustSpeed(1)
                weirdAnimationPlaying = true
            end
        end
    end
})


local heroJumpAnimationPlaying = false
local heroJumpCurrentAnim = nil
animSection:AddButton({
    Name = "hero jump",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local AnimationId = "184574340"  
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://"..AnimationId
            
            if not heroJumpCurrentAnim then
                heroJumpCurrentAnim = humanoid:LoadAnimation(Anim)
            end
            
            if heroJumpAnimationPlaying then
                heroJumpCurrentAnim:Stop()
                heroJumpAnimationPlaying = false
            else
                heroJumpCurrentAnim:Play(0)
                heroJumpCurrentAnim:AdjustSpeed(1)
                heroJumpAnimationPlaying = true
            end
        end
    end
})


local floatingHeadAnimationPlaying = false
local floatingHeadCurrentAnim = nil
animSection:AddButton({
    Name = "floating head",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local AnimationId = "121572214"  
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://"..AnimationId
            
            if not floatingHeadCurrentAnim then
                floatingHeadCurrentAnim = humanoid:LoadAnimation(Anim)
            end
            
            if floatingHeadAnimationPlaying then
                floatingHeadCurrentAnim:Stop()
                floatingHeadAnimationPlaying = false
            else
                floatingHeadCurrentAnim:Play(0)
                floatingHeadCurrentAnim:AdjustSpeed(1)
                floatingHeadAnimationPlaying = true
            end
        end
    end
})


local cloneIllusionAnimationPlaying = false
local cloneIllusionCurrentAnim = nil
animSection:AddButton({
    Name = "head throw",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local AnimationId = "35154961"  
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://"..AnimationId
            
            if not cloneIllusionCurrentAnim then
                cloneIllusionCurrentAnim = humanoid:LoadAnimation(Anim)
            end
            
            if cloneIllusionAnimationPlaying then
                cloneIllusionCurrentAnim:Stop()
                cloneIllusionAnimationPlaying = false
            else
                cloneIllusionCurrentAnim:Play(0)
                cloneIllusionCurrentAnim:AdjustSpeed(1)
                cloneIllusionAnimationPlaying = true
            end
        end
    end
})


local moonDanceAnimationPlaying = false
local moonDanceCurrentAnim = nil
animSection:AddButton({
    Name = "moon dance",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local AnimationId = "45834924" 
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://"..AnimationId
            
            if not moonDanceCurrentAnim then
                moonDanceCurrentAnim = humanoid:LoadAnimation(Anim)
            end
            
            if moonDanceAnimationPlaying then
                moonDanceCurrentAnim:Stop()
                moonDanceAnimationPlaying = false
            else
                moonDanceCurrentAnim:Play(0)
                moonDanceCurrentAnim:AdjustSpeed(1)
                moonDanceAnimationPlaying = true
            end
        end
    end
})


local dinoWalkAnimationPlaying = false
local dinoWalkCurrentAnim = nil
local dinoWalkHeartbeatConnection = nil 
local RunService = game:GetService("RunService")


local function getCharacterAndHumanoid()
    local plr = game.Players.LocalPlayer
    local character = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    return character, humanoid
end

animSection:AddButton({
    Name = "goon",
    Callback = function()
        local character, humanoid = getCharacterAndHumanoid()
        if humanoid then
            local AnimationId = "168268306"
            local Anim = Instance.new("Animation")
            Anim.AnimationId = "rbxassetid://" .. AnimationId

            if not dinoWalkCurrentAnim or dinoWalkCurrentAnim.Parent ~= humanoid then

                dinoWalkCurrentAnim = humanoid:LoadAnimation(Anim)
            end

            if dinoWalkAnimationPlaying then

                dinoWalkAnimationPlaying = false
                if dinoWalkCurrentAnim.IsPlaying then
                    dinoWalkCurrentAnim:Stop()
                end
                if dinoWalkHeartbeatConnection then
                    dinoWalkHeartbeatConnection:Disconnect()
                    dinoWalkHeartbeatConnection = nil
                end
            else

                dinoWalkAnimationPlaying = true
                dinoWalkHeartbeatConnection = RunService.Heartbeat:Connect(function()
                    if dinoWalkCurrentAnim.IsPlaying then
                        dinoWalkCurrentAnim:Stop()
                    else
                        dinoWalkCurrentAnim:Play(0)
                        dinoWalkCurrentAnim:AdjustSpeed(50)
                    end
                end)
            end
        end
    end
})


game.Players.LocalPlayer.CharacterAdded:Connect(function()
    dinoWalkAnimationPlaying = false
    if dinoWalkHeartbeatConnection then
        dinoWalkHeartbeatConnection:Disconnect()
        dinoWalkHeartbeatConnection = nil
    end
    dinoWalkCurrentAnim = nil
end)

mveSection:AddButton({
    Name = "[C] to speed",
    Callback = function()
        isSpeedEnabled = not isSpeedEnabled
        isMoving = false  
        if isSpeedEnabled then
            OrionLib:MakeNotification({
                Name = "Speed Enabled",
                Content = "Speed movement is now enabled. Hold C to move.",
                Image = "rbxassetid://6031761837",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Speed Disabled",
                Content = "Speed movement is now disabled.",
                Image = "rbxassetid://6031761837",
                Time = 3
            })
        end
    end
})

mveSection:AddSlider({
    Name = "CFrame speed",
    Min = 10,
    Max = 200,
    Default = 25,  
    Increment = 5,
    Callback = function(val)
        speed = val
    end
})


game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.C then
        if isSpeedEnabled then
            isCKeyHeld = true 
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        isCKeyHeld = false  
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if isSpeedEnabled and isCKeyHeld then
        local direction = humanoidRootPart.CFrame.LookVector
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + direction * (speed / 10)
    end
end)

local AntiBangEnabled = false
local IsVoiding = false
local AnimCheck = true
local AbMagnitude = 2
local AbDelay = 1
local RanTP = false
local VoidDepth = -499

local Player = game.Players.LocalPlayer
local RootPart, Humanoid, Character
local Camera = game.Workspace.CurrentCamera


local function GetNearestPlayers()
    if RootPart then
        for _, x in next, game.Players:GetPlayers() do
            if x ~= Player then
                local x_Character = x.Character
                local x_Humanoid = x_Character and x_Character:FindFirstChildWhichIsA("Humanoid")
                local x_RootPart = x_Humanoid and x_Humanoid.RootPart

                if x_RootPart and (RootPart.Position - x_RootPart.Position).Magnitude < AbMagnitude then
                    if AnimCheck then
                        for _, track in next, x_Humanoid:GetPlayingAnimationTracks() do
                            if track.Animation and (track.Animation.AnimationId:match("148840371") or track.Animation.AnimationId:match("5918726674")) then
                                return true
                            end
                        end
                        return false
                    else
                        return true
                    end
                end
            end
        end
    end
    return false
end


local function VoidPlayer()
    if Character and Humanoid and RootPart then
        local CurrentPosition = RootPart.CFrame
        local OldDH = workspace.FallenPartsDestroyHeight

        workspace.FallenPartsDestroyHeight = math.huge 
        RootPart.CFrame = CFrame.new(0, VoidDepth, 0) * CFrame.Angles(math.rad(90), 0, 0)
        RootPart.AssemblyLinearVelocity = Vector3.new()
        task.wait(AbDelay)

        RootPart.AssemblyLinearVelocity = Vector3.new()
        RootPart.CFrame = CurrentPosition
        workspace.FallenPartsDestroyHeight = OldDH
    end
end


spawn(function()
    while true do
        if AntiBangEnabled then
            Character = Player.Character
            Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
            RootPart = Humanoid and Humanoid.RootPart

            if GetNearestPlayers() and Humanoid and RootPart and not IsVoiding then
                if RanTP then
                    RootPart.CFrame = RootPart.CFrame + Vector3.new(math.random(1, 50), 0, math.random(1, 50))
                else
                    IsVoiding = true
                    local CurrentPosition = RootPart.Velocity.Magnitude < 50 and RootPart.CFrame or Camera.Focus
                    local Timer = tick()
                    local OldDH = workspace.FallenPartsDestroyHeight

                    repeat
                        workspace["\x46\x61\x6C\x6C\x65\x6E\x50\x61\x72\x74\x73\x44\x65\x73\x74\x72\x6F\x79\x48\x65\x69\x67\x68\x74"] = 0 / 0
                        RootPart.CFrame = CFrame.new(0, VoidDepth, 0) * CFrame.Angles(math.rad(90), 0, 0)
                        RootPart.AssemblyLinearVelocity = Vector3.new()
                        task.wait()
                    until tick() > Timer + AbDelay

                    RootPart.AssemblyLinearVelocity = Vector3.new()
                    RootPart.CFrame = CurrentPosition

                    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    workspace["\x46\x61\x6C\x6C\x65\x6E\x50\x61\x72\x74\x73\x44\x65\x73\x74\x72\x6F\x79\x48\x65\x69\x67\x68\x74"] = OldDH
                    IsVoiding = false
                end
            end
        end
        task.wait()
    end
end)


local function ToggleAntiBang()
    AntiBangEnabled = not AntiBangEnabled

    if AntiBangEnabled then
        OrionLib:MakeNotification({
            Name = "anti-Bang is now ON",
            Content = "You are now protected from getting diddled",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "anti-bang is now OFF",
            Content = "you are no longer safe..",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end


mageSection:AddButton({
    Name = "anti-bang",
    Callback = ToggleAntiBang
})


tpSection:AddButton({
    Name = "Tp into sky",
    Callback = function()
        local savedPosition = player.Character.PrimaryPart.Position
        player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition.X, 100000, savedPosition.Z))
    end
})


OrionLib:Init()
