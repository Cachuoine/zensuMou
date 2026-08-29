local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

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
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search server status...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

-- KHU VỰC SERVER STATUS ĐƯỢC TRANG TRÍ LẠI ĐẸP MẮT
local contentFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 240), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.4 })
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)

-- Tiêu đề nhỏ bên trong khung Server Status
local headerTitle = New("TextLabel", { Parent = contentFrame, Position = UDim2.new(0, 15, 0, 12), Size = UDim2.new(1, -30, 0, 20), BackgroundTransparency = 1, Text = "⚡ SERVER PERFORMANCE", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left })

local infoList = New("Frame", { Parent = contentFrame, Position = UDim2.new(0, 12, 0, 40), Size = UDim2.new(1, -24, 1, -50), BackgroundTransparency = 1 })
New("UIListLayout", { Parent = infoList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

-- Hàm tạo các dòng trạng thái phong cách thẻ (card)
local function createStatusRow(layoutOrder, labelText, initialValue)
    local row = New("Frame", { Parent = infoList, LayoutOrder = layoutOrder, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(15, 17, 26), BackgroundTransparency = 0.6 })
    Corner(row, 8)
    Stroke(row, 1, 0.8)
    
    New("TextLabel", { Parent = row, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(180, 185, 200), TextXAlignment = Enum.TextXAlignment.Left })
    
    local valLabel = New("TextLabel", { Parent = row, Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(1, -24, 1, 0), BackgroundTransparency = 1, Text = initialValue, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Right })
    
    return valLabel
end

local fpsVal = createStatusRow(1, "Frames Per Second (FPS)", "60 FPS")
local pingVal = createStatusRow(2, "Network Ping", "0 ms")
local playersVal = createStatusRow(3, "Server Players", "1 / 1")
local uptimeVal = createStatusRow(4, "Session Uptime", "00:00:00")

local startTime = tick()

backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

local lastUpdate = 0
local frameCount = 0

local connection
connection = RunService.RenderStepped:Connect(function(dt)
    if not root.Parent then
        connection:Disconnect()
        return
    end
    
    -- Cập nhật màu sắc động theo Theme / Rainbow
    local a = accent()
    backStroke.Color = a
    searchStroke.Color = a
    contentStroke.Color = a
    arrowLabel.TextColor3 = a
    headerTitle.TextColor3 = a

    -- Cập nhật thông số Server Status mượt mà mỗi khung hình
    frameCount = frameCount + 1
    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.5 then
        local currentFPS = math.floor(frameCount / lastUpdate)
        fpsVal.Text = currentFPS .. " FPS"
        
        local p = Players.LocalPlayer
        if p and p:GetNetworkPing() then
            pingVal.Text = math.floor(p:GetNetworkPing() * 1000) .. " ms"
        else
            pingVal.Text = "N/A"
        end
        
        playersVal.Text = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
        
        local uptime = math.floor(tick() - startTime)
        local hours = math.floor(uptime / 3600)
        local minutes = math.floor((uptime % 3600) / 60)
        local seconds = uptime % 60
        uptimeVal.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        
        frameCount = 0
        lastUpdate = 0
    end
end)

return { Root = root }[cite: 1]
```[cite: 1]
