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
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search server...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

-- Main content container for Server Status
local contentFrame = New("ScrollingFrame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 320), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageColor3 = accent() })
Corner(contentFrame, 12)
local contentStroke = Stroke(contentFrame, 1, 0.6)
New("UIPadding", { Parent = contentFrame, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
New("UIListLayout", { Parent = contentFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

-- Helper function to copy text to clipboard safely
local function notifyCopied(text)
    pcall(function()
        if setclipboard then
            setclipboard(tostring(text))
        end
    end)
end

-- Function to create server status card with 2 sections:
-- Left: ID tab, Right: Game ID and Place ID inside the same box separated cleanly, with click-to-copy functionality.
local function createServerCard(layoutOrder, userIdText, gameIdVal, placeIdVal)
    local card = New("Frame", { Parent = contentFrame, LayoutOrder = layoutOrder, Size = UDim2.new(1, 0, 0, 65), BackgroundColor3 = Color3.fromRGB(15, 17, 24), BackgroundTransparency = 0.3 })
    Corner(card, 8)
    local cardStroke = Stroke(card, 1, 0.7)

    -- Left side: ID tab
    local leftContainer = New("Frame", { Parent = card, Position = UDim2.new(0, 8, 0, 8), Size = UDim2.new(0, 95, 1, -16), BackgroundColor3 = Color3.fromRGB(20, 22, 32), BackgroundTransparency = 0.5 })
    Corner(leftContainer, 6)
    
    New("TextLabel", { Parent = leftContainer, Position = UDim2.new(0, 0, 0, 5), Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = "USER ID", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(140, 145, 165), TextXAlignment = Enum.TextXAlignment.Center })
    
    local userIdLabel = New("TextButton", { Parent = leftContainer, Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = tostring(userIdText), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(240, 242, 248), AutoButtonColor = false })
    
    userIdLabel.Activated:Connect(function()
        notifyCopied(userIdText)
        userIdLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.delay(0.3, function()
            userIdLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        end)
    end)

    -- Right side: Game ID and Place ID in one unified box, split into 2 rows
    local rightContainer = New("Frame", { Parent = card, Position = UDim2.new(0, 110, 0, 8), Size = UDim2.new(1, -118, 1, -16), BackgroundColor3 = Color3.fromRGB(20, 22, 32), BackgroundTransparency = 0.5 })
    Corner(rightContainer, 6)

    -- Game ID Row (Top half)
    local gameIdBtn = New("TextButton", { Parent = rightContainer, Position = UDim2.new(0, 8, 0, 4), Size = UDim2.new(1, -16, 0, 22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false })
    New("TextLabel", { Parent = gameIdBtn, Size = UDim2.new(0, 60, 1, 0), BackgroundTransparency = 1, Text = "Game ID:", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(140, 145, 165), TextXAlignment = Enum.TextXAlignment.Left })
    local gameIdValLabel = New("TextLabel", { Parent = gameIdBtn, Position = UDim2.new(0, 65, 0, 0), Size = UDim2.new(1, -65, 1, 0), BackgroundTransparency = 1, Text = tostring(gameIdVal), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left })

    gameIdBtn.Activated:Connect(function()
        notifyCopied(gameIdVal)
        gameIdValLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.delay(0.3, function()
            gameIdValLabel.TextColor3 = accent()
        end)
    end)

    -- Divider line between Game ID and Place ID
    New("Frame", { Parent = rightContainer, Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.new(1, -16, 0, 1), BackgroundColor3 = Color3.fromRGB(40, 45, 60), BackgroundTransparency = 0.5, BorderSizePixel = 0 })

    -- Place ID Row (Bottom half)
    local placeIdBtn = New("TextButton", { Parent = rightContainer, Position = UDim2.new(0, 8, 0, 28), Size = UDim2.new(1, -16, 0, 22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false })
    New("TextLabel", { Parent = placeIdBtn, Size = UDim2.new(0, 60, 1, 0), BackgroundTransparency = 1, Text = "Place ID:", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(140, 145, 165), TextXAlignment = Enum.TextXAlignment.Left })
    local placeIdValLabel = New("TextLabel", { Parent = placeIdBtn, Position = UDim2.new(0, 65, 0, 0), Size = UDim2.new(1, -65, 1, 0), BackgroundTransparency = 1, Text = tostring(placeIdVal), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left })

    placeIdBtn.Activated:Connect(function()
        notifyCopied(placeIdVal)
        placeIdValLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.delay(0.3, function()
            placeIdValLabel.TextColor3 = accent()
        end)
    end)

    return card
end

-- Populate initial server info card using local player and game data
local currentUserId = Players.LocalPlayer and Players.LocalPlayer.UserId or 12345678
local currentGameId = game.GameId
local currentPlaceId = game.PlaceId

createServerCard(1, currentUserId, currentGameId, currentPlaceId)

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
end)

return { Root = root }
