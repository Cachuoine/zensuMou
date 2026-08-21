-- FishHub • Creative.lua
-- Clean Creative tab
-- Glow1 / Glow2 circular bubbles removed

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local Config = context.Config or {}
local ShowNotification = context.ShowNotification

local SOCIALS = {
    {
        Name = "Discord",
        Asset = "rbxassetid://79178042116025",
        Url = "https://discord.gg/zFN6Nd99fC",
        Description = "COMMUNITY"
    },
    {
        Name = "Facebook",
        Asset = "rbxassetid://121038275317096",
        Url = "https://www.facebook.com/dao.huy.lam.09/",
        Description = "PROFILE"
    },
    {
        Name = "TikTok",
        Asset = "rbxassetid://71597520923112",
        Url = "https://www.tiktok.com/@daolam.trh",
        Description = "FOLLOW"
    }
}

for _, child in ipairs(Tab:GetChildren()) do child:Destroy() end
Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local function theme()
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(130, 95, 255)
end

local function new(className, props)
    local x = Instance.new(className)
    for k, v in pairs(props or {}) do x[k] = v end
    return x
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function tween(obj, time, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function notify(text)
    if type(ShowNotification) == "function" then
        pcall(ShowNotification, text)
    else
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "FishHub",
                Text = text,
                Duration = 3
            })
        end)
    end
end

local Root = new("Frame", {
    Name = "CreativeRoot",
    Parent = Tab,
    Size = UDim2.new(1, -8, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    BorderSizePixel = 0
})

new("UIPadding", {
    Parent = Root,
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 18),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6)
})

new("UIListLayout", {
    Parent = Root,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 12)
})

local Hero = new("Frame", {
    Name = "Hero",
    Parent = Root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 178),
    BackgroundColor3 = Color3.fromRGB(9, 10, 17),
    BorderSizePixel = 0,
    ClipsDescendants = true
})
corner(Hero, 17)
local heroStroke = stroke(Hero, theme(), 1.4, .3)

-- Clean gradient only. No circular glow objects.
new("UIGradient", {
    Parent = Hero,
    Rotation = 25,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 18, 29)),
        ColorSequenceKeypoint.new(.5, Color3.fromRGB(9, 10, 17)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 15, 32))
    })
})

local accent = new("Frame", {
    Parent = Hero,
    Position = UDim2.fromOffset(18, 17),
    Size = UDim2.fromOffset(4, 43),
    BackgroundColor3 = theme(),
    BorderSizePixel = 0
})
corner(accent, 3)

