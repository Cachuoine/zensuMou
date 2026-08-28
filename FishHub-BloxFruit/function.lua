local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local context = ...
if type(context) ~= "table" or not context.Tab then return end

local Tab = context.Tab
local Config = context.Config or {}

local function accent()
    return typeof(Config.ThemeColor) == "Color3"
        and Config.ThemeColor
        or Color3.fromRGB(0, 229, 255)
end

local function New(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
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
        Transparency = transparency or 0.5,
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

-- ================= ROOT STATE =================
-- currentUnload: hàm dọn dẹp (nếu có) của trang con đang mở, gọi trước khi
-- quay lại menu chính hoặc mở trang con khác.
local currentUnload = nil

local function safeUnload()
    if type(currentUnload) == "function" then
        pcall(currentUnload)
    end
    currentUnload = nil
end

-- Bảng đăng ký các module con. Mỗi entry là 1 hàm build(subContext) trả về
-- (rootFrame, unloadFn?) hoặc chỉ rootFrame.
local ModuleBuilders = {}
local openModule -- forward declare (định nghĩa bên dưới)

-- ================= MAIN MENU RENDER =================
local function renderMainMenu()
    safeUnload()

    for _, child in ipairs(Tab:GetChildren()) do
        child:Destroy()
    end

    Tab.BackgroundTransparency = 1
    Tab.BorderSizePixel = 0
    Tab.ScrollBarThickness = 0
    Tab.ScrollBarImageTransparency = 1
    Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local root = New("Frame", {
        Parent = Tab,
        Size = UDim2.new(1, -10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1
    })

    New("UIPadding", {
        Parent = root,
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })

    New("UIListLayout", {
        Parent = root,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    local head = New("Frame", {
        Parent = root,
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 66),
        BackgroundColor3 = Color3.fromRGB(8, 9, 14),
        BorderSizePixel = 0
    })
    Corner(head, 14)
    local headStroke = Stroke(head, 1, 0.35)

    New("UIGradient", {
        Parent = head,
        Rotation = 18,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 31)),
            ColorSequenceKeypoint.new(0.62, Color3.fromRGB(9, 10, 16)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 7, 12))
        })
    })

    local headerGlow = New("Frame", {
        Parent = head,
        Position = UDim2.new(1, -105, 0, -56),
        Size = UDim2.fromOffset(150, 150),
        BackgroundColor3 = accent(),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0
    })
    Corner(headerGlow, 99)
    New("UIGradient", {
        Parent = headerGlow,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    local headerGlow2 = New("Frame", {
        Parent = head,
        Position = UDim2.new(0, -45, 1, -35),
        Size = UDim2.fromOffset(100, 100),
        BackgroundColor3 = accent(),
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0
    })
    Corner(headerGlow2, 99)
    New("UIGradient", {
        Parent = headerGlow2,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    local headerHighlight = New("Frame", {
        Parent = head,
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(1, -56, 0, 2),
        BackgroundColor3 = accent(),
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0
    })
    Corner(headerHighlight, 2)

    local accentBar = New("Frame", {
        Parent = head,
        Position = UDim2.fromOffset(12, 14),
        Size = UDim2.fromOffset(4, 38),
        BackgroundColor3 = accent(),
        BorderSizePixel = 0
    })
    Corner(accentBar, 4)

    New("TextLabel", {
        Parent = head,
        Position = UDim2.fromOffset(28, 9),
        Size = UDim2.new(1, -42, 0, 25),
        BackgroundTransparency = 1,
        Text = "FUNCTION",
        Font = Enum.Font.GothamBlack,
        TextSize = 17,
        TextColor3 = Color3.fromRGB(245, 246, 252),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = head,
        Position = UDim2.fromOffset(28, 36),
        Size = UDim2.new(1, -42, 0, 17),
        BackgroundTransparency = 1,
        Text = "TOOLS  •  MODULES  •  UTILITIES",
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextColor3 = Color3.fromRGB(125, 130, 145),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local headerDot = New("Frame", {
        Parent = head,
        Position = UDim2.new(1, -28, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = accent(),
        BorderSizePixel = 0
    })
    Corner(headerDot, 99)

    task.spawn(function()
        while headerDot.Parent do
            Tween(headerDot, 0.9, {BackgroundTransparency = 0.1}, Enum.EasingStyle.Sine)
            task.wait(0.9)
            if not headerDot.Parent then break end
            Tween(headerDot, 0.9, {BackgroundTransparency = 0.7}, Enum.EasingStyle.Sine)
            task.wait(0.9)
        end
    end)

    local holder = New("Frame", {
        Parent = root,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1
    })

    New("UIGridLayout", {
        Parent = holder,
        CellSize = UDim2.new(0.5, -5, 0, 92),
        CellPadding = UDim2.new(0, 10, 0, 10),
        FillDirectionMaxCells = 2,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local modules = {
        {"SHOP", "shop", "Shop and item utilities."},
        {"SETTING FARM", "settingfarm", "Farming preferences."},
        {"FARM", "farm", "Farming functions and controls."},
        {"ITEM", "item", "Items and quest utilities."},
        {"ISLAND", "island", "Island travel and navigation."},
        {"FRUIT", "fruit", "Fruit utilities and helpers."},
        {"SETTING", "setting", "FishHub settings and controls."},
    }

    local cards = {}

    local function makeCard(index, data)
        local title, moduleKey, description = data[1], data[2], data[3]

        local card = New("TextButton", {
            Parent = holder,
            LayoutOrder = index,
            AutoButtonColor = false,
            Text = "",
            BackgroundColor3 = Color3.fromRGB(9, 10, 15),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        })
        Corner(card, 14)

        New("UIGradient", {
            Parent = card,
            Rotation = 100,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 15, 23)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 14))
            })
        })

        local stroke = Stroke(card, 1, 0.68)
        local scale = New("UIScale", {Parent = card, Scale = 0.92})

        local shine = New("Frame", {
            Parent = card,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = accent(),
            BorderSizePixel = 0
        })
        Corner(shine, 4)

        local iconGlow = New("Frame", {
            Parent = card,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(15 + 19, 16 + 19),
            Size = UDim2.fromOffset(50, 50),
            BackgroundColor3 = accent(),
            BackgroundTransparency = 0.88,
            BorderSizePixel = 0
        })
        Corner(iconGlow, 99)

        local iconBox = New("Frame", {
            Parent = card,
            Position = UDim2.fromOffset(15, 16),
            Size = UDim2.fromOffset(38, 38),
            BackgroundColor3 = Color3.fromRGB(17, 19, 28),
            BorderSizePixel = 0
        })
        Corner(iconBox, 11)
        local iconStroke = Stroke(iconBox, 1, 0.72)

        New("UIGradient", {
            Parent = iconBox,
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 26, 38)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 15, 22))
            })
        })

        New("TextLabel", {
            Parent = iconBox,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = string.sub(title, 1, 1),
            Font = Enum.Font.GothamBlack,
            TextSize = 13,
            TextColor3 = accent()
        })

        New("TextLabel", {
            Parent = card,
            Position = UDim2.fromOffset(66, 14),
            Size = UDim2.new(1, -92, 0, 22),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(240, 242, 248),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        New("TextLabel", {
            Parent = card,
            Position = UDim2.fromOffset(66, 37),
            Size = UDim2.new(1, -82, 0, 34),
            BackgroundTransparency = 1,
            Text = description,
            Font = Enum.Font.GothamMedium,
            TextSize = 8,
            TextColor3 = Color3.fromRGB(112, 117, 132),
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        local chevron = New("TextLabel", {
            Parent = card,
            Position = UDim2.new(1, -29, 0, 15),
            Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1,
            Text = "›",
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextColor3 = accent()
        })

        local state = {
            button = card,
            stroke = stroke,
            iconStroke = iconStroke,
            shine = shine,
            scale = scale,
            iconGlow = iconGlow,
            name = string.lower(title),
            moduleKey = moduleKey
        }
        cards[#cards + 1] = state

        card.MouseEnter:Connect(function()
            Tween(scale, 0.18, {Scale = 1.045}, Enum.EasingStyle.Back)
            Tween(stroke, 0.18, {Transparency = 0.05, Thickness = 1.5})
            Tween(iconBox, 0.18, {BackgroundColor3 = Color3.fromRGB(23, 26, 38)})
            Tween(shine, 0.18, {Size = UDim2.new(0, 5, 1, 0)})
            Tween(iconGlow, 0.18, {BackgroundTransparency = 0.72})
            Tween(chevron, 0.18, {Position = UDim2.new(1, -25, 0, 15)})
        end)

        card.MouseLeave:Connect(function()
            Tween(scale, 0.18, {Scale = 1})
            Tween(stroke, 0.18, {Transparency = 0.68, Thickness = 1})
            Tween(iconBox, 0.18, {BackgroundColor3 = Color3.fromRGB(17, 19, 28)})
            Tween(shine, 0.18, {Size = UDim2.new(0, 3, 1, 0)})
            Tween(iconGlow, 0.18, {BackgroundTransparency = 0.88})
            Tween(chevron, 0.18, {Position = UDim2.new(1, -29, 0, 15)})
        end)

        card.Activated:Connect(function()
            openModule(moduleKey)
        end)

        task.delay(index * 0.045, function()
            if card and card.Parent then
                Tween(card, 0.3, {BackgroundTransparency = 0}, Enum.EasingStyle.Quart)
                Tween(scale, 0.32, {Scale = 1}, Enum.EasingStyle.Back)
            end
        end)
    end

    for i, moduleData in ipairs(modules) do
        makeCard(i, moduleData)
    end

    task.spawn(function()
        while root.Parent do
            local a = accent()
            accentBar.BackgroundColor3 = a
            headerDot.BackgroundColor3 = a
            headStroke.Color = a
            headerGlow.BackgroundColor3 = a
            headerGlow2.BackgroundColor3 = a
            headerHighlight.BackgroundColor3 = a

            for _, item in ipairs(cards) do
                item.stroke.Color = a
                item.iconStroke.Color = a
                item.shine.BackgroundColor3 = a
                item.iconGlow.BackgroundColor3 = a
            end

            task.wait(0.2)
        end
    end)
end

-- ================= SUB PAGE SHELL =================
-- Tạo khung chung cho 1 trang con: top bar (Back + Search) + content frame.
-- builderFn(contentFrame, subContext) được gọi để build nội dung riêng của module.
local function renderSubPage(titleText, moduleKey, builderFn)
    safeUnload()

    for _, child in ipairs(Tab:GetChildren()) do
        child:Destroy()
    end

    Tab.BackgroundTransparency = 1
    Tab.BorderSizePixel = 0
    Tab.ScrollBarThickness = 0
    Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local root = New("Frame", {
        Parent = Tab,
        Size = UDim2.new(1, -10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1
    })
    New("UIPadding", {
        Parent = root,
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })
    New("UIListLayout", {
        Parent = root,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    local topBar = New("Frame", {
        Parent = root,
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1
    })

    local backBtn = New("TextButton", {
        Parent = topBar,
        Size = UDim2.fromOffset(45, 45),
        BackgroundColor3 = Color3.fromRGB(12, 13, 19),
        AutoButtonColor = false,
        Text = ""
    })
    Corner(backBtn, 10)
    local backStroke = Stroke(backBtn, 1, 0.4)
    New("TextLabel", {
        Parent = backBtn,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "←",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = accent()
    })

    backBtn.MouseEnter:Connect(function()
        Tween(backStroke, 0.15, {Transparency = 0.05})
    end)
    backBtn.MouseLeave:Connect(function()
        Tween(backStroke, 0.15, {Transparency = 0.4})
    end)

    local titleBox = New("Frame", {
        Parent = topBar,
        Position = UDim2.new(0, 55, 0, 0),
        Size = UDim2.new(1, -55, 1, 0),
        BackgroundColor3 = Color3.fromRGB(12, 13, 19)
    })
    Corner(titleBox, 10)
    local titleStroke = Stroke(titleBox, 1, 0.4)

    New("TextLabel", {
        Parent = titleBox,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -24, 1, 0),
        BackgroundTransparency = 1,
        Text = titleText,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(240, 242, 248),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local contentFrame = New("Frame", {
        Parent = root,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(9, 10, 15),
        BackgroundTransparency = 0.5
    })
    Corner(contentFrame, 12)
    local contentStroke = Stroke(contentFrame, 1, 0.6)
    New("UIPadding", {
        Parent = contentFrame,
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    })

    -- Nút Back: quay lại menu chính (giữ cấu trúc: tab -> nội dung -> back -> các tab)
    backBtn.Activated:Connect(function()
        renderMainMenu()
    end)

    task.spawn(function()
        while root.Parent do
            local a = accent()
            backStroke.Color = a
            titleStroke.Color = a
            contentStroke.Color = a
            task.wait(0.2)
        end
    end)

    -- subContext kế thừa context gốc, thêm helper riêng cho module
    local subContext = setmetatable({
        Tab = Tab,
        Config = Config,
        ContentFrame = contentFrame,
        New = New,
        Corner = Corner,
        Stroke = Stroke,
        Tween = Tween,
        accent = accent,
        BackToMain = renderMainMenu,
    }, { __index = context })

    if type(builderFn) == "function" then
        local ok, unloadFn = pcall(builderFn, contentFrame, subContext)
        if ok and type(unloadFn) == "function" then
            currentUnload = unloadFn
        elseif not ok then
            warn("[FishHub] Module '" .. moduleKey .. "' lỗi khi build:", unloadFn)
            New("TextLabel", {
                Parent = contentFrame,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundTransparency = 1,
                Text = "Đã xảy ra lỗi khi tải module này.",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = Color3.fromRGB(200, 90, 90)
            })
        end
    end
end

-- ================= MODULE BUILDERS =================
-- Mỗi builder chỉ cần vẽ nội dung vào contentFrame. Back đã được xử lý sẵn ở
-- renderSubPage nên các module KHÔNG cần tự làm nút back nữa.

local function placeholderBuilder(labelText)
    return function(contentFrame, subContext)
        subContext.New("TextLabel", {
            Parent = contentFrame,
            Size = UDim2.new(1, 0, 0, 160),
            BackgroundTransparency = 1,
            Text = labelText,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(200, 205, 220),
            TextWrapped = true
        })
    end
end

ModuleBuilders["shop"] = {
    title = "SHOP",
    build = placeholderBuilder("Shop Content Items & Upgrades"),
}
ModuleBuilders["settingfarm"] = {
    title = "SETTING FARM",
    build = placeholderBuilder("Setting Farm Content"),
}
ModuleBuilders["farm"] = {
    title = "FARM",
    build = placeholderBuilder("Farm Content"),
}
ModuleBuilders["item"] = {
    title = "ITEM",
    build = placeholderBuilder("Item Content"),
}
ModuleBuilders["island"] = {
    title = "ISLAND",
    build = placeholderBuilder("Island Content"),
}
ModuleBuilders["fruit"] = {
    title = "FRUIT",
    build = placeholderBuilder("Fruit Content"),
}
ModuleBuilders["setting"] = {
    title = "SETTING",
    build = placeholderBuilder("FishHub Settings"),
}

-- ================= OPEN MODULE =================
openModule = function(moduleKey)
    local entry = ModuleBuilders[moduleKey]
    if not entry then
        warn("[FishHub] Không tìm thấy module:", moduleKey)
        return
    end
    renderSubPage(entry.title, moduleKey, entry.build)
end

-- Expose để tương thích ngược nếu file khác gọi context.LoadFunction("shop") v.v.
context.LoadFunction = function(key)
    if key == "function" or key == "Function" or key == nil then
        renderMainMenu()
    else
        openModule(key)
    end
end
context.Navigate = context.LoadFunction
context.BackToMain = renderMainMenu
context.OpenModule = openModule

-- Khởi động: hiển thị menu chính
renderMainMenu()

return {
    Root = Tab,
    BackToMain = renderMainMenu,
    OpenModule = openModule,
}
