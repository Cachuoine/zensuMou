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
        Transparency = transparency or 0.45,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function formatTime(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%02d:%02d", m, s)
end

local function readTimer(timerObject)
    if not timerObject then
        return nil
    end

    local text = tostring(timerObject.Text or "")
    local minutes, seconds = text:match("(%d+):(%d+)")
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end

    local onlySeconds = text:match("(%d+)")
    if onlySeconds then
        return tonumber(onlySeconds)
    end

    return nil
end

local function findEnemy(enemyName)
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then
        return nil
    end

    -- Scan descendants because some enemy containers can be nested.
    for _, obj in ipairs(enemies:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == enemyName then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health > 0 then
                return obj
            end
        end
    end

    return nil
end

local function getBossCFrame(model)
    if not model then
        return nil
    end

    local root = model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart

    if root and root:IsA("BasePart") then
        return root.CFrame
    end

    local ok, cf = pcall(function()
        return model:GetPivot()
    end)
    if ok then
        return cf
    end

    return nil
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
    PaddingLeft = UDim.new(2, 0),
    PaddingRight = UDim.new(5, 0)
})

New("UIListLayout", {
    Parent = container,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

local header = New("Frame", {
    Parent = container,
    LayoutOrder = 0,
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Color3.fromRGB(13, 15, 22),
    BorderSizePixel = 0
})
Corner(header, 12)
local headerStroke = Stroke(header, 1, 0.5)

New("TextLabel", {
    Parent = header,
    Position = UDim2.fromOffset(14, 7),
    Size = UDim2.new(1, -28, 0, 14),
    BackgroundTransparency = 1,
    Text = "BOSS TRACKER",
    Font = Enum.Font.GothamBlack,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(240, 242, 248),
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", {
    Parent = header,
    Position = UDim2.fromOffset(14, 22),
    Size = UDim2.new(1, -28, 0, 13),
    BackgroundTransparency = 1,
    Text = "workspace.Enemies  •  workspace._WorldOrigin",
    Font = Enum.Font.Gotham,
    TextSize = 8,
    TextColor3 = Color3.fromRGB(120, 126, 142),
    TextXAlignment = Enum.TextXAlignment.Left
})

local normalBosses = {
    {name = "STONE", marker = "STONE Respawn Marker"},
    {name = "HYDRA LEADER", marker = "HYDRA LEADER Respawn Marker"},
    {name = "Kilo Admiral", marker = "KILO ADMIRAL Respawn Marker"},
    {name = "Captain Elephant", marker = "CAPTAIN ELEPHANT Respawn Marker"},
    {name = "Beautiful Pirate", marker = "BEAUTIFUL PIRATE Respawn Marker"},
    {name = "Longma", marker = "LONGMA Respawn Marker"},
    {name = "Cake Queen", marker = "CAKE QUEEN Respawn Marker"}
}

local conditionBosses = {
    "Soul Reaper",
    "Cake Prince",
    "Dough King",
    "Rip_Indra",
    "Tyrant of the Skies"
}

local normalCards = {}
local conditionCards = {}

local function makeCard(parent, order, title, subtitle)
    local card = New("Frame", {
        Parent = parent,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 67),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)

    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(14, 8),
        Size = UDim2.new(1, -94, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(14, 29),
        Size = UDim2.new(1, -94, 0, 26),
        BackgroundTransparency = 1,
        Text = subtitle,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(140, 145, 160),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true
    })

    local badge = New("Frame", {
        Parent = card,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(38, 38),
        BackgroundColor3 = Color3.fromRGB(22, 25, 37),
        BorderSizePixel = 0
    })
    Corner(badge, 9)
    local badgeStroke = Stroke(badge, 1, 0.4)

    local indicator = New("TextLabel", {
        Parent = badge,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    return {
        card = card,
        stroke = stroke,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        title = title,
        status = nil
    }
end

local normalHeader = New("TextLabel", {
    Parent = container,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "• NORMAL BOSS",
    Font = Enum.Font.GothamBlack,
    TextSize = 9,
    TextColor3 = accent(),
    TextXAlignment = Enum.TextXAlignment.Left
})

for i, data in ipairs(normalBosses) do
    local card = makeCard(container, i + 1, data.name, "Status: False")
    card.marker = data.marker
    card.timerText = New("TextLabel", {
        Parent = card.card,
        Position = UDim2.fromOffset(14, 48),
        Size = UDim2.new(1, -105, 0, 12),
        BackgroundTransparency = 1,
        Text = "Respawn: --:--",
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextColor3 = Color3.fromRGB(105, 110, 125),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- The status label is the first subtitle-like label after the title.
    local labels = {}
    for _, child in ipairs(card.card:GetChildren()) do
        if child:IsA("TextLabel") and child ~= card.timerText and child.Parent == card.card then
            table.insert(labels, child)
        end
    end
    card.statusLabel = labels[2]
    card.statusLabel.Text = "Status: False"
    normalCards[data.name] = card
end

local conditionHeader = New("TextLabel", {
    Parent = container,
    LayoutOrder = 20,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "• PRECIOUS BOSS",
    Font = Enum.Font.GothamBlack,
    TextSize = 9,
    TextColor3 = accent(),
    TextXAlignment = Enum.TextXAlignment.Left
})

for i, name in ipairs(conditionBosses) do
    local card = makeCard(container, 20 + i, name, "Status: False")
    card.statusLabel = nil
    for _, child in ipairs(card.card:GetChildren()) do
        if child:IsA("TextLabel") and child.Text == "Status: False" then
            card.statusLabel = child
            break
        end
    end
    conditionCards[name] = card
end

local function setStatus(card, found, extra)
    local a = accent()

    card.stroke.Color = a
    card.badgeStroke.Color = a

    if found then
        card.indicator.Text = "✓"
        card.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
        card.statusLabel.Text = "Status: True"
        card.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
    else
        card.indicator.Text = "×"
        card.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
        card.statusLabel.Text = "Status: False"
        card.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
    end

    if extra and card.timerText then
        card.timerText.Text = extra
        card.timerText.TextColor3 = a
    end
end

local function getTimerForMarker(markerName)
    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
    if not worldOrigin then
        return nil
    end

    local marker = worldOrigin:FindFirstChild(markerName)
    if not marker then
        return nil
    end

    local respawnTimer = marker:FindFirstChild("RespawnTimer")
    local frame = respawnTimer and respawnTimer:FindFirstChild("Frame")
    local timer = frame and frame:FindFirstChild("Timer")

    if timer and timer:IsA("TextLabel") then
        return readTimer(timer)
    end

    return nil
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then
        alive = false
    end
end)

task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a
        headerStroke.Color = a
        normalHeader.TextColor3 = a
        conditionHeader.TextColor3 = a

        -- Normal bosses:
        -- 1) workspace.Enemies is checked for the live boss.
        -- 2) If absent, _WorldOrigin respawn marker is checked for its timer.
        -- 3) Once the timer reaches zero, the card returns to the normal True/False state.
        for name, data in pairs(normalBosses) do
            local card = normalCards[name]
            local enemy = findEnemy(name)

            if enemy then
                setStatus(card, true, "Spawned  •  workspace.Enemies")
            else
                local remaining = getTimerForMarker(data.marker)

                if remaining and remaining > 0 then
                    setStatus(card, false, "Respawn: " .. formatTime(remaining))
                else
                    setStatus(card, false, "Respawn: ready  •  waiting for spawn")
                end
            end
        end

        -- Condition bosses are presence based. Their CFrame is obtained
        -- dynamically from the live model, so no hard-coded coordinates are needed.
        for name, card in pairs(conditionCards) do
            local enemy = findEnemy(name)
            local cf = getBossCFrame(enemy)

            if cf then
                setStatus(card, true, nil)
            else
                setStatus(card, false, nil)
            end
        end

        -- Keep the scan responsive without creating a tight render-loop.
        task.wait(0.5)
    end
end)

return {}
