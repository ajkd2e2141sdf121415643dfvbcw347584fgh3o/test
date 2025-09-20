repeat wait() until game:IsLoaded() 
_G.FarmChest = true
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
HttpService.HttpEnabled = true
--รอเช็ค
local lp = Players.LocalPlayer
while not lp do
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    lp = Players.LocalPlayer
end

while not Players.LocalPlayer or not Players.LocalPlayer:FindFirstChild("PlayerGui") do
    task.wait()
end
if game:GetService("CoreGui"):FindFirstChild("Info") then
    game:GetService("CoreGui").Info:Destroy()
end

-- 🕐 ระบบย้ายเซิร์ฟอัตโนมัติแบบง่าย (ไม่เช็คคน/ping)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- ⚙️ การตั้งค่า
local PlaceID = game.PlaceId
local TIMER_MINUTES = 1 -- เวลาที่รอ (นาที)
local TIMER_SECONDS = TIMER_MINUTES * 60
local currentJobId = game.JobId

-- 🔧 ตัวแปรสำหรับระบบ
local isHopping = false
local hopAttempts = 0

 repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
local player = game.Players.LocalPlayer
local deadname = player.Name .. " Body"
function AutoServerHop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                end
            end
        end
    end
    function Teleport() 
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end  

spawn(function()
while task.wait() do
    local body = workspace:WaitForChild("Characters"):FindFirstChild(deadname)
        if body then
            print("💀 ตายแล้ว (พบใน Characters)")
            AutoServerHop()
        end
    end
end)
loadstring(game:HttpGet('https://raw.githubusercontent.com/ajkd2e2141sdf121415643dfvbcw347584fgh3o/hmm/refs/heads/main/s3'))()
_G.CONFIG = _G.CONFIG

-- 🔔 แสดงการแจ้งเตือน
local function notify(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 5
        })
    end)
end

-- ⏰ ระบบ Timer อัตโนมัติ
local function startAutoHopTimer()
    print("⏰ เริ่ม Auto Server Hop Timer (" .. TIMER_MINUTES .. " นาที)")
    notify("Auto Hop Started", "⏰ จะย้ายเซิร์ฟทุก " .. TIMER_MINUTES .. " นาที", 5)
    
    task.spawn(function()
        while true do
            task.wait(TIMER_SECONDS)
            
            if not isHopping then
                print("⏰ ถึงเวลาย้ายเซิร์ฟแล้ว!")
                AutoServerHop()
            else
                print("⚠️ กำลังย้ายเซิร์ฟอยู่ ข้ามรอบนี้")
            end
        end
    end)
end

-- 🚀 เริ่มระบบ
print("🟢 Auto Server Hop System เริ่มแล้ว!")
print("📍 Current JobId: " .. currentJobId)
print("⏰ จะย้ายเซิร์ฟทุก " .. TIMER_MINUTES .. " นาที")
startAutoHopTimer()



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

local function checkAndCollectDiamondsBeforeHop()
    local diamondCount = 0
    local maxRetries = 3
    local player = game.Players.LocalPlayer
    local name = player.Name

    local isDead = false
    for _, v in pairs(workspace.Characters:GetChildren()) do
        if string.find(v.Name, name) then
            isDead = true
            break
        end
    end

    if isDead then
        print("ตาย")
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
       
    else
        if _G.ShowLogs then
            print("✅ ตรวจสอบแล้ว ไม่มี Diamond เหลือ")
        end
      
    end
    
    return diamondCount == 0
end
local startTime = tick()

local CONFIG = {
    FIREBASE_URL = "https://discordbotdata-29400-default-rtdb.asia-southeast1.firebasedatabase.app/jobids.json",
}

local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local deadname = localPlayer.Name .. "Humanoid"  -- ชื่อ body ที่ตาย

print("🚀 Starting Server Hop Script...")

-- ดึงข้อมูล JobID จาก Firebase
local function getJobIDs()
    local ok, body = pcall(function()
        if request then
            return request({Url = CONFIG.FIREBASE_URL, Method = "GET"}).Body
        elseif syn and syn.request then
            return syn.request({Url = CONFIG.FIREBASE_URL, Method = "GET"}).Body
        elseif http_request then
            return http_request({Url = CONFIG.FIREBASE_URL, Method = "GET"}).Body
        elseif http.request then
            return http.request({Url = CONFIG.FIREBASE_URL, Method = "GET"}).Body
        else
            error("no request function available")
        end
    end)
    
    if not ok or not body then
        warn("❌ Cannot fetch Firebase data (ok:" .. tostring(ok) .. ", body:" .. tostring(body) .. ")")
        return nil
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not success or not data then
        warn("❌ Invalid Firebase JSON")
        return nil
    end
    
    local jobIds = {}
    for firebaseKey, jobData in pairs(data) do
        if jobData.id and jobData.timestamp then
            local cleanId = jobData.id:match("([%w%-]+)")
            local players = tonumber(jobData.id:match("!Players:(%d+)")) or 0
            if cleanId then
                table.insert(jobIds, {
                    key = firebaseKey,
                    id = cleanId,
                    players = players,
                    timestamp = jobData.timestamp
                })
            end
        end
    end
    
    if #jobIds == 0 then
        warn("❌ No valid JobIDs parsed!")
    end
    return jobIds
