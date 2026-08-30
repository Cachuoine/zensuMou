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
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 })
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1 })

local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(45, 45), BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "" })
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local arrowLabel = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "←", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = accent() })

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 55, 0, 0), Size = UDim2.new(1, -55, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)

New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = "🔍", TextSize = 14 })
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

local splitContainer = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 360), BackgroundTransparency = 1 })

local menuContainer = New("Frame", { Parent = splitContainer, Size = UDim2.new(0.32, -5, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(menuContainer, 12)
local menuStroke = Stroke(menuContainer, 1, 0.5)
New("UIPadding", { Parent = menuContainer, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })
New("UIListLayout", { Parent = menuContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

local contentContainer = New("Frame", { Parent = splitContainer, Position = UDim2.new(0.32, 5, 0, 0), Size = UDim2.new(0.68, -5, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(contentContainer, 12)
local contentStroke = Stroke(contentContainer, 1, 0.6)
New("UIPadding", { Parent = contentContainer, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })

local contentScroll = New("ScrollingFrame", { Parent = contentContainer, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y })
New("UIListLayout", { Parent = contentScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

local tabsData = {
    { Name = "sword shop", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/shop/sword.lua" },
    { Name = "gun shop", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/shop/gun.lua" },
    { Name = "fighting shop", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/shop/melee.lua" },
    { Name = "miss", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/shop/missshop.lua" }
}

local activeTabButton = nil
local contentCache = {}

local function loadUrlContent(url)
    for _, child in ipairs(contentScroll:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") then child:Destroy() end
    end
    
    if contentCache[url] then
        New("TextLabel", { Parent = contentScroll, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = contentCache[url], Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(210, 215, 230), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true })
        return
    end

    local loadingLabel = New("TextLabel", { Parent = contentScroll, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Loading content...", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(150, 155, 170), TextXAlignment = Enum.TextXAlignment.Left })
    
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        loadingLabel:Destroy()
        if success then
            contentCache[url] = result
            New("TextLabel", { Parent = contentScroll, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = result, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(210, 215, 230), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true })
        else
            New("TextLabel", { Parent = contentScroll, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "Failed to load content from URL.", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.fromRGB(255, 100, 100), TextXAlignment = Enum.TextXAlignment.Left })
        end
    end)
end

for i, data in ipairs(tabsData) do
    local btn = New("TextButton", { Parent = menuContainer, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(16, 18, 26), AutoButtonColor = false, Text = "" })
    Corner(btn, 8)
    
    local indicator = New("Frame", { Parent = btn, Size = UDim2.new(0, 3, 1, -8), Position = UDim2.new(0, 4, 0, 4), BackgroundColor3 = accent(), BackgroundTransparency = 1 })
    Corner(indicator, 2)
    
    local label = New("TextLabel", { Parent = btn, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -20, 1, 0), BackgroundTransparency = 1, Text = data.Name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(180, 185, 200), TextXAlignment = Enum.TextXAlignment.Left })

    btn.Activated:Connect(function()
        if activeTabButton == btn then return end
        if activeTabButton then
            TweenService:Create(activeTabButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(16, 18, 26) }):Play()
            local oldInd = activeTabButton:FindFirstChildOfClass("Frame")
            if oldInd then TweenService:Create(oldInd, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play() end
            local oldLbl = activeTabButton:FindFirstChildOfClass("TextLabel")
            if oldLbl then TweenService:Create(oldLbl, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(180, 185, 200) }):Play() end
        end
        activeTabButton = btn
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(24, 27, 38) }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(label, TweenInfo.new(0.2), { TextColor3 = accent() }):Play()
        
        loadUrlContent(data.Url)
    end)

    if i == 1 then
        activeTabButton = btn
        btn.BackgroundColor3 = Color3.fromRGB(24, 27, 38)
        indicator.BackgroundTransparency = 0
        label.TextColor3 = accent()
        loadUrlContent(data.Url)
    end
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
    menuStroke.Color = a
    contentStroke.Color = a
    arrowLabel.TextColor3 = a
end)

return { Root = root }
