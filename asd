_G.FarmChest = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

if game.CoreGui:FindFirstChild("ScreenGui") then game.CoreGui:FindFirstChild("ScreenGui"):Destroy() end
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local H_KEY_CODE = Enum.KeyCode.H
local isRenderingEnabled = true

-- ⚙️ การตั้งค่าระบบป้องกันเซิฟเต็ม
local PlaceID = game.PlaceId
local MAX_PLAYERS_SAFE = 5
local MIN_PLAYERS = 0
local MAX_PAGES = 3
local MAX_SERVER_ATTEMPTS = 3  
local TELEPORT_DELAY = 0
local RECHECK_DELAY = 0
local SERVER_FILE = "safe_servers.json"

UserInputService.InputBegan:Connect(function(input, isProcessed)
	if not isProcessed and input.KeyCode == H_KEY_CODE then
		isRenderingEnabled = not isRenderingEnabled
		RunService:Set3dRenderingEnabled(isRenderingEnabled)
	end
end)

-- Gui to Lua
-- Version: 3.2

-- Instances:

local Credit = Instance.new("ScreenGui")
local Creditframe = Instance.new("Frame")
local madebyvec = Instance.new("TextLabel")
local Logo = Instance.new("ImageLabel")
local Discord = Instance.new("ImageButton")
local Othertext = Instance.new("TextLabel")
local Clickme = Instance.new("TextLabel")
local ClickmeTh = Instance.new("TextLabel")
local OthertextTH = Instance.new("TextLabel")
local Coplinkdiscord = Instance.new("TextButton")

--Properties:

local Ui =  game:GetService("CoreGui"):FindFirstChild("Credit")
if Ui then
    Ui:Destroy()
end
Credit.Name = "Credit"
Credit.Parent = game.CoreGui
Credit.Enabled = true
Credit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Creditframe.Name = "Creditframe"
Creditframe.Parent = Credit
Creditframe.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
Creditframe.BackgroundTransparency = 0.3
Creditframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
Creditframe.BorderSizePixel = 0
Creditframe.Size = UDim2.new(2, 0, 2, 0) -- เต็มจอ
Creditframe.AnchorPoint = Vector2.new(0.5, 0.5)
Creditframe.Position = UDim2.new(0.5, 0, 0.5, 0) -- อยู่กึ่งกลาง

madebyvec.Name = "madebyvec"
madebyvec.Parent = Creditframe
madebyvec.AnchorPoint = Vector2.new(0.5, 0.5)
madebyvec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
madebyvec.BackgroundTransparency = 1.000
madebyvec.BorderColor3 = Color3.fromRGB(0, 0, 0)
madebyvec.BorderSizePixel = 0
madebyvec.Position = UDim2.new(0.5, 0, 0.400000006, 0) -- อยู่เหนือกึ่งกลาง
madebyvec.Size = UDim2.new(0, 200, 0, 50)
madebyvec.Font = Enum.Font.SourceSansBold
madebyvec.Text = "Made by Vector Hub"
madebyvec.TextColor3 = Color3.fromRGB(0, 0, 0)
madebyvec.TextSize = 100.000
madebyvec.TextStrokeColor3 = Color3.fromRGB(0, 26, 255)
madebyvec.TextStrokeTransparency = 0.000

Logo.Name = "Logo"
Logo.Parent = Creditframe
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1.000
Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0, 1150, 0, 350) -- อยู่กึ่งกล
Logo.Size = UDim2.new(0, 900, 0, 900) -- ขนาดที่เหมาะสมกับจอ
Logo.ZIndex = 0
Logo.Image = "rbxassetid://93896063585601"
Logo.ImageColor3 = Color3.fromRGB(0, 102, 255)
Logo.ImageTransparency = 0.300

Discord.Name = "Discord"
Discord.Parent = Creditframe
Discord.AnchorPoint = Vector2.new(0.5, 0.5)
Discord.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Discord.BackgroundTransparency = 1.000
Discord.BorderColor3 = Color3.fromRGB(0, 0, 0)
Discord.BorderSizePixel = 0
Discord.Position = UDim2.new(0.5, 0, 0.500000715, 0) 
Discord.Size = UDim2.new(0, 115, 0, 104)
Discord.Image = "rbxassetid://134478721013696"

Othertext.Name = "Othertext"
Othertext.Parent = Creditframe
Othertext.AnchorPoint = Vector2.new(0.5, 0.5)
Othertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Othertext.BackgroundTransparency = 1.000
Othertext.BorderColor3 = Color3.fromRGB(0, 0, 0)
Othertext.BorderSizePixel = 0
Othertext.Position = UDim2.new(0.5, 0, 0.440000027, 0) -- อยู่ใต้ Logo
Othertext.Size = UDim2.new(0, 400, 0, 37)
Othertext.Font = Enum.Font.SourceSans
Othertext.Text = "Join My Discord For News Update / Report Bug,RequestGame"
Othertext.TextColor3 = Color3.fromRGB(0, 0, 0)
Othertext.TextSize = 30.000
Othertext.TextStrokeColor3 = Color3.fromRGB(0, 26, 255)
Othertext.TextStrokeTransparency = 0.000

Clickme.Name = "Clickme"
Clickme.Parent = Creditframe
Clickme.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Clickme.BackgroundTransparency = 1.000
Clickme.BorderColor3 = Color3.fromRGB(0, 0, 0)
Clickme.BorderSizePixel = 0
Clickme.Position = UDim2.new(0.399998873, 0, 0.490000069, 0) 
Clickme.Size = UDim2.new(0, 300, 0, 50)
Clickme.Font = Enum.Font.SourceSans
Clickme.Text = "Click Logo Discord For Copy Link >>"
Clickme.TextColor3 = Color3.fromRGB(0, 0, 0)
Clickme.TextSize = 19.000
Clickme.TextStrokeColor3 = Color3.fromRGB(0, 26, 255)
Clickme.TextStrokeTransparency = 0.000

