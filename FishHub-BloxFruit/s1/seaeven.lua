local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    if Config.Rainbow or Config.RainbowMode then
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius)
    })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.18,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.ScrollBarImageTransparency = 1
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local root = New("Frame", {
    Parent = Tab,
    Size = UDim2.new(1, -10, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
})

New("UIPadding", {
    Parent = root,
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5)
})

New("UIListLayout", {
    Parent = root,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10)
})

local topBar = New("Frame", {
    Parent = root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundTransparency = 1
})

local backBtn = New("TextButton", {
    Parent = topBar,
    Size = UDim2.fromOffset(45, 45),
    BackgroundColor3 = Color3.fromRGB(11, 13, 19),
    AutoButtonColor = false,
    Text = "",
    BorderSizePixel = 0
})
Corner(backBtn, 11)
local backStroke = Stroke(backBtn, 1, 0.4)

local arrow = New("TextLabel", {
    Parent = backBtn,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "←",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = accent()
})

local backScale = New("UIScale", {
    Parent = backBtn,
    Scale = 1
})

local searchBox = New("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 55, 0, 0),
    Size = UDim2.new(1, -55, 1, 0),
    BackgroundColor3 = Color3.fromRGB(11, 13, 19),
    BorderSizePixel = 0
})
Corner(searchBox, 11)
local searchStroke = Stroke(searchBox, 1, 0.4)

New("TextLabel", {
    Parent = searchBox,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.fromOffset(20, 45),
    BackgroundTransparency = 1,
    Text = "⌕",
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    TextColor3 = accent()
})

local search = New("TextBox", {
    Parent = searchBox,
    Position = UDim2.fromOffset(40, 0),
    Size = UDim2.new(1, -52, 1, 0),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    PlaceholderText = "search...",
    PlaceholderColor3 = Color3.fromRGB(100, 105, 120),
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(240, 242, 248),
    TextXAlignment = Enum.TextXAlignment.Left
})

local workspace = New("Frame", {
    Parent = root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 282),
    BackgroundTransparency = 1
})

