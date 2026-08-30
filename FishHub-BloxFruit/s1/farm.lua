--[[
    server.lua
    Blox Fruit - Server Hub
    Tabs: Island Event | Boss | Miss
    Layout: Left (tabs, nhỏ hơn) | Right (content, lớn hơn)
]]

local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")

local player   = Players.LocalPlayer

-- =========================================================================
-- THEME / CONFIG
-- =========================================================================
local CONFIG = {
    ThemeColor   = Color3.fromRGB(0, 229, 255),
    Rainbow      = false,
    BgDark       = Color3.fromRGB(8, 9, 14),
    BgPanel      = Color3.fromRGB(14, 16, 24),
    BgTab        = Color3.fromRGB(18, 20, 30),
    BgTabActive  = Color3.fromRGB(22, 26, 40),
    TextPrimary  = Color3.fromRGB(240, 242, 248),
    TextMuted    = Color3.fromRGB(130, 135, 150),
    StrokeAlpha  = 0.55,
}

local TAB_LIST = {
    { name = "Farm", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/farm.lua" },
    { name = "Fishing", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/fishing.lua" },
    { name = "Miss", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm/missfarm.lua" }
}

-- =========================================================================
-- UTILS
-- =========================================================================
local function New(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    return inst
end

local function Corner(parent, r)
    return New("UICorner", { Parent = parent, CornerRadius = UDim.new(0, r) })
end

local function Stroke(parent, thickness, transparency, color)
    return New("UIStroke", {
        Parent = parent,
        Color = color or CONFIG.ThemeColor,
        Thickness = thickness or 1,
        Transparency = transparency or CONFIG.StrokeAlpha,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function Pad(parent, t, b, l, r)
    return New("UIPadding", {
        Parent = parent,
        PaddingTop    = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingRight  = UDim.new(0, r or 0),
    })
end

local function tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quint,
        dir or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- =========================================================================
-- HTTP / SCRIPT RUNNER
-- =========================================================================
local function fetch(url)
    local ok, res = pcall(function()
        if syn and syn.request then
            local r = syn.request({ Url = url, Method = "GET" })
            return r.Body
        elseif request then
            local r = request({ Url = url, Method = "GET" })
            return r.Body
        elseif http_request then
            local r = http_request({ Url = url, Method = "GET" })
            return r.Body
        elseif game and game.HttpGet then
            return game:HttpGet(url, true)
        end
        return nil
    end)
    if ok and type(res) == "string" and #res > 0 then return res end
    return nil
end

local function runContent(url, holder)
    for _, c in ipairs(holder:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton") then
            c:Destroy()
        end
    end

    holder.Visible = false
    local loading = New("TextLabel", {
        Parent = holder,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = "Loading...",
        TextColor3 = CONFIG.TextMuted,
        TextSize = 14,
    })

    task.spawn(function()
        local src = fetch(url)
        loading:Destroy()
        holder.Visible = true
        if not src then
            New("TextLabel", {
                Parent = holder,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium,
                Text = "⚠ Failed to load content (offline / executor blocked)",
                TextColor3 = Color3.fromRGB(255, 110, 110),
                TextSize = 13,
                TextWrapped = true,
            })
            return
        end

        local content = New("TextLabel", {
            Parent = holder,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Text = src,
            TextColor3 = CONFIG.TextPrimary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
        })
        Pad(content, 8, 8, 10, 10)
    end)
end

-- =========================================================================
-- UI BUILD
-- =========================================================================
if player.PlayerGui:FindFirstChild("FishHubFarm") then
    player.PlayerGui.FishHubFarm:Destroy()
end

local gui = New("ScreenGui", {
    Name = "FishHubFarm",
    Parent = player.PlayerGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})

local main = New("Frame", {
    Parent = gui,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(720, 460),
    BackgroundColor3 = CONFIG.BgDark,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})
Corner(main, 14)
Stroke(main, 1.2, 0.3)
New("ImageLabel", {
    Parent = main,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = "rbxassetid://5554236805",
    ImageTransparency = 0.92,
    ImageColor3 = CONFIG.ThemeColor,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0,
})

-- =================== TOP BAR ===================
local topBar = New("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = CONFIG.BgPanel,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    ZIndex = 5,
})
Corner(topBar, 14)
New("Frame", {
    Parent = topBar,
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = topBar.BackgroundColor3,
    BackgroundTransparency = topBar.BackgroundTransparency,
    BorderSizePixel = 0,
})

local backBtn = New("TextButton", {
    Parent = topBar,
    Position = UDim2.new(0, 10, 0, 8),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = CONFIG.BgTab,
    AutoButtonColor = false,
    Text = "",
})
Corner(backBtn, 8)
Stroke(backBtn, 1, 0.5)
local backIcon = New("TextLabel", {
    Parent = backBtn,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "←",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = CONFIG.ThemeColor,
})
backBtn.MouseEnter:Connect(function()
    tween(backBtn, { BackgroundColor3 = Color3.fromRGB(28, 32, 48) }, 0.18)
    tween(backIcon, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.18)
end)
backBtn.MouseLeave:Connect(function()
    tween(backBtn, { BackgroundColor3 = CONFIG.BgTab }, 0.18)
    tween(backIcon, { TextColor3 = CONFIG.ThemeColor }, 0.18)
end)

New("TextLabel", {
    Parent = topBar,
    Position = UDim2.new(0, 52, 0, 0),
    Size = UDim2.new(0, 110, 1, 0),
    BackgroundTransparency = 1,
    Text = "FARM",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = CONFIG.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local searchBox = New("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 170, 0, 8),
    Size = UDim2.new(1, -180, 0, 32),
    BackgroundColor3 = CONFIG.BgTab,
    BorderSizePixel = 0,
})
Corner(searchBox, 8)
Stroke(searchBox, 1, 0.55)

local searchIcon = New("TextLabel", {
    Parent = searchBox,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.fromOffset(20, 32),
    BackgroundTransparency = 1,
    Text = "⌕",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = CONFIG.ThemeColor,
    TextXAlignment = Enum.TextXAlignment.Center,
})
local searchInput = New("TextBox", {
    Parent = searchBox,
    Position = UDim2.new(0, 36, 0, 0),
    Size = UDim2.new(1, -42, 1, 0),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    Text = "",
    PlaceholderText = "search items...",
    PlaceholderColor3 = CONFIG.TextMuted,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = CONFIG.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- =================== BODY ===================
local body = New("Frame", {
    Parent = main,
    Position = UDim2.new(0, 0, 0, 48),
    Size = UDim2.new(1, 0, 1, -48),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
})

local leftCol = New("Frame", {
    Parent = body,
    Size = UDim2.new(0, 150, 1, 0),
    BackgroundColor3 = CONFIG.BgPanel,
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
})
Pad(leftCol, 10, 10, 8, 8)

New("UIListLayout", {
    Parent = leftCol,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
})

local divider = New("Frame", {
    Parent = body,
    Position = UDim2.new(0, 150, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = CONFIG.ThemeColor,
    BackgroundTransparency = 0.75,
    BorderSizePixel = 0,
})

local rightCol = New("Frame", {
    Parent = body,
    Position = UDim2.new(0, 151, 0, 0),
    Size = UDim2.new(1, -151, 1, 0),
    BackgroundColor3 = CONFIG.BgPanel,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})
Pad(rightCol, 12, 12, 14, 14)

local contentHolder = New("Frame", {
    Parent = rightCol,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
})

-- =================== TAB ITEMS ===================
local activeIndex = 1
local tabButtons  = {}
local tabIndicator

tabIndicator = New("Frame", {
    Parent = leftCol,
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 0, 0, 22),
    Size = UDim2.new(0, 3, 0, 0),
    BackgroundColor3 = CONFIG.ThemeColor,
    BorderSizePixel = 0,
    ZIndex = 10,
})
Corner(tabIndicator, 2)

for i, info in ipairs(TAB_LIST) do
    local btn = New("TextButton", {
        Parent = leftCol,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = CONFIG.BgTab,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
    })
    Corner(btn, 8)
    Stroke(btn, 1, 0.75)

    local accentBar = New("Frame", {
        Parent = btn,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 4, 0.5, 0),
        Size = UDim2.new(0, 2, 0, 0),
        BackgroundColor3 = CONFIG.ThemeColor,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
    })
    Corner(accentBar, 1)

    local lbl = New("TextLabel", {
        Parent = btn,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = info.name,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = CONFIG.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local shimmer = New("Frame", {
        Parent = btn,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CONFIG.ThemeColor,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = 0,
    })
    Corner(shimmer, 8)

    btn.MouseEnter:Connect(function()
        if i ~= activeIndex then
            tween(btn,    { BackgroundColor3 = CONFIG.BgTabActive }, 0.18)
            tween(lbl,    { TextColor3 = Color3.fromRGB(200, 210, 230) }, 0.18)
            tween(shimmer,{ Size = UDim2.new(1, 0, 1, 0) }, 0.25)
        end
    end)
    btn.MouseLeave:Connect(function()
        if i ~= activeIndex then
            tween(btn,    { BackgroundColor3 = CONFIG.BgTab }, 0.18)
            tween(lbl,    { TextColor3 = CONFIG.TextMuted }, 0.18)
            tween(shimmer,{ Size = UDim2.new(0, 0, 1, 0) }, 0.25)
        end
    end)

    btn.Activated:Connect(function()
        if i == activeIndex then return end
        setActive(i)
    end)

    tabButtons[i] = {
        btn = btn,
        lbl = lbl,
        accentBar = accentBar,
        shimmer = shimmer,
    }
end

function setActive(i)
    if activeIndex == i then return end
    local prev = activeIndex
    activeIndex = i

    local old = tabButtons[prev]
    if old then
        tween(old.btn,    { BackgroundColor3 = CONFIG.BgTab }, 0.22)
        tween(old.lbl,    { TextColor3 = CONFIG.TextMuted }, 0.22)
        tween(old.accentBar, { Size = UDim2.new(0, 2, 0, 0) }, 0.22)
        tween(old.shimmer,{ Size = UDim2.new(0, 0, 1, 0) }, 0.22)
    end

    local cur = tabButtons[i]
    if cur then
        tween(cur.btn,    { BackgroundColor3 = CONFIG.BgTabActive }, 0.22)
        tween(cur.lbl,    { TextColor3 = CONFIG.ThemeColor }, 0.22)
        tween(cur.accentBar, { Size = UDim2.new(0, 2, 1, -12) }, 0.22, Enum.EasingStyle.Back)
        tween(cur.shimmer,{ Size = UDim2.new(1, 0, 1, 0) }, 0.25)
    end

    local target = cur and cur.btn or nil
    if target and tabIndicator then
        local absY = target.AbsolutePosition.Y - leftCol.AbsolutePosition.Y
        local absH = target.AbsoluteSize.Y
        tween(tabIndicator, {
            Position = UDim2.new(0, 0, 0, absY + absH * 0.5),
            Size     = UDim2.new(0, 3, 0, absH - 12),
        }, 0.28, Enum.EasingStyle.Quint)
    end

    runContent(TAB_LIST[i].url, contentHolder)
end

local function applyFilter(query)
    query = (query or ""):lower()
    if query == "" then
        for _, t in ipairs(tabButtons) do t.btn.Visible = true end
        return
    end
    for idx, t in ipairs(tabButtons) do
        local name = TAB_LIST[idx].name:lower()
        t.btn.Visible = name:find(query, 1, true) ~= nil
    end
end
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    applyFilter(searchInput.Text)
end)

backBtn.Activated:Connect(function()
    tween(main, { Size = UDim2.fromOffset(0, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.3, function() gui:Destroy() end)
end)

setActive(1)

main.Size = UDim2.fromOffset(0, 0)
tween(main, { Size = UDim2.fromOffset(720, 460) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

if CONFIG.Rainbow then
    RunService.RenderStepped:Connect(function()
        local h = tick() % 5 / 5
        local c = Color3.fromHSV(h, 1, 1)
        CONFIG.ThemeColor = c
        tabIndicator.BackgroundColor3 = c
        if tabButtons[activeIndex] then
            tabButtons[activeIndex].accentBar.BackgroundColor3 = c
            tabButtons[activeIndex].lbl.TextColor3 = c
        end
        backIcon.TextColor3 = c
        searchIcon.TextColor3 = c
    end)
end
