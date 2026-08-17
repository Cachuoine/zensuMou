local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local context = ...
local player = (context and context.Player) or Players.LocalPlayer
if not player then return end
local playerGui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui", 10)
local tab = context and context.Tab
local main = context and context.MainWindow
if not tab then
    local fishHub = playerGui and playerGui:FindFirstChild("FishHub")
    local mainWindow = fishHub and fishHub:FindFirstChild("MainWindow")
    local content = mainWindow and mainWindow:FindFirstChild("ContentContainer")
    tab = content and content:FindFirstChild("HomeTab", true)
    main = main or mainWindow
end
if not tab then return end

for _, child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ClipsDescendants = true

local function theme()
    local stroke = main and main:FindFirstChildOfClass("UIStroke")
    return stroke and stroke.Color or Color3.fromRGB(104, 82, 255)
end
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r); c.Parent = p
end
local function stroke(p,t)
    local s=Instance.new("UIStroke"); s.Color=theme(); s.Thickness=1; s.Transparency=t or .55; s.Parent=p; return s
end
local function label(p,text,size,color,font)
    local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Font=font or Enum.Font.GothamMedium; x.TextSize=size; x.TextColor3=color; x.Text=text; x.Parent=p; return x
end

local scroll=Instance.new("ScrollingFrame")
scroll.Name="HomeScroll"; scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
scroll.ScrollBarThickness=0; scroll.ScrollBarImageTransparency=1; scroll.ScrollingDirection=Enum.ScrollingDirection.Y
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.CanvasSize=UDim2.new(); scroll.Parent=tab
local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,5); pad.PaddingRight=UDim.new(0,5); pad.PaddingTop=UDim.new(0,4); pad.PaddingBottom=UDim.new(0,10); pad.Parent=scroll

local root=Instance.new("Frame"); root.Size=UDim2.new(1,-10,0,0); root.AutomaticSize=Enum.AutomaticSize.Y; root.BackgroundTransparency=1; root.Parent=scroll
local list=Instance.new("UIListLayout"); list.Padding=UDim.new(0,12); list.HorizontalAlignment=Enum.HorizontalAlignment.Center; list.Parent=root

local welcome=Instance.new("Frame"); welcome.Size=UDim2.new(1,0,0,104); welcome.BackgroundColor3=Color3.fromRGB(7,8,12); welcome.BorderSizePixel=0; welcome.Parent=root; corner(welcome,12); stroke(welcome,.42)
local accent=Instance.new("Frame"); accent.Size=UDim2.new(0,4,1,-28); accent.Position=UDim2.new(0,13,0,14); accent.BackgroundColor3=theme(); accent.BorderSizePixel=0; accent.Parent=welcome; corner(accent,3)
local wt=label(welcome,"FISHHUB",20,Color3.fromRGB(245,246,252),Enum.Font.GothamBlack); wt.Position=UDim2.new(0,30,0,14); wt.Size=UDim2.new(1,-45,0,25)
local ws=label(welcome,"Welcome to your control panel",10,Color3.fromRGB(145,150,165)); ws.Position=UDim2.new(0,31,0,42); ws.Size=UDim2.new(1,-45,0,18)
local gameName="Roblox"; pcall(function() local info=MarketplaceService:GetProductInfo(game.PlaceId); if info and info.Name then gameName=info.Name end end)
local gameTag=label(welcome,"●  "..gameName,9,theme(),Enum.Font.GothamBold); gameTag.Position=UDim2.new(0,31,0,70); gameTag.Size=UDim2.new(1,-45,0,18)

local dynamicLines={}
local dynamicStrokes={}
local function section(titleText,height)
    local holder=Instance.new("Frame"); holder.Size=UDim2.new(1,0,0,height); holder.BackgroundTransparency=1; holder.Parent=root
    local title=label(holder,titleText,10,theme(),Enum.Font.GothamBold); title.Size=UDim2.new(0,170,0,18); title.Position=UDim2.new(.5,-85,0,0); title.TextXAlignment=Enum.TextXAlignment.Center; title.ZIndex=3
    local line=Instance.new("Frame"); line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,0,24); line.BackgroundColor3=theme(); line.BorderSizePixel=0; line.ZIndex=1; line.Parent=holder
    local g=Instance.new("UIGradient"); g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.96),NumberSequenceKeypoint.new(.18,.60),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.82,.60),NumberSequenceKeypoint.new(1,.96)}); g.Parent=line
    table.insert(dynamicLines,{line=line,title=title})
    local card=Instance.new("Frame"); card.Size=UDim2.new(1,-4,0,height-43); card.Position=UDim2.new(0,2,0,39); card.BackgroundColor3=Color3.fromRGB(7,8,12); card.BorderSizePixel=0; card.Parent=holder; corner(card,11); table.insert(dynamicStrokes,stroke(card,.65)); return card
end

local status=section("PLAYER STATUS",136)
local function findValue(...)
    local names={...}; local containers={player:FindFirstChild("leaderstats"),player:FindFirstChild("Data"),player:FindFirstChild("data")}
    for _,container in ipairs(containers) do if container then for _,name in ipairs(names) do local v=container:FindFirstChild(name); if v then return v end end end end
    for _,name in ipairs(names) do local v=player:FindFirstChild(name); if v then return v end end
    return nil
