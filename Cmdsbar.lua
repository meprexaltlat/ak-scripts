local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local THEME = {
    COLORS = {
        PRIMARY = Color3.fromRGB(15, 20, 35),
        SECONDARY = Color3.fromRGB(25, 35, 55),
        ACCENT = Color3.fromRGB(65, 140, 255),
        HOVER = Color3.fromRGB(85, 160, 255),
        TEXT = Color3.fromRGB(240, 245, 255),
        BORDER = Color3.fromRGB(85, 95, 120),
        GLOW = Color3.fromRGB(45, 120, 255),
        PLACEHOLDER = Color3.fromRGB(160, 170, 190),
        PREDICTION = Color3.fromRGB(128, 128, 128)
    },
    ANIMATION = {
        DURATION = {
            FADE = 0.15,
            MOVE_OPEN = 0.35,
            MOVE_CLOSE = 0.7,
            EXPAND = 0.25,
            SHRINK = 0.5
        },
        EASING = {
            MOVE_OPEN = Enum.EasingStyle.Back,
            MOVE_CLOSE = Enum.EasingStyle.Quint,
            EXPAND = Enum.EasingStyle.Quint,
            SHRINK = Enum.EasingStyle.Quint
        }
    },
    SIZES = {
        BUTTON = UDim2.new(0, 45, 0, 45),
        COMMAND_BAR = UDim2.new(0, 550, 0, 55)
    }
}

