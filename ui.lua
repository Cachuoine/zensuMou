local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
if not Player then
    Player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
end

local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

if PlayerGui:FindFirstChild("FishHub") then
    PlayerGui.FishHub:Destroy()
end

----------------------------------------------------------------------
-- DANH SÁCH GAME HỖ TRỢ THEO THỂ LOẠI
----------------------------------------------------------------------
local SupportedCategories = {
    {
        CategoryName = "⚔️ Anime & RPG",
        Games = {
            { Name = "Evomon", PlaceIds = {134381727982611} },
            { Name = "Blox Fruits", PlaceIds = {2753915549, 4442272183, 7449423635} },
			{ Name = "Haze", PlaceIds = {6918802270} }
        }
    },
    {
        CategoryName = "🎣 Adventure & Casual",
        Games = {
            { Name = "Fisch", PlaceIds = {16732694052} },
            { Name = "99 Nights in the Forest", PlaceIds = {79546208627805} },
        }
    },
    {
        CategoryName = "🎯 Action & Shooter",
        Games = {
            { Name = "Rivals", PlaceIds = {17625359962} },
        }
    },
    {
        CategoryName = "🚜 Simulator & Farming",
        Games = {
            { Name = "Grow a Garden 2", PlaceIds = {97598239454123} }
        }
    }
}

local CurrentPlaceId = game.PlaceId

----------------------------------------------------------------------
-- ĐỌC DỮ LIỆU KEY TỪ PHẦN GETKEY (FishHub_Key.json)
----------------------------------------------------------------------
local SavedKey = ""

if readfile and isfile and isfile("FishHub_Key.json") then
    pcall(function()
        local data = HttpService:JSONDecode(readfile("FishHub_Key.json"))
        if data then
            SavedKey = data.key or ""
        end
    end)
end

----------------------------------------------------------------------
-- CẤU HÌNH & CONFIG UI
----------------------------------------------------------------------
local Config = {
    MainWidth = 700,
    MainHeight = 480,
    MaxWidth = 1000,
    MaxHeight = 650,
    RainbowBorder = false,
    RainbowSpeed = 0.003,
    GUIAnimation = true,
    Language = "EN",
    ToggleKey = Enum.KeyCode.RightShift,
    
    MarqueeUserColor = Color3.fromRGB(0, 229, 255),      
    MarqueeExecutorColor = Color3.fromRGB(168, 85, 247), 
    MarqueeCreColor = Color3.fromRGB(255, 75, 75),       
    
    ThemeColor = Color3.fromRGB(0, 229, 255),       
    BgMain = Color3.fromRGB(16, 16, 20),           
    BgSidebar = Color3.fromRGB(11, 11, 14),        
    BgSidebarBtn = Color3.fromRGB(20, 20, 26),     
    BgSidebarBtnHover = Color3.fromRGB(30, 30, 40),
    BgCard = Color3.fromRGB(25, 25, 32),           
    BgCategory = Color3.fromRGB(20, 20, 26),       
    BorderColor = Color3.fromRGB(45, 45, 60),      
    
    ShowDebug = true
}

local MarqueeExtraConfig = {
    UseRainbowText = false,      
    RainbowSpeed = 0.002,       
    EnableBreathing = true,     
}

local Translations = {
    EN = {
        Title = "Script Collection",
        Home = "Home",
        Support = "Support Games",
        Setting = "Setting",
        SettingTitle = "Hub Settings",
        SupportTitle = "🎮 Supported Games List",
        
        CatAppearance = "🎨 Visual & Theme",
        CatFooterColors = "👤 Footer Text Colors",
        CatSystem = "⚙️ System & Controls",
        CatActions = "⚡ Quick Utilities",

        RainbowToggle = "🌈 Rainbow Border",
        RainbowDesc = "Enable/Disable continuous rainbow border effect.",
        SpeedToggle = "⚡ Rainbow Speed",
        SpeedDesc = "Cycle rainbow effect speed.",
        AnimToggle = "🎬 GUI Animation",
        AnimDesc = "Smooth open/close window transitions.",
        LangToggle = "🌐 Language",
        LangDesc = "Switch interface language.",
        KeybindTitle = "⌨️ Toggle Hotkey",
        KeybindDesc = "Click to set a new toggle hotkey.",
        ThemeTitle = "🎨 FishHub Theme",
        ThemeDesc = "Choose a custom color theme for FishHub UI.",
        DebugToggle = "📊 Debug Overlay",
        DebugDesc = "Display FPS, Ping, Memory, Players, Time and Key Status.",

        MarqueeUserTitle = "👤 User Text Color",
        MarqueeUserDesc = "Change text color for the User section.",
        MarqueeExecutorTitle = "⚡ Executor Text Color",
        MarqueeExecutorDesc = "Change text color for the Executor section.",
        MarqueeCreTitle = "👑 Creator Text Color",
        MarqueeCreDesc = "Change text color for the Creator (CRE) section.",

        RejoinBtn = "🔄 Rejoin Game",
        HopBtn = "🌐 Server Hop",
        CopyDiscordBtn = "📋 Copy Discord Link",
        RefreshUIBtn = "🧹 Clean & Reload UI",
        
        PressKey = "Press Key...",
        CloseConfirm = "Do you want to close FishHub?",
        Yes = "Yes",
        No = "No"
    },
    VN = {
        Title = "Bộ Sưu Tập Script",
        Home = "Trang Chủ",
        Support = "Game Hỗ Trợ",
        Setting = "Cài Đặt",
        SettingTitle = "Cài Đặt Bảng Điều Khiển",
        SupportTitle = "🎮 Danh Sách Game Hỗ Trợ",

        CatAppearance = "🎨 Giao Diện & Theme",
        CatFooterColors = "👤 Màu Chữ Dòng Chạy (Footer)",
        CatSystem = "⚙️ Hệ Thống & Phím Tắt",
        CatActions = "⚡ Công Cụ Nhanh",

        RainbowToggle = "🌈 Viền Cầu Vồng",
        RainbowDesc = "Bật/Tắt hiệu ứng chuyển màu viền liên tục.",
        SpeedToggle = "⚡ Tốc Độ Cầu Vồng",
        SpeedDesc = "Thay đổi tốc độ đổi màu.",
        AnimToggle = "🎬 Hiệu Ứng Mở/Đóng",
        AnimDesc = "Hiệu ứng thu phóng mượt mà khi bật/tắt UI.",
        LangToggle = "🌐 Ngôn Ngữ",
        LangDesc = "Chuyển đổi Tiếng Anh / Tiếng Việt.",
        KeybindTitle = "⌨️ Phím Tắt Ẩn/Hiện",
        KeybindDesc = "Nhấn để đổi phím mở giao diện.",
        ThemeTitle = "🎨 Giao Diện Chủ Đề",
        ThemeDesc = "Chọn màu chủ đề độc đáo cho giao diện FishHub.",
        DebugToggle = "📊 Bảng Debug Thông Số",
        DebugDesc = "Hiển thị FPS, Ping, Bộ nhớ, Người chơi, Giờ và Key.",

        MarqueeUserTitle = "👤 Màu Chữ Phần User",
        MarqueeUserDesc = "Đổi màu riêng cho phần tên User ở dòng chạy.",
        MarqueeExecutorTitle = "⚡ Màu Chữ Phần Executor",
        MarqueeExecutorDesc = "Đổi màu riêng cho phần Executor ở dòng chạy.",
        MarqueeCreTitle = "👑 Màu Chữ Phần Creator",
        MarqueeCreDesc = "Đổi màu riêng cho phần Creator (CRE) ở dòng chạy.",

        RejoinBtn = "🔄 Vào Lại Server",
        HopBtn = "🌐 Chuyển Server",
        CopyDiscordBtn = "📋 Copy Link Discord",
        RefreshUIBtn = "🧹 Tải Lại Giao Diện",

        PressKey = "Nhấn phím...",
        CloseConfirm = "Bạn có chắc muốn tắt FishHub không?",
        Yes = "Có",
        No = "Không"
    }
}

