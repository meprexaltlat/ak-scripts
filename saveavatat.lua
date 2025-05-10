-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local AvatarEditor = game:GetService("AvatarEditorService")

local player = Players.LocalPlayer
local savedOutfits = {}
local fileName = "OutfitSaver_" .. player.UserId .. ".json"
local selectedOutfitIndex, selectedOutfitButton = nil, nil
local guiOpen = true
local guiMinimized = false
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OutfitSaverGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = ScreenGui

local cornerRadius = Instance.new("UICorner")
cornerRadius.CornerRadius = UDim.new(0, 10)
cornerRadius.Parent = mainFrame

local shadowEffect = Instance.new("ImageLabel")
shadowEffect.Name = "Shadow"
shadowEffect.BackgroundTransparency = 1
shadowEffect.Position = UDim2.new(0, -15, 0, -15)
shadowEffect.Size = UDim2.new(1, 30, 1, 30)
shadowEffect.Image = "rbxassetid://6014261993"
shadowEffect.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadowEffect.ImageTransparency = 0.5
shadowEffect.ScaleType = Enum.ScaleType.Slice
shadowEffect.SliceCenter = Rect.new(49, 49, 450, 450)
shadowEffect.ZIndex = -1
shadowEffect.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Outfit Saver"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -75, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 120, 190)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local saveSection = Instance.new("Frame")
saveSection.Name = "SaveSection"
saveSection.Size = UDim2.new(1, -40, 0, 60)
saveSection.Position = UDim2.new(0, 20, 0, 10)
saveSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
saveSection.BorderSizePixel = 0
saveSection.Parent = contentFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveSection

local outfitNameInput = Instance.new("TextBox")
outfitNameInput.Name = "OutfitNameInput"
outfitNameInput.Size = UDim2.new(1, -110, 0, 35)
outfitNameInput.Position = UDim2.new(0, 10, 0, 12)
outfitNameInput.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
outfitNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
outfitNameInput.PlaceholderText = "Outfit Name"
outfitNameInput.Text = ""
outfitNameInput.Font = Enum.Font.Gotham
outfitNameInput.TextSize = 14
outfitNameInput.ClipsDescendants = true
outfitNameInput.Parent = saveSection

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = outfitNameInput

local saveButton = Instance.new("TextButton")
saveButton.Name = "SaveButton"
saveButton.Size = UDim2.new(0, 90, 0, 35)
saveButton.Position = UDim2.new(1, -100, 0, 12)
saveButton.BackgroundColor3 = Color3.fromRGB(20, 160, 90)
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.Text = "Save"
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 14
saveButton.Parent = saveSection

local saveButtonCorner = Instance.new("UICorner")
saveButtonCorner.CornerRadius = UDim.new(0, 6)
saveButtonCorner.Parent = saveButton

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "OutfitsContainer"
scrollFrame.Size = UDim2.new(1, -40, 1, -120)
scrollFrame.Position = UDim2.new(0, 20, 0, 80)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
scrollFrame.Parent = contentFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 1, -40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Text = ""
statusLabel.Parent = contentFrame

local function updateStatus(message, color)
    statusLabel.Text = message
    statusLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    
    task.delay(5, function()
        if statusLabel.Text == message then
            statusLabel.Text = ""
        end
    end)
end

local function serializeHumanoidDescription(humDesc)
    local propNames = {
        "BackAccessory", "BodyTypeScale", "ClimbAnimation", "DepthScale", 
        "Face", "FaceAccessory", "FallAnimation", "FrontAccessory", 
        "GraphicTShirt", "HairAccessory", "HatAccessory", "HeadScale", 
        "HeightScale", "IdleAnimation", "JumpAnimation", "LeftArm", 
        "LeftLeg", "NeckAccessory", "Pants", "ProportionScale", 
        "RightArm", "RightLeg", "RunAnimation", "Shirt", "ShouldersAccessory", 
        "SwimAnimation", "Torso", "WaistAccessory", "WalkAnimation", 
        "WidthScale", "Head", "HeadColor", "LeftArmColor", "LeftLegColor", 
        "RightArmColor", "RightLegColor", "TorsoColor"
    }
    
    local serialized = {}
    for _, propName in ipairs(propNames) do
        pcall(function()
            local value = humDesc[propName]
            if typeof(value) == "Color3" then
                serialized[propName] = {
                    R = value.R,
                    G = value.G,
                    B = value.B
                }
            else
                serialized[propName] = value
            end
        end)
    end
    
    return serialized
end

local function deserializeHumanoidDescription(data)
    local newDesc = Instance.new("HumanoidDescription")
    
    for propName, value in pairs(data) do
        pcall(function()
            if type(value) == "table" and value.R ~= nil then
                newDesc[propName] = Color3.new(value.R, value.G, value.B)
            else
                newDesc[propName] = value
            end
        end)
    end
    
    return newDesc
