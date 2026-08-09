--[[ 
    FishHub - Updated with moving flow lines & Settings UI + Player Info & Welcome Home UI (Aligned Stats)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer
if not Player then
    Player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
end
local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end
if PlayerGui:FindFirstChild("FishHub") then
    PlayerGui.FishHub:Destroy()
end

local SavedKey = ""
if readfile and isfile and isfile("FishHub_Key.json") then
    pcall(function()
        local data = HttpService:JSONDecode(readfile("FishHub_Key.json"))
        if data then
            SavedKey = data.key or ""
        end
    end)
end

local Config = {
    MainWidth = 700,
    MainHeight = 480,
    RainbowBorder = false,
    RainbowSpeed = 0.003,
    GUIAnimation = true,
    Language = "EN",
    ToggleKey = Enum.KeyCode.K,
    ThemeColor = Color3.fromRGB(0, 229, 255),       
    BgMain = Color3.fromRGB(45, 45, 52),           
    BgCard = Color3.fromRGB(55, 55, 65),           
    BorderColor = Color3.fromRGB(90, 90, 110),     
    ShowDebug = true,
    UITransparency = 0.25,     
    DebugTransparency = 0.25   
}

local Translations = {
    EN = {
        CloseConfirm = "Do you want to close FishHub?",
        Yes = "Yes",
        No = "No"
    },
    VN = {
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

local OpenGUI, CloseGUI, ToggleMain
local gui = Instance.new("ScreenGui")
gui.Name = "FishHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

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
main.BackgroundTransparency = Config.UITransparency
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

-- ==================== TẠO SETTINGS UI BÊN CẠNH (PHẢI) ====================
local settingsWindow = Instance.new("Frame")
settingsWindow.Name = "SettingsWindow"
settingsWindow.Parent = gui
settingsWindow.Size = UDim2.new(0, 220, 0, Config.MainHeight)
settingsWindow.AnchorPoint = Vector2.new(0, 0.5)
settingsWindow.BackgroundColor3 = Config.BgMain
settingsWindow.BackgroundTransparency = Config.UITransparency
settingsWindow.BorderSizePixel = 0
settingsWindow.Visible = false

local settingsScale = Instance.new("UIScale")
settingsScale.Parent = settingsWindow
settingsScale.Scale = 1
Instance.new("UICorner", settingsWindow).CornerRadius = UDim.new(0, 14)
local settingsStroke = Instance.new("UIStroke")
settingsStroke.Parent = settingsWindow
settingsStroke.Thickness = 2

task.spawn(function()
    local hue = 0
    while settingsWindow and settingsWindow.Parent do
        if Config.RainbowBorder then
            settingsStroke.Color = Color3.fromHSV(hue, 1, 1)
        else
            settingsStroke.Color = Config.ThemeColor
        end
        hue = hue + Config.RainbowSpeed
        if hue >= 1 then hue = 0 end
        RunService.RenderStepped:Wait()
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        if main.Visible then
            settingsWindow.Position = UDim2.new(0.5, (Config.MainWidth / 2) + 10, 0.5, 0)
        end
        task.wait()
    end
end)

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Parent = settingsWindow
settingsTitle.Size = UDim2.new(1, 0, 0, 46)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙ Settings"
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 16
settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Center

local settingsLine = Instance.new("Frame")
settingsLine.Parent = settingsWindow
settingsLine.Size = UDim2.new(1, -20, 0, 1)
settingsLine.Position = UDim2.new(0, 10, 0, 45)
settingsLine.BackgroundColor3 = Config.BorderColor
settingsLine.BorderSizePixel = 0

local settingsContent = Instance.new("TextLabel")
settingsContent.Parent = settingsWindow
settingsContent.Size = UDim2.new(1, -20, 1, -60)
settingsContent.Position = UDim2.new(0, 10, 0, 55)
settingsContent.BackgroundTransparency = 1
settingsContent.Text = "Cài đặt bổ sung sẽ hiển thị ở đây."
settingsContent.Font = Enum.Font.Gotham
settingsContent.TextSize = 13
settingsContent.TextColor3 = Color3.fromRGB(200, 200, 200)
settingsContent.TextWrapped = true
settingsContent.TextYAlignment = Enum.TextYAlignment.Top

local function ToggleSettings()
    if settingsWindow.Visible then
        settingsWindow.Visible = false
    else
        settingsWindow.Visible = true
    end
end
-- =========================================================================

local currentTween = nil
OpenGUI = function()
    if currentTween then currentTween:Cancel() end
    if not Config.GUIAnimation then
        main.Visible = true
        mainScale.Scale = 1
        main.BackgroundTransparency = Config.UITransparency
        return
    end
    main.Visible = true
    mainScale.Scale = 0.85
    main.BackgroundTransparency = 1
    currentTween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = Config.UITransparency
    })
    local scaleTween = TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    })
    currentTween:Play()
    scaleTween:Play()
