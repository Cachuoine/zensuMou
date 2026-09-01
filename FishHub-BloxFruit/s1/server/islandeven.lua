local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

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

-- Danh sách Boss Thường & Boss Điều Kiện đi kèm CFrame và thông tin quét phạm vi 900m
local bossList = {
    -- Normal Boss (name, type, cframe, markerName)
    {name = "STONE", kind = "normal", cframe = Vector3.new(-1109.92603, 58.3789978, 6811.7251), marker = "STONE Respawn Marker"},
    {name = "HYDRA LEADER", kind = "normal", cframe = Vector3.new(-1109.92603, 58.3789978, 6811.7251), marker = "HYDRA LEADER Respawn Marker"},
    {name = "Kilo Admiral", kind = "normal", cframe = Vector3.new(2998.29492, 513.794006, -7344.32178), marker = "KILO ADMIRAL Respawn Marker"},
    {name = "Captain Elephant", kind = "normal", cframe = Vector3.new(-13365.5293, 321.230988, -8484.99023), marker = "CAPTAIN ELEPHANT Respawn Marker"},
    {name = "Beautiful Pirate", kind = "normal", cframe = Vector3.new(5367.31348, 26.3950043, -64.7008362), marker = "BEAUTIFUL PIRATE Respawn Marker"},
    {name = "Longma", kind = "normal", cframe = Vector3.new(-10156.2227, 337.778015, -9445.86523), marker = "LONGMA Respawn Marker"},
    {name = "Cake Queen", kind = "normal", cframe = Vector3.new(-678.478027, 386.856995, -11114.3457), marker = "CAKE QUEEN Respawn Marker"},

    -- Precious Boss / Boss điều kiện True/False (name, kind, cframe)
    {name = "Soul Reaper", kind = "precious", cframe = Vector3.new(-9522.2334, 314.747986, 6789.48193)},
    {name = "Cake Prince", kind = "precious", cframe = Vector3.new(-2089.86597, 4536.92383, -14800.0068)},
    {name = "Dough King", kind = "precious", cframe = Vector3.new(-2089.86597, 4536.92383, -14800.0068)}, -- Vùng Đảo Bánh/Dough King
    {name = "Rip_Indra", kind = "precious", cframe = Vector3.new(-5395.71582, 319.981995, -2588.76001)},
    {name = "Tyrant of the Skies", kind = "precious", cframe = Vector3.new(-5395.71582, 319.981995, -2588.76001)}
}

local cards = {}

for i, boss in ipairs(bossList) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = i,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    -- Hiển thị phân loại Normal/Precious ở trên đầu dấu chấm
    local prefixLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 6),
        Size = UDim2.new(1, -90, 0, 14),
        BackgroundTransparency = 1,
        Text = string.upper(boss.kind) .. " BOSS",
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextColor3 = boss.kind == "normal" and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(255, 170, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local nameLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 20),
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
        Position = UDim2.fromOffset(15, 40),
        Size = UDim2.new(1, -90, 0, 16),
        BackgroundTransparency = 1,
        Text = "Checking...",
        Font = Enum.Font.Gotham,
        TextSize = 10,
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
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[boss.name] = {
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        data = boss
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

        local player = Players.LocalPlayer
        local character = player and player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        for _, data in pairs(cards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a

            local bossInfo = data.data
            local inRange = false

            -- Kiểm tra phạm vi quét bán kính 900m từ vị trí người chơi đến CFrame của boss
            if rootPart then
                local distance = (rootPart.Position - bossInfo.cframe).Magnitude
                if distance <= 900 then
                    inRange = true
                end
            end

            if not inRange then
                data.indicator.Text = "i"
                data.indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
                data.statusLabel.Text = "Out of 900m Range"
                data.statusLabel.TextColor3 = Color3.fromRGB(120, 125, 140)
            else
                if bossInfo.kind == "normal" then
                    -- Quét boss thường qua workspace._WorldOrigin và lấy RespawnTimer
                    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
                    local marker = worldOrigin and worldOrigin:FindFirstChild(bossInfo.marker)
                    local timerFrame = marker and marker:FindFirstChild("RespawnTimer") and marker.RespawnTimer:FindFirstChild("Frame") and marker.RespawnTimer.Frame:FindFirstChild("Timer")
                    
                    if timerFrame and timerFrame:IsA("TextLabel") and timerFrame.Text ~= "" and timerFrame.Text ~= "0" then
                        data.indicator.Text = "⏱"
                        data.indicator.TextColor3 = Color3.fromRGB(255, 200, 80)
                        data.statusLabel.Text = bossInfo.name .. " -> TIME: " .. timerFrame.Text
                        data.statusLabel.TextColor3 = Color3.fromRGB(255, 220, 150)
                    else
                        -- Hết thời gian chờ (True/False theo mẫu chuẩn islandevent)
                        data.indicator.Text = "✓"
                        data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                        data.statusLabel.Text = "Status: True (Spawned/Ready)"
                        data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                    end
                else
                    -- Quét boss điều kiện (precious boss) qua workspace.Enemies
                    local enemiesFolder = Workspace:FindFirstChild("Enemies")
                    local foundBoss = false
                    if enemiesFolder then
                        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                            if string.find(enemy.Name, bossInfo.name) then
                                foundBoss = true
                                break
                            end
                        end
                    end

                    if foundBoss then
                        data.indicator.Text = "✓"
                        data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                        data.statusLabel.Text = "Status: True (Found)"
                        data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                    else
                        data.indicator.Text = "×"
                        data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                        data.statusLabel.Text = "Status: False"
                        data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                    end
                end
            end
        end

        task.wait(0.1)
    end
end)

return {}
