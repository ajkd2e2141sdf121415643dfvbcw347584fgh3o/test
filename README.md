wait(2)
_G.FarmChest = true

-- ⚙️ Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ⚙️ Variables
local player = Players.LocalPlayer
local PlaceID = game.PlaceId
local currentJobId = game.JobId

-- ⚙️ Configuration
local CONFIG = {
    TIMER_MINUTES = 1,
    MAX_PLAYERS_SAFE = 5,
    MIN_PLAYERS = 0,
    MAX_PAGES = 10,
    MAX_SERVER_ATTEMPTS = 5,
    RECHECK_DELAY = 2,
    TELEPORT_DELAY = 0,
    MAX_CYCLES = 4,
    FAST_MODE = true,
    SHOW_LOGS = true,
    USE_TELEPORT = true
}

-- ⚙️ State Variables
local isHopping = false
local startTime = tick()
local hopAttempts = 0
local TIMER_SECONDS = CONFIG.TIMER_MINUTES * 60

-- 📱 Wait for Player and PlayerGui
while not player or not player:FindFirstChild("PlayerGui") do
    task.wait()
end

-- 🗂️ Utility Functions
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

local function loadFailedServers()
    if isfile and isfile("failed_servers.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("failed_servers.json"))
        end)
        if success and data then return data end
    end
    return {}
end

local function saveFailedServer(serverId)
    local failed = loadFailedServers()
    table.insert(failed, serverId)
    if #failed > 30 then table.remove(failed, 1) end
    if writefile then
        pcall(function()
            writefile("failed_servers.json", HttpService:JSONEncode(failed))
        end)
    end
end

local function isServerFailed(serverId)
    local failed = loadFailedServers()
    for _, id in pairs(failed) do
        if id == serverId then return true end
    end
    return false
end

-- 🌐 Server Management Functions
local function fetchAndVerifyServer(serverId)
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.id == serverId then return server end
        end
    end
    return nil
end

