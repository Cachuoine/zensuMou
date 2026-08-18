--// FishHub Creative - clean redesign
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local context = ...
local player = (context and context.Player) or Players.LocalPlayer
if not player then return end
local playerGui = (context and context.PlayerGui) or player:WaitForChild("PlayerGui",10)
local tab = context and context.Tab
local main = context and context.MainWindow
if not tab then
    local fishHub = playerGui and playerGui:FindFirstChild("FishHub")
    local mainWindow = fishHub and fishHub:FindFirstChild("MainWindow")
    local content = mainWindow and mainWindow:FindFirstChild("ContentContainer")
    tab = content and content:FindFirstChild("CreativeTab",true)
    main = main or mainWindow
end
if not tab then return end
for _,child in ipairs(tab:GetChildren()) do child:Destroy() end

local FIXED_TEXT = Color3.fromRGB(244,246,250)
local FIXED_SUB = Color3.fromRGB(164,169,184)
local FIXED_MUTED = Color3.fromRGB(116,122,138)
local FIXED_CARD = Color3.fromRGB(35,38,48)
local FIXED_CARD2 = Color3.fromRGB(42,46,58)
local FIXED_BUTTON = Color3.fromRGB(62,67,82)
local FIXED_BUTTON_HOVER = Color3.fromRGB(73,79,96)

local function accent()
    local s = main and main:FindFirstChildOfClass("UIStroke")
    return (s and s.Color) or Color3.fromRGB(0,229,255)
end
local function corner(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=o end
local function text(parent,t,size,color,font)
    local x=Instance.new("TextLabel")
    x.BackgroundTransparency=1; x.Text=t; x.TextSize=size; x.TextColor3=color; x.Font=font or Enum.Font.GothamMedium; x.Parent=parent
    return x
end
local function addStroke(o,c,tr,th) local s=Instance.new("UIStroke"); s.Color=c; s.Transparency=tr or 0; s.Thickness=th or 1; s.Parent=o; return s end
local function notify(msg)
    local fn=context and context.ShowNotification
    if type(fn)=="function" then pcall(fn,msg) end
end
local function copy(s) pcall(function() if setclipboard then setclipboard(s) end end) end

local scroll=Instance.new("ScrollingFrame")
scroll.Size=UDim2.new(1,-8,1,-4); scroll.Position=UDim2.fromOffset(4,2); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=0; scroll.ScrollBarImageTransparency=1; scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=tab
local root=Instance.new("Frame"); root.Size=UDim2.new(1,-14,0,0); root.AutomaticSize=Enum.AutomaticSize.Y; root.BackgroundTransparency=1; root.Parent=scroll
local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,14); layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; layout.Parent=root

local themed={} 
local function section(titleText,height)
    local holder=Instance.new("Frame"); holder.Size=UDim2.new(1,0,0,height+48); holder.BackgroundTransparency=1; holder.Parent=root
    local title=text(holder,titleText,12,accent(),Enum.Font.GothamBold); title.Size=UDim2.new(0,240,0,20); title.Position=UDim2.new(.5,-120,0,0); title.TextXAlignment=Enum.TextXAlignment.Center
    local line=Instance.new("Frame"); line.Size=UDim2.new(1,-12,0,2); line.Position=UDim2.new(.5,0,0,28); line.AnchorPoint=Vector2.new(.5,0); line.BackgroundColor3=accent(); line.BorderSizePixel=0; line.Parent=holder
    local grad=Instance.new("UIGradient"); grad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.96),NumberSequenceKeypoint.new(.16,.72),NumberSequenceKeypoint.new(.35,.28),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.65,.28),NumberSequenceKeypoint.new(.84,.72),NumberSequenceKeypoint.new(1,.96)}); grad.Parent=line
    local card=Instance.new("Frame"); card.Size=UDim2.new(1,-4,0,height); card.Position=UDim2.new(.5,0,0,45); card.AnchorPoint=Vector2.new(.5,0); card.BackgroundColor3=FIXED_CARD; card.BackgroundTransparency=.02; card.BorderSizePixel=0; card.Parent=holder; corner(card,12); addStroke(card,Color3.fromRGB(72,77,92),.18,1)
    table.insert(themed,{title=title,line=line})
    return card
