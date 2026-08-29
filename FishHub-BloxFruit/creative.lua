local Players=game:GetService('Players')
local TweenService=game:GetService('TweenService')
local StarterGui=game:GetService('StarterGui')
local RunService=game:GetService('RunService')
local context=...
if type(context)~='table' or not context.Tab then return end
local Tab=context.Tab;local Config=context.Config or {}
local function accent()return typeof(Config.ThemeColor)=='Color3' and Config.ThemeColor or Color3.fromRGB(0,229,255)end
local function N(c,p)local o=Instance.new(c);for k,v in pairs(p or {})do o[k]=v end;return o end
local function Circle(p)return N('UICorner',{Parent=p,CornerRadius=UDim.new(1,0)})end
local function Round(p,r)return N('UICorner',{Parent=p,CornerRadius=UDim.new(0,r)})end
local function Stroke(p,t,a,c)return N('UIStroke',{Parent=p,Color=c or accent(),Thickness=t or 1,Transparency=a or .4})end
local function Tween(o,d,p,style)local x=TweenService:Create(o,TweenInfo.new(d or .2,style or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p);x:Play();return x end
local function notify(t)if type(context.ShowNotification)=='function' then pcall(context.ShowNotification,t)else pcall(function()StarterGui:SetCore('SendNotification',{Title='FishHub',Text=t,Duration=3})end)end end

------------------------------------------------------------
-- DECOR HELPERS
------------------------------------------------------------
local connections={}
local function track(c)table.insert(connections,c);return c end

-- Vòng cầu vồng xoay (dán UIGradient vào 1 UIStroke có sẵn)
local RAINBOW=ColorSequence.new({
	ColorSequenceKeypoint.new(0.00,Color3.fromHSV(0/6,.85,1)),
	ColorSequenceKeypoint.new(1/6 ,Color3.fromHSV(1/6,.85,1)),
	ColorSequenceKeypoint.new(2/6 ,Color3.fromHSV(2/6,.85,1)),
	ColorSequenceKeypoint.new(3/6 ,Color3.fromHSV(3/6,.85,1)),
	ColorSequenceKeypoint.new(4/6 ,Color3.fromHSV(4/6,.85,1)),
	ColorSequenceKeypoint.new(5/6 ,Color3.fromHSV(5/6,.85,1)),
	ColorSequenceKeypoint.new(1.00,Color3.fromHSV(6/6,.85,1)),
})
local function RainbowStroke(strokeObj,speed)
	local grad=N('UIGradient',{Parent=strokeObj,Color=RAINBOW})
	track(RunService.Heartbeat:Connect(function(dt)
		grad.Rotation=(grad.Rotation+dt*34*(speed or 1))%360
	end))
	return grad
end

-- Kiểu "IG story ring": vòng rainbow ngoài -> khoảng hở màu nền -> nội dung
local function StoryRing(parent,centerPos,ringD,gapD,bgColor,ringThickness,speed)
	local ring=N('Frame',{Parent=parent,AnchorPoint=Vector2.new(.5,.5),Position=centerPos,Size=UDim2.fromOffset(ringD,ringD),BackgroundTransparency=1});Circle(ring)
	local ringStroke=N('UIStroke',{Parent=ring,Thickness=ringThickness or 3,Transparency=0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
	RainbowStroke(ringStroke,speed)
	local gap=N('Frame',{Parent=parent,AnchorPoint=Vector2.new(.5,.5),Position=centerPos,Size=UDim2.fromOffset(gapD,gapD),BackgroundColor3=bgColor,BorderSizePixel=0});Circle(gap)
	return ring,ringStroke,gap
end

local function GlowBlob(parent,pos,size,color,minT,maxT,period)
	local g=N('Frame',{Parent=parent,Position=pos,Size=size,BackgroundColor3=color,BackgroundTransparency=minT,BorderSizePixel=0});Circle(g)
	N('UIGradient',{Parent=g,Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})})
	task.spawn(function()
		while g and g.Parent do
			Tween(g,period or 1.8,{BackgroundTransparency=maxT},Enum.EasingStyle.Sine);task.wait(period or 1.8)
			if not(g and g.Parent)then break end
			Tween(g,period or 1.8,{BackgroundTransparency=minT},Enum.EasingStyle.Sine);task.wait(period or 1.8)
		end
	end)
	return g
end

------------------------------------------------------------
-- ROOT
------------------------------------------------------------
for _,v in ipairs(Tab:GetChildren())do v:Destroy()end
Tab.BackgroundTransparency=1;Tab.ScrollBarThickness=0;Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
local root=N('Frame',{Parent=Tab,Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
N('UIPadding',{Parent=root,PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,18),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)})
N('UIListLayout',{Parent=root,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,14)})
root.Destroying:Connect(function()for _,c in ipairs(connections)do pcall(function()c:Disconnect()end)end end)