end

local function captureCharacterAppearance(character)
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    
    local humDesc = humanoid:GetAppliedDescription()
    if not humDesc then return nil end

    local rigType = humanoid.RigType.Name
    
    local descData = serializeHumanoidDescription(humDesc)
    
    return {
        serializedDescription = descData,
        rigType = rigType
    }
end

local function applyAppearanceToCharacter(character, appearance)
    if not appearance or not appearance.serializedDescription then return false end

    local success, errorMsg = pcall(function()
        local newDesc = deserializeHumanoidDescription(appearance.serializedDescription)
        
        local rigType = appearance.rigType or "R15"
        AvatarEditor:PromptSaveAvatar(newDesc, Enum.HumanoidRigType[rigType])
        if AvatarEditor.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
            local player = Players.LocalPlayer
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
                local pos
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then pos = hrp.CFrame end
                local newChar = player.CharacterAdded:Wait()
                local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
                if newHRP and pos then newHRP.CFrame = pos end
            end
        end
    end)

    return success, errorMsg
end

local function saveOutfitsToFile()
    local success, errorMsg = pcall(function()
        local outfitData = {}
        for i, outfit in ipairs(savedOutfits) do
            table.insert(outfitData, {
                name = outfit.name,
                appearance = outfit.appearance
            })
        end
        
        local jsonData = HttpService:JSONEncode(outfitData)
        writefile(fileName, jsonData)
    end)
    
    return success, errorMsg
end

local function loadOutfitsFromFile()
    local success, result = pcall(function()
        if isfile(fileName) then
            local jsonData = readfile(fileName)
            local outfitData = HttpService:JSONDecode(jsonData)
            savedOutfits = {}
            
            for _, data in ipairs(outfitData) do
                table.insert(savedOutfits, {
                    name = data.name,
                    appearance = data.appearance
                })
            end
            return true
        end
        return false
    end)
    
    if not success or not result then
        savedOutfits = {}
        return false
    end
    return true
end

local function refreshOutfitList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for i, outfit in ipairs(savedOutfits) do
        local outfitFrame = Instance.new("Frame")
        outfitFrame.Name = "OutfitFrame_" .. i
        outfitFrame.Size = UDim2.new(1, 0, 0, 45)
        outfitFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        outfitFrame.LayoutOrder = i
        outfitFrame.Parent = scrollFrame
        
        local outfitCorner = Instance.new("UICorner")
        outfitCorner.CornerRadius = UDim.new(0, 6)
        outfitCorner.Parent = outfitFrame
        
        local button = Instance.new("TextButton")
        button.Name = "OutfitButton"
        button.Size = UDim2.new(1, -80, 1, 0)
        button.Position = UDim2.new(0, 0, 0, 0)
        button.BackgroundTransparency = 1
        button.Text = outfit.name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 16
        button.Parent = outfitFrame
        
        local applyButton = Instance.new("TextButton")
        applyButton.Name = "ApplyButton"
        applyButton.Size = UDim2.new(0, 35, 0, 35)
        applyButton.Position = UDim2.new(1, -75, 0.5, -17)
        applyButton.BackgroundColor3 = Color3.fromRGB(30, 120, 200)
        applyButton.Text = "A"
        applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        applyButton.Font = Enum.Font.GothamBold
        applyButton.TextSize = 16
        applyButton.Parent = outfitFrame
        
        local applyCorner = Instance.new("UICorner")
        applyCorner.CornerRadius = UDim.new(0, 6)
        applyCorner.Parent = applyButton
        
        local deleteButton = Instance.new("TextButton")
        deleteButton.Name = "DeleteButton"
        deleteButton.Size = UDim2.new(0, 35, 0, 35)
        deleteButton.Position = UDim2.new(1, -35, 0.5, -17)
        deleteButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        deleteButton.Text = "X"
        deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteButton.Font = Enum.Font.GothamBold
        deleteButton.TextSize = 16
        deleteButton.Parent = outfitFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 6)
        deleteCorner.Parent = deleteButton
        
        button.MouseButton1Click:Connect(function()
            selectedOutfitIndex = i
            
            for _, child in ipairs(scrollFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                end
            end
            
            outfitFrame.BackgroundColor3 = Color3.fromRGB(30, 120, 200)
            selectedOutfitButton = outfitFrame
            
            updateStatus("Selected outfit: " .. outfit.name, Color3.fromRGB(50, 200, 200))
        end)
        
        applyButton.MouseButton1Click:Connect(function()
            if player.Character then
                local success, errorMsg = applyAppearanceToCharacter(player.Character, outfit.appearance)
                
                if success then
                    updateStatus("Outfit applied!", Color3.fromRGB(50, 200, 50))
                else
                    updateStatus("Error applying outfit", Color3.fromRGB(255, 50, 50))
                    print("Error: ", errorMsg)
                end
            else
                updateStatus("Character not found!", Color3.fromRGB(255, 50, 50))
            end
        end)
        
        deleteButton.MouseButton1Click:Connect(function()
            table.remove(savedOutfits, i)
            if selectedOutfitIndex == i then
                selectedOutfitIndex = nil
                selectedOutfitButton = nil
            elseif selectedOutfitIndex and selectedOutfitIndex > i then
                selectedOutfitIndex = selectedOutfitIndex - 1
            end
            
            saveOutfitsToFile()
            refreshOutfitList()
            updateStatus("Outfit deleted!", Color3.fromRGB(200, 100, 50))
        end)
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedOutfits * 53)
end

