local Players=game:GetService('Players')
local TweenService=game:GetService('TweenService')
local StarterGui=game:GetService('StarterGui')
local RunService=game:GetService('RunService')
local context=...
if type(context)~='table' or not context.Tab then return end
local Tab=context.Tab;local Config=context.Config or {}
local function accent()return typeof(Config.ThemeColor)=='Color3' and Config.ThemeColor or Color3.fromRGB(0,229,255)end
local function N(c,p)local o=Instance.new(c);for k,v in pairs(p or {})do o[k]=v end;return o end
local function Circle(p)local c=N('UICorner',{Parent=p,CornerRadius=UDim.new(1,0)});return c end
local function Round(p,r)return N('UICorner',{Parent=p,CornerRadius=UDim.new(0,r)})end
local function Stroke(p,t,a)return N('UIStroke',{Parent=p,Color=accent(),Thickness=t or 1,Transparency=a or .4})end
local function Tween(o,d,p,style)local x=TweenService:Create(o,TweenInfo.new(d or .2,style or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p);x:Play();return x end
local function notify(t)if type(context.ShowNotification)=='function' then pcall(context.ShowNotification,t)else pcall(function()StarterGui:SetCore('SendNotification',{Title='FishHub',Text=t,Duration=3})end)end end

-- ================= RAINBOW / DECOR HELPERS =================
local connections={}
local function track(c) table.insert(connections,c); return c end

-- Bo viền cầu vồng xoay tròn, gắn vào 1 UIStroke có sẵn
local function RainbowStroke(strokeObj,speed,rainbowTransparency)
	local grad=N('UIGradient',{
		Parent=strokeObj,
		Color=ColorSequence.new({
			ColorSequenceKeypoint.new(0.00,Color3.fromHSV(0/6,1,1)),
			ColorSequenceKeypoint.new(1/6,Color3.fromHSV(1/6,1,1)),
			ColorSequenceKeypoint.new(2/6,Color3.fromHSV(2/6,1,1)),
			ColorSequenceKeypoint.new(3/6,Color3.fromHSV(3/6,1,1)),
			ColorSequenceKeypoint.new(4/6,Color3.fromHSV(4/6,1,1)),
			ColorSequenceKeypoint.new(5/6,Color3.fromHSV(5/6,1,1)),
			ColorSequenceKeypoint.new(1.00,Color3.fromHSV(6/6,1,1)),
		})
	})
	if rainbowTransparency then strokeObj.Transparency=rainbowTransparency end
	track(RunService.Heartbeat:Connect(function(dt)
		grad.Rotation=(grad.Rotation+dt*36*(speed or 1))%360
	end))
	return grad
end

for _,v in ipairs(Tab:GetChildren())do v:Destroy()end
Tab.BackgroundTransparency=1;Tab.ScrollBarThickness=0;Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
local root=N('Frame',{Parent=Tab,Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
N('UIPadding',{Parent=root,PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,16),PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5)})
N('UIListLayout',{Parent=root,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,10)})

-- dọn dẹp toàn bộ connection khi tab bị xoá / mở lại
root.Destroying:Connect(function()
	for _,c in ipairs(connections)do pcall(function()c:Disconnect()end)end
end)

-- ===== thanh trang trí trên cùng (gradient rainbow mảnh) =====
local topBar=N('Frame',{Parent=root,LayoutOrder=0,Size=UDim2.new(1,0,0,3),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0});Round(topBar,2)
local topBarGrad=N('UIGradient',{Parent=topBar,Color=ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
	ColorSequenceKeypoint.new(.5,Color3.fromHSV(.5,1,1)),
	ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1)),
})})
track(RunService.Heartbeat:Connect(function(dt)topBarGrad.Offset=Vector2.new((topBarGrad.Offset.X+dt*.15)%2-1,0)end))

