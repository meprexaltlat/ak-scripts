loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/More-Scripts/refs/heads/main/Anthony's%20ACL"))()
wait(1)
local function Chat(msg)
    -- Check if we're using the old chat system
    local oldChat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    
    -- Send message using the old chat system if it exists
    if oldChat then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    else
        -- Send message using the new TextChatService
        local textChatService = game:GetService("TextChatService")
        local channel = textChatService.TextChannels.RBXGeneral
        channel:SendAsync(msg)
    end
end

-- Call the Chat function
Chat(" 🔥ḍịṣcọrḍ.ḡḡ/gJgRuwC3MP🔥 ")
