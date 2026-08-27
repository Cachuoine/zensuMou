-- FishHub Creative.lua
-- Designed for the FishHub main context contract.
-- Premium animated creator/social panel with theme + optional rainbow accents.

local context = ...
if type(context) ~= "table" then
    return
end

local Player = context.Player or game:GetService("Players").LocalPlayer
local Tab = context.Tab
local TweenService = context.TweenService or game:GetService("TweenService")
local Players = context.Players or game:GetService("Players")
local Config = context.Config or {}
local ShowNotification = context.ShowNotification or function() end

if not Tab then return end
for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.ClipsDescendants = true
Tab.ScrollBarThickness = 0
Tab.CanvasSize = UDim2.new(0,0,0,0)

local function accent()
    return Config.ThemeColor or Color3.fromRGB(0,229,255)
end

local root = Instance.new("Frame")
root.Name = "CreativeRoot"
root.Parent = Tab
root.Size = UDim2.new(1,0,1,0)
root.BackgroundTransparency = 1

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = obj
    return c
end

local function stroke(obj, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = accent()
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.2
    s.Parent = obj
    return s
end

local function tween(obj, info, props)
    return TweenService:Create(obj, info, props)
end

-- Ambient center glow.
local ambient = Instance.new("Frame")
ambient.Parent = root
ambient.Size = UDim2.new(0,330,0,330)
ambient.Position = UDim2.new(0.5,0,0.5,0)
ambient.AnchorPoint = Vector2.new(0.5,0.5)
ambient.BackgroundColor3 = accent()
ambient.BackgroundTransparency = 0.965
ambient.BorderSizePixel = 0
ambient.ZIndex = 0
corner(ambient, 165)

-- Header.
local title = Instance.new("TextLabel")
title.Parent = root
title.Size = UDim2.new(1,0,0,28)
title.Position = UDim2.new(0,0,0,4)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Text = "CREATIVE"
title.TextColor3 = Color3.fromRGB(245,247,255)
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 4

local subtitle = Instance.new("TextLabel")
subtitle.Parent = root
subtitle.Size = UDim2.new(1,0,0,18)
subtitle.Position = UDim2.new(0,0,0,30)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Code
subtitle.TextSize = 8
subtitle.Text = "DESIGN • COMMUNITY • CREATOR"
subtitle.TextColor3 = Color3.fromRGB(125,132,150)
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.ZIndex = 4

local divider = Instance.new("Frame")
divider.Parent = root
divider.Size = UDim2.new(0.82,0,0,1)
divider.Position = UDim2.new(0.5,0,0,52)
divider.AnchorPoint = Vector2.new(0.5,0)
divider.BackgroundColor3 = accent()
divider.BackgroundTransparency = 0.15
divider.BorderSizePixel = 0
divider.ZIndex = 4

-- Creator card.
local card = Instance.new("Frame")
card.Parent = root
card.Size = UDim2.new(0,430,0,116)
card.Position = UDim2.new(0.5,0,0,68)
card.AnchorPoint = Vector2.new(0.5,0)
card.BackgroundColor3 = Color3.fromRGB(17,19,28)
card.BackgroundTransparency = 0.04
card.BorderSizePixel = 0
card.ZIndex = 2
corner(card, 18)
local cardStroke = stroke(card, 1.2, 0.28)

local avatar = Instance.new("ImageLabel")
avatar.Parent = card
avatar.Size = UDim2.new(0,74,0,74)
avatar.Position = UDim2.new(0,20,0.5,0)
avatar.AnchorPoint = Vector2.new(0,0.5)
avatar.BackgroundColor3 = Color3.fromRGB(26,29,40)
avatar.BackgroundTransparency = 0
avatar.BorderSizePixel = 0
avatar.ZIndex = 5
corner(avatar, 37)

pcall(function()
    avatar.Image = Players:GetUserThumbnailAsync(
        Player and Player.UserId or 1,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
end)

local avatarStroke = stroke(avatar, 2, 0.05)
local avatarGlow = Instance.new("UIStroke")
avatarGlow.Parent = avatar
avatarGlow.Color = accent()
avatarGlow.Thickness = 7
avatarGlow.Transparency = 0.78

local creatorLabel = Instance.new("TextLabel")
creatorLabel.Parent = card
creatorLabel.Size = UDim2.new(1,-120,0,24)
creatorLabel.Position = UDim2.new(0,112,0,23)
creatorLabel.BackgroundTransparency = 1
creatorLabel.Font = Enum.Font.GothamBlack
creatorLabel.TextSize = 16
creatorLabel.Text = Player and Player.DisplayName or "FishHub Creator"
creatorLabel.TextColor3 = Color3.fromRGB(245,247,255)
creatorLabel.TextXAlignment = Enum.TextXAlignment.Left
creatorLabel.ZIndex = 5

local handle = Instance.new("TextLabel")
handle.Parent = card
handle.Size = UDim2.new(1,-120,0,18)
handle.Position = UDim2.new(0,113,0,48)
handle.BackgroundTransparency = 1
handle.Font = Enum.Font.Code
handle.TextSize = 9
handle.Text = "@" .. (Player and Player.Name or "creator")
handle.TextColor3 = accent()
handle.TextXAlignment = Enum.TextXAlignment.Left
handle.ZIndex = 5

local role = Instance.new("TextLabel")
role.Parent = card
role.Size = UDim2.new(1,-120,0,16)
role.Position = UDim2.new(0,113,0,72)
role.BackgroundTransparency = 1
role.Font = Enum.Font.GothamMedium
role.TextSize = 9
role.Text = "FishHub Creative • UI Experience"
role.TextColor3 = Color3.fromRGB(135,141,158)
role.TextXAlignment = Enum.TextXAlignment.Left
role.ZIndex = 5

-- Three circular social/action buttons.
local buttonRow = Instance.new("Frame")
buttonRow.Parent = root
buttonRow.Size = UDim2.new(0,300,0,86)
buttonRow.Position = UDim2.new(0.5,0,0,198)
buttonRow.AnchorPoint = Vector2.new(0.5,0)
buttonRow.BackgroundTransparency = 1
buttonRow.ZIndex = 5

local rowLayout = Instance.new("UIListLayout")
rowLayout.Parent = buttonRow
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
rowLayout.Padding = UDim.new(0,28)

local circles = {}

local function createCircle(icon, labelText, idText)
    local holder = Instance.new("Frame")
    holder.Parent = buttonRow
    holder.Size = UDim2.new(0,72,0,82)
    holder.BackgroundTransparency = 1
    holder.ZIndex = 5

    local btn = Instance.new("TextButton")
    btn.Parent = holder
    btn.Size = UDim2.new(0,58,0,58)
    btn.Position = UDim2.new(0.5,0,0,0)
    btn.AnchorPoint = Vector2.new(0.5,0)
    btn.BackgroundColor3 = Color3.fromRGB(20,23,33)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = icon
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.TextColor3 = Color3.fromRGB(224,228,238)
    btn.ZIndex = 7
    corner(btn, 29)

    local ring = stroke(btn, 2, 0.04)
    local glow = Instance.new("UIStroke")
    glow.Parent = btn
    glow.Name = "RainbowGlow"
    glow.Thickness = 8
    glow.Transparency = 0.82
    glow.Color = accent()

    local inner = Instance.new("Frame")
    inner.Parent = btn
    inner.Size = UDim2.new(0,5,0,5)
    inner.Position = UDim2.new(0.5,0,0.5,0)
    inner.AnchorPoint = Vector2.new(0.5,0.5)
    inner.BackgroundColor3 = accent()
    inner.BorderSizePixel = 0
    inner.ZIndex = 8
    corner(inner, 5)

    local label = Instance.new("TextLabel")
    label.Parent = holder
    label.Size = UDim2.new(1,0,0,16)
    label.Position = UDim2.new(0,0,0,64)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 8
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(145,151,166)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 7

    btn.MouseEnter:Connect(function()
        local c = accent()
        ring.Color = c
        glow.Color = c
        inner.BackgroundColor3 = c
        tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0,64,0,64),
            BackgroundColor3 = c,
            TextColor3 = Color3.fromRGB(10,12,18)
        }):Play()
        tween(glow, TweenInfo.new(0.18), {Transparency = 0.48, Thickness = 11}):Play()
        tween(label, TweenInfo.new(0.18), {TextColor3 = c}):Play()
    end)

    btn.MouseLeave:Connect(function()
        local c = accent()
        ring.Color = c
        glow.Color = c
        inner.BackgroundColor3 = c
        tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0,58,0,58),
            BackgroundColor3 = Color3.fromRGB(20,23,33),
            TextColor3 = Color3.fromRGB(224,228,238)
        }):Play()
        tween(glow, TweenInfo.new(0.18), {Transparency = 0.82, Thickness = 8}):Play()
        tween(label, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(145,151,166)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        ShowNotification(labelText .. " • ID: " .. idText)
        pcall(function()
            if setclipboard then
                setclipboard(idText)
            end
        end)
    end)

    table.insert(circles, {ring=ring, glow=glow, inner=inner, label=label, button=btn})
