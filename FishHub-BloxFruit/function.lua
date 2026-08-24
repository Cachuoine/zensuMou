--[[
    FishHub / Function Tab
    ------------------------------------------------------------
    This file is intentionally self-contained inside the existing
    Function tab supplied by Main.lua.

    Main.lua should load this file with:
        local result = chunk(context)

    where context.Tab is the existing Function ScrollingFrame.

    IMPORTANT:
    - No ScreenGui is created here.
    - No MainWindow is created here.
    - No tabs outside Function are created here.
    - The seven S1 modules are loaded only into the selected
      sub-tab content frame.
]]

return function(context)
    assert(type(context) == "table", "Function.lua: missing context")
    assert(context.Tab, "Function.lua: context.Tab is required")

    local Players = context.Players or game:GetService("Players")
    local TweenService = context.TweenService or game:GetService("TweenService")
    local UserInputService = context.UserInputService or game:GetService("UserInputService")
    local HttpService = context.HttpService or game:GetService("HttpService")
    local Config = context.Config or {}
    local root = context.Tab

    local THEME_FALLBACK = Config.ThemeColor or Color3.fromRGB(0, 229, 255)
    local BG = Color3.fromRGB(20, 21, 29)
    local CARD = Color3.fromRGB(28, 30, 40)
    local CARD_HOVER = Color3.fromRGB(36, 39, 52)
    local TEXT = Color3.fromRGB(238, 240, 248)
    local MUTED = Color3.fromRGB(145, 150, 165)

    -- Re-initialization guard: Main can reload Function.lua after
    -- a theme/settings refresh. Destroy only our own content.
    local old = root:FindFirstChild("FishHubFunctionRoot")
    if old then
        old:Destroy()
    end

    root.BackgroundTransparency = 1
    root.ScrollBarThickness = 0
    root.CanvasSize = UDim2.new(0, 0, 0, 0)

    local function Accent()
        return Config.ThemeColor or THEME_FALLBACK
    end

    local function New(className, parent, props)
        local obj = Instance.new(className)
        obj.Parent = parent
        for k, v in pairs(props or {}) do
            obj[k] = v
        end
        return obj
    end

    local function Corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
        return c
    end

    local function Stroke(parent, thickness)
        local s = Instance.new("UIStroke")
        s.Thickness = thickness or 1
        s.Color = Accent()
        s.Transparency = 0.15
        s.Parent = parent
        return s
    end

    local rootFrame = New("Frame", root, {
        Name = "FishHubFunctionRoot",
        Size = UDim2.new(1, -2, 0, 360),
        Position = UDim2.new(0, 1, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })

    local title = New("TextLabel", rootFrame, {
        Name = "FunctionTitle",
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        Text = "FUNCTION",
        TextColor3 = TEXT,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local subtitle = New("TextLabel", rootFrame, {
        Name = "FunctionSubtitle",
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 10, 0, 27),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        Text = "Select a category",
        TextColor3 = MUTED,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local separator = New("Frame", rootFrame, {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 51),
        BackgroundColor3 = Accent(),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
    })

    local menu = New("ScrollingFrame", rootFrame, {
        Name = "FunctionMenu",
        Size = UDim2.new(1, -20, 1, -62),
        Position = UDim2.new(0, 10, 0, 61),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })

    local menuLayout = New("UIListLayout", menu, {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    New("UIPadding", menu, {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 8),
    })

    local moduleView = New("Frame", rootFrame, {
        Name = "FunctionModuleView",
        Size = UDim2.new(1, -20, 1, -62),
        Position = UDim2.new(0, 10, 0, 61),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
    })

    local topbar = New("Frame", moduleView, {
        Name = "ModuleTopbar",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })

    local backButton = New("TextButton", topbar, {
        Name = "BackButton",
        Size = UDim2.new(0, 36, 0, 30),
        Position = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "‹",
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Accent(),
    })
    Corner(backButton, 8)
    local backStroke = Stroke(backButton, 1)

    local search = New("TextBox", topbar, {
        Name = "SearchBox",
        Size = UDim2.new(1, -44, 0, 30),
        Position = UDim2.new(0, 44, 0, 3),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        Text = "",
        PlaceholderText = "search...",
        PlaceholderColor3 = MUTED,
        TextColor3 = TEXT,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Corner(search, 8)
    local searchStroke = Stroke(search, 1)

    local searchIcon = New("TextLabel", search, {
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        Text = "⌕",
        TextColor3 = Accent(),
        ZIndex = 4,
    })

    local searchPadding = New("UIPadding", search, {
        PaddingLeft = UDim.new(0, 28),
        PaddingRight = UDim.new(0, 8),
    })

    local moduleTitle = New("TextLabel", moduleView, {
        Name = "ModuleTitle",
        Size = UDim2.new(1, -2, 0, 22),
        Position = UDim2.new(0, 1, 0, 39),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Text = "",
        TextColor3 = TEXT,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local moduleContent = New("ScrollingFrame", moduleView, {
        Name = "ModuleContent",
        Size = UDim2.new(1, 0, 1, -66),
        Position = UDim2.new(0, 0, 0, 64),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Accent(),
        ScrollBarImageTransparency = 0.2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })

    local modulePadding = New("UIPadding", moduleContent, {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 4),
    })

    local modules = {
        {name = "SHOP",        url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/shop.lua"},
        {name = "SETTING FARM",url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/settingfarm.lua"},
        {name = "FARM",        url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/farm.lua"},
        {name = "ITEM",        url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/item.lua"},
        {name = "ISLAND",      url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/island.lua"},
        {name = "FRUIT",       url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/fruit.lua"},
        {name = "SETTING",     url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/setting.lua"},
    }

    local menuButtons = {}
    local loaded = {}
    local loading = {}
    local currentModule = nil
    local currentSourceObjects = {}

    local function ClearModuleContent()
        for _, child in ipairs(moduleContent:GetChildren()) do
            if not child:IsA("UIPadding") and not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
        table.clear(currentSourceObjects)
    end

    local function ApplyTheme()
        local accent = Accent()
        separator.BackgroundColor3 = accent
        searchIcon.TextColor3 = accent
        backButton.TextColor3 = accent
        backStroke.Color = accent
        searchStroke.Color = accent
        moduleContent.ScrollBarImageColor3 = accent
        title.TextColor3 = TEXT

        for _, button in pairs(menuButtons) do
            local stroke = button:FindFirstChild("AccentStroke")
            local glow = button:FindFirstChild("Glow")
            if stroke then stroke.Color = accent end
            if glow then glow.BackgroundColor3 = accent end
            button.TextColor3 = button:GetAttribute("Selected") and Color3.fromRGB(18, 20, 26) or TEXT
            button.BackgroundColor3 = button:GetAttribute("Selected") and accent or CARD
        end
    end

    local function SetButtonSelected(name, selected)
        local button = menuButtons[name]
        if not button then return end

        button:SetAttribute("Selected", selected)

        local accent = Accent()
        local stroke = button:FindFirstChild("AccentStroke")
        local glow = button:FindFirstChild("Glow")

        TweenService:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundColor3 = selected and accent or CARD,
            TextColor3 = selected and Color3.fromRGB(18, 20, 26) or TEXT,
        }):Play()

        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.18), {
                Color = accent,
                Transparency = selected and 0 or 0.55,
                Thickness = selected and 1.5 or 1,
            }):Play()
        end

        if glow then
            TweenService:Create(glow, TweenInfo.new(0.18), {
                BackgroundColor3 = accent,
                BackgroundTransparency = selected and 0.9 or 1,
            }):Play()
        end
    end

    local function MakeModuleContext(info)
        return {
            Player = Players.LocalPlayer,
            Players = Players,
            PlayerGui = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),
            TweenService = TweenService,
            UserInputService = UserInputService,
            HttpService = HttpService,
            Config = Config,

            -- CRITICAL:
            -- This is the selected module's content frame.
            -- S1 scripts MUST build their UI here instead of creating
            -- a new ScreenGui/MainWindow.
            Tab = moduleContent,
            Content = moduleContent,
            Parent = moduleContent,

            MainWindow = context.MainWindow,
            Main = context.Main,
            Gui = context.Gui,

            ModuleName = info.name,
            ModuleUrl = info.url,
            TabName = "Function",
            ShowNotification = context.ShowNotification,

            ThemeColor = function()
                return Accent()
            end,

            GetThemeColor = function()
                return Accent()
            end,

            IsRainbowEnabled = function()
                return Config.RainbowEnabled == true or Config.Rainbow == true
            end,
        }
    end

    local function ExecuteRemoteModule(info)
        if loading[info.name] then return end

        loading[info.name] = true
        ClearModuleContent()

        local loadingLabel = New("TextLabel", moduleContent, {
            Name = "ModuleLoading",
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            Text = "Loading " .. info.name .. "...",
            TextColor3 = MUTED,
        })
        table.insert(currentSourceObjects, loadingLabel)

        task.spawn(function()
            local ok, result = pcall(function()
                local source = game:HttpGet(info.url)
                assert(type(source) == "string" and #source > 10, "empty remote source")

                local chunk, compileError = loadstring(source)
                assert(type(chunk) == "function", "compile error: " .. tostring(compileError))

                local moduleContext = MakeModuleContext(info)
                local returned = chunk(moduleContext)

                -- Support:
                -- 1. return function(context)
                -- 2. direct chunk(context)
                if type(returned) == "function" then
                    local innerOk, innerResult = pcall(returned, moduleContext)
                    if not innerOk then
                        error(innerResult)
                    end
                    return innerResult
                end

                return returned
            end)

            loading[info.name] = nil

            if not ok then
                warn("[FishHub] " .. info.name .. " failed: " .. tostring(result))
                ClearModuleContent()

                local errorCard = New("TextLabel", moduleContent, {
                    Name = "ModuleError",
                    Size = UDim2.new(1, -8, 0, 52),
                    BackgroundColor3 = CARD,
                    BackgroundTransparency = 0.1,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 10,
                    TextWrapped = true,
                    Text = info.name .. " failed to load.\n" .. tostring(result),
                    TextColor3 = Color3.fromRGB(255, 125, 125),
                })
                Corner(errorCard, 8)
                local errorStroke = Stroke(errorCard, 1)
                errorStroke.Color = Color3.fromRGB(190, 70, 70)

                if context.ShowNotification then
                    context.ShowNotification(info.name .. " failed to load.")
                end
                return
            end

            loaded[info.name] = true
            ApplyTheme()
        end)
    end

    local function ShowModule(info)
        currentModule = info
        menu.Visible = false
        moduleView.Visible = true
        moduleTitle.Text = info.name
        subtitle.Text = "Function  /  " .. info.name

        search.Text = ""
        ClearModuleContent()

        for _, item in ipairs(modules) do
            SetButtonSelected(item.name, item.name == info.name)
        end

        if loaded[info.name] then
            -- Reloading isn't necessary. The module remains inside the
            -- selected Function sub-view.
            return
        end

        ExecuteRemoteModule(info)
    end

    local function ShowMenu()
        currentModule = nil
        moduleView.Visible = false
        menu.Visible = true
        subtitle.Text = "Select a category"
        search.Text = ""

        for _, item in ipairs(modules) do
            SetButtonSelected(item.name, false)
        end
    end

    backButton.MouseButton1Click:Connect(function()
        ShowMenu()
    end)

    backButton.MouseEnter:Connect(function()
        local accent = Accent()
        TweenService:Create(backButton, TweenInfo.new(0.15), {
            BackgroundColor3 = CARD_HOVER,
        }):Play()
        backButton.TextColor3 = accent
    end)

    backButton.MouseLeave:Connect(function()
        TweenService:Create(backButton, TweenInfo.new(0.15), {
            BackgroundColor3 = CARD,
        }):Play()
    end)

    local function SearchRemoteContent(query)
        query = string.lower(query or "")

        for _, obj in ipairs(currentSourceObjects) do
            if obj and obj.Parent then
                local text = ""
                pcall(function()
                    text = tostring(obj.Text or "")
                end)

                if query == "" then
                    obj.Visible = true
                else
                    obj.Visible = string.find(string.lower(text), query, 1, true) ~= nil
                end
            end
        end

        -- Also search objects directly created by S1 scripts under
        -- moduleContent. This does not touch MainWindow or other tabs.
        for _, obj in ipairs(moduleContent:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("TextLabel") or obj:IsA("TextBox") then
                local text = tostring(obj.Text or obj.PlaceholderText or "")
                if query == "" then
                    obj.Visible = true
                else
                    obj.Visible = string.find(string.lower(text), query, 1, true) ~= nil
                end
            end
        end
    end

    search:GetPropertyChangedSignal("Text"):Connect(function()
        if moduleView.Visible then
            SearchRemoteContent(search.Text)
        end
    end)

    search.Focused:Connect(function()
        TweenService:Create(searchStroke, TweenInfo.new(0.15), {
            Color = Accent(),
            Transparency = 0,
        }):Play()
    end)

    search.FocusLost:Connect(function()
        TweenService:Create(searchStroke, TweenInfo.new(0.15), {
            Color = Accent(),
            Transparency = 0.15,
        }):Play()
    end)

    for index, info in ipairs(modules) do
        local button = New("TextButton", menu, {
            Name = info.name:gsub("%s+", ""),
            LayoutOrder = index,
            Size = UDim2.new(1, -4, 0, 42),
            BackgroundColor3 = CARD,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            Text = info.name,
            TextColor3 = TEXT,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        Corner(button, 9)

        local padding = New("UIPadding", button, {
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 12),
        })

        local icon = New("TextLabel", button, {
            Size = UDim2.new(0, 26, 1, 0),
            Position = UDim2.new(1, -32, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Text = "›",
            TextColor3 = Accent(),
            TextXAlignment = Enum.TextXAlignment.Center,
        })

        local glow = New("Frame", button, {
            Name = "Glow",
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Accent(),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = button.ZIndex - 1,
        })
        Corner(glow, 9)

        local stroke = Stroke(button, 1)
        stroke.Name = "AccentStroke"
        stroke.Transparency = 0.55

        menuButtons[info.name] = button

        button.MouseEnter:Connect(function()
            local accent = Accent()
            icon.TextColor3 = accent
            TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quint), {
                BackgroundColor3 = button:GetAttribute("Selected") and accent or CARD_HOVER,
            }):Play()
            TweenService:Create(glow, TweenInfo.new(0.16), {
                BackgroundTransparency = button:GetAttribute("Selected") and 0.9 or 0.95,
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.16), {
                Color = accent,
                Transparency = 0.1,
            }):Play()
        end)

        button.MouseLeave:Connect(function()
            local selected = button:GetAttribute("Selected") == true
            TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quint), {
                BackgroundColor3 = selected and Accent() or CARD,
                TextColor3 = selected and Color3.fromRGB(18, 20, 26) or TEXT,
            }):Play()
            TweenService:Create(glow, TweenInfo.new(0.16), {
                BackgroundTransparency = selected and 0.9 or 1,
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.16), {
                Color = Accent(),
                Transparency = selected and 0 or 0.55,
            }):Play()
        end)

        button.MouseButton1Click:Connect(function()
            ShowModule(info)
        end)
    end

    -- Rainbow/theme watcher. It changes ONLY Function-owned objects.
    task.spawn(function()
        while rootFrame and rootFrame.Parent do
            local accent = Accent()

            separator.BackgroundColor3 = accent
            backButton.TextColor3 = accent
            searchIcon.TextColor3 = accent
            searchStroke.Color = accent
            backStroke.Color = accent
            moduleContent.ScrollBarImageColor3 = accent

            for _, button in pairs(menuButtons) do
                local stroke = button:FindFirstChild("AccentStroke")
                local glow = button:FindFirstChild("Glow")
                local icon = button:FindFirstChildWhichIsA("TextLabel")
                if stroke then stroke.Color = accent end
                if glow then glow.BackgroundColor3 = accent end
                if icon then icon.TextColor3 = accent end
                if button:GetAttribute("Selected") then
                    button.BackgroundColor3 = accent
                end
            end

            task.wait(0.08)
        end
    end)

    -- Keep menu canvas correct after resizing.
    menu:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        menu.CanvasSize = UDim2.new(0, 0, 0, menuLayout.AbsoluteContentSize.Y + 10)
    end)

    menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        menu.CanvasSize = UDim2.new(0, 0, 0, menuLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Initial state: Function shows its own seven categories.
    ShowMenu()
    ApplyTheme()

    return {
        Root = rootFrame,
        Menu = menu,
        ModuleView = moduleView,
        ModuleContent = moduleContent,

        OpenModule = function(name)
            for _, info in ipairs(modules) do
                if info.name == name then
                    ShowModule(info)
                    return true
                end
            end
            return false
        end,

        Back = ShowMenu,

        RefreshTheme = ApplyTheme,

        Destroy = function()
            if rootFrame and rootFrame.Parent then
                rootFrame:Destroy()
            end
        end,
    }
end
