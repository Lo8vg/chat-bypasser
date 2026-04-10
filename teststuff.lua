-- Basic Chat Spam Test for Roblox
-- Tests how quickly you get tagged for spamming 1 or 2 messages

local Players = game:GetService("Players")
local ReplicatedModules = game:GetService("ReplicatedStorage"):WaitForChild("ChatModules")
local ChatConstants = require(ReplicatedModules:WaitForChild("ChatConstants"))

-- Configuration
local TEST_TYPE = "single" -- Change to "single" or "double"
local MESSAGE1 = "test message"
local MESSAGE2 = "another test" -- Only used if TEST_TYPE is "double"
local DELAY_BETWEEN_MESSAGES = 1 -- seconds

-- Function to send chat message
local function sendMessage(message)
    local ChatRemote = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
    local SayMessageRequest = ChatRemote:WaitForChild("SayMessageRequest")
    SayMessageRequest:FireServer(message, ChatConstants.AllChannels)
end

-- Main test function
local function runSpamTest()
    local messageCount = 0
    local startTime = tick()
    
    if TEST_TYPE == "single" then
        print("Testing single message spam...")
        while true do
            sendMessage(MESSAGE1)
            messageCount = messageCount + 1
            print("Sent message #" .. messageCount)
            wait(DELAY_BETWEEN_MESSAGES)
        end
    elseif TEST_TYPE == "double" then
        print("Testing double message spam...")
        while true do
            sendMessage(MESSAGE1)
            messageCount = messageCount + 1
            print("Sent message #" .. messageCount)
            wait(DELAY_BETWEEN_MESSAGES)
            
            sendMessage(MESSAGE2)
            messageCount = messageCount + 1
            print("Sent message #" .. messageCount)
            wait(DELAY_BETWEEN_MESSAGES)
        end
    end
end

-- Start the test
runSpamTest()
