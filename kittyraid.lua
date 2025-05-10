while task.wait() do
    for _, x in next, game.Players.LocalPlayer.Backpack:GetChildren() do
        if x:IsA("Tool") then
            x.Parent = game.Players.LocalPlayer.Character
            x.Parent = workspace
        end
    end
game.ReplicatedStorage.GiveCat:FireServer()
end
