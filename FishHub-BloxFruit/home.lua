-- FishHub | Home.lua
-- Context-compatible Home tab. The large decorative bubble/orb is intentionally absent.
local context = ...
context = type(context) == "table" and context or {}

local Players = context.Players or game:GetService("Players")
local TweenService = context.TweenService or game:GetService("TweenService")
local Player = context.Player or Players.LocalPlayer
local Tab = context.Tab
local Config = context.Config or {ThemeColor = Color3.fromRGB(0,229,255)}
if not Tab or not Player then return end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end
Tab.CanvasSize = UDim2.new(0,0,0,0)
Tab.ScrollBarThickness = 0
Tab.BackgroundTransparency = 1

local function statValue(names, default)
    local leaderstats = Player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, name in ipairs(names) do
            local v = leaderstats:FindFirstChild(name)
            if v then return tostring(v.Value) end
        end
    end
    for _, name in ipairs(names) do
        local v = Player:FindFirstChild(name)
        if v then return tostring(v.Value) end
    end
    return default or "0"
end

local function card(parent, size, pos, radius)
    local f = Instance.new("Frame")
    f.Parent = parent
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = Color3.fromRGB(15,19,27)
    f.BackgroundTransparency = 0.05
    f.BorderSizePixel = 0
    local c = Instance.new("UICorner", f)
    c.CornerRadius = UDim.new(0, radius or 12)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = Config.ThemeColor
    stroke.Thickness = 1
    stroke.Transparency = 0.62
    return f
end

local function label(parent, text, size, pos, font, textSize, color)
    local l = Instance.new("TextLabel")
    l.Parent = parent
    l.Size = size
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = font or Enum.Font.GothamMedium
    l.TextSize = textSize or 11
    l.TextColor3 = color or Color3.fromRGB(225,229,238)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    return l
end

local root = Instance.new("Frame")
root.Name = "HomeContent"
root.Parent = Tab
root.Size = UDim2.new(1, -24, 0, 355)
root.Position = UDim2.new(0, 12, 0, 10)
root.BackgroundTransparency = 1

local title = label(root, "READY TO EXPERIENCE YOUR CONTROL PANEL", UDim2.new(1,0,0,24), UDim2.new(0,0,0,0), Enum.Font.GothamBold, 15, Color3.fromRGB(242,244,250))
title.TextXAlignment = Enum.TextXAlignment.Center
local sub = label(root, "PLAYER OVERVIEW  •  LIVE SESSION", UDim2.new(1,0,0,18), UDim2.new(0,0,0,25), Enum.Font.Code, 9, Color3.fromRGB(135,141,156))
sub.TextXAlignment = Enum.TextXAlignment.Center

local line = Instance.new("Frame")
line.Parent = root
line.Size = UDim2.new(0.88,0,0,1)
line.Position = UDim2.new(0.06,0,0,54)
line.BackgroundColor3 = Config.ThemeColor
line.BackgroundTransparency = 0.2
line.BorderSizePixel = 0
Instance.new("UICorner",line).CornerRadius = UDim.new(1,0)

local info = card(root, UDim2.new(1,0,0,94), UDim2.new(0,0,0,68), 13)
local avatar = Instance.new("ImageLabel")
avatar.Parent = info
avatar.Size = UDim2.fromOffset(64,64)
avatar.Position = UDim2.new(0,14,0.5,-32)
avatar.BackgroundColor3 = Color3.fromRGB(27,32,43)
avatar.BorderSizePixel = 0
avatar.ImageTransparency = 0
Instance.new("UICorner",avatar).CornerRadius = UDim.new(1,0)
local avStroke = Instance.new("UIStroke",avatar)
avStroke.Color = Config.ThemeColor
avStroke.Thickness = 1.2
pcall(function()
    local image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    avatar.Image = image
end)
label(info, Player.DisplayName, UDim2.new(1,-100,0,22), UDim2.new(0,92,0,17), Enum.Font.GothamBold, 14, Color3.fromRGB(245,247,255))
label(info, "@" .. Player.Name, UDim2.new(1,-100,0,18), UDim2.new(0,92,0,39), Enum.Font.Code, 9, Color3.fromRGB(145,151,166))
label(info, "USERID  " .. tostring(Player.UserId), UDim2.new(0.42,0,0,18), UDim2.new(0,92,0,60), Enum.Font.Code, 8, Color3.fromRGB(125,131,146))
label(info, "EXECUTOR  CLIENT", UDim2.new(0.42,0,0,18), UDim2.new(0.52,0,0,60), Enum.Font.Code, 8, Config.ThemeColor)