local function findSafestServers()
    print("🔍 Searching for safest servers... Current JobId: " .. currentJobId)
    notify("Deep Search", "🔍 Detailed server search...", 3)
    
    local safestServers = {}
    local cursor = ""
    local pagesSearched = 0
    
    while pagesSearched < CONFIG.MAX_PAGES and #safestServers < 20 do
        pagesSearched = pagesSearched + 1
        print("📄 Searching page " .. pagesSearched .. "/" .. CONFIG.MAX_PAGES)
        
        local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end
        
        local success, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if not success or not data or not data.data then
            print("❌ Failed to fetch server data on page " .. pagesSearched)
            break
        end
        
        for _, server in pairs(data.data) do
            local isSuperSafe = (
                server.id ~= currentJobId and
                server.playing >= CONFIG.MIN_PLAYERS and
                server.playing <= CONFIG.MAX_PLAYERS_SAFE and
                server.maxPlayers >= 5 and
                not isServerFailed(server.id)
            )
            
            if isSuperSafe then
                table.insert(safestServers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers,
                    ping = server.ping or 999,
                    safety_score = (CONFIG.MAX_PLAYERS_SAFE - server.playing)
                })
                print("✅ Safe server: " .. server.id .. " (" .. server.playing .. "/" .. server.maxPlayers .. ")")
            end
        end
        
        cursor = data.nextPageCursor or ""
        if cursor == "" then break end
        task.wait(0.3)
    end
    
    table.sort(safestServers, function(a, b)
        if a.safety_score ~= b.safety_score then
            return a.safety_score > b.safety_score
        elseif a.playing ~= b.playing then
            return a.playing < b.playing
        else
            return a.ping < b.ping
        end
    end)
    
    print("🏆 Found " .. #safestServers .. " safe servers")
    return safestServers
end

local function findAvailableServers()
    print("🔍 Fallback: Finding any available servers... Current: " .. currentJobId)
    
    local availableServers = {}
    local cursor = ""
    local pagesSearched = 0
    
    while pagesSearched < CONFIG.MAX_PAGES and #availableServers < 20 do
        pagesSearched = pagesSearched + 1
        
        local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end
        
        local success, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if not success or not data or not data.data then break end
        
        for _, server in pairs(data.data) do
            local isAvailable = (
                server.id ~= currentJobId and
                server.playing < server.maxPlayers and
                not isServerFailed(server.id)
            )
            
            if isAvailable then
                table.insert(availableServers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers,
                    ping = server.ping or 999
                })
            end
        end
        
        cursor = data.nextPageCursor or ""
        if cursor == "" then break end
        task.wait(0.3)
    end
    
    table.sort(availableServers, function(a, b) return a.ping < b.ping end)
    print("🏆 Found " .. #availableServers .. " fallback servers")
    return availableServers
end

local function ultraSafeTeleport(server)
    print("🔍 Double-checking server " .. server.id .. " before teleport...")
    
    local currentServerData = fetchAndVerifyServer(server.id)
    if not currentServerData then
        print("❌ Server not found")
        return false
    end
    
    if currentServerData.playing > currentServerData.maxPlayers - 1 then
        print("❌ Server full: " .. currentServerData.playing .. "/" .. currentServerData.maxPlayers)
        saveFailedServer(server.id)
        return false
    end
    
    if currentServerData.id == currentJobId then
        print("❌ This is current server, skipping")
        saveFailedServer(server.id)
        return false
    end
    
    print("✅ Server available: " .. currentServerData.playing .. "/" .. currentServerData.maxPlayers)
    notify("Teleporting", "🚀 Joining server " .. currentServerData.playing .. "/" .. currentServerData.maxPlayers .. " players", 3)
    
    local teleportFailed = false
    local failConnection = TeleportService.TeleportInitFailed:Connect(function(plr, teleportResult, errorMessage)
        if plr == player then
            teleportFailed = true
            warn("❌ Teleport Failed: " .. tostring(errorMessage))
            saveFailedServer(server.id)
            notify("Teleport Failed", "❌ " .. tostring(errorMessage), 3)
        end
    end)
    
    local success = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceID, server.id, player)
    end)
    
    task.wait(3)
    failConnection:Disconnect()
    
    if success and not teleportFailed then
        print("✅ Teleport initiated successfully!")
        notify("Success!", "✅ Joining new server...", 3)
        return true
    else
        saveFailedServer(server.id)
        return false
    end
end

