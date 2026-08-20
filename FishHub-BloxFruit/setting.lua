--// FishHub • Setting.lua
--// Advanced Settings tab
--// Theme / Rainbow / Color / UI size controls.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end

local context = ...
local playerGui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui", 10)
local tab = context and context.Tab
local main = context and context.MainWindow

if not tab then
    local fishHub = playerGui and playerGui:FindFirstChild("FishHub")
    local mainWindow = fishHub and fishHub:FindFirstChild("MainWindow")
    local content = mainWindow and mainWindow:FindFirstChild("ContentContainer")
    tab = content and content:FindFirstChild("SettingTab", true)
    main = main or mainWindow
end

if not tab then return end

for _, child in ipairs(tab:GetChildren()) do
    child:Destroy()
end

local State = {
    Rainbow = false,
    RainbowSpeed = 50,
    UIAlpha = 0,
    UIScale = 100,
    SelectedColor = Color3.fromRGB(104, 82, 255),
}

local function theme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or State.SelectedColor
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function mkStroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Color = theme()
    s.Thickness = 1
    s.Transparency = transparency or .58
    s.Parent = parent
    return s
end

local function txt(parent, value, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = value
    l.TextSize = size
    l.TextColor3 = color
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function tween(obj, props, duration)
    return TweenService:Create(
        obj,
        TweenInfo.new(duration or .2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
end

local accents, strokes, accentTexts = {}, {}, {}

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "SettingScroll"
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = tab

local p = Instance.new("UIPadding")
p.PaddingLeft = UDim.new(0,7)
p.PaddingRight = UDim.new(0,7)
p.PaddingTop = UDim.new(0,7)
p.PaddingBottom = UDim.new(0,14)
p.Parent = scroll

local root = Instance.new("Frame")
root.Size = UDim2.new(1,-14,0,0)
root.AutomaticSize = Enum.AutomaticSize.Y
root.BackgroundTransparency = 1
root.Parent = scroll

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,12)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.Parent = root

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,105)
header.BackgroundColor3 = Color3.fromRGB(7,8,12)
header.BorderSizePixel = 0
header.ClipsDescendants = true
header.Parent = root
corner(header,15)
table.insert(strokes,mkStroke(header,.38))

local glow = Instance.new("Frame")
glow.Size = UDim2.new(0,160,0,160)
glow.Position = UDim2.new(1,-90,0,-75)
glow.BackgroundColor3 = theme()
glow.BackgroundTransparency = .88
glow.BorderSizePixel = 0
glow.Parent = header
corner(glow,100)
table.insert(accents,glow)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,4,1,-30)
bar.Position = UDim2.new(0,14,0,15)
bar.BackgroundColor3 = theme()
bar.BorderSizePixel = 0
bar.Parent = header
corner(bar,4)
table.insert(accents,bar)

local title = txt(header,"SETTING",21,Color3.fromRGB(245,246,252),Enum.Font.GothamBlack)
title.Position = UDim2.new(0,30,0,14)
title.Size = UDim2.new(1,-44,0,26)

local sub = txt(header,"Appearance & interface",10,Color3.fromRGB(145,150,165),Enum.Font.GothamMedium)
sub.Position = UDim2.new(0,31,0,43)
sub.Size = UDim2.new(1,-44,0,18)

local stateText = txt(header,"RAINBOW OFF",9,theme(),Enum.Font.GothamBold)
stateText.Position = UDim2.new(0,31,0,70)
stateText.Size = UDim2.new(0,150,0,18)
table.insert(accentTexts,stateText)

local function sectionTitle(textValue)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1,0,0,30)
    h.BackgroundTransparency = 1
    h.Parent = root

    local title = txt(h,textValue,9,theme(),Enum.Font.GothamBold)
    title.Size = UDim2.new(.5,0,1,0)
    title.Position = UDim2.new(.25,0,0,0)
    title.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(accentTexts,title)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1,0,0,1)
    line.Position = UDim2.new(0,0,1,-1)
    line.BackgroundColor3 = theme()
    line.BorderSizePixel = 0
    line.Parent = h
    table.insert(accents,line)

    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,.98),
        NumberSequenceKeypoint.new(.22,.65),
        NumberSequenceKeypoint.new(.5,0),
        NumberSequenceKeypoint.new(.78,.65),
        NumberSequenceKeypoint.new(1,.98),
    })
    g.Parent = line
