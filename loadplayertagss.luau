-- Make the usernames the same color as their nametag accent color -- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService") -- Added for text size calculation

-- Checks if a value exists in a table (case-insensitive)
local function containsIgnoreCase(tbl, name)
	if not name then return false end -- Added safety check
	name = name:lower()
	for _, v in ipairs(tbl) do
		if v:lower() == name then
			return true
		end
	end
	return false
end

-- Tag configuration.
local CONFIG = {
	TAG_SIZE = UDim2.new(0, 0, 0, 32),  -- height only, width will be dynamic
	TAG_OFFSET = Vector3.new(0, 2.0, 0),
	MAX_DISTANCE = 200000,
	DISTANCE_THRESHOLD = 50,      -- when player backs away 50 studs, tag minimizes
	HYSTERESIS = 5,               -- only switch state when crossing 45 studs on the way back (50-5)
	CORNER_RADIUS = UDim.new(0, 10),
	PARTICLE_COUNT = 100,         -- increased particle count
	PARTICLE_SPEED = 1,
	GLOW_INTENSITY = 0.3,
	TELEPORT_DISTANCE = 5,
	TELEPORT_HEIGHT = 0.5,
}

local RankData = {
	["AK OWNER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = true, UseImage = true, accent = Color3.fromRGB(120, 66, 245), emoji = "👑", image = "http://www.roblox.com/asset/?id=115097330925898" },
	["AK CO OWNER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = true, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(61, 126, 255), emoji = "⚡", image = "http://www.roblox.com/asset/?id=134980103242776" },
	["AK DADDY"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(0, 191, 255), emoji = "💎", image = "" },
	["AK STAFF"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(255, 255, 255), emoji = "🔰", image = "http://www.roblox.com/asset/?id=71948587278990" },
	["AK ADVERTISER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 69, 0), emoji = "📢", image = "" },
	["AK HELPER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(169, 169, 169), emoji = "📢", image = "" },
	["AK USER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(0, 140, 255), emoji = "♦️", image = "http://www.roblox.com/asset/?id=105073335979264" },
	["OG BUYER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 105, 180), emoji = "∞", image = "" },
	["AK LUCKYGOD"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(124, 252, 0), emoji = "🍀", image = "" },
	["AK BOOSTER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(128, 0, 128), emoji = "🚀", image = "" },
	["AK SUPPORT"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(0,150,0),   emoji = "🔨", image = "http://www.roblox.com/asset/?id=78056611932628" },
	["AK BADDIE"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 105, 180), emoji = "👅", image = "" },
	["AK REAPER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(0, 0, 0), emoji = "🧿", image = "" },
	["AK MONEYMAKER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(152, 255, 152), emoji = "💰", image = "" },
	["AK GODMODE"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 215, 0), emoji = "🤫", image = "" },
        ["AK FEMBOY"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 105, 180), emoji = "💖", image = "" },
        ["AK ASIAN"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(64, 224, 208), emoji = "🍜", image = "" },
        ["AK TERMINATOR"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 102, 102), emoji = "👁️", image = "" },
        ["AK CEO"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(200, 162, 200), emoji = "👑", image = "" },
        ["AK E-SEXLOVER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 105, 180), emoji = "💋", image = "" },
        ["AK MOMMY"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(144, 31, 242), emoji = "🍄", image = "" },
        ["AK DEX"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(0, 0, 0), emoji = "🐺", image = "" },
        ["AK SNIPERMASK"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(138, 3, 3), emoji = "👁️‍🗨️", image = "" },
        ["AK E-KITTEN"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 105, 180), emoji = "🍑", image = "" },
        ["AK FREAK"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 255, 255), emoji = "🍆", image = "" },
        ["AK AZER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 255, 255), emoji = "🩸", image = "" },
        ["AK HUSTLA"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(0, 160, 190), emoji = "🦈", image = "" },
        ["AK HOLLOWFLAME"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 85, 0), emoji = "🎃", image = "" },
        ["AK FENNEC"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(255, 140, 0), emoji = "🦊", image = "http://www.roblox.com/asset/?id=78056611932628" },
        ["AK DRAGON"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(139, 0, 0), emoji = "🍓", image = "" },
        ["AK FEDERAL"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 0, 0), emoji = "🚨", image = "" },
        ["AK GOODBOY"] = { primary = Color3.fromRGB(20, 0, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 0, 0), emoji = "🥵", image = "" },
        ["AK ARCTURUS"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(255, 165, 0), emoji = "♦️", image = "http://www.roblox.com/asset/?id=106859219117319" },
        ["AK WARRIOR"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(252, 11, 3), emoji = "♦️", image = "http://www.roblox.com/asset/?id=74203319792453" },
        ["AK KAWAII"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(255, 105, 180), emoji = "♦️", image = "http://www.roblox.com/asset/?id=120305713055340" },
        ["AK POTATO"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = true, accent = Color3.fromRGB(255, 165, 0), emoji = "♦️", image = "http://www.roblox.com/asset/?id=115679774469788" },
        ["AK TWISTED"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(255, 0, 0), emoji = "🤤", image = "" },
        ["AK PHROGSPLOIT"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(59, 255, 111), emoji = "🐸", image = "" },
        ["AK DOGGYFUCKER"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = true, UseImage = true, accent = Color3.fromRGB(255, 102, 102), emoji = "🐸", image = "http://www.roblox.com/asset/?id=87817403228848" },
        ["AK DOGGYFUCKA"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = true, UseImage = true, accent = Color3.fromRGB(0, 255, 255), emoji = "🐸", image = "http://www.roblox.com/asset/?id=97511041552708" },
        ["AK HORNYBOY"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(242, 66, 245), emoji = "🦝", image = "http://www.roblox.com/asset/?id=97511041552708" },
	["AK PERKZ"] = { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, UseImage = false, accent = Color3.fromRGB(124, 252, 0), emoji = "💰", image = "" },
        ["AK MOMMY KITTY"] = {primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = true, UseImage = true, accent = Color3.fromRGB(255, 183, 206), emoji = "🐸", image = "http://www.roblox.com/asset/?id=96637072641091"}








}

local ChatWhitelist = {}

-- Remove spaces from a string.
local function modifyString(randomText)
	local modified = ""
	for char in randomText:gmatch(".") do
		if char ~= " " then
			modified = modified .. char
		end
	end
	return modified
end

-- Chat message for spam.
local message = "AKADMIN-AntiTags"
local modifiedMessage = modifyString(message) -- This line was duplicated in original, keep it for fidelity

-- Chat Spam (if you wish to remove, comment or delete this section)
spawn(function() -- <<<< CHAT SPAM RE-ENABLED >>>>
    while true do
        -- send 10 messages evenly over 5 seconds
        for i = 1, 10 do
            Players:Chat(modifiedMessage)
            wait(5)  -- 10 × 0.5s = 5s total
        end
    end
end) -- <<<< C

local modifiedMessage = modifyString(message) -- This line was duplicated in original, keep it for fidelity


-- User Lists (Ensure names are lowercase for containsIgnoreCase if using it that way)
-- It seems the original used case-sensitive comparisons implicitly before containsIgnoreCase was fully integrated
local Advertisers = {"Vlafz195", "6736_45", "goekaycool", "goekayball", "goekayball2"}
local Helper = {"newbornfromthedark", "FadedSkyPlay"}
local Scripters = {"GYATT_DAMN1", "328ml", "29Kyooo", "goetemp_1", "goetemp_2", "BloxiAstra", "Robloxian74630436", "iLoveScriptsMiniG"}
local Owners = {"Dxan_PlayS", "Xeni_he07", "AliKhammas1234", "YournothimbuddyXD", "I_LOVEYOU12210", "AK_ADMEN1", "AK_ADMEN2", "Akksosdmdokdkddmkd"}
local Supporter = {"Robloxian74630436", "MyLittlePonySEDE", "IBimsDerBimbo44","SebyIz"}
local AKStaff = {"goekaycool", "hallloweenss", "24ksm1le5", "canoxaloo","mullyXD222","elijahmob2010"}
local LuckyGods = {"lIIluckyIIII", "TheSadMan198", "XxLuckyXx187", "XxRaportXX", "FellFlower2"}
local Boosters = {"lunarrjng", "Complexgummy", "Yuutsuna69", "rectimhamborger", "jadaismommy123", "Mississippi3344", "proficerium", "AstoIfooooo", "sIyvibes","c4air", "ich978", "Highlandfoil964", "WealthyZeno", "elxsqt", "Sycredifying"}
local Supporters = {"MullyALT_2", "TheRealGabbyChan6", "GoodHelper12345", "elijahmob2010", "qbz1934", "Garryisgarry43"} -- Original name
local Baddies = {"tbhaxol", ""}
local Reapers = {"silences0u1", ""}
local Moneymakers = {"AznBBacon", ""}
local Godmodes = {"HSKairu"}
local Femboys = {"knight_9618"}
local Asians = {"Halalbeyazz"}
local Terminators = {"BossCard03"}
local Ceos = {"Space_Dev01"}
local lovers = {"Bigfloppy1234"}
local mommys = {"IeftIeft"}
local dex = {"R1ZZULAT0R"}
local Sniper = {"HistoricalBuster"}
local kitten = {"HeavenSentSinner"}
local Azer = {""}
local Freak = {"XxcyripticxX"}
local husta = {"Lerks_alt"}
local hollow = {"HunterAnnie0101"}
local fox = {"ms_fennec"}
local dragon = {"123_haru0"}
local fed = {"Obsidsto5726"}
local ka = {"GoozIstEinSimp"}
local goodboy = {"bossgamama"}
local warriors = {"King_JNeko"}
local kitty = {"21_brook53star"}
local potato = {"nuggiestart"}
local twisted = {"HmBullet"}
local frogsploits = {"Watermelon829829"}
local doggy = {"awdawdhjhjyrygftdhdr"}
local doggy2 = {"Bloo_Dubbs"}
local hornyboys = {"Yuutsuna69"}
local perks = {"15korno"}
local mom = {"mommykittyownsyou"}

-- Create basic particle frames. (Identical to original)
local function createParticles(tag, parent, accentColor)
	for i = 1, CONFIG.PARTICLE_COUNT do
		local particle = Instance.new("Frame")
		particle.Name = "Particle_" .. i
		particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
		particle.Position = UDim2.new(math.random(), math.random(-10, 10), 1 + math.random() * 0.5, 0)
		particle.BackgroundColor3 = accentColor
		particle.BackgroundTransparency = math.random(0, 0.4)
		particle.BorderSizePixel = 0
		local pCorner = Instance.new("UICorner")
		pCorner.CornerRadius = UDim.new(1, 10)
		pCorner.Parent = particle
		particle.Parent = parent

		spawn(function()
			while tag and tag.Parent do
				local startX = math.random()
				local startOffsetX = math.random(-10, 10)
				particle.Position = UDim2.new(startX, startOffsetX, 1 + math.random() * 0.5, 0)
				particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
				particle.BackgroundTransparency = math.random(0, 0.4)

				local duration = math.random(10, 40) / (CONFIG.PARTICLE_SPEED * 10)
				local endX = startX + (math.random() - 0.5) * 0.3
				local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)

				local tween = TweenService:Create(particle, tweenInfo, {
					Position = UDim2.new(endX, startOffsetX, -0.5, math.random(-20, 20)),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0)
				})
				tween:Play()
				task.wait(math.random(20, 40) / (CONFIG.PARTICLE_SPEED * 10))
			end
		end)
	end
end

-- Teleport function (Identical to original, potential invalid asset IDs noted)
local function teleportToPlayer(targetPlayer)
	local localPlayer = Players.LocalPlayer
	local character = localPlayer.Character
	local targetCharacter = targetPlayer.Character
	if not (character and targetCharacter) then return end
	local humanoid = character:FindFirstChild("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local targetHRP = targetCharacter:FindFirstChild("UpperTorso")
	if not (humanoid and hrp and targetHRP) then return end
	local targetCFrame = targetHRP.CFrame
	local teleportPosition = targetCFrame.Position - (targetCFrame.LookVector * CONFIG.TELEPORT_DISTANCE)
	teleportPosition = teleportPosition + Vector3.new(0, CONFIG.TELEPORT_HEIGHT, 0)
	local particlepart = Instance.new("Part", workspace)
	particlepart.Transparency = 1
	particlepart.Anchored = true
	particlepart.CanCollide = false
	particlepart.Position = hrp.Position
	local transmitter1 = Instance.new("ParticleEmitter")
	transmitter1.Texture = "http://www.roblox.com/asset/?id=89296104222585" -- Original ID (potentially invalid)
	transmitter1.Size = NumberSequence.new(4)
	transmitter1.Lifetime = NumberRange.new(0.15, 0.15)
	transmitter1.Rate = 100
	transmitter1.TimeScale = 0.25
	transmitter1.VelocityInheritance = 1
	transmitter1.Drag = 5
	transmitter1.Parent = particlepart
	local particlepart2 = Instance.new("Part", workspace)
	particlepart2.Transparency = 1
	particlepart2.Anchored = true
	particlepart2.CanCollide = false
	particlepart2.Position = teleportPosition
	local transmitter2 = Instance.new("ParticleEmitter")
	transmitter2.Texture = "http://www.roblox.com/asset/?id=89296104222585" -- Original ID (potentially invalid)
	transmitter2.Size = NumberSequence.new(4)
	transmitter2.Lifetime = NumberRange.new(0.15, 0.15)
	transmitter2.Rate = 100
	transmitter2.TimeScale = 0.25
	transmitter2.VelocityInheritance = 1
	transmitter2.Drag = 5
	transmitter2.Parent = particlepart2
	local fadeTime = 0.1
	local tweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local meshParts = {}
	for _, part in ipairs(character:GetDescendants()) do
		-- Original only checked MeshPart, let's keep it that way
		if part:IsA("MeshPart") then
			table.insert(meshParts, part)
		end
	end
	for _, part in ipairs(meshParts) do
		local tween = TweenService:Create(part, tweenInfo, {Transparency = 1})
		tween:Play()
	end
	task.wait(fadeTime)
	hrp.CFrame = CFrame.new(teleportPosition, targetHRP.Position)
	local teleportSound = Instance.new("Sound")
	teleportSound.SoundId = "rbxassetid://5066021887"
	local head = character:FindFirstChild("Head")
	if head then
		teleportSound.Parent = head
	else
		teleportSound.Parent = hrp
	end
	teleportSound.Volume = 0.5
	teleportSound:Play()
	for _, part in ipairs(meshParts) do
		local tween = TweenService:Create(part, tweenInfo, {Transparency = 0})
		tween:Play()
	end
	game.Debris:AddItem(teleportSound, 2) -- Add sound cleanup like before
	task.wait(1)
	particlepart:Destroy()
	particlepart2:Destroy()
end

-- Helper function to calculate text width
local function getTextWidth(text, font, textSize)
	local size = TextService:GetTextSize(text, textSize, font, Vector2.new(2000, CONFIG.TAG_SIZE.Y.Offset)) -- Use large width constraint
	return math.ceil(size.X) -- Round up to ensure enough space
end


local function attachTagToHead(character, player, rankText)
	local head = character:FindFirstChild("Head")
	if not head then
		head = character:WaitForChild("Head", 1)
		if not head then return end
	end
	-- Disable default Roblox nametag.
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
	-- Remove any existing custom tag for this head. (Original logic was slightly different, keeping it)
	for _, child in ipairs(head:GetChildren()) do
		if child.Name == "RankTag" then
			child:Destroy()
		end
	end

	local rankData = RankData[rankText] or { primary = Color3.fromRGB(20, 20, 20), AnimateName = false, JumpLetters = false, GlitchName = false, accent = Color3.fromRGB(114, 47, 55), emoji = "⭐" } -- Default fallback

	local tag = Instance.new("BillboardGui")
	tag.Name = "RankTag"
	tag.Adornee = head
	tag.Size = CONFIG.TAG_SIZE -- Initial size, will be updated
	tag.StudsOffset = CONFIG.TAG_OFFSET
	tag.AlwaysOnTop = true
	tag.MaxDistance = CONFIG.MAX_DISTANCE
	tag.LightInfluence = 0
	tag.ResetOnSpawn = false
	tag.Active = true

	local container = Instance.new("Frame")
	container.Name = "TagContainer"
	container.Size = UDim2.new(1, 0, 1, 0) -- Container fills the tag
	container.BackgroundColor3 = rankData.primary
	container.BackgroundTransparency = 0.15
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = tag

	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = CONFIG.CORNER_RADIUS
	containerCorner.Parent = container

	local border = Instance.new("UIStroke")
	border.Color = rankData.accent
	border.Thickness = 2
	border.Transparency = 0.2
	border.Parent = container

	local clickButton = Instance.new("TextButton")
	clickButton.Name = "ClickButton"
	clickButton.Size = UDim2.new(1, 0, 1, 0)
	clickButton.BackgroundTransparency = 1
	clickButton.Text = ""
	clickButton.ZIndex = 10
	clickButton.AutoButtonColor = false
	clickButton.Active = true
	clickButton.Parent = container

	-- Original event connections for click/hover
	if player ~= Players.LocalPlayer then
		clickButton.MouseButton1Click:Connect(function()
			teleportToPlayer(player)
		end)
		clickButton.MouseEnter:Connect(function()
			TweenService:Create(container, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
		end)
		clickButton.MouseLeave:Connect(function()
			TweenService:Create(container, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
		end)
	end

	local particlesContainer = Instance.new("Frame")
	particlesContainer.Name = "ParticlesContainer"
	particlesContainer.Size = UDim2.new(1, 0, 1, 0)
	particlesContainer.BackgroundTransparency = 1
	particlesContainer.ZIndex = 2
	particlesContainer.ClipsDescendants = true
	particlesContainer.Parent = container
	local pContainerCorner = Instance.new("UICorner")
	pContainerCorner.CornerRadius = UDim.new(1, 0) -- Original had this rounded
	pContainerCorner.Parent = particlesContainer
	createParticles(tag, particlesContainer, rankData.accent)
	
	local emojiLabel
	if rankData.UseImage then
		emojiLabel = Instance.new("ImageLabel")
		emojiLabel.Name = "EmojiLabel"
		emojiLabel.Size = UDim2.new(0, 30, 0, 30) -- Original size
		emojiLabel.Position = UDim2.new(0, 8, 0.5, -15) -- Original position
		emojiLabel.BackgroundTransparency = 1
		emojiLabel.Image = rankData.image
		emojiLabel.ScaleType = Enum.ScaleType.Fit -- Ensure image fits properly
		emojiLabel.ZIndex = 5 -- Match ZIndex with text version
		emojiLabel.Parent = container
	else
		emojiLabel = Instance.new("TextLabel")
		emojiLabel.Name = "EmojiLabel"
		emojiLabel.Size = UDim2.new(0, 30, 0, 30) -- Original size
		emojiLabel.Position = UDim2.new(0, 8, 0.5, -15) -- Original position
		emojiLabel.BackgroundTransparency = 1
		emojiLabel.Text = rankData.emoji
		emojiLabel.TextSize = 22
		emojiLabel.Font = Enum.Font.GothamBold
		emojiLabel.TextColor3 = Color3.new(1, 1, 1)
		emojiLabel.ZIndex = 5
		emojiLabel.Parent = container
	end

	-- DisplayName label
	local displayNameLabel = Instance.new("TextLabel")
	displayNameLabel.Name = "DisplayNameLabel"
	displayNameLabel.BackgroundTransparency = 1
	-- MODIFICATION: Use full display name, remove truncation
	local fullDisplayName = player.DisplayName or player.Name
	displayNameLabel.Text = "@" .. fullDisplayName
	displayNameLabel.TextSize = 10 -- Original size
	displayNameLabel.Font = Enum.Font.GothamBold
	displayNameLabel.TextColor3 = rankData.accent -- Original color
	displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	displayNameLabel.ZIndex = 5
	-- Size and Position determined below

	-- Rank label
	local rankLabel = Instance.new("TextLabel")
	rankLabel.Name = "RankLabel"
	rankLabel.BackgroundTransparency = 1
	-- MODIFICATION: Use full rank text, remove truncation
	rankLabel.Text = rankText
	rankLabel.TextSize = 14 -- Original size
	rankLabel.Font = Enum.Font.GothamBold
	rankLabel.TextColor3 = rankData.accent -- Original color
	rankLabel.TextXAlignment = Enum.TextXAlignment.Left
	rankLabel.ZIndex = 5
	spawn(function()
		while true do
			wait()
			-- Blinking cursor animation
			if rankData.AnimateName then
				local name = rankText
				local blinkCount = 5
				local typingDelay = 0.1
				local blinkDelay = 0.5
				
				-- Write the name character by character
				for i = 1, #name do
					rankLabel.Text = string.sub(name, 1, i) .. "|"
					wait(typingDelay)
				end
				
				-- Blink cursor at the end of the name
				for i = 1, blinkCount do
					rankLabel.Text = name .. "|"
					wait(blinkDelay)
					rankLabel.Text = name
					wait(blinkDelay)
				end
				
				-- Delete the name character by character
				for i = #name, 1, -1 do
					rankLabel.Text = string.sub(name, 1, i) .. "|"
					wait(typingDelay)
				end
				
				-- Blink cursor with no name
				for i = 1, blinkCount do
					rankLabel.Text = "|"
					wait(blinkDelay)
					rankLabel.Text = ""
					wait(blinkDelay)
				end
			-- Jumping letters animation
			elseif rankData.JumpLetters then
				local text = rankText
				local jumpDuration = 0.2
				local pauseDuration = 0.5
				local jumpIterations = 3
				
				for iteration = 1, jumpIterations do
					-- Create jumping effect for each letter one at a time
					for i = 1, #text do
						local before = string.sub(text, 1, i-1)
						local current = string.sub(text, i, i)
						local after = string.sub(text, i+1)
						
						-- Jump up
						rankLabel.Text = before .. string.lower(current) .. after
						wait(jumpDuration)
						
						-- Return to normal
						rankLabel.Text = text
						wait(jumpDuration)
					end
				end
			-- Digital Glitch animation
			elseif rankData.GlitchName then
				local text = rankText
				local glitchDuration = 0.05
				local normalDuration = 0.3
				local glitchCycles = 5
				local glitchIntensity = 3  -- How many glitch artifacts per cycle
				
				-- Special characters for glitch effect
				local glitchChars = {"@", "#", "$", "%", "&", "!", "?", "/", "\\", "|", "<", ">", "=", "+", "*", "-", "_", "~", "^"}
				
				for cycle = 1, glitchCycles do
					-- Show normal text first
					rankLabel.Text = text
					wait(normalDuration)
					
					-- Multiple glitch artifacts per cycle
					for artifact = 1, glitchIntensity do
						local glitchedText = ""
						
						-- Process each character
						for i = 1, #text do
							-- Randomly decide if this character should glitch
							if math.random() < 0.3 then
								-- Replace with random glitch character or shift case
								local randomChoice = math.random(1, 10)
								if randomChoice <= 7 then
									-- Use a random glitch character
									glitchedText = glitchedText .. glitchChars[math.random(1, #glitchChars)]
								elseif randomChoice <= 9 then
									-- Change case
									local char = string.sub(text, i, i)
									if char == string.upper(char) then
										glitchedText = glitchedText .. string.lower(char)
									else
										glitchedText = glitchedText .. string.upper(char)
									end
								else
									-- Character disappears
									glitchedText = glitchedText .. " "
								end
							else
								-- Keep original
								glitchedText = glitchedText .. string.sub(text, i, i)
							end
						end
						
						-- Random position shift effect
						if math.random() < 0.3 then
							-- Add random spaces at beginning or push text to the right
							local spaces = string.rep(" ", math.random(1, 3))
							glitchedText = spaces .. glitchedText
						end
						
						-- Sometimes random characters are added to the end
						if math.random() < 0.3 then
							local extraGlitch = ""
							for i = 1, math.random(1, 3) do
								extraGlitch = extraGlitch .. glitchChars[math.random(1, #glitchChars)]
							end
							glitchedText = glitchedText .. extraGlitch
						end
						
						-- Display the glitched text
						rankLabel.Text = glitchedText
						wait(glitchDuration)
					end
					
					-- Return to normal text between cycles
					rankLabel.Text = text
					wait(normalDuration * 2)
				end
				
				-- Final return to normal text
				rankLabel.Text = text
				wait(normalDuration * 3)
			end
		end
	end)
	-- Size and Position determined below

	-- === MODIFICATION: Dynamic Width Calculation ===
	-- Use original padding/layout values derived from original script
	local sidePadding = 16 -- Original script used this for positioning text block start
	local emojiWidth = 36 -- Original script used this offset calculation `emojiWidth + sidePadding`
	local emojiLabelWidth = 30 -- Actual width of the emoji label itself
	local emojiLeftPadding = 8 -- Original emoji position offset X

	-- Calculate actual text widths needed
	local rankWidthActual = getTextWidth(rankLabel.Text, rankLabel.Font, rankLabel.TextSize)
	local displayNameWidthActual = getTextWidth(displayNameLabel.Text, displayNameLabel.Font, displayNameLabel.TextSize)
	local maxTextWidth = math.max(rankWidthActual, displayNameWidthActual)

	-- Calculate total width based on original structure:
	-- [emojiLeftPadding] [emojiLabelWidth] [sidePadding] [maxTextWidth] [sidePadding]
	local totalWidth = emojiLeftPadding + emojiLabelWidth + sidePadding + maxTextWidth + sidePadding

	-- Update tag size
	tag.Size = UDim2.new(0, totalWidth, 0, CONFIG.TAG_SIZE.Y.Offset)
	container.Size = UDim2.new(1, 0, 1, 0) -- Container still fills tag

	-- Position and Size Elements based on calculation and original layout

	emojiLabel.Position = UDim2.new(0, emojiLeftPadding, 0.5, -15) -- Keep original Y pos/anchor
	emojiLabel.Size = UDim2.new(0, emojiLabelWidth, 0, 30) -- Keep original size

	local textBlockXOffset = emojiLeftPadding + emojiLabelWidth + sidePadding -- Where text starts

	-- Position and size rank label using its actual required width
	rankLabel.Position = UDim2.new(0, textBlockXOffset, 0, 3) -- Original Y position
	rankLabel.Size = UDim2.new(0, rankWidthActual, 0, 16) -- Use actual width, original height
	rankLabel.Parent = container

	-- Position and size display name label using its actual required width
	displayNameLabel.Position = UDim2.new(0, textBlockXOffset, 0, 17) -- Original Y position
	displayNameLabel.Size = UDim2.new(0, displayNameWidthActual, 0, 16) -- Use actual width, original height
	displayNameLabel.Parent = container
	-- === End Dynamic Width Calculation Modification ===


	-- Revised minimized configuration.
	local isMinimized = false
		-- MODIFICATION: Use the dynamically calculated totalWidth for FULL_SIZE
		local FULL_SIZE = UDim2.new(0, totalWidth, 0, CONFIG.TAG_SIZE.Y.Offset)
		local MINI_SIZE = UDim2.new(0, 40, 0, 40) -- Original mini size
		local MINI_OFFSET = Vector3.new(0, 1.0, 0) -- Original mini offset
	local activeTween = true -- Variable to control the loop

	-- Original minimize/maximize tween loop
	spawn(function()
		while activeTween do -- Use the control variable
			if character and head and head.Parent and Players.LocalPlayer and Players.LocalPlayer.Character then
				local localHead = Players.LocalPlayer.Character:FindFirstChild("Head")
				if localHead then
					local distance = (head.Position - localHead.Position).Magnitude
					if distance > (CONFIG.DISTANCE_THRESHOLD + CONFIG.HYSTERESIS) and not isMinimized then
						isMinimized = true
						TweenService:Create(tag, TweenInfo.new(0.5), { Size = MINI_SIZE, StudsOffset = MINI_OFFSET }):Play()
						TweenService:Create(rankLabel, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
						TweenService:Create(displayNameLabel, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
						-- Original emoji tween for minimize
						TweenService:Create(emojiLabel, TweenInfo.new(0.5), { Position = UDim2.new(0.5, -15, 0.5, -15), Size = UDim2.new(0, 30, 0, 30)}):Play()
						TweenService:Create(containerCorner, TweenInfo.new(0.5), { CornerRadius = UDim.new(1, 0) }):Play() -- Fully rounded corners
					elseif distance < (CONFIG.DISTANCE_THRESHOLD - CONFIG.HYSTERESIS) and isMinimized then
						isMinimized = false
						TweenService:Create(tag, TweenInfo.new(0.5), { Size = FULL_SIZE, StudsOffset = CONFIG.TAG_OFFSET }):Play() -- Use dynamic FULL_SIZE
						TweenService:Create(rankLabel, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
						TweenService:Create(displayNameLabel, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
						-- Original emoji tween for maximize
						TweenService:Create(emojiLabel, TweenInfo.new(0.5), { Position = UDim2.new(0, 8, 0.5, -15), Size = UDim2.new(0, 30, 0, 30)}):Play()
						TweenService:Create(containerCorner, TweenInfo.new(0.5), { CornerRadius = CONFIG.CORNER_RADIUS }):Play() -- Restore original corner radius
					end
				end
			else
				-- Character or head is gone, stop the loop for this tag
				activeTween = false
			end
			task.wait(0.2)
		end
	end)
	-- Original cleanup logic using activeTween
	tag.AncestryChanged:Connect(function(_, parent)
		if not parent then
			activeTween = false -- Signal the loop to stop if the tag is removed
		end
	end)
	-- This connection might be redundant if AncestryChanged handles it, but keep original structure
	Players.PlayerRemoving:Connect(function(removedPlayer)
		if removedPlayer == player then
			if tag and tag.Parent then
				tag:Destroy() -- Explicitly destroy if player leaves
			end
			activeTween = false -- Signal the loop to stop
		end
	end)

	-- Parent the tag to the local player's PlayerGui. (Original logic)
	tag.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	-- Re-connect click button just in case parenting affected it (Original did this)
	if player ~= Players.LocalPlayer then
		clickButton.MouseButton1Click:Connect(function()
			teleportToPlayer(player)
		end)
	end
	return tag
end

local localTagChoice = nil -- Original variable

-- Modified Notification GUI function for AK ADMIN coming from the top right. (Identical to original)
local function showAKAdminNotification(player)
	local playerName = player.Name
	local notifMessage = "@" .. playerName .. " Has executed AK ADMIN"
	local success, thumb = pcall(function() -- Wrap in pcall for safety
		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)
	if not success then thumb = "" end -- Default if error

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AKAdminNotificationGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = "NotificationFrame"
	frame.Size = UDim2.new(0, 300, 0, 80)
	frame.Position = UDim2.new(1, 310, 0, -80) -- Original start position
	frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.8
	stroke.Thickness = 0.5
	stroke.Parent = frame

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "ProfilePic"
	imageLabel.Size = UDim2.new(0, 50, 0, 50)
	imageLabel.Position = UDim2.new(0, 10, 0, 15) -- Original position
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = thumb
	imageLabel.Parent = frame
	-- Original didn't have rounded corner for image


	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "NotificationText"
	textLabel.Size = UDim2.new(1, -70, 1, 0) -- Original size
	textLabel.Position = UDim2.new(0, 60, 0, 0) -- Original position
	textLabel.BackgroundTransparency = 1
	textLabel.Text = notifMessage
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 16
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center -- Default alignment if not specified
	textLabel.Parent = frame

	-- Original Tweens
	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Position = UDim2.new(1, -310, 0, 10)}) -- Original end position
	tweenIn:Play()
	tweenIn.Completed:Wait()

	task.wait(3) -- Original wait time

	local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Position = UDim2.new(1, 310, 0, -80)}) -- Original out position
	tweenOut:Play()
	tweenOut.Completed:Wait()
	screenGui:Destroy()
end

-- Tag Choice Notification UI (Identical to original)
local function createNotificationUI()
	-- Prevent duplicate notifications.
	if game:GetService("CoreGui"):FindFirstChild("TagNotification") or localTagChoice ~= nil then
		return nil, nil, nil, nil
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "TagNotification"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.Size = UDim2.new(0, 280, 0, 140)
	frame.Position = UDim2.new(0.5, -140, 0.5, -70) -- Original Position
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = 0 -- Original transparency
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = frame

	-- Original blur logic
	local blur = Instance.new("BlurEffect")
	blur.Size = 10
	blur.Parent = Lighting

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.8
	stroke.Thickness = 1
	stroke.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 35) -- Original size
	title.Position = UDim2.new(0, 0, 0, 10) -- Original position
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 16
	title.Text = "Tag Visibility Settings"
	title.Parent = frame

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Size = UDim2.new(0.9, 0, 0, 40) -- Original size
	messageLabel.Position = UDim2.new(0.05, 0, 0.35, 0) -- Original position
	messageLabel.BackgroundTransparency = 1
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
	messageLabel.TextSize = 14
	messageLabel.TextWrapped = true
	messageLabel.Text = "Would you like to display your rank tag above your character?"
	messageLabel.Parent = frame

	-- Original button creation logic
	local function createButton(text, position, color)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.35, 0, 0, 30)
		button.Position = position
		button.BackgroundColor3 = color
		button.BorderSizePixel = 0
		button.Font = Enum.Font.GothamBold
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextSize = 14
		button.Text = text
		button.AutoButtonColor = false
		button.BackgroundTransparency = 0 -- Original transparency
		button.Parent = frame

		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 6)
		buttonCorner.Parent = button

		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
		end)
		return button
	end

	local yesButton = createButton("Yes", UDim2.new(0.1, 0, 0.7, 0), Color3.fromRGB(46, 204, 113))
	local noButton = createButton("No", UDim2.new(0.55, 0, 0.7, 0), Color3.fromRGB(231, 76, 60))
	return gui, yesButton, noButton, blur -- Return original values
end

-- Tag creation logic (calls modified attachTagToHead)
local charAddedConn -- Store the CharacterAdded connection
local notificationGuiVisible = false -- Flag to prevent multiple GUIs

-- Function to handle tag attachment and CharacterAdded connection
local function attachTagAndConnect(player, rankText)
	if player.Character then
		attachTagToHead(player.Character, player, rankText)
	end
	if charAddedConn then charAddedConn:Disconnect() end -- Disconnect previous connection
	charAddedConn = player.CharacterAdded:Connect(function(character)
		task.wait()
		attachTagToHead(character, player, rankText)
	end)
	-- Original disconnect logic for player removing
	local playerRemovingConn = Players.PlayerRemoving:Connect(function(leavingPlayer)
		if leavingPlayer == player then
			if charAddedConn then charAddedConn:Disconnect() end
			if playerRemovingConn then playerRemovingConn:Disconnect() end -- Disconnect self
		end
	end)
end

-- Function to handle GUI cleanup
local function cleanupNotificationUI(gui, blur, yesConn, noConn)
	if yesConn then yesConn:Disconnect() end
	if noConn then noConn:Disconnect() end

	if gui then gui:Destroy() end
	if blur and blur.Parent then
		blur:Destroy()
	end
	notificationGuiVisible = false -- Reset the flag
end

-- Function to handle user choice
local function handleUserChoice(player, rankText, choice)
	if choice then
		attachTagAndConnect(player, rankText)
	end
	localTagChoice = choice
end

local function createTag(player, rankText, showPrompt)
	if showPrompt and player == Players.LocalPlayer then
		if localTagChoice ~= nil then
			if localTagChoice then
				attachTagAndConnect(player, rankText)
			end
			return
		end

		-- Check if the notification GUI is already visible
		if notificationGuiVisible then
			return
		end

		local gui, yesButton, noButton, blur = createNotificationUI()
		if not gui then return end
		local playerGui = player:WaitForChild("PlayerGui", 5)
		if not playerGui then
			if blur then blur:Destroy() end
			if gui then gui:Destroy() end
			return
		end
		gui.Parent = playerGui
		notificationGuiVisible = true -- Set the flag

		local yesConn, noConn
		yesConn = yesButton.MouseButton1Click:Connect(function()
			handleUserChoice(player, rankText, true)
			cleanupNotificationUI(gui, blur, yesConn, noConn)
		end)

		noConn = noButton.MouseButton1Click:Connect(function()
			handleUserChoice(player, rankText, false)
			cleanupNotificationUI(gui, blur, yesConn, noConn)
		end)
	else
		-- Not local player or no prompt needed
		attachTagAndConnect(player, rankText)
	end
end

-- Player tag application logic (Identical to original structure, uses containsIgnoreCase)
local function applyPlayerTag(player)
	if not player or not player:IsDescendantOf(Players) then
		return
	end
	local showPrompt = (player == Players.LocalPlayer)
	local assignedTag = nil
	local playerNameLower = player.Name:lower() -- Use lowercase for comparisons

	if containsIgnoreCase(Owners, playerNameLower) then
		assignedTag = "AK OWNER"
	elseif containsIgnoreCase(Scripters, playerNameLower) then
		assignedTag = "AK CO OWNER"
	elseif containsIgnoreCase(Supporter, playerNameLower) then -- Capital S list
		assignedTag = "AK DADDY"
	elseif containsIgnoreCase(AKStaff, playerNameLower) then
		assignedTag = "AK STAFF"
	elseif containsIgnoreCase(Advertisers, playerNameLower) then
		assignedTag = "AK ADVERTISER"
	elseif containsIgnoreCase(Helper, playerNameLower) then
		assignedTag = "AK HELPER"
	elseif containsIgnoreCase(LuckyGods, playerNameLower) then
		assignedTag = "AK LUCKYGOD"
	elseif containsIgnoreCase(Boosters, playerNameLower) then
		assignedTag = "AK BOOSTER"
	elseif containsIgnoreCase(Supporters, playerNameLower) then -- Plural S list
		assignedTag = "AK SUPPORT"
	elseif containsIgnoreCase(Baddies, playerNameLower) then
		assignedTag = "AK BADDIE"
	elseif containsIgnoreCase(Reapers, playerNameLower) then
		assignedTag = "AK REAPER"
	elseif containsIgnoreCase(Moneymakers, playerNameLower) then
		assignedTag = "AK MONEYMAKER"
	elseif containsIgnoreCase(Godmodes, playerNameLower) then
		assignedTag = "AK GODMODE"
	elseif containsIgnoreCase(Femboys, playerNameLower) then
		assignedTag = "AK FEMBOY"
	elseif containsIgnoreCase(Asians, playerNameLower) then
		assignedTag = "AK ASIAN"
	elseif containsIgnoreCase(Terminators, playerNameLower) then
		assignedTag = "AK TERMINATOR"
        elseif containsIgnoreCase(Ceos, playerNameLower) then
		assignedTag = "AK CEO"
        elseif containsIgnoreCase(lovers, playerNameLower) then
  		assignedTag = "AK E-SEXLOVER"
        elseif containsIgnoreCase(mommys, playerNameLower) then
		assignedTag = "AK MOMMY"
        elseif containsIgnoreCase(dex, playerNameLower) then
		assignedTag = "AK DEX"
        elseif containsIgnoreCase(Sniper, playerNameLower) then
		assignedTag = "AK SNIPERMASK"
        elseif containsIgnoreCase(kitten, playerNameLower) then
		assignedTag = "AK E-KITTEN"
        elseif containsIgnoreCase(Azer, playerNameLower) then
		assignedTag = "AK AZER"
        elseif containsIgnoreCase(Freak, playerNameLower) then
		assignedTag = "AK FREAK"
        elseif containsIgnoreCase(husta, playerNameLower) then
		assignedTag = "AK HUSTLA"
        elseif containsIgnoreCase(hollow, playerNameLower) then
		assignedTag = "AK HOLLOWFLAME"
        elseif containsIgnoreCase(fox, playerNameLower) then
		assignedTag = "AK FENNEC"
        elseif containsIgnoreCase(dragon, playerNameLower) then
		assignedTag = "AK DRAGON"
        elseif containsIgnoreCase(fed, playerNameLower) then
		assignedTag = "AK FEDERAL"
        elseif containsIgnoreCase(ka, playerNameLower) then
		assignedTag = "AK ARCTURUS"
        elseif containsIgnoreCase(goodboy, playerNameLower) then
		assignedTag = "AK GOODBOY"
	elseif containsIgnoreCase(warriors, playerNameLower) then
		assignedTag = "AK WARRIOR"
	elseif containsIgnoreCase(kitty, playerNameLower) then
		assignedTag = "AK KAWAII"
	elseif containsIgnoreCase(potato, playerNameLower) then
		assignedTag = "AK POTATO"
	elseif containsIgnoreCase(twisted, playerNameLower) then
		assignedTag = "AK TWISTED"
	elseif containsIgnoreCase(frogsploits, playerNameLower) then
		assignedTag = "AK PHROGSPLOIT"
	elseif containsIgnoreCase(doggy, playerNameLower) then
		assignedTag = "AK DOGGYFUCKER"
	elseif containsIgnoreCase(doggy2, playerNameLower) then
		assignedTag = "AK DOGGYFUCKA"
	elseif containsIgnoreCase(hornyboys, playerNameLower) then
		assignedTag = "AK HORNYBOY"
	elseif containsIgnoreCase(perks, playerNameLower) then
		assignedTag = "AK PERKZ"
	elseif containsIgnoreCase(mom, playerNameLower) then
		assignedTag = "AK MOMMY KITTY"
	elseif ChatWhitelist[playerNameLower] then -- Check lowercase key
		assignedTag = "AK USER"
	end

	-- Original tag removal logic (checking head children first)
	if player.Character and player.Character:FindFirstChild("Head") then
		local head = player.Character.Head
		-- Remove tag from head if it exists (original logic)
		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("BillboardGui") and child.Name == "RankTag" then
				child:Destroy()
			end
		end
		-- Also remove from LocalPlayerGui just in case (belt-and-suspenders based on original structure)
		local localPlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
		if localPlayerGui then
			for _, gui in ipairs(localPlayerGui:GetChildren()) do
				if gui:IsA("BillboardGui") and gui.Name == "RankTag" and gui.Adornee == head then
					gui:Destroy()
				end
			end
		end
	end

	if assignedTag then
		createTag(player, assignedTag, showPrompt)
	else
		-- No tag assigned, removal handled above. Original didn't have an explicit 'else' for removal here.
	end
end


local chatConnections = {} -- Original variable

-- Chat listener setup (Identical to original)
local function setupChatListener(player)
	if chatConnections[player] then
		return
	end
	local conn = player.Chatted:Connect(function(msg)
		if not player or not player:IsDescendantOf(Players) then
			if chatConnections[player] then
				chatConnections[player]:Disconnect()
			end
			chatConnections[player] = nil
			return
		end
		-- Check for the special AK ADMIN command
		if modifyString(msg:lower()) == modifiedMessage:lower() then
			local playerNameLower = player.Name:lower()
			-- Check if player already has a rank (excluding AK USER)
			if containsIgnoreCase(Owners, playerNameLower)
				or containsIgnoreCase(Scripters, playerNameLower)
				or containsIgnoreCase(Supporter, playerNameLower)
				or containsIgnoreCase(AKStaff, playerNameLower)
				or containsIgnoreCase(Advertisers, playerNameLower)
				or containsIgnoreCase(Helper, playerNameLower)
				or containsIgnoreCase(LuckyGods, playerNameLower)
				or containsIgnoreCase(Supporters, playerNameLower) -- Plural S list
				or containsIgnoreCase(Baddies, playerNameLower)
				or containsIgnoreCase(Reapers, playerNameLower)
				or containsIgnoreCase(Moneymakers, playerNameLower)
				or containsIgnoreCase(Godmodes, playerNameLower)
				or containsIgnoreCase(Femboys, playerNameLower)
				or containsIgnoreCase(Asians, playerNameLower)
				or containsIgnoreCase(Terminators, playerNameLower)
				or containsIgnoreCase(Ceos, playerNameLower)
				or containsIgnoreCase(lovers, playerNameLower)
				or containsIgnoreCase(mommys, playerNameLower)
				or containsIgnoreCase(dex, playerNameLower)
				or containsIgnoreCase(Sniper, playerNameLower)
				or containsIgnoreCase(kitten, playerNameLower)
				or containsIgnoreCase(Azer, playerNameLower)
				or containsIgnoreCase(Freak, playerNameLower)
				or containsIgnoreCase(husta, playerNameLower)
				or containsIgnoreCase(hollow, playerNameLower)
				or containsIgnoreCase(fox, playerNameLower)
				or containsIgnoreCase(dragon, playerNameLower)
				or containsIgnoreCase(fed, playerNameLower)
				or containsIgnoreCase(ka, playerNameLower)
				or containsIgnoreCase(goodboy, playerNameLower)
				or containsIgnoreCase(warriors, playerNameLower)
				or containsIgnoreCase(kitty, playerNameLower)
				or containsIgnoreCase(potato, playerNameLower)
				or containsIgnoreCase(twisted, playerNameLower)
				or containsIgnoreCase(frogsploits, playerNameLower)
				or containsIgnoreCase(doggy, playerNameLower)
				or containsIgnoreCase(doggy2, playerNameLower)
				or containsIgnoreCase(hornyboys, playerNameLower)
				or containsIgnoreCase(perks, playerNameLower)
				or containsIgnoreCase(mom, playerNameLower)
				or containsIgnoreCase(Boosters, playerNameLower) then
				return -- Don't grant AK USER if they have a higher rank
			end
			-- Check if already whitelisted
			if ChatWhitelist[playerNameLower] then
				return -- Already has AK USER
			end
			ChatWhitelist[playerNameLower] = true -- Use lowercase key
			applyPlayerTag(player)
			showAKAdminNotification(player)
		end
	end)
	chatConnections[player] = conn
end

local localPlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui") -- Original variable definition location

-- Tag Refresh/Cleanup Coroutine (Identical to original)
spawn(function()
	while task.wait(2) do -- Original interval
		local validAdornees = {}
		local currentPlayers = Players:GetPlayers() -- Get players inside loop

		for _, player in ipairs(currentPlayers) do
			if player.Character and player.Character:FindFirstChild("Head") then
				table.insert(validAdornees, player.Character.Head)
				local hasTag = false
				-- Check LocalPlayerGui for the tag (original check location)
				for _, gui in ipairs(localPlayerGui:GetChildren()) do
					if gui:IsA("BillboardGui") and gui.Name == "RankTag" and gui.Adornee == player.Character.Head then
						hasTag = true
						break
					end
				end

				-- Determine if player should have tag (same logic as applyPlayerTag)
				local shouldHaveTag = false
				local playerNameLower = player.Name:lower()
				if containsIgnoreCase(Owners, playerNameLower)
					or containsIgnoreCase(Scripters, playerNameLower)
					or containsIgnoreCase(Supporter, playerNameLower)
					or containsIgnoreCase(AKStaff, playerNameLower)
					or containsIgnoreCase(Advertisers, playerNameLower)
					or containsIgnoreCase(Helper, playerNameLower)
					or containsIgnoreCase(LuckyGods, playerNameLower)
					or containsIgnoreCase(Boosters, playerNameLower)
					or containsIgnoreCase(Supporters, playerNameLower) -- Plural S list
					or containsIgnoreCase(Baddies, playerNameLower)
					or containsIgnoreCase(Reapers, playerNameLower)
					or containsIgnoreCase(Moneymakers, playerNameLower)
					or containsIgnoreCase(Godmodes, playerNameLower)
					or containsIgnoreCase(Femboys, playerNameLower)
					or containsIgnoreCase(Asians, playerNameLower)
					or containsIgnoreCase(Terminators, playerNameLower)
					or containsIgnoreCase(lovers, playerNameLower)
					or containsIgnoreCase(Ceos, playerNameLower)
					or containsIgnoreCase(mommys, playerNameLower)
					or containsIgnoreCase(dex, playerNameLower)
					or containsIgnoreCase(Sniper, playerNameLower)
					or containsIgnoreCase(kitten, playerNameLower)
					or containsIgnoreCase(Azer, playerNameLower)
					or containsIgnoreCase(Freak, playerNameLower)
					or containsIgnoreCase(husta, playerNameLower)
					or containsIgnoreCase(hollow, playerNameLower)
					or containsIgnoreCase(fox, playerNameLower)
					or containsIgnoreCase(dragon, playerNameLower)
					or containsIgnoreCase(fed, playerNameLower)
					or containsIgnoreCase(ka, playerNameLower)
					or containsIgnoreCase(goodboy, playerNameLower)
					or containsIgnoreCase(kitty, playerNameLower)
					or containsIgnoreCase(warriors, playerNameLower)
					or containsIgnoreCase(potato, playerNameLower)
				        or containsIgnoreCase(twisted, playerNameLower)
					or containsIgnoreCase(frogsploits, playerNameLower)
					or containsIgnoreCase(doggy, playerNameLower)
					or containsIgnoreCase(doggy2, playerNameLower)
					or containsIgnoreCase(hornyboys, playerNameLower)
					or containsIgnoreCase(perks, playerNameLower)
					or containsIgnoreCase(mom, playerNameLower)
					or ChatWhitelist[playerNameLower] then
					shouldHaveTag = true
				end

				-- If discrepancy, re-apply tag (original logic)
				if shouldHaveTag and not hasTag then
					applyPlayerTag(player)
				-- Original didn't explicitly remove tags here if `shouldHaveTag` was false,
				-- relying on the initial `applyPlayerTag` calls and player join/leave logic.
				-- We keep that behavior.
				end
			end
		end

		-- Cleanup orphaned tags in LocalPlayerGui (original logic)
		for i = #localPlayerGui:GetChildren(), 1, -1 do -- Iterate backwards
			local gui = localPlayerGui:GetChildren()[i]
			if gui:IsA("BillboardGui") and gui.Name == "RankTag" then
				local adornee = gui.Adornee
				if not adornee or not adornee:IsDescendantOf(workspace) or not table.find(validAdornees, adornee) then
					gui:Destroy()
				end
			end
		end
	end
end)

-- Initial setup for existing players (Identical to original)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(applyPlayerTag, player)
	task.spawn(setupChatListener, player)
end

-- Handle players joining (Identical to original)
Players.PlayerAdded:Connect(function(player)
	task.wait(0.5) -- Original delay
	task.spawn(setupChatListener, player)
	task.spawn(applyPlayerTag, player)
end)

-- Handle players leaving (Identical to original)
Players.PlayerRemoving:Connect(function(player)
	-- Disconnect chat listener
	if chatConnections[player] then
		chatConnections[player]:Disconnect()
		chatConnections[player] = nil
	end

	-- Remove the tag associated with the player from the local player's GUI
	local playerHead = player.Character and player.Character:FindFirstChild("Head")
	if playerHead and localPlayerGui then
		for _, gui in ipairs(localPlayerGui:GetChildren()) do
			if gui:IsA("BillboardGui") and gui.Name == "RankTag" and gui.Adornee == playerHead then
				gui:Destroy()
				break
			end
		end
	end

	-- Cleanup notification UI if the leaving player is the local player (Original logic)
	if player == Players.LocalPlayer then
		local playerGui = player:FindFirstChild("PlayerGui") -- Check the leaving player's Gui
		if playerGui then
			local notification = playerGui:FindFirstChild("TagNotification")
			if notification then
				notification:Destroy()
				-- Also remove the blur effect if it exists
				local blur = Lighting:FindFirstChild("BlurEffect")
				if blur then -- Original just destroyed any blur effect
					blur:Destroy()
				end
			end
		end
		-- Reset local tag choice if local player leaves (original didn't explicitly do this, but good practice)
		localTagChoice = nil
	end
end)

-- Return table for external control (Identical to original)
return {
	refreshTags = function()
		print("Refreshing all player tags...")
		for _, player in ipairs(Players:GetPlayers()) do
			task.spawn(applyPlayerTag, player)
		end
	end,
	forceTag = function(player, rankType)
		if not player or not player:IsDescendantOf(Players) then
			warn("forceTag: Invalid player provided.")
			return false
		end
		if RankData[rankType] then
			print(string.format("Forcing tag '%s' for player %s", rankType, player.Name))
			-- Original removal logic before forcing
			if player.Character and player.Character:FindFirstChild("Head") then
				local head = player.Character.Head
				for _, child in ipairs(head:GetChildren()) do
					if child.Name == "RankTag" then
						child:Destroy()
					end
				end
			end
			-- Also remove from LocalPlayerGui
			for _, gui in ipairs(localPlayerGui:GetChildren()) do
				if gui:IsA("BillboardGui") and gui.Name == "RankTag" and gui.Adornee and gui.Adornee.Parent == player.Character then
					gui:Destroy()
				end
			end
			-- Create tag, ensure prompt logic respects local player status
			createTag(player, rankType, player == Players.LocalPlayer)
			return true
		else
			warn(string.format("forceTag: Invalid rankType '%s' provided.", rankType))
			return false
		end
	end,
}
