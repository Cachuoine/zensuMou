local C = ...
local Tab = C.Tab
local TweenService = C.TweenService

Tab:ClearAllChildren()
Tab.ScrollBarThickness=0
Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
Tab.CanvasSize=UDim2.new(0,0,0,0)

local Theme=function() return C.GetThemeColor() end

local Root=Instance.new("Frame")
Root.Parent=Tab
Root.Size=UDim2.new(1,-8,0,0)
Root.AutomaticSize=Enum.AutomaticSize.Y
Root.BackgroundTransparency=1

local layout=Instance.new("UIListLayout")
layout.Parent=Root
layout.Padding=UDim.new(0,12)
layout.HorizontalAlignment=Enum.HorizontalAlignment.Center

local function Corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 10)
    c.Parent=o
end

local function Stroke(o)
    local s=Instance.new("UIStroke")
    s.Color=Theme()
    s.Thickness=1
    s.Transparency=0.2
    s.Parent=o
    return s
end

local function Divider(title)
    local holder=Instance.new("Frame")
    holder.Parent=Root
    holder.Size=UDim2.new(1,-12,0,28)
    holder.BackgroundTransparency=1
    local label=Instance.new("TextLabel")
    label.Parent=holder
    label.Size=UDim2.new(0,0,0,18)
    label.AutomaticSize=Enum.AutomaticSize.X
    label.Position=UDim2.new(0.5,0,0,0)
    label.AnchorPoint=Vector2.new(0.5,0)
    label.BackgroundTransparency=1
    label.Text=title
    label.Font=Enum.Font.GothamBold
    label.TextSize=12
    label.TextColor3=Theme()
    label.ZIndex=3
    local line=Instance.new("Frame")
    line.Parent=holder
    line.Size=UDim2.new(1,0,0,2)
    line.Position=UDim2.new(0,0,0,20)
    line.BackgroundColor3=Theme()
    line.BorderSizePixel=0
    Corner(line,2)
    local g=Instance.new("UIGradient")
    g.Parent=line
    g.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.92),
        NumberSequenceKeypoint.new(0.2,0.55),
        NumberSequenceKeypoint.new(0.4,0.12),
        NumberSequenceKeypoint.new(0.5,0),
        NumberSequenceKeypoint.new(0.6,0.12),
        NumberSequenceKeypoint.new(0.8,0.55),
        NumberSequenceKeypoint.new(1,0.92)
    })
end

local function Card(order,height)
    local f=Instance.new("Frame")
    f.Parent=Root
    f.Size=UDim2.new(1,-12,0,height)
    f.BackgroundColor3=Color3.fromRGB(7,8,12)
    f.BackgroundTransparency=0.05
    f.BorderSizePixel=0
    f.LayoutOrder=order
    Corner(f,10)
    Stroke(f)
    return f
end

Divider("ROBLOX PLAYERS")
local roblox=Card(2,118)

local avatar=Instance.new("ImageLabel")
avatar.Parent=roblox
avatar.Size=UDim2.new(0,78,0,78)
avatar.Position=UDim2.new(0,14,0.5,-39)
avatar.BackgroundColor3=Color3.fromRGB(17,18,24)
avatar.BorderSizePixel=0
avatar.Image="rbxthumb://type=AvatarHeadShot&id="..C.Player.UserId.."&w=150&h=150"
avatar.ScaleType=Enum.ScaleType.Crop
Corner(avatar,10)
Stroke(avatar)

local fixedName=Instance.new("TextLabel")
fixedName.Parent=roblox
fixedName.Size=UDim2.new(1,-112,0,24)
fixedName.Position=UDim2.new(0,104,0,28)
fixedName.BackgroundTransparency=1
fixedName.Text="thankhuyenhuy"
fixedName.Font=Enum.Font.GothamBold
fixedName.TextSize=14
fixedName.TextColor3=Color3.fromRGB(240,240,245)
fixedName.TextXAlignment=Enum.TextXAlignment.Left

local fixedTag=Instance.new("TextLabel")
fixedTag.Parent=roblox
fixedTag.Size=UDim2.new(1,-112,0,22)
fixedTag.Position=UDim2.new(0,104,0,54)
fixedTag.BackgroundTransparency=1
fixedTag.Text="@thankhuyenhuy"
fixedTag.Font=Enum.Font.GothamMedium
fixedTag.TextSize=10
fixedTag.TextColor3=Theme()
fixedTag.TextXAlignment=Enum.TextXAlignment.Left

Divider("FACEBOOK PLAYERS")
local facebook=Card(4,82)

local add=Instance.new("TextButton")
add.Parent=facebook
add.Size=UDim2.new(1,-20,0,42)
add.Position=UDim2.new(0,10,0.5,-21)
add.BackgroundColor3=Theme()
add.BackgroundTransparency=0.08
add.BorderSizePixel=0
add.AutoButtonColor=false
add.Text="+  ADD"
add.Font=Enum.Font.GothamBold
add.TextSize=12
add.TextColor3=Color3.fromRGB(20,20,28)
Corner(add,8)
local addStroke=Stroke(add)

add.MouseEnter:Connect(function()
    TweenService:Create(add,TweenInfo.new(0.16),{BackgroundTransparency=0}):Play()
end)
add.MouseLeave:Connect(function()
    TweenService:Create(add,TweenInfo.new(0.16),{BackgroundTransparency=0.08}):Play()
end)
add.MouseButton1Click:Connect(function()
    local url="https://www.facebook.com/dao.huy.lam.09/"
    pcall(function()
        if setclipboard then
            setclipboard(url)
        end
    end)
    if C.Notify then C.Notify("Facebook link copied.") end
end)

task.spawn(function()
    while Tab.Parent and Root.Parent do
        local color=Theme()
        fixedTag.TextColor3=color
        add.BackgroundColor3=color
        addStroke.Color=color
        for _,obj in ipairs(Root:GetDescendants()) do
            if obj:IsA("UIStroke") then obj.Color=color end
        end
        task.wait(0.5)
    end
end)
