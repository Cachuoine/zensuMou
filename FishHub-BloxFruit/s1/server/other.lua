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

-- Hàm gọi CommF an toàn tối ưu cho Blox Fruits
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

-- Nhóm 1: Server Info
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
    {key = "chest", title = "Chest Forecast (Fist / Chalice)", desc = "Scanning server..."},
    {key = "elite", title = "Elite Progress", desc = "Fetching data..."},
    {key = "cakeprince", title = "Cake Prince", desc = "Fetching data..."},
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

    serverCards[info.key] = {card = card, stroke = stroke, descLabel = descLabel}
end

-- Nhóm 2: Player Info
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
    {key = "kenlevel", title = "Ken Level (Dodges)", desc = "Synchronizing..."},
    {key = "moonstatus", title = "Moon Status", desc = "Synchronizing..."},
    {key = "racetier", title = "Race Tier", desc = "Synchronizing..."},
    {key = "pulllever", title = "Pull Lever", desc = "Synchronizing..."}
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

-- Mốc thời gian thực tế của Server dựa vào DistributedGameTime
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

        -- 2. Chest Forecast (Quét kỹ balo & nhân vật của toàn bộ người chơi trong server xem có Fist / Chalice không)
        if serverCards["chest"] then
            local foundItemName = nil
            for _, p in ipairs(Players:GetPlayers()) do
                local bp = p:FindFirstChild("Backpack")
                local char = p.Character
                
                local function checkContainer(cont)
                    if not cont then return end
                    for _, item in ipairs(cont:GetChildren()) do
                        if item.Name == "Fist of Darkness" or item.Name == "God's Chalice" then
                            return item.Name
                        end
                    end
                end
                
                foundItemName = checkContainer(bp) or checkContainer(char)
                if foundItemName then break end
            end
            
            if foundItemName then
                serverCards["chest"].descLabel.Text = "Found: " .. foundItemName
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["chest"].descLabel.Text = "No Special Item in Server"
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        -- 3. Elite Progress (Lấy dữ liệu thật từ Server qua CommF)
        if serverCards["elite"] then
            local eliteVal = invokeCommF("EliteHunter", "Progress")
            if eliteVal ~= nil then
                serverCards["elite"].descLabel.Text = "Killed/Progress: " .. tostring(eliteVal)
                serverCards["elite"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
            else
                serverCards["elite"].descLabel.Text = "Not Available / No Data"
                serverCards["elite"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- 4. Cake Prince Progress
        if serverCards["cakeprince"] then
            local cakeVal = invokeCommF("CakePrince", "Progress")
            if cakeVal ~= nil then
                serverCards["cakeprince"].descLabel.Text = "Progress: " .. tostring(cakeVal) .. "/500"
                serverCards["cakeprince"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
            else
                serverCards["cakeprince"].descLabel.Text = "Progress: 0/500 (Not Spawned)"
                serverCards["cakeprince"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- 5. Spy Status
        if serverCards["spystatus"] then
            local spyVal = invokeCommF("Spy", "Check")
            if spyVal == true or spyVal == 1 then
                serverCards["spystatus"].descLabel.Text = "Status: Available / Ready"
                serverCards["spystatus"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["spystatus"].descLabel.Text = "Status: Cooldown / Not Ready"
                serverCards["spystatus"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        -- PLAYER INFO UPDATES
        
        -- Ken Level (Lấy trực tiếp từ giá trị Dodges trong thư mục Character thực tế)
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

        -- Moon Status (Đọc trực tiếp Lighting ClockTime và GetMoonPhase của server thực tế)
        if playerCards["moonstatus"] then
            local moonPhase = Lighting:GetMoonPhase()
            local clockTime = Lighting.ClockTime
            local phaseStr = "Normal"
            if moonPhase > 0.75 then
                phaseStr = "Full Moon (100%)"
            elseif clockTime >= 18 or clockTime < 6 then
                phaseStr = string.format("Night (Phase: %.2f)", moonPhase)
            else
                phaseStr = string.format("Day (Phase: %.2f)", moonPhase)
            end
            playerCards["moonstatus"].descLabel.Text = phaseStr
            playerCards["moonstatus"].descLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end

        -- Race Tier (Kiểm tra trạng thái Tộc qua hệ thống game)
        if playerCards["racetier"] then
            local raceVal = invokeCommF("Wenlocktoad", "1")
            if raceVal then
                playerCards["racetier"].descLabel.Text = "Tier/Status: " .. tostring(raceVal)
                playerCards["racetier"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                playerCards["racetier"].descLabel.Text = "Tier: Not Unlocked / V3/V4"
                playerCards["racetier"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- Pull Lever
        if playerCards["pulllever"] then
            local leverVal = invokeCommF("Lever", "Check")
            if leverVal then
                playerCards["pulllever"].descLabel.Text = "Pull Lever: Pulled (✔)"
                playerCards["pulllever"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                playerCards["pulllever"].descLabel.Text = "Pull Lever: Not Yet (❌)"
                playerCards["pulllever"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        task.wait(1)
    end
end)

return {}