ClickmeTh.Name = "ClickmeTh"
ClickmeTh.Parent = Creditframe
ClickmeTh.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClickmeTh.BackgroundTransparency = 1.000
ClickmeTh.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClickmeTh.BorderSizePixel = 0
ClickmeTh.Position = UDim2.new(0.5, 0, 0.490000069, 0)
ClickmeTh.Size = UDim2.new(0, 300, 0, 50)
ClickmeTh.Font = Enum.Font.SourceSans
ClickmeTh.Text = "<< กดโลโก้เพื่อก็อปปี้ลิ้งดิสคอร์ด"
ClickmeTh.TextColor3 = Color3.fromRGB(0, 0, 0)
ClickmeTh.TextSize = 19.000
ClickmeTh.TextStrokeColor3 = Color3.fromRGB(0, 26, 255)
ClickmeTh.TextStrokeTransparency = 0.000

OthertextTH.Name = "OthertextTH"
OthertextTH.Parent = Creditframe
OthertextTH.AnchorPoint = Vector2.new(0.5, 0.5)
OthertextTH.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OthertextTH.BackgroundTransparency = 1.000
OthertextTH.BorderColor3 = Color3.fromRGB(0, 0, 0)
OthertextTH.BorderSizePixel = 0
OthertextTH.Position = UDim2.new(0.5, 0, 0.460000008, 0) -- อยู่ใต้ Othertext
OthertextTH.Size = UDim2.new(0, 400, 0, 37)
OthertextTH.Font = Enum.Font.SourceSans
OthertextTH.Text = "เข้าดิสคอร์ดเพื่อรับข่าวสาร หรือรีพอร์ตบัค หรือเสนอเกม"
OthertextTH.TextColor3 = Color3.fromRGB(0, 0, 0)
OthertextTH.TextSize = 30.000
OthertextTH.TextStrokeColor3 = Color3.fromRGB(0, 26, 255)
OthertextTH.TextStrokeTransparency = 0.000

Coplinkdiscord.Name = "Coplinkdiscord"
Coplinkdiscord.Parent = Creditframe
Coplinkdiscord.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Coplinkdiscord.BackgroundTransparency = 0.9
Coplinkdiscord.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- พื้นหลังมองเห็น
Coplinkdiscord.BorderColor3 = Color3.fromRGB(0, 0, 0)
Coplinkdiscord.BorderSizePixel = 0
Coplinkdiscord.Position = UDim2.new(0.5, -57, 0.47, 0) -- อยู่กึ่งกลางแนวนอน
Coplinkdiscord.Size = UDim2.new(0, 114, 0, 86)
Coplinkdiscord.Font = Enum.Font.SourceSans
Coplinkdiscord.Text = "CLICKME!!"
Coplinkdiscord.TextColor3 = Color3.fromRGB(255, 0, 0)
Coplinkdiscord.TextSize = 14.000
Coplinkdiscord.TextStrokeTransparency = 0.000

-- การจัดการคลิก
local UserInputService = game:GetService("UserInputService")

Coplinkdiscord.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/977JQXX82w")
    local player = game.Players.LocalPlayer
    if player then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Copied!",
            Text = "Discord link copied to clipboard!",
            Duration = 5
        })
    end
    print("Copied Discord link to clipboard") -- Debug
end)

-- การหมุน Logo ตามเข็มนาฬิกาแบบต่อเนื่อง
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local rotation = 0
local rotationSpeed = 0.4 -- ความเร็วการหมุน (องศาต่อเฟรม)

local function updateRotation()
    rotation = rotation + rotationSpeed
    Logo.Rotation = rotation % 360 -- ใช้ modulo เพื่อให้หมุนวนที่ 0-360 องศา
end

RunService.RenderStepped:Connect(updateRotation) -- หมุนทุกเฟรม

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local TextButton_2 = Instance.new("TextButton")

--Properties:
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 1.000
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0.359884858, 0, 0.3125, 0)
Frame.Size = UDim2.new(0, 71, 0, 21)

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BackgroundTransparency = 0.900
TextButton.BorderColor3 = Color3.fromRGB(27, 42, 53)
TextButton.Position = UDim2.new(-0.00486259907, 0, 0.992753386, 0)
TextButton.Size = UDim2.new(0, 71, 0, 38)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "Whitescreen"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 14.000
local is3DRenderingEnabled = true

TextButton.MouseButton1Click:Connect(function()
	is3DRenderingEnabled = not is3DRenderingEnabled
	game:GetService("RunService"):Set3dRenderingEnabled(is3DRenderingEnabled)
end)

TextLabel.Parent = TextButton
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(0.0422539562, 0, 0.657894373, 0)
TextLabel.Size = UDim2.new(0, 64, 0, 13)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "H or Click"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 14.000

UICorner.Parent = TextButton
UICorner_2.Parent = Frame

TextButton_2.Parent = Frame
TextButton_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.BackgroundTransparency = 0.900
TextButton_2.Position = UDim2.new(0.154929116, 0, 0.0952380896, 0)
TextButton_2.Size = UDim2.new(0, 47, 0, 18)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "Hide"
TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_2.TextSize = 14.000
TextButton_2.MouseButton1Click:Connect(function()
	if Frame.Visible then
		TextButton.Visible = not TextButton.Visible
	else
		TextButton.Visible = not TextButton.Visible
	end
end)

local function VFHJNK_fake_script() -- Frame.LocalScript
	local script = Instance.new('LocalScript', Frame)
	script.Parent.Draggable = true
	script.Parent.Active = true
end
coroutine.wrap(VFHJNK_fake_script)()

-- 📢 ฟังก์ชันแจ้งเตือน
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

-- 🗂️ ระบบจัดการไฟล์
local function loadFailedServers()
    if isfile and isfile("failed_servers.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("failed_servers.json"))
        end)
        if success and data then
            return data
        end
    end
    return {}
end

local function saveFailedServer(serverId)
    local failed = loadFailedServers()
    table.insert(failed, serverId)
    
    -- เก็บแค่ 30 เซิฟล่าสุด
    if #failed > 30 then
        table.remove(failed, 1)
    end
    
    if writefile then
        pcall(function()
            writefile("failed_servers.json", HttpService:JSONEncode(failed))
        end)
    end
