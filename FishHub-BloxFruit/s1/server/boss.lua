local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

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

-- Danh sách Normal Boss (Kiểm tra RespawnTimer trong _WorldOrigin)
local normalBosses = {
    {name = "STONE", markerName = "STONE Respawn Marker", cframe = CFrame.new(-1109.92603, 58.3789978, 6811.7251, 0.275688112, -0, -0.961247265, 0, 1, -0, 0.961247265, 0, 0.275688112)},
    {name = "HYDRA LEADER", markerName = "HYDRA LEADER Respawn Marker", cframe = CFrame.new(-1109.92603, 58.3789978, 6811.7251, 0.275688112, -0, -0.961247265, 0, 1, -0, 0.961247265, 0, 0.275688112)},
    {name = "Kilo Admiral", markerName = "KILO ADMIRAL Respawn Marker", cframe = CFrame.new(2998.29492, 513.794006, -7344.32178, 0.207885921, 0, 0.97815311, 0, 1, 0, -0.97815311, 0, 0.207885921)},
    {name = "Captain Elephant", markerName = "CAPTAIN ELEPHANT Respawn Marker", cframe = CFrame.new(-13365.5293, 321.230988, -8484.99023, -0.997842431, 0, 0.0656556115, 0, 1, 0, -0.0656556115, 0, -0.997842431)},
    {name = "Beautiful Pirate", markerName = "BEAUTIFUL PIRATE Respawn Marker", cframe = CFrame.new(5367.31348, 26.3950043, -64.7008362, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
    {name = "Longma", markerName = "LONGMA Respawn Marker", cframe = CFrame.new(-10156.2227, 337.778015, -9445.86523, -0.0348494053, 0, 0.999392569, 0, 1, 0, -0.999392569, 0, -0.0348494053)},
    {name = "Cake Queen", markerName = "CAKE QUEEN Respawn Marker", cframe = CFrame.new(-678.478027, 386.856995, -11114.3457, -0.93524456, 0, 0.354002535, 0, 1, 0, -0.354002535, 0, -0.93524456)}
}

-- Danh sách Precious Boss / Boss điều kiện (Kiểm tra sự xuất hiện trong Enemies)
local preciousBosses = {
    {name = "Soul Reaper", keywords = {"Soul Reaper"}, cframe = CFrame.new(-9522.2334, 314.747986, 6789.48193, 0.999388874, -0, -0.0349550731, 0, 1, -0, 0.0349550731, 0, 0.999388874)},
    {name = "Cake Prince", keywords = {"Cake Prince"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {name = "Dough King", keywords = {"Dough King"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {name = "Rip_Indra", keywords = {"rip_indra", "Rip_Indra"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)},
    {name = "Tyrant of the Skies", keywords = {"Tyrant of the Skies", "Tyrant"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)}
}

local cards = {}
local layoutOrder = 0

-- Tiêu đề Normal Boss trên đầu dấu chấm
local normalHeader = New("TextLabel", {
    Parent = container,
    LayoutOrder = (function() layoutOrder = layoutOrder + 1 return layoutOrder end)(),
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• NORMAL BOSS",
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(180, 190, 210),
    TextXAlignment = Enum.TextXAlignment.Left
})

for _, boss in ipairs(normalBosses) do
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
        Size = UDim2.new(1, -90, 0, 20),
        BackgroundTransparency = 1,
        Text = boss.name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 33),
        Size = UDim2.new(1, -90, 0, 20),
        BackgroundTransparency = 1,
        Text = boss.name .. "->False:",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local badge = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = Color3.fromRGB(22, 25, 37),
        BorderSizePixel = 0
    })
    Corner(badge, 8)
    local badgeStroke = Stroke(badge, 1, 0.4)

    local indicator = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[boss.name] = {
        type = "normal",
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        markerName = boss.markerName,
        cframe = boss.cframe
    }
end

-- Tiêu đề Precious Boss trên đầu dấu chấm
local preciousHeader = New("TextLabel", {
    Parent = container,
    LayoutOrder = (function() layoutOrder = layoutOrder + 1 return layoutOrder end)(),
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• PRECIOUS BOSS",
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(180, 190, 210),
    TextXAlignment = Enum.TextXAlignment.Left
})

for _, boss in ipairs(preciousBosses) do
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
        Size = UDim2.new(1, -90, 0, 20),
        BackgroundTransparency = 1,
        Text = boss.name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 33),
        Size = UDim2.new(1, -90, 0, 20),
        BackgroundTransparency = 1,
        Text = boss.name .. "->False",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local badge = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = Color3.fromRGB(22, 25, 37),
        BorderSizePixel = 0
    })
    Corner(badge, 8)
    local badgeStroke = Stroke(badge, 1, 0.4)

    local indicator = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[boss.name] = {
        type = "precious",
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        keywords = boss.keywords,
        cframe = boss.cframe
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Hàm quét khoảng cách người chơi quanh tâm CFrame của boss (Phạm vi vô hạn mét)
local function isPlayerNearby(bossCFrame)
    if not bossCFrame then return true end
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return true end
    local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    return true -- Quét toàn bộ tầm vô hạn theo yêu cầu
end

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        local enemiesFolder = Workspace:FindFirstChild("Enemies")

        for name, data in pairs(cards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a

            if data.type == "normal" then
                local isNear = isPlayerNearby(data.cframe)
                local foundTimer = false
                local timerText = ""

                if worldOrigin and isNear then
                    local marker = worldOrigin:FindFirstChild(data.markerName)
                    if marker then
                        local respawnTimer = marker:FindFirstChild("RespawnTimer")
                        if respawnTimer then
                            local frame = respawnTimer:FindFirstChild("Frame")
                            if frame then
                                local timerLabel = frame:FindFirstChild("Timer")
                                if timerLabel and timerLabel:IsA("TextLabel") then
                                    timerText = timerLabel.Text or ""
                                    if timerText ~= "" and timerText ~= "0" and timerText ~= "00:00" then
                                        foundTimer = true
                                    end
                                end
                            end
                        end
                    end
                end

                if foundTimer then
                    data.indicator.Text = "✕"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    data.statusLabel.Text = name .. "->False: " .. timerText
                    data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                else
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = name .. "->True:"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                end

            elseif data.type == "precious" then
                local isNear = isPlayerNearby(data.cframe)
                local found = false

                if enemiesFolder and isNear then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local enemyName = enemy.Name
                        for _, kw in ipairs(data.keywords) do
                            if enemyName == kw or string.find(string.lower(enemyName), string.lower(kw)) then
                                found = true
                                break
                            end
                        end
                        if found then break end
                    end
                end

                if found then
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = "Status: True"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                else
                    data.indicator.Text = "✕"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    data.statusLabel.Text = "Status: False"
                    data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                end
            end
        end

        task.wait(0.2)
    end
end)

return {}