end

local attemptCount = 0  -- ตัวแปรนับจำนวนครั้งที่เรียกฟังก์ชัน (ทุกครั้ง)

local function getLatestJobID(mode)
    mode = mode or "latest"  -- Default: latest, หรือ "random" สำหรับสุ่ม
    local jobIds = getJobIDs()
    if not jobIds or #jobIds == 0 then
        return nil
    end
    
    table.sort(jobIds, function(a, b) return a.timestamp > b.timestamp end)  -- Sort ล่าสุดก่อน
    
    if mode == "random" then
        local randomIndex = math.random(1, #jobIds)
        local randomJob = jobIds[randomIndex]
        --print("🎲 Random JobID selected: " .. randomJob.id .. " (Players: " .. randomJob.players .. ")")
        return randomJob.id
    else
        local latestJob = jobIds[1]
        --print("🔍 Latest JobID: " .. latestJob.id .. " (Players: " .. latestJob.players .. ")")
        return latestJob.id
    end
end

local function joinLatestJobID()
    attemptCount = attemptCount + 1  -- นับทุกครั้งที่เรียก
    local thisAttemptSuccess = false  -- ตัวแปรชั่วคราวสำหรับเช็ค success
    
    local latestJobId = getLatestJobID(math.random() < 0.5 and "random" or "latest")  -- 50% latest, 50% random
    if not latestJobId then
        --warn("❌ No latest/random JobID found")
    else
       -- print("🚀 Spamming Teleport to JobID: " .. latestJobId)
        
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, latestJobId, localPlayer)
        end)
        
        if not success then
          --  warn("❌ Teleport failed: " .. tostring(err))
        else
          --  print("✅ Teleport initiated! Loading...")
            thisAttemptSuccess = true
        end
    end
    
   -- print("📊 Attempt count: " .. attemptCount .. " (Success this time: " .. tostring(thisAttemptSuccess) .. ")")
    
    -- ถ้าพยายามครบ 50 ครั้ง ให้ใช้ Teleport สุ่ม
    if attemptCount >= 50 then
       -- print("⚠️ พยายามย้ายเซิร์ฟครบ 50 ครั้งแล้ว (รวม success) เปลี่ยนไปใช้ Teleport สุ่มเซิร์ฟ")
        local success, err = pcall(function()
        game.Players.LocalPlayer:Kick("KickForchangeserverwork\nเตะสำหรับทำให้ย้ายเซิฟทำงานได้")
        game:GetService("TeleportService"):Teleport(126509999114328)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
        if not success then
            warn("❌  Teleport failed: " .. tostring(err))
        else
            print("✅  Teleport initiated! Loading...")
        end
        attemptCount = 0  -- รีเซ็ตหลังใช้ Random Teleport
    end
end

local hopMethodIndex = 1  -- ตัวแปรสำหรับติดตามวิธีการ hop ปัจจุบัน (เริ่มต้นที่ 1)

local function antiFullServerHop()
    print("🛡️ เริ่มระบบย้ายเซิฟป้องกันเซิฟเต็ม Current JobId: " .. currentJobId)
    notify("Anti-Full Hop", "🛡️ กำลังค้นหาเซิฟที่ปลอดภัยที่สุด", 3)

    -- เก็บ Diamond ก่อนย้าย
    local success = checkAndCollectDiamondsBeforeHop()
    if success then
        print("💎 เก็บ Diamond เรียบร้อยก่อนย้ายเซิฟ")
        task.wait(1)
    else
        print("🔍 ตรวจพบปัญหา เช่น ตายหรือยังมี Diamond")
    end
    
    -- วนลูปเพื่อ hop โดยหมุนเวียนวิธีการ
    while true do
        if hopMethodIndex == 1 then
           -- print("🔄 ใช้วิธีที่ 1: AutoServerHop()")
            joinLatestJobID()
        elseif hopMethodIndex == 2 then
           -- print("🔄 ใช้วิธีที่ 2: joinLatestJobID()")
            joinLatestJobID()
        elseif hopMethodIndex == 3 then
           -- print("🔄 ใช้วิธีที่ 3: Kick และ Teleport ไป PlaceId ใหม่")
            game.Players.LocalPlayer:Kick("KickForchangeserverwork\nเตะสำหรับทำให้ย้ายเซิฟทำงานได้")
            game:GetService("TeleportService"):Teleport(126509999114328)
        elseif hopMethodIndex == 4 then
            --print("🔄 ใช้วิธีที่ 4: Kick และ Rejoin เซิร์ฟเดิม")
            game.Players.LocalPlayer:Kick("KickForchangeserverwork\nเตะสำหรับทำให้ย้ายเซิฟทำงานได้")
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
        
        -- หมุนเวียนไปวิธีถัดไป (วนกลับไป 1 ถ้าครบ 4)
        hopMethodIndex = hopMethodIndex + 1
        if hopMethodIndex > 4 then
            hopMethodIndex = 1
        end
        
        task.wait(0)  -- รอเล็กน้อยก่อนลูปรอบถัดไป (ถ้าจำเป็น)
    end
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
        print("⏰ เวลาเหลือ: " .. minutes .. ":" .. string.format("%02d", seconds) .. " ก่อนย้ายเซิร์ฟ Current JobId: " .. currentJobId)
    else
        print("🎯 ถึงเวลาย้ายเซิร์ฟแล้ว! Current JobId: " .. currentJobId)
    end
end

-- 🔄 ลูปหลักสำหรับตรวจสอบเวลา
local function startAutoHopTimer()
    print("🚀 เริ่มระบบย้ายเซิร์ฟอัตโนมัติ Current JobId: " .. currentJobId)
    print("⏱️ จะย้ายเซิร์ฟทุก " .. TIMER_MINUTES .. " นาที")
    notify("Auto Hop Started", "⏱️ ย้ายเซิร์ฟทุก " .. TIMER_MINUTES .. " นาที", 5)
    
    spawn(function()
        while _G.AutoHopEnabled do
            local remaining = getRemainingTime()
            
            if remaining > 0 and math.floor(remaining) % 10 == 0 then
                showStatus()
            end
            
            if remaining <= 10 and remaining > 0 then
                print("⏰ " .. math.floor(remaining) .. " วินาที...")
                if remaining <= 3 then
                    notify("Countdown", "⏰ " .. math.floor(remaining) .. " วินาที", 1)
                end
            end
            
            if remaining <= 0 then
                if not isHopping then
                    print("🎯 ถึงเวลาย้ายเซิร์ฟ!")
                    AutoServerHop()
                    startTime = tick() -- รีเซ็ตเวลา
                end
                
                task.wait()
                
                if game.JobId == currentJobId then
                    print("⚠️ ยังอยู่เซิร์ฟเดิม ลองใหม่ใน 5 วินาที... Current: " .. game.JobId)
                    notify("Retry", "⚠️ ลองใหม่ใน 5 วินาที", 3)
                    isHopping = false
                    task.wait()
                else
                    print("✅ ย้ายสำเร็จ! JobId ใหม่: " .. game.JobId)
                    currentJobId = game.JobId -- อัพเดท (แม้จะอัตโนมัติ แต่ยืนยัน)
                    startTime = tick()
                end
            end
            
            task.wait(1)
        end
    end)
end

-- 🎮 ฟังก์ชันเริ่มต้นระบบ
local function initAutoHop()
    print("📋 กำลังเริ่มระบบ Auto Server Hop Current JobId: " .. currentJobId)
    print("📍 เซิร์ฟปัจจุบัน: " .. currentJobId)
    print("🎯 PlaceID: " .. PlaceID)
    notify("Notify", "PlaceID: " .. PlaceID, 3)
    notify("Notify", "Current: " .. currentJobId, 3)
    
    startAutoHopTimer()
end

-- 🛑 ฟังก์ชันหยุดระบบ
local function stopAutoHop()
    print("🛑 หยุดระบบ Auto Server Hop")
    notify("Stopped", "🛑 หยุดระบบ Auto Hop", 3)
    _G.AutoHopEnabled = false
end

-- 🔧 Export ฟังก์ชัน
getgenv().startAutoHop = initAutoHop
getgenv().stopAutoHop = stopAutoHop
getgenv().getRemainingTime = getRemainingTime
getgenv().showHopStatus = showStatus
getgenv().antiFullServerHop = antiFullServerHop

-- 🚀 เริ่มระบบอัตโนมัติ
_G.AutoHopEnabled = true
initAutoHop()
---
local TeleportService = game:GetService("TeleportService")
local placeId = 126509999114328  --126509999114328
local player = game.Players.LocalPlayer

local function joinPlace()
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(placeId, player)
    end)
    if not success then
        warn("ไม่สามารถเข้าร่วม Place ID ได้: " .. errorMessage)
    end
