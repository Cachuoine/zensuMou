local Players=game:GetService('Players')
local TweenService=game:GetService('TweenService')
local StarterGui=game:GetService('StarterGui')
local RunService=game:GetService('RunService')

local context=...
if type(context)~='table' or not context.Tab then return end

local Tab=context.Tab
local Config=context.Config or {}

local function accent()
	return typeof(Config.ThemeColor)=='Color3' and Config.ThemeColor or Color3.fromRGB(0,229,255)
end

-- Supports the common FishHub config names without changing the existing interface.
local function rainbowEnabled()
	return Config.Rainbow==true or Config.RainbowEnabled==true or Config.RainbowMode==true
end

local function N(c,p)
	local o=Instance.new(c)
	for k,v in pairs(p or {}) do o[k]=v end
	return o
end

local function Circle(p)
	return N('UICorner',{Parent=p,CornerRadius=UDim.new(1,0)})
end

local function Round(p,r)
	return N('UICorner',{Parent=p,CornerRadius=UDim.new(0,r)})
end

local function Stroke(p,t,a)
	return N('UIStroke',{Parent=p,Color=accent(),Thickness=t or 1,Transparency=a or .4})
end

local function Tween(o,d,p,style)
	local x=TweenService:Create(o,TweenInfo.new(d or .2,style or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p)
	x:Play()
	return x
end

local function notify(t)
	if type(context.ShowNotification)=='function' then
		pcall(context.ShowNotification,t)
	else
		pcall(function()
			StarterGui:SetCore('SendNotification',{Title='FishHub',Text=t,Duration=3})
		end)
	end
end

for _,v in ipairs(Tab:GetChildren()) do v:Destroy() end
Tab.BackgroundTransparency=1
Tab.ScrollBarThickness=0
Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y

local root=N('Frame',{
	Parent=Tab,
	Size=UDim2.new(1,-10,0,0),
	AutomaticSize=Enum.AutomaticSize.Y,
	BackgroundTransparency=1
})

N('UIPadding',{
	Parent=root,
	PaddingTop=UDim.new(0,8),
	PaddingBottom=UDim.new(0,16),
	PaddingLeft=UDim.new(0,5),
	PaddingRight=UDim.new(0,5)
})

N('UIListLayout',{
	Parent=root,
	SortOrder=Enum.SortOrder.LayoutOrder,
	HorizontalAlignment=Enum.HorizontalAlignment.Center,
	Padding=UDim.new(0,10)
})

-- Profile card
local profile=N('Frame',{Parent=root,LayoutOrder=1,Size=UDim2.new(1,0,0,154),BackgroundColor3=Color3.fromRGB(8,9,15),BorderSizePixel=0});Round(profile,18);local profileStroke=Stroke(profile,1.4,.18)
local profileGlow=N('Frame',{Parent=profile,Position=UDim2.fromOffset(2,2),Size=UDim2.new(1,-4,0,3),BackgroundColor3=accent(),BorderSizePixel=0});Round(profileGlow,3)
local profileLine=N('Frame',{Parent=profile,Position=UDim2.fromOffset(20,145),Size=UDim2.new(1,-40,0,1),BackgroundColor3=accent(),BorderSizePixel=0});profileLine.BackgroundTransparency=.15
local avGlow=N('Frame',{Parent=profile,Position=UDim2.fromOffset(13,13),Size=UDim2.fromOffset(112,112),BackgroundColor3=accent(),BackgroundTransparency=.78,BorderSizePixel=0});Circle(avGlow)
local avHolder=N('Frame',{Parent=profile,Position=UDim2.fromOffset(18,18),Size=UDim2.fromOffset(102,102),BackgroundColor3=Color3.fromRGB(5,6,10),BorderSizePixel=0});Circle(avHolder);local avStroke=Stroke(avHolder,2,.05)
local av=N('ImageLabel',{Parent=avHolder,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(94,94),BackgroundTransparency=1,Image='',ScaleType=Enum.ScaleType.Crop});Circle(av)
local fallback=N('TextLabel',{Parent=avHolder,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='R',Font=Enum.Font.GothamBlack,TextSize=30,TextColor3=accent()});fallback.ZIndex=3
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(137,25),Size=UDim2.new(1,-154,0,26),BackgroundTransparency=1,Text='@thankhuyenhuy',Font=Enum.Font.GothamBlack,TextSize=19,TextColor3=Color3.fromRGB(248,249,255),TextXAlignment=Enum.TextXAlignment.Left})
local creator=N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(138,52),Size=UDim2.new(1,-154,0,18),BackgroundTransparency=1,Text='ROBLOX CREATOR  •  FISHHUB',Font=Enum.Font.GothamBold,TextSize=8,TextColor3=accent(),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(138,78),Size=UDim2.new(1,-154,0,42),BackgroundTransparency=1,Text='Social hub\nTap a circle below to copy a link.',Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=Color3.fromRGB(145,151,168),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
local USERNAME='thankhuyenhuy'
task.spawn(function()
	local id
	local ok,res=pcall(function()return Players:GetUserIdFromNameAsync(USERNAME)end)
	if ok then id=res end
	if not id then return end
	local ok2,img=pcall(function()
		return Players:GetUserThumbnailAsync(id,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
	end)
	if ok2 and img and img~='' then
		av.Image=img
		fallback.Visible=false
	end
end)

-- Section title
local title=N('TextLabel',{Parent=root,LayoutOrder=2,Size=UDim2.new(1,0,0,42),BackgroundTransparency=1,Text='SOCIAL LINKS',Font=Enum.Font.GothamBlack,TextSize=11,TextColor3=Color3.fromRGB(242,244,250),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
local subTitle=N('TextLabel',{Parent=root,LayoutOrder=2,Position=UDim2.fromOffset(0,17),Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text='CONNECT • SHARE • SUPPORT',Font=Enum.Font.GothamBold,TextSize=7,TextColor3=Color3.fromRGB(115,121,140),TextXAlignment=Enum.TextXAlignment.Left})
local row=N('Frame',{Parent=root,LayoutOrder=3,Size=UDim2.new(1,0,0,142),BackgroundTransparency=1})
local layout=N('UIListLayout',{Parent=row,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,24)})
local socials={{'DISCORD','rbxassetid://79178042116025','https://discord.gg/zFN6Nd99fC'},{'FACEBOOK','rbxassetid://121038275317096','https://www.facebook.com/dao.huy.lam.09/'},{'TIKTOK','rbxassetid://71597520923112','https://www.tiktok.com/@daolam.trh'}}
for _,d in ipairs(socials)do
 local h=N('Frame',{Parent=row,Size=UDim2.fromOffset(96,132),BackgroundTransparency=1})
 local glow=N('Frame',{Parent=h,Size=UDim2.fromOffset(88,88),Position=UDim2.new(.5,-44,0,2),BackgroundColor3=accent(),BackgroundTransparency=.82,BorderSizePixel=0});Circle(glow)
 local b=N('TextButton',{Parent=h,Size=UDim2.fromOffset(82,82),Position=UDim2.new(.5,-41,0,5),AutoButtonColor=false,Text='',BackgroundColor3=Color3.fromRGB(9,10,17),BorderSizePixel=0});Circle(b)
 local st=Stroke(b,1.7,.15)
 local inner=N('Frame',{Parent=b,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(70,70),BackgroundTransparency=1,BorderSizePixel=0});Circle(inner);local innerSt=Stroke(inner,1,.65)
 local sc=N('UIScale',{Parent=b})
 local img=N('ImageLabel',{Parent=b,Size=UDim2.fromOffset(48,48),Position=UDim2.new(.5,-24,.5,-24),BackgroundTransparency=1,Image=d[2],ImageColor3=accent(),ScaleType=Enum.ScaleType.Fit})
 local label=N('TextLabel',{Parent=h,Position=UDim2.new(0,0,0,95),Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text=d[1],Font=Enum.Font.GothamBold,TextSize=8,TextColor3=Color3.fromRGB(235,237,244),TextXAlignment=Enum.TextXAlignment.Center})
 local hint=N('TextLabel',{Parent=h,Position=UDim2.new(0,0,0,112),Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Text='COPY LINK',Font=Enum.Font.GothamMedium,TextSize=6,TextColor3=Color3.fromRGB(95,101,118),TextXAlignment=Enum.TextXAlignment.Center})
 b.MouseEnter:Connect(function()
   Tween(sc,.2,{Scale=1.12},Enum.EasingStyle.Back);Tween(st,.2,{Thickness=2.4,Transparency=0});Tween(innerSt,.2,{Thickness=1.5,Transparency=.25});Tween(glow,.2,{Size=UDim2.fromOffset(96,96),Position=UDim2.new(.5,-48,0,-2),BackgroundTransparency=.68},Enum.EasingStyle.Quad);Tween(img,.2,{Size=UDim2.fromOffset(55,55),Position=UDim2.new(.5,-27.5,.5,-27.5)},Enum.EasingStyle.Back);Tween(label,.2,{TextColor3=accent()})
 end)
 b.MouseLeave:Connect(function()
   Tween(sc,.2,{Scale=1});Tween(st,.2,{Thickness=1.7,Transparency=.15});Tween(innerSt,.2,{Thickness=1,Transparency=.65});Tween(glow,.2,{Size=UDim2.fromOffset(88,88),Position=UDim2.new(.5,-44,0,2),BackgroundTransparency=.82});Tween(img,.2,{Size=UDim2.fromOffset(48,48),Position=UDim2.new(.5,-24,.5,-24)});Tween(label,.2,{TextColor3=Color3.fromRGB(235,237,244)})
 end)
 b.Activated:Connect(function()
   Tween(sc,.1,{Scale=.94},Enum.EasingStyle.Quad);task.delay(.1,function()Tween(sc,.18,{Scale=1.08},Enum.EasingStyle.Back)end)
   pcall(function()if setclipboard then setclipboard(d[3])end end);notify('Copied '..d[1]..' link!')
 end)
end

local footer=N('TextLabel',{Parent=root,LayoutOrder=4,Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,Text='FISHHUB  •  SOCIAL CENTER',Font=Enum.Font.GothamBold,TextSize=7,TextColor3=Color3.fromRGB(80,86,103),TextXAlignment=Enum.TextXAlignment.Center})

local rainbowRunning=true
task.spawn(function()
 local hue=0
 while rainbowRunning and root.Parent do
   local rainbow=(Config.Rainbow==true or Config.RainbowEnabled==true or Config.RainbowMode==true)
   local c
   if rainbow then hue=(hue+0.004)%1;c=Color3.fromHSV(hue,.9,1) else c=accent() end
   profileGlow.BackgroundColor3=c;profileLine.BackgroundColor3=c;avGlow.BackgroundColor3=c
   profileStroke.Color=c;avStroke.Color=c;creator.TextColor3=c;title.TextColor3=rainbow and c or Color3.fromRGB(242,244,250)
   for _,obj in ipairs(row:GetDescendants())do
     if obj:IsA('UIStroke') then obj.Color=c elseif obj:IsA('ImageLabel') then obj.ImageColor3=c end
   end
   task.wait(.03)
 end
end)

return {Root=root}
