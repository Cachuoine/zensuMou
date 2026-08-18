--// FishHub Creative.lua
--// Creative profile: @thankhuyenhuy
--// Script by DaoHuyLam

local context = ...

local Players = (context and context.Players) or game:GetService("Players")
local TweenService = (context and context.TweenService) or game:GetService("TweenService")
local player = (context and context.Player) or Players.LocalPlayer
local tab = context and context.Tab

if not tab then
    return
end

-- Clean ONLY the Creative tab.
for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

tab.CanvasSize = UDim2.new(0, 0, 0, 0)
tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
tab.ScrollingDirection = Enum.ScrollingDirection.Y
tab.ScrollBarThickness = 0

local ACCENT = Color3.fromRGB(0, 229, 255)
local PURPLE = Color3.fromRGB(168, 85, 247)
local BG = Color3.fromRGB(9, 11, 18)
local CARD = Color3.fromRGB(15, 18, 28)
local TEXT = Color3.fromRGB(245, 247, 255)
local MUTED = Color3.fromRGB(145, 151, 170)

local function tween(instance, info, props)
    local t = TweenService:Create(instance, info, props)
    t:Play()
    return t
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function label(parent, text, size, position, font, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or TEXT
    l.Font = font or Enum.Font.GothamMedium
    l.TextSize = size
    l.Position = position
    l.Size = UDim2.new(1, 0, 0, size + 8)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- Main creative canvas.
local root = Instance.new("Frame")
root.Name = "CreativeRoot"
root.Size = UDim2.new(1, -8, 0, 330)
root.Position = UDim2.new(0, 4, 0, 4)
root.BackgroundColor3 = BG
root.BorderSizePixel = 0
root.Parent = tab
corner(root, 14)
stroke(root, ACCENT, 1.2, 0.55)

-- Soft animated accent line.
local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(1, -34, 0, 2)
topGlow.Position = UDim2.new(0, 17, 0, 16)
topGlow.BackgroundColor3 = ACCENT
topGlow.BorderSizePixel = 0
topGlow.Parent = root
corner(topGlow, 2)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT),
    ColorSequenceKeypoint.new(0.5, PURPLE),
    ColorSequenceKeypoint.new(1, ACCENT)
})
gradient.Parent = topGlow

task.spawn(function()
    local offset = -1
    while topGlow.Parent do
        offset += 0.012
        if offset > 1 then offset = -1 end
        gradient.Offset = Vector2.new(offset, 0)
        task.wait(0.025)
    end
end)

-- Header.
local badge = Instance.new("Frame")
badge.Size = UDim2.new(0, 42, 0, 42)
badge.Position = UDim2.new(0, 22, 0, 34)
badge.BackgroundColor3 = ACCENT
badge.BackgroundTransparency = 0.84
badge.BorderSizePixel = 0
badge.Parent = root
corner(badge, 12)
stroke(badge, ACCENT, 1, 0.35)

local badgeText = label(badge, "✦", 20, UDim2.new(0, 0, 0, 4), Enum.Font.GothamBold, ACCENT)
badgeText.TextXAlignment = Enum.TextXAlignment.Center

local title = label(root, "CREATIVE", 21, UDim2.new(0, 78, 0, 34), Enum.Font.GothamBold, TEXT)
local subtitle = label(root, "A personal space crafted for @thankhuyenhuy", 10, UDim2.new(0, 80, 0, 61), Enum.Font.GothamMedium, MUTED)

local author = label(root, "SCRIPT BY  •  DaoHuyLam", 9, UDim2.new(0, 80, 0, 80), Enum.Font.Code, ACCENT)

-- Profile card.
local profile = Instance.new("Frame")
profile.Size = UDim2.new(1, -44, 0, 104)
profile.Position = UDim2.new(0, 22, 0, 112)
profile.BackgroundColor3 = CARD
profile.BackgroundTransparency = 0.08
profile.BorderSizePixel = 0
profile.Parent = root
corner(profile, 12)
stroke(profile, PURPLE, 1, 0.62)

