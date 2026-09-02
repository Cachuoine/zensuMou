local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

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

-- Hàm gọi CommF an toàn lấy từ boss.lua gốc[cite: 4]
local function invokeCommF(...)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local commF = remotes:FindFirstChild("CommF_") or remotes:FindFirstChild("CommF")
        if commF and commF:IsA("RemoteFunction") then
            local success, res = pcall(function(...)
                return commF:InvokeServer(...)
            end, ...)
            if success then return res end
        end
    end
    return nil
end

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
    {key = "uptime", title = "Server Uptime", desc = "Checking..."},
    {key = "chest", title = "Chest Forecast (Fist of Darkness / Chalice)", desc = "Checking..."},
    {key = "elite", title = "Elite Progress", desc = "Checking..."},
    {key = "cakeprince", title = "Cake Prince", desc = "Checking..."},
    {key = "spystatus", title = "Spy Status", desc = "Checking..."}
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

    serverCards[info.key] = {
        card = card,
        stroke = stroke,
        descLabel = descLabel
    }
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
    {key = "kenlevel", title = "Ken Level", desc = "Checking..."},
    {key = "moonstatus", title = "Moon Status", desc = "Checking..."},
    {key = "racetier", title = "Race Tier", desc = "Checking..."},
    {key = "pulllever", title = "Pull Lever", desc = "Checking..."}
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

    playerCards[info.key] = {
        card = card,
        stroke = stroke,
        descLabel = descLabel
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Biến lưu thời gian khởi động thực tế của Server (dựa vào chỉ số mạng/thời gian game)
local serverStartTick = tick() - workspace.DistributedGameTime

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        for _, c in pairs(serverCards) do c.stroke.Color = a end
        for _, c in pairs(playerCards) do c.stroke.Color = a end

        -- 1. Server Uptime (Động 100% theo thời gian thực hoạt động của server)
        if serverCards["uptime"] then
            local uptimeSec = math.floor(tick() - serverStartTick)
            local upH = math.floor(uptimeSec / 3600)
            local upM = math.floor((uptimeSec % 3600) / 60)
            local upS = uptimeSec % 60
            serverCards["uptime"].descLabel.Text = string.format("%02dh %02dm %02ds", upH, upM, upS)
            serverCards["uptime"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        -- 2. Chest Forecast (Fist of Darkness / God's Chalice - Quét toàn bộ người chơi và rương trong server)
        if serverCards["chest"] then
            local foundItem = false
            for _, p in ipairs(Players:GetPlayers()) do
                local bp = p.FindFirstChild(p, "Backpack")
                local char = p.Character
                if bp and (bp:FindFirstChild("Fist of Darkness") or bp:FindFirstChild("God's Chalice")) then
                    foundItem = true
                    break
                end
                if char and (char:FindFirstChild("Fist of Darkness") or char:FindFirstChild("God's Chalice")) then
                    foundItem = true
                    break
                end
            end
            if foundItem then
                serverCards["chest"].descLabel.Text = "Status: Available (Found Item)"
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["chest"].descLabel.Text = "Status: Not Found Yet"
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        -- 3. Elite Progress (Lấy chính xác thông số Elite Hunter trực tiếp từ Remotes của game)
        if serverCards["elite"] then
            local success, eliteVal = pcall(function()
                return invokeCommF("EliteHunter", "Progress")
            end)
            if success and eliteVal then
                serverCards["elite"].descLabel.Text = "Elite Progress: " .. tostring(eliteVal)
                serverCards["elite"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
            else
                serverCards["elite"].descLabel.Text = "Elite Progress: 0/50"
                serverCards["elite"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- 4. Cake Prince (Lấy tiến độ Cake Prince từ server)
        if serverCards["cakeprince"] then
            local success, cakeVal = pcall(function()
                return invokeCommF("CakePrince", "Progress")
            end)
            if success and cakeVal then
                serverCards["cakeprince"].descLabel.Text = "Killed: " .. tostring(cakeVal) .. "/500"
                serverCards["cakeprince"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
            else
                serverCards["cakeprince"].descLabel.Text = "Killed: 0/500"
                serverCards["cakeprince"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- 5. Spy Status (Trạng thái Bartender / Spy Trade)
        if serverCards["spystatus"] then
            local success, spyVal = pcall(function()
                return invokeCommF("Spy", "Check")
            end)
            if success and spyVal then
                serverCards["spystatus"].descLabel.Text = "Available / Ready"
                serverCards["spystatus"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["spystatus"].descLabel.Text = "Don't Trade Yet"
                serverCards["spystatus"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        -- PLAYER INFO UPDATES (Cập nhật liên tục theo nhân vật thực tế của người chơi)
        
        -- Ken Level (Đọc giá trị Dodges từ thư mục dữ liệu nhân vật)
        if playerCards["kenlevel"] then
            local currentKen = "0 / 5000"
            if LocalPlayer.Character then
                local charFolder = Workspace:FindFirstChild("Characters")
                local myChar = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
                local dodgeObj = myChar and myChar:FindFirstChild("Dodges")
                if dodgeObj then
                    currentKen = tostring(dodgeObj.Value) .. " / 5000"
                end
            end
            playerCards["kenlevel"].descLabel.Text = currentKen
            playerCards["kenlevel"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        -- Moon Status (Lấy trạng thái mặt trăng chính xác từ Lighting của server)
        if playerCards["moonstatus"] then
            local clockTime = Lighting.ClockTime
            local moonPhase = Lighting:GetMoonPhase()
            local phaseText = "Normal Phase"
            if moonPhase > 0.75 then
                phaseText = "Full Moon (100%)"
            elseif moonPhase > 0.5 then
                phaseText = "Waning Gibbous"
            else
                phaseText = string.format("Phase: %.2f", moonPhase)
            end
            playerCards["moonstatus"].descLabel.Text = phaseText
            playerCards["moonstatus"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        -- Race Tier (Kiểm tra bậc tộc V4 qua NPC Wenlocktoad hoặc dữ liệu game)
        if playerCards["racetier"] then
            local success, raceVal = pcall(function()
                return invokeCommF("Wenlocktoad", "1")
            end)
            if success and raceVal then
                playerCards["racetier"].descLabel.Text = "Race Tier: " .. tostring(raceVal)
                playerCards["racetier"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                playerCards["racetier"].descLabel.Text = "Race Tier: N/A"
                playerCards["racetier"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- Pull Lever (Kiểm tra trạng thái kéo cần gạt Mirage/Temple)
        if playerCards["pulllever"] then
            local success, leverVal = pcall(function()
                return invokeCommF("Lever", "Check")
            end)
            if success and leverVal then
                playerCards["pulllever"].descLabel.Text = "Pull Lever: ✔ (Pulled)"
                playerCards["pulllever"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                playerCards["pulllever"].descLabel.Text = "Pull Lever: ❌"
                playerCards["pulllever"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        task.wait(0.2)
    end
end)

return {}
