loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/More-Scripts/refs/heads/main/Anthony's%20ACL"))()
local TextChatService = game:GetService("TextChatService")

-- Function to send a chat message
local function chatMessage(str)
    str = tostring(str)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        -- Use TextChatService to send the message
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        -- Use the old chat system
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- Invisible characters and formatting
local blob = "\u{000D}" -- Invisible character
local spaces = " " -- Spaces for centering text

-- Goodbye message with obfuscation to avoid filtering
local goodbyeMessage = spaces:rep(10) 
    .. "" .. blob:rep(80) 
    .. " ║👋 BYE BYE! 👋 ║" 
    .. blob:rep(5) 
    .. "\n" 
    .. " ║ d1scord.gg/VekmXžSj7S ║" -- Obfuscated Discord link
    .. blob:rep(40)

-- Compact message for the old chat system
local compactMessage = "👋 BYE BYE! 👋 d1scord.gg/VekmXžSj7S"

-- Check chat version and send appropriate message
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    -- Send the goodbye message 5 times with a slight delay for the new chat system
    for i = 1, 5 do
        chatMessage(goodbyeMessage)
        wait(0.1)  -- Small delay to ensure each message is sent smoothly
    end
else
    -- Send the compact message 5 times with a slight delay for the old chat system
    for i = 1, 5 do
        chatMessage(compactMessage)
        wait(0.1)  -- Small delay to ensure each message is sent smoothly
    end
end

-- Wait 0.5 seconds before leaving the game
wait(0.5)

-- Forcefully leave the game
game:Shutdown()