end

local function isServerFailed(serverId)
    local failed = loadFailedServers()
    for _, id in pairs(failed) do
        if id == serverId then
            return true
        end
    end
    return false
end

-- 🌐 ดึงข้อมูลเซิฟและเช็คแบบ Real-time
local function fetchAndVerifyServer(serverId)
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.id == serverId then
                return server
            end
        end
    end
    
    return nil
end

-- 🔍 ค้นหาเซิฟแบบรอบคอบ
local function findSafestServers()
    print("🔍 กำลังค้นหาเซิฟที่ปลอดภัยที่สุด...")
    notify("Deep Search", "🔍 ค้นหาเซิฟแบบละเอียด...", 3)
    
    local safestServers = {}
    local cursor = ""
    local pagesSearched = 0
    
    while pagesSearched < MAX_PAGES and #safestServers < 20 do
        pagesSearched = pagesSearched + 1
        print("📄 ค้นหาหน้าที่ " .. pagesSearched .. "/" .. MAX_PAGES)
        
        local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor and cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        
        local success, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if not success or not data or not data.data then
            break
        end
        
        for _, server in pairs(data.data) do
            local isSuperSafe = (
                server.id ~= game.JobId and
                server.playing >= MIN_PLAYERS and
                server.playing <= MAX_PLAYERS_SAFE and
                server.maxPlayers >= 5 and
                not isServerFailed(server.id)
            )
            
            if isSuperSafe then
                table.insert(safestServers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers,
                    ping = server.ping or 999,
                    safety_score = (MAX_PLAYERS_SAFE - server.playing)
                })
                
                print("✅ เซิฟปลอดภัย: " .. server.playing .. "/" .. server.maxPlayers .. 
                      " คน (Safety: " .. (MAX_PLAYERS_SAFE - server.playing) .. ")")
            end
        end
        
        cursor = data.nextPageCursor or ""
        if cursor == "" or cursor == "null" then
            break
        end
        
        task.wait(0.3)
    end
    
    -- จัดเรียง: ความปลอดภัย -> คนน้อย -> ping ต่ำ
    table.sort(safestServers, function(a, b)
        if a.safety_score ~= b.safety_score then
            return a.safety_score > b.safety_score
        elseif a.playing ~= b.playing then
            return a.playing < b.playing
        else
            return a.ping < b.ping
        end
    end)
    
    print("🏆 พบเซิฟปลอดภัย " .. #safestServers .. " เซิฟ")
    return safestServers
end

-- 🚀 Teleport แบบ Double-Check
local function ultraSafeTeleport(server)
    print("🔍 Double-checking เซิฟ " .. server.id .. " ก่อน Teleport...")
    
    local currentServerData = fetchAndVerifyServer(server.id)
    
    if not currentServerData then
        print("❌ ไม่พบเซิฟนี้แล้ว")
        return false
    end
    
    if currentServerData.playing > MAX_PLAYERS_SAFE then
        print("❌ เซิฟเต็มแล้ว: " .. currentServerData.playing .. "/" .. currentServerData.maxPlayers)
        saveFailedServer(server.id)
        return false
    end
    
    print("✅ เซิฟยังว่าง: " .. currentServerData.playing .. "/" .. currentServerData.maxPlayers)
    print("🚀 กำลัง Teleport...")
    
    notify("Teleporting", "🚀 กำลังเข้าเซิฟ " .. currentServerData.playing .. "/" .. currentServerData.maxPlayers .. " คน", 3)
    
    local teleportFailed = false
    local failConnection = TeleportService.TeleportInitFailed:Connect(function(plr, teleportResult, errorMessage, placeId, teleportOptions)
        if plr == player then
            teleportFailed = true
            warn("❌ Teleport Failed: " .. tostring(errorMessage))
            saveFailedServer(server.id)
            
            if string.find(tostring(errorMessage):lower(), "full") then
                notify("Server Full", "❌ เซิฟเต็มแล้ว ลองเซิฟถัดไป", 2)
            else
                notify("Teleport Failed", "❌ " .. tostring(errorMessage), 3)
            end
        end
    end)
    
    local success, errorMsg = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceID, server.id, player)
    end)
    
    task.wait(2)
    
    failConnection:Disconnect()
    
    if success and not teleportFailed then
        print("✅ Teleport เริ่มสำเร็จ!")
        notify("Success!", "✅ กำลังเข้าเซิฟใหม่...", 3)
        return true
    else
        print("❌ Teleport ล้มเหลว: " .. tostring(errorMsg))
        saveFailedServer(server.id)
        return false
    end
end

