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

-- Danh sách Normal Boss (Sử dụng từ khóa để tìm kiếm linh hoạt trong _WorldOrigin)
local normalBosses = {
    {name = "STONE", keyword = "stone", cframe = CFrame.new(-1109.92603, 58.3789978, 6811.7251, 0.275688112, -0, -0.961247265, 0, 1, -0, 0.961247265, 0, 0.275688112)},
    {name = "HYDRA LEADER", keyword = "hydra leader", cframe = CFrame.new(-1109.92603, 58.3789978, 6811.7251, 0.275688112, -0, -0.961247265, 0, 1, -0, 0.961247265, 0, 0.275688112)},
    {name = "Kilo Admiral", keyword = "kilo admiral", cframe = CFrame.new(2998.29492, 513.794006, -7344.32178, 0.207885921, 0, 0.97815311, 0, 1, 0, -0.97815311, 0, 0.207885921)},
    {name = "Captain Elephant", keyword = "captain elephant", cframe = CFrame.new(-13365.5293, 321.230988, -8484.99023, -0.997842431, 0, 0.0656556115, 0, 1, 0, -0.0656556115, 0, -0.997842431)},
    {name = "Beautiful Pirate", keyword = "beautiful pirate", cframe = CFrame.new(5367.31348, 26.3950043, -64.7008362, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
    {name = "Longma", keyword = "longma", cframe = CFrame.new(-10156.2227, 337.778015, -9445.86523, -0.0348494053, 0, 0.999392569, 0, 1, 0, -0.999392569, 0, -0.0348494053)},
    {name = "Cake Queen", keyword = "cake queen", cframe = CFrame.new(-678.478027, 386.856995, -11114.3457, -0.93524456, 0, 0.354002535, 0, 1, 0, -0.354002535, 0, -0.93524456)}
}

-- Danh sách Precious Boss / Boss điều kiện
local preciousBosses = {
    {name = "Soul Reaper", keywords = {"soul reaper"}, cframe = CFrame.new(-9522.2334, 314.747986, 6789.48193, 0.999388874, -0, -0.0349550731, 0, 1, -0, 0.0349550731, 0, 0.999388874)},
    {name = "Cake Prince", keywords = {"cake prince"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {name = "Dough King", keywords = {"dough king"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {name = "Rip_Indra", keywords = {"rip_indra", "rip indra"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)},
    {name = "Tyrant of the Skies", keywords = {"tyrant of the skies", "tyrant"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)}
}

local cards = {}
local layoutOrder = 0

-- Tiêu đề Normal Boss
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
        keyword = boss.keyword,
        cframe = boss.cframe
    }
end

-- Tiêu đề Precious Boss
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
        keywords = boss.keywords,
        cframe = boss.cframe
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

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
                    -- Full màu đỏ cho toàn bộ dòng chữ trạng thái False và thời gian
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
                    -- Full màu đỏ cho precious boss khi ở trạng thái False
                    data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
                end
            end
        end

        task.wait(0.2)
    end
end)

return {}
