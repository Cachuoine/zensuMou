local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

-- Hàm tạo tiêu đề phân mục (Category Header) theo yêu cầu
local function createCategoryHeader(text, layoutOrder)
    local header = New("TextLabel", {
        Parent = container,
        LayoutOrder = layoutOrder,
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = string.upper(text),
        Font = Enum.Font.GothamBlack,
        TextSize = 11,
        TextColor3 = accent(),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return header
end

-- Định nghĩa danh sách Boss Thường (Normal Boss) dựa trên workspace._WorldOrigin
local normalBosses = {
    {name = "STONE", markerName = "STONE Respawn Marker"},
    {name = "HYDRA LEADER", markerName = "HYDRA LEADER Respawn Marker"},
    {name = "Kilo Admiral", markerName = "KILO ADMIRAL Respawn Marker"},
    {name = "Captain Elephant", markerName = "CAPTAIN ELEPHANT Respawn Marker"},
    {name = "Beautiful Pirate", markerName = "BEAUTIFUL PIRATE Respawn Marker"},
    {name = "Longma", markerName = "LONGMA Respawn Marker"},
    {name = "Cake Queen", markerName = "CAKE QUEEN Respawn Marker"}
}

-- Định nghĩa danh sách Boss Điều Kiện (Precious Boss) dựa trên workspace.Enemies và CFrame
local preciousBosses = {
    {name = "Soul Reaper", cframe = CFrame.new(-9522.2334, 314.747986, 6789.48193, 0.999388874, -0, -0.0349550731, 0, 1, -0, 0.0349550731, 0, 0.999388874)},
    {name = "Cake Prince", cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {name = "Dough King", cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)}, -- Dùng chung khu vực đảo bánh
    {name = "Rip_Indra", cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)},
    {name = "Tyrant of the Skies", cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)}
}

createCategoryHeader("• NORMAL BOSS", 1)

local cards = {}
local orderCounter = 2

-- Tạo card cho Normal Boss
for _, boss in ipairs(normalBosses) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = orderCounter,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    }); orderCounter = orderCounter + 1
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -90, 0, 22),
        BackgroundTransparency = 1,
        Text = boss.name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 36),
        Size = UDim2.new(1, -90, 0, 16),
        BackgroundTransparency = 1,
        Text = "Status->True/False: Checking...",
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
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[boss.name] = {
        type = "normal",
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        markerName = boss.markerName,
        cachedTime = nil,
        lastTick = tick()
    }
end

createCategoryHeader("• PRECIOUS BOSS", orderCounter); orderCounter = orderCounter + 1

-- Tạo card cho Precious Boss
for _, boss in ipairs(preciousBosses) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = orderCounter,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    }); orderCounter = orderCounter + 1
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -90, 0, 22),
        BackgroundTransparency = 1,
        Text = boss.name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 36),
        Size = UDim2.new(1, -90, 0, 16),
        BackgroundTransparency = 1,
        Text = "False",
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
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    cards[boss.name] = {
        type = "precious",
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        cframe = boss.cframe
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Chú ý 1: Đợi người chơi vào thế giới hoàn tất mới bắt đầu quét
task.spawn(function()
    while not LocalPlayer or not LocalPlayer.Character or not Workspace:FindFirstChild("_WorldOrigin") do
        task.wait(1)
        if not alive then return end
    end

    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a
        
        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        local enemiesFolder = Workspace:FindFirstChild("Enemies")

        for name, data in pairs(cards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a

            if data.type == "normal" then
                -- Chú ý 2 (Normal Boss): Kiểm tra workspace._WorldOrigin thường xuyên
                local foundTimer = false
                if worldOrigin then
                    local marker = worldOrigin:FindFirstChild(data.markerName)
                    if marker then
                        local timerGui = marker:FindFirstChild("RespawnTimer")
                        if timerGui and timerGui:FindFirstChild("Frame") then
                            local timerTextLabel = timerGui.Frame:FindFirstChild("Timer")
                            if timerTextLabel and timerTextLabel:IsA("TextLabel") and timerTextLabel.Text ~= "" then
                                data.cachedTime = timerTextLabel.Text
                                foundTimer = true
                            end
                        end
                    end
                end

                if foundTimer then
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = "Status->True/False: True (" .. tostring(data.cachedTime) .. ")"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                else
                    -- Khi time không còn xuất hiện trong _WorldOrigin nữa, giữ lại cache thời gian tiếp tục chạy không dừng
                    if data.cachedTime then
                        data.indicator.Text = "✓"
                        data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                        data.statusLabel.Text = "Status->True/False: True (Respawning...)"
                        data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                    else
                        data.indicator.Text = "×"
                        data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                        data.statusLabel.Text = "Status->True/False: False"
                        data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                    end
                end

            elseif data.type == "precious" then
                -- Chú ý 2 (Precious Boss): Kiểm tra workspace.Enemies quét vô hạn mét từ tâm CFrame mỗi con boss
                local bossFound = false
                if enemiesFolder and data.cframe then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        if enemy.Name == name or string.find(enemy.Name, name) then
                            local humanoidRootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("RootPart")
                            if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
                                local dist = (humanoidRootPart.Position - data.cframe.Position).Magnitude
                                if dist <= 3500 then -- Quét bán kính rộng xung quanh tâm CFrame đảo tương ứng
                                    bossFound = true
                                    break
                                end
                            end
                        end
                    end
                end

                if bossFound then
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = "True"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                else
                    data.indicator.Text = "×"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    data.statusLabel.Text = "False"
                    data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                end
            end
        end

        task.wait(0.2)
    end
end)

return {}