local function createCommandBar()
    local gui = Instance.new("ScreenGui")
    gui.Name = "PremiumCommandBar"
    gui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.BackgroundColor3 = THEME.COLORS.PRIMARY
    mainFrame.Size = THEME.SIZES.BUTTON
    mainFrame.Position = UDim2.new(1, -172, 0, -32)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Transparency = 0.2

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.COLORS.PRIMARY),
        ColorSequenceKeypoint.new(0.5, THEME.COLORS.SECONDARY),
        ColorSequenceKeypoint.new(1, THEME.COLORS.PRIMARY)
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame

    local glow = Instance.new("ImageLabel")
    glow.Image = "rbxassetid://7014506339"
    glow.ImageColor3 = THEME.COLORS.GLOW
    glow.ImageTransparency = 0.6
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(2, 0, 2, 0)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.ZIndex = -1
    glow.Parent = mainFrame

    local icon = Instance.new("ImageButton")
    icon.Image = "rbxassetid://99535144264404"
    icon.Size = UDim2.new(0.65, 0, 0.65, 0)
    icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Parent = mainFrame

    local commandContainer = Instance.new("Frame")
    commandContainer.Size = THEME.SIZES.BUTTON
    commandContainer.BackgroundColor3 = THEME.COLORS.PRIMARY
    commandContainer.BackgroundTransparency = 0.05
    commandContainer.Visible = false
    commandContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    commandContainer.Position = UDim2.new(0.5, 0, 0.65, 0)

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 18)
    containerCorner.Parent = commandContainer

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.COLORS.BORDER
    stroke.Thickness = 1.5
    stroke.Transparency = 0.7
    stroke.Parent = commandContainer

    gradient:Clone().Parent = commandContainer

    local predictionLabel = Instance.new("TextLabel")
    predictionLabel.Size = UDim2.new(1, -40, 1, 0)
    predictionLabel.Position = UDim2.new(0, 20, 0, 0)
    predictionLabel.BackgroundTransparency = 1
    predictionLabel.TextColor3 = THEME.COLORS.PREDICTION
    predictionLabel.TextSize = 20
    predictionLabel.Font = Enum.Font.GothamBold
    predictionLabel.TextXAlignment = Enum.TextXAlignment.Left
    predictionLabel.Text = ""
    predictionLabel.ZIndex = 1
    predictionLabel.Parent = commandContainer

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -40, 1, 0)
    textBox.Position = UDim2.new(0, 20, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = THEME.COLORS.TEXT
    textBox.PlaceholderColor3 = THEME.COLORS.PLACEHOLDER
    textBox.PlaceholderText = "Enter command..."
    textBox.TextSize = 20
    textBox.Font = Enum.Font.GothamBold
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Visible = false
    textBox.ZIndex = 2
    textBox.Parent = commandContainer

    commandContainer.Parent = gui
    mainFrame.Parent = gui

    return {
        gui = gui,
        mainFrame = mainFrame,
        icon = icon,
        commandContainer = commandContainer,
        textBox = textBox,
        predictionLabel = predictionLabel,
        glow = glow
    }
end

local function initializePremiumCommandBar()
    local ui = createCommandBar()
    local isOpen = false
    local isAnimating = false
    local originalPosition = ui.mainFrame.Position

    _G.cmds = {}
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OBaqt1nbJz1NipM92jv/6qQE2IF1FGovyLEEepBn/refs/heads/main/allcmdss.luau"))()
    end)

    local function updatePrediction(input)
        local prediction = ""
        if input and input ~= "" then
            input = input:lower()
            if not input:match("^!") then
                input = "!" .. input
            end
            
            for cmd, _ in pairs(_G.cmds) do
                if cmd:lower():sub(1, #input) == input then
                    prediction = cmd:sub(#input + 1)
                    break
                end
            end
        end
        ui.predictionLabel.Text = ui.textBox.Text .. prediction
    end

    local function animateCommandBarOpen()
        if isAnimating then return end
        isAnimating = true

        local moveInfo = TweenInfo.new(
            THEME.ANIMATION.DURATION.MOVE_OPEN,
            THEME.ANIMATION.EASING.MOVE_OPEN,
            Enum.EasingDirection.Out,
            0,
            false,
            0
        )

        local expandInfo = TweenInfo.new(
            THEME.ANIMATION.DURATION.EXPAND,
            THEME.ANIMATION.EASING.EXPAND,
            Enum.EasingDirection.Out
        )

        local scaleOut = TweenService:Create(ui.mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 53, 0, 53)
        })

        local scaleIn = TweenService:Create(ui.mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = THEME.SIZES.BUTTON
        })

        local glowExpand = TweenService:Create(ui.glow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(2.2, 0, 2.2, 0),
            ImageTransparency = 0.5
        })

        scaleOut:Play()
        glowExpand:Play()

        scaleOut.Completed:Connect(function()
            scaleIn:Play()

            local moveToCenter = TweenService:Create(ui.mainFrame, moveInfo, {
                Position = UDim2.new(0.5, 0, 0.65, 0)
            })

            local fadeIcon = TweenService:Create(ui.icon, TweenInfo.new(THEME.ANIMATION.DURATION.FADE), {
                ImageTransparency = 1
            })

            moveToCenter:Play()
            fadeIcon:Play()

            moveToCenter.Completed:Connect(function()
                ui.commandContainer.Size = THEME.SIZES.BUTTON
                ui.commandContainer.Position = UDim2.new(0.5, 0, 0.65, 0)
                ui.commandContainer.Visible = true

                local expandContainer = TweenService:Create(ui.commandContainer, expandInfo, {
                    Size = THEME.SIZES.COMMAND_BAR
                })

                expandContainer:Play()

                expandContainer.Completed:Connect(function()
                    ui.textBox.Visible = true
                    ui.textBox:CaptureFocus()
                    isAnimating = false
                    isOpen = true
                end)
            end)
        end)
    end

    local function animateCommandBarClose()
        if isAnimating then return end
        isAnimating = true

        ui.textBox.Visible = false
        ui.predictionLabel.Text = ""

        local shrinkInfo = TweenInfo.new(
            THEME.ANIMATION.DURATION.SHRINK,
            THEME.ANIMATION.EASING.SHRINK,
            Enum.EasingDirection.InOut
        )

        local moveBackInfo = TweenInfo.new(
            THEME.ANIMATION.DURATION.MOVE_CLOSE,
            THEME.ANIMATION.EASING.MOVE_CLOSE,
            Enum.EasingDirection.InOut
        )

        local shrinkContainer = TweenService:Create(ui.commandContainer, shrinkInfo, {
            Size = THEME.SIZES.BUTTON
        })

        local glowShrink = TweenService:Create(ui.glow, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = UDim2.new(2, 0, 2, 0),
            ImageTransparency = 0.6
        })

        shrinkContainer:Play()
        glowShrink:Play()

        shrinkContainer.Completed:Connect(function()
            ui.commandContainer.Visible = false

            local moveBack = TweenService:Create(ui.mainFrame, moveBackInfo, {
                Position = originalPosition
            })

            local fadeInIcon = TweenService:Create(ui.icon, TweenInfo.new(THEME.ANIMATION.DURATION.FADE), {
                ImageTransparency = 0
            })

            moveBack:Play()
            fadeInIcon:Play()

            moveBack.Completed:Connect(function()
                isAnimating = false
                isOpen = false
            end)
        end)
    end

    local dragging = false
    local dragStartPos = Vector2.new()
    local frameStartPos = UDim2.new(0,0,0,0)
    local firstDrag = true

    local function startDrag(inputObject)
        if isAnimating then return end
        dragging = true
        if firstDrag then
            dragStartPos = Vector2.new(inputObject.Position.X, inputObject.Position.Y)
            frameStartPos = ui.mainFrame.Position
            firstDrag = false
        else
           dragStartPos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
           frameStartPos = ui.mainFrame.Position
        end
    end

    local function endDrag()
        dragging = false
        originalPosition = ui.mainFrame.Position
    end

     -- Modified toggleCommandBar function to accept a boolean parameter.
    local function toggleCommandBar(isFromTouch)
        if not isOpen and not isAnimating then
            animateCommandBarOpen()
        end
    end

    ui.textBox:GetPropertyChangedSignal("Text"):Connect(function()
        updatePrediction(ui.textBox.Text)
    end)

    UserInputService.InputBegan:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            if ui.icon.AbsolutePosition.X <= pos.X and pos.X <= ui.icon.AbsolutePosition.X + ui.icon.AbsoluteSize.X and 
               ui.icon.AbsolutePosition.Y <= pos.Y and pos.Y <= ui.icon.AbsolutePosition.Y + ui.icon.AbsoluteSize.Y then
               startDrag(input)
               -- We dont handle the input, so the icon MouseButton1Up still has a chance to fire
              -- input.Handled = true
            end
        end

        if input.KeyCode == Enum.KeyCode.F6 then
            if not isOpen and not isAnimating then
                animateCommandBarOpen()
            end
        elseif input.KeyCode == Enum.KeyCode.Escape and isOpen then
            animateCommandBarClose()
        elseif input.KeyCode == Enum.KeyCode.Tab and isOpen and ui.predictionLabel.Text ~= "" then
            ui.textBox.Text = ui.predictionLabel.Text
            ui.textBox:CaptureFocus()
            ui.textBox.CursorPosition = #ui.textBox.Text + 1
            updatePrediction(ui.textBox.Text)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            local delta = mousePos - dragStartPos
            ui.mainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            endDrag()
        end
    end)

    ui.icon.MouseButton1Up:Connect(function()
        if not dragging then
            toggleCommandBar() -- PC click
        end
    end)

    ui.icon.TouchTap:Connect(function()
         if not dragging then
            toggleCommandBar(true) -- Touch click
        end
    end)

    ui.textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local currentText = ui.textBox.Text
            if currentText ~= "" then
                -- Use the full predicted command if available
                local fullText = ui.predictionLabel.Text
                -- Format the command with ! prefix if not present
                local cmd = fullText:match("^!") and fullText or "!" .. fullText
                cmd = cmd:lower():match("^%s*(.-)%s*$")
                
                if _G.cmds[cmd] then
                    pcall(function()
                        loadstring(game:HttpGet(_G.cmds[cmd]))()
                    end)
                end
            end
            ui.textBox.Text = ""
            ui.predictionLabel.Text = ""
        end
        animateCommandBarClose()
    end)

    -- Set up initialization
    local function init()
        -- Parent the GUI to PlayerGui
        local player = Players.LocalPlayer
        if player then
            ui.gui.Parent = player:WaitForChild("PlayerGui")
        else
            Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            ui.gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end

    init()
end

-- Start the command bar
initializePremiumCommandBar()