new("TextLabel", {
    Parent = Hero,
    Position = UDim2.fromOffset(32, 13),
    Size = UDim2.new(1, -50, 0, 29),
    BackgroundTransparency = 1,
    Text = "CREATIVE",
    TextColor3 = Color3.fromRGB(248, 249, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left
})

local subtitle = new("TextLabel", {
    Parent = Hero,
    Position = UDim2.fromOffset(32, 42),
    Size = UDim2.new(1, -50, 0, 18),
    BackgroundTransparency = 1,
    Text = "FISHHUB  •  SOCIAL CENTER",
    TextColor3 = theme(),
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
})

new("Frame", {
    Parent = Hero,
    Position = UDim2.fromOffset(18, 72),
    Size = UDim2.new(1, -36, 0, 1),
    BackgroundColor3 = theme(),
    BackgroundTransparency = .55,
    BorderSizePixel = 0
})

new("TextLabel", {
    Parent = Hero,
    Position = UDim2.fromOffset(18, 86),
    Size = UDim2.new(1, -36, 0, 42),
    BackgroundTransparency = 1,
    Text = "Welcome to the Creative space.\nConnect with FishHub through the links below.",
    TextColor3 = Color3.fromRGB(157, 163, 182),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

local badge = new("TextLabel", {
    Parent = Hero,
    Position = UDim2.fromOffset(18, 144),
    Size = UDim2.fromOffset(105, 20),
    BackgroundColor3 = theme(),
    BackgroundTransparency = .86,
    Text = "SOCIAL LINKS",
    TextColor3 = Color3.fromRGB(235, 237, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Center
})
corner(badge, 8)

local Section = new("Frame", {
    Parent = Root,
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundTransparency = 1
})

new("TextLabel", {
    Parent = Section,
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "CONNECT",
    TextColor3 = Color3.fromRGB(242, 244, 252),
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
})

new("TextLabel", {
    Parent = Section,
    Position = UDim2.fromOffset(0, 18),
    Size = UDim2.new(1, 0, 0, 15),
    BackgroundTransparency = 1,
    Text = "Hover a logo for an effect • Click to copy",
    TextColor3 = Color3.fromRGB(91, 97, 115),
    Font = Enum.Font.Gotham,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left
})

local SocialRow = new("Frame", {
    Name = "SocialRow",
    Parent = Root,
    LayoutOrder = 3,
    Size = UDim2.new(1, 0, 0, 140),
    BackgroundTransparency = 1
})

new("UIListLayout", {
    Parent = SocialRow,
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 10)
})

local function copyURL(data)
    local copied = false
    pcall(function()
        if type(setclipboard) == "function" then
            setclipboard(data.Url)
            copied = true
        end
    end)

    if copied then
        notify("Copied " .. data.Name .. " link!")
    else
        notify(data.Name .. " link: " .. data.Url)
    end
end

for _, data in ipairs(SOCIALS) do
    local card = new("TextButton", {
        Name = data.Name .. "Card",
        Parent = SocialRow,
        Size = UDim2.fromOffset(100, 124),
        BackgroundColor3 = Color3.fromRGB(10, 11, 18),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ClipsDescendants = true
    })

    corner(card, 14)
    local cardStroke = stroke(card, theme(), 1, .55)
    local scale = new("UIScale", {Scale = 1, Parent = card})

    local logo = new("ImageLabel", {
        Parent = card,
        AnchorPoint = Vector2.new(.5, 0),
        Position = UDim2.new(.5, 0, 0, 13),
        Size = UDim2.fromOffset(54, 54),
        BackgroundTransparency = 1,
        Image = data.Asset,
        ScaleType = Enum.ScaleType.Fit
    })

    new("TextLabel", {
        Parent = card,
        Position = UDim2.new(0, 8, 0, 72),
        Size = UDim2.new(1, -16, 0, 18),
        BackgroundTransparency = 1,
        Text = string.upper(data.Name),
        TextColor3 = Color3.fromRGB(240, 242, 248),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    new("TextLabel", {
        Parent = card,
        Position = UDim2.new(0, 8, 0, 91),
        Size = UDim2.new(1, -16, 0, 15),
        BackgroundTransparency = 1,
        Text = data.Description,
        TextColor3 = theme(),
        Font = Enum.Font.Code,
        TextSize = 7,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    card.MouseEnter:Connect(function()
        tween(scale, .2, {Scale = 1.07})
        tween(card, .18, {BackgroundColor3 = Color3.fromRGB(18, 20, 30)})
        tween(cardStroke, .18, {Transparency = .05, Thickness = 1.5})
        tween(logo, .2, {Size = UDim2.fromOffset(62, 62)})
    end)

    card.MouseLeave:Connect(function()
        tween(scale, .18, {Scale = 1})
        tween(card, .18, {BackgroundColor3 = Color3.fromRGB(10, 11, 18)})
        tween(cardStroke, .18, {Transparency = .55, Thickness = 1})
        tween(logo, .18, {Size = UDim2.fromOffset(54, 54)})
    end)

    card.Activated:Connect(function()
        copyURL(data)
    end)
end

task.spawn(function()
    while Tab.Parent do
        local color = theme()
        heroStroke.Color = color
        accent.BackgroundColor3 = color
        subtitle.TextColor3 = color
        badge.BackgroundColor3 = color
        task.wait(.1)
    end
end)