end

CloseGUI = function()
    if currentTween then currentTween:Cancel() end
    settingsWindow.Visible = false
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

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Config.ToggleKey then
        ToggleMain()
    end
end)

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundTransparency = 1
header.ClipsDescendants = true 

local middleSeparator = Instance.new("TextLabel")
middleSeparator.Parent = header
middleSeparator.BackgroundTransparency = 1
middleSeparator.Size = UDim2.new(0, 50, 1, 0)
middleSeparator.Position = UDim2.new(0.5, -25, 0, 0)
middleSeparator.RichText = true
middleSeparator.Text = "<font color='#808090'>┆</font>"
middleSeparator.Font = Enum.Font.GothamBold
middleSeparator.TextSize = 18
middleSeparator.TextColor3 = Color3.fromRGB(255, 255, 255)
middleSeparator.TextXAlignment = Enum.TextXAlignment.Center

local leftTitle = Instance.new("TextLabel")
leftTitle.Parent = header
leftTitle.BackgroundTransparency = 1
leftTitle.Size = UDim2.new(0.5, -15, 1, 0)
leftTitle.RichText = true
leftTitle.Text = "⚓ <font color='#00E5FF'>FishHub</font>"
leftTitle.Font = Enum.Font.GothamBold
leftTitle.TextSize = 18
leftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
leftTitle.TextXAlignment = Enum.TextXAlignment.Right

local gameName = "Roblox Game"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local rightTitle = Instance.new("TextLabel")
rightTitle.Parent = header
rightTitle.BackgroundTransparency = 1
rightTitle.Size = UDim2.new(0.5, -15, 1, 0)
rightTitle.RichText = true
rightTitle.Text = "<font color='#A855F7'>" .. gameName .. "</font>"
rightTitle.Font = Enum.Font.GothamBold
rightTitle.TextSize = 18
rightTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
rightTitle.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while header and header.Parent do
        leftTitle.Position = UDim2.new(0, -400, 0, 0)
        rightTitle.Position = UDim2.new(0.5, 400, 0, 0)
        
        local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local t1 = TweenService:Create(leftTitle, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
        local t2 = TweenService:Create(rightTitle, tweenInfo, {Position = UDim2.new(0.5, 15, 0, 0)})
        t1:Play()
        t2:Play()
        
        task.wait(2.5)
    end
end)

local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1, -20, 0, 1)
line.Position = UDim2.new(0, 10, 0, 45)
line.BackgroundColor3 = Config.BorderColor
line.BorderSizePixel = 0

local function AddHoverGlow(card, stroke)
    card.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Config.ThemeColor}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Config.BorderColor}):Play()
    end)
end

local navContainer = Instance.new("Frame")
navContainer.Parent = main
navContainer.Size = UDim2.new(0, 320, 0, 32)
navContainer.Position = UDim2.new(0.5, 0, 0, 52)
navContainer.AnchorPoint = Vector2.new(0.5, 0)
navContainer.BackgroundTransparency = 1

local navLayout = Instance.new("UIListLayout")
navLayout.Parent = navContainer
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
navLayout.Padding = UDim.new(0, 10)

local leftFlowLabel = Instance.new("TextLabel")
leftFlowLabel.Parent = main
leftFlowLabel.Size = UDim2.new(0, 0, 0, 32)
leftFlowLabel.Position = UDim2.new(0, 10, 0, 52)
leftFlowLabel.BackgroundTransparency = 1
leftFlowLabel.Font = Enum.Font.Code
leftFlowLabel.TextSize = 14
leftFlowLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
leftFlowLabel.TextXAlignment = Enum.TextXAlignment.Right
leftFlowLabel.TextYAlignment = Enum.TextYAlignment.Center
leftFlowLabel.ClipsDescendants = true

