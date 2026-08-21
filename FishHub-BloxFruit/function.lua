-- FishHub | Function.lua
-- Giữ nguyên cấu trúc: search bar ngang full + 2 ô / dòng.
local Players=game:GetService('Players')
local TweenService=game:GetService('TweenService')
local player=Players.LocalPlayer
local context=...
if type(context)~='table' or not context.Tab then return end
local Tab=context.Tab
local Config=context.Config or {}
local function accent() return typeof(Config.ThemeColor)=='Color3' and Config.ThemeColor or Color3.fromRGB(0,229,255) end
local function N(c,p)local o=Instance.new(c);for k,v in pairs(p or {})do o[k]=v end;return o end
local function C(p,r)local x=N('UICorner',{Parent=p,CornerRadius=UDim.new(0,r)});return x end
local function S(p,t,a)local x=N('UIStroke',{Parent=p,Color=accent(),Thickness=t or 1,Transparency=a or .5});return x end
local function T(o,d,p)local x=TweenService:Create(o,TweenInfo.new(d or .2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p);x:Play();return x end
for _,v in ipairs(Tab:GetChildren())do v:Destroy()end
Tab.BackgroundTransparency=1;Tab.ScrollBarThickness=0;Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
local root=N('Frame',{Parent=Tab,Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
N('UIPadding',{Parent=root,PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5)})
local list=N('UIListLayout',{Parent=root,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,9)})
local head=N('Frame',{Parent=root,LayoutOrder=1,Size=UDim2.new(1,0,0,62),BackgroundColor3=Color3.fromRGB(8,9,14),BorderSizePixel=0});C(head,14);S(head,1,.3)
local bar=N('Frame',{Parent=head,Position=UDim2.fromOffset(12,14),Size=UDim2.fromOffset(4,34),BackgroundColor3=accent(),BorderSizePixel=0});C(bar,4)
N('TextLabel',{Parent=head,Position=UDim2.fromOffset(27,9),Size=UDim2.new(1,-40,0,24),BackgroundTransparency=1,Text='FUNCTION',Font=Enum.Font.GothamBlack,TextSize=17,TextColor3=Color3.fromRGB(245,246,252),TextXAlignment=Enum.TextXAlignment.Left})
N('TextLabel',{Parent=head,Position=UDim2.fromOffset(27,34),Size=UDim2.new(1,-40,0,16),BackgroundTransparency=1,Text='TOOLS  •  MODULES  •  UTILITIES',Font=Enum.Font.GothamMedium,TextSize=8,TextColor3=Color3.fromRGB(125,130,145),TextXAlignment=Enum.TextXAlignment.Left})
-- Search bar remains one full horizontal bar.
local search=N('Frame',{Parent=root,LayoutOrder=2,Size=UDim2.new(1,0,0,42),BackgroundColor3=Color3.fromRGB(8,9,14),BorderSizePixel=0});C(search,11);local ss=S(search,1,.55)
local icon=N('TextLabel',{Parent=search,Position=UDim2.fromOffset(12,0),Size=UDim2.fromOffset(28,42),BackgroundTransparency=1,Text='⌕',Font=Enum.Font.GothamBold,TextSize=23,TextColor3=accent()})
local box=N('TextBox',{Parent=search,Position=UDim2.fromOffset(43,0),Size=UDim2.new(1,-48,1,0),BackgroundTransparency=1,Text='',PlaceholderText='Search...',PlaceholderColor3=Color3.fromRGB(105,110,125),TextColor3=Color3.fromRGB(235,237,244),Font=Enum.Font.GothamMedium,TextSize=10,ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left})
box.Focused:Connect(function()T(ss,.15,{Transparency=.05,Thickness=1.3})end);box.FocusLost:Connect(function()T(ss,.15,{Transparency=.55,Thickness=1})end)
local holder=N('Frame',{Parent=root,LayoutOrder=3,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
local grid=N('UIGridLayout',{Parent=holder,CellSize=UDim2.new(.5,-5,0,86),CellPadding=UDim2.new(0,10,0,10),FillDirectionMaxCells=2,SortOrder=Enum.SortOrder.LayoutOrder})
local mods={{'SHOP','Shop','Shop and item utilities.'},{'SETTING FARM','SettingFarm','Farming preferences.'},{'FARM','Farm','Farming functions and controls.'},{'ITEM & QUEST','ItemQuest','Items and quest utilities.'},{'ISLAND','Island','Island travel and navigation.'},{'FRUIT','Fruit','Fruit utilities and helpers.'},{'SETTING','Setting','FishHub settings and controls.'}}
local cards={}
local function notify(t)if type(context.ShowNotification)=='function' then pcall(context.ShowNotification,t)end end
local function load(k)
 if type(context.LoadFunction)=='function' then local ok,e=pcall(context.LoadFunction,k);if not ok then notify(tostring(e))end elseif type(context.Navigate)=='function' then pcall(context.Navigate,k) end
end
for i,m in ipairs(mods)do
 local b=N('TextButton',{Parent=holder,LayoutOrder=i,AutoButtonColor=false,Text='',BackgroundColor3=Color3.fromRGB(9,10,15),BorderSizePixel=0});C(b,13);local st=S(b,1,.65);local sc=N('UIScale',{Parent=b,Scale=1})
 local ind=N('Frame',{Parent=b,Position=UDim2.fromOffset(10,15),Size=UDim2.fromOffset(4,56),BackgroundColor3=accent(),BorderSizePixel=0});C(ind,4)
 local ico=N('TextLabel',{Parent=b,Position=UDim2.fromOffset(23,12),Size=UDim2.fromOffset(30,30),BackgroundColor3=Color3.fromRGB(18,20,30),BackgroundTransparency=.1,Text=string.sub(m[1],1,1),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=accent()});C(ico,9)
 N('TextLabel',{Parent=b,Position=UDim2.fromOffset(62,10),Size=UDim2.new(1,-72,0,20),BackgroundTransparency=1,Text=m[1],Font=Enum.Font.GothamBold,TextSize=9,TextColor3=Color3.fromRGB(240,242,248),TextXAlignment=Enum.TextXAlignment.Left})
 N('TextLabel',{Parent=b,Position=UDim2.fromOffset(62,32),Size=UDim2.new(1,-72,0,32),BackgroundTransparency=1,Text=m[3],Font=Enum.Font.GothamMedium,TextSize=8,TextColor3=Color3.fromRGB(112,117,132),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
 local che=N('TextLabel',{Parent=b,Position=UDim2.new(1,-27,1,-27),Size=UDim2.fromOffset(18,18),BackgroundTransparency=1,Text='›',Font=Enum.Font.GothamBold,TextSize=18,TextColor3=accent()})
 cards[#cards+1]={b=b,st=st,sc=sc,name=string.lower(m[1]),key=m[2]}
 b.MouseEnter:Connect(function()T(sc,.18,{Scale=1.025},Enum.EasingStyle.Back);T(st,.18,{Transparency=.05,Thickness=1.5})end)
 b.MouseLeave:Connect(function()T(sc,.18,{Scale=1});T(st,.18,{Transparency=.65,Thickness=1})end)
 b.Activated:Connect(function()load(m[2])end)
end
box:GetPropertyChangedSignal('Text'):Connect(function()local q=string.lower(box.Text);for _,c in ipairs(cards)do c.b.Visible=q=='' or string.find(c.name,q,1,true)~=nil end end)
-- Live theme refresh.
task.spawn(function()while root.Parent do local a=accent();bar.BackgroundColor3=a;icon.TextColor3=a;for _,c in ipairs(cards)do c.st.Color=a end;task.wait(.25)end end)
return {Root=root,SearchBox=box}
