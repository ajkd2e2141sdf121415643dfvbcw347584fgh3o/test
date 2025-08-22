local lp = game.Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local interface = pg:WaitForChild("Interface", 10)
local diamondCount = interface and interface:WaitForChild("DiamondCount", 10)
local countLabel = diamondCount and diamondCount:WaitForChild("Count", 10)

-- Config
getgenv().LockDiamond = "12"
getgenv().LockDiamondEnabled = true
getgenv().SelectClass = "Scavenger"
getgenv().BuyClassSelect = true
getgenv().ClassPurchased = false

spawn(function()
    while task.wait(1) do 
        if getgenv().LockDiamondEnabled and countLabel then
            if countLabel.Text == getgenv().LockDiamond then
                local TeleportService = game:GetService("TeleportService")
                pcall(function()
                    TeleportService:Teleport(79546208627805, game.Players.LocalPlayer)
                end)
            else
                getgenv().V = "Kaitundiamond"
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/AAwful/Vector_Hub/0/v2"))()
                end)
            end
        elseif not countLabel then
            warn("DiamondCount not found, skipping loop...")
        end
    end
end)

spawn(function()
    while task.wait(5) do 
        if getgenv().BuyClassSelect and getgenv().SelectClass and not getgenv().ClassPurchased then
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPurchaseClass"):FireServer(getgenv().SelectClass)
            getgenv().ClassPurchased = true
        end
    end
end)
