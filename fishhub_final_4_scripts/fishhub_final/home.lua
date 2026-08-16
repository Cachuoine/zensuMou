local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then return end
local gui = player:WaitForChild("PlayerGui", 10)
if not gui then return end
local hub = gui:FindFirstChild("FishHub")
local tab = hub and hub:FindFirstChild("HomeTab")
if not hub or not tab then return end

for _, child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ScrollBarThickness = 0
tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
tab.CanvasSize = UDim2.new()

tab.BackgroundTransparency = 1

local function theme()
    local main = hub:FindFirstChild("MainWindow")
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(0,229,255)
end

local function corner(o,r)
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 10) c.Parent=o
end

local function stroke(o,trans)
    local s=Instance.new("UIStroke") s.Color=theme() s.Thickness=1 s.Transparency=trans or .22 s.Parent=o return s
end

local root=Instance.new("Frame")
root.Parent=tab root.Size=UDim2.new(1,-8,0,0) root.AutomaticSize=Enum.AutomaticSize.Y
root.BackgroundTransparency=1
local list=Instance.new("UIListLayout")
list.Parent=root list.Padding=UDim.new(0,10) list.HorizontalAlignment=Enum.HorizontalAlignment.Center

local function text(parent, value, size, bold, color)
    local l=Instance.new("TextLabel")
    l.Parent=parent l.BackgroundTransparency=1 l.Text=value
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    l.TextSize=size l.TextColor3=color or Color3.fromRGB(235,237,245)
    l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end

local function divider(title, order)
    local holder=Instance.new("Frame")
    holder.Parent=root holder.Size=UDim2.new(1,-12,0,30) holder.LayoutOrder=order
    holder.BackgroundTransparency=1
    local lineTop=Instance.new("Frame")
    lineTop.Parent=holder lineTop.Size=UDim2.new(1,0,0,2) lineTop.Position=UDim2.new(0,0,0,14)
    lineTop.BackgroundColor3=theme() lineTop.BorderSizePixel=0 corner(lineTop,2)
    local grad=Instance.new("UIGradient") grad.Parent=lineTop
    grad.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,.92),NumberSequenceKeypoint.new(.18,.58),
        NumberSequenceKeypoint.new(.38,.15),NumberSequenceKeypoint.new(.5,0),
        NumberSequenceKeypoint.new(.62,.15),NumberSequenceKeypoint.new(.82,.58),
        NumberSequenceKeypoint.new(1,.92)
    })
    local label=text(holder,title,12,true,theme())
    label.Size=UDim2.new(1,0,0,24) label.Position=UDim2.new(0,0,0,-1)
    label.TextXAlignment=Enum.TextXAlignment.Center
    return holder,lineTop,label
end

local function card(order,height)
    local f=Instance.new("Frame")
    f.Parent=root f.LayoutOrder=order f.Size=UDim2.new(1,-12,0,height)
    f.BackgroundColor3=Color3.fromRGB(7,8,12) f.BackgroundTransparency=.05 f.BorderSizePixel=0
    corner(f,11) stroke(f,.28)
    return f
end

local gameName="Roblox"
pcall(function()
    local info=MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName=info.Name end
end)

local welcome=card(1,72)
local wTitle=text(welcome,"WELCOME TO FISHHUB",16,true,theme())
wTitle.Size=UDim2.new(1,-24,0,24) wTitle.Position=UDim2.new(0,12,0,8)
local wSub=text(welcome,"Script support: "..gameName.."  •  PlaceId: "..tostring(game.PlaceId),10,false,Color3.fromRGB(165,170,185))
wSub.Size=UDim2.new(1,-24,0,26) wSub.Position=UDim2.new(0,12,0,36)

divider("PLAYER STATUS",2)
local status=card(3,112)
local grid=Instance.new("UIGridLayout")
grid.Parent=status grid.CellSize=UDim2.new(.5,-10,0,42) grid.CellPadding=UDim2.new(0,8,0,6)
grid.HorizontalAlignment=Enum.HorizontalAlignment.Center grid.VerticalAlignment=Enum.VerticalAlignment.Center