local function L(key)
    local lang = Config.Language
    if Translations[lang] and Translations[lang][key] then
        return Translations[lang][key]
    end
    return Translations["EN"][key] or key
end

local CurrentButton
local OpenHome, OpenSupport, OpenSettings
local OpenGUI, CloseGUI, ToggleMain
local RefreshUI

local gui = Instance.new("ScreenGui")
gui.Name = "FishHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

----------------------------------------------------------------------
-- MAIN HUB UI
----------------------------------------------------------------------
local openLine = Instance.new("Frame")
openLine.Parent = gui
openLine.Size = UDim2.new(0, 550, 0, 6)
openLine.Position = UDim2.new(0.5, 0, 0, 3)
openLine.AnchorPoint = Vector2.new(0.5, 0)
openLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
openLine.BackgroundTransparency = 0
openLine.BorderSizePixel = 0

Instance.new("UICorner", openLine).CornerRadius = UDim.new(1, 0)
local lineStroke = Instance.new("UIStroke")
lineStroke.Parent = openLine
lineStroke.Thickness = 2

task.spawn(function()
    local hue = 0
    while openLine and openLine.Parent do
        if Config.RainbowBorder then
            lineStroke.Color = Color3.fromHSV(hue, 1, 1)
        else
            lineStroke.Color = Config.ThemeColor
        end
        hue = hue + Config.RainbowSpeed
        if hue >= 1 then hue = 0 end
        RunService.RenderStepped:Wait()
    end
end)

local lineButton = Instance.new("TextButton")
lineButton.Parent = openLine
lineButton.Size = UDim2.fromScale(1, 1)
lineButton.BackgroundTransparency = 1
lineButton.Text = ""
lineButton.AutoButtonColor = false

lineButton.MouseButton1Click:Connect(function()
    ToggleMain()
end)

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Parent = gui
main.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Config.BgMain
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Visible = false

local mainScale = Instance.new("UIScale")
mainScale.Parent = main
mainScale.Scale = 1

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = main
mainStroke.Thickness = 2

task.spawn(function()
    local hue = 0
    while main and main.Parent do
        if Config.RainbowBorder then
            mainStroke.Color = Color3.fromHSV(hue, 1, 1)
        else
            mainStroke.Color = Config.ThemeColor
        end
        hue = hue + Config.RainbowSpeed
        if hue >= 1 then hue = 0 end
        RunService.RenderStepped:Wait()
    end
end)

local currentTween = nil
OpenGUI = function()
    if currentTween then currentTween:Cancel() end
    if not Config.GUIAnimation then
        main.Visible = true
        mainScale.Scale = 1
        main.BackgroundTransparency = 0
        return
    end
    
    main.Visible = true
    mainScale.Scale = 0.85
    main.BackgroundTransparency = 1
    
    currentTween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    local scaleTween = TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    })
    
    currentTween:Play()
    scaleTween:Play()
end

CloseGUI = function()
    if currentTween then currentTween:Cancel() end
    if not Config.GUIAnimation then
        main.Visible = false
        return
    end
    
    currentTween = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    local scaleTween = TweenService:Create(mainScale, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Scale = 0.85
    })
    
    currentTween:Play()
    scaleTween:Play()
    
    task.delay(0.25, function()
        if main and main.BackgroundTransparency >= 0.9 then
            main.Visible = false
            mainScale.Scale = 1
        end
    end)
end

ToggleMain = function()
    if main.Visible and main.BackgroundTransparency < 0.9 then
        CloseGUI()
    else
        OpenGUI()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Config.ToggleKey then
        ToggleMain()
    end
end)

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 1, 0)
title.RichText = true
title.Text = "⚓ <font color='#00E5FF'>FishHub</font> <font color='#808090'>┆</font> <font color='#A855F7'>Script Collection</font>"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Center

local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1, -20, 0, 1)
line.Position = UDim2.new(0, 10, 0, 45)
line.BackgroundColor3 = Config.BorderColor
line.BorderSizePixel = 0

local content = Instance.new("Frame")
content.Parent = main
content.Position = UDim2.new(0, 0, 0, 47)
content.Size = UDim2.new(1, 0, 1, -90)
content.BackgroundTransparency = 1

local discordBox = Instance.new("Frame")
discordBox.Parent = main
discordBox.Position = UDim2.new(0, 10, 1, -40)
discordBox.Size = UDim2.new(1, -20, 0, 35)
discordBox.BackgroundTransparency = 1
discordBox.ClipsDescendants = true

local avatar = Instance.new("ImageLabel")
avatar.Parent = discordBox
avatar.Size = UDim2.new(0, 26, 0, 26)
avatar.Position = UDim2.new(0, 6, 0.5, -13)
avatar.BackgroundTransparency = 1
avatar.ScaleType = Enum.ScaleType.Fit

task.spawn(function()
    pcall(function()
        if Player and Player.UserId then
            avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end
    end)
end)

local discordText = Instance.new("TextButton")
discordText.Parent = discordBox
discordText.Size = UDim2.new(0, 1200, 1, 0)
discordText.Position = UDim2.new(0, 42, 0, 0)
discordText.BackgroundTransparency = 1
discordText.Font = Enum.Font.GothamBold
discordText.TextSize = 13
discordText.TextColor3 = Color3.fromRGB(255, 255, 255)
discordText.RichText = true
discordText.TextXAlignment = Enum.TextXAlignment.Left
discordText.AutoButtonColor = false
discordText.Text = ""

local function ColorToHex(color)
    return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

task.spawn(function()
    local executor = "Unknown"
    pcall(function()
        if identifyexecutor then executor = identifyexecutor() end
    end)
    local username = Player and Player.Name or "User"
    
    local rainbowHue = 0
    local breathTimer = 0
    
    while gui and gui.Parent do
        local userHex = ColorToHex(Config.MarqueeUserColor)
        local execHex = ColorToHex(Config.MarqueeExecutorColor)
        local creHex = ColorToHex(Config.MarqueeCreColor)
        
        if MarqueeExtraConfig.UseRainbowText then
            local r1, g1, b1 = Color3.toHSV(Color3.fromHSV(rainbowHue, 1, 1))
            local r2, g2, b2 = Color3.toHSV(Color3.fromHSV((rainbowHue + 0.33) % 1, 1, 1))
            local r3, g3, b3 = Color3.toHSV(Color3.fromHSV((rainbowHue + 0.66) % 1, 1, 1))
            
            userHex = ColorToHex(Color3.fromHSV(r1, 1, 1))
            execHex = ColorToHex(Color3.fromHSV(r2, 1, 1))
            creHex = ColorToHex(Color3.fromHSV(r3, 1, 1))
            
            rainbowHue = rainbowHue + MarqueeExtraConfig.RainbowSpeed
            if rainbowHue >= 1 then rainbowHue = 0 end
        end

        if MarqueeExtraConfig.EnableBreathing then
            breathTimer = breathTimer + 0.05
            discordText.TextTransparency = 0.12 + (math.sin(breathTimer) * 0.12)
        else
            discordText.TextTransparency = 0
        end
        
        discordText.Text = string.format(
            "<font color='#00E5FF'>✦</font> <font color='#AAAAAA'>USER:</font> <font color='%s'><b>%s</b></font>  <font color='#505060'>|</font>  <font color='#00E5FF'>⚡</font> <font color='#AAAAAA'>EXECUTOR:</font> <font color='%s'><b>%s</b></font>  <font color='#505060'>|</font>  <font color='#00E5FF'>👑</font> <font color='#AAAAAA'>CRE:</font> <font color='%s'><b>DaoHuyLam</b></font> <font color='#00E5FF'>✦</font>", 
            userHex, username, execHex, executor, creHex
        )
        
        discordText.Position = UDim2.new(0, 42, 0, 0)
        local textWidth = discordText.TextBounds.X + 150
        discordText.Position = UDim2.new(0, discordBox.AbsoluteSize.X, 0, 0)
        
        local speed = 75
        local distance = discordBox.AbsoluteSize.X + textWidth
        local timeTaken = distance / speed
        
        local tween = TweenService:Create(discordText, TweenInfo.new(timeTaken, Enum.EasingStyle.Linear), {Position = UDim2.new(0, -textWidth, 0, 0)})
        tween:Play()
        
        while tween.PlaybackState == Enum.PlaybackState.Playing and gui and gui.Parent do
            task.wait(0.1)
        end
    end
end)

-- SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Parent = content
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.Size = UDim2.new(0, 190, 1, 0)
sidebar.BackgroundColor3 = Config.BgSidebar
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Parent = sidebar
sidebarStroke.Color = Config.BorderColor
sidebarStroke.Thickness = 1

local pageContainer = Instance.new("Frame")
pageContainer.Parent = content
pageContainer.Position = UDim2.new(0, 195, 0, 0)
pageContainer.Size = UDim2.new(1, -195, 1, 0)
pageContainer.BackgroundTransparency = 1

local Indicator = Instance.new("Frame")
Indicator.Parent = sidebar
Indicator.Size = UDim2.new(0, 3, 0, 38)
Indicator.Position = UDim2.new(0, 2, 0, 20)
Indicator.BackgroundColor3 = Config.ThemeColor
Indicator.BorderSizePixel = 0
Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

local function ClearContent()
    for _, v in ipairs(pageContainer:GetChildren()) do
        v:Destroy()
    end
end

OpenHome = function() ClearContent() end

----------------------------------------------------------------------
-- PHẦN SUPPORT GAME
----------------------------------------------------------------------
OpenSupport = function()
    ClearContent()

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = pageContainer
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 15, 0, 10)
    titleLbl.Size = UDim2.new(1, -30, 0, 25)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = L("SupportTitle")
    titleLbl.TextSize = 18
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local searchBox = Instance.new("TextBox")
    searchBox.Parent = pageContainer
    searchBox.Position = UDim2.new(0, 15, 0, 40)
    searchBox.Size = UDim2.new(1, -25, 0, 32)
    searchBox.BackgroundColor3 = Config.BgCategory
    searchBox.BorderSizePixel = 0
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "🔍 Search supported games..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
    searchBox.TextSize = 12
    searchBox.ClearTextOnFocus = false
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Parent = searchBox
    searchStroke.Color = Config.BorderColor
    searchStroke.Thickness = 1

    local searchPad = Instance.new("UIPadding")
    searchPad.Parent = searchBox
    searchPad.PaddingLeft = UDim.new(0, 12)

    local scrollHolder = Instance.new("ScrollingFrame")
    scrollHolder.Parent = pageContainer
    scrollHolder.Position = UDim2.new(0, 15, 0, 80)
    scrollHolder.Size = UDim2.new(1, -25, 1, -90)
    scrollHolder.BackgroundTransparency = 1
    scrollHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollHolder.ScrollBarThickness = 3
    scrollHolder.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = scrollHolder
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 14)

    local categoryFrames = {}

    for _, catData in ipairs(SupportedCategories) do
        local catFrame = Instance.new("Frame")
        catFrame.Parent = scrollHolder
        catFrame.Size = UDim2.new(1, -10, 0, 0)
        catFrame.AutomaticSize = Enum.AutomaticSize.Y
        catFrame.BackgroundColor3 = Config.BgCategory
        catFrame.BorderSizePixel = 0
        Instance.new("UICorner", catFrame).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = catFrame
        stroke.Color = Config.BorderColor
        stroke.Thickness = 1

        local catTitle = Instance.new("TextLabel")
        catTitle.Parent = catFrame
        catTitle.Position = UDim2.new(0, 12, 0, 10)
        catTitle.Size = UDim2.new(1, -24, 0, 20)
        catTitle.BackgroundTransparency = 1
        catTitle.Font = Enum.Font.GothamBold
        catTitle.Text = catData.CategoryName
        catTitle.TextSize = 13
        catTitle.TextColor3 = Config.ThemeColor
        catTitle.TextXAlignment = Enum.TextXAlignment.Left

        local gameGridContainer = Instance.new("Frame")
        gameGridContainer.Parent = catFrame
        gameGridContainer.Position = UDim2.new(0, 10, 0, 36)
        gameGridContainer.Size = UDim2.new(1, -20, 0, 0)
        gameGridContainer.BackgroundTransparency = 1
        gameGridContainer.AutomaticSize = Enum.AutomaticSize.Y

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = gameGridContainer
        gridLayout.CellSize = UDim2.new(0.485, 0, 0, 52)
        gridLayout.CellPadding = UDim2.new(0.03, 0, 0, 10)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local pad = Instance.new("UIPadding")
        pad.Parent = catFrame
        pad.PaddingTop = UDim.new(0, 36)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        local gameCards = {}

        for _, gameData in ipairs(catData.Games) do
            local isCurrentGame = false
            for _, id in ipairs(gameData.PlaceIds) do
                if id == CurrentPlaceId then
                    isCurrentGame = true
                    break
                end
            end

            local isWorking = (gameData.Name == "Evomon" or gameData.Name == "Blox Fruits")

            local card = Instance.new("Frame")
            card.Parent = gameGridContainer
            card.Size = UDim2.new(1, 0, 0, 52)
            card.BackgroundColor3 = isCurrentGame and Color3.fromRGB(28, 45, 65) or Config.BgCard
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Parent = card
            cardStroke.Thickness = isCurrentGame and 2 or 1
            cardStroke.Color = isCurrentGame and Config.ThemeColor or Config.BorderColor

            card.MouseEnter:Connect(function()
                if not isCurrentGame then
                    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 42)}):Play()
                    TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = Config.ThemeColor}):Play()
                end
            end)
            card.MouseLeave:Connect(function()
                if not isCurrentGame then
                    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgCard}):Play()
                    TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = Config.BorderColor}):Play()
                end
            end)

            local gameTitle = Instance.new("TextLabel")
            gameTitle.Parent = card
            gameTitle.Position = UDim2.new(0, 12, 0, 6)
            gameTitle.Size = UDim2.new(1, -20, 0, 18)
            gameTitle.BackgroundTransparency = 1
            gameTitle.Font = Enum.Font.GothamBold
            gameTitle.Text = gameData.Name
            gameTitle.TextSize = 11.5
            gameTitle.TextColor3 = isCurrentGame and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 230)
            gameTitle.TextXAlignment = Enum.TextXAlignment.Left
            gameTitle.TextTruncate = Enum.TextTruncate.AtEnd

            local badge = Instance.new("Frame")
            badge.Parent = card
            badge.Size = UDim2.new(0, 85, 0, 18)
            badge.Position = UDim2.new(0, 12, 0, 28)
            badge.BackgroundColor3 = isWorking and Color3.fromRGB(20, 60, 35) or Color3.fromRGB(60, 20, 20)
            badge.BorderSizePixel = 0
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)

            local circleGreenRed = Instance.new("Frame")
            circleGreenRed.Parent = badge
            circleGreenRed.Size = UDim2.new(0, 6, 0, 6)
            circleGreenRed.Position = UDim2.new(0, 6, 0.5, -3)
            circleGreenRed.BackgroundColor3 = isWorking and Color3.fromRGB(50, 230, 80) or Color3.fromRGB(230, 50, 50)
            circleGreenRed.BorderSizePixel = 0
            Instance.new("UICorner", circleGreenRed).CornerRadius = UDim.new(1, 0)

            task.spawn(function()
                while circleGreenRed and circleGreenRed.Parent do
                    TweenService:Create(circleGreenRed, TweenInfo.new(0.6), {BackgroundTransparency = 0.2}):Play()
                    task.wait(0.6)
                    TweenService:Create(circleGreenRed, TweenInfo.new(0.6), {BackgroundTransparency = 0.8}):Play()
                    task.wait(0.6)
                end
            end)

            local badgeText = Instance.new("TextLabel")
            badgeText.Parent = badge
            badgeText.Size = UDim2.new(1, -14, 1, 0)
            badgeText.Position = UDim2.new(0, 14, 0, 0)
            badgeText.BackgroundTransparency = 1
            badgeText.Font = Enum.Font.GothamBold
            badgeText.Text = isWorking and "WORKING" or "OFFLINE"
            badgeText.TextSize = 8.5
            badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
            badgeText.TextXAlignment = Enum.TextXAlignment.Center

            table.insert(gameCards, {Card = card, Name = string.lower(gameData.Name)})
        end

        table.insert(categoryFrames, {Frame = catFrame, Cards = gameCards})
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        for _, cat in ipairs(categoryFrames) do
            local visibleCount = 0
            for _, gCard in ipairs(cat.Cards) do
                if query == "" or string.find(gCard.Name, query) then
                    gCard.Card.Visible = true
                    visibleCount = visibleCount + 1
                else
                    gCard.Card.Visible = false
                end
            end
            cat.Frame.Visible = (visibleCount > 0)
        end
    end)