end
local function button(parent,txt,y,fn)
    local b=Instance.new("TextButton"); b.Size=UDim2.fromOffset(164,34); b.Position=UDim2.new(.5,0,0,y); b.AnchorPoint=Vector2.new(.5,0); b.BackgroundColor3=FIXED_BUTTON; b.BorderSizePixel=0; b.Text=txt; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.TextColor3=FIXED_TEXT; b.AutoButtonColor=false; b.Parent=parent; corner(b,8)
    local st=addStroke(b,Color3.fromRGB(92,97,112),.2,1)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.15),{BackgroundColor3=FIXED_BUTTON_HOVER}):Play(); TweenService:Create(st,TweenInfo.new(.15),{Transparency=0}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.15),{BackgroundColor3=FIXED_BUTTON}):Play(); TweenService:Create(st,TweenInfo.new(.15),{Transparency=.2}):Play() end)
    b.Activated:Connect(function() if fn then fn() end end)
    return b
end

-- Roblox Player
local roblox=section("ROBLOX PLAYER",128)
local targetName="thankhuyenhuynhuy"
local targetId
pcall(function() targetId=Players:GetUserIdFromNameAsync(targetName) end)
local avatar=Instance.new("ImageLabel"); avatar.Size=UDim2.fromOffset(62,62); avatar.Position=UDim2.new(.5,-125,0,22); avatar.BackgroundColor3=Color3.fromRGB(24,27,35); avatar.BorderSizePixel=0; avatar.ScaleType=Enum.ScaleType.Crop; avatar.Parent=roblox; corner(avatar,11)
if targetId then avatar.Image="rbxthumb://type=AvatarHeadShot&id="..tostring(targetId).."&w=150&h=150" end
local nm=text(roblox,targetName,16,FIXED_TEXT,Enum.Font.GothamBold); nm.Size=UDim2.fromOffset(180,23); nm.Position=UDim2.new(.5,-52,0,22); nm.TextXAlignment=Enum.TextXAlignment.Left
local un=text(roblox,"@"..targetName,10,FIXED_SUB,Enum.Font.GothamMedium); un.Size=UDim2.fromOffset(180,18); un.Position=UDim2.new(.5,-52,0,49); un.TextXAlignment=Enum.TextXAlignment.Left
local cap=text(roblox,"ROBLOX PLAYER PROFILE",8,FIXED_MUTED,Enum.Font.GothamBold); cap.Size=UDim2.fromOffset(180,16); cap.Position=UDim2.new(.5,-52,0,72); cap.TextXAlignment=Enum.TextXAlignment.Left

-- Discord
local dc=section("SERVER DISCORD",112)
local di=text(dc,"◈",24,FIXED_TEXT,Enum.Font.GothamBold); di.Size=UDim2.fromOffset(44,30); di.Position=UDim2.new(.5,-22,0,9); di.TextXAlignment=Enum.TextXAlignment.Center
local dsub=text(dc,"FishHub Community Server",10,FIXED_SUB,Enum.Font.GothamMedium); dsub.Size=UDim2.new(1,-24,0,18); dsub.Position=UDim2.fromOffset(12,43); dsub.TextXAlignment=Enum.TextXAlignment.Center
button(dc,"JOIN DISCORD",68,function() copy("https://discord.gg/zFN6Nd99fC"); notify("Discord invite copied!") end)

-- Facebook
local fb=section("FACEBOOK PLAYER",112)
local fi=text(fb,"f",26,FIXED_TEXT,Enum.Font.GothamBold); fi.Size=UDim2.fromOffset(44,32); fi.Position=UDim2.new(.5,-22,0,7); fi.TextXAlignment=Enum.TextXAlignment.Center
local fsub=text(fb,"Connect with the player",10,FIXED_SUB,Enum.Font.GothamMedium); fsub.Size=UDim2.new(1,-24,0,18); fsub.Position=UDim2.fromOffset(12,43); fsub.TextXAlignment=Enum.TextXAlignment.Center
button(fb,"ADD FACEBOOK",68,function() copy("https://www.facebook.com/dao.huy.lam.09/"); notify("Facebook profile link copied!") end)

task.spawn(function()
    while tab.Parent do
        local c=accent()
        for _,item in ipairs(themed) do
            if item.title.Parent then item.title.TextColor3=c end
            if item.line.Parent then item.line.BackgroundColor3=c end
        end
        task.wait(.05)
    end
end)

return true
