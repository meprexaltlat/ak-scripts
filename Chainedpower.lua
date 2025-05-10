getgenv().spam = false
game.Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/nuke" then
        game:GetService("ReplicatedStorage").TrollCommand:FireServer("Nuke")
    end
    if msg:lower() == "/jail all" then
        game:GetService("ReplicatedStorage").TrollCommand:FireServer("JailAll")
    end
    if msg:lower() == "/spawn fog" then
        game:GetService("ReplicatedStorage").TrollCommand:FireServer("Fog")
    end
    if msg:lower() == "/bunnyhop all" then
        game:GetService("ReplicatedStorage").TrollCommand:FireServer("BunnyHop")
    end
    if msg:lower() == "/low gravity" then
        game:GetService("ReplicatedStorage").TrollCommand:FireServer("LowGravity")
    end
    if msg:lower() == "/no jumping" then
        game:GetService("ReplicatedStorage").TrollCommand:FireServer("NoJumping")
    end
    if msg:lower() == "/spam off" then
        getgenv().spam = false
    end
    if msg:lower() == "/spam on" then
        getgenv().spam = true
        while getgenv().spam do
           wait()
            if getgenv().spam == false then
                break
            end
            game:GetService("ReplicatedStorage").TrollCommand:FireServer("LowGravity")
            game:GetService("ReplicatedStorage").TrollCommand:FireServer("NoJumping")
        end
    end
end)
