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
for _,v in ipairs(Tab:GetChildren())do v:Destroy()end
Tab.BackgroundTransparency=1;Tab.ScrollBarThickness=0;Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
local root=N('Frame',{Parent=Tab,Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
N('UIPadding',{Parent=root,PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,16),PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5)})
N('UIListLayout',{Parent=root,SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,10)})
local profile=N('Frame',{Parent=root,LayoutOrder=1,Size=UDim2.new(1,0,0,138),BackgroundColor3=Color3.fromRGB(9,10,17),BorderSizePixel=0});Round(profile,16);Stroke(profile,1.3,.28)
local avHolder=N('Frame',{Parent=profile,Position=UDim2.fromOffset(17,17),Size=UDim2.fromOffset(104,104),BackgroundColor3=Color3.fromRGB(6,7,11),BorderSizePixel=0});Circle(avHolder);Stroke(avHolder,2,.15)
local av=N('ImageLabel',{Parent=avHolder,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(96,96),BackgroundTransparency=1,Image='',ScaleType=Enum.ScaleType.Crop});Circle(av)
local fallback=N('TextLabel',{Parent=avHolder,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='R',Font=Enum.Font.GothamBlack,TextSize=30,TextColor3=accent()});fallback.ZIndex=3
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(137,22),Size=UDim2.new(1,-150,0,24),BackgroundTransparency=1,Text='@thankhuyenhuy',Font=Enum.Font.GothamBlack,TextSize=18,TextColor3=Color3.fromRGB(245,246,252),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(138,48),Size=UDim2.new(1,-150,0,18),BackgroundTransparency=1,Text='ROBLOX CREATOR',Font=Enum.Font.GothamBold,TextSize=9,TextColor3=accent(),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=profile,Position=UDim2.fromOffset(138,74),Size=UDim2.new(1,-150,0,38),BackgroundTransparency=1,Text='FishHub interface • social links\nTap a circle to copy the link.',Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=Color3.fromRGB(135,141,158),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
local USERNAME='thankhuyenhuy'
task.spawn(function()local id;local ok,res=pcall(function()return Players:GetUserIdFromNameAsync(USERNAME)end);if ok then id=res end;if not id then return end;local ok2,img=pcall(function()return Players:GetUserThumbnailAsync(id,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end);if ok2 and img and img~='' then av.Image=img;fallback.Visible=false end end)
local title=N('TextLabel',{Parent=root,LayoutOrder=2,Size=UDim2.new(1,0,0,38),BackgroundTransparency=1,Text='SOCIAL LINKS\nClick a circular logo to copy its link',Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(239,241,248),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top});title.RichText=false
local row=N('Frame',{Parent=root,LayoutOrder=3,Size=UDim2.new(1,0,0,125),BackgroundTransparency=1});local layout=N('UIListLayout',{Parent=row,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,20)})
local socials={{'DISCORD','rbxassetid://79178042116025','https://discord.gg/zFN6Nd99fC'},{'FACEBOOK','rbxassetid://121038275317096','https://www.facebook.com/dao.huy.lam.09/'},{'TIKTOK','rbxassetid://71597520923112','https://www.tiktok.com/@daolam.trh'}}
for _,d in ipairs(socials)do local h=N('Frame',{Parent=row,Size=UDim2.fromOffset(95,120),BackgroundTransparency=1});local b=N('TextButton',{Parent=h,Size=UDim2.fromOffset(82,82),Position=UDim2.new(.5,-41,0,2),AutoButtonColor=false,Text='',BackgroundColor3=Color3.fromRGB(9,10,16),BorderSizePixel=0});Circle(b);local st=Stroke(b,1.5,.3);local sc=N('UIScale',{Parent=b});local img=N('ImageLabel',{Parent=b,Size=UDim2.fromOffset(50,50),Position=UDim2.new(.5,-25,.5,-25),BackgroundTransparency=1,Image=d[2],ImageColor3=accent(),ScaleType=Enum.ScaleType.Fit});N('TextLabel',{Parent=h,Position=UDim2.new(0,0,0,91),Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Text=d[1],Font=Enum.Font.GothamBold,TextSize=8,TextColor3=Color3.fromRGB(235,237,244),TextXAlignment=Enum.TextXAlignment.Center});b.MouseEnter:Connect(function()Tween(sc,.2,{Scale=1.1},Enum.EasingStyle.Back);Tween(st,.2,{Thickness=2.2,Transparency=0});Tween(img,.2,{Size=UDim2.fromOffset(56,56),Position=UDim2.new(.5,-28,.5,-28)},Enum.EasingStyle.Back)end);b.MouseLeave:Connect(function()Tween(sc,.2,{Scale=1});Tween(st,.2,{Thickness=1.5,Transparency=.3});Tween(img,.2,{Size=UDim2.fromOffset(50,50),Position=UDim2.new(.5,-25,.5,-25)})end);b.Activated:Connect(function()pcall(function()if setclipboard then setclipboard(d[3])end end);notify('Copied '..d[1]..' link!')end)end
return {Root=root}