local context = ...
if type(context) ~= "table" then return end

local Players = context.Players
local Player = context.Player
local Tab = context.Tab
local TweenService = context.TweenService
local Config = context.Config or {}
local GetAccent = context.GetCurrentAccentColor or function() return Config.ThemeColor or Color3.fromRGB(0,229,255) end
local ShowNotification = context.ShowNotification or function() end

local root = Instance.new("Frame")
root.Name="HomeContent"
root.Parent=Tab
root.Size=UDim2.fromScale(1,1)
root.BackgroundTransparency=1

local function card(parent,size,pos)
    local f=Instance.new("Frame")
    f.Parent=parent
    f.Size=size
    f.Position=pos
    f.BackgroundColor3=Color3.fromRGB(30,32,42)
    f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)
    local s=Instance.new("UIStroke",f)
    s.Thickness=1
    s.Color=GetAccent()
    return f,s
end

local info,infoStroke=card(root,UDim2.new(0.48,-5,0,118),UDim2.new(0,2,0,5))
local avatar=Instance.new("ImageLabel")
avatar.Parent=info
avatar.Size=UDim2.new(0,76,0,76)
avatar.Position=UDim2.new(0,16,0,21)
avatar.BackgroundTransparency=1
avatar.Image="rbxasset://textures/ui/GuiImagePlaceholder.png"
Instance.new("UICorner",avatar).CornerRadius=UDim.new(1,0)

local name=Instance.new("TextLabel")
name.Parent=info
name.Size=UDim2.new(1,-108,0,24)
name.Position=UDim2.new(0,106,0,24)
name.BackgroundTransparency=1
name.Text=Player and Player.DisplayName or "Player"
name.Font=Enum.Font.GothamBold
name.TextSize=14
name.TextColor3=Color3.fromRGB(242,244,250)
name.TextXAlignment=Enum.TextXAlignment.Left

local handle=Instance.new("TextLabel")
handle.Parent=info
handle.Size=UDim2.new(1,-108,0,18)
handle.Position=UDim2.new(0,106,0,50)
handle.BackgroundTransparency=1
handle.Text="@"..(Player and Player.Name or "unknown")
handle.Font=Enum.Font.Code
handle.TextSize=10
handle.TextColor3=Color3.fromRGB(150,155,170)
handle.TextXAlignment=Enum.TextXAlignment.Left

local userid=Instance.new("TextLabel")
userid.Parent=info
userid.Size=UDim2.new(1,-108,0,18)
userid.Position=UDim2.new(0,106,0,72)
userid.BackgroundTransparency=1
userid.Text="USER ID  "..tostring(Player and Player.UserId or 0)
userid.Font=Enum.Font.Code
userid.TextSize=9
userid.TextColor3=GetAccent()
userid.TextXAlignment=Enum.TextXAlignment.Left

local status,statusStroke=card(root,UDim2.new(0.52,-5,0,118),UDim2.new(0.52,3,0,5))
local st=Instance.new("TextLabel")
st.Parent=status
st.Size=UDim2.new(1,-24,0,22)
st.Position=UDim2.new(0,12,0,14)
st.BackgroundTransparency=1
st.Text="PLAYER STATUS"
st.Font=Enum.Font.GothamBold
st.TextSize=11
st.TextColor3=GetAccent()
st.TextXAlignment=Enum.TextXAlignment.Left

local details=Instance.new("TextLabel")
details.Parent=status
details.Size=UDim2.new(1,-24,0,64)
details.Position=UDim2.new(0,12,0,39)
details.BackgroundTransparency=1
details.Text="Level     "..tostring(Player and Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Level") and Player.Data.Level.Value or "--").."\nPlaceId   "..tostring(game.PlaceId).."\nExecutor   FishHub"
details.Font=Enum.Font.Code
details.TextSize=10
details.TextColor3=Color3.fromRGB(190,194,205)
details.TextXAlignment=Enum.TextXAlignment.Left
details.TextYAlignment=Enum.TextYAlignment.Top

local line=Instance.new("Frame")
line.Parent=root
line.Size=UDim2.new(1,-8,0,1)
line.Position=UDim2.new(0,4,0,136)
line.BackgroundColor3=GetAccent()
line.BorderSizePixel=0

local ready=Instance.new("TextLabel")
ready.Parent=root
ready.Size=UDim2.new(1,-8,0,26)
ready.Position=UDim2.new(0,4,0,145)
ready.BackgroundTransparency=1
ready.Text="READY TO EXPERIENCE YOUR CONTROL PANEL"
ready.Font=Enum.Font.GothamBold
ready.TextSize=10
ready.TextColor3=Color3.fromRGB(145,150,165)
ready.TextXAlignment=Enum.TextXAlignment.Center

task.spawn(function()
    local ok,content=pcall(function()
        return Players:GetUserThumbnailAsync(Player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    end)
    if ok and content then avatar.Image=content end
end)

task.spawn(function()
    while root and root.Parent do
        local c=GetAccent()
        infoStroke.Color=c
        statusStroke.Color=c
        userid.TextColor3=c
        st.TextColor3=c
        line.BackgroundColor3=c
        task.wait(.12)
    end
end)

return {Destroy=function() if root and root.Parent then root:Destroy() end end}