end

local function card(height)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1,0,0,height)
    c.BackgroundColor3 = Color3.fromRGB(8,9,14)
    c.BorderSizePixel = 0
    c.Parent = root
    corner(c,12)
    table.insert(strokes,mkStroke(c,.68))
    return c
end

--// Theme color preview
sectionTitle("THEME")

local themeCard = card(94)

local preview = Instance.new("Frame")
preview.Size = UDim2.new(0,54,0,54)
preview.Position = UDim2.new(0,13,.5,-27)
preview.BackgroundColor3 = State.SelectedColor
preview.BorderSizePixel = 0
preview.Parent = themeCard
corner(preview,13)
table.insert(accents,preview)

local previewGradient = Instance.new("UIGradient")
previewGradient.Rotation = 45
previewGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(.35,State.SelectedColor),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(8,9,14)),
})
previewGradient.Parent = preview

local colorTitle = txt(themeCard,"ACCENT COLOR",10,Color3.fromRGB(240,242,248),Enum.Font.GothamBold)
colorTitle.Position = UDim2.new(0,82,0,16)
colorTitle.Size = UDim2.new(1,-94,0,18)

local colorInfo = txt(themeCard,"Manual color overrides rainbow",8,Color3.fromRGB(125,130,145),Enum.Font.GothamMedium)
colorInfo.Position = UDim2.new(0,82,0,37)
colorInfo.Size = UDim2.new(1,-94,0,16)

local apply = Instance.new("TextButton")
apply.AutoButtonColor = false
apply.Text = "APPLY"
apply.TextSize = 8
apply.Font = Enum.Font.GothamBold
apply.TextColor3 = Color3.fromRGB(245,246,252)
apply.Size = UDim2.new(0,72,0,25)
apply.Position = UDim2.new(1,-84,1,-35)
apply.BackgroundColor3 = State.SelectedColor
apply.BorderSizePixel = 0
apply.Parent = themeCard
corner(apply,8)
table.insert(accents,apply)

-- Vertical hue slider
local hue = Instance.new("Frame")
hue.Name = "ColorSlider"
hue.Size = UDim2.new(0,12,0,54)
hue.Position = UDim2.new(1,-102,0,14)
hue.BackgroundColor3 = Color3.new(1,1,1)
hue.BorderSizePixel = 0
hue.Parent = themeCard
corner(hue,6)

local hueGradient = Instance.new("UIGradient")
hueGradient.Rotation = 90
hueGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(.16,Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(.33,Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(.50,Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(.66,Color3.fromRGB(0,80,255)),
    ColorSequenceKeypoint.new(.83,Color3.fromRGB(170,0,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
})
hueGradient.Parent = hue

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0,18,0,6)
knob.Position = UDim2.new(.5,-9,.25,-3)
knob.BackgroundColor3 = Color3.fromRGB(245,246,252)
knob.BorderSizePixel = 0
knob.Parent = hue
corner(knob,4)

local hueDragging = false

local function setHueFromY(y)
    local pos = math.clamp((y-hue.AbsolutePosition.Y)/math.max(hue.AbsoluteSize.Y,1),0,1)
    knob.Position = UDim2.new(.5,-9,pos,-3)

    -- Full HSV hue, high saturation/value.
    local h = pos
    State.SelectedColor = Color3.fromHSV(h, .82, .98)
    preview.BackgroundColor3 = State.SelectedColor
end

hue.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        hueDragging = true
        setHueFromY(input.Position.Y)
        State.Rainbow = false
        stateText.Text = "RAINBOW OFF • MANUAL"
    end
end)

hue.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        hueDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if hueDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        setHueFromY(input.Position.Y)
    end
end)

apply.Activated:Connect(function()
    if context and type(context.SetTheme) == "function" then
        pcall(context.SetTheme, State.SelectedColor)
    elseif main then
        local bind = main:FindFirstChild("SetTheme")
        if bind and bind:IsA("BindableEvent") then
            bind:Fire(State.SelectedColor)
        end
    end

    apply.Text = "APPLIED"
    tween(apply,{BackgroundColor3=Color3.fromRGB(18,19,26)},.15):Play()

    task.delay(.8,function()
        if apply.Parent then
            apply.Text = "APPLY"
            apply.BackgroundColor3 = State.SelectedColor
        end
    end)
end)

