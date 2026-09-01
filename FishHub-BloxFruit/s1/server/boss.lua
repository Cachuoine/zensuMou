local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

------------------------------------------------------------
-- Settings
------------------------------------------------------------
local SETTINGS = {
    SoundVolume = 0.6,
    NotifyCooldown = 30,            -- chống spam cùng 1 boss trong 30s
    NotificationDuration = 6,       -- toast tồn tại bao nhiêu giây
    NotifyQueueDelay = 0.6,         -- delay giữa 2 toast khi stack
    WebhookURL = nil,               -- paste Discord webhook vào đây nếu muốn
}

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

local function Stroke(parent, thickness, transparency, color)
    return New("UIStroke", {
        Parent = parent,
        Color = color or accent(),
        Thickness = thickness or 1,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function Tween(obj, duration, props, style, direction)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.2,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

for _, child in ipairs(Tab:GetChildren()) do
    child:Destroy()
end

Tab.BackgroundTransparency = 1
Tab.BorderSizePixel = 0

------------------------------------------------------------
-- Notification area (top of Tab)
------------------------------------------------------------
local notifyFrame = New("Frame", {
    Parent = Tab,
    Position = UDim2.new(0, 5, 0, 5),
    Size = UDim2.new(1, -10, 0, 130),
    BackgroundTransparency = 1,
    ClipsDescendants = true
})
New("UIListLayout", {
    Parent = notifyFrame,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
    VerticalAlignment = Enum.VerticalAlignment.Top
})

------------------------------------------------------------
-- Scrolling container (below notification area)
------------------------------------------------------------
local container = New("ScrollingFrame", {
    Parent = Tab,
    Position = UDim2.new(0, 5, 0, 140),
    Size = UDim2.new(1, -10, 1, -145),
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
-- Notification sound
------------------------------------------------------------
local sound = nil
pcall(function()
    sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = SETTINGS.SoundVolume
    sound.Parent = SoundService
end)

------------------------------------------------------------
-- Toast queue + showNotification
------------------------------------------------------------
local notifyQueue = {}
local notifying = false
local function showNotification(title, message, color, duration)
    duration = duration or SETTINGS.NotificationDuration
    color = color or Color3.fromRGB(0, 229, 255)

    -- newest first
    local toast = New("Frame", {
        Parent = notifyFrame,
        LayoutOrder = math.floor(tick() * 1000) % 1000000,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(15, 17, 26),
        BorderSizePixel = 0
    })
    Corner(toast, 10)
    Stroke(toast, 1, 0.3, color)

    local bar = New("Frame", {
        Parent = toast,
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.new(0, 3, 1, -12),
        BackgroundColor3 = color,
        BorderSizePixel = 0
    })
    Corner(bar, 2)

    New("TextLabel", {
        Parent = toast,
        Position = UDim2.fromOffset(18, 6),
        Size = UDim2.new(1, -30, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = color,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = toast,
        Position = UDim2.fromOffset(18, 26),
        Size = UDim2.new(1, -30, 0, 30),
        BackgroundTransparency = 1,
        Text = message,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(220, 225, 235),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    toast.BackgroundTransparency = 1
    Tween(toast, 0.25, {BackgroundTransparency = 0})

    task.delay(duration, function()
        if toast and toast.Parent then
            Tween(toast, 0.4, {BackgroundTransparency = 1})
            task.wait(0.45)
            if toast and toast.Parent then
                toast:Destroy()
            end
        end
    end)

    pcall(function()
        if sound then sound:Play() end
    end)
end

local function queueNotify(title, message, color, duration)
    table.insert(notifyQueue, {title, message, color or Color3.fromRGB(0, 229, 255), duration})
    if notifying then return end
    notifying = true
    task.spawn(function()
        while #notifyQueue > 0 do
            local args = table.remove(notifyQueue, 1)
            showNotification(args[1], args[2], args[3], args[4])
            task.wait(SETTINGS.NotifyQueueDelay)
        end
        notifying = false
    end)
end

------------------------------------------------------------
-- Discord webhook (optional)
------------------------------------------------------------
local function postWebhook(webhookUrl, title, message)
    if not webhookUrl or webhookUrl == "" then return end
    pcall(function()
        local data = {
            ["username"] = "FishHub Boss Alert",
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = message,
                ["color"] = 16750848
            }}
        }
        HttpService:PostAsync(
            webhookUrl,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

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
-- Cards
------------------------------------------------------------
local function makeNormalCard(name, marker, order)
    local card = New("Frame", {
        Parent = container,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 78),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 10),
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
        Position = UDim2.fromOffset(15, 32),
        Size = UDim2.new(1, -90, 0, 16),
        BackgroundTransparency = 1,
        Text = "Checking...",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local lastSeenLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 52),
        Size = UDim2.new(1, -90, 0, 14),
        BackgroundTransparency = 1,
        Text = "Last seen: -",
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(95, 100, 115),
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
        lastSeenLabel = lastSeenLabel,
        badge = badge,
        badgeStroke = badgeStroke,
        indicator = indicator,
        marker = marker
    }
end

local function makePreciousCard(name, enemyName, cframe, order)
    local hasCFrame = cframe ~= nil
    local rightWidth = hasCFrame and 110 or 60

    local card = New("Frame", {
        Parent = container,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 78),
        BackgroundColor3 = Color3.fromRGB(13, 15, 22),
        BorderSizePixel = 0
    })
    Corner(card, 12)
    local stroke = Stroke(card, 1, 0.5)

    New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 10),
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
        Position = UDim2.fromOffset(15, 32),
        Size = UDim2.new(1, -(rightWidth + 25), 0, 16),
        BackgroundTransparency = 1,
        Text = "Checking...",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(150, 155, 170),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local lastSeenLabel = New("TextLabel", {
        Parent = card,
        Position = UDim2.fromOffset(15, 52),
        Size = UDim2.new(1, -(rightWidth + 25), 0, 14),
        BackgroundTransparency = 1,
        Text = "Last seen: -",
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = Color3.fromRGB(95, 100, 115),
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
        lastSeenLabel = lastSeenLabel,
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

local function timeAgo(ts)
    if not ts then return "-" end
    local elapsed = math.max(0, tick() - ts)
    if elapsed < 5 then return "just now"
    elseif elapsed < 60 then return math.floor(elapsed) .. "s ago"
    elseif elapsed < 3600 then return math.floor(elapsed / 60) .. "m ago"
    else return math.floor(elapsed / 3600) .. "h ago" end
end

------------------------------------------------------------
-- State tracking
------------------------------------------------------------
local alive = true
Tab.AncestryChanged:Connect(function(_, parent)
    if not parent then alive = false end
end)

local lastState = {}    -- name -> bool (alive?)
local lastSeen = {}     -- name -> tick()
local lastNotify = {}   -- name -> tick() (anti-spam cooldown)
local firstScan = true

for name in pairs(normalCards) do lastState[name] = false end
for name in pairs(preciousCards) do lastState[name] = false end

local PRECIOUS_COLOR = Color3.fromRGB(255, 200, 80)
local NORMAL_COLOR   = Color3.fromRGB(0, 229, 255)

local function fireSpawnAlert(category, bossName)
    local now = tick()
    if lastNotify[bossName] and (now - lastNotify[bossName]) < SETTINGS.NotifyCooldown then
        return
    end
    lastNotify[bossName] = now

    local title, color
    if category == "precious" then
        title = "💎 PRECIOUS BOSS SPAWNED"
        color = PRECIOUS_COLOR
    else
        title = "⚔ NORMAL BOSS READY"
        color = NORMAL_COLOR
    end

    local message = bossName .. " vừa xuất hiện trong server!"
    queueNotify(title, message, color, SETTINGS.NotificationDuration)

    if SETTINGS.WebhookURL and SETTINGS.WebhookURL ~= "" then
        task.spawn(function()
            postWebhook(SETTINGS.WebhookURL, title, message)
        end)
    end
end

------------------------------------------------------------
-- Instant detection: workspace.Enemies.ChildAdded (precious)
------------------------------------------------------------
pcall(function()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        enemiesFolder.ChildAdded:Connect(function(child)
            if not child:IsA("Model") then return end
            if not child:FindFirstChildOfClass("Humanoid") then return end
            local lowerName = string.lower(child.Name)
            for bossName, data in pairs(preciousCards) do
                local lowerBoss = string.lower(data.enemyName)
                if lowerName == lowerBoss or string.find(lowerName, lowerBoss, 1, true) then
                    if lastState[bossName] ~= true then
                        lastState[bossName] = true
                        lastSeen[bossName] = tick()
                        fireSpawnAlert("precious", bossName)
                    end
                    break
                end
            end
        end)

        enemiesFolder.ChildRemoved:Connect(function(child)
            if not child:IsA("Model") then return end
            local lowerName = string.lower(child.Name)
            for bossName in pairs(preciousCards) do
                local lowerBoss = string.lower(preciousCards[bossName].enemyName)
                if lowerName == lowerBoss or string.find(lowerName, lowerBoss, 1, true) then
                    if lastState[bossName] then
                        lastState[bossName] = false
                    end
                    break
                end
            end
        end)
    end
end)

------------------------------------------------------------
-- Polling loop (state change detection + UI refresh)
------------------------------------------------------------
task.spawn(function()
    while alive and container.Parent do
        local a = accent()
        container.ScrollBarImageColor3 = a

        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        local enemiesFolder = Workspace:FindFirstChild("Enemies")

        -------------------- NORMAL BOSSES --------------------
        for bossName, data in pairs(normalCards) do
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
                        bossAlive = true
                    end
                else
                    bossAlive = true
                end
            end

            local currentState = bossAlive
            local prevState = lastState[bossName] or false

            if currentState and not prevState then
                lastSeen[bossName] = tick()
                if not firstScan then
                    fireSpawnAlert("normal", bossName)
                end
            end
            lastState[bossName] = currentState

            if currentState then
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

            data.lastSeenLabel.Text = "Last seen: " .. timeAgo(lastSeen[bossName])
        end

        -------------------- PRECIOUS BOSSES --------------------
        for bossName, data in pairs(preciousCards) do
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
                    if enemy:IsA("Model") then
                        local en = string.lower(enemy.Name)
                        if en == lowerName or string.find(en, lowerName, 1, true) then
                            found = true
                            break
                        end
                    end
                end
            end

            local currentState = found
            local prevState = lastState[bossName] or false

            if currentState and not prevState then
                lastSeen[bossName] = tick()
                if not firstScan then
                    fireSpawnAlert("precious", bossName)
                end
            end
            lastState[bossName] = currentState

            if currentState then
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

            data.lastSeenLabel.Text = "Last seen: " .. timeAgo(lastSeen[bossName])
        end

        firstScan = false
        task.wait(0.2)
    end
end)

return {}
