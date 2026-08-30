--[[
================================================================
 shop.lua  —  FishHub · Blox Fruit
 Layout : [ Back | Title | Search ]  TopBar (48px)
          [ Tabs (160px) │ Content (flex) ]
 Tabs   : Sword Shop · Gun Shop · Fighting Shop · Miss
 Auto   : runs first tab on open
 Anim   : vertical-bar indicator · Quint · 0.18s · no delay
================================================================
]]

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")

local player = Players.LocalPlayer

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------
local THEME = {
    Accent       = Color3.fromRGB(0, 229, 255),
    BgRoot       = Color3.fromRGB(7, 8, 13),
    BgPanel      = Color3.fromRGB(13, 15, 22),
    BgTab        = Color3.fromRGB(18, 20, 30),
    BgTabHover   = Color3.fromRGB(24, 27, 40),
    BgTabActive  = Color3.fromRGB(28, 32, 50),
    BgInput      = Color3.fromRGB(16, 18, 26),
    TextHi       = Color3.fromRGB(240, 242, 248),
    TextMid      = Color3.fromRGB(170, 175, 190),
    TextLo       = Color3.fromRGB(110, 115, 130),
    Stroke       = 0.55,
}

local TABS = {
    { name = "Dealer", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit/dealer.lua" },
    { name = "Fruit", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit/fruit.lua" }
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function new(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

local function corner(p, r)
    return new("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) })
end

local function stroke(p, t, tr, c)
    return new("UIStroke", {
        Parent = p,
        Color = c or THEME.Accent,
        Thickness = t or 1,
        Transparency = tr or THEME.Stroke,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function tween(obj, props, dur, style, dir)
    local info = TweenInfo.new(
        dur or 0.18,
        style or Enum.EasingStyle.Quint,
        dir or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

----------------------------------------------------------------
-- HTTP fetch (multi-executor)
----------------------------------------------------------------
local function fetch(url)
    local ok, res = pcall(function()
        if syn and syn.request then
            return syn.request({ Url = url, Method = "GET" }).Body
        elseif request then
            return request({ Url = url, Method = "GET" }).Body
        elseif http_request then
            return http_request({ Url = url, Method = "GET" }).Body
        elseif game and game.HttpGet then
            return game:HttpGet(url, true)
        end
    end)
    if ok and type(res) == "string" and #res > 5 then return res end
    return nil
end

----------------------------------------------------------------
-- GUI CLEANUP
----------------------------------------------------------------
local guiParent = (gethui and gethui()) or CoreGui or player.PlayerGui
local guiName   = "FishHub_Fruit"
if guiParent:FindFirstChild(guiName) then guiParent[guiName]:Destroy() end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local gui = new("ScreenGui", {
    Name              = guiName,
    Parent            = guiParent,
    ResetOnSpawn      = false,
    ZIndexBehavior    = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset    = true,
})

-- ==============================================================
-- MAIN PANEL
-- ==============================================================
local main = new("Frame", {
    Name                 = "Main",
    Parent               = gui,
    AnchorPoint          = Vector2.new(0.5, 0.5),
    Position             = UDim2.fromScale(0.5, 0.5),
    Size                 = UDim2.fromOffset(800, 500),
    BackgroundColor3     = THEME.BgRoot,
    BorderSizePixel      = 0,
    ClipsDescendants     = true,
})
corner(main, 14)
stroke(main, 1.2, 0.35)

-- Subtle top-edge gradient
new("UIGradient", {
    Parent    = main,
    Rotation  = 90,
    Color     = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 229, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 229, 255)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.92),
        NumberSequenceKeypoint.new(1,   1),
    }),
}).Enabled = false  -- not used; keep for future

----------------------------------------------------------------
-- TOP BAR
----------------------------------------------------------------
local topBar = new("Frame", {
    Name             = "TopBar",
    Parent           = main,
    Size             = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = THEME.BgPanel,
    BackgroundTransparency = 0.2,
    BorderSizePixel  = 0,
    ZIndex           = 5,
})
corner(topBar, 14)
-- mask bottom corners of topbar
new("Frame", {
    Parent             = topBar,
    Size               = UDim2.new(1, 0, 0, 16),
    Position           = UDim2.new(0, 0, 1, -16),
    BackgroundColor3   = topBar.BackgroundColor3,
    BackgroundTransparency = topBar.BackgroundTransparency,
    BorderSizePixel    = 0,
})

-- Thin accent line under top bar
new("Frame", {
    Parent             = topBar,
    Size               = UDim2.new(1, -24, 0, 1),
    Position           = UDim2.new(0, 12, 1, -1),
    BackgroundColor3   = THEME.Accent,
    BackgroundTransparency = 0.75,
    BorderSizePixel    = 0,
})

-- Back button
local back = new("TextButton", {
    Parent           = topBar,
    Position         = UDim2.new(0, 10, 0, 8),
    Size             = UDim2.fromOffset(32, 32),
    BackgroundColor3 = THEME.BgTab,
    AutoButtonColor  = false,
    Text             = "",
})
corner(back, 8)
stroke(back, 1, 0.5)
local backIcon = new("TextLabel", {
    Parent = back,
    Size   = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text   = "←",
    Font   = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = THEME.Accent,
})
back.MouseEnter:Connect(function()
    tween(back,    { BackgroundColor3 = THEME.BgTabHover }, 0.15)
    tween(backIcon,{ TextColor3 = Color3.new(1,1,1) }, 0.15)
end)
back.MouseLeave:Connect(function()
    tween(back,    { BackgroundColor3 = THEME.BgTab }, 0.15)
    tween(backIcon,{ TextColor3 = THEME.Accent }, 0.15)
end)
back.Activated:Connect(function()
    tween(main, { Size = UDim2.fromOffset(0, 0) }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.22, function() gui:Destroy() end)
end)

-- Title
new("TextLabel", {
    Parent = topBar,
    Position = UDim2.new(0, 52, 0, 0),
    Size   = UDim2.new(0, 110, 1, 0),
    BackgroundTransparency = 1,
    Text   = "FRUIT",
    Font   = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = THEME.TextHi,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Search box
local searchBox = new("Frame", {
    Parent = topBar,
    Position = UDim2.new(0, 168, 0, 8),
    Size   = UDim2.new(1, -178, 0, 32),
    BackgroundColor3 = THEME.BgInput,
    BorderSizePixel = 0,
})
corner(searchBox, 8)
stroke(searchBox, 1, 0.55)

-- Search icon
local searchIcon = new("TextLabel", {
    Parent = searchBox,
    Position = UDim2.new(0, 10, 0, 0),
    Size   = UDim2.fromOffset(20, 32),
    BackgroundTransparency = 1,
    Text   = "⌕",
    Font   = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = THEME.Accent,
    TextXAlignment = Enum.TextXAlignment.Center,
})
-- Search input
local searchInput = new("TextBox", {
    Parent = searchBox,
    Position = UDim2.new(0, 36, 0, 0),
    Size   = UDim2.new(1, -42, 1, 0),
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    Text   = "",
    PlaceholderText = "search...",
    PlaceholderColor3 = THEME.TextLo,
    Font   = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = THEME.TextHi,
    TextXAlignment = Enum.TextXAlignment.Left,
})

----------------------------------------------------------------
-- BODY
----------------------------------------------------------------
local body = new("Frame", {
    Parent = main,
    Position = UDim2.new(0, 0, 0, 48),
    Size   = UDim2.new(1, 0, 1, -48),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
})

-- LEFT: tab menu (160px)
local leftCol = new("Frame", {
    Parent = body,
    Size   = UDim2.new(0, 160, 1, 0),
    BackgroundColor3 = THEME.BgPanel,
    BackgroundTransparency = 0.35,
    BorderSizePixel  = 0,
})
new("UIPadding", {
    Parent = leftCol,
    PaddingTop    = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft   = UDim.new(0, 10),
    PaddingRight  = UDim.new(0, 10),
})
new("UIListLayout", {
    Parent = leftCol,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
})

-- DIVIDER (vertical line between left/right)
new("Frame", {
    Parent = body,
    Position = UDim2.new(0, 160, 0, 0),
    Size   = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = THEME.Accent,
    BackgroundTransparency = 0.7,
    BorderSizePixel = 0,
    ZIndex = 3,
})

-- RIGHT: content area
local rightCol = new("Frame", {
    Parent = body,
    Position = UDim2.new(0, 161, 0, 0),
    Size   = UDim2.new(1, -161, 1, 0),
    BackgroundColor3 = THEME.BgPanel,
    BackgroundTransparency = 0.55,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
})
new("UIPadding", {
    Parent = rightCol,
    PaddingTop    = UDim.new(0, 14),
    PaddingBottom = UDim.new(0, 14),
    PaddingLeft   = UDim.new(0, 16),
    PaddingRight  = UDim.new(0, 16),
})

-- Content header (tab name display)
local contentHeader = new("TextLabel", {
    Parent = rightCol,
    Size   = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Font   = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = THEME.Accent,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text   = "",
})

-- Content body
local contentBody = new("TextLabel", {
    Parent = rightCol,
    Position = UDim2.new(0, 0, 0, 26),
    Size   = UDim2.new(1, 0, 1, -28),
    BackgroundTransparency = 1,
    Font   = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = THEME.TextMid,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped   = true,
    Text   = "",
})

----------------------------------------------------------------
-- TAB BUTTONS
----------------------------------------------------------------
local activeIdx = 1
local tabBtns   = {}
local indicator

-- vertical-bar indicator (kẻ dọc)
indicator = new("Frame", {
    Parent = leftCol,
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 0, 0, 0),
    Size   = UDim2.new(0, 3, 0, 0),
    BackgroundColor3 = THEME.Accent,
    BorderSizePixel  = 0,
    ZIndex = 10,
})
corner(indicator, 2)

-- glow halo behind indicator
local indicatorGlow = new("Frame", {
    Parent = leftCol,
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 0, 0, 0),
    Size   = UDim2.new(0, 3, 0, 0),
    BackgroundColor3 = THEME.Accent,
    BackgroundTransparency = 0.75,
    BorderSizePixel  = 0,
    ZIndex = 9,
})
corner(indicatorGlow, 3)

for i, info in ipairs(TABS) do
    local btn = new("TextButton", {
        Parent = leftCol,
        LayoutOrder = i,
        Size   = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = THEME.BgTab,
        AutoButtonColor  = false,
        Text   = "",
        BorderSizePixel = 0,
    })
    corner(btn, 8)
    stroke(btn, 1, 0.78)

    -- Left-edge bar (subtle, will animate when active)
    local edgeBar = new("Frame", {
        Parent = btn,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size   = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = THEME.Accent,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
    })
    corner(edgeBar, 1)

    -- Shimmer overlay (hover)
    local shimmer = new("Frame", {
        Parent = btn,
        Size   = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = THEME.Accent,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = 0,
    })
    corner(shimmer, 8)

    -- Label
    local lbl = new("TextLabel", {
        Parent = btn,
        Position = UDim2.new(0, 14, 0, 0),
        Size   = UDim2.new(1, -18, 1, 0),
        BackgroundTransparency = 1,
        Text   = info.name,
        Font   = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = THEME.TextMid,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Index dot (right)
    local dot = new("TextLabel", {
        Parent = btn,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size   = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        Text   = tostring(i),
        Font   = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = THEME.TextLo,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    btn.MouseEnter:Connect(function()
        if i == activeIdx then return end
        tween(btn,     { BackgroundColor3 = THEME.BgTabHover }, 0.15)
        tween(lbl,     { TextColor3 = THEME.TextHi }, 0.15)
        tween(shimmer, { Size = UDim2.new(1, 0, 1, 0) }, 0.2)
        tween(dot,     { TextColor3 = THEME.Accent }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        if i == activeIdx then return end
        tween(btn,     { BackgroundColor3 = THEME.BgTab }, 0.15)
        tween(lbl,     { TextColor3 = THEME.TextMid }, 0.15)
        tween(shimmer, { Size = UDim2.new(0, 0, 1, 0) }, 0.2)
        tween(dot,     { TextColor3 = THEME.TextLo }, 0.15)
    end)

    btn.Activated:Connect(function()
        if i == activeIdx then return end
        setActive(i)
    end)

    tabBtns[i] = { btn = btn, lbl = lbl, edgeBar = edgeBar, shimmer = shimmer, dot = dot }
end

----------------------------------------------------------------
-- SET ACTIVE (with smooth animations)
----------------------------------------------------------------
function setActive(i)
    if activeIdx == i then return end
    local prev = activeIdx
    activeIdx = i

    -- old tab reset
    local old = tabBtns[prev]
    if old then
        tween(old.btn,      { BackgroundColor3 = THEME.BgTab }, 0.18)
        tween(old.lbl,      { TextColor3 = THEME.TextMid }, 0.18)
        tween(old.edgeBar,  { Size = UDim2.new(0, 0, 1, -10) }, 0.18)
        tween(old.shimmer,  { Size = UDim2.new(0, 0, 1, 0) }, 0.18)
        tween(old.dot,      { TextColor3 = THEME.TextLo }, 0.18)
        tween(old.btn:FindFirstChildOfClass("UIStroke"), { Transparency = 0.78 }, 0.18)
    end

    -- new tab activate
    local cur = tabBtns[i]
    if cur then
        tween(cur.btn,      { BackgroundColor3 = THEME.BgTabActive }, 0.18)
        tween(cur.lbl,      { TextColor3 = THEME.Accent }, 0.18)
        tween(cur.edgeBar,  { Size = UDim2.new(0, 3, 1, -10) }, 0.2, Enum.EasingStyle.Back)
        tween(cur.shimmer,  { Size = UDim2.new(1, 0, 1, 0) }, 0.25)
        tween(cur.dot,      { TextColor3 = THEME.Accent }, 0.18)
        tween(cur.btn:FindFirstChildOfClass("UIStroke"), { Transparency = 0.15 }, 0.18)
    end

    -- move vertical bar indicator
    if indicator and cur then
        local absY = cur.btn.AbsolutePosition.Y - leftCol.AbsolutePosition.Y
        local absH = cur.btn.AbsoluteSize.Y
        local targetY = absY + absH * 0.5
        local targetH = absH - 10
        tween(indicator, {
            Position = UDim2.new(0, 0, 0, targetY),
            Size     = UDim2.new(0, 3, 0, targetH),
        }, 0.22, Enum.EasingStyle.Quint)
        tween(indicatorGlow, {
            Position = UDim2.new(0, 0, 0, targetY),
            Size     = UDim2.new(0, 3, 0, targetH + 6),
        }, 0.22, Enum.EasingStyle.Quint)
    end

    -- load content
    loadContent(TABS[i].url, TABS[i].name)
end

----------------------------------------------------------------
-- LOAD CONTENT (HTTP fetch + render)
----------------------------------------------------------------
function loadContent(url, name)
    -- clear
    contentBody.Text = ""
    contentHeader.Text = "▸ " .. (name or "")
    -- loading state
    task.spawn(function()
        local src = fetch(url)
        if src and #src > 0 then
            -- format ngắn gọn, sơ sài
            local short = src
            if #short > 1800 then short = short:sub(1, 1800) .. "\n\n... (truncated)" end
            -- fade-in
            contentBody.TextTransparency = 1
            contentBody.Text = short
            tween(contentBody, { TextTransparency = 0 }, 0.25)
        else
            contentBody.Text = "⚠  Không thể tải nội dung.\nKiểm tra executor có hỗ trợ HTTP request."
            contentBody.TextColor3 = Color3.fromRGB(255, 110, 110)
        end
    end)
end

----------------------------------------------------------------
-- SEARCH FILTER (filters tab list)
----------------------------------------------------------------
local function applyFilter(q)
    q = (q or ""):lower()
    for idx, t in ipairs(tabBtns) do
        local n = TABS[idx].name:lower()
        local match = (q == "") or (n:find(q, 1, true) ~= nil)
        t.btn.Visible = match
    end
end
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    applyFilter(searchInput.Text)
end)

----------------------------------------------------------------
-- INIT
----------------------------------------------------------------
-- force first render to lock layout
main.Size = UDim2.fromOffset(0, 0)
main.Size = UDim2.fromOffset(800, 500)
task.wait()  -- 1 frame for layout

setActive(1)

-- intro animation
main.Size = UDim2.fromOffset(0, 0)
tween(main, { Size = UDim2.fromOffset(800, 500) }, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

----------------------------------------------------------------
-- OPTIONAL: theme pulse (kẻ dọc indicator glow)
----------------------------------------------------------------
task.spawn(function()
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not indicator or not indicator.Parent then
            conn:Disconnect(); return
        end
        t += dt
        local pulse = 0.55 + math.sin(t * 2.2) * 0.15
        if indicatorGlow then
            indicatorGlow.BackgroundTransparency = pulse
        end
    end)
end)