local function makeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        gui.Position = newPosition
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
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

makeDraggable(mainFrame)

local function toggleMinimize()
    guiMinimized = not guiMinimized
    
    if guiMinimized then
        contentFrame.Visible = false
        mainFrame:TweenSize(UDim2.new(0, 280, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
        minimizeButton.Text = "+"
    else
        mainFrame:TweenSize(UDim2.new(0, 280, 0, 380), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
        task.wait(0.3)
        contentFrame.Visible = true
        minimizeButton.Text = "-"
    end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)

saveButton.MouseButton1Click:Connect(function()
    local name = outfitNameInput.Text
    if name == "" then
        updateStatus("Please enter a name!", Color3.fromRGB(255, 200, 50))
        return
    end
    
    if player.Character then
        local appearance = captureCharacterAppearance(player.Character)
        
        if appearance then
            table.insert(savedOutfits, {
                name = name,
                appearance = appearance
            })
            
            outfitNameInput.Text = ""
            local success, errorMsg = saveOutfitsToFile()
            if success then
                refreshOutfitList()
                updateStatus("Outfit saved!", Color3.fromRGB(50, 200, 50))
                
                pcall(function()
                    StarterGui:SetCore("SendNotification", {
                        Title = "Outfit Saver",
                        Text = "Outfit '" .. name .. "' saved!",
                        Duration = 3
                    })
                end)
            else
                updateStatus("Error saving file: " .. (errorMsg or "Unknown error"), Color3.fromRGB(255, 50, 50))
                print("Save error: ", errorMsg)
            end
        else
            updateStatus("Error saving outfit!", Color3.fromRGB(255, 50, 50))
        end
    else
        updateStatus("Character not found!", Color3.fromRGB(255, 50, 50))
    end
end)

local function applyButtonEffects(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

applyButtonEffects(saveButton, Color3.fromRGB(20, 160, 90), Color3.fromRGB(30, 180, 100))
applyButtonEffects(closeButton, Color3.fromRGB(200, 60, 60), Color3.fromRGB(220, 70, 70))
applyButtonEffects(minimizeButton, Color3.fromRGB(60, 120, 190), Color3.fromRGB(70, 130, 210))

closeButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and ((input.KeyCode == Enum.KeyCode.O and UIS:IsKeyDown(Enum.KeyCode.LeftControl)) or 
       (isMobile and input.KeyCode == Enum.KeyCode.ButtonR1)) then
        guiOpen = not guiOpen
        mainFrame.Visible = guiOpen
    end
end)

local fileSystemAvailable = pcall(function() 
    return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function" 
end)

pcall(function()
    if fileSystemAvailable then
        if loadOutfitsFromFile() then
            updateStatus("Outfits loaded from file!", Color3.fromRGB(50, 200, 50))
        else
            updateStatus("Starting with empty outfit collection", Color3.fromRGB(200, 200, 50))
        end
    else
        updateStatus("File system not available!", Color3.fromRGB(255, 100, 50))
        print("File system functions are not available. This script requires an executor that supports file operations.")
    end
    
    refreshOutfitList()
    
    task.wait(1)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Outfit Saver",
            Text = #savedOutfits .. " outfits loaded!",
            Duration = 3
        })
    end)
end)

local function checkGameCompatibility()
    local customAvatarSystem = false
    
    if RS:FindFirstChild("LoadClothing") or 
       RS:FindFirstChild("UpdateAvatar") or
       RS:FindFirstChild("ChangeOutfit") then
        customAvatarSystem = true
    end
    
    return customAvatarSystem
end

if checkGameCompatibility() then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Note",
            Text = "This game has a custom avatar system. Functionality may be limited.",
            Duration = 5
        })
    end)
end