local rightFlowLabel = Instance.new("TextLabel")
rightFlowLabel.Parent = main
rightFlowLabel.Size = UDim2.new(0, 0, 0, 32)
rightFlowLabel.Position = UDim2.new(0, 0, 0, 52)
rightFlowLabel.BackgroundTransparency = 1
rightFlowLabel.Font = Enum.Font.Code
rightFlowLabel.TextSize = 14
rightFlowLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
rightFlowLabel.TextXAlignment = Enum.TextXAlignment.Left
rightFlowLabel.TextYAlignment = Enum.TextYAlignment.Center
rightFlowLabel.ClipsDescendants = true

task.spawn(function()
    while main and main.Parent do
        local maxLeftWidth = math.max(10, main.AbsoluteSize.X / 2 - navContainer.AbsoluteSize.X / 2 - 15)
        local maxRightWidth = math.max(10, main.AbsoluteSize.X / 2 - navContainer.AbsoluteSize.X / 2 - 15)
        
        leftFlowLabel.Size = UDim2.new(0, maxLeftWidth, 0, 32)
        rightFlowLabel.Size = UDim2.new(0, maxRightWidth, 0, 32)
        rightFlowLabel.Position = UDim2.new(0.5, navContainer.AbsoluteSize.X / 2 + 5, 0, 52)

        local totalChars = math.floor(maxLeftWidth / 8)
        
        for i = 0, totalChars do
            if not main or not main.Parent then break end
            leftFlowLabel.Text = string.rep("=", i) .. ">"
            rightFlowLabel.Text = "<" .. string.rep("=", i)
            task.wait(0.08)
        end
    end
end)

local contentContainer = Instance.new("Frame")
contentContainer.Parent = main
contentContainer.Size = UDim2.new(1, -20, 1, -95)
contentContainer.Position = UDim2.new(0, 10, 0, 90)
contentContainer.BackgroundTransparency = 1

local tabs = {}
local tabButtons = {}

