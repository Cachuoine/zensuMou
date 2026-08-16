local C = ...
local Tab = C.Tab
local Player = C.Player
local TweenService = C.TweenService
local MarketplaceService = C.MarketplaceService

Tab:ClearAllChildren()
Tab.ScrollBarThickness = 0
Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
Tab.CanvasSize = UDim2.new(0,0,0,0)

local Theme = function()
    return C.GetThemeColor()
end

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

local function Text(parent,text,size,bold,color)
    local l=Instance.new("TextLabel")
    l.Parent=parent
    l.BackgroundTransparency=1
    l.Text=text
    l.TextSize=size or 12
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    l.TextColor3=color or Color3.fromRGB(235,235,242)
    l.TextWrapped=true
    return l
end

local Root=Instance.new("Frame")
Root.Parent=Tab
Root.Size=UDim2.new(1,-8,0,0)
Root.AutomaticSize=Enum.AutomaticSize.Y
Root.BackgroundTransparency=1

local Layout=Instance.new("UIListLayout")
Layout.Parent=Root
Layout.Padding=UDim.new(0,12)
Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
Layout.SortOrder=Enum.SortOrder.LayoutOrder

local function Divider(title,order)
    local holder=Instance.new("Frame")
    holder.Parent=Root
    holder.Size=UDim2.new(1,-12,0,28)
    holder.BackgroundTransparency=1
    holder.LayoutOrder=order
    local label=Text(holder,title,12,true,Theme())
    label.Size=UDim2.new(0,0,0,18)
    label.AutomaticSize=Enum.AutomaticSize.X
    label.Position=UDim2.new(0.5,0,0,0)
    label.AnchorPoint=Vector2.new(0.5,0)
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
    return holder
end

local function Card(order,height)
    local f=Instance.new("Frame")
    f.Parent=Root
    f.Size=UDim2.new(1,-12,0,height)
    f.BackgroundColor3=Color3.fromRGB(7,8,12)
    f.BackgroundTransparency=0.08
    f.BorderSizePixel=0
    f.LayoutOrder=order
    Corner(f,10)
    Stroke(f)
    return f
end

local gameName="Roblox"
pcall(function()
    local info=MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName=info.Name end
end)

local welcome=Card(1,72)
local welcomeTitle=Text(welcome,"WELCOME TO FISHHUB",16,true,Theme())
welcomeTitle.Size=UDim2.new(1,-24,0,24)
welcomeTitle.Position=UDim2.new(0,12,0,8)
welcomeTitle.TextXAlignment=Enum.TextXAlignment.Left
local welcomeSub=Text(welcome,"Script interface ready for "..gameName..". Current place: "..tostring(game.PlaceId),10,false,Color3.fromRGB(165,170,185))
welcomeSub.Size=UDim2.new(1,-24,0,30)
welcomeSub.Position=UDim2.new(0,12,0,34)
welcomeSub.TextXAlignment=Enum.TextXAlignment.Left

Divider("PLAYER STATUS",2)

local status=Card(3,112)
local statusGrid=Instance.new("UIGridLayout")
statusGrid.Parent=status
statusGrid.CellSize=UDim2.new(0.5,-10,0,42)
statusGrid.CellPadding=UDim2.new(0,8,0,6)
statusGrid.HorizontalAlignment=Enum.HorizontalAlignment.Center
statusGrid.VerticalAlignment=Enum.VerticalAlignment.Center

local function ValueCard(title,value)
    local box=Instance.new("Frame")
    box.BackgroundColor3=Color3.fromRGB(15,16,22)
    box.BorderSizePixel=0
    Corner(box,7)
    local t=Text(box,title,9,true,Color3.fromRGB(145,150,165))
    t.Size=UDim2.new(1,-12,0,15)
    t.Position=UDim2.new(0,6,0,4)
    t.TextXAlignment=Enum.TextXAlignment.Left
    local v=Text(box,value,12,true,Color3.fromRGB(245,245,250))
    v.Name="Value"
    v.Size=UDim2.new(1,-12,0,18)
    v.Position=UDim2.new(0,6,0,20)
    v.TextXAlignment=Enum.TextXAlignment.Left
    return box,v
