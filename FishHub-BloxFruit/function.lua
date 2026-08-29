local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}
context.Config = Config

-- ===== Đường dẫn gốc & tự tham chiếu =====
-- Nếu file này KHÔNG được host với tên "function.lua" trên GitHub, sửa FUNCTION_URL cho khớp tên thật.
local BASE_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/"
local FUNCTION_URL = BASE_URL .. "function.lua"

local function accent()
    if Config.RainbowMode then
        local speed = Config.RainbowSpeed or 0.15
        local hue = (tick() * speed) % 1
        return Color3.fromHSV(hue, 0.85, 1)
    end
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function Corner(parent, radius)
    local c = New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius)
    })
    return c
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.2,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

-- ===== Bộ nạp script từ xa (dùng chung cho mở module + quay lại trang Function) =====
local function loadRemote(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not result then return false end

    local fn = loadstring(result)
    if not fn then return false end

    return pcall(fn, context)
end

local function loadModule(fileName)
    loadRemote(BASE_URL .. fileName .. ".lua")
end

-- Các module con (shop.lua, farm.lua, item.lua, ...) sẽ gọi context.BackToFunction()
-- khi bấm nút Back để quay lại đúng trang Function này.
-- 2 alias LoadFunction/Navigate được thêm để tương thích với các file module đã tồn tại sẵn.
context.BackToFunction = function()
    loadRemote(FUNCTION_URL)
end
context.LoadFunction = function(name)
    if not name or name == "function" or name == "Function" then
        loadRemote(FUNCTION_URL)
    else
        loadModule(name)
    end
end
context.Navigate = function(name)
    context.LoadFunction(name)
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.ScrollBarImageTransparency = 1
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", {
    Parent = Tab,
    Size = UDim2.new(1, -10, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
})

New("UIPadding", {
    Parent = root,
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5)
})

local list = New("UIListLayout", {
    Parent = root,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10)
})

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

local headerGlow = New("Frame", {
    Parent = head,
    Position = UDim2.new(1, -105, 0, -56),
    Size = UDim2.fromOffset(150, 150),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0
})
Corner(headerGlow, 99)
New("UIGradient", {
    Parent = headerGlow,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
})

local headerGlow2 = New("Frame", {
    Parent = head,
    Position = UDim2.new(0, -45, 1, -35),
    Size = UDim2.fromOffset(100, 100),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.94,
    BorderSizePixel = 0
})
Corner(headerGlow2, 99)
New("UIGradient", {
    Parent = headerGlow2,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
})

local headerHighlight = New("Frame", {
    Parent = head,
    Position = UDim2.fromOffset(28, 0),
    Size = UDim2.new(1, -56, 0, 2),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0
})
Corner(headerHighlight, 2)

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
    Text = "FUNCTION",
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
    Text = "TOOLS  •  MODULES  •  UTILITIES",
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
        Tween(headerDot, 0.9, {BackgroundTransparency = 0.1}, Enum.EasingStyle.Sine)
        task.wait(0.9)
        if not headerDot.Parent then break end
        Tween(headerDot, 0.9, {BackgroundTransparency = 0.7}, Enum.EasingStyle.Sine)
        task.wait(0.9)
    end
end)

local holder = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
})

local grid = New("UIGridLayout", {
    Parent = holder,
    CellSize = UDim2.new(0.5, -5, 0, 92),
    CellPadding = UDim2.new(0, 10, 0, 10),
    FillDirectionMaxCells = 2,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local modules = {
    {"SHOP", "shop", "Shop and item utilities."},
    {"SETTING FARM", "settingfarm", "Farming preferences."},
    {"FARM", "farm", "Farming functions and controls."},
    {"ITEM", "item", "Items and quest utilities."},
    {"ISLAND", "island", "Island travel and navigation."},
    {"FRUIT", "fruit", "Fruit utilities and helpers."},
    {"SETTING", "setting", "FishHub settings and controls."},
}

local cards = {}

local function makeCard(index, data)
    local title, fileName, description = data[1], data[2], data[3]

    local card = New("TextButton", {
        Parent = holder,
        LayoutOrder = index,
        AutoButtonColor = false,
        Text = "",
        BackgroundColor3 = Color3.fromRGB(9, 10, 15),
        BackgroundTransparency = 1,
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

    local shine = New("Frame", {
        Parent = card,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accent(),
        BorderSizePixel = 0
    })
    Corner(shine, 4)

    local iconGlow = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(15 + 19, 16 + 19),
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

    New("UIGradient", {
        Parent = iconBox,
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 26, 38)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 15, 22))
        })
    })

    New("TextLabel", {
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

    local chevron = New("TextLabel", {
        Parent = card,
        Position = UDim2.new(1, -29, 0, 15),
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Text = "›",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = accent()
    })

    local state = {
        button = card,
        stroke = stroke,
        iconStroke = iconStroke,
        shine = shine,
        scale = scale,
        iconGlow = iconGlow,
        name = string.lower(title),
        fileName = fileName
    }
    cards[#cards + 1] = state

    card.MouseEnter:Connect(function()
        Tween(scale, 0.18, {Scale = 1.045}, Enum.EasingStyle.Back)
        Tween(stroke, 0.18, {Transparency = 0.05, Thickness = 1.5})
        Tween(iconBox, 0.18, {BackgroundColor3 = Color3.fromRGB(23, 26, 38)})
        Tween(shine, 0.18, {Size = UDim2.new(0, 5, 1, 0)})
        Tween(iconGlow, 0.18, {BackgroundTransparency = 0.72})
        Tween(chevron, 0.18, {Position = UDim2.new(1, -25, 0, 15)})
    end)

    card.MouseLeave:Connect(function()
        Tween(scale, 0.18, {Scale = 1})
        Tween(stroke, 0.18, {Transparency = 0.68, Thickness = 1})
        Tween(iconBox, 0.18, {BackgroundColor3 = Color3.fromRGB(17, 19, 28)})
        Tween(shine, 0.18, {Size = UDim2.new(0, 3, 1, 0)})
        Tween(iconGlow, 0.18, {BackgroundTransparency = 0.88})
        Tween(chevron, 0.18, {Position = UDim2.new(1, -29, 0, 15)})
    end)

    card.Activated:Connect(function()
        loadModule(fileName)
    end)

    task.delay(index * 0.045, function()
        if card and card.Parent then
            Tween(card, 0.3, {BackgroundTransparency = 0}, Enum.EasingStyle.Quart)
            Tween(scale, 0.32, {Scale = 1}, Enum.EasingStyle.Back)
        end
    end)
end

for i, moduleData in ipairs(modules) do
    makeCard(i, moduleData)
end

task.spawn(function()
    while root.Parent do
        local a = accent()
        accentBar.BackgroundColor3 = a
        headerDot.BackgroundColor3 = a
        headStroke.Color = a
        headerGlow.BackgroundColor3 = a
        headerGlow2.BackgroundColor3 = a
        headerHighlight.BackgroundColor3 = a

        for _, item in ipairs(cards) do
            item.stroke.Color = a
            item.iconStroke.Color = a
            item.shine.BackgroundColor3 = a
            item.iconGlow.BackgroundColor3 = a
        end

        task.wait(0.05)
    end
end)

return {
    Root = root
}