local function CreateTabContent(name)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name .. "Tab"
    tabFrame.Parent = contentContainer
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.Visible = false
    tabFrame.ScrollBarThickness = 4
    
    if name == "Home" then
        local homeLayout = Instance.new("UIListLayout")
        homeLayout.Parent = tabFrame
        homeLayout.SortOrder = Enum.SortOrder.LayoutOrder
        homeLayout.Padding = UDim.new(0, 12)

        -- 1. WELCOME BANNER CARD (Chào mừng trải nghiệm script và game)
        local welcomeCard = Instance.new("Frame")
        welcomeCard.Parent = tabFrame
        welcomeCard.Size = UDim2.new(1, 0, 0, 75)
        welcomeCard.BackgroundColor3 = Config.BgCard
        welcomeCard.BackgroundTransparency = 0.15
        welcomeCard.BorderSizePixel = 0
        welcomeCard.LayoutOrder = 1
        Instance.new("UICorner", welcomeCard).CornerRadius = UDim.new(0, 10)
        local welcomeStroke = Instance.new("UIStroke")
        welcomeStroke.Parent = welcomeCard
        welcomeStroke.Color = Config.ThemeColor
        welcomeStroke.Thickness = 1.5
        AddHoverGlow(welcomeCard, welcomeStroke)

        local welcomeIcon = Instance.new("TextLabel")
        welcomeIcon.Parent = welcomeCard
        welcomeIcon.Size = UDim2.new(0, 45, 0, 45)
        welcomeIcon.Position = UDim2.new(0, 12, 0.5, -22.5)
        welcomeIcon.BackgroundTransparency = 1
        welcomeIcon.Font = Enum.Font.GothamBold
        welcomeIcon.TextSize = 26
        welcomeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        welcomeIcon.Text = "🌊"
        welcomeIcon.TextXAlignment = Enum.TextXAlignment.Center

        local welcomeTitle = Instance.new("TextLabel")
        welcomeTitle.Parent = welcomeCard
        welcomeTitle.Size = UDim2.new(1, -70, 0, 22)
        welcomeTitle.Position = UDim2.new(0, 62, 0, 15)
        welcomeTitle.BackgroundTransparency = 1
        welcomeTitle.Font = Enum.Font.GothamBold
        welcomeTitle.TextSize = 15
        welcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        welcomeTitle.Text = "Welcome to FishHub, " .. Player.DisplayName .. "!"
        welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
        welcomeTitle.TextTruncate = Enum.TextTruncate.AtEnd

        local welcomeSub = Instance.new("TextLabel")
        welcomeSub.Parent = welcomeCard
        welcomeSub.Size = UDim2.new(1, -70, 0, 20)
        welcomeSub.Position = UDim2.new(0, 62, 0, 38)
        welcomeSub.BackgroundTransparency = 1
        welcomeSub.Font = Enum.Font.Gotham
        welcomeSub.TextSize = 12
        welcomeSub.TextColor3 = Color3.fromRGB(180, 220, 255)
        welcomeSub.Text = "Ready to experience the ultimate script in " .. gameName .. "!"
        welcomeSub.TextXAlignment = Enum.TextXAlignment.Left
        welcomeSub.TextTruncate = Enum.TextTruncate.AtEnd

        -- 2. REDESIGNED PROFILE CARD (Đã loại bỏ phần màu xanh thừa)
        local profileCard = Instance.new("Frame")
        profileCard.Parent = tabFrame
        profileCard.Size = UDim2.new(1, 0, 0, 90)
        profileCard.BackgroundColor3 = Config.BgCard
        profileCard.BackgroundTransparency = 0.2
        profileCard.BorderSizePixel = 0
        profileCard.LayoutOrder = 2
        Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 10)
        local profileStroke = Instance.new("UIStroke")
        profileStroke.Parent = profileCard
        profileStroke.Color = Config.BorderColor
        profileStroke.Thickness = 1
        AddHoverGlow(profileCard, profileStroke)

        -- Đã xóa profileGlow hoặc chuyển thành trong suốt hoàn toàn
        local profileGlow = Instance.new("Frame")
        profileGlow.Parent = profileCard
        profileGlow.Size = UDim2.new(0, 120, 1, 0)
        profileGlow.Position = UDim2.new(0, 0, 0, 0)
        profileGlow.BackgroundTransparency = 1
        profileGlow.BackgroundColor3 = Config.ThemeColor
        profileGlow.BorderSizePixel = 0
        Instance.new("UICorner", profileGlow).CornerRadius = UDim.new(0, 10)

        local avtImg = Instance.new("ImageLabel")
        avtImg.Parent = profileCard
        avtImg.Size = UDim2.new(0, 66, 0, 66)
        avtImg.Position = UDim2.new(0, 12, 0.5, -33)
        avtImg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        avtImg.BorderSizePixel = 0
        avtImg.Image = "rbxassetid://0"
        Instance.new("UICorner", avtImg).CornerRadius = UDim.new(1, 0)
        local avtStroke = Instance.new("UIStroke")
        avtStroke.Parent = avtImg
        avtStroke.Color = Config.BorderColor -- Đổi viền avatar về màu xám viền chung
        avtStroke.Thickness = 2

        task.spawn(function()
            pcall(function()
                local content = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                avtImg.Image = content
            end)
        end)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = profileCard
        nameLbl.Size = UDim2.new(1, -95, 0, 26)
        nameLbl.Position = UDim2.new(0, 90, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 17
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Text = Player.DisplayName
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local tagLbl = Instance.new("TextLabel")
        tagLbl.Parent = profileCard
        tagLbl.Size = UDim2.new(1, -95, 0, 20)
        tagLbl.Position = UDim2.new(0, 90, 0, 46)
        tagLbl.BackgroundTransparency = 1
        tagLbl.Font = Enum.Font.GothamMedium
        tagLbl.TextSize = 13
        tagLbl.TextColor3 = Color3.fromRGB(180, 180, 200) -- Đổi màu chữ @ từ xanh sang xám sáng hài hòa
        tagLbl.Text = "@" .. Player.Name .. "  •  Verified User"
        tagLbl.TextXAlignment = Enum.TextXAlignment.Left
        tagLbl.TextTruncate = Enum.TextTruncate.AtEnd

        -- 3. STATS CONTAINER (Level, Bounty/Honor, Fragments, Beli) - Căn chỉnh lại chiều rộng khớp hoàn toàn với khối trên
        local statsContainer = Instance.new("Frame")
        statsContainer.Parent = tabFrame
        statsContainer.Size = UDim2.new(1, 0, 0, 130)
        statsContainer.BackgroundTransparency = 1
        statsContainer.LayoutOrder = 3

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = statsContainer
        gridLayout.CellSize = UDim2.new(0.5, -5, 0, 56) -- Căn đều tự động khít 100% theo chiều rộng khung chứa
        gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function CreateStatCard(title, icon)
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Config.BgCard
            card.BackgroundTransparency = 0.2
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke")
            stroke.Parent = card
            stroke.Color = Config.BorderColor
            stroke.Thickness = 1
            AddHoverGlow(card, stroke)

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Parent = card
            titleLbl.Size = UDim2.new(1, -12, 0, 18)
            titleLbl.Position = UDim2.new(0, 6, 0, 6)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = 11
            titleLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
            titleLbl.Text = icon .. "  " .. title
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local valLbl = Instance.new("TextLabel")
            valLbl.Parent = card
            valLbl.Size = UDim2.new(1, -12, 0, 24)
            valLbl.Position = UDim2.new(0, 6, 0, 24)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 14
            valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            valLbl.Text = "Loading..."
            valLbl.TextXAlignment = Enum.TextXAlignment.Left
            valLbl.TextTruncate = Enum.TextTruncate.AtEnd

            return card, titleLbl, valLbl
        end

        local levelCard, _, levelVal = CreateStatCard("LEVEL", "⭐")
        levelCard.Parent = statsContainer
        levelCard.LayoutOrder = 1

        local factionCard, factionTitleLbl, factionVal = CreateStatCard("BOUNTY", "⚔️")
        factionCard.Parent = statsContainer
        factionCard.LayoutOrder = 2

        local fragCard, _, fragVal = CreateStatCard("FRAGMENTS", "💎")
        fragCard.Parent = statsContainer
        fragCard.LayoutOrder = 3

        local beliCard, _, beliVal = CreateStatCard("BELI", "💵") 
        beliCard.Parent = statsContainer
        beliCard.LayoutOrder = 4

        -- Cập nhật thông số tự động theo người chơi và Team
        task.spawn(function()
            while tabFrame and tabFrame.Parent do
                pcall(function()
                    -- Level
                    local lvl = "N/A"
                    if Player:FindFirstChild("leaderstats") then
                        local ls = Player.leaderstats
                        if ls:FindFirstChild("Level") then lvl = ls.Level.Value
                        elseif ls:FindFirstChild("Lvl") then lvl = ls.Lvl.Value end
                    end
                    if lvl == "N/A" and Player:FindFirstChild("Data") then
                        local data = Player.Data
                        if data:FindFirstChild("Level") then lvl = data.Level.Value
                        elseif data:FindFirstChild("Lvl") then lvl = data.Lvl.Value end
                    end
                    levelVal.Text = tostring(lvl)

                    -- Beli
                    local beli = "0"
                    if Player:FindFirstChild("leaderstats") then
                        local ls = Player.leaderstats
                        if ls:FindFirstChild("Beli") then beli = ls.Beli.Value
                        elseif ls:FindFirstChild("Money") then beli = ls.Money.Value
                        elseif ls:FindFirstChild("Cash") then beli = ls.Cash.Value end
                    end
                    if beli == "0" and Player:FindFirstChild("Data") then
                        local data = Player.Data
                        if data:FindFirstChild("Beli") then beli = data.Beli.Value
                        elseif data:FindFirstChild("Money") then beli = data.Money.Value
                        elseif data:FindFirstChild("Cash") then beli = data.Cash.Value end
                    end
                    beliVal.Text = tostring(beli)

                    -- Fragments
                    local frag = "0"
                    if Player:FindFirstChild("leaderstats") then
                        local ls = Player.leaderstats
                        if ls:FindFirstChild("Fragments") then frag = ls.Fragments.Value
                        elseif ls:FindFirstChild("Fragment") then frag = ls.Fragment.Value end
                    end
                    if frag == "0" and Player:FindFirstChild("Data") then
                        local data = Player.Data
                        if data:FindFirstChild("Fragments") then frag = data.Fragments.Value
                        elseif data:FindFirstChild("Fragment") then frag = data.Fragment.Value end
                    end
                    fragVal.Text = tostring(frag)

                    -- Team check for Bounty (Pirates) / Honor (Marines)
                    local isMarine = false
                    if Player.Team then
                        local teamName = string.lower(Player.Team.Name)
                        if string.find(teamName, "marine") or string.find(teamName, "hải quân") then
                            isMarine = true
                        end
                    end

                    if isMarine then
                        factionTitleLbl.Text = "🛡️  HONOR"
                        local honor = "0"
                        if Player:FindFirstChild("leaderstats") then
                            local ls = Player.leaderstats
                            if ls:FindFirstChild("Honor") then honor = ls.Honor.Value
                            elseif ls:FindFirstChild("Bounty") then honor = ls.Bounty.Value
                            elseif ls:FindFirstChild("Bounty/Honor") then honor = ls["Bounty/Honor"].Value end
                        end
                        if honor == "0" and Player:FindFirstChild("Data") then
                            local data = Player.Data
                            if data:FindFirstChild("Honor") then honor = data.Honor.Value
                            elseif data:FindFirstChild("Bounty") then honor = data.Bounty.Value
                            elseif data:FindFirstChild("Bounty/Honor") then honor = data["Bounty/Honor"].Value end
                        end
                        factionVal.Text = tostring(honor)
                    else
                        factionTitleLbl.Text = "⚔️  BOUNTY"
                        local bounty = "0"
                        if Player:FindFirstChild("leaderstats") then
                            local ls = Player.leaderstats
                            if ls:FindFirstChild("Bounty") then bounty = ls.Bounty.Value
                            elseif ls:FindFirstChild("Honor") then bounty = ls.Honor.Value
                            elseif ls:FindFirstChild("Bounty/Honor") then bounty = ls["Bounty/Honor"].Value end
                        end
                        if bounty == "0" and Player:FindFirstChild("Data") then
                            local data = Player.Data
                            if data:FindFirstChild("Bounty") then bounty = data.Bounty.Value
                            elseif data:FindFirstChild("Honor") then bounty = data.Honor.Value
                            elseif data:FindFirstChild("Bounty/Honor") then bounty = data["Bounty/Honor"].Value end
                        end
                        factionVal.Text = tostring(bounty)
                    end
                end)
                task.wait(1)
            end
        end)

        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 360)
    elseif name == "Creative" then
        local creativeLayout = Instance.new("UIListLayout")
        creativeLayout.Parent = tabFrame
        creativeLayout.SortOrder = Enum.SortOrder.LayoutOrder
        creativeLayout.Padding = UDim.new(0, 15)
        creativeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        -- Khoảng trống căn chỉnh phía trên cho đẹp mắt
        local paddingFrame = Instance.new("Frame")
        paddingFrame.Parent = tabFrame
        paddingFrame.Size = UDim2.new(1, 0, 0, 40)
        paddingFrame.BackgroundTransparency = 1
        paddingFrame.LayoutOrder = 1

        -- 1. AVATAR NGƯỜI CHƠI CỐ ĐỊNH (thankhuyenhuy - Chỉ hiện avatar, không lộ thông tin)
        local avtCard = Instance.new("Frame")
        avtCard.Parent = tabFrame
        avtCard.Size = UDim2.new(0, 110, 0, 110)
        avtCard.BackgroundColor3 = Config.BgCard
        avtCard.BackgroundTransparency = 0.2
        avtCard.BorderSizePixel = 0
        avtCard.LayoutOrder = 2
        Instance.new("UICorner", avtCard).CornerRadius = UDim.new(1, 0)
        local avtCardStroke = Instance.new("UIStroke")
        avtCardStroke.Parent = avtCard
        avtCardStroke.Color = Config.ThemeColor
        avtCardStroke.Thickness = 2
        AddHoverGlow(avtCard, avtCardStroke)

        local fixedAvtImg = Instance.new("ImageLabel")
        fixedAvtImg.Parent = avtCard
        fixedAvtImg.Size = UDim2.new(1, -10, 1, -10)
        fixedAvtImg.Position = UDim2.new(0, 5, 0, 5)
        fixedAvtImg.BackgroundTransparency = 1
        fixedAvtImg.Image = "rbxassetid://0"
        Instance.new("UICorner", fixedAvtImg).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            pcall(function()
                local targetUserId = Players:GetUserIdFromNameAsync("thankhuyenhuy")
                if targetUserId then
                    local content = Players:GetUserThumbnailAsync(targetUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                    fixedAvtImg.Image = content
                end
            end)
        end)

        -- 2. THÔNG TIN SCRIPT ĐƯỢC LÀM BỞI DaoHuyLam (ĐẶT Ở GIỮA TRUNG TÂM)
        local infoCard = Instance.new("Frame")
        infoCard.Parent = tabFrame
        infoCard.Size = UDim2.new(0.9, 0, 0, 80)
        infoCard.BackgroundColor3 = Config.BgCard
        infoCard.BackgroundTransparency = 0.2
        infoCard.BorderSizePixel = 0
        infoCard.LayoutOrder = 3
        Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 12)
        local infoStroke = Instance.new("UIStroke")
        infoStroke.Parent = infoCard
        infoStroke.Color = Config.BorderColor
        infoStroke.Thickness = 1.5
        AddHoverGlow(infoCard, infoStroke)

        local scriptTitleLbl = Instance.new("TextLabel")
        scriptTitleLbl.Parent = infoCard
        scriptTitleLbl.Size = UDim2.new(1, 0, 0, 25)
        scriptTitleLbl.Position = UDim2.new(0, 0, 0, 15)
        scriptTitleLbl.BackgroundTransparency = 1
        scriptTitleLbl.Font = Enum.Font.GothamBold
        scriptTitleLbl.TextSize = 16
        scriptTitleLbl.TextColor3 = Config.ThemeColor
        scriptTitleLbl.Text = "FishHub Creative Script"
        scriptTitleLbl.TextXAlignment = Enum.TextXAlignment.Center

        local scriptAuthorLbl = Instance.new("TextLabel")
        scriptAuthorLbl.Parent = infoCard
        scriptAuthorLbl.Size = UDim2.new(1, 0, 0, 25)
        scriptAuthorLbl.Position = UDim2.new(0, 0, 0, 40)
        scriptAuthorLbl.BackgroundTransparency = 1
        scriptAuthorLbl.Font = Enum.Font.GothamMedium
        scriptAuthorLbl.TextSize = 14
        scriptAuthorLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        scriptAuthorLbl.Text = "Script Made by: DaoHuyLam"
        scriptAuthorLbl.TextXAlignment = Enum.TextXAlignment.Center

        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
    else
        local label = Instance.new("TextLabel")
        label.Parent = tabFrame
        label.Size = UDim2.new(1, 0, 0, 50)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = "Đây là nội dung của trang: " .. name
        label.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    tabs[name] = tabFrame
    return tabFrame