local function checkAndCollectDiamondsBeforeHop()
    local diamondCount = 0
    local maxRetries = 3
    local player = game.Players.LocalPlayer
    local name = player.Name

    -- ตรวจสอบว่าผู้เล่นตายหรือไม่โดยเช็คใน workspace.Characters
    local isDead = false
    for _, v in pairs(workspace.Characters:GetChildren()) do
        if string.find(v.Name, name) then
            isDead = true
            break
        end
    end

    if isDead then
        print("ตาย")
        saveFailedServer(game.JobId) -- Blacklist เซิร์ฟเวอร์ปัจจุบัน
        return false -- ไม่เรียก antiFullServerHop() ในนี้ ปล่อยให้ฟังก์ชันหลักจัดการ
    else
        print("มีชีวิต")
    end

    -- ดำเนินการเก็บ Diamond ถ้ายังมีชีวิต
    for retry = 1, maxRetries do
        diamondCount = 0
        
        for _, diamond in pairs(workspace.Items:GetChildren()) do
            if diamond.Name == "Diamond" then
                diamondCount = diamondCount + 1
            end
        end
        
        if diamondCount > 0 then
            if _G.ShowLogs then
                print("💎 พบ Diamond " .. diamondCount .. " อัน กำลังเก็บ... (ครั้งที่ " .. retry .. "/" .. maxRetries .. ")")
            end
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://16129235054",
                Title = "Diamond Found!",
                Text = "พบ Diamond " .. diamondCount .. " อัน กำลังเก็บ...",
                Duration = 3
            })
            
            local collectedCount = collectDiamonds() or 0 -- ตรวจสอบ nil
            if _G.ShowLogs then
                print("✅ เก็บ Diamond ได้ " .. collectedCount .. " อัน")
            end
            
            task.wait(2)
        else
            if _G.ShowLogs then
                print("✅ ไม่มี Diamond เหลืออยู่ในเซิร์ฟเวอร์")
            end
            break
        end
    end
    
    -- ตรวจสอบ Diamond อีกครั้งก่อนย้ายเซิร์ฟ
    diamondCount = 0
    for _, diamond in pairs(workspace.Items:GetChildren()) do
        if diamond.Name == "Diamond" then
            diamondCount = diamondCount + 1
        end
    end
    
    if diamondCount > 0 then
        if _G.ShowLogs then
            warn("⚠️ ยังคงมี Diamond " .. diamondCount .. " อันเหลืออยู่")
        end
        StarterGui:SetCore("SendNotification", {
            Icon = "rbxassetid://16129235054",
            Title = "Warning!",
            Text = "⚠️ ยังมี Diamond " .. diamondCount .. " อันเหลือ",
            Duration = 5
        })
    else
        if _G.ShowLogs then
            print("✅ ตรวจสอบแล้ว ไม่มี Diamond เหลือ")
        end
        StarterGui:SetCore("SendNotification", {
            Icon = "rbxassetid://16129235054",
            Title = "Ready to Hop!",
            Text = "✅ No Diamond In Server\n✅ ไม่มี Diamond เหลือ",
            Duration = 3
        })
    end
    
    return diamondCount == 0
