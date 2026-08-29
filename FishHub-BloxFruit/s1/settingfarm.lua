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
local searchInput = New("TextBox", { Parent = searchBox, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, ClearTextOnFocus = false, PlaceholderText = "search...", PlaceholderColor3 = Color3.fromRGB(100, 105, 120), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(240, 242, 248), TextXAlignment = Enum.TextXAlignment.Left })

local bodyFrame = New("Frame", { Parent = root, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 320), BackgroundTransparency = 1 })

local leftPane = New("Frame", { Parent = bodyFrame, Size = UDim2.new(0, 130, 1, 0), BackgroundColor3 = Color3.fromRGB(12, 13, 19) })
Corner(leftPane, 12)
local leftStroke = Stroke(leftPane, 1, 0.4)
New("UIPadding", { Parent = leftPane, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
New("UIListLayout", { Parent = leftPane, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })

local divider = New("Frame", { Parent = bodyFrame, Position = UDim2.new(0, 140, 0, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = accent(), BackgroundTransparency = 0.3 })

local rightPane = New("Frame", { Parent = bodyFrame, Position = UDim2.new(0, 150, 0, 0), Size = UDim2.new(1, -150, 1, 0), BackgroundColor3 = Color3.fromRGB(9, 10, 15), BackgroundTransparency = 0.5 })
Corner(rightPane, 12)
local rightStroke = Stroke(rightPane, 1, 0.6)
New("UIPadding", { Parent = rightPane, PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) })

local contentLabel = New("TextLabel", { Parent = rightPane, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "Select a tab...", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(200, 205, 220), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top })

local indicator = New("Frame", { Parent = leftPane, Size = UDim2.new(0, 3, 0, 0), BackgroundColor3 = accent() })
Corner(indicator, 2)

local tabsData = {
    { Name = "Setting Farm", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm/misssettingfarm.lua" },
    { Name = "Hold & Select Skill", Url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm/hold%26selectskill.lua" },
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
    local btn = New("TextButton", { Parent = leftPane, LayoutOrder = i, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Color3.fromRGB(18, 20, 30), AutoButtonColor = false, Text = data.Name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(180, 185, 200) })
    Corner(btn, 8)
    
    btn.Activated:Connect(function()
        for _, b in ipairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(18, 20, 30), TextColor3 = Color3.fromRGB(180, 185, 200) }):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(25, 28, 42), TextColor3 = accent() }):Play()
        
        task.spawn(function()
            while btn.AbsolutePosition.Y == 0 and root.Parent do
                task.wait()
            end
            if not root.Parent then return end
            TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 3, 0, btn.AbsoluteSize.Y - 4),
                Position = UDim2.new(0, -5, 0, btn.AbsolutePosition.Y - leftPane.AbsolutePosition.Y + 2)
            }):Play()
        end)

        loadUrlContent(data.Url)
    end)
    
    table.insert(tabButtons, btn)
end

task.spawn(function()
    task.wait(0.1)
    if tabButtons[1] then
        tabButtons[1].Activated:Fire()
    end
end)

searchInput.FocusLost:Connect(function()
    local filter = string.lower(searchInput.Text)
    for _, btn in ipairs(tabButtons) do
        if filter == "" or string.find(string.lower(btn.Text), filter) then
            btn.Visible = true
        else
            btn.Visible = false
        end
    end
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
    leftStroke.Color = a
    rightStroke.Color = a
    divider.BackgroundColor3 = a
    indicator.BackgroundColor3 = a
    arrowLabel.TextColor3 = a
end)

return { Root = root }