end

CreateTabContent("Home")
CreateTabContent("Function")
CreateTabContent("Creative")

local function SwitchTab(tabName)
    for name, frame in pairs(tabs) do
        if name == tabName then
            frame.Visible = true
        else
            frame.Visible = false
        end
    end
    for name, btn in pairs(tabButtons) do
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if name == tabName then
            btn.BackgroundColor3 = Config.ThemeColor
            btn.TextColor3 = Color3.fromRGB(30, 30, 40)
            if stroke then stroke.Color = Config.ThemeColor end
        else
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            btn.TextColor3 = Color3.fromRGB(230, 230, 240)
            if stroke then stroke.Color = Config.BorderColor end
        end
    end
end

local function CreateNavButton(name)
    local btn = Instance.new("TextButton")
    btn.Parent = navContainer
    btn.Size = UDim2.new(0, 95, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Parent = btn
    btnStroke.Color = Config.BorderColor
    btnStroke.Thickness = 1
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    
    tabButtons[name] = btn
end

CreateNavButton("Home")
CreateNavButton("Function")
CreateNavButton("Creative")

SwitchTab("Home")

local debugSidebarFrame = Instance.new("Frame")
debugSidebarFrame.Name = "DebugSidebar"
debugSidebarFrame.Parent = gui
debugSidebarFrame.Size = UDim2.new(0, 180, 0, 112)
debugSidebarFrame.Position = UDim2.new(1, -190, 1, -182)
debugSidebarFrame.BackgroundColor3 = Config.BgCard
debugSidebarFrame.BackgroundTransparency = Config.DebugTransparency
debugSidebarFrame.BorderSizePixel = 0
debugSidebarFrame.Visible = Config.ShowDebug
Instance.new("UICorner", debugSidebarFrame).CornerRadius = UDim.new(0, 8)
local debugSidebarStroke = Instance.new("UIStroke")
debugSidebarStroke.Parent = debugSidebarFrame
debugSidebarStroke.Thickness = 1
debugSidebarStroke.Color = Config.BorderColor

local debugSidebarText = Instance.new("TextLabel")
debugSidebarText.Parent = debugSidebarFrame
debugSidebarText.Size = UDim2.new(1, -12, 1, -6)
debugSidebarText.Position = UDim2.new(0, 6, 0, 3)
debugSidebarText.BackgroundTransparency = 1
debugSidebarText.Font = Enum.Font.Code
debugSidebarText.TextSize = 10
debugSidebarText.TextColor3 = Color3.fromRGB(240, 240, 240)
debugSidebarText.TextXAlignment = Enum.TextXAlignment.Left
debugSidebarText.TextYAlignment = Enum.TextYAlignment.Top
debugSidebarText.RichText = true

local keyStatusSidebarFrame = Instance.new("Frame")
keyStatusSidebarFrame.Name = "KeyStatusSidebar"
keyStatusSidebarFrame.Parent = gui
keyStatusSidebarFrame.Size = UDim2.new(0, 180, 0, 54)
keyStatusSidebarFrame.Position = UDim2.new(1, -190, 1, -64)
keyStatusSidebarFrame.BackgroundColor3 = Config.BgCard
keyStatusSidebarFrame.BackgroundTransparency = Config.DebugTransparency
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
keyInnerCard.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
keyNameLabel.Size = UDim2.new(0, 75, 1, 0)
keyNameLabel.Position = UDim2.new(0, 22, 0, 0)
keyNameLabel.BackgroundTransparency = 1
keyNameLabel.Font = Enum.Font.GothamBold
keyNameLabel.TextSize = 10
keyNameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
keyNameLabel.Text = "K"
keyNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local keyActiveLabel = Instance.new("TextLabel")
keyActiveLabel.Parent = keyInnerCard
keyActiveLabel.Size = UDim2.new(1, -95, 1, 0)
keyActiveLabel.Position = UDim2.new(0, 92, 0, 0)
keyActiveLabel.BackgroundTransparency = 1
keyActiveLabel.Font = Enum.Font.GothamBold
keyActiveLabel.TextSize = 9.5
keyActiveLabel.TextColor3 = Color3.fromRGB(50, 230, 80)
keyActiveLabel.Text = "LOADING..."
keyActiveLabel.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    if SavedKey == "DHLADMIN22052009" then
        keyActiveLabel.Text = "LIFETIME"
        keyActiveLabel.TextColor3 = Color3.fromRGB(255, 215, 0) 
    elseif SavedKey ~= "" then
        local FIREBASE_URL = "https://fishhub-35d18-default-rtdb.firebaseio.com/keys"
        local url = FIREBASE_URL .. "/" .. SavedKey .. ".json"
        local success, response = pcall(function() return game:HttpGet(url) end)
        local keyData = nil
        if success and response and response ~= "null" then
            keyData = HttpService:JSONDecode(response)
        else
            local fallbackSuccess, fallbackResponse = pcall(function()
                return game:HttpGet(FIREBASE_URL .. ".json")
            end)
            if fallbackSuccess and fallbackResponse and fallbackResponse ~= "null" then
                local decoded = HttpService:JSONDecode(fallbackResponse)
                if type(decoded) == "table" then
                    for k, v in pairs(decoded) do
                        if k == SavedKey or v == SavedKey or (type(v) == "table" and (v.key == SavedKey or v.Key == SavedKey)) then
                            keyData = v
                            break
                        end
                    end
                end
            end
        end
        if type(keyData) == "table" and keyData.createdAt then
            local createdAtSec = math.floor(tonumber(keyData.createdAt) / 1000)
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

local function CreateCircleButton(text, xOffset)
    local btn = Instance.new("TextButton")
    btn.Parent = main
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, -xOffset, 0, 8)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Parent = btn
    btnStroke.Color = Config.BorderColor
    btnStroke.Thickness = 1
    AddHoverGlow(btn, btnStroke)
    return btn