end
local function antiFullServerHop()
    local startTime = tick()
    print("🛡️ เริ่มระบบย้ายเซิฟป้องกันเซิฟเต็ม")
    notify("Anti-Full Hop", "🛡️ ค้นหาเซิฟที่ปลอดภัยที่สุด", 3)
    
    -- ตรวจสอบสถานะผู้เล่นและเก็บ Diamond ก่อนย้าย
    if not checkAndCollectDiamondsBeforeHop() then
        print("🔍 ตรวจพบปัญหา (เช่น ตายหรือยังมี Diamond) กำลังดำเนินการย้ายเซิร์ฟ...")
    end
    
    local safestServers = findSafestServers() or {}
    
    if #safestServers == 0 then
        print("❌ ไม่พบเซิฟปลอดภัย")
        notify("No Safe Server", "❌ ไม่พบเซิฟปลอดภัย จะลอง Teleport แบบสุ่ม", 5)
        
        pcall(function()
            TeleportService:Teleport(PlaceID, game.Players.LocalPlayer)
        end)
        return false
    end
    
    -- แสดงเซิฟที่จะลอง
    print("🏆 เซิฟปลอดภัยที่สุด 5 อันดับแรก:")
    for i = 1, math.min(5, #safestServers) do
        local server = safestServers[i]
        print("   " .. i .. ". " .. (server.playing or 0) .. "/" .. (server.maxPlayers or 0) .. 
              " คน (Safety: " .. (server.safety_score or 0) .. ", Ping: " .. (server.ping or 0) .. "ms)")
    end
    
    -- ลองเซิฟทีละเซิฟ
    for attempt = 1, math.min(MAX_SERVER_ATTEMPTS or 5, #safestServers) do
        local server = safestServers[attempt]

        StarterGui:SetCore("SendNotification", {
            Icon = "rbxassetid://16129235054",
            Title = "แจ้งเตือน!",
            Text = "🎯 Server " .. attempt .. ": " .. (server.playing or 0) .. "/" .. (server.maxPlayers or 0) .. " คน",
            Duration = 5
        })

        print("🎯 ลองเซิฟที่ " .. attempt .. ": " .. (server.playing or 0) .. "/" .. (server.maxPlayers or 0) .. " คน")
        
        local success = ultraSafeTeleport(server)
        if success then
            local totalTime = math.floor((tick() - startTime) * 100) / 100
            print("✅ ย้ายเซิฟสำเร็จใน " .. totalTime .. " วินาที!")
            return true
        end
        
        print("⏳ รอ " .. (RECHECK_DELAY or 2) .. " วินาทีแล้วลองเซิฟถัดไป...")
        task.wait(RECHECK_DELAY or 2)
    end
    
    print("🚨 ลองทุกเซิฟแล้ว ใช้วิธีสุดท้าย")
    notify("Last Resort", "🚨 ใช้ Random Teleport", 3)
    
    pcall(function()
        TeleportService:Teleport(PlaceID, game.Players.LocalPlayer)
    end)
    
    return false
end


----
-- วิธีที่ 1: ตรวจสอบ Health โดยตรง
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if player.Character and player.Character:FindFirstChild("Humanoid") then
    if player.Character.Humanoid.Health == 0 then 
        antiFullServerHop()
    else
        print("มีชีวิต - HP: " .. player.Character.Humanoid.Health)
    end
else
    antiFullServerHop()
end

-- วิธีที่ 2: ใช้ Event เพื่อตรวจสอบการตาย (แนะนำ)
local function onCharacterDied()
antiFullServerHop()
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- ตรวจสอบเมื่อ HP เปลี่ยนแปลง
    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            onCharacterDied()
        end
    end)
    
    -- หรือใช้ Event Died โดยตรง
    humanoid.Died:Connect(function()
        onCharacterDied()
    end)
end

-- เชื่อมต่อ Events
player.CharacterAdded:Connect(onCharacterAdded)

-- ตรวจสอบตัวละครปัจจุบัน (ถ้ามี)
if player.Character then
    onCharacterAdded(player.Character)
end

-- วิธีที่ 3: ตรวจสอบแบบ Loop (ไม่แนะนำ แต่ใช้ได้)
spawn(function()
    while true do
        wait(1) -- ตรวจสอบทุกวินาที
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local health = player.Character.Humanoid.Health
            
            if health == 0 then
               antiFullServerHop()
                -- เรียกฟังก์ชันย้ายเซิฟที่นี่
                break -- หยุด loop เมื่อตาย
            else
                print("มีชีวิต - HP: " .. health)
            end
        else
            antiFullServerHop()
        end
    end
end)
---

if game.PlaceId == 79546208627805 then 
    StarterGui:SetCore("SendNotification", {
        Icon = "rbxassetid://16129235054",
        Title = "Place",
        Text = "Lobby",
        Duration = 3
    })

    spawn(function()
        while task.wait() do 
            if _G.FarmChest then 
                repeat task.wait()
                    if workspace.Teleporter1.BillboardHolder.BillboardGui.Players.Text == "0/5" then 
                        player.Character.HumanoidRootPart.CFrame = workspace.Teleporter1.EnterPart.CFrame
                        local args = {
                            "Chosen",
                            [3] = 1
                        }
                        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TeleportEvent"):FireServer(unpack(args))
                    elseif workspace.Teleporter2.BillboardHolder.BillboardGui.Players.Text == "0/5" then 
                        player.Character.HumanoidRootPart.CFrame = workspace.Teleporter2.EnterPart.CFrame
                        local args = {
                            "Chosen",
                            [3] = 1
                        }
                        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TeleportEvent"):FireServer(unpack(args))
                    elseif workspace.Teleporter3.BillboardHolder.BillboardGui.Players.Text == "0/5" then 
                        player.Character.HumanoidRootPart.CFrame = workspace.Teleporter3.EnterPart.CFrame
                        local args = {
                            "Chosen",
                            [3] = 1
                        }
                        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TeleportEvent"):FireServer(unpack(args))
                    end
                
                    if player.PlayerGui.Interface.LobbyCreate.Visible == true then
                        StarterGui:SetCore("SendNotification", {
                            Icon = "rbxassetid://16129235054",
                            Title = "Strat Lobby!",
                            Text = "Create Party...",
                            Duration = 3
                        })
                        
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
                until player.PlayerGui.TeleporterAssets.TextButton.Visible == true or  not _G.FarmChest
                print("โย่ววว")
            end
        end
    end)
    
elseif game.PlaceId == 126509999114328 then
    StarterGui:SetCore("SendNotification", {
        Icon = "rbxassetid://16129235054",
        Title = "Place",
        Text = "Ingame",
        Duration = 3
    })
    
    -- ฟาร์มเพชร
    _G.FarmChest = _G.FarmChest or true
    _G.FastMode = _G.FastMode or true
    _G.ShowLogs = _G.ShowLogs or true
    _G.UseTeleport = _G.UseTeleport or true
    _G.MaxCycles = _G.MaxCycles or 4

    -- ฟังก์ชัน Teleport ไปหากล่อง
    local function teleportToChest(chest)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and chest:FindFirstChild("Main") then
            local success, err = pcall(function()
                player.Character.HumanoidRootPart.CFrame = chest.Main.CFrame + Vector3.new(0, 5, 0)
            end)
            
            if success and _G.ShowLogs then
                -- print("🚀 TP ไปหา: " .. chest.Name)
            elseif not success and _G.ShowLogs then
                warn("❌ TP ล้มเหลว: " .. tostring(err))
            end
            
            return success
        end
        return false
    end



    local function collectDiamonds()
        local diamondCount = 0
        for _, diamond in pairs(workspace.Items:GetChildren()) do
            if diamond.Name == "Diamond" then
                local success, err = pcall(function()
                    local args = {
                        [1] = diamond
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestTakeDiamonds"):FireServer(unpack(args))
                    diamondCount = diamondCount + 1
                end)
                
                if success and _G.ShowLogs then
                    print("✅ Collect Diamond Success! (" .. diamondCount .. ")\n✅ เก็บ Diamond สำเร็จ! (" .. diamondCount .. ")")
                    StarterGui:SetCore("SendNotification", {
                        Icon = "rbxassetid://16129235054",
                        Title = "แจ้งเตือน!",
                        Text = "✅ Collect Diamond Success! (" .. diamondCount .. ")\n✅ เก็บ Diamond สำเร็จ! (" .. diamondCount .. ")",
                        Duration = 5
                    })
                elseif not success and _G.ShowLogs then
                    warn("❌ Collect Diamond Failed: " .. tostring(err))
                end
                
                task.wait(0.05)
            end
        end
        
        if diamondCount > 0 and _G.ShowLogs then
            print("💎 รวมเก็บ Diamond ได้: " .. diamondCount .. " อัน")
        end
        
        return diamondCount
    end

    -- ฟังก์ชันเปิดกล่องทั้งหมด
    local function openAllChestsAndCollect()
        if not _G.FarmChest then return end
        
        local chestCount = 0
        local successCount = 0
        local alreadyOpenedCount = 0
        
        for i, v in pairs(workspace.Items:GetChildren()) do 
            if not _G.FarmChest then break end
            
            if string.find(v.Name, "Chest") and not string.find(v.Name, "Snow") and not string.find(v.Name, "Alien") then 
                chestCount = chestCount + 1
                
                if v:FindFirstChild("Main") and not v:FindFirstChild("IceBlock") then
                    if v.Main:FindFirstChild("ProximityAttachment") then
                        local proximityInteraction = v.Main.ProximityAttachment:FindFirstChild("ProximityInteraction")
                        if proximityInteraction then
                            local success, err = pcall(function()
                                if _G.UseTeleport then
                                    teleportToChest(v)
                                    task.wait(0.2)
                                end
                                
                                fireproximityprompt(proximityInteraction)
                                successCount = successCount + 1
                                
                                if _G.ShowLogs then
                                    --print("🎁 เปิดกล่อง: " .. v.Name)
                                end
                                
                                if not _G.FastMode then
                                    task.wait(0.5)
                                    collectDiamonds()
                                end
                            end)
                            
                            if not success and _G.ShowLogs then
                                warn("❌ ไม่สามารถเปิดกล่อง " .. v.Name .. ": " .. tostring(err))
                            end
                        end
                    else
                        alreadyOpenedCount = alreadyOpenedCount + 1
                        if _G.ShowLogs then
                            --print("📦 กล่องเปิดไปแล้ว: " .. v.Name)
                        end
                    end
                end
                
                task.wait(0.1)
            end
        end
        
        if _G.ShowLogs then
            print("📊 พบกล่อง: " .. chestCount .. " | เปิดได้: " .. successCount .. " | เปิดแล้ว: " .. alreadyOpenedCount)
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://16129235054",
                Title = "Notify!",
                Text = " FoundChest: " .. chestCount .. " | OpenChest: " .. successCount .. " | AlreadyOpen: " .. alreadyOpenedCount,
                Duration = 3
            })
        end
        
        if chestCount == 0 then
            print("🔄 ไม่มีกล่อง ตรวจสอบ Diamond ก่อนย้ายเซิฟ")
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://16129235054",
                Title = "Notify!",
                Text = "No Chest, Checking Diamond Before Change Server!\nไม่มีกล่องเหลือ ตรวจสอบ Diamond ก่อนย้ายเซิร์ฟ!",
                Duration = 3
            })
            antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
            _G.FarmChest = false
            return 0
        end
        
        -- ถ้าทุกกล่องเปิดหมดแล้ว
        if successCount == 0 and alreadyOpenedCount == chestCount then
            print("🔄 กล่องเปิดหมดแล้ว ตรวจสอบ Diamond ก่อนย้ายเซิฟ")
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://16129235054",
                Title = "แจ้งเตือน!",
                Text = "All Chest Opened, Checking Diamond Before Change Server!\nกล่องเปิดหมดแล้ว ตรวจสอบ Diamond ก่อนย้ายเซิร์ฟ!",
                Duration = 3
            })
            antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
            _G.FarmChest = false
            return 0
        end
        
        -- ถ้าเป็นโหมดเร็ว ให้เก็บ Diamond ทั้งหมดหลังเปิดกล่องเสร็จ
        if _G.FastMode and successCount > 0 then
            if _G.ShowLogs then
                print("⏳ รอ Diamond spawn...")
            end
            task.wait(1) -- รอให้ Diamond ทั้งหมด spawn
            collectDiamonds()
        end
        
        return successCount
    end

    -- ฟังก์ชันฟาร์มแบบวนลูป
    local function farmLoop()
        local cycleCount = 0
        
        while _G.FarmChest do
            cycleCount = cycleCount + 1
            local startTime = tick()
            
            if _G.ShowLogs then
                print(" เริ่มรอบที่ " .. cycleCount .. "/" .. _G.MaxCycles)
            end
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://16129235054",
                Title = "Strat!",
                Text = "Round " .. cycleCount .. "/" .. _G.MaxCycles,
                Duration = 10
            })
            
            local chestsOpened = openAllChestsAndCollect()
            
            -- ถ้าไม่มีกล่องให้เปิดแล้ว (return 0) ให้หยุดลูป
            if chestsOpened == 0 then
                break
            end
            
            local endTime = tick()
            local cycleTime = math.floor((endTime - startTime) * 100) / 100
            
            if _G.ShowLogs then
                print("⏱️ รอบที่ " .. cycleCount .. " เสร็จใน " .. cycleTime .. " วินาที")
            end
            
            -- ตรวจสอบว่าครบจำนวนรอบสูงสุดหรือยัง
            if cycleCount >= _G.MaxCycles then
                if _G.ShowLogs then
                    print("🔄 ครบ " .. _G.MaxCycles .. " รอบแล้ว ตรวจสอบ Diamond ก่อนย้ายเซิฟ")
                end
                StarterGui:SetCore("SendNotification", {
                    Icon = "rbxassetid://16129235054",
                    Title = "Notify!",
                    Text = "Max " .. _G.MaxCycles .. " Round, Checking Diamond Before ChangeServer!",
                    Duration = 3
                })
                antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
                _G.FarmChest = false
                break
            end
            
            -- ถ้ายังมีกล่องให้เปิด ให้รอก่อนรอบใหม่
            if _G.FarmChest then
                if _G.ShowLogs then
                    print("💤 รอ 1 วินาที ก่อนรอบใหม่...")
                end
                task.wait(1) -- รอแค่ 1 วินาที
            end
        end
        
        if _G.ShowLogs then
            print("🛑 หยุดฟาร์มแล้ว (รวม " .. cycleCount .. " รอบ)")
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://16129235054",
                Title = "Notify!",
                Text = "🛑 StopFarm (All " .. cycleCount .. " Round)",
                Duration = 5
            })
        end
    end

    -- ฟังก์ชันรันครั้งเดียว (จากโค้ดต้นฉบับ)
    local function runOnce()
        if _G.ShowLogs then
            print("🎯 เปิดกล่องและเก็บ Diamond ครั้งเดียว")
        end
        openAllChestsAndCollect()
    end

    spawn(function()
        while true do
            if not _G.FarmChest then
                antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
            end
            task.wait(.1)
        end
    end)

    spawn(function()
        while true do
            if _G.FarmChest then
                farmLoop()
            end
            task.wait(.1)
        end
    end)

    getgenv().runOnce = runOnce
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.H, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.H, false, game)
end

