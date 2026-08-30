--[[
    fruit.lua
    Module: Fruit (single content, no tabs)
    Layout  : Top bar (back + search) + single content panel
    Effects : Search bar matches the rest of the suite, no scrollbar
]]

local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab    = context.Tab
local Config = context.Config or {}

-- =================== helpers ===================
local function accent()
    if Config.Rainbow or Config.RainbowMode then
        local hue = tick() % 5 / 5
        return Color3.fromHSV(hue, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3" and Config.ThemeColor or Color3.fromRGB(0, 229, 255)
end

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function corner(p, r)
    return new("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) })
end

local function stroke(p, t, tr)
    return new("UIStroke", { Parent = p, Color = accent(), Thickness = t or 1, Transparency = tr or 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end

-- =================== clean parent tab ===================
for _, c in ipairs(Tab:GetChildren()) do c:Destroy() end
Tab.BackgroundTransparency = 1
Tab.BorderSizePixel       = 0

-- =================== root ===================
local root = new("Frame", {
    Parent          = Tab,
    Size            = UDim2.new(1, -10, 0, 0),
    AutomaticSize   = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
})
new("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
new("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

-- =================== top bar (back + search) ===================
local topBar = new("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1 })

local backBtn = new("TextButton", {
    Parent = topBar, Size = UDim2.fromOffset(50, 50),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "",
})
corner(backBtn, 12)
local backStroke = stroke(backBtn, 1, 0.4)
local arrow = new("TextLabel", {
    Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "‹", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = accent(),
})

local searchBox = new("Frame", {
    Parent = topBar, Position = UDim2.new(0, 60, 0, 0), Size = UDim2.new(1, -60, 1, 0),
    BackgroundColor3 = Color3.fromRGB(12, 13, 19),
})
corner(searchBox, 12)
local searchStroke = stroke(searchBox, 1, 0.4)

new("TextLabel", {
    Parent = searchBox, Position = UDim2.new(0, 16, 0, 0), Size = UDim2.new(0, 18, 1, 0),
    BackgroundTransparency = 1, Text = "⌕", Font = Enum.Font.GothamBold, TextSize = 16,
    TextColor3 = Color3.fromRGB(140, 145, 160), TextXAlignment = Enum.TextXAlignment.Left,
})
local searchInput = new("TextBox", {
    Parent = searchBox, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -52, 1, 0),
    BackgroundTransparency = 1, ClearTextOnFocus = false,
    PlaceholderText = "search fruits...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120),
    Text = "", Font = Enum.Font.GothamMedium, TextSize = 13,
    TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left,
})

-- =================== content panel (NO scroll at all) ===================
local content = new("Frame", {
    Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 460),
    BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.25,
    BorderSizePixel = 0, ClipsDescendants = true,
})
corner(content, 14)
local contentStroke = stroke(content, 1, 0.45)
new("UIPadding", { Parent = content, PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 18), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20) })

local contentHolder = new("Frame", {
    Parent = content, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, BorderSizePixel = 0,
})
new("UIListLayout", { Parent = contentHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

-- Default placeholder
new("TextLabel", {
    Parent = contentHolder, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
    Text = "Fruit", Font = Enum.Font.GothamBold, TextSize = 18,
    TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left,
})
new("TextLabel", {
    Parent = contentHolder, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
    Text = "Module content is provided by the loader.", Font = Enum.Font.GothamMedium, TextSize = 11,
    TextColor3 = Color3.fromRGB(160, 165, 180), TextXAlignment = Enum.TextXAlignment.Left,
})

if type(context.LoadContent) == "function" then
    pcall(context.LoadContent, { Name = "Fruit" }, contentHolder)
end

-- =================== back button ===================
backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        pcall(context.BackToMain)
    elseif type(context.LoadFunction) == "function" then
        pcall(context.LoadFunction)
    end
end)

-- =================== live accent colour sync ===================
local conn
conn = RunService.RenderStepped:Connect(function()
    if not root.Parent then conn:Disconnect(); return end
    local a = accent()
    backStroke.Color = a
    searchStroke.Color = a
    contentStroke.Color = a
    arrow.TextColor3 = a
end)

return { Root = root }
