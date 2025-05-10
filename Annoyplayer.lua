local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI Erstellung
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local DragBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")

-- GUI zum CoreGui hinzufügen
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Hauptframe
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.BorderSizePixel = 0

-- DragBar
DragBar.Name = "DragBar"
DragBar.Parent = MainFrame
DragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DragBar.Size = UDim2.new(1, 0, 0, 25)
DragBar.BorderSizePixel = 0

-- Titel
Title.Parent = DragBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Body Lifter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
CloseButton.Parent = DragBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(1, -20, 0, 5)
CloseButton.Size = UDim2.new(0, 15, 0, 15)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Toggle Button
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 45)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ACTIVATE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

-- Variablen
local Dragging = false
local DragStart = nil
local StartPos = nil
local BodyLifted = false
local UpdateConnection = nil
local originalPositions = {}
local currentKeyframe = 1
local animationTime = 0
local lastKeyframeTime = 0

-- Keyframe System
local keyframes = 
{
    -- Keyframe 1

    {
        duration = 0.1,
        config = {
            Head = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            UpperTorso = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LowerTorso = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftUpperArm = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftLowerArm = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftHand = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightUpperArm = {
                position = Vector3.new(-10, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = "AK_ADMEN2"
            },
            RightLowerArm = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightHand = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftUpperLeg = {
                position = Vector3.new(0, -10, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = "AK_ADMEN2"
            },
            LeftLowerLeg = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftFoot = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightUpperLeg = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightLowerLeg = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightFoot = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            }
        }
        
        
    },
        {
        duration = 0.1,
        config = {
            Head = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            UpperTorso = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LowerTorso = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftUpperArm = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftLowerArm = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftHand = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightUpperArm = {
                position = Vector3.new(10, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = "AK_ADMEN2"
            },
            RightLowerArm = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightHand = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftUpperLeg = {
                position = Vector3.new(0, 10, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = "AK_ADMEN2"
            },
            LeftLowerLeg = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            LeftFoot = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightUpperLeg = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightLowerLeg = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            },
            RightFoot = {
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
            }
        }
        
        
    }



    

}

-- Liste der Körperteile
local bodyParts = {}
for partName, _ in pairs(keyframes[1].config) do
    table.insert(bodyParts, partName)
end

-- Funktion zum Berechnen der Verbindungspunkte
local function GetJointOffset(part)
    return part.Size.Y/2
end

-- Funktion zum Interpolieren zwischen zwei Vektoren
local function LerpVector3(start, target, alpha)
    return start:Lerp(target, alpha)
end

-- Drag Funktionalität
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- Funktion zum Speichern der ursprünglichen Positionen
local function SaveOriginalPositions()
    local character = Players.LocalPlayer.Character
    if character then
        for partName, _ in pairs(keyframes[1].config) do
            local part = character:FindFirstChild(partName)
            if part then
                originalPositions[partName] = part.CFrame
            end
        end
    end
end

-- Funktion zum Aktualisieren eines einzelnen Körperteils
local function UpdateBodyPart(character, partName, currentConfig, nextConfig, alpha)
    local part = character:FindFirstChild(partName)
    if part and BodyLifted then
        local basePosition = originalPositions[partName]
        if basePosition then
            -- Interpoliere zwischen aktuellem und nächstem Keyframe
            local lerpedPosition = LerpVector3(currentConfig.position, nextConfig.position, alpha)
            local lerpedRotationX = currentConfig.rotation.X + (nextConfig.rotation.X - currentConfig.rotation.X) * alpha
            local lerpedRotationY = currentConfig.rotation.Y + (nextConfig.rotation.Y - currentConfig.rotation.Y) * alpha
            local lerpedRotationZ = currentConfig.rotation.Z + (nextConfig.rotation.Z - currentConfig.rotation.Z) * alpha
            
            local targetCFrame = basePosition
            
            -- Wenn ein Ziel-Spieler gesetzt ist
            local targetPlayer = currentConfig.targetPlayer
            if targetPlayer and targetPlayer ~= "" then
                local targetCharacter = Players:FindFirstChild(targetPlayer)
                if targetCharacter and targetCharacter.Character then
                    local targetHumanoidRootPart = targetCharacter.Character:FindFirstChild("HumanoidRootPart")
                    if targetHumanoidRootPart then
                        -- Berechne die Position relativ zum Ziel-Spieler
                        targetCFrame = targetHumanoidRootPart.CFrame * 
                            CFrame.new(lerpedPosition) * 
                            CFrame.Angles(
                                math.rad(lerpedRotationX),
                                math.rad(lerpedRotationY),
                                math.rad(lerpedRotationZ)
                            )
                    end
                end
            else
                -- Normale Position ohne Ziel-Spieler
                targetCFrame = basePosition * 
                    CFrame.new(lerpedPosition) * 
                    CFrame.Angles(
                        math.rad(lerpedRotationX),
                        math.rad(lerpedRotationY),
                        math.rad(lerpedRotationZ)
                    )
            end
            
            part.CFrame = targetCFrame
            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end

-- Body Update Funktion
local function UpdateBody()
    local character = Players.LocalPlayer.Character
    if character and BodyLifted then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            
            -- Berechne die verstrichene Zeit seit dem letzten Keyframe
            local deltaTime = tick() - lastKeyframeTime
            animationTime = animationTime + deltaTime
            lastKeyframeTime = tick()
            
            -- Bestimme aktuellen und nächsten Keyframe
            local currentFrame = keyframes[currentKeyframe]
            local nextFrame = keyframes[currentKeyframe + 1]
            if not nextFrame then
                nextFrame = keyframes[1]
            end
            
            -- Berechne Interpolationsfaktor
            local alpha = math.min(animationTime / currentFrame.duration, 1)
            
            -- Aktualisiere alle Körperteile
            for partName, _ in pairs(currentFrame.config) do
                UpdateBodyPart(character, partName, currentFrame.config[partName], nextFrame.config[partName], alpha)
            end
            
            -- Wechsle zum nächsten Keyframe wenn die Zeit abgelaufen ist
            if alpha >= 1 then
                currentKeyframe = currentKeyframe + 1
                if currentKeyframe > #keyframes then
                    currentKeyframe = 1
                end
                animationTime = 0
            end
        end
    end
end

-- Funktion zum sicheren Deaktivieren des Ragdolls
local function SafeDeactivateRagdoll()
    for i = 1, 3 do
        ReplicatedStorage.UnragdollEvent:FireServer()
        task.wait(0.1)
    end
    
    local character = Players.LocalPlayer.Character
    if character then
        for partName, _ in pairs(keyframes[1].config) do
            local part = character:FindFirstChild(partName)
            if part and originalPositions[partName] then
                part.CFrame = originalPositions[partName]
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

-- Toggle Button Funktion
ToggleButton.MouseButton1Click:Connect(function()
    BodyLifted = not BodyLifted
    
    if BodyLifted then
        ToggleButton.Text = "DEACTIVATE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        
        SaveOriginalPositions()
        currentKeyframe = 1
        animationTime = 0
        lastKeyframeTime = tick()
        
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        UpdateConnection = RunService.Heartbeat:Connect(UpdateBody)
        
        ReplicatedStorage.RagdollEvent:FireServer()
    else
        ToggleButton.Text = "ACTIVATE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 45)
        
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        
        SafeDeactivateRagdoll()
    end
end)

-- Close Button Funktion
CloseButton.MouseButton1Click:Connect(function()
    if BodyLifted then
        BodyLifted = false
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        
        SafeDeactivateRagdoll()
    end
    ScreenGui:Destroy()
end)

-- Reset beim Respawn
Players.LocalPlayer.CharacterAdded:Connect(function()
    if BodyLifted then
        BodyLifted = false
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        ToggleButton.Text = "ACTIVATE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 180, 45)
        
        SafeDeactivateRagdoll()
    end
end)
