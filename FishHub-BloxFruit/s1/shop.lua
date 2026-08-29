local TweenService = game:GetService("TweenService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

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
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius) })
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

local function Tween(obj, duration, props)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- Quay lại trang Function chính. Ưu tiên BackToFunction (do function.lua cấp),
-- fallback sang LoadFunction/Navigate nếu context được tạo bởi phiên bản khác.
local function goBack()
    if type(context.BackToFunction) == "function" then
        context.BackToFunction()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction("function")
    elseif type(context.Navigate) == "function" then
        context.Navigate("function")
    end
end

for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", {
    Parent = Tab,
    Size = UDim2.new(1, -10, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
})
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- ===== Top bar: nút Back + thanh tìm kiếm =====
local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1 })

local backBtn = New("TextButton", {
    Parent = topBar,
    Size = UDim2.fromOffset(45, 45),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19),
    AutoButtonColor = false,
    Text = ""
})
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local backIcon = New("TextLabel", {
    Parent = backBtn,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "←",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = accent()
})

local searchBox = New("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 55, 0, 0),
    Size = UDim2.new(1, -55, 1, 0),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19)
})
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)

local searchIcon = New("TextLabel", {
    Parent = searchBox,
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(0, 20, 1, 0),
    BackgroundTransparency = 1,
    Text = "🔍",
    TextSize = 14,
    TextColor3 = accent()
})

New("TextBox", {
    Parent = searchBox,
    Position = UDim2.new(0, 40, 0, 0),
    Size = UDim2.new(1, -50, 1, 0),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    PlaceholderText = "search...",
    PlaceholderColor3 = Color3.fromRGB(100, 105, 120),
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(240, 242, 248),
    TextXAlignment = Enum.TextXAlignment.Left
})

backBtn.MouseEnter:Connect(function() Tween(backStroke, 0.15, {Transparency = 0.05}) end)
backBtn.MouseLeave:Connect(function() Tween(backStroke, 0.15, {Transparency = 0.4}) end)
backBtn.Activated:Connect(goBack)

-- ===== Nội dung Shop (chèn nội dung thật vào contentFrame bên dưới) =====
local contentFrame = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = Color3.fromRGB(9, 10, 15),
    BackgroundTransparency = 0.5
})
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)
New("UIPadding", { Parent = contentFrame, PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) })

New("TextLabel", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "SHOP ITEMS & UPGRADES",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(200, 205, 220),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = contentFrame,
    Position = UDim2.new(0, 0, 0, 26),
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Text = "Nội dung Shop hiển thị tại đây. Gắn thêm nút mua / danh sách vật phẩm vào contentFrame.",
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(130, 135, 150),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- ===== Cập nhật theme / rainbow liên tục =====
task.spawn(function()
    while root.Parent do
        local a = accent()
        backStroke.Color = a
        backIcon.TextColor3 = a
        searchStroke.Color = a
        searchIcon.TextColor3 = a
        contentStroke.Color = a
        task.wait(0.05)
    end
end)

return { Root = root, ContentFrame = contentFrame }
