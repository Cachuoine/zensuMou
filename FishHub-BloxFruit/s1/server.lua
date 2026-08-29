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
New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

-- TRANG TRÍ CONTENT FRAME (VẪN GIỮ NGUYÊN KHUNG MẪU, CHỈ LÀM ĐẸP GIAO DIỆN HIỂN THỊ TRẠNG THÁI SERVER THUẦN TÚY)
local contentFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 210), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)

-- Tiêu đề trạng thái server (Chỉ mang tính chất trang trí)
local statusTitle = New("TextLabel", { Parent = contentFrame, Position = UDim2.new(0, 16, 0, 16), Size = UDim2.new(1, -32, 0, 20), BackgroundTransparency = 1, Text = "🌐 Server Status", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left })

local statusDesc = New("TextLabel", { Parent = contentFrame, Position = UDim2.new(0, 16, 0, 38), Size = UDim2.new(1, -32, 0, 40), BackgroundTransparency = 1, Text = "Current connection state and environment details for this game session.", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(140, 145, 165), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true })

-- Khung hiển thị mẫu giao diện trang trí (Không có hàm code chạy chức năng ngầm)
local badgeContainer = New("Frame", { Parent = contentFrame, Position = UDim2.new(0, 16, 0, 90), Size = UDim2.new(1, -32, 0, 95), BackgroundColor3 = Color3.fromRGB(13, 15, 22), BackgroundTransparency = 0.6 })
Corner(badgeContainer, 8)
Stroke(badgeContainer, 1, 0.8)

local function createRow(yPos, labelText, valText, valColor)
    local row = New("Frame", { Parent = badgeContainer, Position = UDim2.new(0, 12, 0, yPos), Size = UDim2.new(1, -24, 0, 24), BackgroundTransparency = 1 })
    New("TextLabel", { Parent = row, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(180, 185, 200), TextXAlignment = Enum.TextXAlignment.Left })
    New("TextLabel", { Parent = row, Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = valText, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = valColor or Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Right })
end

createRow(10, "Connection State", "Connected", Color3.fromRGB(46, 204, 113))
createRow(38, "Environment", "Live Server", Color3.fromRGB(52, 152, 219))
createRow(66, "Module Mode", "Visual Only", Color3.fromRGB(241, 196, 15))

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
    statusTitle.TextColor3 = a
end)

return { Root = root }[cite: 1]
```[cite: 1]