--// Rainbow
sectionTitle("RAINBOW")

local rainbowCard = card(103)

local rainbowTitle = txt(rainbowCard,"RAINBOW THEME",10,Color3.fromRGB(240,242,248),Enum.Font.GothamBold)
rainbowTitle.Position = UDim2.new(0,15,0,13)
rainbowTitle.Size = UDim2.new(1,-90,0,18)

local rainbowDesc = txt(rainbowCard,"Cycle the accent color automatically",8,Color3.fromRGB(125,130,145),Enum.Font.GothamMedium)
rainbowDesc.Position = UDim2.new(0,15,0,33)
rainbowDesc.Size = UDim2.new(1,-30,0,16)

local toggle = Instance.new("TextButton")
toggle.AutoButtonColor = false
toggle.Text = ""
toggle.Size = UDim2.new(0,46,0,24)
toggle.Position = UDim2.new(1,-61,0,13)
toggle.BackgroundColor3 = Color3.fromRGB(25,26,34)
toggle.BorderSizePixel = 0
toggle.Parent = rainbowCard
corner(toggle,12)

local toggleKnob = Instance.new("Frame")
toggleKnob.Size = UDim2.new(0,18,0,18)
toggleKnob.Position = UDim2.new(0,3,.5,-9)
toggleKnob.BackgroundColor3 = Color3.fromRGB(165,168,178)
toggleKnob.BorderSizePixel = 0
toggleKnob.Parent = toggle
corner(toggleKnob,10)

local speedLabel = txt(rainbowCard,"SPEED",8,Color3.fromRGB(125,130,145),Enum.Font.GothamBold)
speedLabel.Position = UDim2.new(0,15,0,65)
speedLabel.Size = UDim2.new(0,55,0,18)

local speedValue = txt(rainbowCard,"50%",9,theme(),Enum.Font.GothamBold)
speedValue.Position = UDim2.new(1,-52,0,65)
speedValue.Size = UDim2.new(0,37,0,18)
speedValue.TextXAlignment = Enum.TextXAlignment.Right
table.insert(accentTexts,speedValue)

local speedBar = Instance.new("Frame")
speedBar.Size = UDim2.new(1,-86,0,6)
speedBar.Position = UDim2.new(0,67,0,71)
speedBar.BackgroundColor3 = Color3.fromRGB(26,27,35)
speedBar.BorderSizePixel = 0
speedBar.Parent = rainbowCard
corner(speedBar,5)

local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new(.5,0,1,0)
speedFill.BackgroundColor3 = theme()
speedFill.BorderSizePixel = 0
speedFill.Parent = speedBar
corner(speedFill,5)
table.insert(accents,speedFill)

local speedKnob = Instance.new("Frame")
speedKnob.Size = UDim2.new(0,12,0,12)
speedKnob.Position = UDim2.new(.5,-6,.5,-6)
speedKnob.BackgroundColor3 = Color3.fromRGB(245,246,252)
speedKnob.BorderSizePixel = 0
speedKnob.Parent = speedBar
corner(speedKnob,10)

local speedDragging = false

local function setSpeedFromX(x)
    local p = math.clamp((x-speedBar.AbsolutePosition.X)/math.max(speedBar.AbsoluteSize.X,1),0,1)
    State.RainbowSpeed = math.floor(p*100+0.5)
    speedFill.Size = UDim2.new(p,0,1,0)
    speedKnob.Position = UDim2.new(p,-6,.5,-6)
    speedValue.Text = tostring(State.RainbowSpeed) .. "%"
end

speedBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        speedDragging = true
        setSpeedFromX(input.Position.X)
    end
end)

speedBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        speedDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if speedDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        setSpeedFromX(input.Position.X)
    end
end)

