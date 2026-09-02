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

-- Hàm gọi CommF an toàn
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
    {key = "uptime", title = "Server Uptime", desc = "Calculating..."},
    {key = "timeinserver", title = "Time in Server", desc = "00h 00m 00s"},
    {key = "chest", title = "Chest Forecast (Fist / Chalice)", desc = "Checking status..."},
    {key = "elite", title = "Elite Progress", desc = "Progress: 0"},
    {key = "cakeprince", title = "Cake Prince", desc = "Killed: 0/500"},
    {key = "spystatus", title = "Spy Status", desc = "Don't Trade Yet"},
    {key = "placeid", title = "Place ID", desc = tostring(game.PlaceId)},
    {key = "jobid", title = "Job ID", desc = tostring(game.JobId)}
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
    {key = "kenlevel", title = "Ken Level", desc = "0 / 5000"},
    {key = "moonstatus", title = "Moon Status", desc = "Phase: Calculating..."},
    {key = "racetier", title = "Race Tier", desc = "N/A"},
    {key = "pulllever", title = "Pull Lever", desc = "Pull Lever: ❌"}
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

local joinTime = tick()

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        for _, c in pairs(serverCards) do c.stroke.Color = a end
        for _, c in pairs(playerCards) do c.stroke.Color = a end

        -- 1. Server Uptime & Time in Server
        local uptimeSec = os.time() - (Workspace:GetAttribute("ServerStartTime") or os.time())
        if uptimeSec < 0 then uptimeSec = 0 end
        local upH = math.floor(uptimeSec / 3600)
        local upM = math.floor((uptimeSec % 3600) / 60)
        local upS = uptimeSec % 60
        if serverCards["uptime"] then
            serverCards["uptime"].descLabel.Text = string.format("%02dh %02dm %02ds", upH, upM, upS)
        end

        local personalTime = math.floor(tick() - joinTime)
        local pH = math.floor(personalTime / 3600)
        local pM = math.floor((personalTime % 3600) / 60)
        local pS = personalTime % 60
        if serverCards["timeinserver"] then
            serverCards["timeinserver"].descLabel.Text = string.format("%02dh %02dm %02ds", pH, pM, pS)
        end

        -- 2. Chest Forecast (Fist of Darkness / God's Chalice)
        if serverCards["chest"] then
            local hasSpecialItem = false
            for _, player in ipairs(Players:GetPlayers()) do
                local backpack = player:FindFirstChild("Backpack")
                local char = player.Character
                if backpack and (backpack:FindFirstChild("Fist of Darkness") or backpack:FindFirstChild("God's Chalice")) then
                    hasSpecialItem = true
                    break
                end
                if char and (char:FindFirstChild("Fist of Darkness") or char:FindFirstChild("God's Chalice")) then
                    hasSpecialItem = true
                    break
                end
            end
            if hasSpecialItem then
                serverCards["chest"].descLabel.Text = "Item Detected in Server!"
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["chest"].descLabel.Text = "No Special Item Found Yet"
                serverCards["chest"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- 3. Elite Progress
        if serverCards["elite"] then
            local eliteCount = invokeCommF("EliteHunter", "Progress") or 0
            serverCards["elite"].descLabel.Text = "Elite Progress: " .. tostring(eliteCount)
        end

        -- 4. Cake Prince
        if serverCards["cakeprince"] then
            local cakeProgress = invokeCommF("CakePrince", "Progress") or "0/500"
            serverCards["cakeprince"].descLabel.Text = "Killed: " .. tostring(cakeProgress)
        end

        -- 5. Spy Status
        if serverCards["spystatus"] then
            local spy = invokeCommF("Spy", "Check")
            if spy then
                serverCards["spystatus"].descLabel.Text = "Available / Ready"
                serverCards["spystatus"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                serverCards["spystatus"].descLabel.Text = "Don't Trade Yet"
                serverCards["spystatus"].descLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -- PLAYER INFO UPDATES
        -- Ken Level (đọc từ Dodges Value đã phân tích trước đó)
        if playerCards["kenlevel"] and LocalPlayer.Character then
            local charFolder = Workspace:FindFirstChild("Characters")
            local myCharFolder = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
            local dodgesVal = myCharFolder and myCharFolder:FindFirstChild("Dodges")
            local currentDodges = dodgesVal and dodgesVal.Value or 0
            playerCards["kenlevel"].descLabel.Text = currentDodges .. " / 5000"
        end

        -- Moon Status
        if playerCards["moonstatus"] then
            local moonPhase = Lighting:GetMoonPhase()
            playerCards["moonstatus"].descLabel.Text = string.format("Phase: %.2f (Sea 3)", moonPhase)
        end

        -- Race Tier & Pull Lever
        if playerCards["racetier"] then
            local raceInfo = invokeCommF("Wenlocktoad", "1")
            playerCards["racetier"].descLabel.Text = "Race Tier: Active"
        end

        if playerCards["pulllever"] then
            local leverChecked = invokeCommF("Lever", "Check")
            if leverChecked then
                playerCards["pulllever"].descLabel.Text = "Pull Lever: ✔"
                playerCards["pulllever"].descLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                playerCards["pulllever"].descLabel.Text = "Pull Lever: ❌"
                playerCards["pulllever"].descLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end

        task.wait(1)
    end
end)

return {}
