game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "Note!",
Text = "This script takes 10 seconds to load and may lag when loading", 

Button1 = "Yes",
Button2 = "Cancel",
Duration = 30 
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/Fsploit/Frostware-/refs/heads/main/Bypass.lua"))()