-- 🔄 Server Hop Functions
local function AutoServerHop()
    if isHopping then
        print("⚠️ Already server hopping... Current JobId: " .. currentJobId)
        return
    end
    
    isHopping = true
    hopAttempts = hopAttempts + 1
    
    print("🔄 Starting server hop (attempt " .. hopAttempts .. ") Current JobId: " .. currentJobId)
    notify("Server Hop", "🔄 Server hopping... (attempt " .. hopAttempts .. ")", 3)
    
    local safestServers = findSafestServers()
    
    -- Try safe servers first
    if #safestServers > 0 then
        for attempt = 1, math.min(CONFIG.MAX_SERVER_ATTEMPTS, #safestServers) do
            local server = safestServers[attempt]
            print("🎯 Trying safe server " .. attempt .. ": " .. server.id)
            if ultraSafeTeleport(server) then
                isHopping = false
                return true
            end
            task.wait(CONFIG.RECHECK_DELAY)
        end
    end
    
    -- Fallback to available servers
    print("❌ No safe servers found, trying fallback")
    local availableServers = findAvailableServers()
    
    if #availableServers > 0 then
        for attempt = 1, math.min(CONFIG.MAX_SERVER_ATTEMPTS, #availableServers) do
            local server = availableServers[attempt]
            if ultraSafeTeleport(server) then
                isHopping = false
                return true
            end
            task.wait(CONFIG.RECHECK_DELAY)
        end
    end
    
    -- Last resort: Random teleport
    print("🚨 No servers found, using random teleport")
    notify("Last Resort", "🚨 Using random teleport", 3)
    pcall(function() TeleportService:Teleport(PlaceID, player) end)
    
    isHopping = false
    return false
end

-- 💎 Diamond Collection Functions
local function collectDiamonds()
    local diamondCount = 0
    for _, diamond in pairs(workspace.Items:GetChildren()) do
        if diamond.Name == "Diamond" then
            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestTakeDiamonds"):FireServer(diamond)
                diamondCount = diamondCount + 1
            end)
            task.wait(0.05)
        end
    end
    
    if diamondCount > 0 and CONFIG.SHOW_LOGS then
        print("💎 Collected diamonds: " .. diamondCount)
    end
    return diamondCount
end

local function checkAndCollectDiamondsBeforeHop()
    local player = Players.LocalPlayer
    local name = player.Name
    
    -- Check if player is dead
    local isDead = false
    for _, v in pairs(workspace.Characters:GetChildren()) do
        if string.find(v.Name, name) then
            isDead = true
            break
        end
    end
    
    if isDead then
        print("Player is dead")
        saveFailedServer(currentJobId)
        return false
    end
    
    -- Collect diamonds if alive
    for retry = 1, 3 do
        local diamondCount = 0
        for _, diamond in pairs(workspace.Items:GetChildren()) do
            if diamond.Name == "Diamond" then diamondCount = diamondCount + 1 end
        end
        
        if diamondCount > 0 then
            print("💎 Found " .. diamondCount .. " diamonds, collecting... (attempt " .. retry .. "/3)")
            collectDiamonds()
            task.wait(2)
        else
            print("✅ No diamonds left in server")
            break
        end
    end
    
    return true
end

-- 🎁 Chest Functions
local function teleportToChest(chest)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and chest:FindFirstChild("Main") then
        return pcall(function()
            player.Character.HumanoidRootPart.CFrame = chest.Main.CFrame + Vector3.new(0, 5, 0)
        end)
    end
    return false
end

local function openAllChestsAndCollect()
    if not _G.FarmChest then return 0 end
    
    local chestCount, successCount, alreadyOpenedCount = 0, 0, 0
    
    for _, v in pairs(workspace.Items:GetChildren()) do 
        if not _G.FarmChest then break end
        
        if string.find(v.Name, "Chest") and not string.find(v.Name, "Snow") and not string.find(v.Name, "Alien") then 
            chestCount = chestCount + 1
            
            if v:FindFirstChild("Main") and not v:FindFirstChild("IceBlock") then
                if v.Main:FindFirstChild("ProximityAttachment") then
                    local proximityInteraction = v.Main.ProximityAttachment:FindFirstChild("ProximityInteraction")
                    if proximityInteraction then
                        pcall(function()
                            if CONFIG.USE_TELEPORT then
                                teleportToChest(v)
                                task.wait(0.2)
                            end
                            fireproximityprompt(proximityInteraction)
                            successCount = successCount + 1
                            
                            if not CONFIG.FAST_MODE then
                                task.wait(0.5)
                                collectDiamonds()
                            end
                        end)
                    end
                else
                    alreadyOpenedCount = alreadyOpenedCount + 1
                end
            end
            task.wait(0.1)
        end
    end
    
    if CONFIG.SHOW_LOGS then
        print("📊 Found: " .. chestCount .. " | Opened: " .. successCount .. " | Already open: " .. alreadyOpenedCount)
        notify("Chest Status", "Found: " .. chestCount .. " | Opened: " .. successCount, 3)
    end
    
    -- Check if no chests or all opened
    if chestCount == 0 or (successCount == 0 and alreadyOpenedCount == chestCount) then
        local message = chestCount == 0 and "No chests found" or "All chests opened"
        print("🔄 " .. message .. ", checking diamonds before server hop")
        notify("Server Hop", message .. ", switching servers", 3)
        AutoServerHop()
        _G.FarmChest = false
        return 0
    end
    
    -- Collect diamonds in fast mode
    if CONFIG.FAST_MODE and successCount > 0 then
        task.wait(1)
        collectDiamonds()
    end
    
    return successCount
end

local function farmLoop()
    local cycleCount = 0
    
    while _G.FarmChest do
        cycleCount = cycleCount + 1
        local startTime = tick()
        
        if CONFIG.SHOW_LOGS then
            print("🚀 Starting round " .. cycleCount .. "/" .. CONFIG.MAX_CYCLES)
        end
        notify("Farm Round", "Round " .. cycleCount .. "/" .. CONFIG.MAX_CYCLES, 5)
        
        local chestsOpened = openAllChestsAndCollect()
        if chestsOpened == 0 then break end
        
        local cycleTime = math.floor((tick() - startTime) * 100) / 100
        if CONFIG.SHOW_LOGS then
            print("⏱️ Round " .. cycleCount .. " completed in " .. cycleTime .. " seconds")
        end
        
        -- Check max cycles
        if cycleCount >= CONFIG.MAX_CYCLES then
            print("🔄 Max " .. CONFIG.MAX_CYCLES .. " rounds completed, checking diamonds before server hop")
            notify("Max Rounds", "Max rounds completed, switching servers", 3)
            AutoServerHop()
            _G.FarmChest = false
            break
        end
        
        if _G.FarmChest then
            task.wait(1)
        end
    end
    
    if CONFIG.SHOW_LOGS then
        print("🛑 Farm stopped (total " .. cycleCount .. " rounds)")
        notify("Farm Complete", "🛑 Farm stopped (" .. cycleCount .. " rounds)", 5)
    end
end

-- 🕐 Timer Functions
local function getRemainingTime()
    local elapsedTime = tick() - startTime
    return math.max(0, TIMER_SECONDS - elapsedTime)
end

local function showStatus()
    local remaining = getRemainingTime()
    local minutes = math.floor(remaining / 60)
    local seconds = math.floor(remaining % 60)
    
    if remaining > 0 then
        print("⏰ Time remaining: " .. minutes .. ":" .. string.format("%02d", seconds))
    else
        print("🎯 Time to server hop!")
    end
end

local function startAutoHopTimer()
    print("🚀 Starting auto server hop system. Current JobId: " .. currentJobId)
    notify("Auto Hop Started", "⏱️ Server hop every " .. CONFIG.TIMER_MINUTES .. " minute(s)", 5)
    
    spawn(function()
        while _G.AutoHopEnabled do
            local remaining = getRemainingTime()
            
            if remaining > 0 and math.floor(remaining) % 10 == 0 then
                showStatus()
            end
            
            if remaining <= 10 and remaining > 0 then
                if remaining <= 3 then
                    notify("Countdown", "⏰ " .. math.floor(remaining) .. " seconds", 1)
                end
            end
            
            if remaining <= 0 then
                if not isHopping then
                    print("🎯 Time to server hop!")
                    AutoServerHop()
                    startTime = tick()
                end
                
                task.wait(3)
                
                if game.JobId == currentJobId then
                    print("⚠️ Still in same server, retrying in 5 seconds...")
                    isHopping = false
                    task.wait(5)
                else
                    print("✅ Server hop successful! New JobId: " .. game.JobId)
                    currentJobId = game.JobId
                    startTime = tick()
                end
            end
            
            task.wait(1)
        end
    end)
end

-- 🎮 Death Detection and Auto Hop
local function onCharacterDied()
    print("Character died! Blacklisting server and hopping. Current JobId: " .. currentJobId)
    saveFailedServer(currentJobId)
    AutoServerHop()
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then onCharacterDied() end
    end)
    humanoid.Died:Connect(onCharacterDied)
