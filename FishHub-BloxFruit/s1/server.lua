local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    if Config.Rainbow or Config.RainbowMode then
        local hue = tick() % 5 / 5
        return Color3.fromHSV(hue, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius) })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", { Parent = parent, Color = accent(), Thickness = thickness or 1, Transparency = transparency or 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end

for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- HEADER TRANG TRÍ CHUẨN SERVER STATUS
local head = New("Frame", {
    Parent = root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 66),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BorderSizePixel = 0
})
Corner(head, 14)
local headStroke = Stroke(head, 1, 0.35)

New("UIGradient", {
    Parent = head,
    Rotation = 18,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 31)),
        ColorSequenceKeypoint.new(0.62, Color3.fromRGB(9, 10, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 7, 12))
    })
})

local accentBar = New("Frame", {
    Parent = head,
    Position = UDim2.fromOffset(12, 14),
    Size = UDim2.fromOffset(4, 38),
    BackgroundColor3 = accent(),
    BorderSizePixel = 0
})
Corner(accentBar, 4)

New("TextLabel", {
    Parent = head,
    Position = UDim2.fromOffset(28, 9),
    Size = UDim2.new(1, -42, 0, 25),
    BackgroundTransparency = 1,
    Text = "SERVER STATUS",
    Font = Enum.Font.GothamBlack,
    TextSize = 17,
    TextColor3 = Color3.fromRGB(245, 246, 252),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = head,
    Position = UDim2.fromOffset(28, 36),
    Size = UDim2.new(1, -42, 0, 17),
    BackgroundTransparency = 1,
    Text = "PERFORMANCE  •  LATENCY  •  UPTIME",
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextColor3 = Color3.fromRGB(125, 130, 145),
    TextXAlignment = Enum.TextXAlignment.Left
})

local headerDot = New("Frame", {
    Parent = head,
    Position = UDim2.new(1, -28, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(7, 7),
    BackgroundColor3 = accent(),
    BorderSizePixel = 0
})
Corner(headerDot, 99)

task.spawn(function()
    while headerDot.Parent do
        TweenService:Create(headerDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.1}):Play()
        task.wait(0.9)
        if not headerDot.Parent then break end
        TweenService:Create(headerDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play()
        task.wait(0.9)
    end
end)

-- KHUNG CHỨA THÔNG TIN SERVER (GIỮ NGUYÊN CẤU TRÚC, LÀM ĐẸP GIAO DIỆN)
local holder = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
})

New("UIGridLayout", {
    Parent = holder,
    CellSize = UDim2.new(0.5, -5, 0, 92),
    CellPadding = UDim2.new(0, 10, 0, 10),
    FillDirectionMaxCells = 2,
    SortOrder = Enum.SortOrder.LayoutOrder
})

-- Danh sách các thẻ thông tin Server Status (Mô phỏng tĩnh chất server, không thêm chức năng ngoài)
local serverCardsData = {
    {"PING", "Latency", "Server connection delay."},
    {"FPS", "Frames", "Client rendering rate."},
    {"PLAYERS", "Users", "Connected players count."},
    {"UPTIME", "Time", "Session active duration."},
    {"REGION", "Area", "Server host location."},
    {"MEMORY", "RAM", "Client memory usage."},
}

local cards = {}

local function makeServerCard(index, data)
    local title, subtitle, description = data[1], data[2], data[3]

    local card = New("Frame", {
        Parent = holder,
        LayoutOrder = index,
        BackgroundColor3 = Color3.fromRGB(9, 10, 15),
        BackgroundTransparency = 0,
        BorderSizePixel = 0
    })
    Corner(card, 14)

    New("UIGradient", {
        Parent = card,
        Rotation = 100,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 15, 23)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 14))
        })
    })

    local stroke = Stroke(card, 1, 0.68)
    local scale = New("UIScale", {Parent = card, Scale = 0.92})

    local iconGlow = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(34, 35),
        Size = UDim2.fromOffset(50, 50),
        BackgroundColor3 = accent(),
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0
    })
    Corner(iconGlow, 99)

    local iconBox = New("Frame", {
        Parent = card,
        Position = UDim2.fromOffset(15, 16),
        Size = UDim2.fromOffset(38, 38),
        BackgroundColor3 = Color3.fromRGB(17, 19, 28),
        BorderSizePixel = 0
    })
    Corner(iconBox, 11)
    local iconStroke = Stroke(iconBox, 1, 0.72)

    local titleLabelText = New("TextLabel", {
        Parent = iconBox,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = string.sub(title, 1, 1),
        Font = Enum.Font.GothamBlack,
        TextSize = 13,
        TextColor3 = accent()
    })

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(66, 14),
        Size = UDim2.new(1, -92, 0, 22),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(66, 37),
        Size = UDim2.new(1, -82, 0, 34),
        BackgroundTransparency = 1,
        Text = description,
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextColor3 = Color3.fromRGB(112, 117, 132),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    local badge = New("TextLabel", {
        Parent = card,
        Position = UDim2.new(1, -38, 0, 14),
        Size = UDim2.fromOffset(26, 16),
        BackgroundTransparency = 1,
        Text = subtitle,
        Font = Enum.Font.GothamBold,
        TextSize = 7,
        TextColor3 = accent(),
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local state = {
        stroke = stroke,
        iconStroke = iconStroke,
        iconGlow = iconGlow,
        titleLabelText = titleLabelText,
        badge = badge
    }
    cards[#cards + 1] = state

    task.delay(index * 0.045, function()
        if card and card.Parent then
            TweenService:Create(scale, TweenInfo.new(0.32, Enum.EasingStyle.Back), {Scale = 1}):Play()
        end
    end)
end

for i, data in ipairs(serverCardsData) do
    makeServerCard(i, data)
end

-- Vòng lặp cập nhật màu sắc và hiệu ứng giao diện mượt mà theo từng frame
local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then
        connection:Disconnect()
        return
    end
    local a = accent()
    accentBar.BackgroundColor3 = a
    headerDot.BackgroundColor3 = a
    headStroke.Color = a

    for _, item in ipairs(cards) do
        if item.stroke and item.stroke.Parent then
            item.stroke.Color = a
            item.iconStroke.Color = a
            item.iconGlow.BackgroundColor3 = a
            if item.titleLabelText then
                item.titleLabelText.TextColor3 = a
            end
            if item.badge then
                item.badge.TextColor3 = a
            end
        end
    end
end)

return { Root = Tab }