local menuPanel = New("Frame", {
    Parent = workspace,
    Size = UDim2.new(0.30, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
Corner(menuPanel, 14)
local menuStroke = Stroke(menuPanel, 1, 0.58)

New("TextLabel", {
    Parent = menuPanel,
    Position = UDim2.fromOffset(13, 10),
    Size = UDim2.new(1, -26, 0, 18),
    BackgroundTransparency = 1,
    Text = "MENU",
    Font = Enum.Font.GothamBlack,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(125, 130, 145),
    TextXAlignment = Enum.TextXAlignment.Left
})

local menu = New("Frame", {
    Parent = menuPanel,
    Position = UDim2.fromOffset(8, 34),
    Size = UDim2.new(1, -16, 1, -42),
    BackgroundTransparency = 1
})

New("UIListLayout", {
    Parent = menu,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 5)
})

local divider = New("Frame", {
    Parent = workspace,
    Position = UDim2.new(0.30, 6, 0, 8),
    Size = UDim2.new(0, 1, 1, -16),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0
})

local contentPanel = New("Frame", {
    Parent = workspace,
    Position = UDim2.new(0.30, 17, 0, 0),
    Size = UDim2.new(0.70, -17, 1, 0),
    BackgroundColor3 = Color3.fromRGB(8, 9, 14),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
Corner(contentPanel, 14)
local contentStroke = Stroke(contentPanel, 1, 0.58)

local contentTitle = New("TextLabel", {
    Parent = contentPanel,
    Position = UDim2.fromOffset(14, 10),
    Size = UDim2.new(1, -28, 0, 20),
    BackgroundTransparency = 1,
    Text = "CONTENT",
    Font = Enum.Font.GothamBlack,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(240, 242, 248),
    TextXAlignment = Enum.TextXAlignment.Left
})

local contentLine = New("Frame", {
    Parent = contentPanel,
    Position = UDim2.fromOffset(14, 32),
    Size = UDim2.new(1, -28, 0, 1),
    BackgroundColor3 = accent(),
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0
})

local content = New("Frame", {
    Parent = contentPanel,
    Position = UDim2.fromOffset(14, 45),
    Size = UDim2.new(1, -28, 1, -57),
    BackgroundTransparency = 1,
    ClipsDescendants = true
})

local tabs = {}
local active

local function showLoading(title)
    for _, child in ipairs(content:GetChildren()) do
        child:Destroy()
    end
    New("TextLabel", {
        Parent = content,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Text = "LOADING  •  " .. string.upper(title),
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextColor3 = accent(),
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

local function loadRemote(data)
    showLoading(data.title)

    local ok, source = pcall(function()
        return game:HttpGet(data.url)
    end)

    if not ok or type(source) ~= "string" or source == "" then
        for _, child in ipairs(content:GetChildren()) do child:Destroy() end
        New("TextLabel", {
            Parent = content,
            Size = UDim2.new(1, 0, 0, 55),
            BackgroundTransparency = 1,
            Text = "Unable to load module.\n" .. tostring(data.title),
            Font = Enum.Font.GothamMedium,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(255, 125, 125),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        return
    end

    local fnOk, fn = pcall(loadstring, source)
    if not fnOk or type(fn) ~= "function" then
        for _, child in ipairs(content:GetChildren()) do child:Destroy() end
        New("TextLabel", {
            Parent = content,
            Size = UDim2.new(1, 0, 0, 70),
            BackgroundTransparency = 1,
            Text = "Module compile error.\n" .. tostring(fn),
            Font = Enum.Font.GothamMedium,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(255, 125, 125),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        return
    end

    for _, child in ipairs(content:GetChildren()) do
        child:Destroy()
    end

    local subContext = {}
    for k, v in pairs(context) do
        subContext[k] = v
    end
    subContext.Tab = content
    subContext.ContentTab = content
    subContext.ParentTab = Tab
    subContext.BackToMain = context.BackToMain
    subContext.LoadFunction = context.LoadFunction
    subContext.Navigate = context.Navigate

    local runOk, runErr = pcall(fn, subContext)
    if not runOk then
        for _, child in ipairs(content:GetChildren()) do
            child:Destroy()
        end
        New("TextLabel", {
            Parent = content,
            Size = UDim2.new(1, 0, 0, 70),
            BackgroundTransparency = 1,
            Text = "Module runtime error.\n" .. tostring(runErr),
            Font = Enum.Font.GothamMedium,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(255, 125, 125),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
end

local function selectTab(item, instant)
    if active == item then return end

    if active then
        Tween(active.line, instant and 0 or 0.18, {
            Size = UDim2.new(0, 3, 0, 0),
            BackgroundTransparency = 1
        })
        Tween(active.button, instant and 0 or 0.18, {
            BackgroundTransparency = 1
        })
    end

    active = item

    Tween(item.line, instant and 0 or 0.20, {
        Size = UDim2.new(0, 3, 0.72, 0),
        BackgroundTransparency = 0
    }, Enum.EasingStyle.Quint)

    Tween(item.button, instant and 0 or 0.20, {
        BackgroundTransparency = 0.88
    }, Enum.EasingStyle.Quint)

    contentTitle.Text = string.upper(item.title)
    loadRemote(item)
end

local definitions = {
    {"sea even", "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/seaeven/seaeven.lua"},
    {"island even", "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/seaeven/islandeven.lua"}
}

for index, data in ipairs(definitions) do
    local title, url = data[1], data[2]

    local button = New("TextButton", {
        Parent = menu,
        LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(19, 21, 29),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0
    })
    Corner(button, 9)

    local line = New("Frame", {
        Parent = button,
        Position = UDim2.new(0, 0, 0.14, 0),
        Size = UDim2.new(0, 3, 0, 0),
        BackgroundColor3 = accent(),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    Corner(line, 4)

    New("TextLabel", {
        Parent = button,
        Position = UDim2.fromOffset(13, 0),
        Size = UDim2.new(1, -19, 1, 0),
        BackgroundTransparency = 1,
        Text = string.upper(title),
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextColor3 = Color3.fromRGB(205, 209, 220),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local item = {
        title = title,
        url = url,
        button = button,
        line = line
    }
    tabs[#tabs + 1] = item

    button.MouseEnter:Connect(function()
        if active ~= item then
            Tween(button, 0.14, {BackgroundTransparency = 0.94})
        end
    end)

    button.MouseLeave:Connect(function()
        if active ~= item then
            Tween(button, 0.14, {BackgroundTransparency = 1})
        end
    end)

    button.Activated:Connect(function()
        selectTab(item, false)
    end)
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(search.Text or "")
    for _, item in ipairs(tabs) do
        item.button.Visible =
            query == "" or string.find(string.lower(item.title), query, 1, true) ~= nil
    end
end)

backBtn.MouseEnter:Connect(function()
    Tween(backScale, 0.15, {Scale = 1.06}, Enum.EasingStyle.Back)
    Tween(backStroke, 0.15, {Transparency = 0.05, Thickness = 1.5})
end)

backBtn.MouseLeave:Connect(function()
    Tween(backScale, 0.15, {Scale = 1}, Enum.EasingStyle.Quint)
    Tween(backStroke, 0.15, {Transparency = 0.4, Thickness = 1})
end)

backBtn.Activated:Connect(function()
    if type(context.BackToMain) == "function" then
        context.BackToMain()
    elseif type(context.LoadFunction) == "function" then
        context.LoadFunction()
    end
end)

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

task.spawn(function()
    while alive and root.Parent do
        local a = accent()
        backStroke.Color = a
        searchStroke.Color = a
        menuStroke.Color = a
        contentStroke.Color = a
        divider.BackgroundColor3 = a
        contentLine.BackgroundColor3 = a
        arrow.TextColor3 = a

        for _, item in ipairs(tabs) do
            item.line.BackgroundColor3 = a
        end

        task.wait(0)
    end
end)

if tabs[1] then
    active = nil
    selectTab(tabs[1], true)
end

return { Root = root }