local profile=N('Frame',{Parent=root,LayoutOrder=1,Size=UDim2.new(1,0,0,138),BackgroundColor3=Color3.fromRGB(9,10,17),BorderSizePixel=0});Round(profile,16)
local profileStroke=Stroke(profile,1.3,.28)
local profileGradient=N('UIGradient',{Parent=profile,Rotation=18,Color=ColorSequence.new(Color3.fromRGB(20,22,35),Color3.fromRGB(8,9,15))})
local profileGlow=N('Frame',{Parent=profile,Position=UDim2.new(1,-92,0,-58),Size=UDim2.fromOffset(150,150),BackgroundColor3=accent(),BackgroundTransparency=.9,BorderSizePixel=0});Circle(profileGlow);N('UIGradient',{Parent=profileGlow,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.3),NumberSequenceKeypoint.new(1,1)})})
-- glow nhấp nháy nhẹ theo nhịp cho sang
task.spawn(function()
	while profileGlow and profileGlow.Parent do
		Tween(profileGlow,1.6,{BackgroundTransparency=.82},Enum.EasingStyle.Sine)
		task.wait(1.6)
		if not (profileGlow and profileGlow.Parent) then break end
		Tween(profileGlow,1.6,{BackgroundTransparency=.92},Enum.EasingStyle.Sine)
		task.wait(1.6)
	end
end)

-- ===== khung avatar: viền theme + vòng rainbow xoay bọc ngoài =====
local avHolder=N('Frame',{Parent=profile,Position=UDim2.fromOffset(17,17),Size=UDim2.fromOffset(104,104),BackgroundColor3=Color3.fromRGB(6,7,11),BorderSizePixel=0});Circle(avHolder)
N('UIStroke',{Parent=avHolder,Color=accent(),Thickness=2,Transparency=.15})
-- vòng ngoài cùng: hiệu ứng cầu vồng xoay bao quanh avatar
local outerRing=N('Frame',{Parent=profile,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(0,17+52,0,17+52),Size=UDim2.fromOffset(114,114),BackgroundTransparency=1});Circle(outerRing)
local outerRingStroke=N('UIStroke',{Parent=outerRing,Thickness=2.4,Transparency=0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
RainbowStroke(outerRingStroke,1.1)
local av=N('ImageLabel',{Parent=avHolder,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(96,96),BackgroundTransparency=1,Image='',ScaleType=Enum.ScaleType.Crop});Circle(av)
local fallback=N('TextLabel',{Parent=avHolder,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='R',Font=Enum.Font.GothamBlack,TextSize=30,TextColor3=accent()});fallback.ZIndex=3
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(137,22),Size=UDim2.new(1,-150,0,24),BackgroundTransparency=1,Text='@thankhuyenhuy',Font=Enum.Font.GothamBlack,TextSize=18,TextColor3=Color3.fromRGB(245,246,252),TextXAlignment=Enum.TextXAlignment.Left})
local roleRow=N('Frame',{Parent=profile,Position=UDim2.fromOffset(137,48),Size=UDim2.new(1,-150,0,18),BackgroundTransparency=1})
N('UIListLayout',{Parent=roleRow,FillDirection=Enum.FillDirection.Horizontal,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,5)})
local roleDot=N('Frame',{Parent=roleRow,Size=UDim2.fromOffset(6,6),BackgroundColor3=accent(),BorderSizePixel=0});Circle(roleDot)
task.spawn(function()
	while roleDot and roleDot.Parent do
		Tween(roleDot,.9,{BackgroundTransparency=.1},Enum.EasingStyle.Sine);task.wait(.9)
		if not (roleDot and roleDot.Parent) then break end
		Tween(roleDot,.9,{BackgroundTransparency=.75},Enum.EasingStyle.Sine);task.wait(.9)
	end
end)
N('TextLabel',{Parent=roleRow,Size=UDim2.new(1,-11,1,0),BackgroundTransparency=1,Text='ROBLOX CREATOR',Font=Enum.Font.GothamBold,TextSize=9,TextColor3=accent(),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(138,74),Size=UDim2.new(1,-150,0,38),BackgroundTransparency=1,Text='FishHub interface • social links\nTap a circle to copy the link.',Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=Color3.fromRGB(135,141,158),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
local USERNAME='thankhuyenhuy'
task.spawn(function()local id;local ok,res=pcall(function()return Players:GetUserIdFromNameAsync(USERNAME)end);if ok then id=res end;if not id then return end;local ok2,img=pcall(function()return Players:GetUserThumbnailAsync(id,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end);if ok2 and img and img~='' then av.Image=img;fallback.Visible=false end end)

-- ===== tiêu đề khu social có gạch chân gradient trang trí =====
local titleWrap=N('Frame',{Parent=root,LayoutOrder=2,Size=UDim2.new(1,0,0,46),BackgroundTransparency=1})
local titleAccent=N('Frame',{Parent=titleWrap,Position=UDim2.fromOffset(0,2),Size=UDim2.fromOffset(3,32),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0});Round(titleAccent,2)
local titleAccentGrad=N('UIGradient',{Parent=titleAccent,Rotation=90,Color=ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
	ColorSequenceKeypoint.new(.5,Color3.fromHSV(.5,1,1)),
	ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1)),
})})
track(RunService.Heartbeat:Connect(function(dt)titleAccentGrad.Offset=Vector2.new(0,(titleAccentGrad.Offset.Y+dt*.2)%2-1)end))
N('TextLabel',{Parent=titleWrap,Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,0,18),BackgroundTransparency=1,Text='SOCIAL LINKS',Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(239,241,248),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=titleWrap,Position=UDim2.fromOffset(14,20),Size=UDim2.new(1,-14,0,16),BackgroundTransparency=1,Text='Click a circular logo to copy its link',Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=Color3.fromRGB(135,141,158),TextXAlignment=Enum.TextXAlignment.Left})
local divider=N('Frame',{Parent=titleWrap,Position=UDim2.fromOffset(0,42),Size=UDim2.new(1,0,0,1),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=.9,BorderSizePixel=0})