getgenv().antiFullServerHop = antiFullServerHop

-- 🕐 ระบบย้ายเซิร์ฟอัตโนมัติทุก 1 นาที
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- ⚙️ การตั้งค่า
local PlaceID = game.PlaceId
local TIMER_MINUTES = 1 -- เวลาที่รอ (นาที)
local TIMER_SECONDS = TIMER_MINUTES * 60 -- แปลงเป็นวินาที
local currentJobId = game.JobId -- เซิร์ฟปัจจุบัน

-- 🔧 ตัวแปรสำหรับระบบ
local isHopping = false -- ป้องกันการทำงานซ้อน
local startTime = tick() -- เวลาเริ่มต้น
local hopAttempts = 0 -- จำนวนครั้งที่พยายาม

-- 📢 ฟังก์ชันแจ้งเตือน
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

-- 🌐 ฟังก์ชันย้ายเซิร์ฟ (ไม่ย้ายเข้าเซิร์ฟเดิม)
local function AutoServerHop()
    if isHopping then
        print("⚠️ กำลังย้ายเซิร์ฟอยู่แล้ว...")
        return
    end
    
    isHopping = true
    hopAttempts = hopAttempts + 1
    
    print("🔄 เริ่มย้ายเซิร์ฟ (ครั้งที่ " .. hopAttempts .. ")")
    notify("Server Hop", "🔄 กำลังย้ายเซิร์ฟ... (ครั้งที่ " .. hopAttempts .. ")", 3)
    
    -- ดึงข้อมูลเซิร์ฟ
    local success, serverData = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100")
        )
    end)
    
    if not success or not serverData or not serverData.data then
        warn("❌ ไม่สามารถดึงข้อมูลเซิร์ฟได้")
        notify("Error", "❌ ไม่สามารถดึงข้อมูลเซิร์ฟได้", 3)
        
        -- ใช้ Random Teleport แทน
        pcall(function()
            TeleportService:Teleport(PlaceID, player)
        end)
        return
    end
    
    -- หาเซิร์ฟที่ไม่ใช่เซิร์ฟปัจจุบัน
    local availableServers = {}
    
    for _, server in pairs(serverData.data) do
        if server.id ~= currentJobId and server.playing > 0 and server.playing < server.maxPlayers then
            table.insert(availableServers, {
                id = server.id,
                playing = server.playing,
                maxPlayers = server.maxPlayers,
                ping = server.ping or 999
            })
        end
    end
    
    if #availableServers == 0 then
        print("⚠️ ไม่มีเซิร์ฟอื่นที่ใช้ได้ ใช้ Random Teleport")
        notify("No Servers", "⚠️ ไม่มีเซิร์ฟอื่น ใช้ Random Teleport", 3)
        
        pcall(function()
            TeleportService:Teleport(PlaceID, player)
        end)
        return
    end
    
    -- เรียงเซิร์ฟตาม ping ต่ำสุด
    table.sort(availableServers, function(a, b)
        return a.ping < b.ping
    end)
    
    -- เลือกเซิร์ฟที่ดีที่สุด
    local bestServer = availableServers[1]
    
    print("🎯 พบเซิร์ฟเหมาะสม: " .. bestServer.playing .. "/" .. bestServer.maxPlayers .. " คน")
    notify("Found Server", "🎯 " .. bestServer.playing .. "/" .. bestServer.maxPlayers .. " คน", 3)
    
    -- ตั้งค่า Event เมื่อ Teleport ล้มเหลว
    local failConnection = TeleportService.TeleportInitFailed:Connect(function(plr, teleportResult, errorMessage)
        if plr == player then
            warn("❌ Teleport ล้มเหลว: " .. tostring(errorMessage))
            notify("Teleport Failed", "❌ " .. tostring(errorMessage), 3)
            isHopping = false -- รีเซ็ตสถานะ
        end
    end)
    
    -- ทำการ Teleport
    local teleportSuccess = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceID, bestServer.id, player)
    end)
    
    if teleportSuccess then
        print("✅ กำลังย้ายไปเซิร์ฟใหม่...")
        notify("Success", "✅ กำลังย้ายเซิร์ฟ...", 3)
    else
        print("❌ ไม่สามารถ Teleport ได้")
        notify("Failed", "❌ ไม่สามารถ Teleport ได้", 3)
        isHopping = false -- รีเซ็ตสถานะ
    end
    
    -- ยกเลิก Connection หลังจาก 5 วินาที
    task.wait(5)
    failConnection:Disconnect()