end

----------------------------------------------------------------------
-- CỬA SỔ SETTINGS
----------------------------------------------------------------------
OpenSettings = function()
    ClearContent()

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = pageContainer
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 15, 0, 10)
    titleLbl.Size = UDim2.new(1, -30, 0, 25)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = L("SettingTitle")
    titleLbl.TextSize = 18
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local settingsHolder = Instance.new("ScrollingFrame")
    settingsHolder.Parent = pageContainer
    settingsHolder.Position = UDim2.new(0, 15, 0, 40)
    settingsHolder.Size = UDim2.new(1, -25, 1, -50)
    settingsHolder.BackgroundTransparency = 1
    settingsHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsHolder.ScrollBarThickness = 3
    settingsHolder.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = settingsHolder
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 12)

    local function CreateCategory(categoryTitle)
        local categoryFrame = Instance.new("Frame")
        categoryFrame.Parent = settingsHolder
        categoryFrame.Size = UDim2.new(1, -10, 0, 0)
        categoryFrame.AutomaticSize = Enum.AutomaticSize.Y
        categoryFrame.BackgroundColor3 = Config.BgCategory
        categoryFrame.BorderSizePixel = 0
        Instance.new("UICorner", categoryFrame).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = categoryFrame
        stroke.Color = Config.BorderColor
        stroke.Thickness = 1

        local catLabel = Instance.new("TextLabel")
        catLabel.Parent = categoryFrame
        catLabel.Position = UDim2.new(0, 12, 0, 8)
        catLabel.Size = UDim2.new(1, -24, 0, 20)
        catLabel.BackgroundTransparency = 1
        catLabel.Font = Enum.Font.GothamBold
        catLabel.Text = categoryTitle
        catLabel.TextSize = 13
        catLabel.TextColor3 = Config.ThemeColor
        catLabel.TextXAlignment = Enum.TextXAlignment.Left

        local catList = Instance.new("UIListLayout")
        catList.Parent = categoryFrame
        catList.SortOrder = Enum.SortOrder.LayoutOrder
        catList.Padding = UDim.new(0, 8)

        local pad = Instance.new("UIPadding")
        pad.Parent = categoryFrame
        pad.PaddingTop = UDim.new(0, 32)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        return categoryFrame
    end

    local function CreateSettingToggle(parent, name, desc, configKey, callback)
        local card = Instance.new("Frame")
        card.Parent = parent
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Config.BgCard
        card.BorderSizePixel = 0
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = card
        nameLbl.Position = UDim2.new(0, 10, 0, 6)
        nameLbl.Size = UDim2.new(1, -85, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = name
        nameLbl.TextSize = 12
        nameLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local descLbl = Instance.new("TextLabel")
        descLbl.Parent = card
        descLbl.Position = UDim2.new(0, 10, 0, 24)
        descLbl.Size = UDim2.new(1, -85, 0, 18)
        descLbl.BackgroundTransparency = 1
        descLbl.Font = Enum.Font.Gotham
        descLbl.Text = desc
        descLbl.TextSize = 10
        descLbl.TextColor3 = Color3.fromRGB(140, 140, 150)
        descLbl.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = card
        toggleBtn.Size = UDim2.new(0, 65, 0, 28)
        toggleBtn.Position = UDim2.new(1, -75, 0.5, -14)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        toggleBtn.Text = ""
        toggleBtn.AutoButtonColor = false
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

        local toggleStroke = Instance.new("UIStroke")
        toggleStroke.Parent = toggleBtn
        toggleStroke.Color = Config.BorderColor
        toggleStroke.Thickness = 1

        local dot = Instance.new("Frame")
        dot.Parent = toggleBtn
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 8, 0.5, -4)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local statusText = Instance.new("TextLabel")
        statusText.Parent = toggleBtn
        statusText.Size = UDim2.new(1, -20, 1, 0)
        statusText.Position = UDim2.new(0, 18, 0, 0)
        statusText.BackgroundTransparency = 1
        statusText.Font = Enum.Font.GothamBold
        statusText.TextSize = 10
        statusText.TextXAlignment = Enum.TextXAlignment.Center

        local function updateVisual(isActive)
            if isActive then
                statusText.Text = "ON"
                statusText.TextColor3 = Color3.fromRGB(50, 230, 80)
            else
                statusText.Text = "OFF"
                statusText.TextColor3 = Color3.fromRGB(230, 50, 50)
            end
        end

        updateVisual(Config[configKey])

        task.spawn(function()
            while dot and dot.Parent do
                local active = Config[configKey]
                local targetColor = active and Color3.fromRGB(50, 230, 80) or Color3.fromRGB(230, 50, 50)
                
                TweenService:Create(dot, TweenInfo.new(0.5), {
                    BackgroundColor3 = targetColor,
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(0, 8, 0.5, -5)
                }):Play()
                task.wait(0.5)

                TweenService:Create(dot, TweenInfo.new(0.5), {
                    BackgroundColor3 = active and Color3.fromRGB(20, 140, 50) or Color3.fromRGB(140, 20, 20),
                    Size = UDim2.new(0, 7, 0, 7),
                    Position = UDim2.new(0, 9.5, 0.5, -3.5)
                }):Play()
                task.wait(0.5)
            end
        end)

        toggleBtn.MouseButton1Click:Connect(function()
            Config[configKey] = not Config[configKey]
            updateVisual(Config[configKey])
            if callback then callback(Config[configKey]) end
        end)
    end

    local function CreateColorPickerRow(parent, name, desc, configKey)
        local card = Instance.new("Frame")
        card.Parent = parent
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Config.BgCard
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = card
        nameLbl.Position = UDim2.new(0, 10, 0, 6)
        nameLbl.Size = UDim2.new(1, -120, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = name
        nameLbl.TextSize = 12
        nameLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local descLbl = Instance.new("TextLabel")
        descLbl.Parent = card
        descLbl.Position = UDim2.new(0, 10, 0, 24)
        descLbl.Size = UDim2.new(1, -120, 0, 18)
        descLbl.BackgroundTransparency = 1
        descLbl.Font = Enum.Font.Gotham
        descLbl.Text = desc
        descLbl.TextSize = 10
        descLbl.TextColor3 = Color3.fromRGB(140, 140, 150)
        descLbl.TextXAlignment = Enum.TextXAlignment.Left

        local colorBtn = Instance.new("TextButton")
        colorBtn.Parent = card
        colorBtn.Size = UDim2.new(0, 100, 0, 28)
        colorBtn.Position = UDim2.new(1, -110, 0.5, -14)
        colorBtn.BackgroundColor3 = Config[configKey]
        colorBtn.Text = "🎨 Pick Color"
        colorBtn.Font = Enum.Font.GothamBold
        colorBtn.TextSize = 10
        colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)

        local colStroke = Instance.new("UIStroke")
        colStroke.Parent = colorBtn
        colStroke.Color = Config.BorderColor
        colStroke.Thickness = 1

        local dropdown = Instance.new("Frame")
        dropdown.Parent = parent
        dropdown.Size = UDim2.new(1, 0, 0, 0)
        dropdown.AutomaticSize = Enum.AutomaticSize.Y
        dropdown.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        dropdown.Visible = false
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

        local dropStroke = Instance.new("UIStroke")
        dropStroke.Parent = dropdown
        dropStroke.Color = Config.BorderColor
        dropStroke.Thickness = 1

        local grid = Instance.new("UIGridLayout")
        grid.Parent = dropdown
        grid.CellSize = UDim2.new(0, 70, 0, 52)
        grid.CellPadding = UDim2.new(0, 8, 0, 8)
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local pad = Instance.new("UIPadding")
        pad.Parent = dropdown
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        local palette = {
            { Name = "Cyan Neon", Color = Color3.fromRGB(0, 229, 255) },
            { Name = "Royal Blue", Color = Color3.fromRGB(0, 150, 255) },
            { Name = "Emerald", Color = Color3.fromRGB(50, 215, 75) },
            { Name = "Mint Green", Color = Color3.fromRGB(74, 222, 128) },
            { Name = "Purple", Color = Color3.fromRGB(168, 85, 247) },
            { Name = "Pink Neon", Color = Color3.fromRGB(236, 72, 153) },
            { Name = "Ruby Red", Color = Color3.fromRGB(255, 75, 75) },
            { Name = "Fire Orange", Color = Color3.fromRGB(255, 159, 10) },
            { Name = "Gold Yellow", Color = Color3.fromRGB(255, 215, 0) },
            { Name = "Pure White", Color = Color3.fromRGB(255, 255, 255) },
            { Name = "Silver Gray", Color = Color3.fromRGB(156, 163, 175) },
            { Name = "Dark Gray", Color = Color3.fromRGB(100, 100, 110) }
        }

        for _, item in ipairs(palette) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Parent = dropdown
            itemFrame.BackgroundTransparency = 1
            itemFrame.Size = UDim2.new(0, 70, 0, 52)

            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = itemFrame
            itemBtn.Size = UDim2.new(0, 32, 0, 32)
            itemBtn.Position = UDim2.new(0.5, -16, 0, 0)
            itemBtn.BackgroundColor3 = item.Color
            itemBtn.Text = ""
            itemBtn.AutoButtonColor = false
            Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(1, 0)

            local itemName = Instance.new("TextLabel")
            itemName.Parent = itemFrame
            itemName.Size = UDim2.new(1, 0, 0, 16)
            itemName.Position = UDim2.new(0, 0, 0, 34)
            itemName.BackgroundTransparency = 1
            itemName.Font = Enum.Font.GothamBold
            itemName.Text = item.Name
            itemName.TextSize = 9
            itemName.TextColor3 = Color3.fromRGB(180, 180, 190)
            itemName.TextXAlignment = Enum.TextXAlignment.Center

            itemBtn.MouseButton1Click:Connect(function()
                Config[configKey] = item.Color
                colorBtn.BackgroundColor3 = item.Color
                dropdown.Visible = false
            end)
        end

        colorBtn.MouseButton1Click:Connect(function()
            dropdown.Visible = not dropdown.Visible
        end)
    end

    local appearanceCat = CreateCategory(L("CatAppearance"))
    CreateSettingToggle(appearanceCat, L("RainbowToggle"), L("RainbowDesc"), "RainbowBorder")
    CreateSettingToggle(appearanceCat, L("AnimToggle"), L("AnimDesc"), "GUIAnimation")

    local themeCard = Instance.new("Frame")
    themeCard.Parent = appearanceCat
    themeCard.Size = UDim2.new(1, 0, 0, 48)
    themeCard.BackgroundColor3 = Config.BgCard
    Instance.new("UICorner", themeCard).CornerRadius = UDim.new(0, 8)

    local themeLbl = Instance.new("TextLabel")
    themeLbl.Parent = themeCard
    themeLbl.Position = UDim2.new(0, 10, 0, 6)
    themeLbl.Size = UDim2.new(1, -120, 0, 18)
    themeLbl.BackgroundTransparency = 1
    themeLbl.Font = Enum.Font.GothamBold
    themeLbl.Text = L("ThemeTitle")
    themeLbl.TextSize = 12
    themeLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    themeLbl.TextXAlignment = Enum.TextXAlignment.Left

    local themeDesc = Instance.new("TextLabel")
    themeDesc.Parent = themeCard
    themeDesc.Position = UDim2.new(0, 10, 0, 24)
    themeDesc.Size = UDim2.new(1, -120, 0, 18)
    themeDesc.BackgroundTransparency = 1
    themeDesc.Font = Enum.Font.Gotham
    themeDesc.Text = L("ThemeDesc")
    themeDesc.TextSize = 10
    themeDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
    themeDesc.TextXAlignment = Enum.TextXAlignment.Left

    local themeToggleBtn = Instance.new("TextButton")
    themeToggleBtn.Parent = themeCard
    themeToggleBtn.Size = UDim2.new(0, 100, 0, 28)
    themeToggleBtn.Position = UDim2.new(1, -110, 0.5, -14)
    themeToggleBtn.BackgroundColor3 = Config.ThemeColor
    themeToggleBtn.Text = "🎨 Select Color"
    themeToggleBtn.Font = Enum.Font.GothamBold
    themeToggleBtn.TextSize = 10
    themeToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", themeToggleBtn).CornerRadius = UDim.new(0, 6)

    local themeToggleStroke = Instance.new("UIStroke")
    themeToggleStroke.Parent = themeToggleBtn
    themeToggleStroke.Color = Config.BorderColor
    themeToggleStroke.Thickness = 1

    local themeDropdown = Instance.new("Frame")
    themeDropdown.Parent = appearanceCat
    themeDropdown.Size = UDim2.new(1, 0, 0, 0)
    themeDropdown.AutomaticSize = Enum.AutomaticSize.Y
    themeDropdown.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    themeDropdown.Visible = false
    Instance.new("UICorner", themeDropdown).CornerRadius = UDim.new(0, 8)

    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Parent = themeDropdown
    dropdownStroke.Color = Config.BorderColor
    dropdownStroke.Thickness = 1

    local dropdownGrid = Instance.new("UIGridLayout")
    dropdownGrid.Parent = themeDropdown
    dropdownGrid.CellSize = UDim2.new(0, 70, 0, 52)
    dropdownGrid.CellPadding = UDim2.new(0, 8, 0, 8)
    dropdownGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local dropdownPad = Instance.new("UIPadding")
    dropdownPad.Parent = themeDropdown
    dropdownPad.PaddingTop = UDim.new(0, 10)
    dropdownPad.PaddingBottom = UDim.new(0, 10)
    dropdownPad.PaddingLeft = UDim.new(0, 10)
    dropdownPad.PaddingRight = UDim.new(0, 10)

    local themeList = {
        { Name = "Cyan Neon", Color = Color3.fromRGB(0, 229, 255) },
        { Name = "Royal Blue", Color = Color3.fromRGB(0, 150, 255) },
        { Name = "Deep Ocean", Color = Color3.fromRGB(10, 80, 200) },
        { Name = "Emerald", Color = Color3.fromRGB(50, 215, 75) },
        { Name = "Mint Green", Color = Color3.fromRGB(74, 222, 128) },
        { Name = "Purple", Color = Color3.fromRGB(168, 85, 247) },
        { Name = "Lavender", Color = Color3.fromRGB(192, 132, 252) },
        { Name = "Pink Neon", Color = Color3.fromRGB(236, 72, 153) },
        { Name = "Rose Pink", Color = Color3.fromRGB(251, 113, 133) },
        { Name = "Ruby Red", Color = Color3.fromRGB(255, 75, 75) },
        { Name = "Fire Orange", Color = Color3.fromRGB(255, 159, 10) },
        { Name = "Sunset Orange", Color = Color3.fromRGB(249, 115, 22) },
        { Name = "Gold Yellow", Color = Color3.fromRGB(255, 215, 0) },
        { Name = "Cyber Yellow", Color = Color3.fromRGB(234, 179, 8) },
        { Name = "Pure White", Color = Color3.fromRGB(255, 255, 255) },
        { Name = "Silver Gray", Color = Color3.fromRGB(156, 163, 175) }
    }

    for _, item in ipairs(themeList) do
        local colorItemFrame = Instance.new("Frame")
        colorItemFrame.Parent = themeDropdown
        colorItemFrame.BackgroundTransparency = 1
        colorItemFrame.Size = UDim2.new(0, 70, 0, 52)

        local colBtn = Instance.new("TextButton")
        colBtn.Parent = colorItemFrame
        colBtn.Size = UDim2.new(0, 32, 0, 32)
        colBtn.Position = UDim2.new(0.5, -16, 0, 0)
        colBtn.BackgroundColor3 = item.Color
        colBtn.Text = ""
        colBtn.AutoButtonColor = false
        Instance.new("UICorner", colBtn).CornerRadius = UDim.new(1, 0)

        local nameText = Instance.new("TextLabel")
        nameText.Parent = colorItemFrame
        nameText.Size = UDim2.new(1, 0, 0, 16)
        nameText.Position = UDim2.new(0, 0, 0, 34)
        nameText.BackgroundTransparency = 1
        nameText.Font = Enum.Font.GothamBold
        nameText.Text = item.Name
        nameText.TextSize = 9
        nameText.TextColor3 = Color3.fromRGB(180, 180, 190)
        nameText.TextXAlignment = Enum.TextXAlignment.Center

        colBtn.MouseButton1Click:Connect(function()
            Config.ThemeColor = item.Color
            themeToggleBtn.BackgroundColor3 = item.Color
            themeDropdown.Visible = false
            RefreshUI()
        end)
    end

    themeToggleBtn.MouseButton1Click:Connect(function()
        themeDropdown.Visible = not themeDropdown.Visible
    end)

    local footerColorsCat = CreateCategory(L("CatFooterColors"))
    CreateColorPickerRow(footerColorsCat, L("MarqueeUserTitle"), L("MarqueeUserDesc"), "MarqueeUserColor")
    CreateColorPickerRow(footerColorsCat, L("MarqueeExecutorTitle"), L("MarqueeExecutorDesc"), "MarqueeExecutorColor")
    CreateColorPickerRow(footerColorsCat, L("MarqueeCreTitle"), L("MarqueeCreDesc"), "MarqueeCreColor")

    local systemCat = CreateCategory(L("CatSystem"))
    CreateSettingToggle(systemCat, L("DebugToggle"), L("DebugDesc"), "ShowDebug", function(val)
        if debugSidebarFrame then
            debugSidebarFrame.Visible = val
        end
        if keyStatusSidebarFrame then
            keyStatusSidebarFrame.Visible = val
        end
    end)

    local keyCard = Instance.new("Frame")
    keyCard.Parent = systemCat
    keyCard.Size = UDim2.new(1, 0, 0, 48)
    keyCard.BackgroundColor3 = Config.BgCard
    Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 8)

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Parent = keyCard
    keyLbl.Position = UDim2.new(0, 10, 0, 6)
    keyLbl.Size = UDim2.new(1, -110, 0, 18)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.Text = L("KeybindTitle")
    keyLbl.TextSize = 12
    keyLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    keyLbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyDesc = Instance.new("TextLabel")
    keyDesc.Parent = keyCard
    keyDesc.Position = UDim2.new(0, 10, 0, 24)
    keyDesc.Size = UDim2.new(1, -110, 0, 18)
    keyDesc.BackgroundTransparency = 1
    keyDesc.Font = Enum.Font.Gotham
    keyDesc.Text = L("KeybindDesc")
    keyDesc.TextSize = 10
    keyDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
    keyDesc.TextXAlignment = Enum.TextXAlignment.Left

    local keyBtn = Instance.new("TextButton")
    keyBtn.Parent = keyCard
    keyBtn.Size = UDim2.new(0, 90, 0, 24)
    keyBtn.Position = UDim2.new(1, -100, 0.5, -12)
    keyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    keyBtn.Text = Config.ToggleKey.Name
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 11
    keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

    keyBtn.MouseButton1Click:Connect(function()
        keyBtn.Text = L("PressKey")
        keyBtn.BackgroundColor3 = Config.ThemeColor
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Config.ToggleKey = input.KeyCode
                keyBtn.Text = input.KeyCode.Name
                keyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                conn:Disconnect()
            end
        end)
    end)

    local langCard = Instance.new("Frame")
    langCard.Parent = systemCat
    langCard.Size = UDim2.new(1, 0, 0, 48)
    langCard.BackgroundColor3 = Config.BgCard
    Instance.new("UICorner", langCard).CornerRadius = UDim.new(0, 8)

    local langLbl = Instance.new("TextLabel")
    langLbl.Parent = langCard
    langLbl.Position = UDim2.new(0, 10, 0, 6)
    langLbl.Size = UDim2.new(1, -110, 0, 18)
    langLbl.BackgroundTransparency = 1
    langLbl.Font = Enum.Font.GothamBold
    langLbl.Text = L("LangToggle")
    langLbl.TextSize = 12
    langLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    langLbl.TextXAlignment = Enum.TextXAlignment.Left

    local langDesc = Instance.new("TextLabel")
    langDesc.Parent = langCard
    langDesc.Position = UDim2.new(0, 10, 0, 24)
    langDesc.Size = UDim2.new(1, -110, 0, 18)
    langDesc.BackgroundTransparency = 1
    langDesc.Font = Enum.Font.Gotham
    langDesc.Text = L("LangDesc")
    langDesc.TextSize = 10
    langDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
    langDesc.TextXAlignment = Enum.TextXAlignment.Left

    local langBtn = Instance.new("TextButton")
    langBtn.Parent = langCard
    langBtn.Size = UDim2.new(0, 90, 0, 24)
    langBtn.Position = UDim2.new(1, -100, 0.5, -12)
    langBtn.BackgroundColor3 = Config.ThemeColor
    langBtn.Text = Config.Language == "EN" and "ENGLISH" or "TIẾNG VIỆT"
    langBtn.Font = Enum.Font.GothamBold
    langBtn.TextSize = 10
    langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)

    langBtn.MouseButton1Click:Connect(function()
        Config.Language = (Config.Language == "EN") and "VN" or "EN"
        RefreshUI()
    end)

    local actionCat = CreateCategory(L("CatActions"))

    local gridFrame = Instance.new("Frame")
    gridFrame.Parent = actionCat
    gridFrame.Size = UDim2.new(1, 0, 0, 65)
    gridFrame.BackgroundTransparency = 1

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = gridFrame
    gridLayout.CellSize = UDim2.new(0.48, 0, 0, 28)
    gridLayout.CellPadding = UDim2.new(0.03, 0, 0, 6)

    local function CreateActionButton(btnText, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = gridFrame
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        btn.Text = btnText
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Parent = btn
        btnStroke.Color = Config.BorderColor
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(callback)
    end

    CreateActionButton(L("RejoinBtn"), function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
        end)
    end)

    CreateActionButton(L("HopBtn"), function()
        pcall(function()
            local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local body = game:GetService("HttpService"):JSONDecode(req)
            if body and body.data then
                for _, s in ipairs(body.data) do
                    if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                        break
                    end
                end
            end
        end)
    end)

    CreateActionButton(L("CopyDiscordBtn"), function()
        pcall(function()
            if setclipboard then setclipboard("https://discord.gg/2tTJxRk2ct") end
        end)
    end)

    CreateActionButton(L("RefreshUIBtn"), function()
        RefreshUI()
    end)