------------------------------------------------------------
-- HEADER CARD
------------------------------------------------------------
local CARD_BG=Color3.fromRGB(9,10,17)
local header=N('Frame',{Parent=root,LayoutOrder=1,Size=UDim2.new(1,0,0,158),BackgroundColor3=CARD_BG,BorderSizePixel=0,ClipsDescendants=true})
Round(header,18)
Stroke(header,1,.35,Color3.fromRGB(255,255,255))
N('UIGradient',{Parent=header,Rotation=100,Color=ColorSequence.new(Color3.fromRGB(21,23,36),Color3.fromRGB(7,8,13))})
GlowBlob(header,UDim2.new(1,-70,0,-70),UDim2.fromOffset(170,170),accent(),.88,.95,2.2)
GlowBlob(header,UDim2.new(0,-40,1,-30),UDim2.fromOffset(120,120),accent(),.93,.97,2.6)

-- avatar: story-ring rainbow + khoảng hở + viền theme
local AV_CENTER=UDim2.fromOffset(62,62)
StoryRing(header,AV_CENTER,102,92,CARD_BG,3,1.1)
local avHolder=N('Frame',{Parent=header,AnchorPoint=Vector2.new(.5,.5),Position=AV_CENTER,Size=UDim2.fromOffset(86,86),BackgroundColor3=Color3.fromRGB(6,7,11),BorderSizePixel=0});Circle(avHolder)
Stroke(avHolder,1.4,.25)
local av=N('ImageLabel',{Parent=avHolder,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(80,80),BackgroundTransparency=1,Image='',ScaleType=Enum.ScaleType.Crop});Circle(av)
local fallback=N('TextLabel',{Parent=avHolder,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='R',Font=Enum.Font.GothamBlack,TextSize=28,TextColor3=accent(),ZIndex=3})

-- tên + chip role + bio
local TEXT_X=140
N('TextLabel',{Parent=header,Position=UDim2.fromOffset(TEXT_X,20),Size=UDim2.new(1,-(TEXT_X+14),0,24),BackgroundTransparency=1,Text='@thankhuyenhuy',Font=Enum.Font.GothamBlack,TextSize=18,TextColor3=Color3.fromRGB(247,248,253),TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd})

local chip=N('Frame',{Parent=header,Position=UDim2.fromOffset(TEXT_X,50),Size=UDim2.fromOffset(122,20),BackgroundColor3=accent(),BackgroundTransparency=.85,BorderSizePixel=0});Round(chip,10)
Stroke(chip,1,.6)
N('UIListLayout',{Parent=chip,FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,5)})
local roleDot=N('Frame',{Parent=chip,Size=UDim2.fromOffset(6,6),BackgroundColor3=accent(),BorderSizePixel=0});Circle(roleDot)
task.spawn(function()
	while roleDot and roleDot.Parent do
		Tween(roleDot,1,{BackgroundTransparency=.1},Enum.EasingStyle.Sine);task.wait(1)
		if not(roleDot and roleDot.Parent)then break end
		Tween(roleDot,1,{BackgroundTransparency=.7},Enum.EasingStyle.Sine);task.wait(1)
	end
end)
N('TextLabel',{Parent=chip,Size=UDim2.fromOffset(96,16),BackgroundTransparency=1,Text='ROBLOX CREATOR',Font=Enum.Font.GothamBold,TextSize=8.5,TextColor3=accent(),TextXAlignment=Enum.TextXAlignment.Left})

N('TextLabel',{Parent=header,Position=UDim2.fromOffset(TEXT_X,78),Size=UDim2.new(1,-(TEXT_X+16),0,50),BackgroundTransparency=1,Text='FishHub interface — social links.\nTap a circle below to copy the link.',Font=Enum.Font.GothamMedium,TextSize=9.5,TextColor3=Color3.fromRGB(148,153,168),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})

local USERNAME='thankhuyenhuy'
local envTable=(type(getgenv)=='function' and getgenv())or _G
envTable.__FishHubCreativeCache=envTable.__FishHubCreativeCache or {}
local avatarCache=envTable.__FishHubCreativeCache

if avatarCache.image then
	av.Image=avatarCache.image
	fallback.Visible=false
else
	task.spawn(function()
		local id=avatarCache.userId
		if not id then
			local ok,res=pcall(function()return Players:GetUserIdFromNameAsync(USERNAME)end)
			if ok then id=res;avatarCache.userId=id end
		end
		if not id then return end
		local ok2,img=pcall(function()return Players:GetUserThumbnailAsync(id,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)
		if ok2 and img and img~='' then
			avatarCache.image=img
			if av and av.Parent then av.Image=img;fallback.Visible=false end
		end
	end)
end

------------------------------------------------------------
-- SECTION TITLE
------------------------------------------------------------
local titleWrap=N('Frame',{Parent=root,LayoutOrder=2,Size=UDim2.new(1,0,0,34),BackgroundTransparency=1})
local titleBar=N('Frame',{Parent=titleWrap,Position=UDim2.fromOffset(0,3),Size=UDim2.fromOffset(3,26),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0});Round(titleBar,2)
local titleBarGrad=N('UIGradient',{Parent=titleBar,Rotation=90,Color=RAINBOW})
track(RunService.Heartbeat:Connect(function(dt)titleBarGrad.Offset=Vector2.new(0,(titleBarGrad.Offset.Y+dt*.18)%2-1)end))
N('TextLabel',{Parent=titleWrap,Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,0,16),BackgroundTransparency=1,Text='SOCIAL LINKS',Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(241,242,249),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=titleWrap,Position=UDim2.fromOffset(14,17),Size=UDim2.new(1,-14,0,14),BackgroundTransparency=1,Text='Click a logo to copy its link',Font=Enum.Font.GothamMedium,TextSize=8.5,TextColor3=Color3.fromRGB(130,135,150),TextXAlignment=Enum.TextXAlignment.Left})

