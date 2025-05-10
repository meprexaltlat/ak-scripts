local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
local gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local PlaceId, JobId = game.PlaceId, game.JobId
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService
local everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

local function writefileExploit()
    return writefile ~= nil
end

local function readfileExploit()
    return readfile ~= nil
end

local function isNumber(str)
    return tonumber(str) ~= nil or str == "inf"
end

-- Functionality to queue teleport execution
if queueteleport then
    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/LOLkeeptrying/AKADMIN/refs/heads/main/Congratslol'))()")
    print("Script queued for execution upon teleport.")
else
    warn("Queue on teleport is not supported on this executor.")
end