end


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
               joinPlace()
            end
        end
    end)
    
local localPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function getCharacter()
    return localPlayer and (localPlayer.Character or localPlayer.CharacterAdded:Wait())
end

    local function getHRP(timeout)
    local char = getCharacter()
    return (char and char:WaitForChild("HumanoidRootPart", timeout)) or nil
end
    task.spawn(function()
        while _G.FarmChest do
            local teleporters = {}
            for i = 1, 3 do
                local ok, tele = pcall(function() return workspace:FindFirstChild("Teleporter" .. i) end)
                if ok and tele then table.insert(teleporters, tele) end
            end

            for _, tele in ipairs(teleporters) do
                if not _G.FarmChest then break end
                local bb = tele:FindFirstChild("BillboardHolder")
                local gui = bb and bb:FindFirstChild("BillboardGui")
                if gui and gui:FindFirstChild("Players") and gui.Players.Text == "0/5" then
                    local hrp = getHRP(2)
                    if hrp and tele:FindFirstChild("EnterPart") then
                        pcall(function()
                            hrp.CFrame = tele.EnterPart.CFrame
                            ReplicatedStorage:WaitForChild("RemoteEvents", 5):WaitForChild("TeleportEvent", 5):FireServer("Chosen", nil, 1)
                        end)
                    end
                    task.wait(0.5)
                end
            end

            task.wait(0.4)
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
    _G.MaxCycles = _G.MaxCycles or 2

    
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
RunService:Set3dRenderingEnabled(true)
local H_KEY_CODE = Enum.KeyCode.H
local isRenderingEnabled = true
UserInputService.InputBegan:Connect(function(input, isProcessed)
	if not isProcessed and input.KeyCode == H_KEY_CODE then
		isRenderingEnabled = not isRenderingEnabled
		RunService:Set3dRenderingEnabled(isRenderingEnabled)
	end
end)


local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local TextButton_2 = Instance.new("TextButton")

--Properties:
ScreenGui.Parent = Players.LocalPlayer.PlayerGui
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
TextButton.Font = Enum.Font.Code
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
                                end
                                
                                fireproximityprompt(proximityInteraction)
                                successCount = successCount + 1
                                
                                if _G.ShowLogs then
                                    --print("🎁 เปิดกล่อง: " .. v.Name)
                                end
                                
                                if not _G.FastMode then
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
            end
        end
        
        if _G.ShowLogs then
            print("📊 พบกล่อง: " .. chestCount .. " | เปิดได้: " .. successCount .. " | เปิดแล้ว: " .. alreadyOpenedCount)
            
        end
        
        if chestCount == 0 then
            print("🔄 ไม่มีกล่อง ตรวจสอบ Diamond ก่อนย้ายเซิฟ")
          
            antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
            _G.FarmChest = false
            return 0
        end
        
        -- ถ้าทุกกล่องเปิดหมดแล้ว
        if successCount == 0 and alreadyOpenedCount == chestCount then
            print("🔄 กล่องเปิดหมดแล้ว ตรวจสอบ Diamond ก่อนย้ายเซิฟ")
           
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
           antiFullServerHop()
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
                                    task.wait(0)
                                end
                                
                                fireproximityprompt(proximityInteraction)
                                successCount = successCount + 1
                                
                                if _G.ShowLogs then
                                    --print("🎁 เปิดกล่อง: " .. v.Name)
                                end
                                
                                if not _G.FastMode then
                                    task.wait(0)
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
          
        end
        
        if chestCount == 0 then
           
            antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
            _G.FarmChest = false
            return 0
        end
        
        -- ถ้าทุกกล่องเปิดหมดแล้ว
        if successCount == 0 and alreadyOpenedCount == chestCount then
            print("🔄 กล่องเปิดหมดแล้ว ตรวจสอบ Diamond ก่อนย้ายเซิฟ")
         
            antiFullServerHop() -- ใช้ antiFullServerHop แทน serverHop
            _G.FarmChest = false
            return 0
        end
        
        -- ถ้าเป็นโหมดเร็ว ให้เก็บ Diamond ทั้งหมดหลังเปิดกล่องเสร็จ
        if _G.FastMode and successCount > 0 then
            if _G.ShowLogs then
                print("⏳ รอ Diamond spawn...")
            end
            task.wait(.1) -- รอให้ Diamond ทั้งหมด spawn
            collectDiamonds()
        end
        
        return successCount
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
                antiFullServerHop() 
            end
            task.wait(.1)
        end
    end)


    getgenv().runOnce = runOnce
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.H, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.H, false, game)
end
spawn(function()
    while task.wait(0.01) do
        if game:GetService("Players").LocalPlayer.GameplayPaused == true then 
            game:GetService("Players").LocalPlayer.GameplayPaused = false
        end
    end
end)
loadstring(game:HttpGet('https://raw.githubusercontent.com/7878wqz/sc1/refs/heads/main/h'))()
--ปัจจุบันใช้ตัวนี้
