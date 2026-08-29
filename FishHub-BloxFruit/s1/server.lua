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
New("UIListLayout", { Parent = root, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12) })

local topBar = New("Frame", { Parent = root, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1 })

local backBtn = New("TextButton", { Parent = topBar, Size = UDim2.fromOffset(50, 50), BackgroundColor3 = Color3.fromRGB(14, 16, 24), AutoButtonColor = false, Text = "" })
Corner(backBtn, 14)
local backStroke = Stroke(backBtn, 1, 0.4)
New("UIGradient", { Parent = backBtn, Rotation = 45, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 37)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 20)) }) })

local arrowLabel = New("TextLabel", { Parent = backBtn, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "←", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = accent() })

local searchBox = New("Frame", { Parent = topBar, Position = UDim2.new(0, 60, 0, 0), Size = UDim2.new(1, -60, 1, 0), BackgroundColor3 = Color3.fromRGB(14, 16, 24) })
Corner(searchBox, 14)
local searchStroke = Stroke(searchBox, 1, 0.4)
New("UIGradient", { Parent = searchBox, Rotation = 45, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 37)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 20)) }) })

local searchIconGlow = New("Frame", { Parent = searchBox, Position = UDim2.new(0, 10, 0.5, -16), Size = UDim2.fromOffset(32, 32), BackgroundColor3 = accent(), BackgroundTransparency = 0.85, BorderSizePixel = 0 })
Corner(searchIconGlow, 99)

New("TextLabel", { Parent = searchBox, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 28, 1, 0), BackgroundTransparency = 1, Text = "🔍", TextSize = 14 })
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 48, 0, 0), Size = UDim2.new(1, -58, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "Search server status...", PlaceholderColor3 = Color3.fromRGB(110, 115, 135), Text = "", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

local contentFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 220), BackgroundColor3 = Color3.fromRGB(10, 11, 17), BackgroundTransparency = 0.3 })
Corner(contentFrame, 16)
local contentStroke = Stroke(contentFrame, 1, 0.6)
New("UIGradient", { Parent = contentFrame, Rotation = 90, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 18, 27)), ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 14)) }) })

local contentInner = New("Frame", { Parent = contentFrame, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
New("UIPadding", { Parent = contentInner, PaddingTop = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20) })
New("UIListLayout", { Parent = contentInner, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center })

local statusDot = New("Frame", { Parent = contentInner, LayoutOrder = 1, Size = UDim2.fromOffset(12, 12), BackgroundColor3 = accent(), BorderSizePixel = 0 })
Corner(statusDot, 99)

New("TextLabel", { Parent = contentInner, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = "SERVER STATUS", Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = Color3.fromRGB(245, 246, 252), TextXAlignment = Enum.TextXAlignment.Center })

New("TextLabel", { Parent = contentInner, LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "Module Content Area — Everything is running smoothly and ready.", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(130, 135, 155), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center })

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
    arrowLabel.TextColor3 = a
    statusDot.BackgroundColor3 = a
    searchIconGlow.BackgroundColor3 = a
end)

return { Root = root }
