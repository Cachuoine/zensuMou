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

-- Danh sách Normal Boss kèm tên Marker chuẩn trong _WorldOrigin để bắt sự kiện xuất hiện tức thì
local normalBosses = {
    {name = "STONE", keyword = "stone", markerName = "STONE Respawn Marker"},
    {name = "HYDRA LEADER", keyword = "hydra leader", markerName = "Hydra Leader Respawn Marker"},
    {name = "Kilo Admiral", keyword = "kilo admiral", markerName = "Kilo Admiral Respawn Marker"},
    {name = "Captain Elephant", keyword = "captain elephant", markerName = "Captain Elephant Respawn Marker"},
    {name = "Beautiful Pirate", keyword = "beautiful pirate", markerName = "Beautiful Pirate Respawn Marker"},
    {name = "Longma", keyword = "longma", markerName = "Longma Respawn Marker"},
    {name = "Cake Queen", keyword = "cake queen", markerName = "Cake Queen Respawn Marker"}
}

local preciousBosses = {
    {name = "Soul Reaper", keywords = {"soul reaper"}, markerName = "Soul Reaper Respawn Marker"},
    {name = "Cake Prince", keywords = {"cake prince"}, markerName = "Cake Prince Respawn Marker"},
    {name = "Dough King", keywords = {"dough king"}, markerName = "Dough King Respawn Marker"},
    {name = "Rip_Indra", keywords = {"rip_indra", "rip indra"}, markerName = "rip_indra Respawn Marker"},
    {name = "Tyrant of the Skies", keywords = {"tyrant of the skies", "tyrant"}, markerName = "Tyrant Respawn Marker"}
}

local cards = {}
local layoutOrder = 0

-- Tiêu đề Normal Boss
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• NORMAL BOSS",
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(180, 190, 210),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Note chung cho Normal Boss
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "Note: Must be within island range to scan boss info.",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(130, 140, 160),
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
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        keyword = boss.keyword,
        markerName = boss.markerName
    }
end

-- Tiêu đề Precious Boss
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• PRECIOUS BOSS",
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(180, 190, 210),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Note chung cho Precious Boss
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "Note: Must be within island range to scan boss info.",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(130, 140, 160),
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
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        keywords = boss.keywords,
        markerName = boss.markerName
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Sử dụng RunService.Heartbeat để quét cực nhanh thay vì task.wait(1) giúp bắt sát thời gian thực
RunService.Heartbeat:Connect(function()
    if not alive or not container.Parent then return end

    local a = accent()
    container.ScrollBarImageColor3 = a

    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")

    for name, data in pairs(cards) do
        data.stroke.Color = a
        data.badgeStroke.Color = a

        local markerFound = nil
        if worldOrigin then
            -- Quét chính xác theo tên Marker hoặc tìm kiếm theo từ khóa linh hoạt bên trong _WorldOrigin
            markerFound = worldOrigin:FindFirstChild(data.markerName)
            if not markerFound and data.keyword then
                for _, obj in ipairs(worldOrigin:GetChildren()) do
                    if string.find(string.lower(obj.Name), data.keyword) then
                        markerFound = obj
                        break
                    end
                end
            elseif not markerFound and data.keywords then
                for _, obj in ipairs(worldOrigin:GetChildren()) do
                    local objNameLower = string.lower(obj.Name)
                    for _, kw in ipairs(data.keywords) do
                        if string.find(objNameLower, kw) then
                            markerFound = obj
                            break
                        end
                    end
                    if markerFound then break end
                end
            end
        end

        -- Nếu marker xuất hiện nghĩa là boss đã chết -> Lấy thời gian từ RespawnTimer.Frame.Timer
        if markerFound then
            local respawnTimer = markerFound:FindFirstChild("RespawnTimer")
            local frame = respawnTimer and respawnTimer:FindFirstChild("Frame")
            local timerLabel = frame and frame:FindFirstChild("Timer")

            local timerText = ""
            if timerLabel and timerLabel.Text ~= "" then
                timerText = tostring(timerLabel.Text)
                -- Lọc bỏ các thẻ HTML tags nếu có
                timerText = string.gsub(timerText, "<[^%s>]+[^>]*>", "")
                timerText = string.gsub(timerText, "</[^>]+>", "")
                timerText = string.gsub(timerText, "^%s*(.-)%s*$", "%1")
            end

            data.indicator.Text = "✕"
            data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)

            if timerText ~= "" and timerText ~= "0" and timerText ~= "00:00" then
                data.statusLabel.Text = "Status: False: " .. timerText
            else
                data.statusLabel.Text = "Status: False"
            end
            data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
        else
            -- Không có marker nghĩa là boss đang sống (True)
            data.indicator.Text = "✓"
            data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
            data.statusLabel.Text = "Status: True"
            data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
        end
    end
end)

return {}
