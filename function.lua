local context = ...
if type(context) ~= "table" then
    return function() end
end

local Players = context.Players
local TweenService = context.TweenService
local HttpService = context.HttpService
local Tab = context.Tab
local Config = context.Config or {}
local ShowNotification = context.ShowNotification or function() end
local GetAccent = context.GetCurrentAccentColor or function() return Config.ThemeColor or Color3.new(0,1,1) end

local CHILD_URLS = {
    SHOP = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/shop.lua",
    SETTINGFARM = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm.lua",
    FARM = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm.lua",
    ITEM = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/item.lua",
    ISLAND = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/island.lua",
    FRUIT = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit.lua",
    SETTING = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/setting.lua",
}

local alive = true
local current = nil
local childCache = {}
local themeObjects = {}
local rainbowThread = nil
local hue = 0

local function safeDestroy(x)
    if x and x.Destroy then pcall(function() x:Destroy() end) end
end

local root = Instance.new("Frame")
root.Name = "FunctionRoot"
root.Parent = Tab
root.Size = UDim2.fromScale(1,1)
root.BackgroundTransparency = 1

local top = Instance.new("Frame")
top.Parent = root
top.Size = UDim2.new(1,0,0,38)
top.BackgroundTransparency = 1

local back = Instance.new("TextButton")
back.Name = "BackButton"
back.Parent = top
back.Size = UDim2.new(0,38,0,30)
back.Position = UDim2.new(0,2,0,4)
back.BackgroundColor3 = Color3.fromRGB(42,44,56)
back.BorderSizePixel = 0
back.AutoButtonColor = false
back.Text = "‹"
back.Font = Enum.Font.GothamBold
back.TextSize = 20
back.TextColor3 = GetAccent()
Instance.new("UICorner",back).CornerRadius = UDim.new(0,8)
local backStroke = Instance.new("UIStroke",back)
backStroke.Thickness = 1
backStroke.Color = GetAccent()

local search = Instance.new("TextBox")
search.Name = "Search"
search.Parent = top
search.Size = UDim2.new(1,-50,0,30)
search.Position = UDim2.new(0,48,0,4)
search.BackgroundColor3 = Color3.fromRGB(35,37,48)
search.BackgroundTransparency = 0.05
search.BorderSizePixel = 0
search.ClearTextOnFocus = false
search.PlaceholderText = "search..."
search.PlaceholderColor3 = Color3.fromRGB(135,140,155)
search.Text = ""
search.TextColor3 = Color3.fromRGB(235,238,245)
search.Font = Enum.Font.GothamMedium
search.TextSize = 11
search.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner",search).CornerRadius = UDim.new(0,8)
local searchPadding = Instance.new("UIPadding",search)
searchPadding.PaddingLeft = UDim.new(0,31)
local searchStroke = Instance.new("UIStroke",search)
searchStroke.Thickness = 1
searchStroke.Color = GetAccent()

local magnify = Instance.new("TextLabel")
magnify.Parent = top
magnify.Size = UDim2.new(0,22,0,30)
magnify.Position = UDim2.new(0,54,0,4)
magnify.BackgroundTransparency = 1
magnify.Text = "⌕"
magnify.Font = Enum.Font.GothamBold
magnify.TextSize = 19
magnify.TextColor3 = GetAccent()
magnify.ZIndex = 3

local title = Instance.new("TextLabel")
title.Parent = root
title.Size = UDim2.new(1,-4,0,24)
title.Position = UDim2.new(0,2,0,43)
title.BackgroundTransparency = 1
title.Text = "FUNCTIONS"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(235,238,245)
title.TextXAlignment = Enum.TextXAlignment.Left

local divider = Instance.new("Frame")
divider.Parent = root
divider.Size = UDim2.new(1,-4,0,1)
divider.Position = UDim2.new(0,2,0,69)
divider.BackgroundColor3 = GetAccent()
divider.BorderSizePixel = 0

local list = Instance.new("ScrollingFrame")
list.Parent = root
list.Size = UDim2.new(1,-4,1,-78)
list.Position = UDim2.new(0,2,0,76)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 0
list.CanvasSize = UDim2.new(0,0,0,0)
local grid = Instance.new("UIGridLayout",list)
grid.CellSize = UDim2.new(0.5,-7,0,48)
grid.CellPadding = UDim2.new(0,10,0,10)
grid.SortOrder = Enum.SortOrder.LayoutOrder

local buttons = {}
local order = {"SHOP","SETTINGFARM","FARM","ITEM","ISLAND","FRUIT","SETTING"}

local function register(obj)
    table.insert(themeObjects,obj)
    return obj
end

