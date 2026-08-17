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
local scroll=Instance.new("ScrollingFrame"); scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=0; scroll.ScrollBarImageTransparency=1; scroll.ScrollingDirection=Enum.ScrollingDirection.Y; scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=tab
local root=Instance.new("Frame"); root.Size=UDim2.new(1,-10,0,0); root.AutomaticSize=Enum.AutomaticSize.Y; root.BackgroundTransparency=1; root.Parent=scroll
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
local facebook=section("PROFILE",120)
local title=txt(facebook,"Profile image",10,Color3.fromRGB(230,232,240),Enum.Font.GothamBold); title.Position=UDim2.new(0,14,0,9); title.Size=UDim2.new(1,-28,0,20)
local profile=Instance.new("ImageLabel"); profile.Size=UDim2.fromOffset(44,44); profile.Position=UDim2.new(0,14,0,35); profile.BackgroundColor3=Color3.fromRGB(14,15,22); profile.BorderSizePixel=0; profile.ScaleType=Enum.ScaleType.Crop; profile.Image="https://scontent.fhan5-11.fna.fbcdn.net/v/t39.30808-6/639507734_122222004620277901_131643371501354954_n.jpg?stp=dst-jpg_tt6&cstp=mx2048x1536&ctp=s2048x1536&_nc_cat=110&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=cc71e4&_nc_eui2=AeGbW2GgRFd3WxIpeKiUxtwBZI2rbFEhzixkjatsUSHOLPjXvVSTny4EIWtebMyDR55-JwrGDqGm3wAFGtSAbHFN&_nc_ohc=j-w6Vq-LjC8Q7kNvwGXrMfQ&_nc_oc=AdpfPkpz6jrdJ6ot9pDxb17jEuOzZZGAUJpqFC32MWmBkjDNvq8-IggCY0ltq7XakgE&_nc_zt=23&_nc_ht=scontent.fhan5-11.fna&_nc_gid=O072jdVYZ512SNuEUCUOMw&_nc_ss=7b2a8&oh=00_AQFG3mF7kAd2b3vOoiiOjoLh1vNChGo6kIkqrh4L9sryQA&oe=6A8844C3"; profile.Parent=facebook; corner(profile,8)
local profileText=txt(facebook,"CUSTOM PROFILE",10,Color3.fromRGB(230,232,240),Enum.Font.GothamBold); profileText.Position=UDim2.new(0,70,0,39); profileText.Size=UDim2.new(1,-84,0,18)
local link=txt(facebook,"IMAGE URL",8,Color3.fromRGB(100,105,120),Enum.Font.GothamMedium); link.Position=UDim2.new(0,70,0,59); link.Size=UDim2.new(1,-84,0,18)
task.spawn(function() while tab.Parent do local c=theme(); usr.TextColor3=c; for _,item in ipairs(dynamicLines) do item.line.BackgroundColor3=c; item.title.TextColor3=c end; for _,s in ipairs(dynamicStrokes) do if s.Parent then s.Color=c end end; task.wait(.08) end end)
