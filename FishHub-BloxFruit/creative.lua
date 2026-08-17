local Players=game:GetService("Players")
local context=...
local player=(context and context.Player) or Players.LocalPlayer
if not player then return end
local playerGui=(context and context.PlayerGui) or player:WaitForChild("PlayerGui",10)
local tab=context and context.Tab
local main=context and context.MainWindow
if not tab then local fishHub=playerGui and playerGui:FindFirstChild("FishHub"); local mainWindow=fishHub and fishHub:FindFirstChild("MainWindow"); local content=mainWindow and mainWindow:FindFirstChild("ContentContainer"); tab=content and content:FindFirstChild("CreativeTab",true); main=main or mainWindow end
if not tab then return end
for _,child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ClipsDescendants=true
local function theme() local s=main and main:FindFirstChildOfClass("UIStroke"); return s and s.Color or Color3.fromRGB(104,82,255) end
local function corner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=p end
local function txt(p,t,s,c,f) local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Font=f or Enum.Font.GothamMedium; x.TextSize=s; x.TextColor3=c; x.Text=t; x.Parent=p; return x end
local root=Instance.new("Frame"); root.Size=UDim2.new(1,-10,1,0); root.BackgroundTransparency=1; root.Parent=tab
local list=Instance.new("UIListLayout"); list.Padding=UDim.new(0,12); list.HorizontalAlignment=Enum.HorizontalAlignment.Center; list.Parent=root
local dynamicLines={}; local dynamicStrokes={}
local function section(titleText,height)
 local holder=Instance.new("Frame"); holder.Size=UDim2.new(1,0,0,height); holder.BackgroundTransparency=1; holder.Parent=root
 local title=txt(holder,titleText,10,theme(),Enum.Font.GothamBold); title.Size=UDim2.new(0,200,0,18); title.Position=UDim2.new(.5,-100,0,0); title.TextXAlignment=Enum.TextXAlignment.Center; title.ZIndex=5
 local line=Instance.new("Frame"); line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,0,25); line.BackgroundColor3=theme(); line.BorderSizePixel=0; line.ZIndex=1; line.Parent=holder
 local grad=Instance.new("UIGradient"); grad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.96),NumberSequenceKeypoint.new(.18,.60),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.82,.60),NumberSequenceKeypoint.new(1,.96)}); grad.Parent=line
 local card=Instance.new("Frame"); card.Size=UDim2.new(1,-4,0,height-43); card.Position=UDim2.new(0,2,0,39); card.BackgroundColor3=Color3.fromRGB(7,8,12); card.BorderSizePixel=0; card.Parent=holder; corner(card,11)
 local st=Instance.new("UIStroke"); st.Color=theme(); st.Transparency=.65; st.Parent=card
 table.insert(dynamicLines,{line=line,title=title}); table.insert(dynamicStrokes,st); return card
end
local roblox=section("ROBLOX PLAYERS",140)
-- DisplayName is the actual in-game name; UserName remains only as @username.
local displayName=player.DisplayName
local username=player.Name
local av=Instance.new("ImageLabel"); av.Size=UDim2.new(0,68,0,68); av.Position=UDim2.new(0,14,0,12); av.BackgroundColor3=Color3.fromRGB(14,15,22); av.BorderSizePixel=0; av.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"; av.Parent=roblox; corner(av,11)
local nm=txt(roblox,displayName,14,Color3.fromRGB(245,246,252),Enum.Font.GothamBold); nm.Position=UDim2.new(0,96,0,12); nm.Size=UDim2.new(1,-110,0,23)
local usr=txt(roblox,"@"..username,10,theme(),Enum.Font.GothamBold); usr.Position=UDim2.new(0,96,0,38); usr.Size=UDim2.new(1,-110,0,19)
local tag=txt(roblox,"SCRIPT CREATOR  •  ROBLOX PROFILE",8,Color3.fromRGB(100,105,120),Enum.Font.GothamBold); tag.Position=UDim2.new(0,14,0,93); tag.Size=UDim2.new(1,-28,0,18)
task.spawn(function() while tab.Parent do local c=theme(); usr.TextColor3=c; for _,item in ipairs(dynamicLines) do item.line.BackgroundColor3=c; item.title.TextColor3=c end; for _,s in ipairs(dynamicStrokes) do if s.Parent then s.Color=c end end; task.wait(.08) end end)