end

-- 🖥️ Rendering Toggle
local function setupRenderToggle()
    local isRenderingEnabled = true
    
    UserInputService.InputBegan:Connect(function(input, isProcessed)
        if not isProcessed and input.KeyCode == Enum.KeyCode.H then
            isRenderingEnabled = not isRenderingEnabled
            RunService:Set3dRenderingEnabled(isRenderingEnabled)
        end
    end)
end

-- 📱 UI Creation
local function createCreditUI()
    local Credit = Instance.new("ScreenGui")
    local CreditFrame = Instance.new("Frame")
    local CreditText = Instance.new("TextLabel")
    local Username = Instance.new("TextLabel")
    local DiamondAmout = Instance.new("TextLabel")
    local TimeServer = Instance.new("TextLabel")
    local RejoinServerButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local DiscordLink = Instance.new("ImageButton")
    local TextDiscordLink = Instance.new("TextLabel")

    -- Remove existing Credit UI
    local existingCredit = player.PlayerGui:FindFirstChild("Credit")
    if existingCredit then existingCredit:Destroy() end

    Credit.Name = "Credit"
    Credit.Parent = player:WaitForChild("PlayerGui")
    Credit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    CreditFrame.Name = "CreditFrame"
    CreditFrame.Parent = Credit
    CreditFrame.BackgroundTransparency = 1
    CreditFrame.Size = UDim2.new(1, 0, 1, 0)

    CreditText.Name = "CreditText"
    CreditText.Parent = CreditFrame
    CreditText.AnchorPoint = Vector2.new(0.5, 0.5)
    CreditText.BackgroundTransparency = 1
    CreditText.Position = UDim2.new(0.5, 0, 0.5, 0)
    CreditText.Size = UDim2.new(0, 200, 0, 50)
    CreditText.Font = Enum.Font.Arcade
    CreditText.Text = "!:Vector Hub Farm Diamond:!"
    CreditText.TextColor3 = Color3.fromRGB(6, 6, 255)
    CreditText.TextSize = 44
    CreditText.TextStrokeTransparency = 0.2

    Username.Name = "Username"
    Username.Parent = CreditText
    Username.AnchorPoint = Vector2.new(0.5, 0.5)
    Username.BackgroundTransparency = 1
    Username.Position = UDim2.new(0.5, 0, 1.12, 0)
    Username.Size = UDim2.new(0, 200, 0, 50)
    Username.Font = Enum.Font.Arcade
    Username.Text = "Username: " .. player.Name
    Username.TextColor3 = Color3.fromRGB(255, 4, 4)
    Username.TextSize = 30
    Username.TextStrokeTransparency = 0.2

    DiamondAmout.Name = "DiamondAmout"
    DiamondAmout.Parent = CreditText
    DiamondAmout.AnchorPoint = Vector2.new(0.5, 0.5)
    DiamondAmout.BackgroundTransparency = 1
    DiamondAmout.Position = UDim2.new(0.5, 0, 1.68, 0)
    DiamondAmout.Size = UDim2.new(0, 200, 0, 50)
    DiamondAmout.Font = Enum.Font.Arcade
    DiamondAmout.TextColor3 = Color3.fromRGB(0, 229, 255)
    DiamondAmout.TextSize = 30
    DiamondAmout.TextStrokeTransparency = 0.2

    -- Update diamond count
    local function updateDiamondCount()
        local interface = player.PlayerGui:FindFirstChild("Interface")
        local diamondCount = interface and interface:FindFirstChild("DiamondCount")
        local countLabel = diamondCount and diamondCount:FindFirstChild("Count")
        
        if countLabel then
            DiamondAmout.Text = "Diamond: " .. countLabel.Text
            countLabel:GetPropertyChangedSignal("Text"):Connect(function()
                DiamondAmout.Text = "Diamond: " .. countLabel.Text
            end)
        else
            DiamondAmout.Text = "Diamond: Loading..."
        end
    end
    
    task.spawn(updateDiamondCount)

    TimeServer.Name = "TimeServer"
    TimeServer.Parent = CreditText
    TimeServer.AnchorPoint = Vector2.new(0.5, 0.5)
    TimeServer.BackgroundTransparency = 1
    TimeServer.Position = UDim2.new(0.5, 0, 2.26, 0)
    TimeServer.Size = UDim2.new(0, 200, 0, 50)
    TimeServer.Font = Enum.Font.Arcade
    TimeServer.TextColor3 = Color3.fromRGB(6, 255, 6)
    TimeServer.TextSize = 30
    TimeServer.TextStrokeTransparency = 0.2

    local function updateTime()
        local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
        local Hour = math.floor(GameTime / 3600) % 24
        local Minute = math.floor(GameTime / 60) % 60
        local Second = math.floor(GameTime) % 60
        TimeServer.Text = "Hour: " .. Hour .. " Minute: " .. Minute .. " Second: " .. Second
    end

    spawn(function()
        while task.wait(1) do
            pcall(updateTime)
        end
    end)

    RejoinServerButton.Name = "RejoinServerButton"
    RejoinServerButton.Parent = CreditText
    RejoinServerButton.AnchorPoint = Vector2.new(0.5, 0.5)
    RejoinServerButton.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
    RejoinServerButton.BackgroundTransparency = 0.3
    RejoinServerButton.BorderSizePixel = 5
    RejoinServerButton.Position = UDim2.new(0.5, 0, 3.26, 0)
    RejoinServerButton.Size = UDim2.new(0, 200, 0, 50)
    RejoinServerButton.Font = Enum.Font.Arcade
    RejoinServerButton.Text = "RejoinServer"
    RejoinServerButton.TextSize = 26
    RejoinServerButton.TextWrapped = true

    UICorner.Parent = RejoinServerButton

    RejoinServerButton.MouseButton1Click:Connect(function()
        TeleportService:Teleport(PlaceID, player)
        notify("Rejoining", "Rejoining server...", 5)
    end)

    DiscordLink.Name = "DiscordLink"
    DiscordLink.Parent = CreditText
    DiscordLink.AnchorPoint = Vector2.new(0.5, 0.5)
    DiscordLink.BackgroundTransparency = 1
    DiscordLink.Position = UDim2.new(0.5, 0, 4.44, 0)
    DiscordLink.Size = UDim2.new(0, 66, 0, 48)
    DiscordLink.Image = "rbxassetid://83190364603693"

    DiscordLink.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/977JQXX82w")
        notify("Copied!", "Discord link copied to clipboard!", 5)
    end)

    TextDiscordLink.Name = "TextDiscordLink"
    TextDiscordLink.Parent = DiscordLink
    TextDiscordLink.AnchorPoint = Vector2.new(0.5, 0.5)
    TextDiscordLink.BackgroundTransparency = 1
    TextDiscordLink.Position = UDim2.new(0.5, 0, 1.15, 0)
    TextDiscordLink.Size = UDim2.new(0, 200, 0, 50)
    TextDiscordLink.Font = Enum.Font.Arcade
    TextDiscordLink.Text = "JoinDiscordForNews!"
    TextDiscordLink.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextDiscordLink.TextSize = 25