end

-- 🕐 ฟังก์ชันคำนวณเวลาที่เหลือ
local function getRemainingTime()
    local elapsedTime = tick() - startTime
    local remainingTime = TIMER_SECONDS - elapsedTime
    return math.max(0, remainingTime)
end

-- 📊 ฟังก์ชันแสดงสถานะ
local function showStatus()
    local remaining = getRemainingTime()
    local minutes = math.floor(remaining / 60)
    local seconds = math.floor(remaining % 60)
    
    if remaining > 0 then
        print("⏰ เวลาเหลือ: " .. minutes .. ":" .. string.format("%02d", seconds) .. " ก่อนย้ายเซิร์ฟ")
    else
        print("🎯 ถึงเวลาย้ายเซิร์ฟแล้ว!")
    end
end

-- 🔄 ลูปหลักสำหรับตรวจสอบเวลา
local function startAutoHopTimer()
    print("🚀 เริ่มระบบย้ายเซิร์ฟอัตโนมัติ")
    print("⏱️ จะย้ายเซิร์ฟทุก " .. TIMER_MINUTES .. " นาที")
    notify("Auto Hop Started", "⏱️ ย้ายเซิร์ฟทุก " .. TIMER_MINUTES .. " นาที", 5)
    
    spawn(function()
        while true do
            local remaining = getRemainingTime()
            
            -- แสดงสถานะทุก 10 วินาที (เฉพาะตอนยังรออยู่)
            if remaining > 0 and math.floor(remaining) % 10 == 0 then
                showStatus()
            end
            
            -- แสดงการนับถอยหลังในช่วง 10 วินาทีสุดท้าย (เฉพาะตอนยังรออยู่)
            if remaining <= 10 and remaining > 0 then
                print("⏰ " .. math.floor(remaining) .. " วินาที...")
                
                if remaining <= 3 then
                    notify("Countdown", "⏰ " .. math.floor(remaining) .. " วินาที", 1)
                end
            end
            
            -- เมื่อถึงเวลา หรือ เวลาหมดแล้วแต่ยังไม่สำเร็จ
            if remaining <= 0 then
                if not isHopping then
                    print("🎯 ถึงเวลาย้ายเซิร์ฟ!")
                    AutoServerHop()
                end
                
                -- รอ 3 วินาทีเพื่อดู teleport result
                task.wait(3)
                
                -- ถ้ายังอยู่เซิร์ฟเดิม (teleport ไม่สำเร็จ)
                if game.JobId == currentJobId then
                    print("⚠️ Teleport ไม่สำเร็จ ลองใหม่ในอีก 5 วินาที...")
                    notify("Retry", "⚠️ ลองใหม่ในอีก 2 วินาที", 3)
                    isHopping = false
                    task.wait(2) -- รอ 5 วินาทีแล้วลองใหม่เลย ไม่รีเซ็ตเวลา
                else
                    -- ถ้า teleport สำเร็จ ระบบจะหยุดทำงาน
                    print("✅ Teleport สำเร็จ! ระบบหยุดทำงาน")
                    break
                end
            end
            
            task.wait(1) -- ตรวจสอบทุกวินาที
        end
    end)
