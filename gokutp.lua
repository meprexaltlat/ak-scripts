local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse  = player:GetMouse()
local camera = workspace.CurrentCamera

-- Tool erstellen
local tool = Instance.new("Tool")
tool.Name           = "Click Teleport"
tool.RequiresHandle = false
tool.Parent         = player.Backpack

-- Teleport‑Funktion mit Effekten, Ausrichtung und Kamera‑Restore
local function teleportWithEffects(targetCFrame)
    local character = player.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Kamera‑CFrame sichern, damit es nachher unverändert bleibt
    local oldCamCF = camera.CFrame

    -- Ursprung für Partikel
    local originPos = hrp.Position
    local partA = Instance.new("Part", workspace)
    partA.Anchored     = true
    partA.CanCollide   = false
    partA.Transparency = 1
    partA.Position     = originPos
    local emitterA = Instance.new("ParticleEmitter", partA)
    emitterA.Texture             = "http://www.roblox.com/asset/?id=89296104222585"
    emitterA.Size                = NumberSequence.new(4)
    emitterA.Lifetime            = NumberRange.new(0.15)
    emitterA.Rate                = 100
    emitterA.TimeScale           = 0.25
    emitterA.VelocityInheritance = 1
    emitterA.Drag                = 5

    -- Ziel‑Partikel
    local partB = partA:Clone()
    partB.Parent   = workspace
    partB.Position = targetCFrame.Position

    -- MeshParts ausblenden
    local fadeTime = 0.1
    local ti = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local meshParts = {}
    for _, p in ipairs(character:GetDescendants()) do
        if p:IsA("MeshPart") then
            table.insert(meshParts, p)
            TweenService:Create(p, ti, {Transparency = 1}):Play()
        end
    end
    task.wait(fadeTime)

    -- Teleport + Ausrichtung übernehmen
    hrp.CFrame = targetCFrame

    -- Kamera‑CFrame zurücksetzen (kein Einfluss auf die Kamera)
    camera.CFrame = oldCamCF

    -- Sound beim Ankommen
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://5066021887"
    sound.Volume  = 0.5
    sound.Parent  = character:FindFirstChild("Head") or hrp
    sound:Play()

    -- MeshParts wieder einblenden
    for _, p in ipairs(meshParts) do
        TweenService:Create(p, ti, {Transparency = 0}):Play()
    end

    -- Aufräumen
    task.delay(1, function()
        partA:Destroy()
        partB:Destroy()
    end)
end

-- Tool aktivieren
tool.Activated:Connect(function()
    -- Ziel-Position 2.5 Studs über Boden
    local targetPos = mouse.Hit.p + Vector3.new(0, 2.5, 0)
    -- Richtung berechnen: Maus-Plane als Blickrichtung
    local lookDir = (mouse.Hit.p - player.Character.HumanoidRootPart.Position)
    lookDir = Vector3.new(lookDir.X, 0, lookDir.Z).Unit
    local targetCFrame = CFrame.new(targetPos, targetPos + lookDir)

    teleportWithEffects(targetCFrame)
end)
