local context = ...
if type(context) ~= "table" then return end

local TweenService = context.TweenService
local Config = context.Config or {}
local ShowNotification = context.ShowNotification or function() end
local AddThemeObject = context.AddThemeObject or function(x) return x end
local GetAccent = context.GetCurrentAccentColor or function() return Config.ThemeColor or Color3.fromRGB(0,229,255) end

local TITLE = "'SHOP'"
local ITEMS = "['SHOP LIST', 'BUY FRUIT', 'BUY ACCESSORY', 'BUY WEAPON']"

local root = Instance.new("Frame")
root.Name = "Content"
root.Parent = context.Tab
root.Size = UDim2.fromScale(1,1)
root.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame")
scroll.Parent = root
scroll.Size = UDim2.fromScale(1,1)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 0
scroll.CanvasSize = UDim2.new(0,0,0,0)

local pad = Instance.new("UIPadding",scroll)
pad.PaddingTop = UDim.new(0,8)
pad.PaddingBottom = UDim.new(0,12)
pad.PaddingLeft = UDim.new(0,2)
pad.PaddingRight = UDim.new(0,2)

local layout = Instance.new("UIListLayout",scroll)
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local header = Instance.new("Frame")
header.Parent = scroll
header.Size = UDim2.new(1,-4,0,64)
header.BackgroundColor3 = Color3.fromRGB(31,33,43)
header.BorderSizePixel = 0
Instance.new("UICorner",header).CornerRadius = UDim.new(0,10)
local hs = Instance.new("UIStroke",header)
hs.Thickness=1
hs.Color=GetAccent()
AddThemeObject(hs)

local title = Instance.new("TextLabel")
title.Parent=header
title.Size=UDim2.new(1,-24,0,24)
title.Position=UDim2.new(0,12,0,9)
title.BackgroundTransparency=1
title.Text=TITLE
title.Font=Enum.Font.GothamBold
title.TextSize=13
title.TextColor3=Color3.fromRGB(240,242,248)
title.TextXAlignment=Enum.TextXAlignment.Left

local sub = Instance.new("TextLabel")
sub.Parent=header
sub.Size=UDim2.new(1,-24,0,18)
sub.Position=UDim2.new(0,12,0,34)
sub.BackgroundTransparency=1
sub.Text="Loaded inside FishHub • isolated from main UI"
sub.Font=Enum.Font.Code
sub.TextSize=9
sub.TextColor3=Color3.fromRGB(145,150,165)
sub.TextXAlignment=Enum.TextXAlignment.Left

local states = {}
local buttons = {}

for index,label in ipairs(ITEMS) do
    local card=Instance.new("Frame")
    card.Parent=scroll
    card.Size=UDim2.new(1,-4,0,48)
    card.BackgroundColor3=Color3.fromRGB(38,40,51)
    card.BorderSizePixel=0
    card.LayoutOrder=index
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)
    local stroke=Instance.new("UIStroke",card)
    stroke.Thickness=1
    stroke.Color=Color3.fromRGB(72,75,91)
    AddThemeObject(stroke)

    local text=Instance.new("TextLabel")
    text.Parent=card
    text.Size=UDim2.new(1,-105,1,0)
    text.Position=UDim2.new(0,13,0,0)
    text.BackgroundTransparency=1
    text.Text=label
    text.Font=Enum.Font.GothamMedium
    text.TextSize=10.5
    text.TextColor3=Color3.fromRGB(225,228,237)
    text.TextXAlignment=Enum.TextXAlignment.Left

    local button=Instance.new("TextButton")
    button.Parent=card
    button.Size=UDim2.new(0,74,0,28)
    button.Position=UDim2.new(1,-86,0.5,-14)
    button.BackgroundColor3=Color3.fromRGB(51,54,68)
    button.BorderSizePixel=0
    button.AutoButtonColor=false
    button.Text="OFF"
    button.Font=Enum.Font.GothamBold
    button.TextSize=9
    button.TextColor3=Color3.fromRGB(155,160,175)
    Instance.new("UICorner",button).CornerRadius=UDim.new(0,7)
    local bs=Instance.new("UIStroke",button)
    bs.Thickness=1
    bs.Color=GetAccent()
    AddThemeObject(bs)

    states[label]=false
    buttons[label]=button

    button.MouseButton1Click:Connect(function()
        states[label]=not states[label]
        local on=states[label]
        button.Text=on and "ON" or "OFF"
        button.TextColor3=on and GetAccent() or Color3.fromRGB(155,160,175)
        TweenService:Create(button,TweenInfo.new(.18,Enum.EasingStyle.Quint),{
            BackgroundColor3=on and Color3.fromRGB(55,58,72) or Color3.fromRGB(51,54,68)
        }):Play()
        ShowNotification(TITLE.." • "..label.." "..(on and "enabled" or "disabled"))
    end)
end

scroll.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+16)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+16)
end)

return {
    Destroy=function()
        if root and root.Parent then root:Destroy() end
    end
}
