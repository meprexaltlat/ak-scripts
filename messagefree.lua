if not game:IsLoaded() then game["Loaded"]:wait() end

local Version = "AK ADMIN"
local CurrentChangelog = "FREE"

local Opened = false

local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")


local Message = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://15052532623", Duration = Time})
end

Message(string.format(" %s ", Version), "FREE VERSION ", 10)