toggle.Activated:Connect(function()
    State.Rainbow = not State.Rainbow

    if State.Rainbow then
        stateText.Text = "RAINBOW ON"
        tween(toggle,{BackgroundColor3=theme()},.2):Play()
        tween(toggleKnob,{Position=UDim2.new(1,-21,.5,-9)},.2):Play()
    else
        stateText.Text = "RAINBOW OFF"
        tween(toggle,{BackgroundColor3=Color3.fromRGB(25,26,34)},.2):Play()
        tween(toggleKnob,{Position=UDim2.new(0,3,.5,-9)},.2):Play()
    end
end)

--// UI Scale
sectionTitle("INTERFACE")

local uiCard = card(80)

local uiTitle = txt(uiCard,"UI SIZE",10,Color3.fromRGB(240,242,248),Enum.Font.GothamBold)
uiTitle.Position = UDim2.new(0,15,0,13)
uiTitle.Size = UDim2.new(.5,0,0,18)

local uiValue = txt(uiCard,"100%",9,theme(),Enum.Font.GothamBold)
uiValue.Position = UDim2.new(1,-55,0,13)
uiValue.Size = UDim2.new(0,40,0,18)
uiValue.TextXAlignment = Enum.TextXAlignment.Right
table.insert(accentTexts,uiValue)

local uiBar = Instance.new("Frame")
uiBar.Size = UDim2.new(1,-30,0,6)
uiBar.Position = UDim2.new(0,15,0,49)
uiBar.BackgroundColor3 = Color3.fromRGB(26,27,35)
uiBar.BorderSizePixel = 0
uiBar.Parent = uiCard
corner(uiBar,5)

local uiFill = Instance.new("Frame")
uiFill.Size = UDim2.new(.5,0,1,0)
uiFill.BackgroundColor3 = theme()
uiFill.BorderSizePixel = 0
uiFill.Parent = uiBar
corner(uiFill,5)
table.insert(accents,uiFill)

local uiKnob = Instance.new("Frame")
uiKnob.Size = UDim2.new(0,12,0,12)
uiKnob.Position = UDim2.new(.5,-6,.5,-6)
uiKnob.BackgroundColor3 = Color3.fromRGB(245,246,252)
uiKnob.BorderSizePixel = 0
uiKnob.Parent = uiBar
corner(uiKnob,10)

local uiDragging = false

local function setUIScaleFromX(x)
    local p = math.clamp((x-uiBar.AbsolutePosition.X)/math.max(uiBar.AbsoluteSize.X,1),0,1)
    State.UIScale = math.floor(75+p*50)
    local normalized = (State.UIScale-75)/50

    uiFill.Size = UDim2.new(normalized,0,1,0)
    uiKnob.Position = UDim2.new(normalized,-6,.5,-6)
    uiValue.Text = tostring(State.UIScale) .. "%"

    if context and type(context.SetUIScale) == "function" then
        pcall(context.SetUIScale, State.UIScale/100)
    elseif main then
        local bind = main:FindFirstChild("SetUIScale")
        if bind and bind:IsA("BindableEvent") then
            bind:Fire(State.UIScale/100)
        end
    end
end

uiBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        uiDragging = true
        setUIScaleFromX(input.Position.X)
    end
end)

uiBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        uiDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if uiDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        setUIScaleFromX(input.Position.X)
    end
end)

--// Live rainbow engine
local hueValue = 0

RunService.RenderStepped:Connect(function(dt)
    if not tab.Parent then return end

    if State.Rainbow then
        local speed = math.max(State.RainbowSpeed,1)
        hueValue = (hueValue + dt * (speed / 100) * .35) % 1
        State.SelectedColor = Color3.fromHSV(hueValue,.82,.98)
        preview.BackgroundColor3 = State.SelectedColor
    end

    local c = State.Rainbow and State.SelectedColor or theme()

    for _, obj in ipairs(accents) do
        if obj.Parent then obj.BackgroundColor3 = c end
    end

    for _, obj in ipairs(accentTexts) do
        if obj.Parent then obj.TextColor3 = c end
    end

    for _, s in ipairs(strokes) do
        if s.Parent then s.Color = c end
    end

    if apply.Parent and not State.Rainbow then
        apply.BackgroundColor3 = State.SelectedColor
    end
end)

--// Initial values
setSpeedFromX(speedBar.AbsolutePosition.X + speedBar.AbsoluteSize.X * .5)
setUIScaleFromX(uiBar.AbsolutePosition.X + uiBar.AbsoluteSize.X * .5)
