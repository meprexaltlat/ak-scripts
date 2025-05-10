local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

Notification:Notify(
    {Title = "AK ADMIN LOADER", Description = "Do you want to load AK ADMIN?"},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "option"},
    {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84), Callback = function(State) if tostring(State) == "true" then Notification:Notify(
    {Title = "AK ADMIN LOADER", Description = "Executing..."},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "default"}
) end
wait(0.5)
Notification:Notify(
    {Title = "SUCCESS", Description = "AK ADMIN Successfully loaded thanks for using AK ADMIN, Enjoy!"},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "default"}
)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/main/free%20ak%20admin"))()() end}
)
