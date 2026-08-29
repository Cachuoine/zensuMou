local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Clipboard = setclipboard or toclipboard

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
New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search status...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

-- Khung chính phân chia Trái/Phải sang trọng, hiện đại
local contentFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 240), BackgroundColor3 = Color3.fromRGB(10, 11, 16), BackgroundTransparency = 0.3 })
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)

-- Bên trái luôn nhỏ hơn bên phải (Trái 28%, Phải 72%)
local leftPanel = New("Frame", { Parent = contentFrame, Size = UDim2.new(0.28, -2, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 })
local rightPanel = New("Frame", { Parent = contentFrame, Size = UDim2.new(0.72, -2, 1, 0), Position = UDim2.new(0.28, 2, 0, 0), BackgroundTransparency = 1 })

-- Đường kẻ dọc ngăn cách đẹp mắt
local divider = New("Frame", { Parent = contentFrame, Size = UDim2.new(0, 1, 1, -20), Position = UDim2.new(0.28, 0, 0, 10), BackgroundColor3 = Color3.fromRGB(35, 40, 55), BorderSizePixel = 0 })

-- Cấu hình Phần Trái (Hệ thống Tab chuẩn phong cách active phát sáng)
New("UIPadding", { Parent = leftPanel, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 4) })
New("UIListLayout", { Parent = leftPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

New("TextLabel", { Parent = leftPanel, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "MENU", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(110, 115, 135), TextXAlignment = Enum.TextXAlignment.Left })

-- Tab ID mẫu (Đang được chọn -> Phát sáng / Active state)
local idTabBtn = New("TextButton", { Parent = leftPanel, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(22, 26, 38), AutoButtonColor = false, Text = "" })
Corner(idTabBtn, 8)
local idTabStroke = Stroke(idTabBtn, 1, 0.2) -- Viền sáng hơn giả dạng đang chọn tab này
local idTabText = New("TextLabel", { Parent = idTabBtn, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "  📌 ID Info", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left })

-- Cấu hình Phần Phải (Hiển thị chi tiết ID Game & Place từng số độc lập để copy)
New("UIPadding", { Parent = rightPanel, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) })
New("UIListLayout", { Parent = rightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

New("TextLabel", { Parent = rightPanel, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "CLICK SPECIFIC ID TO COPY", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(110, 115, 135), TextXAlignment = Enum.TextXAlignment.Left })

local gameIdVal = tostring(game.GameId)
local placeIdVal = tostring(game.PlaceId)

-- Hàm tạo các dòng ID tinh tế, đẹp và tương tác click chính xác từng số
local function createIdRow(labelTitle, idValue)
    local row = New("Frame", { Parent = rightPanel, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Color3.fromRGB(14, 16, 24) })
    Corner(row, 8)
    local rowStroke = Stroke(row, 1, 0.7)
    
    New("TextLabel", { Parent = row, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 80, 1, 0), BackgroundTransparency = 1, Text = labelTitle, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(160, 165, 185), TextXAlignment = Enum.TextXAlignment.Left })
    
    -- Nút bấm bao quanh đúng phần hiển thị số ID để copy riêng biệt
    local copyBtn = New("TextButton", { Parent = row, Position = UDim2.new(1, -165, 0, 6), Size = UDim2.new(0, 155, 1, -12), BackgroundColor3 = Color3.fromRGB(20, 23, 33), AutoButtonColor = false, Text = "" })
    Corner(copyBtn, 6)
    local copyStroke = Stroke(copyBtn, 1, 0.5)
    
    local idLabel = New("TextLabel", { Parent = copyBtn, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = idValue, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(230, 235, 250), TextXAlignment = Enum.TextXAlignment.Center })
    
    copyBtn.Activated:Connect(function()
        if Clipboard then
            Clipboard(idValue)
        end
        
        -- Hiệu ứng phản hồi khi ấn vào số để copy
        copyBtn.BackgroundColor3 = Color3.fromRGB(30, 38, 55)
        idLabel.TextColor3 = accent()
        
        task.spawn(function()
            task.wait(0.25)
            copyBtn.BackgroundColor3 = Color3.fromRGB(20, 23, 33)
            idLabel.TextColor3 = Color3.fromRGB(230, 235, 250)
        end)
        
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Copied!",
                Text = "Đã sao chép " .. labelTitle .. ": " .. idValue,
                Duration = 2.5
            })
        end)
    end)
end

createIdRow("Game ID", gameIdVal)
createIdRow("Place ID", placeIdVal)

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
    idTabStroke.Color = a -- Giữ hiệu ứng tab đang chọn phát sáng theo màu theme/rainbow
end)

return { Root = root }
