local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

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
Tab.ScrollingEnabled = false

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 })

local topBar = New("Frame", { Parent = root, Size = UDim2.new(1, -10, 0, 45), Position = UDim2.new(0, 5, 0, 8), BackgroundTransparency = 1 })

local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(45, 45), BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "" })
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local arrowLabel = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "←", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = accent() })

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 55, 0, 0), Size = UDim2.new(1, -55, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)
New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = "🔍", TextSize = 14 })
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

local mainLayout = New("Frame", { Parent = root, Position = UDim2.new(0, 5, 0, 61), Size = UDim2.new(1, -10, 1, -69), BackgroundTransparency = 1 })

local leftMenu = New("Frame", { Parent = mainLayout, Size = UDim2.new(0, 140, 1, 0), BackgroundColor3 = Color3.fromRGB(10, 11, 16) })
Corner(leftMenu, 10)
local leftStroke = Stroke(leftMenu, 1, 0.5)

local menuList = New("UIListLayout", { Parent = leftMenu, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
New("UIPadding", { Parent = leftMenu, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

local divider = New("Frame", { Parent = mainLayout, Position = UDim2.new(0, 146, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = accent(), BorderSizePixel = 0 })

local rightContent = New("Frame", { Parent = mainLayout, Position = UDim2.new(0, 154, 0, 0), Size = UDim2.new(1, -154, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(rightContent, 10)
local contentStroke = Stroke(rightContent, 1, 0.6)

local contentInner = New("ScrollingFrame", { Parent = rightContent, Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0) })
New("UIListLayout", { Parent = contentInner, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

local tabsData = {
    { Name = "item", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/stackfarm/item.lua" },
    { Name = "quest", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/stackfarm/quest.lua" }
}

local function loadTabContent(url)
    for _, c in ipairs(contentInner:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    local textLabel = New("TextLabel", {
        Parent = contentInner,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(210, 215, 230),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Text = success and result or "Error loading content from URL."
    })
end

local tabButtons = {}
for i, data in ipairs(tabsData) do
    local btn = New("TextButton", {
        Parent = leftMenu,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(15, 17, 25),
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = i
    })
    Corner(btn, 8)
    
    local indicator = New("Frame", {
        Parent = btn,
        Size = UDim2.new(0, 3, 0.7, 0),
        Position = UDim2.new(0, 0, 0.15, 0),
        BackgroundColor3 = accent(),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })
    Corner(indicator, 2)

    local lbl = New("TextLabel", {
        Parent = btn,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = data.Name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(170, 175, 195),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    table.insert(tabButtons, { Button = btn, Indicator = indicator, Label = lbl, Url = data.Url })
end

local function selectTab(index)
    for idx, item in ipairs(tabButtons) do
        if idx == index then
            TweenService:Create(item.Button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(25, 28, 42) }):Play()
            TweenService:Create(item.Indicator, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(item.Label, TweenInfo.new(0.2), { TextColor3 = accent() }):Play()
            loadTabContent(item.Url)
        else
            TweenService:Create(item.Button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(15, 17, 25) }):Play()
            TweenService:Create(item.Indicator, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(item.Label, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(170, 175, 195) }):Play()
        end
    end
end

for idx, item in ipairs(tabButtons) do
    item.Button.Activated:Connect(function()
        selectTab(idx)
    end)
end

if #tabButtons > 0 then
    selectTab(1)
end

backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then
        connection:Disconnect()
        return
    end
    local a = accent()
    backStroke.Color = a
    searchStroke.Color = a
    contentStroke.Color = a
    leftStroke.Color = a
    arrowLabel.TextColor3 = a
    divider.BackgroundColor3 = a
    for _, item in ipairs(tabButtons) do
        item.Indicator.BackgroundColor3 = a
    end
end)

return { Root = root }