end

local SideButtons = {}

local function CreateSideButton(textKey, y, image)
    local btn = Instance.new("TextButton")
    btn.Parent = sidebar
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = Config.BgSidebarBtn
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        if CurrentButton ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtnHover}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentButton ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtn}):Play()
        end
    end)

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Parent = btn
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.Position = UDim2.new(0, 8, 0.5, -2.5)
    dot.BackgroundColor3 = Config.ThemeColor
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        while dot and dot.Parent do
            TweenService:Create(dot, TweenInfo.new(0.6), {BackgroundTransparency = 0.2, Size = UDim2.new(0, 7, 0, 7), Position = UDim2.new(0, 7, 0.5, -3.5)}):Play()
            task.wait(0.6)
            TweenService:Create(dot, TweenInfo.new(0.6), {BackgroundTransparency = 0.8, Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(0, 8.5, 0.5, -2)}):Play()
            task.wait(0.6)
        end
    end)

    local icon = Instance.new("ImageLabel")
    icon.Parent = btn
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 18, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = image
    icon.ImageColor3 = Color3.fromRGB(200, 200, 215)
    icon.ScaleType = Enum.ScaleType.Fit

    local lbl = Instance.new("TextLabel")
    lbl.Parent = btn
    lbl.Name = "Label"
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 42, 0, 0)
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Text = L(textKey)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11.5
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(SideButtons, {Button = btn, Key = textKey, Dot = dot, Icon = icon, Label = lbl})
    return btn