end

local function createWhitescreenUI()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextButton = Instance.new("TextButton")
    local TextLabel = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    local TextButton_2 = Instance.new("TextButton")

    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Parent = ScreenGui
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.new(0.36, 0, 0.31, 0)
    Frame.Size = UDim2.new(0, 71, 0, 21)
    Frame.Draggable = true
    Frame.Active = true

    TextButton.Parent = Frame
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BackgroundTransparency = 0.9
    TextButton.Position = UDim2.new(0, 0, 1, 0)
    TextButton.Size = UDim2.new(0, 71, 0, 38)
    TextButton.Font = Enum.Font.SourceSansBold
    TextButton.Text = "Whitescreen"
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 14

    local is3DRenderingEnabled = true
    TextButton.MouseButton1Click:Connect(function()
        is3DRenderingEnabled = not is3DRenderingEnabled
        RunService:Set3dRenderingEnabled(is3DRenderingEnabled)
    end)

    TextLabel.Parent = TextButton
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.04, 0, 0.66, 0)
    TextLabel.Size = UDim2.new(0, 64, 0, 13)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "H or Click"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14

    UICorner.Parent = TextButton

    TextButton_2.Parent = Frame
    TextButton_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_2.BackgroundTransparency = 0.9
    TextButton_2.Position = UDim2.new(0.15, 0, 0.1, 0)
    TextButton_2.Size = UDim2.new(0, 47, 0, 18)
    TextButton_2.Font = Enum.Font.SourceSans
    TextButton_2.Text = "Hide"
    TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_2.TextSize = 14

    TextButton_2.MouseButton1Click:Connect(function()
        TextButton.Visible = not TextButton.Visible
    end)
