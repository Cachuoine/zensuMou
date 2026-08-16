--// FishHub - Creative.lua
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Creative={}

local FACEBOOK_URL="https://www.facebook.com/dao.huy.lam.09/"

local function clear(p)
    for _,c in ipairs(p:GetChildren()) do c:Destroy() end
end

local function corner(p,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=p
end

local function stroke(p,color)
    local s=Instance.new("UIStroke")
    s.Color=color
    s.Thickness=1
    s.Transparency=.25
    s.Parent=p
end

local function divider(parent,title)
    local h=Instance.new("Frame")
    h.Size=UDim2.new(1,-12,0,32)
    h.BackgroundTransparency=1
    h.Parent=parent

    for _,x in ipairs({.18,.82}) do
        local line=Instance.new("Frame")
        line.Size=UDim2.new(.36,0,0,1)
        line.Position=UDim2.new(x,0,.5,0)
        line.AnchorPoint=Vector2.new(.5,.5)
        line.BackgroundColor3=Color3.fromRGB(100,100,115)
        line.BorderSizePixel=0
        line.Parent=h

        local g=Instance.new("UIGradient")
        g.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),
            NumberSequenceKeypoint.new(.5,0),
            NumberSequenceKeypoint.new(1,1)
        })
        g.Parent=line
    end

    local t=Instance.new("TextLabel")
    t.Size=UDim2.new(0,160,0,24)
    t.Position=UDim2.new(.5,0,.5,0)
    t.AnchorPoint=Vector2.new(.5,.5)
    t.BackgroundColor3=Color3.fromRGB(5,5,8)
    t.Text=title
    t.TextColor3=Color3.fromRGB(225,225,235)
    t.Font=Enum.Font.GothamBold
    t.TextSize=11
    t.Parent=h
    corner(t,5)
end

function Creative:Load(tabFrame,themeColor)
    if not tabFrame then return end
    clear(tabFrame)
    themeColor=themeColor or Color3.fromRGB(0,200,255)

    local root=Instance.new("Frame")
    root.Size=UDim2.new(1,0,0,330)
    root.BackgroundTransparency=1
    root.Parent=tabFrame

    local list=Instance.new("UIListLayout")
    list.Padding=UDim.new(0,8)
    list.HorizontalAlignment=Enum.HorizontalAlignment.Center
    list.Parent=root

    divider(root,"ROBLOX PLAYERS")

    local roblox=Instance.new("Frame")
    roblox.Size=UDim2.new(1,-12,0,105)
    roblox.BackgroundColor3=Color3.fromRGB(5,5,8)
    roblox.BorderSizePixel=0
    roblox.Parent=root
    corner(roblox,9)
    stroke(roblox,themeColor)

    local avatar=Instance.new("ImageLabel")
    avatar.Size=UDim2.new(0,64,0,64)
    avatar.Position=UDim2.new(0,12,.5,0)
    avatar.AnchorPoint=Vector2.new(0,.5)
    avatar.BackgroundColor3=Color3.fromRGB(20,20,26)
    avatar.BorderSizePixel=0
    avatar.Parent=roblox
    corner(avatar,32)

    pcall(function()
        avatar.Image=Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    local n=Instance.new("TextLabel")
    n.Size=UDim2.new(1,-100,0,25)
    n.Position=UDim2.new(0,90,0,25)
    n.BackgroundTransparency=1
    n.Text="thankhuyenhuy"
    n.TextColor3=Color3.fromRGB(235,235,245)
    n.Font=Enum.Font.GothamBold
    n.TextSize=13
    n.TextXAlignment=Enum.TextXAlignment.Left
    n.Parent=roblox

    local u=n:Clone()
    u.Position=UDim2.new(0,90,0,52)
    u.Text="@thankhuyenhuy"
    u.TextColor3=themeColor
    u.Font=Enum.Font.GothamMedium
    u.TextSize=10
    u.Parent=roblox

    divider(root,"FACEBOOK PLAYERS")

    local facebook=Instance.new("Frame")
    facebook.Size=UDim2.new(1,-12,0,100)
    facebook.BackgroundColor3=Color3.fromRGB(5,5,8)
    facebook.BorderSizePixel=0
    facebook.Parent=root
    corner(facebook,9)
    stroke(facebook,themeColor)

    local add=Instance.new("TextButton")
    add.Size=UDim2.new(1,-20,0,42)
    add.Position=UDim2.new(0,10,0,29)
    add.BackgroundColor3=themeColor
    add.BorderSizePixel=0
    add.AutoButtonColor=false
    add.Text="ADD"
    add.TextColor3=Color3.fromRGB(10,10,14)
    add.Font=Enum.Font.GothamBold
    add.TextSize=12
    add.Parent=facebook
    corner(add,7)

    add.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then setclipboard(FACEBOOK_URL) end
        end)
        pcall(function()
            if syn and syn.request then
                syn.request({Url=FACEBOOK_URL,Method="GET"})
            end
        end)
    end)
end

return Creative
