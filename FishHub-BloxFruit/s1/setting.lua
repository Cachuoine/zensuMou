--[[
================================================================
 setting.lua  —  FishHub · Blox Fruit
 Panel đơn giản, không có tabs.
 TopBar & search icon dùng chung style với các file khác.
================================================================
]]

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")

local player = Players.LocalPlayer

----------------------------------------------------------------
-- THEME  (giống các file khác)
----------------------------------------------------------------
local THEME = {
    Accent       = Color3.fromRGB(0, 229, 255),
    BgRoot       = Color3.fromRGB(7, 8, 13),
    BgPanel      = Color3.fromRGB(13, 15, 22),
    BgTab        = Color3.fromRGB(18, 20, 30),
    BgItem       = Color3.fromRGB(20, 22, 32),
    BgInput      = Color3.fromRGB(16, 18, 26),
    TextHi       = Color3.fromRGB(240, 242, 248),
    TextMid      = Color3.fromRGB(170, 175, 190),
    TextLo       = Color3.fromRGB(110, 115, 130),
    Stroke       = 0.55,
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function new(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end
local function corner(p, r) return new("UICorner", { Parent = p, CornerRadius = UDim.new(0, r) }) end
local function stroke(p, t, tr, c)
    return new("UIStroke", {
        Parent = p, Color = c or THEME.Accent,
        Thickness = t or 1, Transparency = tr or THEME.Stroke,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end
local function tween(obj, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local guiParent = (gethui and gethui()) or CoreGui or player.PlayerGui
local guiName   = "FishHub_Setting"
if guiParent:FindFirstChild(guiName) then guiParent[guiName]:Destroy() end

local gui = new("ScreenGui", {
    Name = guiName, Parent = guiParent,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})

local main = new("Frame", {
    Parent = gui,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(560, 440),
    BackgroundColor3 = THEME.BgRoot,
    BorderSizePixel = 0, ClipsDescendants = true,
})
corner(main, 14)
stroke(main, 1.2, 0.35)

----------------------------------------------------------------
-- TOP BAR
----------------------------------------------------------------
local topBar = new("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = THEME.BgPanel,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0, ZIndex = 5,
})
corner(topBar, 14)
new("Frame", {
    Parent = topBar, Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 1, -16),
    BackgroundColor3 = topBar.BackgroundColor3,
    BackgroundTransparency = topBar.BackgroundTransparency,
    BorderSizePixel = 0,
})
new("Frame", {
    Parent = topBar, Size = UDim2.new(1, -24, 0, 1),
    Position = UDim2.new(0, 12, 1, -1),
    BackgroundColor3 = THEME.Accent,
    BackgroundTransparency = 0.75, BorderSizePixel = 0,
})

-- Back
local back = new("TextButton", {
    Parent = topBar, Position = UDim2.new(0, 10, 0, 8),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = THEME.BgTab, AutoButtonColor = false, Text = "",
})
corner(back, 8); stroke(back, 1, 0.5)
local backIcon = new("TextLabel", {
    Parent = back, Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, Text = "←",
    Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = THEME.Accent,
})
back.MouseEnter:Connect(function()
    tween(back, { BackgroundColor3 = Color3.fromRGB(24, 27, 40) }, 0.15)
    tween(backIcon, { TextColor3 = Color3.new(1,1,1) }, 0.15)
end)
back.MouseLeave:Connect(function()
    tween(back, { BackgroundColor3 = THEME.BgTab }, 0.15)
    tween(backIcon, { TextColor3 = THEME.Accent }, 0.15)
end)
back.Activated:Connect(function()
    tween(main, { Size = UDim2.fromOffset(0, 0) }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.22, function() gui:Destroy() end)
end)

new("TextLabel", {
    Parent = topBar, Position = UDim2.new(0, 52, 0, 0),
    Size = UDim2.new(0, 110, 1, 0), BackgroundTransparency = 1,
    Text = "SETTING", Font = Enum.Font.GothamBold, TextSize = 15,
    TextColor3 = THEME.TextHi, TextXAlignment = Enum.TextXAlignment.Left,
})

-- Search box  (icon "⌕" giống hệt các file khác)
local searchBox = new("Frame", {
    Parent = topBar, Position = UDim2.new(0, 168, 0, 8),
    Size = UDim2.new(1, -178, 0, 32),
    BackgroundColor3 = THEME.BgInput, BorderSizePixel = 0,
})
corner(searchBox, 8); stroke(searchBox, 1, 0.55)

local searchIcon = new("TextLabel", {
    Parent = searchBox, Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.fromOffset(20, 32), BackgroundTransparency = 1,
    Text = "⌕", Font = Enum.Font.GothamBold, TextSize = 16,
    TextColor3 = THEME.Accent, TextXAlignment = Enum.TextXAlignment.Center,
})
local searchInput = new("TextBox", {
    Parent = searchBox, Position = UDim2.new(0, 36, 0, 0),
    Size = UDim2.new(1, -42, 1, 0), BackgroundTransparency = 1,
    ClearTextOnFocus = false, Text = "",
    PlaceholderText = "search settings...",
    PlaceholderColor3 = THEME.TextLo,
    Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = THEME.TextHi, TextXAlignment = Enum.TextXAlignment.Left,
})

----------------------------------------------------------------
-- BODY  — simple list (no tabs)
----------------------------------------------------------------
local body = new("Frame", {
    Parent = main, Position = UDim2.new(0, 0, 0, 48),
    Size = UDim2.new(1, 0, 1, -48),
    BackgroundColor3 = THEME.BgPanel,
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0, ClipsDescendants = true,
})
new("UIPadding", {
    Parent = body,
    PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16),
})
new("UIListLayout", {
    Parent = body, SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
})

-- Setting items
local SETTINGS = {
    { label = "UI Theme",        hint = "accent color" },
    { label = "Rainbow",         hint = "animated hue" },
    { label = "Auto Save",       hint = "persist state" },
    { label = "Notifications",   hint = "popup alerts"  },
    { label = "Language",        hint = "ui locale"     },
    { label = "Performance",     hint = "fps boost"     },
    { label = "Reset Config",    hint = "restore"       },
}

for i, s in ipairs(SETTINGS) do
    local row = new("Frame", {
        Parent = body, LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = THEME.BgItem, BorderSizePixel = 0,
    })
    corner(row, 8); stroke(row, 1, 0.7)

    new("TextLabel", {
        Parent = row, Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -90, 1, 0), BackgroundTransparency = 1,
        Text = s.label, Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = THEME.TextHi, TextXAlignment = Enum.TextXAlignment.Left,
    })

    new("TextLabel", {
        Parent = row, Position = UDim2.new(1, -80, 0, 0),
        Size = UDim2.new(0, 70, 1, 0), BackgroundTransparency = 1,
        Text = s.hint, Font = Enum.Font.GothamMedium, TextSize = 10,
        TextColor3 = THEME.TextLo, TextXAlignment = Enum.TextXAlignment.Right,
    })

    -- hover effect
    local btn = new("TextButton", {
        Parent = row, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
    })
    btn.MouseEnter:Connect(function()
        tween(row, { BackgroundColor3 = Color3.fromRGB(26, 28, 42) }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(row, { BackgroundColor3 = THEME.BgItem }, 0.15)
    end)
end

-- search filter rows
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = searchInput.Text:lower()
    local idx = 0
    for _, child in ipairs(body:GetChildren()) do
        if child:IsA("Frame") then
            idx += 1
            if SETTINGS[idx] then
                local match = (q == "") or SETTINGS[idx].label:lower():find(q, 1, true) ~= nil
                child.Visible = match
            end
        end
    end
end)

----------------------------------------------------------------
-- INTRO
----------------------------------------------------------------
main.Size = UDim2.fromOffset(0, 0)
tween(main, { Size = UDim2.fromOffset(560, 440) }, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