end
local function formatNumber(value)
    if not value then return "0" end
    local raw=value.Value; local n=tonumber(raw); if not n then return tostring(raw or 0) end
    local s=tostring(math.floor(n)); local sign=""; if s:sub(1,1)=="-" then sign="-"; s=s:sub(2) end
    while true do local replaced,count=s:gsub("^(%d+)(%d%d%d)","%1,%2"); s=replaced; if count==0 then break end end
    return sign..s
end
local function createStat(titleText,valueText,x,y)
    local card=Instance.new("Frame"); card.Size=UDim2.new(.5,-9,0,34); card.Position=UDim2.new(x,4,0,y); card.BackgroundColor3=Color3.fromRGB(12,13,19); card.BorderSizePixel=0; card.Parent=status; corner(card,7)
    local title=label(card,titleText,8,Color3.fromRGB(115,120,135),Enum.Font.GothamBold); title.Size=UDim2.new(.58,0,1,0); title.Position=UDim2.new(0,8,0,0)
    local value=label(card,valueText,9,Color3.fromRGB(240,242,248),Enum.Font.GothamBold); value.Size=UDim2.new(.42,-8,1,0); value.Position=UDim2.new(.58,0,0,0); value.TextXAlignment=Enum.TextXAlignment.Right
    return title,value
end
local levelValue=findValue("Level","level"); local beliValue=findValue("Beli","Money","money"); local fragmentsValue=findValue("Fragments","Fragment","fragments")
local levelTitle,level=createStat("LEVEL",formatNumber(levelValue),0,7); local _,beli=createStat("BELI",formatNumber(beliValue),.5,7); local _,fragments=createStat("FRAGMENTS",formatNumber(fragmentsValue),0,48); local reputationTitle,reputation=createStat("BOUNTY","0",.5,48)

local function getTeamKind()
    local team=player.Team; if not team then return "Unknown" end
    local name=string.lower(team.Name)
    if string.find(name,"pirate",1,true) or string.find(name,"pira",1,true) then return "Pirates" end
    if string.find(name,"marine",1,true) or string.find(name,"mari",1,true) then return "Marines" end
    return team.Name
end
local function refreshReputation()
    local kind=getTeamKind()
    if kind=="Pirates" then reputationTitle.Text="BOUNTY"; reputation.Text=formatNumber(findValue("Bounty","bounty"))
    elseif kind=="Marines" then reputationTitle.Text="HONOR"; reputation.Text=formatNumber(findValue("Honor","honor"))
    else reputationTitle.Text="BOUNTY"; reputation.Text=formatNumber(findValue("Bounty","bounty")) end
end

local info=section("INFORMATION",142)
local avatar=Instance.new("ImageLabel"); avatar.Size=UDim2.new(0,64,0,64); avatar.Position=UDim2.new(0,13,0,12); avatar.BackgroundColor3=Color3.fromRGB(14,15,22); avatar.BorderSizePixel=0; avatar.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"; avatar.Parent=info; corner(avatar,10)
local dn=label(info,player.DisplayName,14,Color3.fromRGB(245,246,252),Enum.Font.GothamBold); dn.Position=UDim2.new(0,91,0,11); dn.Size=UDim2.new(1,-105,0,21)
local un=label(info,"@"..player.Name,10,theme(),Enum.Font.GothamBold); un.Position=UDim2.new(0,91,0,34); un.Size=UDim2.new(1,-105,0,18)
local uid=label(info,"USER ID  •  "..player.UserId,9,Color3.fromRGB(135,140,155)); uid.Position=UDim2.new(0,91,0,54); uid.Size=UDim2.new(1,-105,0,17)
local executorName="Unknown"; pcall(function() if identifyexecutor then local a,b=identifyexecutor(); executorName=tostring(a or b or "Unknown") elseif getexecutorname then executorName=tostring(getexecutorname()) end end)
local ex=label(info,"EXECUTOR  •  "..executorName,9,Color3.fromRGB(135,140,155)); ex.Position=UDim2.new(0,91,0,74); ex.Size=UDim2.new(1,-105,0,17)

-- Keep section lines/cards synchronized with the main theme, including rainbow/theme animation.
task.spawn(function()
    while tab.Parent do
        local accentColor=theme()
        accent.BackgroundColor3=accentColor; gameTag.TextColor3=accentColor; un.TextColor3=accentColor
        for _,item in ipairs(dynamicLines) do item.line.BackgroundColor3=accentColor; item.title.TextColor3=accentColor end
        for _,s in ipairs(dynamicStrokes) do if s and s.Parent then s.Color=accentColor end end
        task.wait(0.08)
    end
end)

task.spawn(function()
    while tab.Parent do
        levelValue=findValue("Level","level"); beliValue=findValue("Beli","Money","money"); fragmentsValue=findValue("Fragments","Fragment","fragments")
        level.Text=formatNumber(levelValue); beli.Text=formatNumber(beliValue); fragments.Text=formatNumber(fragmentsValue); refreshReputation()
        task.wait(.35)
    end
end)