local function accent()
    if Config.RainbowEnabled == true then
        return Color3.fromHSV(hue,0.82,1)
    end
    return GetAccent()
end

for i,name in ipairs(order) do
    local b = Instance.new("TextButton")
    b.Name = name
    b.Parent = list
    b.BackgroundColor3 = Color3.fromRGB(42,44,56)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(230,233,242)
    b.LayoutOrder = i
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,9)
    local st = Instance.new("UIStroke",b)
    st.Thickness = 1
    st.Color = accent()
    register(st)
    local scale = Instance.new("UIScale",b)
    b.MouseEnter:Connect(function()
        TweenService:Create(scale,TweenInfo.new(.16,Enum.EasingStyle.Back),{Scale=1.025}):Play()
        TweenService:Create(b,TweenInfo.new(.16),{BackgroundColor3=Color3.fromRGB(52,55,70)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(scale,TweenInfo.new(.16),{Scale=1}):Play()
        TweenService:Create(b,TweenInfo.new(.16),{BackgroundColor3=Color3.fromRGB(42,44,56)}):Play()
    end)
    buttons[name]=b
end

local childViewport = Instance.new("Frame")
childViewport.Name = "ChildViewport"
childViewport.Parent = root
childViewport.Size = UDim2.new(1,0,1,-40)
childViewport.Position = UDim2.new(0,0,0,40)
childViewport.BackgroundTransparency = 1
childViewport.Visible = false

local function filterButtons()
    local q = string.lower(search.Text or "")
    local visibleCount = 0
    for _,name in ipairs(order) do
        local ok = q == "" or string.find(string.lower(name),q,1,true) ~= nil
        buttons[name].Visible = ok
        if ok then visibleCount += 1 end
    end
    list.CanvasSize = UDim2.new(0,0,0,math.ceil(visibleCount/2)*58)
end

search:GetPropertyChangedSignal("Text"):Connect(filterButtons)
filterButtons()

local function buildChildContext(name, mount)
    return {
        Player = context.Player,
        Players = Players,
        PlayerGui = context.PlayerGui,
        TweenService = TweenService,
        HttpService = HttpService,
        Config = Config,
        MainWindow = context.MainWindow,
        Main = context.Main,
        Gui = context.Gui,
        Tab = mount,
        Mount = mount,
        TabName = name,
        ShowNotification = ShowNotification,
        GetCurrentAccentColor = GetAccent,
        IsRainbowEnabled = function() return Config.RainbowEnabled == true end,
        SetRainbowEnabled = function(v) Config.RainbowEnabled = v == true end,
        AddThemeObject = register,
    }
end

local function loadChild(name)
    local url = CHILD_URLS[name]
    if not url then return end
    current = name
    list.Visible = false
    title.Text = name
    childViewport.Visible = true
    safeDestroy(childViewport:FindFirstChild("ChildMount"))
    local mount = Instance.new("Frame")
    mount.Name = "ChildMount"
    mount.Parent = childViewport
    mount.Size = UDim2.fromScale(1,1)
    mount.BackgroundTransparency = 1
    mount.Visible = true

    local ok, err = pcall(function()
        local source = game:HttpGet(url)
        assert(type(source)=="string" and #source>10,"empty remote source")
        local chunk, compileError = loadstring(source)
        assert(type(chunk)=="function","compile error: "..tostring(compileError))
        local childContext = buildChildContext(name,mount)
        local result = chunk(childContext)
        if type(result)=="function" then
            local resultOk,resultErr = pcall(result,childContext)
            assert(resultOk,resultErr)
        end
    end)
    if not ok then
        ShowNotification(name.." failed to load: "..tostring(err))
    end
end

back.MouseButton1Click:Connect(function()
    if current then
        current=nil
        childViewport.Visible=false
        list.Visible=true
        title.Text="FUNCTIONS"
        search.Text=""
        filterButtons()
    end
end)

for _,name in ipairs(order) do
    buttons[name].MouseButton1Click:Connect(function()
        loadChild(name)
    end)
end

task.spawn(function()
    while alive and root.Parent do
        hue = (hue + math.max(0.001,(tonumber(Config.RainbowSpeedPercent) or 100)/100000)) % 1
        local c = accent()
        backStroke.Color=c
        back.TextColor3=c
        searchStroke.Color=c
        magnify.TextColor3=c
        divider.BackgroundColor3=c
        for _,obj in ipairs(themeObjects) do
            if obj and obj.Parent then obj.Color=c end
        end
        task.wait(0.03)
    end
end)

return {
    Destroy = function()
        alive=false
        safeDestroy(root)
    end,
    Back = function()
        back:Activate()
    end
}