end

local HomeBtn = CreateSideButton("Home", 18, "rbxassetid://108029482244357")
local SupportBtn = CreateSideButton("Support", 64, "rbxassetid://86514728032684")
local SettingBtn = CreateSideButton("Setting", 110, "rbxassetid://99627454901549")

----------------------------------------------------------------------
-- DEBUG OVERLAY (Đã canh chỉnh đồng bộ lề ngang 5px)
----------------------------------------------------------------------
debugSidebarFrame = Instance.new("Frame")
debugSidebarFrame.Name = "DebugSidebar"
debugSidebarFrame.Parent = sidebar
debugSidebarFrame.Size = UDim2.new(1, -10, 0, 112)
debugSidebarFrame.Position = UDim2.new(0, 5, 1, -178)
debugSidebarFrame.BackgroundColor3 = Config.BgCard
debugSidebarFrame.BackgroundTransparency = 0
debugSidebarFrame.BorderSizePixel = 0
debugSidebarFrame.Visible = Config.ShowDebug

Instance.new("UICorner", debugSidebarFrame).CornerRadius = UDim.new(0, 8)

local debugSidebarStroke = Instance.new("UIStroke")
debugSidebarStroke.Parent = debugSidebarFrame
debugSidebarStroke.Thickness = 1
debugSidebarStroke.Color = Config.BorderColor