end

-- 🏠 Lobby Functions
local function handleLobbyLogic()
    spawn(function()
        while _G.FarmChest do
            task.wait()
            
            local teleporters = {workspace.Teleporter1, workspace.Teleporter2, workspace.Teleporter3}
            
            for _, teleporter in pairs(teleporters) do
                if teleporter and teleporter.BillboardHolder.BillboardGui.Players.Text == "0/5" then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = teleporter.EnterPart.CFrame
                        
                        local args = {"Chosen", [3] = 1}
                        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TeleportEvent"):FireServer(unpack(args))
                        break
                    end
                end
            end
            
            if player.PlayerGui.Interface.LobbyCreate.Visible then
                notify("Start Lobby!", "Creating party...", 3)
                
                local partySizeButton = player.PlayerGui.Interface.LobbyCreate.ButtonList.Button1
                if partySizeButton and partySizeButton:IsA("TextButton") then
                    GuiService.SelectedObject = partySizeButton
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    task.wait(0.5)

                    if partySizeButton.BackgroundColor3 == Color3.fromRGB(255, 225, 0) then
                        local createButton = player.PlayerGui.Interface.LobbyCreate.HeaderFrame.CreateButton
                        if createButton and createButton:IsA("TextButton") then
                            GuiService.SelectedObject = createButton
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        end
                    end
                end
                task.wait(1)
            end
            
            if player.PlayerGui.TeleporterAssets.TextButton.Visible then
                break
            end
        end
    end)
