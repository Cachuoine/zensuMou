--// FishHub - Home.lua
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local Home = {}

local function clear(parent)
    for _, child in ipairs(parent:GetChildren()) do child:Destroy() end
end

local function formatNumber(value)
    value = tonumber(value) or 0
    local negative = value < 0
    value = math.abs(value)
    local s = tostring(math.floor(value))
    while true do
        local n, c = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = n
        if c == 0 then break end
    end
    return (negative and "-" or "") .. s
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

local function stroke(p, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1
    s.Transparency = transparency or 0
    s.Parent = p
end

local function divider(parent, title)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, -12, 0, 32)
    h.BackgroundTransparency = 1
    h.Parent = parent

    for _, x in ipairs({0.18, 0.82}) do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0.36, 0, 0, 1)
        line.Position = UDim2.new(x, 0, .5, 0)
        line.AnchorPoint = Vector2.new(.5, .5)
        line.BackgroundColor3 = Color3.fromRGB(100,100,115)
        line.BorderSizePixel = 0
        line.Parent = h

        local g = Instance.new("UIGradient")
        g.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),
            NumberSequenceKeypoint.new(.5,0),
            NumberSequenceKeypoint.new(1,1)
        })
        g.Parent = line
    end

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0,160,0,24)
    t.Position = UDim2.new(.5,0,.5,0)
    t.AnchorPoint = Vector2.new(.5,.5)
    t.BackgroundColor3 = Color3.fromRGB(5,5,8)
    t.Text = title
    t.TextColor3 = Color3.fromRGB(225,225,235)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 11
    t.Parent = h
    corner(t,5)
end

local function card(parent, height)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-12,0,height)
    f.BackgroundColor3 = Color3.fromRGB(5,5,8)
    f.BorderSizePixel = 0
    f.Parent = parent
    corner(f,9)
    stroke(f,Color3.fromRGB(55,55,68),.25)
    return f
end

function Home:Load(tabFrame, themeColor)
    if not tabFrame then return end
    clear(tabFrame)
    themeColor = themeColor or Color3.fromRGB(0,200,255)
    tabFrame.ScrollBarThickness = 0

    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,0,520)
    root.BackgroundTransparency = 1
    root.Parent = tabFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0,8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.Parent = root

    local welcome = card(root,72)
    local wt = Instance.new("TextLabel")
    wt.Size = UDim2.new(1,-20,0,28)
    wt.Position = UDim2.new(0,10,0,7)
    wt.BackgroundTransparency = 1
    wt.Text = "WELCOME, "..string.upper(LocalPlayer.DisplayName)
    wt.TextColor3 = themeColor
    wt.Font = Enum.Font.GothamBold
    wt.TextSize = 15
    wt.TextXAlignment = Enum.TextXAlignment.Left
    wt.Parent = welcome

    local gameName = "Roblox"
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info and info.Name then gameName = info.Name end
    end)

    local wi = Instance.new("TextLabel")
    wi.Size = UDim2.new(1,-20,0,22)
    wi.Position = UDim2.new(0,10,0,38)
    wi.BackgroundTransparency = 1
    wi.Text = "FishHub  •  "..gameName.."  •  @"..LocalPlayer.Name
    wi.TextColor3 = Color3.fromRGB(155,155,170)
    wi.Font = Enum.Font.GothamMedium
    wi.TextSize = 10
    wi.TextXAlignment = Enum.TextXAlignment.Left
    wi.Parent = welcome

    divider(root,"PLAYER STATUS")
    local status = card(root,154)
    local data = LocalPlayer:FindFirstChild("Data")

    local function get(name, fallback)
        local v = data and data:FindFirstChild(name)
        return v and v.Value or fallback
    end

    local stats = {
        {"LEVEL",get("Level",0)}, {"TEAM",LocalPlayer.Team and LocalPlayer.Team.Name or "None"},
        {"BOUNTY",get("Bounty",0)}, {"HONOR",get("Honor",0)},
        {"BELI",get("Beli",0)}, {"FRAGMENTS",get("Fragments",0)}
    }

    for i, item in ipairs(stats) do
        local col = ((i-1)%2)*.5+.02
        local row = math.floor((i-1)/2)
        local b = Instance.new("Frame")
        b.Size = UDim2.new(.46,0,0,36)
        b.Position = UDim2.new(col,0,0,10+row*42)
        b.BackgroundColor3 = Color3.fromRGB(16,16,21)
        b.BorderSizePixel = 0
        b.Parent = status
        corner(b,6)

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(.48,0,1,0)
        l.Position = UDim2.new(0,10,0,0)
        l.BackgroundTransparency = 1
        l.Text = item[1]
        l.TextColor3 = Color3.fromRGB(145,145,160)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = b

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(.48,-8,1,0)
        v.Position = UDim2.new(.48,0,0,0)
        v.BackgroundTransparency = 1
        v.Text = (item[1]=="TEAM") and tostring(item[2]) or formatNumber(item[2])
        v.TextColor3 = Color3.fromRGB(235,235,245)
        v.Font = Enum.Font.GothamBold
        v.TextSize = 10
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.Parent = b
    end

    divider(root,"INFORMATION")
    local info = card(root,126)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0,70,0,70)
    avatar.Position = UDim2.new(0,12,.5,0)
    avatar.AnchorPoint = Vector2.new(0,.5)
    avatar.BackgroundColor3 = Color3.fromRGB(20,20,26)
    avatar.BorderSizePixel = 0
    avatar.Parent = info
    corner(avatar,35)

    pcall(function()
        avatar.Image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    local executor = "Unknown"
    if identifyexecutor then pcall(function() executor = identifyexecutor() end) end

    local rows = {
        {"NAME",LocalPlayer.DisplayName},
        {"@NAME","@"..LocalPlayer.Name},
        {"USERID",LocalPlayer.UserId},
        {"EXECUTOR",executor}
    }

    for i,row in ipairs(rows) do
        local y = 8+(i-1)*25
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0,70,0,20)
        l.Position = UDim2.new(0,94,0,y)
        l.BackgroundTransparency = 1
        l.Text = row[1]
        l.TextColor3 = Color3.fromRGB(125,125,140)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = info

        local v = l:Clone()
        v.Position = UDim2.new(0,164,0,y)
        v.Size = UDim2.new(1,-174,0,20)
        v.Text = tostring(row[2])
        v.TextColor3 = Color3.fromRGB(230,230,240)
        v.Font = Enum.Font.GothamBold
        v.TextTruncate = Enum.TextTruncate.AtEnd
        v.Parent = info
    end
end

return Home
