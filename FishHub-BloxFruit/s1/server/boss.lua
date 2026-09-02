local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Hàm gọi CommF / CommF_ an toàn
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

-- Danh sách Normal Boss giữ nguyên hoàn toàn
local normalBosses = {
    {name = "STONE", keyword = "stone"},
    {name = "HYDRA LEADER", keyword = "hydra leader"},
    {name = "Kilo Admiral", keyword = "kilo admiral"},
    {name = "Captain Elephant", keyword = "captain elephant"},
    {name = "Beautiful Pirate", keyword = "beautiful pirate"},
    {name = "Longma", keyword = "longma"},
    {name = "Cake Queen", keyword = "cake queen"}
}

-- Danh sách Precious Boss (Sửa phần boss quý theo yêu cầu kết hợp Enemies và CommF)
local preciousBosses = {
    {name = "Soul Reaper", keywords = {"soul reaper"}},
    {name = "Cake Prince", keywords = {"cake prince"}},
    {name = "Dough King", keywords = {"dough king"}},
    {name = "Rip_Indra", keywords = {"rip_indra", "rip indra"}},
    {name = "Tyrant of the Skies", keywords = {"tyrant of the skies", "tyrant"}}
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
    Text = "• SEA3 | NORMAL BOSS",
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
layoutOrder = layoutOrder + 1
New("TextLabel", {
    Parent = container,
    LayoutOrder = layoutOrder,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• SEA3 | PRECIOUS BOSS",
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

-- Cache lưu trữ thời gian đếm ngược khi marker boss thường biến mất khỏi _WorldOrigin
local cachedTimers = {}

RunService.Heartbeat:Connect(function()
    if not alive or not container.Parent then return end

    local a = accent()
    container.ScrollBarImageColor3 = a

    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
    local enemiesFolder = Workspace:FindFirstChild("Enemies")

    for name, data in pairs(cards) do
        data.stroke.Color = a
        data.badgeStroke.Color = a

        if data.type == "normal" then
            local markerFound = nil
            if worldOrigin then
                for _, obj in ipairs(worldOrigin:GetChildren()) do
                    if string.find(string.lower(obj.Name), data.keyword) then
                        markerFound = obj
                        break
                    end
                end
            end

            if markerFound then
                local respawnTimer = markerFound:FindFirstChild("RespawnTimer")
                local frame = respawnTimer and respawnTimer:FindFirstChild("Frame")
                local timerLabel = frame and frame:FindFirstChild("Timer")

                local timerText = ""
                if timerLabel and timerLabel.Text ~= "" then
                    timerText = tostring(timerLabel.Text)
                    timerText = string.gsub(timerText, "<[^%s>]+[^>]*>", "")
                    timerText = string.gsub(timerText, "</[^>]+>", "")
                    timerText = string.gsub(timerText, "^%s*(.-)%s*$", "%1")
                end

                if timerText ~= "" and timerText ~= "0" and timerText ~= "00:00" then
                    cachedTimers[name] = timerText
                end

                data.indicator.Text = "×"
                data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                if cachedTimers[name] then
                    data.statusLabel.Text = "Status: False: " .. cachedTimers[name]
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

            -- Kiểm tra trực tiếp trong workspace.Enemies
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

            -- Kiểm tra dự phòng qua CommF / CommF_ nếu cần thiết dựa trên tên boss
            if not found then
                local remoteCheck = invokeCommF(name, "Check") or invokeCommF("Get" .. name)
                if remoteCheck == true or remoteCheck == "True" then
                    found = true
                end
            end

            if found then
                data.indicator.Text = "✓"
                data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                data.statusLabel.Text = "Status: True"
                data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
            else
                data.indicator.Text = "×"
                data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                data.statusLabel.Text = "Status: False"
                data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            end
        end
    end
end)

return {}
