--[[
    setting.lua
    Blox Fruit - Setting Panel
    Layout: Top bar (back + search) + content area
    Note: Không có tabs, chỉ là panel setting đơn giản.
          Top bar & search icon dùng chung style với các file khác.
]]

local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")

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
    BgItem       = Color3.fromRGB(20, 22, 32),
    TextPrimary  = Color3.fromRGB(240, 242, 248),
    TextMuted    = Color3.fromRGB(130, 135, 150),
    StrokeAlpha  = 0.55,
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
-- UI BUILD
-- =========================================================================
if player.PlayerGui:FindFirstChild("FishHubSetting") then
    player.PlayerGui.FishHubSetting:Destroy()
end

local gui = New("ScreenGui", {
    Name = "FishHubSetting",
    Parent = player.PlayerGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})

local main = New("Frame", {
    Parent = gui,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(540, 420),
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

-- =================== TOP BAR (giống các file khác) ===================
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
    Text = "SETTING",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = CONFIG.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Search box — icon "⌕" giống hệt các file khác
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
    PlaceholderText = "search settings...",
    PlaceholderColor3 = CONFIG.TextMuted,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = CONFIG.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- =================== BODY (content area) ===================
local body = New("Frame", {
    Parent = main,
    Position = UDim2.new(0, 0, 0, 48),
    Size = UDim2.new(1, 0, 1, -48),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
})

local contentWrap = New("Frame", {
    Parent = body,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = CONFIG.BgPanel,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})
Pad(contentWrap, 14, 14, 14, 14)

local list = New("UIListLayout", {
    Parent = contentWrap,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
})

-- Một số setting mẫu
local SETTINGS = {
    { label = "UI Theme",   hint = "accent color" },
    { label = "Rainbow",    hint = "animated hue" },
    { label = "Auto Save",  hint = "persist state" },
    { label = "Notifications", hint = "popup alerts" },
    { label = "Language",   hint = "ui locale" },
}

for i, s in ipairs(SETTINGS) do
    local row = New("Frame", {
        Parent = contentWrap,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = CONFIG.BgItem,
        BorderSizePixel = 0,
    })
    Corner(row, 8)
    Stroke(row, 1, 0.7)

    New("TextLabel", {
        Parent = row,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = s.label,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = CONFIG.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    New("TextLabel", {
        Parent = row,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 60, 1, 0),
        BackgroundTransparency = 1,
        Text = s.hint,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = CONFIG.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
end

-- =================== SEARCH (filter rows) ===================
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = searchInput.Text:lower()
    for idx, child in ipairs(contentWrap:GetChildren()) do
        if child:IsA("Frame") and SETTINGS[idx] then
            child.Visible = q == "" or SETTINGS[idx].label:lower():find(q, 1, true) ~= nil
        end
    end
end)

-- =================== BACK ===================
backBtn.Activated:Connect(function()
    tween(main, { Size = UDim2.fromOffset(0, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.3, function() gui:Destroy() end)
end)

-- =================== INTRO ===================
main.Size = UDim2.fromOffset(0, 0)
tween(main, { Size = UDim2.fromOffset(540, 420) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
