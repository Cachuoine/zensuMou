local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

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

-- Main Content Container (Chia 2 phần Trái / Phải to đẹp)
local contentFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 260), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)

-- Bên trái luôn nhỏ hơn bên phải (Bên trái chiếm 32%, bên phải chiếm 68%)
local leftPanel = New("Frame", { Parent = contentFrame, Size = UDim2.new(0.32, -5, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 })
local rightPanel = New("Frame", { Parent = contentFrame, Size = UDim2.new(0.68, -5, 1, 0), Position = UDim2.new(0.32, 5, 0, 0), BackgroundTransparency = 1 })

-- Đường kẻ dọc ngăn cách giữa trái và phải
local divider = New("Frame", { Parent = contentFrame, Size = UDim2.new(0, 1, 1, -16), Position = UDim2.new(0.32, 0, 0, 8), BackgroundColor3 = Color3.fromRGB(40, 45, 60), BorderSizePixel = 0 })

-- Cấu hình Phần Trái (Tab ID)
New("UIPadding", { Parent = leftPanel, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 5) })
New("UIListLayout", { Parent = leftPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

New("TextLabel", { Parent = leftPanel, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "CATEGORIES", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(140, 145, 165), TextXAlignment = Enum.TextXAlignment.Left })

local idTabButton = New("TextButton", { Parent = leftPanel, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(18, 20, 28), AutoButtonColor = false, Text = "" })
Corner(idTabButton, 8)
Stroke(idTabButton, 1, 0.7)
New("TextLabel", { Parent = idTabButton, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "  🆔 ID Panel", Font = Enum.Font.GothamBold, TextSize, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left })

-- Cấu hình Phần Phải (Hiển thị ID Game và ID Place chung 1 ô, hỗ trợ Click to Copy)
New("UIPadding", { Parent = rightPanel, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
New("UIListLayout", { Parent = rightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

New("TextLabel", { Parent = rightPanel, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "GAME & PLACE IDENTIFIERS (Click to Copy)", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(140, 145, 165), TextXAlignment = Enum.TextXAlignment.Left })

-- Ô chứa ID Game và ID Place chung một ô
local infoContainer = New("TextButton", { Parent = rightPanel, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Color3.fromRGB(14, 16, 24), AutoButtonColor = false, Text = "" })
Corner(infoContainer, 8)
local infoStroke = Stroke(infoContainer, 1, 0.6)

local gameIdVal = tostring(game.GameId)
local placeIdVal = tostring(game.PlaceId)

local infoTextLabel = New("TextLabel", { Parent = infoContainer, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "Game ID: " .. gameIdVal .. "  |  Place ID: " .. placeIdVal, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(220, 225, 240), TextXAlignment = Enum.TextXAlignment.Left })

-- Chức năng khi ấn vào ô ID Game & Place sẽ copy vào Clipboard
infoContainer.Activated:Connect(function()
    local combinedText = "GameId: " .. gameIdVal .. " | PlaceId: " .. placeIdVal
    pcall(function()
        setclipboard(combinedText)
    end)
    
    -- Hiệu ứng nhấp nháy khi copy thành công
    infoContainer.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
    infoTextLabel.TextColor3 = accent()
    
    task.spawn(function()
        task.wait(0.2)
        infoContainer.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
        infoTextLabel.TextColor3 = Color3.fromRGB(220, 225, 240)
    end)
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Copied IDs!",
            Text = "Đã sao chép: " .. combinedText,
            Duration = 3
        })
    end)
end)

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
    infoStroke.Color = a
    arrowLabel.TextColor3 = a
end)

return { Root = root }