local debugSidebarText = Instance.new("TextLabel")
debugSidebarText.Parent = debugSidebarFrame
debugSidebarText.Size = UDim2.new(1, -6, 1, -6)
debugSidebarText.Position = UDim2.new(0, 3, 0, 3)
debugSidebarText.BackgroundTransparency = 1
debugSidebarText.Font = Enum.Font.Code
debugSidebarText.TextSize = 10
debugSidebarText.TextColor3 = Color3.fromRGB(240, 240, 240)
debugSidebarText.TextXAlignment = Enum.TextXAlignment.Left
debugSidebarText.TextYAlignment = Enum.TextYAlignment.Top
debugSidebarText.RichText = true

----------------------------------------------------------------------
-- KEY STATUS (Đồng bộ lề chuẩn với Debug)
----------------------------------------------------------------------
keyStatusSidebarFrame = Instance.new("Frame")
keyStatusSidebarFrame.Name = "KeyStatusSidebar"
keyStatusSidebarFrame.Parent = sidebar
keyStatusSidebarFrame.Size = UDim2.new(1, -10, 0, 54)
keyStatusSidebarFrame.Position = UDim2.new(0, 5, 1, -64)
keyStatusSidebarFrame.BackgroundColor3 = Config.BgCard
keyStatusSidebarFrame.BackgroundTransparency = 0
keyStatusSidebarFrame.BorderSizePixel = 0
keyStatusSidebarFrame.Visible = Config.ShowDebug

Instance.new("UICorner", keyStatusSidebarFrame).CornerRadius = UDim.new(0, 8)

local keyStatusStroke = Instance.new("UIStroke")
keyStatusStroke.Parent = keyStatusSidebarFrame
keyStatusStroke.Thickness = 1
keyStatusStroke.Color = Config.BorderColor

local keyStatusTitle = Instance.new("TextLabel")
keyStatusTitle.Parent = keyStatusSidebarFrame
keyStatusTitle.Size = UDim2.new(1, -12, 0, 16)
keyStatusTitle.Position = UDim2.new(0, 8, 0, 4)
keyStatusTitle.BackgroundTransparency = 1
keyStatusTitle.Font = Enum.Font.GothamBold
keyStatusTitle.TextSize = 10
keyStatusTitle.TextColor3 = Color3.fromRGB(0, 180, 255)
keyStatusTitle.Text = "KEY STATUS"
keyStatusTitle.TextXAlignment = Enum.TextXAlignment.Left

local keyInnerCard = Instance.new("Frame")
keyInnerCard.Parent = keyStatusSidebarFrame
keyInnerCard.Size = UDim2.new(1, -12, 0, 26)
keyInnerCard.Position = UDim2.new(0, 6, 0, 22)
keyInnerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
keyInnerCard.BorderSizePixel = 0
Instance.new("UICorner", keyInnerCard).CornerRadius = UDim.new(0, 6)

local greenDotKey = Instance.new("Frame")
greenDotKey.Parent = keyInnerCard
greenDotKey.Size = UDim2.new(0, 8, 0, 8)
greenDotKey.Position = UDim2.new(0, 8, 0.5, -4)
greenDotKey.BackgroundColor3 = Color3.fromRGB(50, 230, 80)
greenDotKey.BorderSizePixel = 0
Instance.new("UICorner", greenDotKey).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while greenDotKey and greenDotKey.Parent do
        TweenService:Create(greenDotKey, TweenInfo.new(0.6), {BackgroundTransparency = 0.2}):Play()
        task.wait(0.6)
        TweenService:Create(greenDotKey, TweenInfo.new(0.6), {BackgroundTransparency = 0.8}):Play()
        task.wait(0.6)
    end
end)

