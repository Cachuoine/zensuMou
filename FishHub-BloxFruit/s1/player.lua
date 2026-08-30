local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local MainTab = context.Tab
local Config = context.Config or {}

local function accent()
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
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
            duration or 0.2,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

local function clear(parent)
    for _, child in ipairs(parent:GetChildren()) do
        child:Destroy()
    end
end

local function loadRemote(url, target)
    clear(target)

    local loading = New("TextLabel", {
        Parent = target,
        Size = UDim2.new(1, -24, 0, 50),
        Position = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1,
        Text = "Loading module...",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(145, 150, 165),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or type(source) ~= "string" or source == "" then
        loading.Text = "Unable to load module."
        loading.TextColor3 = Color3.fromRGB(255, 120, 120)
        return
    end

    clear(target)

    local fnOk, fn = pcall(loadstring, source)
    if not fnOk or type(fn) ~= "function" then
        local err = tostring(fn)
        New("TextLabel", {
            Parent = target,
            Size = UDim2.new(1, -24, 0, 70),
            Position = UDim2.fromOffset(12, 12),
            BackgroundTransparency = 1,
            Text = "Module error\n" .. err,
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(255, 120, 120),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        return
    end

    local subContext = {}
    for k, v in pairs(context) do
        subContext[k] = v
    end
    subContext.Tab = target
    subContext.ContentTab = target
    subContext.ParentTab = MainTab
    subContext.BackToMain = context.BackToMain
    subContext.LoadFunction = context.LoadFunction
    subContext.Navigate = context.Navigate

    local runOk, runErr = pcall(fn, subContext)
    if not runOk then
        clear(target)
        New("TextLabel", {
            Parent = target,
            Size = UDim2.new(1, -24, 0, 70),
            Position = UDim2.fromOffset(12, 12),
            BackgroundTransparency = 1,
            Text = "Module runtime error\n" .. tostring(runErr),
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(255, 120, 120),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
    end
end

local function build()
    clear(MainTab)

    MainTab.BackgroundTransparency = 1
    MainTab.BorderSizePixel = 0
    MainTab.ScrollBarThickness = 0
    MainTab.ScrollBarImageTransparency = 1
    MainTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local root = New("Frame", {
        Parent = MainTab,
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
        BackgroundColor3 = Color3.fromRGB(12, 13, 19),
        AutoButtonColor = false,
        Text = ""
    })
    Corner(backBtn, 10)
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

    local searchBox = New("Frame", {
        Parent = topBar,
        Position = UDim2.new(0, 55, 0, 0),
        Size = UDim2.new(1, -55, 1, 0),
        BackgroundColor3 = Color3.fromRGB(12, 13, 19)
    })
    Corner(searchBox, 10)
    local searchStroke = Stroke(searchBox, 1, 0.4)

    New("TextLabel", {
        Parent = searchBox,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        BackgroundTransparency = 1,
        Text = "🔍",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(185, 190, 205)
    })

    local search = New("TextBox", {
        Parent = searchBox,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
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

    local split = New("Frame", {
        Parent = root,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 265),
        BackgroundTransparency = 1
    })

    local left = New("Frame", {
        Parent = split,
        Size = UDim2.new(0.31, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(8, 9, 14),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Corner(left, 13)
    local leftStroke = Stroke(left, 1, 0.58)

    New("TextLabel", {
        Parent = left,
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
        Parent = left,
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
        Parent = split,
        Position = UDim2.new(0.31, 5, 0, 7),
        Size = UDim2.fromOffset(1, 251),
        BackgroundColor3 = Color3.fromRGB(48, 52, 65),
        BorderSizePixel = 0
    })

    local right = New("Frame", {
        Parent = split,
        Position = UDim2.new(0.31, 16, 0, 0),
        Size = UDim2.new(0.69, -16, 1, 0),
        BackgroundColor3 = Color3.fromRGB(8, 9, 14),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Corner(right, 13)
    local rightStroke = Stroke(right, 1, 0.58)

    local contentHeader = New("TextLabel", {
        Parent = right,
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -28, 0, 18),
        BackgroundTransparency = 1,
        Text = "CONTENT",
        Font = Enum.Font.GothamBlack,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(125, 130, 145),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local content = New("ScrollingFrame", {
        Parent = right,
        Position = UDim2.fromOffset(8, 34),
        Size = UDim2.new(1, -16, 1, -42),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })

    local tabs = {}
    local active

    local function selectTab(item, instant)
        if active == item then return end

        if active then
            Tween(active.line, 0.18, {
                Size = UDim2.new(0, 3, 0, 0),
                BackgroundTransparency = 1
            }, Enum.EasingStyle.Quint)
            Tween(active.button, 0.18, {
                BackgroundTransparency = 1
            })
        end

        active = item
        Tween(item.line, instant and 0 or 0.2, {
            Size = UDim2.new(0, 3, 0.72, 0),
            BackgroundTransparency = 0
        }, Enum.EasingStyle.Quint)
        Tween(item.button, instant and 0 or 0.2, {
            BackgroundTransparency = 0.88
        }, Enum.EasingStyle.Quint)

        contentHeader.Text = string.upper(item.title)
        loadRemote(item.url, content)
    end

    local definitions = {
        {"PLAYER", "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/player/player.lua"},
        {"PVP", "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/player/pvp.lua"}
    }

    for index, data in ipairs(definitions) do
        local button = New("TextButton", {
            Parent = menu,
            LayoutOrder = index,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(20, 22, 30),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            ClipsDescendants = true
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

        local label = New("TextLabel", {
            Parent = button,
            Position = UDim2.fromOffset(13, 0),
            Size = UDim2.new(1, -20, 1, 0),
            BackgroundTransparency = 1,
            Text = data[1],
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(205, 209, 220),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local item = {
            title = data[1],
            url = data[2],
            button = button,
            line = line,
            label = label
        }
        tabs[#tabs + 1] = item

        button.MouseEnter:Connect(function()
            if active ~= item then
                Tween(button, 0.15, {BackgroundTransparency = 0.94})
            end
        end)

        button.MouseLeave:Connect(function()
            if active ~= item then
                Tween(button, 0.15, {BackgroundTransparency = 1})
            end
        end)

        button.Activated:Connect(function()
            selectTab(item, false)
        end)
    end

    search:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(search.Text or "")
        for _, item in ipairs(tabs) do
            item.button.Visible = query == "" or string.find(string.lower(item.title), query, 1, true) ~= nil
        end
    end)

    backBtn.Activated:Connect(function()
        if type(context.BackToMain) == "function" then
            context.BackToMain()
        elseif type(context.LoadFunction) == "function" then
            context.LoadFunction()
        end
    end)

    task.spawn(function()
        while root.Parent do
            local a = accent()
            backStroke.Color = a
            searchStroke.Color = a
            leftStroke.Color = a
            rightStroke.Color = a
            arrow.TextColor3 = a
            divider.BackgroundColor3 = a
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
end

build()

return { Root = MainTab }