local statusTitle = label(root, "PLAYER STATUS", UDim2.new(1,0,0,20), UDim2.new(0,0,0,174), Enum.Font.GothamBold, 11, Color3.fromRGB(235,238,247))
statusTitle.TextXAlignment = Enum.TextXAlignment.Center
local statusLine = Instance.new("Frame")
statusLine.Parent = root
statusLine.Size = UDim2.new(0.82,0,0,1)
statusLine.Position = UDim2.new(0.09,0,0,198)
statusLine.BackgroundColor3 = Config.ThemeColor
statusLine.BackgroundTransparency = 0.55
statusLine.BorderSizePixel = 0
Instance.new("UICorner",statusLine).CornerRadius = UDim.new(1,0)

local status = card(root, UDim2.new(1,0,0,135), UDim2.new(0,0,0,211), 13)
local team = Player.Team and Player.Team.Name or "Unknown"
local values = {
    {"LEVEL", statValue({"Level","Lvl"}, "0")},
    {"TEAM", team},
    {"BELI", statValue({"Beli","Money"}, "0")},
    {"FRAGMENTS", statValue({"Fragments","Fragment"}, "0")},
    {"BOUNTY", statValue({"Bounty","Bounty/Honor"}, "0")},
    {"HONOR", statValue({"Honor"}, "0")},
}
for i, item in ipairs(values) do
    local col = (i-1) % 3
    local row = math.floor((i-1) / 3)
    local x = 12 + col * 33.333
    local w = 31.2
    local cell = Instance.new("Frame")
    cell.Parent = status
    cell.Size = UDim2.new(w/100,0,0,52)
    cell.Position = UDim2.new(x/100,0,0,row*62 + 8)
    cell.BackgroundTransparency = 1
    label(cell, item[1], UDim2.new(1,0,0,18), UDim2.new(0,0,0,0), Enum.Font.Code, 8, Color3.fromRGB(125,131,146)).TextXAlignment = Enum.TextXAlignment.Center
    local val = label(cell, item[2], UDim2.new(1,0,0,25), UDim2.new(0,0,0,19), Enum.Font.GothamBold, 11, i == 2 and Config.ThemeColor or Color3.fromRGB(232,235,244))
    val.TextXAlignment = Enum.TextXAlignment.Center
end

local function refresh()
    local newTeam = Player.Team and Player.Team.Name or "Unknown"
    -- Rebuild only the small status values; layout remains unchanged.
    for _, child in ipairs(status:GetChildren()) do
        if child:IsA("Frame") then
            local valueLabel = child:FindFirstChildWhichIsA("TextLabel")
            local valueLabels = child:GetChildren()
            if #valueLabels >= 2 then
                local v = valueLabels[#valueLabels]
                if v:IsA("TextLabel") then
                    local index = math.floor((child.AbsolutePosition.Y - status.AbsolutePosition.Y - 8) / 62) * 3 + math.floor((child.AbsolutePosition.X - status.AbsolutePosition.X - 12) / math.max(1,status.AbsoluteSize.X/3)) + 1
                    local item = values[index]
                    if item then v.Text = index == 2 and newTeam or statValue(({ {"Level","Lvl"},{"Team"},{"Beli","Money"},{"Fragments","Fragment"},{"Bounty","Bounty/Honor"},{"Honor"} })[index] or {}, v.Text) end
                end
            end
        end
    end
end

Player:GetPropertyChangedSignal("Team"):Connect(refresh)

-- Keep the tab clean: no decorative orb/bubble is created anywhere in this file.
Tab.CanvasSize = UDim2.new(0,0,0,365)
