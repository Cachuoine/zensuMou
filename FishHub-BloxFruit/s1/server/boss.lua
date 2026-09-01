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

-- Định nghĩa danh sách Boss thường (Normal Boss) và Boss điều kiện (Precious Boss) theo yêu cầu
local bossList = {
    -- Normal Boss (Có marker timer trong workspace._WorldOrigin)
    {name = "STONE", type = "normal", marker = "STONE Respawn Marker"},
    {name = "HYDRA LEADER", type = "normal", marker = "HYDRA LEADER Respawn Marker"},
    {name = "Kilo Admiral", type = "normal", marker = "KILO ADMIRAL Respawn Marker"},
    {name = "Captain Elephant", type = "normal", marker = "CAPTAIN ELEPHANT Respawn Marker"},
    {name = "Beautiful Pirate", type = "normal", marker = "BEAUTIFUL PIRATE Respawn Marker"},
    {name = "Longma", type = "normal", marker = "LONGMA Respawn Marker"},
    {name = "Cake Queen", type = "normal", marker = "CAKE QUEEN Respawn Marker"},

    -- Precious Boss (Boss điều kiện quét trong workspace.Enemies dựa vào vị trí CFrame gần)
    {name = "Soul Reaper", type = "precious", cframe = Vector3.new(-9522.2334, 314.747986, 6789.48193)},
    {name = "Cake Prince", type = "precious", cframe = Vector3.new(-2089.86597, 4536.92383, -14800.0068)},
    {name = "Dough King", type = "precious", cframe = nil},
    {name = "Rip_Indra", type = "precious", cframe = Vector3.new(-5395.71582, 319.981995, -2588.76001)},
    {name = "Tyrant of the Skies", type = "precious", cframe = nil}
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

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -90, 0, 22),
        BackgroundTransparency = 1,
        Text = boss.name .. " (" .. (boss.type == "normal" and "Normal" or "Precious") .. ")",
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

        for name, ui in pairs(cards) do
            ui.stroke.Color = a
            ui.badgeStroke.Color = a

            local bossInfo = ui.data
            local isTrue = false

            if bossInfo.type == "normal" then
                -- Kiểm tra Normal Boss thông qua workspace._WorldOrigin [Respawn Marker] Timer
                if worldOrigin then
                    local marker = worldOrigin:FindFirstChild(bossInfo.marker)
                    if marker then
                        local timerGui = marker:FindFirstChild("RespawnTimer")
                        if timerGui then
                            local frame = timerGui:FindFirstChild("Frame")
                            if frame then
                                local timerVal = frame:FindFirstChild("Timer")
                                -- Khi thời gian kết thúc hoặc không còn hiển thị số/thời gian nữa => Boss xuất hiện (True)
                                if not timerVal or (timerVal:IsA("TextLabel") and (timerVal.Text == "" or timerVal.Text == "0" or timerVal.Text == "00:00" or not timerVal.Visible)) then
                                    isTrue = true
                                end
                            end
                        end
                    else
                        -- Trường hợp mất file/marker boss, theo yêu cầu trả về True
                        isTrue = true
                    end
                else
                    isTrue = true
                end

            elseif bossInfo.type == "precious" then
                -- Kiểm tra Precious Boss trong workspace.Enemies
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        if string.find(enemy.Name, bossInfo.name) then
                            -- Nếu có chỉ định CFrame, kiểm tra khoảng cách quét vô hạn hoặc xung quanh khu vực đó
                            if bossInfo.cframe and enemy:FindFirstChild("HumanoidRootPart") then
                                local dist = (enemy.HumanoidRootPart.Position - bossInfo.cframe.Position).Magnitude
                                if dist < 1500 then -- Phạm vi quét gần
                                    isTrue = true
                                    break
                                end
                            else
                                isTrue = true
                                break
                            end
                        end
                    end
                end
            end

            -- Cập nhật giao diện True/False giống style islandeven.lua
            if isTrue then
                ui.indicator.Text = "✓"
                ui.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                ui.statusLabel.Text = "Status: True"
                ui.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
            else
                ui.indicator.Text = "×"
                ui.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                ui.statusLabel.Text = "Status: False"
                ui.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        task.wait(2)
    end
end)

return {}