local function findStat(...)
    local names={...}
    local leader=player:FindFirstChild("leaderstats")
    local containers={leader,player}
    for _,container in ipairs(containers) do
        if container then
            for _,name in ipairs(names) do
                local obj=container:FindFirstChild(name)
                if obj and (obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue")) then return obj end
            end
        end
    end
    return nil
end

local function formatNumber(v)
    local n=tonumber(v)
    if not n then return tostring(v or 0) end
    local s=tostring(math.floor(n+0.5))
    local sign=""
    if s:sub(1,1)=="-" then sign="-" s=s:sub(2) end
    while true do
        local replaced,count=s:gsub("^(%d+)(%d%d%d)","%1,%2")
        s=replaced if count==0 then break end
    end
    return sign..s
end

local function valueCard(title,value)
    local f=Instance.new("Frame") f.Parent=status f.BackgroundColor3=Color3.fromRGB(15,16,22)
    f.BorderSizePixel=0 corner(f,8)
    local s=stroke(f,.7)
    local a=text(f,title,9,true,Color3.fromRGB(145,150,165))
    a.Size=UDim2.new(1,-12,0,15) a.Position=UDim2.new(0,6,0,4)
    local b=text(f,value,12,true,Color3.fromRGB(245,245,250))
    b.Name="Value" b.Size=UDim2.new(1,-12,0,18) b.Position=UDim2.new(0,6,0,20)
    return b,s
end

local level=findStat("Level","level")
local beli=findStat("Beli","Money","Cash","money")
local fragments=findStat("Fragments","Fragment","fragments")
local levelLabel=select(1,valueCard("LEVEL",level and formatNumber(level.Value) or "0"))
local teamLabel=select(1,valueCard("TEAM",player.Team and player.Team.Name or "None"))
local beliLabel=select(1,valueCard("BELI",beli and formatNumber(beli.Value) or "0"))
local fragLabel=select(1,valueCard("FRAGMENTS",fragments and formatNumber(fragments.Value) or "0"))

local function refresh()
    levelLabel.Text=level and level.Parent and formatNumber(level.Value) or "0"
    beliLabel.Text=beli and beli.Parent and formatNumber(beli.Value) or "0"
    fragLabel.Text=fragments and fragments.Parent and formatNumber(fragments.Value) or "0"
    teamLabel.Text=player.Team and player.Team.Name or "None"
end
for _,obj in ipairs({level,beli,fragments}) do
    if obj then obj.Changed:Connect(refresh) end
end
player:GetPropertyChangedSignal("Team"):Connect(refresh)
refresh()

divider("INFORMATION",4)
local info=card(5,122)
local avatar=Instance.new("ImageLabel")
avatar.Parent=info avatar.Size=UDim2.new(0,78,0,78) avatar.Position=UDim2.new(0,12,.5,-39)
avatar.BackgroundColor3=Color3.fromRGB(18,19,26) avatar.BorderSizePixel=0 avatar.ScaleType=Enum.ScaleType.Crop
avatar.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150" corner(avatar,10) stroke(avatar,.35)

local infoText=Instance.new("Frame") infoText.Parent=info infoText.BackgroundTransparency=1
infoText.Size=UDim2.new(1,-104,1,-16) infoText.Position=UDim2.new(0,100,0,8)
local il=Instance.new("UIListLayout") il.Parent=infoText il.Padding=UDim.new(0,2)
local function infoRow(label,value,color)
    local row=Instance.new("Frame") row.Parent=infoText row.Size=UDim2.new(1,0,0,18) row.BackgroundTransparency=1
    local a=text(row,label,9,false,Color3.fromRGB(135,140,155)) a.Size=UDim2.new(.38,0,1,0)
    local b=text(row,value,10,true,color or Color3.fromRGB(240,242,248)) b.Size=UDim2.new(.62,0,1,0) b.Position=UDim2.new(.38,0,0,0)
    b.TextXAlignment=Enum.TextXAlignment.Left
    return b
end
local nameLabel=infoRow("NAME",player.Name)
local tagLabel=infoRow("@NAME","@"..player.Name,theme())
local idLabel=infoRow("USER ID",tostring(player.UserId))
local executor="Unknown"
pcall(function()
    if identifyexecutor then executor=tostring(identifyexecutor())
    elseif getexecutorname then executor=tostring(getexecutorname()) end
end)
local executorLabel=infoRow("EXECUTOR",executor)

-- Keep remote-module UI synced with the main hub theme.
task.spawn(function()
    while tab.Parent and root.Parent do
        local c=theme()
        wTitle.TextColor3=c tagLabel.TextColor3=c
        for _,o in ipairs(root:GetDescendants()) do
            if o:IsA("UIStroke") then o.Color=c end
            if o:IsA("Frame") and o.Size.Y.Offset==2 then o.BackgroundColor3=c end
        end
        task.wait(.45)
    end
end)
