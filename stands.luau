local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local function GetRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
    return rootPart
end

local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(partialName) or 
           (player.DisplayName and player.DisplayName:lower():find(partialName)) then
            return player
        end
    end
    return nil
end
local function PlayAnim(id,time,speed)
	pcall(function()
		plr.Character.Animate.Disabled = false
		local hum = plr.Character.Humanoid
		local animtrack = hum:GetPlayingAnimationTracks()
		for i,track in pairs(animtrack) do
			track:Stop()
		end
		plr.Character.Animate.Disabled = true
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..id
		local loadanim = hum:LoadAnimation(Anim)
		loadanim:Play()
		loadanim.TimePosition = time
		loadanim:AdjustSpeed(speed)
		loadanim.Stopped:Connect(function()
			plr.Character.Animate.Disabled = false
			for i, track in pairs (animtrack) do
        		track:Stop()
    		end
		end)
	end)
end

local isStanding = false
local standTarget = nil

local function lotustartStand(target)
    if not target or not target.Character then return end
    isStanding = true
    standTarget = target
    PlayAnim(12507085924, 4, 0)
    
    spawn(function()
        while isStanding do
            pcall(function()
                if not GetRoot(plr.Character) then return end
                if not GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
                    local TempV = Velocity_Asset:Clone()
                    TempV.Parent = GetRoot(plr.Character)
                end
                
                if not target.Character then
                    stopStand()
                    return
                end
                
               local root = GetRoot(target.Character)
                if not root then return end
                
            end)
            task.wait()
        end
    end)
end
local function startStand(target)
    if not target or not target.Character then return end
    isStanding = true
    standTarget = target
    PlayAnim(13823324057, 4, 0)
    
    spawn(function()
        while isStanding do
            pcall(function()
                if not GetRoot(plr.Character) then return end
                if not GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
                    local TempV = Velocity_Asset:Clone()
                    TempV.Parent = GetRoot(plr.Character)
                end
                
                if not target.Character then
                    stopStand()
                    return
                end
                
               local root = GetRoot(target.Character)
                if not root then return end
                
            end)
            task.wait()
        end
    end)
end
local function StopAnim()
	plr.Character.Animate.Disabled = false
    local animtrack = plr.Character.Humanoid:GetPlayingAnimationTracks()
    for i, track in pairs (animtrack) do
        track:Stop()
    end
end

local function stopStand()
    isStanding = false
    standTarget = nil
    StopAnim()
    if plr.Character and GetRoot(plr.Character):FindFirstChild("BreakVelocity") then
        GetRoot(plr.Character).BreakVelocity:Destroy()
    end
end

-- Command handler
local prefix = "!"
plr.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local cmd = args[1]:lower()
    
    if cmd == prefix.."stand" then
        local targetName = args[2]
        if targetName then
            local target = findPlayer(targetName)
            if target then
            STANDRUNNING = true
                startStand(target)
                local root = GetRoot(target.Character)
                            while STANDRUNNING do
wait(0.06)
workspace.Gravity=0
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(-2, 3, 3)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)

            end
            end
        end
            elseif cmd == prefix.."stand2" then
        local targetName = args[2]
        if targetName then
            local target = findPlayer(targetName)
            if target then
            STANDRUNNING = true
                lotustartStand(target)
                local root = GetRoot(target.Character)
                            while STANDRUNNING do
wait(0.06)
workspace.Gravity=0
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(-2, 3, 3)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)

            end
            end
        end
    elseif cmd == prefix.."unstand" then
           STANDRUNNING = false
         wait(0.25)
        stopStand()
        workspace.Gravity=192
    end
end)
