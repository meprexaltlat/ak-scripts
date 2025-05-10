local function queueTeleport()
    local queueTeleportFunc = syn and syn.queue_on_teleport or 
                               queue_on_teleport or 
                               (fluxus and fluxus.queue_on_teleport)
    
    if queueTeleportFunc then
        queueTeleportFunc([[
            loadstring(game:HttpGet('https://raw.githubusercontent.com/bfjdsaisfhdsfdsfbkjfdsbdfsbkjvdsbibvd/deinemudda/refs/heads/main/adbot'))()
        ]])
        print("Script successfully queued for teleport")
    else
        warn("No compatible queue_on_teleport function found")
    end
end

queueTeleport()

-- Executor compatibility checks
local setclipboard = setclipboard or toclipboard or set_clipboard
local writefile = writefile or function() warn("writefile not supported") end
local readfile = readfile or function() warn("readfile not supported") end


local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function chatMessage(str)
    str = tostring(str)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local generalChannel = TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
        if generalChannel then
            generalChannel:SendAsync(str)
        else
            warn("RBXGeneral channel not found!")
        end
    else
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest")
        if chatEvent then
            chatEvent:FireServer(str, "All")
        else
            warn("DefaultChatSystemChatEvents not found!")
        end
    end
end

local blob = "\u{000D}"
local clearMessage = ""..string.rep(blob, 197)..""


spawn(function()
    local n = 0
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/More-Scripts/refs/heads/main/Anthony's%20ACL"))()
    local targetedPlayers = {} -- Keeps track of targeted players within a cycle
    local startTime = tick() -- Record the start time

    while wait(8) do
        n = n + 2
        local StarterGui = game:GetService("StarterGui")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")

        StarterGui:SetCore("SendNotification", {
            Title = "AK ADMIN",
            Text = "You need to change your Roblox Language to Қазақ тілі so it won't get tagged",
            Duration = 5
        })

        wait(1)
        local newMessage = blob .. "\r" ..
        "🔥 AK ADMIN 🔥" .. blob .. "\r" ..
        " ---------------------  " .. blob .. "\r" ..
        "Pụŕçħase Lifetime!" .. blob .. "\r" ..
        "or Whitelist urself for FREE!  " .. blob .. "\r" ..
        " ---------------------  " .. blob .. "\r" ..
        "һttpร://diรсord.gg/VekmXžSj7S " 

        local oldMessage = "🔥 AK ADMIN 🔥  Pụṛc̣ḥạṣẹ Ḷịf̣ẹṭiṃẹ! Or use points for free! 👉 ḍịṣcọrḍ.gg/gJgRuwC3MP 👈"

        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            chatMessage(clearMessage)
        end

        wait(1)

        local function sendMessage()
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                chatMessage(newMessage)
            else
                chatMessage(oldMessage)
            end
        end

        local retries = 3
        while retries > 0 do
            local success, err = pcall(sendMessage)
            if success then break end
            retries = retries - 1
            wait(1)
        end

        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        local targetHead = nil
        local targetPlayer = nil

        local FOLLOW_DISTANCE = -0.7
        local HEIGHT_OFFSET = 0.8
        local MOVEMENT_SPEED = 0.25
        local THRUST_SPEED = 0.2
        local THRUST_DISTANCE = 1.5
        local FACEBANG_DURATION = 5
        local PAUSE_DURATION = 5 -- Changed the pause duration to 5
        getgenv().facefuckactive = true

        local function disableAllAnimations(character)
            if not character then return end
            
            local animate = character:FindFirstChild("Animate")
            if animate then
                animate.Disabled = true
                
                for _, child in ipairs(animate:GetChildren()) do
                    if child:IsA("StringValue") then
                        child.Value = ""
                    end
                end
            end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                    track:Destroy()
                end
                
                humanoid.PlatformStand = true
                humanoid.AutoRotate = false
                
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
            
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("LocalScript") and child.Name:match("Controller") then
                    child.Disabled = true
                end
            end
            
            workspace.Gravity = 0
        end

        local function faceBang(head)
            local character = LocalPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local startTime = tick()
            local duration = FACEBANG_DURATION
            
             if not head or not head:IsDescendantOf(workspace) then return end

            disableAllAnimations(character)
            
            while tick() - startTime < duration do
                if not head or not head:IsDescendantOf(workspace) then break end
                local targetCFrame = head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE) * CFrame.Angles(0, math.rad(180), 0)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(targetCFrame, MOVEMENT_SPEED)
                
                local positions = {
                    head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE) * CFrame.Angles(0, math.rad(180), 0),
                    head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE - THRUST_DISTANCE) * CFrame.Angles(0, math.rad(180), 0),
                }
                
                for _, targetPosition in ipairs(positions) do
                    local positionStartTime = tick()
                    while (tick() - positionStartTime) < 0.1 do
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(targetPosition, THRUST_SPEED)
                        RunService.RenderStepped:Wait()
                    end
                end
                
                RunService.RenderStepped:Wait()
            end
        end

        local function stopMovement()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoidRootPart then
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame
                    humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                end
            end
        end

        local function resetCharacter()
            local character = LocalPlayer.Character
            if character then
                workspace.Gravity = 196.2 -- Set gravity to normal
                
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                     humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    humanoid:ChangeState(Enum.HumanoidStateType.Standing)
                end
            end
        end
         local function setZeroGravity()
             workspace.Gravity = 0
        end
        spawn(function()
            while true do
                local players = Players:GetPlayers()
                for _, otherPlayer in ipairs(players) do
                    if otherPlayer ~= LocalPlayer and otherPlayer.Character and not targetedPlayers[otherPlayer.Name] then
                        targetedPlayers[otherPlayer.Name] = true
                        if otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
                            pcall(function()
                                faceBang(otherPlayer.Character.Head)
                            end)
                            stopMovement()
                            resetCharacter()
                            wait(PAUSE_DURATION)
                            setZeroGravity()
                        end
                    end
                end
                targetedPlayers = {} -- Clear after cycle
                wait()
            end
        end)
        
         if tick() - startTime >= 180 then  -- 3 minutes = 180 seconds
            if n >= 25 then
            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local File = pcall(function()
                AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
            end)
            if not File then
                table.insert(AllIDs, actualHour)
                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
            end

            function TPReturner()
                local Site;
                if foundAnything == "" then
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Desc&limit=100'))
                else
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Desc&limit=100&cursor=' .. foundAnything))
                end
                local ID = ""
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                local num = 0;
                for i,v in pairs(Site.data) do
                    local Possible = true
                    ID = tostring(v.id)
                    if tonumber(v.playing) > 0 and tonumber(v.playing) < tonumber(v.maxPlayers) then
                        for _,Existing in pairs(AllIDs) do
                            if num ~= 0 then
                                if ID == tostring(Existing) then
                                    Possible = false
                                end
                            else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                    local delFile = pcall(function()
                                        delfile("NotSameServers.json")
                                        AllIDs = {}
                                        table.insert(AllIDs, actualHour)
                                    end)
                                end
                            end
                            num = num + 1
                        end
                        if Possible == true then
                            table.insert(AllIDs, ID)
                            wait()
                            pcall(function()
                                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                                wait()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                            end)
                            wait(4)
                        end
                    end
                end
            end

            function Teleport()
                while wait() do
                    pcall(function()
                        TPReturner()
                        if foundAnything ~= "" then
                            TPReturner()
                        end
                    end)
                end
            end

            Teleport()
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            
            humanoid.PlatformStand = true
             humanoid.AutoRotate = false
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end
end)

-- Improved Queue on Teleport
