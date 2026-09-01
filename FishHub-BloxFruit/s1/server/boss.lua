local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}
local localPlayer = Players.LocalPlayer

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

-- Danh sách Normal Boss và Precious Boss
local bossList = {
    -- Normal Boss (Có thời gian Timer + Tên Boss->True/False)
    {type = "normal", name = "Stone", markerName = "STONE Respawn Marker", cframe = CFrame.new(-1109.92603, 58.3789978, 6811.7251, 0.275688112, -0, -0.961247265, 0, 1, -0, 0.961247265, 0, 0.275688112)},
    {type = "normal", name = "Hydra Leader", markerName = "HYDRA LEADER Respawn Marker", cframe = CFrame.new(-1109.92603, 58.3789978, 6811.7251, 0.275688112, -0, -0.961247265, 0, 1, -0, 0.961247265, 0, 0.275688112)},
    {type = "normal", name = "Kilo Admiral", markerName = "KILO ADMIRAL Respawn Marker", cframe = CFrame.new(2998.29492, 513.794006, -7344.32178, 0.207885921, 0, 0.97815311, 0, 1, 0, -0.97815311, 0, 0.207885921)},
    {type = "normal", name = "Captain Elephant", markerName = "CAPTAIN ELEPHANT Respawn Marker", cframe = CFrame.new(-13365.5293, 321.230988, -8484.99023, -0.997842431, 0, 0.0656556115, 0, 1, 0, -0.0656556115, 0, -0.997842431)},
    {type = "normal", name = "Beautiful Pirate", markerName = "BEAUTIFUL PIRATE Respawn Marker", cframe = CFrame.new(5367.31348, 26.3950043, -64.7008362, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
    {type = "normal", name = "Longma", markerName = "LONGMA Respawn Marker", cframe = CFrame.new(-10156.2227, 337.778015, -9445.86523, -0.0348494053, 0, 0.999392569, 0, 1, 0, -0.999392569, 0, -0.0348494053)},
    {type = "normal", name = "Cake Queen", markerName = "CAKE QUEEN Respawn Marker", cframe = CFrame.new(-678.478027, 386.856995, -11114.3457, -0.93524456, 0, 0.354002535, 0, 1, 0, -0.354002535, 0, -0.93524456)},
    
    -- Precious Boss / Boss điều kiện (True/False xuất hiện hay không dựa trên workspace.Enemies)
    {type = "precious", name = "Soul Reaper", keywords = {"Soul Reaper"}, cframe = CFrame.new(-9522.2334, 314.747986, 6789.48193, 0.999388874, -0, -0.0349550731, 0, 1, -0, 0.0349550731, 0, 0.999388874)},
    {type = "precious", name = "Cake Prince", keywords = {"Cake Prince"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068, 0.868320882, -0, -0.496002853, 0, 1, -0, 0.496002853, 0, 0.868320882)},
    {type = "precious", name = "Dough King", keywords = {"Dough King"}, cframe = CFrame.new(-2089.86597, 4536.92383, -14800.0068)}, -- Cùng khu vực đảo bánh
    {type = "precious", name = "Rip_Indra", keywords = {"rip_indra", "Rip Indra"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)},
    {type = "precious", name = "Tyrant of the Skies", keywords = {"Tyrant of the Skies"}, cframe = CFrame.new(-5395.71582, 319.981995, -2588.76001)}
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

    -- Hiển thị tiêu đề kèm phân loại Normal / Precious Boss ở phía trên đầu
    local categoryPrefix = boss.type == "normal" and "[Normal Boss] " or "[Precious Boss] "
    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 10),
        Size = UDim2.new(1, -90, 0, 20),
        BackgroundTransparency = 1,
        Text = categoryPrefix .. boss.name,
        Font = Enum.Font.GothamBold,
        TextSize: 12,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 33),
        Size = UDim2.new(1, -90, 0, 18),
        BackgroundTransparency = 1,
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
        
        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        local char = localPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        for name, entry in pairs(cards) do
            entry.stroke.Color = a
            entry.badgeStroke.Color = a
            
            local bossData = entry.data
            local isNear = true
            
            -- Quét phạm vi người chơi đến gần tầm 500m so với CFrame của boss
            if rootPart and bossData.cframe then
                local distance = (rootPart.Position - bossData.cframe.Position).Magnitude
                if distance > 500 then
                    isNear = false
                end
            end

            if not isNear then
                entry.indicator.Text = "-"
                entry.indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
                entry.statusLabel.Text = "Out of range (>500m)"
                entry.statusLabel.TextColor3 = Color3.fromRGB(130, 135, 150)
            else
                local found = false
                local detailText = "False"

                if bossData.type == "normal" then
                    -- Kiểm tra code respawn maker cho boss thường
                    if worldOrigin then
                        local marker = worldOrigin:FindFirstChild(bossData.markerName)
                        if marker then
                            local timerGui = marker:FindFirstChild("RespawnTimer")
                            if timerGui and timerGui:FindFirstChild("Frame") and timerGui.Frame:FindFirstChild("Timer") then
                                local timerVal = timerGui.Frame.Timer
                                local textVal = tostring(timerVal.Text or "")
                                -- Nếu thời gian kết thúc hoặc hiển thị số 0 / trống nghĩa là boss đã sẵn sàng/xuất hiện (True)
                                if textVal == "" or textVal == "0" or string.find(textVal, "00:") or not timerVal.Visible then
                                    found = true
                                    detailText = "True"
                                else
                                    detailText = "False (" .. textVal .. ")"
                                end
                            else
                                -- Không có khung timer hiển thị -> có thể boss đang sống
                                found = true
                                detailText = "True"
                            end
                        else
                            found = true
                            detailText = "True"
                        end
                    end
                elseif bossData.type == "precious" then
                    -- Kiểm tra code workspace.Enemies cho boss điều kiện
                    if enemiesFolder then
                        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                            for _, kw in ipairs(bossData.keywords) do
                                if string.find(string.lower(enemy.Name), string.lower(kw)) then
                                    found = true
                                    break
                                end
                            end
                            if found then break end
                        end
                    end
                    if found then
                        detailText = "True"
                    else
                        detailText = "False"
                    end
                end

                if found then
                    entry.indicator.Text = "✓"
                    entry.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                    entry.statusLabel.Text = bossData.name .. " -> True"
                    entry.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
                else
                    entry.indicator.Text = "×"
                    entry.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                    entry.statusLabel.Text = bossData.name .. " -> " .. detailText
                    entry.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
                end
            end
        end

        task.wait(2)
    end
end)

return {}