local row=N('Frame',{Parent=root,LayoutOrder=3,Size=UDim2.new(1,0,0,132),BackgroundTransparency=1});N('UIListLayout',{Parent=row,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,20)})
local socials={{'DISCORD','rbxassetid://79178042116025','https://discord.gg/zFN6Nd99fC'},{'FACEBOOK','rbxassetid://121038275317096','https://www.facebook.com/dao.huy.lam.09/'},{'TIKTOK','rbxassetid://71597520923112','https://www.tiktok.com/@daolam.trh'}}
for i,d in ipairs(socials)do
	local h=N('Frame',{Parent=row,Size=UDim2.fromOffset(95,127),BackgroundTransparency=1})
	-- vòng rainbow ngoài cùng bọc quanh từng icon xã hội (trang trí)
	local outer=N('Frame',{Parent=h,Size=UDim2.fromOffset(92,92),Position=UDim2.new(.5,-46,0,-3),BackgroundTransparency=1});Circle(outer)
	local outerStroke=N('UIStroke',{Parent=outer,Thickness=2,Transparency=0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
	RainbowStroke(outerStroke,.85+(i*.12))
	local b=N('TextButton',{Parent=h,Size=UDim2.fromOffset(82,82),Position=UDim2.new(.5,-41,0,2),AutoButtonColor=false,Text='',BackgroundColor3=Color3.fromRGB(9,10,16),BorderSizePixel=0});Circle(b)
	local st=Stroke(b,1.5,.3) -- viền trong: màu theme mặc định
	local sc=N('UIScale',{Parent=b})
	local img=N('ImageLabel',{Parent=b,Size=UDim2.fromOffset(50,50),Position=UDim2.new(.5,-25,.5,-25),BackgroundTransparency=1,Image=d[2],ImageColor3=accent(),ScaleType=Enum.ScaleType.Fit})
	N('TextLabel',{Parent=h,Position=UDim2.new(0,0,0,98),Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text=d[1],Font=Enum.Font.GothamBold,TextSize=8,TextColor3=Color3.fromRGB(235,237,244),TextXAlignment=Enum.TextXAlignment.Center})
	b.MouseEnter:Connect(function()
		Tween(sc,.2,{Scale=1.1},Enum.EasingStyle.Back)
		Tween(st,.2,{Thickness=2.2,Transparency=0})
		Tween(img,.2,{Size=UDim2.fromOffset(56,56),Position=UDim2.new(.5,-28,.5,-28)},Enum.EasingStyle.Back)
		Tween(outerStroke,.2,{Thickness=3})
	end)
	b.MouseLeave:Connect(function()
		Tween(sc,.2,{Scale=1})
		Tween(st,.2,{Thickness=1.5,Transparency=.3})
		Tween(img,.2,{Size=UDim2.fromOffset(50,50),Position=UDim2.new(.5,-25,.5,-25)})
		Tween(outerStroke,.2,{Thickness=2})
	end)
	b.Activated:Connect(function()
		pcall(function()if setclipboard then setclipboard(d[3])end end)
		notify('Copied '..d[1]..' link!')
	end)
end
return {Root=root}
