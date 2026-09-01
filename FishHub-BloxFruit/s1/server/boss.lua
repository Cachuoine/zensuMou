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

local normalBosses = {
    {name = "STONE", keyword = "stone", position = Vector3.new(-1109.92603, 58.3789978, 6811.7251)},
    {name = "HYDRA LEADER", keyword = "hydra leader", position = Vector3.new(-1109.92603, 58.3789978, 6811.7251)},
    {name = "Kilo Admiral", keyword = "kilo admiral", position = Vector3.new(2998.29492, 513.794006, -7344.32178)},
    {name = "Captain Elephant", keyword = "captain elephant", position = Vector3.new(-13365.5293, 321.230988, -8484.99023)},
    {name = "Beautiful Pirate", keyword = "beautiful pirate", position = Vector3.new(5367.31348, 26.3950043, -64.7008362)},
    {name = "Longma", keyword = "longma", position = Vector3.new(-10156.2227, 337.778015, -9445.86523)},
    {name = "Cake Queen", keyword = "cake queen", position = Vector3.new(-678.478027, 386.856995, -11114.3457)}
}

local preciousBosses = {
    {name = "Soul Reaper", keywords = {"soul reaper"}, position = Vector3.new(-9522.2334, 314.747986, 6789.48193)},
    {name = "Cake Prince", keywords = {"cake prince"}, position = Vector3.new(-2089.86597, 4536.92383, -14800.0068)},
    {name = "Dough King", keywords = {"dough king"}, position = Vector3.new(-2089.86597, 4536.92383, -14800.0068)},
    {name = "Rip_Indra", keywords = {"rip_indra", "rip indra"}, position = Vector3.new(-5395.71582, 319.981995, -2588.76001)},
    {name = "Tyrant of the Skies", keywords = {"tyrant of the skies", "tyrant"}, position = Vector3.new(-5395.71582, 319.981995, -2588.76001)}
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

-- Note chung đặt ở đầu phần Normal Boss
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
        Text = "✕", -- Đổi lại thành dấu nhân chuẩn
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
        position = boss.position
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

-- Note chung đặt ở đầu phần Precious Boss
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
        Text = "✕", -- Đổi lại thành dấu nhân chuẩn
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
        position = boss.position
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
        local localPlayer = Players.LocalPlayer
        local char = localPlayer and localPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        for name, data in pairs(cards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a

            -- Kiểm tra khoảng cách tới đảo (trong phạm vi 350 studs)
            local isNear = false
            if rootPart then
                local dist = (rootPart.Position - data.position).Magnitude
                if dist <= 350 then
                    isNear = true
                end
            end

            if data.type == "normal" then
                local markerExist = false
                local timerText = ""

                if isNear and worldOrigin then
                    for _, obj in ipairs(worldOrigin:GetChildren()) do
                        local objNameLower = string.lower(obj.Name)
                        if string.find(objNameLower, data.keyword) then
                            local respawnTimer = obj:FindFirstChild("RespawnTimer")
                            if respawnTimer then
                                local frame = respawnTimer:FindFirstChild("Frame")
                                if frame then
                                    local timerLabel = frame:FindFirstChild("Timer")
                                    if timerLabel then
                                        timerText = tostring(timerLabel.Text or "")
                                        timerText = string.gsub(timerText, "<[^%s>]+[^>]*>", "")
                                        timerText = string.gsub(timerText, "</[^>]+>", "")
                                        timerText = string.gsub(timerText, "^%s*(.-)%s*$', "%1")
                                        
                                        -- Chỉ xác nhận có timer (False) khi đoạn code RespawnTimer...Timer thực sự xuất hiện và có nội dung thời gian hợp lệ
                                        if timerText ~= "" and timerText ~= "0" and timerText ~= "00:00" then
                                            markerExist = true
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end

                -- Nếu đường dẫn code RespawnTimer không xuất hiện / không ở gần -> Mặc định True (Boss đang sống hoặc chưa quét thấy), ngược lại hiện Status: False kèm time màu đỏ
                if markerExist then
                    data.indicator.Text = "✕"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    data.statusLabel.Text = "Status: False: " .. timerText
                    data.statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
                else
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = "Status: True"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                end

            elseif data.type == "precious" then
                local found = false

                if isNear and enemiesFolder then
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

                if found and isNear then
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

        task.wait(1)
    end
end)

return {}
