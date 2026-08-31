local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
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
    {name = "Stone", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("STONE Respawn Marker"), keyword = "Stone"},
    {name = "Hydra Leader", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("HYDRA LEADER Respawn Marker"), keyword = "Hydra Leader"},
    {name = "Kilo Admiral", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("KILO ADMIRAL Respawn Marker"), keyword = "Kilo Admiral"},
    {name = "Captain Elephant", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("CAPTAIN ELEPHANT Respawn Marker"), keyword = "Captain Elephant"},
    {name = "Beautiful Pirate", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("BEAUTIFUL PIRATE Respawn Marker"), keyword = "Beautiful Pirate"},
    {name = "Longma", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("LONGMA Respawn Marker"), keyword = "Longma"},
    {name = "Cake Queen", type = "normal", path = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("CAKE QUEEN Respawn Marker"), keyword = "Cake Queen"},
    
    {name = "Soul Reaper", type = "precious", keyword = "Soul Reaper"},
    {name = "Cake Prince", type = "precious", keyword = "Cake Prince"},
    {name = "Dough King", type = "precious", keyword = "Dough King"},
    {name = "rip_indra True Form", type = "precious", keyword = "rip_indra"},
    {name = "Tyrant of the Skies", type = "precious", keyword = "Tyrant of the Skies"}
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
        
        local enemiesFolder = Workspace:FindFirstChild("Enemies")

        for name, info in pairs(cards) do
            info.stroke.Color = a
            info.badgeStroke.Color = a
            
            local isSpawned = false
            local detailText = "Status: False"

            -- ƯU TIÊN SỐ 1: Quét xem boss có thực sự đang nằm trong Workspace.Enemies hay không
            local inWorld = false
            if enemiesFolder and info.data.keyword then
                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    if string.find(enemy.Name, info.data.keyword) then
                        inWorld = true
                        break
                    end
                end
            end

            if inWorld then
                -- Nếu đã có trong thế giới -> Lập tức True, bất chấp đồng hồ ra sao
                isSpawned = true
                detailText = '<font color="rgb(80,255,120)">Status: True | [Đã xuất hiện trong thế giới]</font>'
            else
                -- Nếu chưa có trong thế giới, mới bắt đầu check đến đồng hồ (Respawn Marker)
                if info.data.type == "normal" then
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

                    if timerString and timerString ~= "" and timerString ~= "00:00" and not string.find(timerString, "-") then
                        isSpawned = false
                        detailText = 'Thời gian xuất hiện: <font color="rgb(255,150,50)">[' .. timerString .. ']</font>'
                    else
                        isSpawned = true
                        detailText = '<font color="rgb(80,255,120)">Trạng thái: True (Sẵn sàng)</font>'
                    end
                elseif info.data.type == "precious" then
                    isSpawned = false
                    detailText = '<font color="rgb(150,155,170)">Status: False [Chưa kích hoạt]</font>'
                end
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
