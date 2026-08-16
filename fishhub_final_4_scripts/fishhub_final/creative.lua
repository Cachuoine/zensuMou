local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
if not player then return end
local gui=player:WaitForChild("PlayerGui",10)
local hub=gui and gui:FindFirstChild("FishHub")
local tab=hub and hub:FindFirstChild("CreativeTab")
if not tab then return end

for _,child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ScrollBarThickness=0
tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
tab.CanvasSize=UDim2.new()

local function theme()
    local main=hub:FindFirstChild("MainWindow")
    local s=main and main:FindFirstChildOfClass("UIStroke")
    return s and s.Color or Color3.fromRGB(0,229,255)
end
local function corner(o,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r or 10)c.Parent=o end
local function stroke(o,t)local s=Instance.new("UIStroke")s.Color=theme()s.Thickness=1s.Transparency=t or .2s.Parent=o return s end

local root=Instance.new("Frame")root.Parent=tab root.Size=UDim2.new(1,-8,0,0)root.AutomaticSize=Enum.AutomaticSize.Y root.BackgroundTransparency=1
local list=Instance.new("UIListLayout")list.Parent=root list.Padding=UDim.new(0,12)list.HorizontalAlignment=Enum.HorizontalAlignment.Center

local function divider(title)
    local h=Instance.new("Frame")h.Parent=root h.Size=UDim2.new(1,-12,0,30)h.BackgroundTransparency=1
    local line=Instance.new("Frame")line.Parent=h line.Size=UDim2.new(1,0,0,2)line.Position=UDim2.new(0,0,0,15)
    line.BackgroundColor3=theme()line.BorderSizePixel=0 corner(line,2)
    local g=Instance.new("UIGradient")g.Parent=line g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.92),NumberSequenceKeypoint.new(.2,.55),NumberSequenceKeypoint.new(.4,.12),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.6,.12),NumberSequenceKeypoint.new(.8,.55),NumberSequenceKeypoint.new(1,.92)})
    local l=Instance.new("TextLabel")l.Parent=h l.Size=UDim2.new(1,0,0,22)l.Position=UDim2.new(0,0,0,-1)l.BackgroundTransparency=1
    l.Text=title l.Font=Enum.Font.GothamBold l.TextSize=12 l.TextColor3=theme()l.TextXAlignment=Enum.TextXAlignment.Center
end
local function card(height)
    local f=Instance.new("Frame")f.Parent=root f.Size=UDim2.new(1,-12,0,height)f.BackgroundColor3=Color3.fromRGB(7,8,12)f.BackgroundTransparency=.05 f.BorderSizePixel=0
    corner(f,11)stroke(f,.22)return f
end

divider("ROBLOX PLAYERS")
local roblox=card(118)
local avatar=Instance.new("ImageLabel")avatar.Parent=roblox avatar.Size=UDim2.new(0,78,0,78)avatar.Position=UDim2.new(0,14,.5,-39)
avatar.BackgroundColor3=Color3.fromRGB(17,18,24)avatar.BorderSizePixel=0avatar.ScaleType=Enum.ScaleType.Crop
avatar.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"corner(avatar,10)stroke(avatar,.25)
local name=Instance.new("TextLabel")name.Parent=roblox name.Size=UDim2.new(1,-112,0,24)name.Position=UDim2.new(0,104,0,28)
name.BackgroundTransparency=1 name.Text="thankhuyenhuy"name.Font=Enum.Font.GothamBold name.TextSize=14 name.TextColor3=Color3.fromRGB(240,240,245)name.TextXAlignment=Enum.TextXAlignment.Left
local tag=Instance.new("TextLabel")tag.Parent=roblox tag.Size=UDim2.new(1,-112,0,22)tag.Position=UDim2.new(0,104,0,54)
tag.BackgroundTransparency=1 tag.Text="@thankhuyenhuy"tag.Font=Enum.Font.GothamMedium tag.TextSize=10 tag.TextColor3=theme()tag.TextXAlignment=Enum.TextXAlignment.Left

divider("FACEBOOK PLAYERS")
local facebook=card(82)
local add=Instance.new("TextButton")add.Parent=facebook add.Size=UDim2.new(1,-20,0,42)add.Position=UDim2.new(0,10,.5,-21)
add.BackgroundColor3=theme()add.BackgroundTransparency=.08 add.BorderSizePixel=0 add.AutoButtonColor=false add.Text="+  ADD"
add.Font=Enum.Font.GothamBold add.TextSize=12 add.TextColor3=Color3.fromRGB(20,20,28)corner(add,8)local addStroke=stroke(add,.3)
add.MouseEnter:Connect(function()TweenService:Create(add,TweenInfo.new(.16),{BackgroundTransparency=0}):Play()end)
add.MouseLeave:Connect(function()TweenService:Create(add,TweenInfo.new(.16),{BackgroundTransparency=.08}):Play()end)
add.MouseButton1Click:Connect(function()
    local url="https://www.facebook.com/dao.huy.lam.09/"
    pcall(function() if setclipboard then setclipboard(url) end end)
    local notify=hub:FindFirstChild("NotificationContainer")
    if notify and notify:IsA("Frame") then end
end)

task.spawn(function()
    while tab.Parent and root.Parent do
        local c=theme()
        tag.TextColor3=c add.BackgroundColor3=c addStroke.Color=c
        for _,o in ipairs(root:GetDescendants()) do if o:IsA("UIStroke") then o.Color=c end end
        task.wait(.45)
    end
end)
