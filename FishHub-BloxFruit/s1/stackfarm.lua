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

local root = New("Frame", { Parent = Tab, Size = UDim2.new(1, -10, 0, 420), BackgroundTransparency = 1 })
New("UIPadding", { Parent = root, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })

local leftPane = New("Frame", { Parent = root, Size = UDim2.new(0, 130, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(leftPane, 12)
local leftStroke = Stroke(leftPane, 1, 0.4)
New("UIPadding", { Parent = leftPane, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
New("UIListLayout", { Parent = leftPane, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

local divider = New("Frame", { Parent = root, Position = UDim2.new(0, 140, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = accent(), BackgroundTransparency = 0.3 })

local rightPane = New("Frame", { Parent = root, Position = UDim2.new(0, 150, 0, 0), Size = UDim2.new(1, -150, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(rightPane, 12)
local rightStroke = Stroke(rightPane, 1, 0.6)
New("UIPadding", { Parent = rightPane, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) })

local contentLabel = New("TextLabel", { Parent = rightPane, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "Select a tab...", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.fromRGB(200, 205, 220), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top })

local indicator = New("Frame", { Parent = leftPane, Size = UDim2.new(0, 3, 0, 0), BackgroundColor3 = accent() })
Corner(indicator, 2)

local tabsData = {
    { Name = "Item", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/stackfarm/item.lua" },
    { Name = "Quest", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/stackfarm/quest.lua" },
}

local function loadUrlContent(url)
    contentLabel.Text = "Loading..."
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result then
            contentLabel.Text = result
        else
            contentLabel.Text = "Failed to load content from URL."
        end
    end)
end

local tabButtons = {}

for i, data in ipairs(tabsData) do
    local btn = New("TextButton", { Parent = leftPane, LayoutOrder = i, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Color3.fromRGB(18, 20, 30), AutoButtonColor = false, Text = data.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(180, 185, 200) })
    Corner(btn, 8)
    
    btn.Activated:Connect(function()
        for _, b in ipairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(18, 20, 30), TextColor3 = Color3.fromRGB(180, 185, 200) }):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = accent(), TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        
        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 3, 0, btn.AbsoluteSize.Y),
            Position = UDim2.new(0, -5, 0, btn.AbsolutePosition.Y - leftPane.AbsolutePosition.Y)
        }):Play()

        loadUrlContent(data.Url)
    end)
    
    table.insert(tabButtons, btn)
    if i == 1 then
        task.defer(function()
            btn.Activated:Fire()
        end)
    end
end

local connection
connection = RunService.RenderStepped:Connect(function()
    if not root.Parent then
        connection:Disconnect()
        return
    end
    local a = accent()
    leftStroke.Color = a
    rightStroke.Color = a
    divider.BackgroundColor3 = a
    indicator.BackgroundColor3 = a
end)

return { Root = root }
