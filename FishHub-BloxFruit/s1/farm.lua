--[[ 
    FishHub Blox Fruit - farm.lua
    Boss man, updated with tabs: farm, fishing, miss.
]]--
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

local container = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 320), BackgroundTransparency = 1 })

local menuFrame = New("Frame", { Parent = container, Size = UDim2.new(0.3, -5, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(menuFrame, 10)
local menuStroke = Stroke(menuFrame, 1, 0.4)

New("UIListLayout", { Parent = menuFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center })
New("UIPadding", { Parent = menuFrame, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

local divider = New("Frame", { Parent = container, Position = UDim2.new(0.3, 0, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = accent(), BackgroundTransparency = 0.3 })

local contentFrame = New("Frame", { Parent = container, Position = UDim2.new(0.3, 8, 0, 0), Size = UDim2.new(0.7, -8, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)

local contentScroll = New("ScrollingFrame", { Parent = contentFrame, Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y })
New("UIListLayout", { Parent = contentScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

local displayText = New("TextLabel", { Parent = contentScroll, Size = UDim2.new(1, 0, 0, 200), BackgroundTransparency = 1, Text = "Select a farm tab...", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.fromRGB(200, 205, 220), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top })

local tabsData = {
    { Name = "farm", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/farm.lua" },
    { Name = "fishing", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/fishing.lua" },
    { Name = "miss", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/missfarm.lua" },
}

local activeTabButton = nil

for _, data in ipairs(tabsData) do
    local tabBtn = New("TextButton", { Parent = menuFrame, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(18, 20, 30), AutoButtonColor = false, Text = data.Name:upper(), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(180, 185, 200) })
    Corner(tabBtn, 8)
    Stroke(tabBtn, 1, 0.7)

    tabBtn.MouseEnter:Connect(function()
        if tabBtn ~= activeTabButton then
            TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 32, 48) }):Play()
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if tabBtn ~= activeTabButton then
            TweenService:Create(tabBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(18, 20, 30) }):Play()
        end
    end)

    tabBtn.Activated:Connect(function()
        if activeTabButton == tabBtn then return end
        activeTabButton = tabBtn

        for _, child in ipairs(menuFrame:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(18, 20, 30) }):Play()
                child.TextColor3 = Color3.fromRGB(180, 185, 200)
            end
        end

        TweenService:Create(tabBtn, TweenInfo.new(0.12), { BackgroundColor3 = accent() }):Play()
        tabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)

        displayText.Text = "Loading farm telemetry..."
        task.spawn(function()
            local success, result = pcall(function()
                return game:HttpGet(data.Url)
            end)
            if success and result then
                displayText.Text = result
            else
                displayText.Text = "Failed to load content for " .. data.Name
            end
        end)
    end)
end

local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then
        connection:Disconnect()
        return
    end
    local a = accent()
    menuStroke.Color = a
    contentStroke.Color = a
    divider.BackgroundColor3 = a
    if activeTabButton then
        activeTabButton.BackgroundColor3 = a
        activeTabButton.TextColor3 = Color3.fromRGB(15, 15, 20)
    end
end)

return { Root = root }