local keyNameLabel = Instance.new("TextLabel")
keyNameLabel.Parent = keyInnerCard
keyNameLabel.Size = UDim2.new(0, 80, 1, 0)
keyNameLabel.Position = UDim2.new(0, 22, 0, 0)
keyNameLabel.BackgroundTransparency = 1
keyNameLabel.Font = Enum.Font.GothamBold
keyNameLabel.TextSize = 11
keyNameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
keyNameLabel.Text = "RightShift"
keyNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local keyActiveLabel = Instance.new("TextLabel")
keyActiveLabel.Parent = keyInnerCard
keyActiveLabel.Size = UDim2.new(1, -100, 1, 0)
keyActiveLabel.Position = UDim2.new(0, 95, 0, 0)
keyActiveLabel.BackgroundTransparency = 1
keyActiveLabel.Font = Enum.Font.GothamBold
keyActiveLabel.TextSize = 10
keyActiveLabel.TextColor3 = Color3.fromRGB(50, 230, 80)
keyActiveLabel.Text = "LOADING..."
keyActiveLabel.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    if SavedKey == "DHL22052009" then
        keyActiveLabel.Text = "LIFETIME"
        keyActiveLabel.TextColor3 = Color3.fromRGB(255, 215, 0) 
    elseif SavedKey ~= "" then
        local url = "https://fishhub-35d18-default-rtdb.firebaseio.com/keys/" .. SavedKey .. ".json"
        local success, response = pcall(function() return game:HttpGet(url) end)
        
        if success and response ~= "null" then
            local data = HttpService:JSONDecode(response)
            local createdAtSec = math.floor(data.createdAt / 1000)
            local expireTime = createdAtSec + 86400 
            
            while gui and gui.Parent do
                local currentTime = os.time()
                local timeRemaining = expireTime - currentTime
                
                if timeRemaining > 0 then
                    local h = math.floor(timeRemaining / 3600)
                    local m = math.floor((timeRemaining % 3600) / 60)
                    local s = timeRemaining % 60
                    keyActiveLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
                    keyActiveLabel.TextColor3 = Color3.fromRGB(50, 230, 80) 
                else
                    keyActiveLabel.Text = "EXPIRED!"
                    keyActiveLabel.TextColor3 = Color3.fromRGB(230, 50, 50) 
                    break
                end
                task.wait(1)
            end
        else
            keyActiveLabel.Text = "NO KEY"
            keyActiveLabel.TextColor3 = Color3.fromRGB(230, 50, 50)
        end
    else
        keyActiveLabel.Text = "NO KEY"
        keyActiveLabel.TextColor3 = Color3.fromRGB(230, 50, 50)
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        if Config.ToggleKey then
            keyNameLabel.Text = Config.ToggleKey.Name
        end
        task.wait(1)
    end
end)

local frameCount = 0
local lastFpsUpdate = os.clock()
local currentFps = 60

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = os.clock()
    if now - lastFpsUpdate >= 1 then
        currentFps = math.floor(frameCount / (now - lastFpsUpdate))
        frameCount = 0
        lastFpsUpdate = now
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        if Config.ShowDebug then
            local ping = 0
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            local memoryUsage = 0
            pcall(function()
                memoryUsage = math.floor(StatsService:GetTotalMemoryUsageMb())
            end)

            local time24h = os.date("%H:%M:%S")
            local playerCount = #Players:GetPlayers()
            local maxPlayers = Players.MaxPlayers

            debugSidebarText.Text = string.format(
                "⚡ <b>FPS:</b> %d\n" ..
                "📶 <b>PING:</b> %dms\n" ..
                "💾 <b>MEM:</b> %dMB\n" ..
                "👥 <b>PLAYERS:</b> <font color='#FFDF00'>%d/%d</font>\n" ..
                "🕒 <b>TIME:</b> %s",
                currentFps, ping, memoryUsage, playerCount, maxPlayers, time24h
            )
        end
        task.wait(0.5)
    end
end)

local function SelectButton(btn)
    if CurrentButton == btn then return end
    
    if CurrentButton then
        TweenService:Create(CurrentButton, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtn}):Play()
        for _, item in ipairs(SideButtons) do
            if item.Button == CurrentButton then
                TweenService:Create(item.Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 230)}):Play()
            end
        end
    end

    CurrentButton = btn
    
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtnHover}):Play()
    for _, item in ipairs(SideButtons) do
        if item.Button == btn then
            TweenService:Create(item.Label, TweenInfo.new(0.2), {TextColor3 = Config.ThemeColor}):Play()
        end
    end

    TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0, btn.Position.Y.Offset)}):Play()
end

HomeBtn.MouseButton1Click:Connect(function() SelectButton(HomeBtn); OpenHome() end)
SupportBtn.MouseButton1Click:Connect(function() SelectButton(SupportBtn); OpenSupport() end)
SettingBtn.MouseButton1Click:Connect(function() SelectButton(SettingBtn); OpenSettings() end)

RefreshUI = function()
    Indicator.BackgroundColor3 = Config.ThemeColor
    sidebar.BackgroundColor3 = Config.BgSidebar
    sidebarStroke.Color = Config.BorderColor

    for _, item in ipairs(SideButtons) do
        item.Button.Label.Text = L(item.Key)
        if item.Dot then
            item.Dot.BackgroundColor3 = Config.ThemeColor
        end
        if CurrentButton == item.Button then
            item.Label.TextColor3 = Config.ThemeColor
        end
    end

    if CurrentButton == HomeBtn then OpenHome()
    elseif CurrentButton == SupportBtn then OpenSupport()
    elseif CurrentButton == SettingBtn then OpenSettings() end
end

local function CreateCircleButton(text, xOffset)
    local btn = Instance.new("TextButton")
    btn.Parent = main
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, -xOffset, 0, 8)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local closeBtn = CreateCircleButton("×", 12)
local hideBtn  = CreateCircleButton("─", 44)

local confirm = Instance.new("Frame")
confirm.Parent = gui
confirm.Size = UDim2.new(0, 300, 0, 130)
confirm.Position = UDim2.new(0.5, 0, 0.5, 0)
confirm.AnchorPoint = Vector2.new(0.5, 0.5)
confirm.BackgroundColor3 = Config.BgMain
confirm.Visible = false
confirm.BorderSizePixel = 0
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)

local confirmStroke = Instance.new("UIStroke")
confirmStroke.Parent = confirm
confirmStroke.Color = Config.BorderColor
confirmStroke.Thickness = 1

local txt = Instance.new("TextLabel")
txt.Parent = confirm
txt.Size = UDim2.new(1, -20, 0, 40)
txt.Position = UDim2.new(0, 10, 0, 15)
txt.BackgroundTransparency = 1
txt.Font = Enum.Font.GothamBold
txt.TextSize = 13
txt.TextColor3 = Color3.fromRGB(240, 240, 240)
txt.TextWrapped = true

local yes = Instance.new("TextButton")
yes.Parent = confirm
yes.Size = UDim2.new(0.38, 0, 0, 30)
yes.Position = UDim2.new(0.08, 0, 1, -40)
yes.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
yes.TextColor3 = Color3.new(1, 1, 1)
yes.Font = Enum.Font.GothamBold
yes.TextSize = 12
Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 6)

local no = Instance.new("TextButton")
no.Parent = confirm
no.Size = UDim2.new(0.38, 0, 0, 30)
no.Position = UDim2.new(0.54, 0, 1, -40)
no.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
no.TextColor3 = Color3.new(1, 1, 1)
no.Font = Enum.Font.GothamBold
no.TextSize = 12
Instance.new("UICorner", no).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    txt.Text = L("CloseConfirm")
    yes.Text = L("Yes")
    no.Text = L("No")
    confirm.Visible = true
end)

yes.MouseButton1Click:Connect(function() gui:Destroy() end)
no.MouseButton1Click:Connect(function() confirm.Visible = false end)
hideBtn.MouseButton1Click:Connect(function() CloseGUI() end)

SelectButton(HomeBtn)
OpenHome()
OpenGUI()
