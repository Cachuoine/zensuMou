local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}
local LocalPlayer = Players.LocalPlayer

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

-- Hàm tạo tiêu đề nhóm phân chia danh mục
local function createSectionHeader(titleText, layoutOrder)
    local header = New("TextLabel", {
        Parent = container,
        LayoutOrder = layoutOrder,
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "  " .. string.upper(titleText),
        Font = Enum.Font.GothamBlack,
        TextSize = 11,
        TextColor3 = accent(),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return header
end

-- Định nghĩa danh sách Boss Thường (Normal Boss)
local normalBosses = {
    {name = "STONE", markerPath = {"_WorldOrigin", "STONE Respawn Marker"}},
    {name = "HYDRA LEADER", markerPath = {"_WorldOrigin", "HYDRA LEADER Respawn Marker"}},
    {name = "Kilo Admiral", markerPath = {"_WorldOrigin", "KILO ADMIRAL Respawn Marker"}},
    {name = "Captain Elephant", markerPath = {"_WorldOrigin", "CAPTAIN ELEPHANT Respawn Marker"}},
    {name = "Beautiful Pirate", markerPath = {"_WorldOrigin", "BEAUTIFUL PIRATE Respawn Marker"}},
    {name = "Longma", markerPath = {"_WorldOrigin", "LONGMA Respawn Marker"}},
    {name = "Cake Queen", markerPath = {"_WorldOrigin", "CAKE QUEEN Respawn Marker"}},
}

-- Định nghĩa danh sách Boss Điều Kiện (Precious Boss) kèm CFrame teleport ẩn
local preciousBosses = {
    {name = "Soul Reaper", keywords = {"Soul Reaper", "SoulReaper"}, cframe = CFrame.new(-9522.2334, 314.747986, 6789.48193, 0.999388874, -0, -0.0349550731, 0, 1, -0, 0.0349550731, 0, 0.999388874)},
    {name = "Cake Prince", keywords = {"Cake Prince", "CakePrince"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {name = "Dough King", keywords = {"Dough King", "DoughKing", "Dough King [Raid Boss]"}, cframe = nil},
    {name = "Rip_Indra", keywords = {"rip_indra", "Rip Indra", "rip_indra True Form"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)},
    {name = "Tyrant of the Skies", keywords = {"Tyrant of the Skies", "Tyrant"}, cframe = nil},
}

createSectionHeader("• NORMAL BOSS", 1)

local cards = {}
local orderCounter = 2

-- Tạo card hiển thị cho Boss Thường
for _, boss in ipairs(normalBosses) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = orderCounter,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    orderCounter = orderCounter + 1
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
        Text = "TIME: Checking...",
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
        markerPath = boss.markerPath
    }
end

createSectionHeader("• PRECIOUS BOSS", orderCounter)
orderCounter = orderCounter + 1

-- Tạo card hiển thị cho Boss Điều Kiện
for _, boss in ipairs(preciousBosses) do
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = orderCounter,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    orderCounter = orderCounter + 1
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
        Text = "Status: False",
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
        keywords = boss.keywords,
        cframe = boss.cframe
    }
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

-- Vòng lặp cập nhật trạng thái Boss
task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        for name, data in pairs(cards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a

            if data.type == "normal" then
                -- Kiểm tra qua workspace._WorldOrigin cho Boss Thường
                local currentObj = Workspace
                for _, partName in ipairs(data.markerPath) do
                    if currentObj then
                        currentObj = currentObj:FindFirstChild(partName)
                    end
                end

                local timeText = "0"
                local isAlive = false

                if currentObj then
                    local timerFrame = currentObj:FindFirstChild("RespawnTimer")
                    if timerFrame then
                        local frame = timerFrame:FindFirstChild("Frame")
                        if frame then
                            local timerLabel = frame:FindFirstChild("Timer")
                            if timerLabel and timerLabel:IsA("TextLabel") then
                                timeText = timerLabel.Text
                            end
                        end
                    end
                end

                -- Nếu thời gian hiển thị trống hoặc bằng 0 hoặc hết giờ -> Boss đã xuất hiện (True)
                if timeText == "" or timeText == "0" or timeText == "00:00" or string.match(timeText, "Ready") then
                    isAlive = true
                    data.statusLabel.Text = name .. "->TIME: Alive (True)"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                else
                    isAlive = false
                    data.statusLabel.Text = name .. "->TIME: " .. timeText
                    data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                end

                if isAlive then
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                else
                    data.indicator.Text = "✕"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                end

            elseif data.type == "precious" then
                -- Kiểm tra Boss Điều Kiện qua workspace.Enemies kết hợp kiểm tra vị trí/teleport ẩn nếu có
                local found = false
                local enemiesFolder = Workspace:FindFirstChild("Enemies")

                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        for _, kw in ipairs(data.keywords) do
                            if string.find(string.lower(enemy.Name), string.lower(kw)) then
                                found = true
                                break
                            end
                        end
                        if found then break end
                    end
                end

                -- Thực hiện quét bằng cframe ẩn nếu có định nghĩa để kiểm tra vùng đảo xuất hiện mà không làm giật màn hình người chơi
                if not found and data.cframe and LocalPlayer and LocalPlayer.Character then
                    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        -- Lưu ý: Quá trình kiểm tra ẩn bằng cách so khớp khoảng cách gần vùng spawn hoặc check sự tồn tại trong bán kính
                        local distance = (rootPart.Position - data.cframe.Position).Magnitude
                        if distance < 1500 then
                            for _, obj in ipairs(Workspace:GetChildren()) do
                                for _, kw in ipairs(data.keywords) do
                                    if string.find(string.lower(obj.Name), string.lower(kw)) then
                                        found = true
                                        break
                                    end
                                end
                                if found then break end
                            end
                        end
                    end
                end

                if found then
                    data.indicator.Text = "✓"
                    data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    data.statusLabel.Text = "Status: True"
                    data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                else
                    data.indicator.Text = "✕"
                    data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    data.statusLabel.Text = "Status: False"
                    data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                end
            end
        end

        task.wait(2)
    end
end)

return {}
