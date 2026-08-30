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
New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search setting farm...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

local mainLayoutFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 320), BackgroundTransparency = 1 })

local leftMenu = New("ScrollingFrame", { Parent = mainLayoutFrame, Size = UDim2.new(0.3, -5, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y })
Corner(leftMenu, 12)
local leftStroke = Stroke(leftMenu, 1, 0.6)
New("UIListLayout", { Parent = leftMenu, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
New("UIPadding", { Parent = leftMenu, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

local divider = New("Frame", { Parent = mainLayoutFrame, Position = UDim2.new(0.3, 0, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = accent(), BackgroundTransparency = 0.4 })

local rightContent = New("ScrollingFrame", { Parent = mainLayoutFrame, Position = UDim2.new(0.3, 8, 0, 0), Size = UDim2.new(0.7, -8, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y })
Corner(rightContent, 12)
local rightStroke = Stroke(rightContent, 1, 0.6)
New("UIPadding", { Parent = rightContent, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })

local contentText = New("TextLabel", { Parent = rightContent, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "Loading content...", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(200, 205, 220), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true })

local tabsData = {
    { Name = "setting farm", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm/misssettingfarm.lua" },
    { Name = "hold & select skill", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm/hold%26selectskill.lua" },
}

local currentSelectedTab = nil

local function loadTabContent(url)
    contentText.Text = "Loading..."
    task.spawn(function()
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success and result then
            contentText.Text = result
        else
            contentText.Text = "Failed to load content from URL."
        end
    end)
end

for i, data in ipairs(tabsData) do
    local tabBtn = New("TextButton", { Parent = leftMenu, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(15, 17, 24), AutoButtonColor = false, Text = "", LayoutOrder = i })
    Corner(tabBtn, 8)
    
    local indicator = New("Frame", { Parent = tabBtn, Size = UDim2.new(0, 3, 0.7, 0), Position = UDim2.new(0, 0, 0.15, 0), BackgroundColor3 = accent(), BackgroundTransparency = 1 })
    Corner(indicator, 2)
    
    local label = New("TextLabel", { Parent = tabBtn, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -12, 1, 0), BackgroundTransparency = 1, Text = data.Name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(170, 175, 190), TextXAlignment = Enum.TextXAlignment.Left })

    tabBtn.Activated:Connect(function()
        if currentSelectedTab == tabBtn then return end
        if currentSelectedTab then
            TweenService:Create(currentSelectedTab, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(15, 17, 24) })
            local oldInd = currentSelectedTab:FindFirstChild("Frame")
            if oldInd then TweenService:Create(oldInd, TweenInfo.new(0.2), { BackgroundTransparency = 1 }) end
            local oldLbl = currentSelectedTab:FindFirstChild("TextLabel")
            if oldLbl then TweenService:Create(oldLbl, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(170, 175, 190) }) end
        end
        currentSelectedTab = tabBtn
        TweenService:Create(tabBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(22, 25, 37) })
        TweenService:Create(indicator, TweenInfo.new(0.2), { BackgroundTransparency = 0 })
        TweenService:Create(label, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(255, 255, 255) })
        
        loadTabContent(data.Url)
    end)

    if i == 1 then
        currentSelectedTab = tabBtn
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 37)
        indicator.BackgroundTransparency = 0
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadTabContent(data.Url)
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
    leftStroke.Color = a
    rightStroke.Color = a
    divider.BackgroundColor3 = a
    arrowLabel.TextColor3 = a
end)

return { Root = root }
