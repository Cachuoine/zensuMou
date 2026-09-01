local Context = ...
if type(Context) ~= "table" or not Context.Tab then return end

local Tab = Context.Tab

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

local root = New("ScrollingFrame", {
    Parent = Tab,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

New("UIListLayout", {
    Parent = root,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

New("UIPadding", {
    Parent = root,
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 2)
})

-- Header: Normal Boss
New("TextLabel", {
    Parent = root,
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "• NORMAL BOSS",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(0, 229, 255),
    TextXAlignment = Enum.TextXAlignment.Left
})

local normalBosses = {
    {name = "STONE", marker = "STONE Respawn Marker"},
    {name = "HYDRA LEADER", marker = "HYDRA LEADER Respawn Marker"},
    {name = "Kilo Admiral", marker = "KILO ADMIRAL Respawn Marker"},
    {name = "Captain Elephant", marker = "CAPTAIN ELEPHANT Respawn Marker"},
    {name = "Beautiful Pirate", marker = "BEAUTIFUL PIRATE Respawn Marker"},
    {name = "Longma", marker = "LONGMA Respawn Marker"},
    {name = "Cake Queen", marker = "CAKE QUEEN Respawn Marker"},
}

for i, boss in ipairs(normalBosses) do
    local card = New("Frame", {
        Parent = root,
        LayoutOrder = 10 + i,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Color3.fromRGB(12, 14, 20),
        BorderSizePixel = 0
    })
    Corner(card, 8)

    local label = New("TextLabel", {
        Parent = card,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = boss.name .. " -> TIME: Checking...",
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(220, 225, 235),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    task.spawn(function()
        while card.Parent do
            local success, timeText = pcall(function()
                local marker = workspace._WorldOrigin[boss.marker]
                if marker and marker:FindFirstChild("RespawnTimer") then
                    local timerFrame = marker.RespawnTimer:FindFirstChild("Frame")
                    if timerFrame and timerFrame:FindFirstChild("Timer") then
                        return timerFrame.Timer.Text
                    end
                end
                return "Alive / Ready"
            end)

            if success then
                label.Text = boss.name .. " -> TIME: " .. tostring(timeText)
            else
                label.Text = boss.name .. " -> TIME: Unknown"
            end
            task.wait(1)
        end
    end)
end

-- Header: Precious Boss (Conditional)
New("TextLabel", {
    Parent = root,
    LayoutOrder = 50,
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    Text = "• PRECIOUS BOSS",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(255, 180, 50),
    TextXAlignment = Enum.TextXAlignment.Left
})

local preciousBosses = {
    "Soul Reaper",
    "Cake Prince",
    "Dough King",
    "Rip_Indra",
    "Tyrant of the Skies"
}

for i, bossName in ipairs(preciousBosses) do
    local card = New("Frame", {
        Parent = root,
        LayoutOrder = 60 + i,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Color3.fromRGB(12, 14, 20),
        BorderSizePixel = 0
    })
    Corner(card, 8)

    local label = New("TextLabel", {
        Parent = card,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = bossName .. " -> false",
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(220, 225, 235),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    task.spawn(function()
        while card.Parent do
            local exists = false
            pcall(function()
                if workspace.Enemies:FindFirstChild(bossName) or workspace._WorldOrigin:FindFirstChild(bossName) then
                    exists = true
                end
            end)

            label.Text = bossName .. " -> " .. tostring(exists)
            if exists then
                label.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                label.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
            task.wait(1.5)
        end
    end)
end

return root