end

local closeBtn = CreateCircleButton("×", 12)
local hideBtn  = CreateCircleButton("─", 44)
local gearBtn  = CreateCircleButton("⚙", 76)

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
AddHoverGlow(confirm, confirmStroke)

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
local yesStroke = Instance.new("UIStroke")
yesStroke.Parent = yes
yesStroke.Color = Config.BorderColor
yesStroke.Thickness = 1
AddHoverGlow(yes, yesStroke)

local no = Instance.new("TextButton")
no.Parent = confirm
no.Size = UDim2.new(0.38, 0, 0, 30)
no.Position = UDim2.new(0.54, 0, 1, -40)
no.BackgroundColor3 = Color3.fromRGB(55, 60, 75)
no.TextColor3 = Color3.new(1, 1, 1)
no.Font = Enum.Font.GothamBold
no.TextSize = 12
Instance.new("UICorner", no).CornerRadius = UDim.new(0, 6)
local noStroke = Instance.new("UIStroke")
noStroke.Parent = no
noStroke.Color = Config.BorderColor
noStroke.Thickness = 1
AddHoverGlow(no, noStroke)

closeBtn.MouseButton1Click:Connect(function()
    txt.Text = L("CloseConfirm")
    yes.Text = L("Yes")
    no.Text = L("No")
    confirm.Visible = true
end)

yes.MouseButton1Click:Connect(function() gui:Destroy() end)
no.MouseButton1Click:Connect(function() confirm.Visible = false end)
hideBtn.MouseButton1Click:Connect(function() CloseGUI() end)
gearBtn.MouseButton1Click:Connect(function() ToggleSettings() end)

OpenGUI()