end

-- 🚀 Main Initialization
local function initializeScript()
    createCreditUI()
    
    -- Setup character events
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end
    
    -- Check initial health
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health == 0 then 
            print("Detected death at script start, server hopping immediately")
            saveFailedServer(currentJobId)
            AutoServerHop()
        else
            print("Player alive - HP: " .. player.Character.Humanoid.Health)
        end
    else
        print("No character at start, server hopping")
        saveFailedServer(currentJobId)
        AutoServerHop()
    end
    
    -- Health monitoring loop
    spawn(function()
        while true do
            task.wait(1)
            
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local health = player.Character.Humanoid.Health
                if health == 0 then
                    print("Loop detected death, server hopping")
                    saveFailedServer(currentJobId)
                    AutoServerHop()
                    break
                end
            else
                print("Loop: No character, server hopping")
                saveFailedServer(currentJobId)
                AutoServerHop()
            end
        end
    end)
    
    -- Auto farm monitoring
    spawn(function()
        while true do
            if not _G.FarmChest then
                AutoServerHop()
            end
            task.wait(0.1)
        end
    end)
    
    -- Start auto hop timer
    _G.AutoHopEnabled = true
    startAutoHopTimer()
end

-- 🎮 Place-specific Logic
if PlaceID == 79546208627805 then 
    notify("Place", "Lobby", 3)
    handleLobbyLogic()
    
elseif PlaceID == 126509999114328 then
    notify("Place", "In-game", 3)
    
    setupRenderToggle()
    createWhitescreenUI()
    
    -- Initialize farm settings
    _G.FarmChest = true
    CONFIG.FAST_MODE = true
    CONFIG.SHOW_LOGS = true
    CONFIG.USE_TELEPORT = true
    CONFIG.MAX_CYCLES = 4
    
    -- Start farming
    spawn(function()
        while true do
            if _G.FarmChest then
                farmLoop()
            end
            task.wait(0.1)
        end
    end)
    
    -- Auto-toggle rendering
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.H, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.H, false, game)
end

-- 🔧 Export Functions
getgenv().startAutoHop = function()
    _G.AutoHopEnabled = true
    startAutoHopTimer()
end

getgenv().stopAutoHop = function()
    print("🛑 Stopping Auto Server Hop")
    notify("Stopped", "🛑 Auto Hop stopped", 3)
    _G.AutoHopEnabled = false
end

getgenv().getRemainingTime = getRemainingTime
getgenv().showHopStatus = showStatus
getgenv().runOnce = function()
    if CONFIG.SHOW_LOGS then
        print("🎯 Opening chests and collecting diamonds once")
    end
    openAllChestsAndCollect()
end

-- 🚀 Initialize
initializeScript()

-- Load additional script
loadstring(game:HttpGet('https://raw.githubusercontent.com/7878wqz/sc1/refs/heads/main/h'))()