------------------------------------------------------------
-- SOCIAL CARDS (Dùng đúng các Asset ID của bạn)
------------------------------------------------------------
local row=N('Frame',{Parent=root,LayoutOrder=3,Size=UDim2.new(1,0,0,132),BackgroundTransparency=1})
N('UIListLayout',{Parent=row,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,14)})

local socials={
	{name='DISCORD',icon='rbxassetid://79178042116025',url='https://discord.gg/zFN6Nd99fC',brand=Color3.fromRGB(114,137,218)},
	{name='FACEBOOK',icon='rbxassetid://121038275317096',url='https://www.facebook.com/dao.huy.lam.09/',brand=Color3.fromRGB(66,140,244)},
	{name='TIKTOK',icon='rbxassetid://71597520923112',url='https://www.tiktok.com/@daolam.trh',brand=Color3.fromRGB(56,222,222)},
}
local SUCCESS=Color3.fromRGB(56,222,140)

for i,d in ipairs(socials)do
	local PANEL_BG=Color3.fromRGB(11,12,20)
	local card=N('Frame',{Parent=row,Size=UDim2.fromOffset(92,128),BackgroundColor3=PANEL_BG,BorderSizePixel=0});Round(card,16)
	local cardStroke=Stroke(card,1,.55,Color3.fromRGB(255,255,255))

	local iconCenter=UDim2.fromOffset(46,48)
	local ring,ringStroke=StoryRing(card,iconCenter,74,66,PANEL_BG,2.4,.9+(i*.15))
	local iconHolder=N('Frame',{Parent=card,AnchorPoint=Vector2.new(.5,.5),Position=iconCenter,Size=UDim2.fromOffset(60,60),BackgroundColor3=Color3.fromRGB(7,8,13),BorderSizePixel=0});Circle(iconHolder)
	local innerStroke=Stroke(iconHolder,1.3,.2)
	local sc=N('UIScale',{Parent=card})
	local img=N('ImageLabel',{Parent=iconHolder,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(32,32),BackgroundTransparency=1,Image=d.icon,ImageColor3=d.brand,ScaleType=Enum.ScaleType.Fit})

	N('TextLabel',{Parent=card,Position=UDim2.fromOffset(0,92),Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=d.name,Font=Enum.Font.GothamBold,TextSize=9,TextColor3=Color3.fromRGB(238,239,246),TextXAlignment=Enum.TextXAlignment.Center})
	N('TextLabel',{Parent=card,Position=UDim2.fromOffset(0,108),Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Text='Tap to copy',Font=Enum.Font.GothamMedium,TextSize=7.5,TextColor3=Color3.fromRGB(110,115,130),TextXAlignment=Enum.TextXAlignment.Center})

	local btn=N('TextButton',{Parent=card,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,AutoButtonColor=false,Text=''})

	btn.MouseEnter:Connect(function()
		Tween(sc,.18,{Scale=1.05},Enum.EasingStyle.Back)
		Tween(cardStroke,.18,{Transparency=.15})
		Tween(card,.18,{BackgroundColor3=Color3.fromRGB(15,17,27)})
		Tween(ringStroke,.18,{Thickness=3.2})
		Tween(innerStroke,.18,{Transparency=0,Thickness=1.7})
	end)
	btn.MouseLeave:Connect(function()
		Tween(sc,.18,{Scale=1})
		Tween(cardStroke,.18,{Transparency=.55})
		Tween(card,.18,{BackgroundColor3=PANEL_BG})
		Tween(ringStroke,.18,{Thickness=2.4})
		Tween(innerStroke,.18,{Transparency=.2,Thickness=1.3})
	end)
	btn.Activated:Connect(function()
		pcall(function()if setclipboard then setclipboard(d.url)end end)
		notify('Copied '..d.name..' link!')
		Tween(innerStroke,.15,{Color=SUCCESS,Transparency=0,Thickness=2.2})
		Tween(sc,.15,{Scale=1.12},Enum.EasingStyle.Back)
		task.delay(.55,function()
			if innerStroke and innerStroke.Parent then
				Tween(innerStroke,.35,{Color=accent(),Transparency=.2,Thickness=1.3})
			end
			if sc and sc.Parent then Tween(sc,.2,{Scale=1}) end
		end)
	end)
end

return {Root=root}
