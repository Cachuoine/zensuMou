--[[
    Script hoàn chỉnh: Quản lý và theo dõi toàn bộ Boss Sea 3 (Blox Fruits)
]]

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

-- Toàn bộ danh sách Normal Boss tại Sea 3
local normalBosses = {
    {name = "STONE", keyword = "stone"},
    {name = "ISLAND EMPRESS", keyword = "island empress"},
    {name = "KILO ADMIRAL", keyword = "kilo admiral"},
    {name = "CAPTAIN ELEPHANT", keyword = "captain elephant"},
    {name = "BEAUTIFUL PIRATE", keyword = "beautiful pirate"},
    {name = "LONGMA", keyword = "longma"},
    {name = "CAKE QUEEN", keyword = "cake queen"}
}

-- Toàn bộ danh sách Precious / Raid Boss tại Sea 3
local preciousBosses = {
    {name = "SOUL REAPER", keywords = {"soul reaper"}},
    {name = "CAKE PRINCE", keywords = {"cake prince"}},
    {name = "DOUGH KING", keywords = {"dough king"}},
    {name = "RIP_INDRA", keywords = {"rip_indra", "rip indra"}},
    {name = "TYRANT OF THE SKIES", keywords = {"tyrant of the skies", "tyrant"}}
}

local cards = {}
local layoutOrder = 0

-- Tiêu đề Normal Boss
New("TextLabel", {
    Parent = container,
    LayoutOrder = (function() layoutOrder = layoutOrder + 1 return layoutOrder end)(),
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• SEA 3 - NORMAL BOSS",
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
        Text = "Status: False",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(255, 90, 90),
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
        keyword = boss.keyword
    }
end

-- Tiêu đề Precious Boss
New("TextLabel", {
    Parent = container,
    LayoutOrder = (function() layoutOrder = layoutOrder + 1 return layoutOrder end)(),
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• SEA 3 - PRECIOUS BOSS",
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
        Text = "Status: False",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(255, 90, 90),
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
        keywords = boss.keywords
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Vòng lặp quét trạng thái tối ưu tốc độ cao (0.2 giây)
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
                local markerExist = false
                local timerText = ""

                if worldOrigin then
                    for _, obj in ipairs(worldOrigin:GetChildren()) do
                        local objNameLower = string.lower(obj.Name)
                        if string.find(objNameLower, data.keyword) then
                            markerExist = true
                            local respawnTimer = obj:FindFirstChild("RespawnTimer")
                            if respawnTimer then
                                local frame = respawnTimer:FindFirstChild("Frame")
                                if frame then
                                    local timerLabel = frame:FindFirstChild("Timer")
                                    if timerLabel then
                                        timerText = tostring(timerLabel.Text or "")
                                        timerText = string.gsub(timerText, "<[^%s>]+[^>]*>", "")
                                        timerText = string.gsub(timerText, "</[^>]+>", "")
                                        timerText = string.gsub(timerText, "^%s*(.-)%s*$", "%1")
                                    end
                                end
                            end
                            break
                        end
                    end
                end

                if markerExist then
                    data.indicator.Text = "✕"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    if timerText ~= "" and timerText ~= "0" and timerText ~= "00:00" then
                        data.statusLabel.Text = "Status: False: " .. timerText
                    else
                        data.statusLabel.Text = "Status: False"
                    end
                    data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
                else
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = "Status: True"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                end

            elseif data.type == "precious" then
                local found = false

                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local enemyNameLower = string.lower(enemy.Name)
                        for _, kw in ipairs(data.keywords) do
                            if string.find(enemyNameLower, kw) then
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
                    data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
                end
            end
        end

        task.wait(0.2)
    end
end)

return {}
