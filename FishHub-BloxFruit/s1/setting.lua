local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

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
Tab.AutomaticCanvasSize = Enum.AutomaticSize.None

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 })
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) })

local topBar = New("Frame", { Parent = root, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1 })
local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(40, 40), BackgroundColor3 = Color3.fromRGB(12, 13, 19), AutoButtonColor = false, Text = "" })
Corner(backBtn, 10)
local backStroke = Stroke(backBtn, 1, 0.4)
local arrowLabel = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "←", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = accent() })

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 48, 0, 0), Size = UDim2.new(1, -48, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(searchBox, 10)
local searchStroke = Stroke(searchBox, 1, 0.4)
New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = "🔍", TextSize = 13 })
New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 35, 0, 0), Size = UDim2.new(1, -45, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "Search settings...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

local mainLayout = New("Frame", { Parent = root, Position = UDim2.new(0, 0, 0, 48), Size = UDim2.new(1, 0, 1, -48), BackgroundTransparency = 1 })

local leftMenu = New("ScrollingFrame", { Parent = mainLayout, Size = UDim2.new(0.32, -4, 1, 0), BackgroundColor3 = Color3.fromRGB(10, 11, 16), BorderSizePixel = 0, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y })
Corner(leftMenu, 10)
local leftStroke = Stroke(leftMenu, 1, 0.6)
New("UIListLayout", { Parent = leftMenu, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
New("UIPadding", { Parent = leftMenu, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

local divider = New("Frame", { Parent = mainLayout, Position = UDim2.new(0.32, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = accent(), BorderSizePixel = 0, BackgroundTransparency = 0.4 })

local rightContent = New("ScrollingFrame", { Parent = mainLayout, Position = UDim2.new(0.32, 6, 0, 0), Size = UDim2.new(0.68, -6, 1, 0), BackgroundColor3 = Color3.fromRGB(10, 11, 16), BorderSizePixel = 0, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y })
Corner(rightContent, 10)
local rightStroke = Stroke(rightContent, 1, 0.6)
New("UIPadding", { Parent = rightContent, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })

local tabsData = {
    {name = "config", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/setting/config.lua"},
    {name = "theme UI", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/setting/themeUI.lua"},
}

local currentSelectedBtn = nil
local animLine = New("Frame", { Parent = leftMenu, Size = UDim2.new(0, 3, 0, 32), BackgroundColor3 = accent(), BorderSizePixel = 0, ZIndex = 5 })
Corner(animLine, 2)

local function loadTabContent(url)
    for _, child in ipairs(rightContent:GetChildren()) do
        if child:IsA("GuiObject") and child ~= rightStroke and child.Name ~= "UIPadding" then
            child:Destroy()
        end
    end
    local success, result = pcall(function() return game:HttpGet(url) end)
    local textVal = (success and result) or "Không thể tải nội dung hoặc URL trống."
    
    local textLabel = New("TextLabel", {
        Parent = rightContent,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = textVal,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(200, 205, 220),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
end

for i, tabInfo in ipairs(tabsData) do
    local tabBtn = New("TextButton", {
        Parent = leftMenu,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(15, 17, 25),
        BackgroundTransparency = 0.3,
        AutoButtonColor = false,
        Text = "",
    })
    Corner(tabBtn, 8)
    
    letLabel = New("TextLabel", {
        Parent = tabBtn,
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = tabInfo.name:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(170, 175, 190),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    tabBtn.MouseButton1Click:Connect(function()
        if currentSelectedBtn == tabBtn then return end
        currentSelectedBtn = tabBtn
        
        for _, child in ipairs(leftMenu:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 17, 25)}):Play()
            end
        end
        TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 28, 40)}):Play()
        TweenService:Create(animLine, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -3, 0, tabBtn.AbsolutePosition.Y - leftMenu.AbsolutePosition.Y + leftMenu.CanvasPosition.Y)}):Play()
        
        loadTabContent(tabInfo.url)
    end)

    if i == 1 then
        currentSelectedBtn = tabBtn
        tabBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
        task.defer(function()
            animLine.Position = UDim2.new(1, -3, 0, tabBtn.AbsolutePosition.Y - leftMenu.AbsolutePosition.Y)
            loadTabContent(tabInfo.url)
        end)
    end
end

backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then context.BackToMain()
    elseif type(context.LoadFunction) == "function" then context.LoadFunction() end
end)

RunService.RenderStepped:Connect(function()
    if not root.Parent then return end
    local a = accent()
    backStroke.Color = a
    searchStroke.Color = a
    leftStroke.Color = a
    rightStroke.Color = a
    divider.BackgroundColor3 = a
    arrowLabel.TextColor3 = a
    animLine.BackgroundColor3 = a
end)

return { Root = root }
