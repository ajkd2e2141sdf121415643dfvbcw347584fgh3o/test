local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
repeat task.wait() until LocalPlayer.Character

local lp = game.Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local interface = pg:WaitForChild("Interface", 10)
local diamondCount = interface and interface:WaitForChild("DiamondCount", 10)
local countLabel = diamondCount and diamondCount:WaitForChild("Count", 10)

-- Config
getgenv().LockDiamond = "2000"
getgenv().LockDiamondEnabled = true
getgenv().SelectClass = "Campfire"
getgenv().BuyClassSelect = true

-- ฟังก์ชันแจ้งเตือน
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Icon = "rbxassetid://16129235054",
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

-- ฟังก์ชันตรวจสอบ Place ID
local function isInLobby()
    return game.PlaceId == 79546208627805
end

spawn(function()
    notify("Script Started", "FPS Booster and Diamond Manager is running...", 5)
    while task.wait(1) do
        if getgenv().LockDiamondEnabled and countLabel then
            local diamondValue = tonumber(countLabel.Text) or 0
            local targetValue = tonumber(getgenv().LockDiamond) or 0
            notify("Checking Diamonds", "Current: " .. diamondValue .. " | Target: " .. targetValue, 2)
            
            if diamondValue >= targetValue then
                notify("Diamond Target Reached", "Teleporting to Lobby...", 3)
                if not isInLobby() then
                    pcall(function()
                        TeleportService:Teleport(79546208627805, game.Players.LocalPlayer)
                        notify("Teleporting", "Moving to Place ID 79546208627805", 3)
                    end)
                else
                    notify("Already in Lobby", "No teleport needed", 2)
                end
            else
                notify("Farming Diamonds", "Starting farm script (Value: " .. diamondValue .. ")", 3)
                getgenv().V = "Kaitundiamond"
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/AAwful/Vector_Hub/0/v2"))()
                    notify("Farm Script Loaded", "Vector Hub script is running", 3)
                end)
            end
        elseif not countLabel then
            notify("Error", "DiamondCount not found, skipping loop...", 5)
        end
    end
end)