end

local stats={}
local function FindStat(names,default)
    local leader=Player:FindFirstChild("leaderstats")
    if leader then
        for _,name in ipairs(names) do
            local obj=leader:FindFirstChild(name)
            if obj and (obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue")) then
                return obj
            end
        end
    end
    return default
end

local levelObj=FindStat({"Level","level"},0)
local beliObj=FindStat({"Beli","Money","Cash"},0)
local fragObj=FindStat({"Fragments","Fragment","fragments"},0)
local teamObj=Player.Team

local a,av=ValueCard("LEVEL",tostring(levelObj.Value or 0))
local b,bv=ValueCard("TEAM",teamObj and teamObj.Name or "Unknown")
local c,cv=ValueCard("BELI",tostring(beliObj.Value or 0))
local d,dv=ValueCard("FRAGMENTS",tostring(fragObj.Value or 0))
stats={{levelObj,av},{beliObj,cv},{fragObj,dv}}

local teamLast=teamObj
local function UpdateStatus()
    if levelObj and levelObj.Parent then av.Text=tostring(levelObj.Value) end
    if beliObj and beliObj.Parent then cv.Text=tostring(beliObj.Value) end
    if fragObj and fragObj.Parent then dv.Text=tostring(fragObj.Value) end
    if Player.Team then bv.Text=Player.Team.Name end
end
if levelObj.Changed then levelObj.Changed:Connect(UpdateStatus) end
if beliObj.Changed then beliObj.Changed:Connect(UpdateStatus) end
if fragObj.Changed then fragObj.Changed:Connect(UpdateStatus) end
Player:GetPropertyChangedSignal("Team"):Connect(UpdateStatus)
UpdateStatus()

Divider("INFORMATION",4)

local info=Card(5,116)
local avatar=Instance.new("ImageLabel")
avatar.Parent=info
avatar.Size=UDim2.new(0,78,0,78)
avatar.Position=UDim2.new(0,12,0.5,-39)
avatar.BackgroundColor3=Color3.fromRGB(18,19,26)
avatar.BorderSizePixel=0
avatar.Image="rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
avatar.ScaleType=Enum.ScaleType.Crop
Corner(avatar,10)
Stroke(avatar)

local infoText=Instance.new("Frame")
infoText.Parent=info
infoText.Size=UDim2.new(1,-108,1,-16)
infoText.Position=UDim2.new(0,102,0,8)
infoText.BackgroundTransparency=1

local il=Instance.new("UIListLayout")
il.Parent=infoText
il.Padding=UDim.new(0,2)
il.VerticalAlignment=Enum.VerticalAlignment.Center

local function InfoLine(label,value)
    local row=Instance.new("Frame")
    row.Parent=infoText
    row.Size=UDim2.new(1,0,0,18)
    row.BackgroundTransparency=1
    local l=Text(row,label,9,true,Color3.fromRGB(145,150,165))
    l.Size=UDim2.new(0,62,1,0)
    l.TextXAlignment=Enum.TextXAlignment.Left
    local v=Text(row,value,10,true,Color3.fromRGB(238,238,245))
    v.Size=UDim2.new(1,-68,1,0)
    v.Position=UDim2.new(0,68,0,0)
    v.TextXAlignment=Enum.TextXAlignment.Left
    v.TextTruncate=Enum.TextTruncate.AtEnd
    return v
end

InfoLine("NAME",Player.DisplayName)
InfoLine("@NAME","@"..Player.Name)
InfoLine("USERID",tostring(Player.UserId))
local executor="Unknown"
pcall(function()
    if identifyexecutor then
        executor=identifyexecutor()
    elseif getexecutorname then
        executor=getexecutorname()
    end
end)
InfoLine("EXECUTOR",executor)

task.spawn(function()
    while Tab.Parent and Root.Parent do
        local color=Theme()
        for _,obj in ipairs(Root:GetDescendants()) do
            if obj:IsA("UIStroke") then obj.Color=color end
        end
        welcomeTitle.TextColor3=color
        task.wait(0.5)
    end
end)