local avatarHolder = Instance.new("Frame")
avatarHolder.Size = UDim2.new(0, 66, 0, 66)
avatarHolder.Position = UDim2.new(0, 18, 0.5, 0)
avatarHolder.AnchorPoint = Vector2.new(0, 0.5)
avatarHolder.BackgroundColor3 = Color3.fromRGB(23, 26, 39)
avatarHolder.BorderSizePixel = 0
avatarHolder.Parent = profile
corner(avatarHolder, 16)
stroke(avatarHolder, ACCENT, 1.2, 0.35)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(1, -6, 1, -6)
avatar.Position = UDim2.new(0, 3, 0, 3)
avatar.BackgroundTransparency = 1
avatar.Parent = avatarHolder
corner(avatar, 14)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
end)

local handle = label(profile, "@thankhuyenhuy", 15, UDim2.new(0, 98, 0, 22), Enum.Font.GothamBold, TEXT)
local realName = label(profile, "Roblox profile", 10, UDim2.new(0, 98, 0, 46), Enum.Font.GothamMedium, MUTED)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 7, 0, 7)
statusDot.Position = UDim2.new(1, -112, 0, 28)
statusDot.BackgroundColor3 = Color3.fromRGB(55, 235, 135)
statusDot.BorderSizePixel = 0
statusDot.Parent = profile
corner(statusDot, 10)

local status = label(profile, "CREATIVE", 9, UDim2.new(1, -98, 0, 20), Enum.Font.Code, Color3.fromRGB(55, 235, 135))
status.TextXAlignment = Enum.TextXAlignment.Right

-- Footer cards.
local leftInfo = Instance.new("Frame")
leftInfo.Size = UDim2.new(0.5, -26, 0, 72)
leftInfo.Position = UDim2.new(0, 22, 0, 228)
leftInfo.BackgroundColor3 = CARD
leftInfo.BorderSizePixel = 0
leftInfo.Parent = root
corner(leftInfo, 11)
stroke(leftInfo, ACCENT, 1, 0.7)

local rightInfo = Instance.new("Frame")
rightInfo.Size = UDim2.new(0.5, -26, 0, 72)
rightInfo.Position = UDim2.new(0.5, 4, 0, 228)
rightInfo.BackgroundColor3 = CARD
rightInfo.BorderSizePixel = 0
rightInfo.Parent = root
corner(rightInfo, 11)
stroke(rightInfo, PURPLE, 1, 0.7)

local l1 = label(leftInfo, "IDENTITY", 8, UDim2.new(0, 14, 0, 10), Enum.Font.Code, MUTED)
local l2 = label(leftInfo, "thankhuyenhuy", 13, UDim2.new(0, 14, 0, 29), Enum.Font.GothamBold, TEXT)

local r1 = label(rightInfo, "AUTHOR", 8, UDim2.new(0, 14, 0, 10), Enum.Font.Code, MUTED)
local r2 = label(rightInfo, "DaoHuyLam", 13, UDim2.new(0, 14, 0, 29), Enum.Font.GothamBold, TEXT)

-- Bottom signature.
local signature = label(root, "✦  FISHHUB CREATIVE  /  @thankhuyenhuy", 8, UDim2.new(0, 22, 1, -25), Enum.Font.Code, Color3.fromRGB(105, 111, 130))

-- Entrance animation.
root.BackgroundTransparency = 1
profile.BackgroundTransparency = 1
leftInfo.BackgroundTransparency = 1
rightInfo.BackgroundTransparency = 1
badge.BackgroundTransparency = 1

for _, obj in ipairs({title, subtitle, author, handle, realName, status, l1, l2, r1, r2, signature, badgeText}) do
    obj.TextTransparency = 1
end

task.spawn(function()
    task.wait(0.05)
    tween(root, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween(badge, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.84
    })

    for _, obj in ipairs({title, subtitle, author, handle, realName, status, l1, l2, r1, r2, signature, badgeText}) do
        tween(obj, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })
        task.wait(0.035)
    end

    tween(profile, TweenInfo.new(0.4), {BackgroundTransparency = 0.08})
    tween(leftInfo, TweenInfo.new(0.4), {BackgroundTransparency = 0})
    tween(rightInfo, TweenInfo.new(0.4), {BackgroundTransparency = 0})
end)

-- Subtle breathing animation for the accent.
task.spawn(function()
    while root.Parent do
        tween(topGlow, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.15
        })
        task.wait(1.1)
        tween(topGlow, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.45
        })
        task.wait(1.1)
    end
end)

return true
