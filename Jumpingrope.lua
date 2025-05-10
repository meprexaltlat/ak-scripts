local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

-- Add GUI to CoreGui
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Position = UDim2.new(0.95, -30, 0.05, 0)  -- Adjusted Y position from 0.02 to 0.05
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "🦘"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.AutoButtonColor = false

-- Create rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = ToggleButton

-- Variables
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
        duration = 1.1,
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
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
                position = Vector3.new(-1000, -150, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
        duration = 1.1,
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
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
                position = Vector3.new(0, -150, -1000),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
        duration = 1.1,
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
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
                position = Vector3.new(1000, 150, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
        duration = 1.1,
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
                position = Vector3.new(0, 0, 0),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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
                position = Vector3.new(0, 150, 1000),
                rotation = Vector3.new(0, 0, 0),
                targetPlayer = ""
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

-- List of body parts
local bodyParts = {}
for partName, _ in pairs(keyframes[1].config) do
    table.insert(bodyParts, partName)
end

-- Function to calculate joint offsets
local function GetJointOffset(part)
    return part.Size.Y/2
end

-- Function to interpolate between two vectors
local function LerpVector3(start, target, alpha)
    return start:Lerp(target, alpha)
end

-- Function to save original positions
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

-- Function to update a single body part
local function UpdateBodyPart(character, partName, currentConfig, nextConfig, alpha)
    local part = character:FindFirstChild(partName)
    if part and BodyLifted then
        local basePosition = originalPositions[partName]
        if basePosition then
            -- Interpolate between current and next keyframe
            local lerpedPosition = LerpVector3(currentConfig.position, nextConfig.position, alpha)
            local lerpedRotationX = currentConfig.rotation.X + (nextConfig.rotation.X - currentConfig.rotation.X) * alpha
            local lerpedRotationY = currentConfig.rotation.Y + (nextConfig.rotation.Y - currentConfig.rotation.Y) * alpha
            local lerpedRotationZ = currentConfig.rotation.Z + (nextConfig.rotation.Z - currentConfig.rotation.Z) * alpha
            
            local targetCFrame = basePosition
            
            -- If a target player is set
            local targetPlayer = currentConfig.targetPlayer
            if targetPlayer and targetPlayer ~= "" then
                local targetCharacter = Players:FindFirstChild(targetPlayer)
                if targetCharacter and targetCharacter.Character then
                    local targetHumanoidRootPart = targetCharacter.Character:FindFirstChild("HumanoidRootPart")
                    if targetHumanoidRootPart then
                        -- Calculate position relative to target player
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
                -- Normal position without target player
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

-- Body Update Function
local function UpdateBody()
    local character = Players.LocalPlayer.Character
    if character and BodyLifted then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            
            -- Calculate elapsed time since last keyframe
            local deltaTime = tick() - lastKeyframeTime
            animationTime = animationTime + deltaTime
            lastKeyframeTime = tick()
            
            -- Determine current and next keyframe
            local currentFrame = keyframes[currentKeyframe]
            local nextFrame = keyframes[currentKeyframe + 1]
            if not nextFrame then
                nextFrame = keyframes[1]
            end
            
            -- Calculate interpolation factor
            local alpha = math.min(animationTime / currentFrame.duration, 1)
            
            -- Update all body parts
            for partName, _ in pairs(currentFrame.config) do
                UpdateBodyPart(character, partName, currentFrame.config[partName], nextFrame.config[partName], alpha)
            end
            
            -- Switch to next keyframe when time is up
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

-- Function to safely deactivate ragdoll
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

-- Toggle Button Function
ToggleButton.MouseButton1Click:Connect(function()
    BodyLifted = not BodyLifted
    
    if BodyLifted then
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
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        
        SafeDeactivateRagdoll()
    end
end)

-- Reset on Respawn
Players.LocalPlayer.CharacterAdded:Connect(function()
    if BodyLifted then
        BodyLifted = false
        if UpdateConnection then
            UpdateConnection:Disconnect()
        end
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        
        SafeDeactivateRagdoll()
    end
end)
