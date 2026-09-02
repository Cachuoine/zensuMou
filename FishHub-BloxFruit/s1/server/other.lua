local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Các Remote chuẩn xác từ ReplicatedStorage của bạn
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local ServerBrowser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
local PingRemote = ReplicatedStorage:FindFirstChild("Ping")
local ClockFunc = Remotes and Remotes:FindFirstChild("Clock") and Remotes.Clock:FindFirstChild("DelayedRequestFunction")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    if Config.Rainbow or Config.RainbowMode then
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius)
    })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0

local container = New("ScrollingFrame", {
    Parent = Tab,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = accent()
})

New("UIPadding", {
    Parent = container,
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 15),
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 5)
})

New("UIListLayout", {
    Parent = container,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

local layoutOrder = 0

-- Tiêu đề nhóm 1: Server Info
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• SEA 3 | SERVER",
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(180, 190, 210),
    TextXAlignment = Enum.TextXAlignment.Left
})

local serverMetrics = {
    {key = "uptime", title = "Server Uptime", desc = "Synchronizing..."},
    {key = "ping", title = "Server Ping", desc = "Checking network..."},
    {key = "chest", title = "Chest Forecast (Fist / Chalice)", desc = "Scanning server players..."}
}

local serverCards = {}
for _, info in ipairs(serverMetrics) do
    layoutOrder = layoutOrder + 1
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = layoutOrder,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 10),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Text = info.title,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local descLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 33),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Text = info.desc,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    serverCards[info.key] = {card = card, stroke = stroke, descLabel = descLabel}
end

-- Tiêu đề nhóm 2: Player Info
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• SEA 3 | PLAYER",
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(180, 190, 210),
    TextXAlignment = Enum.TextXAlignment.Left
})

local playerMetrics = {
    {key = "kenlevel", title = "Ken Level (Dodges)", desc = "Reading character data..."},
    {key = "moonstatus", title = "Moon Status (Clock Sync)", desc = "Synchronizing clock..."}
}

local playerCards = {}
for _, info in ipairs(playerMetrics) do
    layoutOrder = layoutOrder + 1
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = layoutOrder,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 10),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Text = info.title,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local descLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 33),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Text = info.desc,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    playerCards[info.key] = {card = card, stroke = stroke, descLabel = descLabel}
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Mốc tính thời gian hoạt động thực tế dựa trên DistributedGameTime của server
local serverStartTick = tick() - Workspace.DistributedGameTime

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a
        for _, c in pairs(serverCards) do c.stroke.Color = a end
        for _, c in pairs(playerCards) do c.stroke.Color = a end

        -- 1. Server Uptime (Động 100% theo thời gian sống thực tế của server)
        if serverCards["uptime"] then
            local uptimeSec = math.floor(tick() - serverStartTick)
            local upH = math.floor(uptimeSec / 3600)
            local upM = math.floor((uptimeSec % 3600) / 60)
            local upS = uptimeSec % 60
            serverCards["uptime"].descLabel.Text = string.format("Active: %02dh %02dm %02ds", upH, upM, upS)
            serverCards["uptime"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        -- 2. Server Ping (Đọc trực tiếp từ Remote Ping chuẩn của game)
        if serverCards["ping"] then
            local currentPing = "Unknown"
            local success = pcall(function()
                if PingRemote and PingRemote:IsA("RemoteFunction") then
                    local t1 = tick()
                    PingRemote:InvokeServer()
                    currentPing = math.floor((tick() - t1) * 1000)
                end
            end)
            if not success or currentPing == "Unknown" then
                -- Fallback sang NetworkStats nếu RemoteFunction không phản hồi trực tiếp
                local stats = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                currentPing = math.floor(stats)
            end
            serverCards["ping"].descLabel.Text = "Latency: " .. tostring(currentPing) .. " ms"
            serverCards["ping"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        end

        -- 3. Chest Forecast (Quét kỹ Balo và Nhân vật của toàn bộ người chơi trong server xem có Fist / Chalice không)
        if serverCards["chest"] then
            local foundItem = nil
            for _, p in ipairs(Players:GetPlayers()) do
                local bp = p:FindFirstChild("Backpack")
                local char = p.Character
                if bp then
                    if bp:FindFirstChild("Fist of Darkness") then foundItem = "Fist of Darkness" end
                    if bp:FindFirstChild("God's Chalice") then foundItem = "God's Chalice" end
                end
                if char then
                    if char:FindFirstChild("Fist of Darkness") then foundItem = "Fist of Darkness" end
                    if char:FindFirstChild("God's Chalice") then foundItem = "God's Chalice" end
                end
                if foundItem then break end
            end

            if foundItem then
                serverCards["chest"].descLabel.Text = "Found Item: " .. foundItem
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["chest"].descLabel.Text = "No Special Item in Server"
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        -- PLAYER INFO UPDATES
        
        -- Ken Level (Đọc chính xác số lượng Dodges từ nhân vật thực tế)
        if playerCards["kenlevel"] then
            local currentDodges = 0
            if LocalPlayer.Character then
                local charFolder = Workspace:FindFirstChild("Characters")
                local myChar = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
                local dodgeObj = myChar and myChar:FindFirstChild("Dodges")
                if dodgeObj then
                    currentDodges = dodgeObj.Value
                end
            end
            playerCards["kenlevel"].descLabel.Text = currentDodges .. " / 5000"
            playerCards["kenlevel"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        -- Moon Status (Đồng bộ thời gian qua Remote Clock chuẩn xác của game kết hợp Lighting engine)
        if playerCards["moonstatus"] then
            local moonPhase = Lighting:GetMoonPhase()
            local serverClock = Lighting.ClockTime
            
            -- Đồng bộ thời gian qua Clock.DelayedRequestFunction nếu có thể
            pcall(function()
                if ClockFunc and ClockFunc:IsA("RemoteFunction") then
                    local res = ClockFunc:InvokeServer()
                    if type(res) == "number" then
                        serverClock = res
                    end
                end
            end)

            local phaseText = "Normal Phase"
            if moonPhase > 0.75 then
                phaseText = string.format("Full Moon (100%%) - Time: %.1fh", serverClock)
            else
                phaseText = string.format("Phase: %.2f - Time: %.1fh", moonPhase, serverClock)
            end
            
            playerCards["moonstatus"].descLabel.Text = phaseText
            playerCards["moonstatus"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        task.wait(1)
    end
end)

return {}
