--==============================================================
-- FishHub | Creative.lua
-- Premium Creative / Social Center
--==============================================================

local context = ...

if type(context) ~= "table" then
    return
end

local Tab = context.Tab

if not Tab then
    return
end

local TweenService = context.TweenService or game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Config = context.Config or {}
local ShowNotification = context.ShowNotification

--==============================================================
-- CONFIG
--==============================================================

local SOCIALS = {
    {
        Name = "Discord",
        Asset = "rbxassetid://79178042116025",
        Url = "https://discord.gg/zFN6Nd99fC",
        Description = "COMMUNITY",
    },

    {
        Name = "Facebook",
        Asset = "rbxassetid://121038275317096",
        Url = "https://www.facebook.com/dao.huy.lam.09/",
        Description = "PROFILE",
    },

    {
        Name = "TikTok",
        Asset = "rbxassetid://71597520923112",
        Url = "https://www.tiktok.com/@daolam.trh",
        Description = "FOLLOW",
    },
}

local DEFAULT_THEME = Color3.fromRGB(130, 95, 255)

local function GetThemeColor()
    if typeof(Config.ThemeColor) == "Color3" then
        return Config.ThemeColor
    end

    return DEFAULT_THEME
end

local ThemeColor = GetThemeColor()

--==============================================================
-- HELPERS
--==============================================================

local function New(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    return object
end

local function Corner(parent, radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
end

local function Stroke(parent, color, thickness, transparency)
    return New("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function Scale(parent)
    return New("UIScale", {
        Scale = 1,
        Parent = parent
    })
end

local function Tween(object, duration, properties, style, direction)
    local ok, result = pcall(function()
        local tween = TweenService:Create(
            object,
            TweenInfo.new(
                duration,
                style or Enum.EasingStyle.Quint,
                direction or Enum.EasingDirection.Out
            ),
            properties
        )

        tween:Play()

        return tween
    end)

    if ok then
        return result
    end
end

local function Notify(text)
    if type(ShowNotification) == "function" then
        pcall(function()
            ShowNotification(text)
        end)

        return
    end

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "FishHub",
            Text = text,
            Duration = 3
        })
    end)
end

--==============================================================
-- CLEAR OLD CREATIVE CONTENT
--==============================================================

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0
Tab.ScrollBarThickness = 0
Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

--==============================================================
-- ROOT
--==============================================================

local Root = New("Frame", {
    Name = "CreativeRoot",
    Parent = Tab,

    Size = UDim2.new(1, -8, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,

    BackgroundTransparency = 1,
    BorderSizePixel = 0
})

New("UIPadding", {
    Parent = Root,

    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 18),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6)
})

New("UIListLayout", {
    Parent = Root,

    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,

    Padding = UDim.new(0, 12)
})

--==============================================================
-- HERO
--==============================================================

local Hero = New("Frame", {
    Name = "Hero",

    Parent = Root,
    LayoutOrder = 1,

    Size = UDim2.new(1, 0, 0, 178),

    BackgroundColor3 = Color3.fromRGB(9, 10, 17),
    BorderSizePixel = 0,

    ClipsDescendants = true
})

Corner(Hero, 17)

local HeroStroke = Stroke(
    Hero,
    ThemeColor,
    1.4,
    0.3
)

New("UIGradient", {
    Parent = Hero,

    Rotation = 25,

    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(17, 18, 29)
        ),

        ColorSequenceKeypoint.new(
            0.5,
            Color3.fromRGB(9, 10, 17)
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(21, 15, 32)
        )
    })
})

local Glow1 = New("Frame", {
    Parent = Hero,

    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(1, 20, 0, 20),

    Size = UDim2.fromOffset(190, 190),

    BackgroundColor3 = ThemeColor,
    BackgroundTransparency = 0.92,

    BorderSizePixel = 0
})

Corner(Glow1, 100)

local Glow2 = New("Frame", {
    Parent = Hero,

    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0, -15, 1, 10),

    Size = UDim2.fromOffset(145, 145),

    BackgroundColor3 = ThemeColor,
    BackgroundTransparency = 0.95,

    BorderSizePixel = 0
})

Corner(Glow2, 100)

--==============================================================
-- HERO TITLE
--==============================================================

local Accent = New("Frame", {
    Parent = Hero,

    Position = UDim2.fromOffset(18, 17),
    Size = UDim2.fromOffset(4, 43),

    BackgroundColor3 = ThemeColor,
    BorderSizePixel = 0
})

Corner(Accent, 3)

