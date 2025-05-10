local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Teleportation and floating function
local function teleportAndReturn()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local camera = Workspace.CurrentCamera

    local originalCFrame = humanoidRootPart.CFrame
    local targetPosition = Vector3.new(244.93862915039062, 3.0289804935455322, -92.26840209960938)
    local floatUpHeight = 30

    local function disableAnimations()
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
        humanoid.AutoRotate = false
    end

    local function enableAnimations()
        humanoid.AutoRotate = true
    end

    disableAnimations()
    local initialCameraCFrame = camera.CFrame
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = initialCameraCFrame

    local tweenService = game:GetService("TweenService")

    local floatUpInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local goalFloatUp = {CFrame = humanoidRootPart.CFrame + Vector3.new(0, floatUpHeight, 0)}
    local floatUpTween = tweenService:Create(humanoidRootPart, floatUpInfo, goalFloatUp)
    floatUpTween:Play()
    floatUpTween.Completed:Wait()

    local moveBackInfo = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local goalMoveBack = {CFrame = CFrame.new(originalCFrame.Position.X, targetPosition.Y + floatUpHeight, originalCFrame.Position.Z)}
    local moveBackTween = tweenService:Create(humanoidRootPart, moveBackInfo, goalMoveBack)
    moveBackTween:Play()
    moveBackTween.Completed:Wait()

    local floatDownInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local goalFloatDown = {CFrame = originalCFrame}
    local floatDownTween = tweenService:Create(humanoidRootPart, floatDownInfo, goalFloatDown)
    floatDownTween:Play()
    floatDownTween.Completed:Wait()

    enableAnimations()
    camera.CameraType = Enum.CameraType.Custom
end

-- Ball control and GUI
local function initializeScript()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local Folder = Instance.new("Folder", Workspace)
    local Part = Instance.new("Part", Folder)
    local Attachment1 = Instance.new("Attachment", Part)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1

    if not getgenv().Network then
        getgenv().Network = {
            BaseParts = {},
            Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
        }

        Network.RetainPart = function(Part)
            if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
                table.insert(Network.BaseParts, Part)
                Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                Part.CanCollide = false
            end
        end

        local function EnablePartControl()
            LocalPlayer.ReplicationFocus = Workspace
            RunService.Heartbeat:Connect(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                for _, Part in pairs(Network.BaseParts) do
                    if Part:IsDescendantOf(Workspace) then
                        Part.Velocity = Network.Velocity
                    end
                end
            end)
        end

        EnablePartControl()
    end

    local function ForcePart(v)
        if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
            for _, x in next, v:GetChildren() do
                if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                    x:Destroy()
                end
            end
            if v:FindFirstChild("Attachment") then
                v:FindFirstChild("Attachment"):Destroy()
            end
            if v:FindFirstChild("AlignPosition") then
                v:FindFirstChild("AlignPosition"):Destroy()
            end
            if v:FindFirstChild("Torque") then
                v:FindFirstChild("Torque"):Destroy()
            end
            v.CanCollide = false
            local Torque = Instance.new("Torque", v)
            Torque.Torque = Vector3.new(100000, 100000, 100000)
            local AlignPosition = Instance.new("AlignPosition", v)
            local Attachment2 = Instance.new("Attachment", v)
            Torque.Attachment0 = Attachment2
            AlignPosition.MaxForce = 9999999999999999
            AlignPosition.MaxVelocity = math.huge
            AlignPosition.Responsiveness = 200
            AlignPosition.Attachment0 = Attachment2
            AlignPosition.Attachment1 = Attachment1
        end
    end

    local ballActive = true

    local function toggleBall()
        ballActive = not ballActive
        if ballActive then
            for _, v in next, Workspace:GetDescendants() do
                ForcePart(v)
            end

            Workspace.DescendantAdded:Connect(function(v)
                if ballActive then
                    ForcePart(v)
                end
            end)

            spawn(function()
                while ballActive and RunService.RenderStepped:Wait() do
                    Attachment1.WorldCFrame = humanoidRootPart.CFrame
                end
            end)
        else
            for _, part in ipairs(Network.BaseParts) do
                part.Anchored = true
            end
        end
    end

    local function makeButtonDraggable(button)
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = button.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        button.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    local function createControlButton()
        local screenGui = Instance.new("ScreenGui")
        local button = Instance.new("TextButton")
        local frame = Instance.new("Frame")
        local uicorner = Instance.new("UICorner")

        local toggleGuiButton = Instance.new("TextButton")

        screenGui.Name = "BallControlGUI"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        frame.Name = "Frame"
        frame.Parent = screenGui
        frame.Position = UDim2.new(0.5, -100, 0, 90)
        frame.Size = UDim2.new(0, 220, 0, 80)
        frame.BackgroundTransparency = 1

        button.Name = "ToggleBallButton"
        button.Size = UDim2.new(0, 200, 0, 50)
        button.Position = UDim2.new(0, 10, 0, 15)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(240, 240, 240)
        button.Font = Enum.Font.Gotham
        button.TextSize = 18
        button.Text = "Bring Ball"
        button.Parent = frame

        uicorner.CornerRadius = UDim.new(0, 12)
        uicorner.Parent = button

        button.MouseButton1Click:Connect(function()
            if not ballActive then
                toggleBall()
                teleportAndReturn()
                button.Text = "Freeze Ball"
            else
                toggleBall()
                button.Text = "Bring Ball"
            end
        end)

        toggleGuiButton.Name = "ToggleGuiButton"
        toggleGuiButton.Size = UDim2.new(0, 50, 0, 50)
        toggleGuiButton.Position = UDim2.new(1, -60, 0.5, -25)
        toggleGuiButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        toggleGuiButton.TextColor3 = Color3.fromRGB(240, 240, 240)
        toggleGuiButton.Font = Enum.Font.Gotham
        toggleGuiButton.TextSize = 14
        toggleGuiButton.Text = "Show"
        toggleGuiButton.Parent = screenGui

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 12)
        buttonCorner.Parent = toggleGuiButton

        makeButtonDraggable(toggleGuiButton)
        makeButtonDraggable(button)

        toggleGuiButton.MouseButton1Click:Connect(function()
            frame.Visible = not frame.Visible
            toggleGuiButton.Text = frame.Visible and "Hide" or "Show"
        end)

        frame.Visible = false
    end

    createControlButton()
    toggleBall()

    LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
        ballActive = false
        sethiddenproperty(LocalPlayer, "SimulationRadius", 100)
        Folder:Destroy()
        LocalPlayer.PlayerGui:FindFirstChild("BallControlGUI"):Destroy()
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        initializeScript()
    end)
end

initializeScript()