end

-- 🎮 ฟังก์ชันเริ่มต้นระบบ
local function initAutoHop()
    print("📋 กำลังเริ่มระบบ Auto Server Hop")
    print("📍 เซิร์ฟปัจจุบัน: " .. currentJobId)
    print("🎯 PlaceID: " .. PlaceID)
    notify("Notify ","PlaceID: " .. PlaceID,3)
    notify("Notify ","Current: " .. currentJobId,3)
    
    startAutoHopTimer()
end

-- 🛑 ฟังก์ชันหยุดระบบ (เผื่อต้องการหยุด)
local function stopAutoHop()
    print("🛑 หยุดระบบ Auto Server Hop")
    notify("Stopped", "🛑 หยุดระบบ Auto Hop", 3)
    _G.AutoHopEnabled = false
end

-- 🔧 Export ฟังก์ชันให้ใช้ภายนอก
getgenv().startAutoHop = initAutoHop
getgenv().stopAutoHop = stopAutoHop
getgenv().getRemainingTime = getRemainingTime
getgenv().showHopStatus = showStatus

-- 🚀 เริ่มระบบอัตโนมัติ
_G.AutoHopEnabled = true
initAutoHop()
wait(5)
-- Configuration
local HARD_CODED_WEBHOOK = "https://discord.com/api/webhooks/1405892341272936449/cn6Lb-dxC4W-vpYDvR0odhtY9sjoHocVmp-xNCTC-MQuGTfnHJC-Ngv0g6Uk8PYLRKi1"
local webhookUrl = getgenv().Webhookurl or HARD_CODED_WEBHOOK

-- Utility Functions
local function getPlayerCount()
    local count = 0
    for _ in pairs(game:GetService("Players"):GetPlayers()) do
        count = count + 1
    end
    return count
end

local function safeGetText(path)
    local success, value = pcall(function()
        return path.Text
    end)
    return success and value or "N/A"
end

local function sendWebhook(url, description, fields)
    local success, response = pcall(function()
        local data = {
            ["username"] = "Vector Hub",
            ["avatar_url"] = "https://media.discordapp.net/attachments/1090933613677252690/1405897109542146148/v2_nobg.png?ex=68a07f37&is=689f2db7&hm=2678bcc3009bf3737a8b8c3838dc6fe6e9ab35fb9ecd3419a338728cebfd236c&=&format=webp&quality=lossless&width=798&height=798",
            ["embeds"] = {
                {
                    ["description"] = description,
                    ["color"] = tonumber(0x0000FF),
                    ["type"] = "rich",
                    ["fields"] = fields,
                    ["footer"] = { ["text"] = "Webhook Vector Hub" },
                    ["timestamp"] = DateTime.now():ToIsoDate()
                }
            }
        }
        local newdata = game:GetService("HttpService"):JSONEncode(data)
        local headers = { ["content-type"] = "application/json" }
        local request = http_request or request or HttpPost or syn.request
        request({ Url = url, Body = newdata, Method = "POST", Headers = headers })
    end)
    if success then
        print("Webhook sent successfully!")
    else
        warn("Webhook failed: " .. tostring(response))
    end
end

-- Game Detection
local is99Night = (game.PlaceId == 126509999114328) -- เปลี่ยนเป็น PlaceId จริงของ 99 Night in the Forest
if not is99Night then
    warn("This script is designed for 99 Night in the Forest (PlaceId: 1234567890). Current PlaceId: " .. game.PlaceId)
    return
end

-- Player and Game Data
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name
local diamondCount = safeGetText(LocalPlayer.PlayerGui.Interface.DiamondCount.Count)
local dayCounter = safeGetText(LocalPlayer.PlayerGui.Interface.DayCounter)
local PlayersMin = getPlayerCount()
local JobId = tostring(game.JobId)
local JoinServer = 'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, \'' .. JobId .. '\')'

-- Debug: Check GUI Paths
print("Diamond Count: " .. tostring(diamondCount))
print("Day Counter: " .. tostring(dayCounter))

-- Webhook Payload for Player Data
local fields = {
    {
        ["name"] = "[👤] Player Name",
        ["value"] = '```' .. playerName .. '```',
        ["inline"] = true
    },
    {
        ["name"] = "[💎] Diamond Count",
        ["value"] = '```' .. (diamondCount ~= "N/A" and diamondCount or "Not Found") .. '```',
        ["inline"] = true
    },
    {
        ["name"] = "[🕒] Day Counter",
        ["value"] = '```' .. (dayCounter ~= "N/A" and dayCounter or "Not Found") .. '```',
        ["inline"] = true
    },
    {
        ["name"] = "[👥] Players Active",
        ["value"] = '```' .. PlayersMin .. '/5```'
    },
    {
        ["name"] = "[📃] JobID",
        ["value"] = '```' .. JobId .. '```'
    },
    {
        ["name"] = "[📁] Join Server",
        ["value"] = '```' .. JoinServer .. '```'
    }
}

-- Send Player Data Webhook (Send even if some data is missing)
sendWebhook(webhookUrl, "**__99 Night in the Forest Info__**", fields)