local Title = New("TextLabel", {
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

local Subtitle = New("TextLabel", {
    Parent = Hero,

    Position = UDim2.fromOffset(32, 42),
    Size = UDim2.new(1, -50, 0, 18),

    BackgroundTransparency = 1,

    Text = "FISHHUB  •  SOCIAL CENTER",

    TextColor3 = ThemeColor,

    Font = Enum.Font.GothamBold,
    TextSize = 9,

    TextXAlignment = Enum.TextXAlignment.Left
})

local HeroLine = New("Frame", {
    Parent = Hero,

    Position = UDim2.fromOffset(18, 72),
    Size = UDim2.new(1, -36, 0, 1),

    BackgroundColor3 = ThemeColor,
    BackgroundTransparency = 0.55,

    BorderSizePixel = 0
})

local Description = New("TextLabel", {
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

local Badge = New("TextLabel", {
    Parent = Hero,

    Position = UDim2.fromOffset(18, 144),
    Size = UDim2.fromOffset(105, 20),

    BackgroundColor3 = ThemeColor,
    BackgroundTransparency = 0.86,

    Text = "SOCIAL LINKS",

    TextColor3 = Color3.fromRGB(235, 237, 255),

    Font = Enum.Font.GothamBold,
    TextSize = 8,

    TextXAlignment = Enum.TextXAlignment.Center
})

Corner(Badge, 8)

--==============================================================
-- SECTION
--==============================================================

local Section = New("Frame", {
    Parent = Root,

    LayoutOrder = 2,

    Size = UDim2.new(1, 0, 0, 35),

    BackgroundTransparency = 1
})

New("TextLabel", {
    Parent = Section,

    Size = UDim2.new(1, 0, 0, 18),

    BackgroundTransparency = 1,

    Text = "CONNECT",

    TextColor3 = Color3.fromRGB(242, 244, 252),

    Font = Enum.Font.GothamBold,
    TextSize = 11,

    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
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

--==============================================================
-- SOCIAL ROW
--==============================================================

local SocialRow = New("Frame", {
    Name = "SocialRow",

    Parent = Root,

    LayoutOrder = 3,

    Size = UDim2.new(1, 0, 0, 140),

    BackgroundTransparency = 1
})

New("UIListLayout", {
    Parent = SocialRow,

    FillDirection = Enum.FillDirection.Horizontal,

    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,

    Padding = UDim.new(0, 10)
})

local Cards = {}

--==============================================================
-- COPY FUNCTION
--==============================================================

local function CopyURL(data)
    local copied = false

    pcall(function()
        if type(setclipboard) == "function" then
            setclipboard(data.Url)
            copied = true
        end
    end)

    if copied then
        Notify(
            "Copied " .. data.Name .. " link!"
        )
    else
        Notify(
            data.Name .. " link: " .. data.Url
        )
    end
end

--==============================================================
-- CREATE SOCIAL CARDS
--==============================================================

for index, data in ipairs(SOCIALS) do

    local Card = New("TextButton", {
        Name = data.Name .. "Card",

        Parent = SocialRow,

        LayoutOrder = index,

        Size = UDim2.fromOffset(108, 126),

        BackgroundColor3 = Color3.fromRGB(13, 14, 22),

        BorderSizePixel = 0,

        AutoButtonColor = false,

        Text = "",

        ClipsDescendants = true
    })

    Corner(Card, 15)

    local CardStroke = Stroke(
        Card,
        ThemeColor,
        1.2,
        0.4
    )

    local CardScale = Scale(Card)

    --==========================================================
    -- MOUSE GLOW
    --==========================================================

    local MouseGlow = New("Frame", {
        Name = "MouseGlow",

        Parent = Card,

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = UDim2.fromScale(0.5, 0.3),

        Size = UDim2.fromOffset(70, 70),

        BackgroundColor3 = ThemeColor,

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Visible = false,

        ZIndex = 1
    })

    Corner(MouseGlow, 50)

    --==========================================================
    -- ICON HOLDER
    --==========================================================

    local IconHolder = New("Frame", {
        Parent = Card,

        AnchorPoint = Vector2.new(0.5, 0),

        Position = UDim2.new(0.5, 0, 0, 11),

        Size = UDim2.fromOffset(70, 70),

        BackgroundColor3 = Color3.fromRGB(8, 9, 14),

        BorderSizePixel = 0,

        ZIndex = 2
    })

    Corner(IconHolder, 21)

    local IconStroke = Stroke(
        IconHolder,
        ThemeColor,
        1.2,
        0.3
    )

    local Icon = New("ImageLabel", {
        Name = "Logo",

        Parent = IconHolder,

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = UDim2.fromScale(0.5, 0.5),

        Size = UDim2.fromOffset(46, 46),

        BackgroundTransparency = 1,

        Image = data.Asset,

        ImageColor3 = ThemeColor,

        ScaleType = Enum.ScaleType.Fit,

        ZIndex = 3
    })

    --==========================================================
    -- TEXT
    --==========================================================

    local NameLabel = New("TextLabel", {
        Parent = Card,

        Position = UDim2.fromOffset(5, 85),

        Size = UDim2.new(1, -10, 0, 16),

        BackgroundTransparency = 1,

        Text = string.upper(data.Name),

        TextColor3 = Color3.fromRGB(240, 242, 250),

        Font = Enum.Font.GothamBold,

        TextSize = 9,

        TextXAlignment = Enum.TextXAlignment.Center,

        ZIndex = 3
    })

    local DescriptionLabel = New("TextLabel", {
        Parent = Card,

        Position = UDim2.fromOffset(5, 102),

        Size = UDim2.new(1, -10, 0, 12),

        BackgroundTransparency = 1,

        Text = data.Description,

        TextColor3 = Color3.fromRGB(87, 93, 111),

        Font = Enum.Font.GothamMedium,

        TextSize = 7,

        TextXAlignment = Enum.TextXAlignment.Center,

        ZIndex = 3
    })

    Cards[index] = {
        Data = data,
        Card = Card,
        Scale = CardScale,
        Stroke = CardStroke,
        Icon = Icon,
        IconHolder = IconHolder,
        IconStroke = IconStroke,
        Glow = MouseGlow
    }

    local Hovering = false

    --==========================================================
    -- HOVER ENTER
    --==========================================================

    Card.MouseEnter:Connect(function(x, y)

        Hovering = true

        MouseGlow.Visible = true

        if x and y then
            MouseGlow.Position = UDim2.fromOffset(x, y)
        end

        Tween(
            CardScale,
            0.18,
            {
                Scale = 1.075
            },
            Enum.EasingStyle.Back
        )

        Tween(
            Card,
            0.18,
            {
                BackgroundColor3 = Color3.fromRGB(19, 20, 30)
            }
        )

        Tween(
            IconHolder,
            0.18,
            {
                Size = UDim2.fromOffset(75, 75)
            },
            Enum.EasingStyle.Back
        )

        Tween(
            Icon,
            0.18,
            {
                Size = UDim2.fromOffset(51, 51)
            },
            Enum.EasingStyle.Back
        )

        Tween(
            MouseGlow,
            0.2,
            {
                Size = UDim2.fromOffset(94, 94),
                BackgroundTransparency = 0.76
            }
        )

        Tween(
            CardStroke,
            0.18,
            {
                Thickness = 2,
                Transparency = 0
            }
        )

        Tween(
            IconStroke,
            0.18,
            {
                Thickness = 2,
                Transparency = 0
            }
        )
    end)

    --==========================================================
    -- FOLLOW MOUSE
    --==========================================================

    Card.MouseMoved:Connect(function(x, y)

        if not Hovering then
            return
        end

        MouseGlow.Position = UDim2.fromOffset(x, y)
    end)

    --==========================================================
    -- HOVER LEAVE
    --==========================================================

    Card.MouseLeave:Connect(function()

        Hovering = false

        MouseGlow.Visible = false

        Tween(
            CardScale,
            0.2,
            {
                Scale = 1
            }
        )

        Tween(
            Card,
            0.2,
            {
                BackgroundColor3 = Color3.fromRGB(13, 14, 22)
            }
        )

        Tween(
            IconHolder,
            0.2,
            {
                Size = UDim2.fromOffset(70, 70)
            }
        )

        Tween(
            Icon,
            0.2,
            {
                Size = UDim2.fromOffset(46, 46)
            }
        )

        Tween(
            MouseGlow,
            0.2,
            {
                Size = UDim2.fromOffset(70, 70),
                BackgroundTransparency = 0.94
            }
        )

        Tween(
            CardStroke,
            0.2,
            {
                Thickness = 1.2,
                Transparency = 0.4
            }
        )

        Tween(
            IconStroke,
            0.2,
            {
                Thickness = 1.2,
                Transparency = 0.3
            }
        )
    end)

    --==========================================================
    -- CLICK
    --==========================================================

    Card.MouseButton1Click:Connect(function()

        Tween(
            CardScale,
            0.08,
            {
                Scale = 0.93
            },
            Enum.EasingStyle.Quad
        )

        task.delay(0.08, function()

            if not Card.Parent then
                return
            end

            Tween(
                CardScale,
                0.18,
                {
                    Scale = Hovering and 1.075 or 1
                },
                Enum.EasingStyle.Back
            )
        end)

        CopyURL(data)
    end)
end

--==============================================================
-- FOOTER
--==============================================================

local Footer = New("Frame", {
    Parent = Root,

    LayoutOrder = 4,

    Size = UDim2.new(1, 0, 0, 42),

    BackgroundTransparency = 1
})

New("Frame", {
    Parent = Footer,

    AnchorPoint = Vector2.new(0.5, 0),

    Position = UDim2.new(0.5, 0, 0, 1),

    Size = UDim2.new(0.65, 0, 0, 1),

    BackgroundColor3 = ThemeColor,

    BackgroundTransparency = 0.72,

    BorderSizePixel = 0
})

New("TextLabel", {
    Parent = Footer,

    Position = UDim2.fromOffset(0, 11),

    Size = UDim2.new(1, 0, 0, 20),

    BackgroundTransparency = 1,

    Text = "FISHHUB  •  CREATIVE",

    TextColor3 = Color3.fromRGB(74, 80, 97),

    Font = Enum.Font.GothamMedium,

    TextSize = 8,

    TextXAlignment = Enum.TextXAlignment.Center
})

--==============================================================
-- RAINBOW SYSTEM
--==============================================================

local RainbowTime = 0

local RainbowConnection

RainbowConnection = RunService.RenderStepped:Connect(function(delta)

    if not Root.Parent then

        if RainbowConnection then
            RainbowConnection:Disconnect()
        end

        return
    end

    RainbowTime =
        (RainbowTime + delta * 0.18) % 1

    for index, item in ipairs(Cards) do

        local hue =
            (RainbowTime + ((index - 1) / #Cards) * 0.22)
            % 1

        local RainbowColor =
            Color3.fromHSV(
                hue,
                0.85,
                1
            )

        item.Icon.ImageColor3 =
            RainbowColor

        item.IconStroke.Color =
            RainbowColor

        item.Glow.BackgroundColor3 =
            RainbowColor
    end
end)

--==============================================================
-- THEME SYNC
--==============================================================

task.spawn(function()

    local PreviousColor = GetThemeColor()

    while Root.Parent do

        local CurrentColor =
            GetThemeColor()

        if CurrentColor ~= PreviousColor then

            PreviousColor = CurrentColor
            ThemeColor = CurrentColor

            HeroStroke.Color =
                CurrentColor

            Accent.BackgroundColor3 =
                CurrentColor

            Subtitle.TextColor3 =
                CurrentColor

            HeroLine.BackgroundColor3 =
                CurrentColor

            Badge.BackgroundColor3 =
                CurrentColor

            for _, item in ipairs(Cards) do

                item.Stroke.Color =
                    CurrentColor

                item.IconStroke.Color =
                    CurrentColor
            end
        end

        task.wait(0.25)
    end
end)

--==============================================================
-- ENTRANCE ANIMATION
--==============================================================

local HeroScale = Scale(Hero)

HeroScale.Scale = 0.95
Hero.BackgroundTransparency = 1

for _, item in ipairs(Cards) do

    item.Card.BackgroundTransparency = 1
    item.Icon.ImageTransparency = 1
end

task.defer(function()

    Tween(
        HeroScale,
        0.42,
        {
            Scale = 1
        },
        Enum.EasingStyle.Back
    )

    Tween(
        Hero,
        0.35,
        {
            BackgroundTransparency = 0
        }
    )

    task.wait(0.12)

    for index, item in ipairs(Cards) do

        task.delay(
            (index - 1) * 0.09,
            function()

                if not item.Card.Parent then
                    return
                end

                Tween(
                    item.Card,
                    0.28,
                    {
                        BackgroundTransparency = 0
                    }
                )

                Tween(
                    item.Icon,
                    0.3,
                    {
                        ImageTransparency = 0
                    }
                )
            end
        )
    end
end)

--==============================================================
-- CANVAS
--==============================================================

local function RefreshCanvas()

    if Tab and Tab.Parent then

        Tab.CanvasSize =
            UDim2.new(
                0,
                0,
                0,
                Root.AbsoluteSize.Y + 12
            )
    end
end

Root:GetPropertyChangedSignal(
    "AbsoluteSize"
):Connect(RefreshCanvas)

task.defer(function()

    task.wait(0.3)

    RefreshCanvas()
end)

--==============================================================
-- RETURN API
--==============================================================

return {
    Root = Root,

    Cards = Cards,

    Copy = function(name)

        for _, item in ipairs(Cards) do

            if string.lower(item.Data.Name)
                == string.lower(tostring(name)) then

                CopyURL(item.Data)

                return true
            end
        end

        return false
    end
}