end

createCircle("D", "DISCORD", "79178042116025")
createCircle("f", "FACEBOOK", "121038275317096")
createCircle("♪", "TIKTOK", "71597520923112")

local footer = Instance.new("TextLabel")
footer.Parent = root
footer.Size = UDim2.new(1,0,0,20)
footer.Position = UDim2.new(0,0,1,-24)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Code
footer.TextSize = 8
footer.Text = "FISHHUB  /  CREATIVE SPACE"
footer.TextColor3 = Color3.fromRGB(100,106,122)
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.ZIndex = 5

-- Theme/rainbow synchronization.
task.spawn(function()
    local hue = 0
    while root and root.Parent do
        local rainbowOn = Config.RainbowEnabled == true
        if rainbowOn then
            local speed = math.clamp(tonumber(Config.RainbowSpeedPercent) or 100, 1, 100)
            hue = (hue + 0.0025 * speed) % 1
            Config.ThemeColor = Color3.fromHSV(hue, 0.82, 1)
        end

        local c = accent()
        ambient.BackgroundColor3 = c
        divider.BackgroundColor3 = c
        cardStroke.Color = c
        avatarStroke.Color = c
        avatarGlow.Color = c
        handle.TextColor3 = c
        liveColor = c
        for _, item in ipairs(circles) do
            if item.ring and item.ring.Parent then
                item.ring.Color = c
                item.glow.Color = c
                item.inner.BackgroundColor3 = c
            end
        end
        task.wait(0.03)
    end
end)

-- Gentle ambient pulse.
task.spawn(function()
    while ambient and ambient.Parent do
        tween(ambient, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,370,0,370),
            BackgroundTransparency = 0.972
        }):Play()
        task.wait(1.4)
        if not (ambient and ambient.Parent) then break end
        tween(ambient, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,330,0,330),
            BackgroundTransparency = 0.965
        }):Play()
        task.wait(1.4)
    end
end)

return true
