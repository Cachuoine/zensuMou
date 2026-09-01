local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    if Config.Rainbow or Config.RainbowMode then
        return Color3.fromHSV((tick() % 5) / 5, 1, 1)
    end
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius)
    })
end

local function Stroke(parent, thickness, transparency)
    return New("UIStroke", {
        Parent = parent,
        Color = accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0

local container = New("ScrollingFrame", {
    Parent = Tab,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = accent()
})

New("UIPadding", {
    Parent = container,
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 15),
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 5)
})

New("UIListLayout", {
    Parent = container,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

local bossDataList = {
    {name = "STONE", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("STONE Respawn Marker")},
    {name = "HYDRA LEADER", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("HYDRA LEADER Respawn Marker")},
    {name = "Kilo Admiral", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("KILO ADMIRAL Respawn Marker")},
    {name = "Captain Elephant", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("CAPTAIN ELEPHANT Respawn Marker")},
    {name = "Beautiful Pirate", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("BEAUTIFUL PIRATE Respawn Marker")},
    {name = "Longma", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("LONGMA Respawn Marker")},
    {name = "Cake Queen", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("CAKE QUEEN Respawn Marker")}
}

local cards = {}

for i, boss in ipairs(bossDataList) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 10),
        Size = UDim2.new(1, -90, 0, 20),
        BackgroundTransparency = 1,
        Text = boss.name,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 33),
        Size = UDim2.new(1, -90, 0, 18),
        BackgroundTransparency = 1,
        RichText = true,
        Text = "Checking...",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local badge = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = Color3.fromRGB(22, 25, 37),
        BorderSizePixel = 0
    })
    Corner(badge, 8)
    local badgeStroke = Stroke(badge, 1, 0.4)

    local indicator = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[boss.name] = {
        data = boss,
        stroke = stroke,
        statusLabel = statusLabel,
        badgeStroke = badgeStroke,
        indicator = indicator
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        for _, info in pairs(cards) do
            info.stroke.Color = a
            info.badgeStroke.Color = a
            
            local marker = info.data.path
            local timerString = ""
            
            if marker then
                local timerGui = marker:FindFirstChild("RespawnTimer")
                if timerGui then
                    local frame = timerGui:FindFirstChild("Frame")
                    if frame then
                        local timerLabel = frame:FindFirstChild("Timer")
                        if timerLabel and timerLabel:IsA("TextLabel") then
                            timerString = timerLabel.Text
                        end
                    end
                end
            end

            local isSpawned = false
            local detailText = ""

            -- Kiểm tra giá trị chuỗi của Timer
            if timerString ~= "" and timerString ~= "00:00" and not string.find(timerString, "-") then
                isSpawned = false
                detailText = info.data.name .. '->TIME: <font color="rgb(255,150,50)">[' .. timerString .. ']</font>'
            else
                isSpawned = true
                detailText = '<font color="rgb(80,255,120)">Status: True | [Đã xuất hiện]</font>'
            end

            if isSpawned then
                info.indicator.Text = "✓"
                info.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                info.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
            else
                info.indicator.Text = "✕"
                info.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                info.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
            
            info.statusLabel.Text = detailText
        end

        task.wait(1)
    end
end)

return {}
