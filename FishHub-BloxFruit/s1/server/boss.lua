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

------------------------------------------------------------
-- Section header
------------------------------------------------------------
local function makeHeader(text, order)
    local header = New("Frame", {
        Parent = container,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(15, 17, 26),
        BorderSizePixel = 0
    })
    Corner(header, 9)
    Stroke(header, 1, 0.5)
    New("UIPadding", {
        Parent = header,
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
    })
    New("TextLabel", {
        Parent = header,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamBlack,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(180, 185, 200),
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

------------------------------------------------------------
-- NORMAL BOSS card (read respawn marker timer)
------------------------------------------------------------
local function makeNormalCard(name, marker, order)
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = order,
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
        Text = name,
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

    return {
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        marker = marker
    }
end

------------------------------------------------------------
-- PRECIOUS BOSS card (workspace.Enemies existence check)
------------------------------------------------------------
local function makePreciousCard(name, enemyName, cframe, order)
    local hasCFrame = cframe ~= nil
    local rightWidth = hasCFrame and 110 or 60

    local card = New("Frame", {
        Parent = container,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -(rightWidth + 25), 0, 22),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local statusLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 36),
        Size = UDim2.new(1, -(rightWidth + 25), 0, 16),
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

    local data = {
        card = card,
        stroke = stroke,
        statusLabel = statusLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        enemyName = enemyName,
        cframe = cframe
    }

    if hasCFrame then
        local tpButton = New("TextButton", {
            Parent = card,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -60, 0.5, 0),
            Size = UDim2.fromOffset(40, 26),
            BackgroundColor3 = Color3.fromRGB(22, 25, 37),
            Text = "TP",
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(0, 229, 255),
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        Corner(tpButton, 6)
        local tpStroke = Stroke(tpButton, 1, 0.4)

        data.tpButton = tpButton
        data.tpStroke = tpStroke

        tpButton.Activated:Connect(function()
            local player = Players.LocalPlayer
            if not player or not player.Character then return end
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = cframe
            end
        end)
    end

    return data
end

------------------------------------------------------------
-- Boss data
------------------------------------------------------------
local order = 1
makeHeader("• NORMAL BOSS", order)
order = order + 1

local normalBosses = {
    {name = "STONE",            marker = "STONE Respawn Marker"},
    {name = "HYDRA LEADER",     marker = "HYDRA LEADER Respawn Marker"},
    {name = "KILO ADMIRAL",     marker = "KILO ADMIRAL Respawn Marker"},
    {name = "CAPTAIN ELEPHANT", marker = "CAPTAIN ELEPHANT Respawn Marker"},
    {name = "BEAUTIFUL PIRATE", marker = "BEAUTIFUL PIRATE Respawn Marker"},
    {name = "LONGMA",           marker = "LONGMA Respawn Marker"},
    {name = "CAKE QUEEN",       marker = "CAKE QUEEN Respawn Marker"}
}

local normalCards = {}
for _, boss in ipairs(normalBosses) do
    local data = makeNormalCard(boss.name, boss.marker, order)
    normalCards[boss.name] = data
    order = order + 1
end

makeHeader("• PRECIOUS BOSS", order)
order = order + 1

local preciousBosses = {
    {
        name = "Soul Reaper",
        enemyName = "Soul Reaper",
        cframe = CFrame.new(
            -9522.2334, 314.747986, 6789.48193,
            0.999388874, -0, -0.0349550731,
            0, 1, -0,
            0.0349550731, 0, 0.999388874
        )
    },
    {
        name = "Cake Prince",
        enemyName = "Cake Prince",
        cframe = CFrame.new(
            -2089.86597, 4536.92383, -14800.0068,
            0.868320882, -0, -0.496002853,
            0, 1, -0,
            0.496002853, 0, 0.868320882
        )
    },
    {
        name = "Dough King",
        enemyName = "Dough King",
        cframe = nil
    },
    {
        name = "Rip Indra",
        enemyName = "rip_indra",
        cframe = CFrame.new(
            -5395.71582, 319.981995, -2588.76001,
            0.927179396, 0, 0.374617696,
            0, 1, 0,
            -0.374617696, 0, 0.927179396
        )
    },
    {
        name = "Tyrant of the Skies",
        enemyName = "Tyrant of the Skies",
        cframe = nil
    }
}

local preciousCards = {}
for _, boss in ipairs(preciousBosses) do
    local data = makePreciousCard(boss.name, boss.enemyName, boss.cframe, order)
    preciousCards[boss.name] = data
    order = order + 1
end

------------------------------------------------------------
-- Helpers
------------------------------------------------------------
-- Timer text such as "0:00", "00:00", "0:00:00", "" -> boss is alive
-- Any non-zero digit anywhere in the timer text -> boss is dead
local function isTimerZero(text)
    if not text or text == "" then return true end
    local digits = string.gsub(text, "%D", "")
    if digits == "" then return true end
    for i = 1, #digits do
        if string.sub(digits, i, i) ~= "0" then
            return false
        end
    end
    return true
end

local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

------------------------------------------------------------
-- Main loop
------------------------------------------------------------
task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        local enemiesFolder = Workspace:FindFirstChild("Enemies")

        -------------------- NORMAL BOSSES --------------------
        for _, data in pairs(normalCards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a

            local bossAlive = false
            local timerText = ""

            if worldOrigin then
                local marker = worldOrigin:FindFirstChild(data.marker)
                if marker then
                    local respawnTimer = marker:FindFirstChild("RespawnTimer")
                    if respawnTimer then
                        local frame = respawnTimer:FindFirstChild("Frame")
                        if frame then
                            local timer = frame:FindFirstChild("Timer")
                            if timer and timer:IsA("TextLabel") then
                                timerText = timer.Text or ""
                                bossAlive = isTimerZero(timerText)
                            end
                        end
                    else
                        -- marker exists but no RespawnTimer -> boss already up
                        bossAlive = true
                    end
                else
                    -- marker missing -> treat as alive
                    bossAlive = true
                end
            end

            if bossAlive then
                data.indicator.Text = "✓"
                data.indicator.TextColor3 = Color3.fromRGB(80, 255, 120)
                data.statusLabel.Text = "Status: True"
                data.statusLabel.TextColor3 = Color3.fromRGB(180, 255, 190)
            else
                data.indicator.Text = "✕"
                data.indicator.TextColor3 = Color3.fromRGB(255, 90, 90)
                if timerText and timerText ~= "" then
                    data.statusLabel.Text = "Status: False (" .. timerText .. ")"
                else
                    data.statusLabel.Text = "Status: False"
                end
                data.statusLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            end
        end

        -------------------- PRECIOUS BOSSES --------------------
        for _, data in pairs(preciousCards) do
            data.stroke.Color = a
            data.badgeStroke.Color = a
            if data.tpButton and data.tpStroke then
                data.tpStroke.Color = a
                data.tpButton.TextColor3 = a
            end

            local found = false
            if enemiesFolder then
                local lowerName = string.lower(data.enemyName)
                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    local en = string.lower(enemy.Name)
                    if en == lowerName or string.find(en, lowerName, 1, true) then
                        found = true
                        break
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

        -- thường xuyên quét, vừa đủ nhẹ cho client
        task.wait(2)
    end
end)

return {}
