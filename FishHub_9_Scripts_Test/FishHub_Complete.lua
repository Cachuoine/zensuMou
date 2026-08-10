--[[ 
    FishHub - Fixed Running Lines Precision Edition & Custom Theme Loading + Auto Rainbow Nav (Fixed Conflict Edition)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

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
    GUIAnimation = true,
    Language = "EN",
    ToggleKey = Enum.KeyCode.K,
    ThemeColor = Color3.fromRGB(0, 229, 255),       
    BgMain = Color3.fromRGB(45, 45, 52),           
    BgCard = Color3.fromRGB(55, 55, 65),           
    BorderColor = Color3.fromRGB(90, 90, 110),     
    ShowDebug = true,
    UITransparency = 0.25,     
    DebugTransparency = 0.25,
    RainbowSpeedPercent = 100,
    UIExaggeratedSize = "Medium"
}

-- Shared UI scale values. Every open/close animation and both panels
-- use this same source of truth so Main and Setting can never desync.
local UISizeScaleMap = {
    Small = 0.85,
    Medium = 1.00,
    Large = 1.15
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

-- Danh sách lưu trữ các UIStroke (viền) và các Line cần áp dụng Theme / Rainbow
local allHubStrokes = {}
local allHubLines = {}
-- Danh sách lưu trữ các TextLabel / thành phần cần đổi màu theo Theme/Rainbow
local allThemeTexts = {}

local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "AdvancedLoadingScreen"
loadingScreen.Parent = gui
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
loadingScreen.BackgroundTransparency = 1
loadingScreen.BorderSizePixel = 0
loadingScreen.Visible = false
loadingScreen.ZIndex = 999

local loadingGlow = Instance.new("Frame")
loadingGlow.Parent = loadingScreen
loadingGlow.Size = UDim2.new(0, 360, 0, 360)
loadingGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
loadingGlow.BackgroundColor3 = Config.ThemeColor
loadingGlow.BackgroundTransparency = 0.94
loadingGlow.BorderSizePixel = 0
loadingGlow.ZIndex = 999
Instance.new("UICorner", loadingGlow).CornerRadius = UDim.new(1, 0)

local loadingCard = Instance.new("Frame")
loadingCard.Parent = loadingScreen
loadingCard.Size = UDim2.new(0, 360, 0, 190)
loadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingCard.AnchorPoint = Vector2.new(0.5, 0.5)
loadingCard.BackgroundColor3 = Color3.fromRGB(18, 19, 27)
loadingCard.BackgroundTransparency = 0.08
loadingCard.BorderSizePixel = 0
loadingCard.ZIndex = 1000
Instance.new("UICorner", loadingCard).CornerRadius = UDim.new(0, 16)

local loadingCardStroke = Instance.new("UIStroke")
loadingCardStroke.Parent = loadingCard
loadingCardStroke.Color = Config.ThemeColor
loadingCardStroke.Thickness = 1.5
loadingCardStroke.Transparency = 0.15

local loadingRing = Instance.new("Frame")
loadingRing.Parent = loadingCard
loadingRing.Size = UDim2.new(0, 54, 0, 54)
loadingRing.Position = UDim2.new(0.5, 0, 0, 24)
loadingRing.AnchorPoint = Vector2.new(0.5, 0)
loadingRing.BackgroundTransparency = 1
loadingRing.ZIndex = 1002

local ringOuter = Instance.new("Frame")
ringOuter.Parent = loadingRing
ringOuter.Size = UDim2.new(1, 0, 1, 0)
ringOuter.BackgroundTransparency = 1
ringOuter.BorderSizePixel = 0
ringOuter.ZIndex = 1002
Instance.new("UICorner", ringOuter).CornerRadius = UDim.new(1, 0)

local ringStroke = Instance.new("UIStroke")
ringStroke.Parent = ringOuter
ringStroke.Color = Config.ThemeColor
ringStroke.Thickness = 3
ringStroke.Transparency = 0.2

local ringInner = Instance.new("Frame")
ringInner.Parent = loadingRing
ringInner.Size = UDim2.new(0, 34, 0, 34)
ringInner.Position = UDim2.new(0.5, 0, 0.5, 0)
ringInner.AnchorPoint = Vector2.new(0.5, 0.5)
ringInner.BackgroundColor3 = Config.ThemeColor
ringInner.BackgroundTransparency = 0.88
ringInner.BorderSizePixel = 0
ringInner.ZIndex = 1003
Instance.new("UICorner", ringInner).CornerRadius = UDim.new(1, 0)

local ringDot = Instance.new("Frame")
ringDot.Parent = loadingRing
ringDot.Size = UDim2.new(0, 7, 0, 7)
ringDot.Position = UDim2.new(0.5, 0, 0.5, 0)
ringDot.AnchorPoint = Vector2.new(0.5, 0.5)
ringDot.BackgroundColor3 = Config.ThemeColor
ringDot.BorderSizePixel = 0
ringDot.ZIndex = 1004
Instance.new("UICorner", ringDot).CornerRadius = UDim.new(1, 0)

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Parent = loadingCard
loadingTitle.Size = UDim2.new(1, -40, 0, 26)
loadingTitle.Position = UDim2.new(0.5, 0, 0, 84)
loadingTitle.AnchorPoint = Vector2.new(0.5, 0)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextSize = 17
loadingTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
loadingTitle.Text = "FISHHUB"
loadingTitle.TextTransparency = 1
loadingTitle.ZIndex = 1002

local loadingText = Instance.new("TextLabel")
loadingText.Parent = loadingCard
loadingText.Size = UDim2.new(1, -65, 0, 20)
loadingText.Position = UDim2.new(0.5, 0, 0, 111)
loadingText.AnchorPoint = Vector2.new(0.5, 0)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.GothamMedium
loadingText.TextSize = 11
loadingText.TextColor3 = Color3.fromRGB(175, 180, 195)
loadingText.Text = "Applying Theme & Reloading UI"
loadingText.TextTransparency = 1
loadingText.ZIndex = 1002

local loadingDots = Instance.new("TextLabel")
loadingDots.Parent = loadingCard
loadingDots.Size = UDim2.new(0, 25, 0, 20)
loadingDots.Position = UDim2.new(1, -42, 0, 111)
loadingDots.BackgroundTransparency = 1
loadingDots.Font = Enum.Font.GothamBold
loadingDots.TextSize = 11
loadingDots.TextColor3 = Config.ThemeColor
loadingDots.Text = ""
loadingDots.TextTransparency = 1
loadingDots.ZIndex = 1002

local progressBackground = Instance.new("Frame")
progressBackground.Parent = loadingCard
progressBackground.Size = UDim2.new(1, -50, 0, 4)
progressBackground.Position = UDim2.new(0.5, 0, 0, 146)
progressBackground.AnchorPoint = Vector2.new(0.5, 0)
progressBackground.BackgroundColor3 = Color3.fromRGB(45, 47, 58)
progressBackground.BackgroundTransparency = 0.2
progressBackground.BorderSizePixel = 0
progressBackground.ZIndex = 1002
Instance.new("UICorner", progressBackground).CornerRadius = UDim.new(1, 0)

local progressFill = Instance.new("Frame")
progressFill.Parent = progressBackground
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Config.ThemeColor
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 1003
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

local loadingStatus = Instance.new("TextLabel")
loadingStatus.Parent = loadingCard
loadingStatus.Size = UDim2.new(1, -40, 0, 18)
loadingStatus.Position = UDim2.new(0.5, 0, 0, 158)
loadingStatus.AnchorPoint = Vector2.new(0.5, 0)
loadingStatus.BackgroundTransparency = 1
loadingStatus.Font = Enum.Font.GothamMedium
loadingStatus.TextSize = 9
loadingStatus.TextColor3 = Color3.fromRGB(125, 130, 145)
loadingStatus.Text = "INITIALIZING"
loadingStatus.TextTransparency = 1
loadingStatus.ZIndex = 1002

local loadingAnimationRunning = false
local loadingAnimationToken = 0

local function UpdateLoadingTheme()
    local color = Config.ThemeColor
    loadingGlow.BackgroundColor3 = color
    loadingCardStroke.Color = color
    ringStroke.Color = color
    ringInner.BackgroundColor3 = color
    ringDot.BackgroundColor3 = color
    loadingDots.TextColor3 = color
    progressFill.BackgroundColor3 = color
end

local function StopLoadingAnimation()
    loadingAnimationRunning = false
    loadingAnimationToken += 1
end

local function StartLoadingAnimation()
    loadingAnimationToken += 1
    local token = loadingAnimationToken
    loadingAnimationRunning = true

    task.spawn(function()
        local dots = 0
        while loadingAnimationRunning and token == loadingAnimationToken and loadingScreen.Parent do
            dots = (dots + 1) % 4
            loadingDots.Text = string.rep(".", dots)
            loadingStatus.Text = ({"INITIALIZING", "APPLYING THEME", "UPDATING UI", "ALMOST READY"})[dots + 1]
            task.wait(0.22)
        end
    end)

    task.spawn(function()
        while loadingAnimationRunning and token == loadingAnimationToken and loadingScreen.Parent do
            loadingRing.Rotation = (loadingRing.Rotation + 8) % 360
            task.wait(0.025)
        end
    end)

    task.spawn(function()
        while loadingAnimationRunning and token == loadingAnimationToken and loadingScreen.Parent do
            local up = TweenService:Create(loadingGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 410, 0, 410), BackgroundTransparency = 0.965})
            local down = TweenService:Create(loadingGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 360, 0, 360), BackgroundTransparency = 0.94})
            up:Play()
            up.Completed:Wait()
            if not loadingAnimationRunning then break end
            down:Play()
            down.Completed:Wait()
        end
    end)
end

local themeLoadingActive = false
local themeLoadingState = {
    mainVisible = false,
    settingsVisible = false,
    openLineVisible = false,
    confirmVisible = false
}

local function GetThemeUI(name)
    return gui:FindFirstChild(name)
end

-- The loading sequence is deliberately driven by one coroutine.
-- This prevents the progress bar from getting stranded at an intermediate value.
local THEME_LOADING_APPLY_DELAY = 2.65
local THEME_LOADING_FINISH_DELAY = 0.65

local function HideUIForThemeLoading()
    local mainUI = GetThemeUI("MainWindow")
    local settingsUI = GetThemeUI("SettingsWindow")
    local openLineUI = GetThemeUI("OpenLine")
    local confirmUI = GetThemeUI("ThemeConfirm")

    themeLoadingState.mainVisible = mainUI and mainUI.Visible or false
    themeLoadingState.settingsVisible = settingsUI and settingsUI.Visible or false
    themeLoadingState.openLineVisible = openLineUI and openLineUI.Visible or false
    themeLoadingState.confirmVisible = confirmUI and confirmUI.Visible or false

    if mainUI then mainUI.Visible = false end
    if settingsUI then settingsUI.Visible = false end
    if openLineUI then openLineUI.Visible = false end
    if confirmUI then confirmUI.Visible = false end
end

local function RestoreUIAfterThemeLoading()
    local mainUI = GetThemeUI("MainWindow")
    local settingsUI = GetThemeUI("SettingsWindow")
    local openLineUI = GetThemeUI("OpenLine")
    local confirmUI = GetThemeUI("ThemeConfirm")

    if mainUI then mainUI.Visible = themeLoadingState.mainVisible end
    if settingsUI then settingsUI.Visible = themeLoadingState.settingsVisible end
    if openLineUI then openLineUI.Visible = themeLoadingState.openLineVisible end
    if confirmUI then confirmUI.Visible = themeLoadingState.confirmVisible end
end

local function FinishAdvancedThemeLoading()
    if not loadingScreen.Parent then
        themeLoadingActive = false
        return
    end

    StopLoadingAnimation()

    TweenService:Create(
        progressFill,
        TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 1, 0)}
    ):Play()

    TweenService:Create(
        loadingCard,
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {
            Position = UDim2.new(0.5, 0, 0.5, -10),
            BackgroundTransparency = 1
        }
    ):Play()

    TweenService:Create(
        loadingGlow,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 500, 0, 500),
            BackgroundTransparency = 1
        }
    ):Play()

    TweenService:Create(loadingTitle, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    TweenService:Create(loadingText, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    TweenService:Create(loadingDots, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
    TweenService:Create(loadingStatus, TweenInfo.new(0.28), {TextTransparency = 1}):Play()

    local fade = TweenService:Create(
        loadingScreen,
        TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )

    fade:Play()
    fade.Completed:Wait()

    loadingScreen.Visible = false

    loadingCard.BackgroundTransparency = 0.08
    loadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadingTitle.TextTransparency = 1
    loadingText.TextTransparency = 1
    loadingDots.TextTransparency = 1
    loadingStatus.TextTransparency = 1
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    loadingGlow.Size = UDim2.new(0, 280, 0, 280)
    loadingGlow.BackgroundTransparency = 1
    loadingRing.Size = UDim2.new(0, 42, 0, 42)
    loadingRing.Rotation = 0

    themeLoadingActive = false

    -- UI is restored only after the loading overlay has completely disappeared.
    RestoreUIAfterThemeLoading()
end

local function PlayAdvancedThemeLoading(targetColor, loadingTitleText, loadingSubtitleText)
    if themeLoadingActive then
        return false
    end

    themeLoadingActive = true
    Config.ThemeColor = targetColor
    UpdateLoadingTheme()
    HideUIForThemeLoading()
    StopLoadingAnimation()

    loadingScreen.Visible = true
    loadingScreen.BackgroundTransparency = 1

    loadingCard.Position = UDim2.new(0.5, 0, 0.5, 20)
    loadingCard.BackgroundTransparency = 1

    loadingTitle.Text = loadingTitleText or "FISHHUB"
    loadingText.Text = loadingSubtitleText or "Applying Theme & Reloading UI"
    loadingStatus.Text = "INITIALIZING"

    loadingTitle.TextTransparency = 1
    loadingText.TextTransparency = 1
    loadingDots.TextTransparency = 1
    loadingStatus.TextTransparency = 1

    progressFill.Size = UDim2.new(0, 0, 1, 0)

    loadingGlow.Size = UDim2.new(0, 280, 0, 280)
    loadingGlow.BackgroundTransparency = 1

    loadingRing.Size = UDim2.new(0, 42, 0, 42)
    loadingRing.Rotation = 0

    StartLoadingAnimation()

    TweenService:Create(
        loadingScreen,
        TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.16}
    ):Play()

    TweenService:Create(
        loadingCard,
        TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 0.08
        }
    ):Play()

    TweenService:Create(
        loadingGlow,
        TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 360, 0, 360),
            BackgroundTransparency = 0.94
        }
    ):Play()

    TweenService:Create(
        loadingRing,
        TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 54, 0, 54)}
    ):Play()

    TweenService:Create(
        loadingTitle,
        TweenInfo.new(0.45),
        {TextTransparency = 0}
    ):Play()

    task.delay(0.18, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(loadingText, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
            TweenService:Create(loadingDots, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
            TweenService:Create(loadingStatus, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
        end
    end)

    -- Progress milestones: 18 -> 42 -> 68 -> 88 -> 100.
    -- The final 100% is always driven by FinishAdvancedThemeLoading.
    TweenService:Create(
        progressFill,
        TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.18, 0, 1, 0)}
    ):Play()

    task.delay(0.8, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(
                progressFill,
                TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.new(0.42, 0, 1, 0)}
            ):Play()
        end
    end)

    task.delay(1.7, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(
                progressFill,
                TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.new(0.68, 0, 1, 0)}
            ):Play()
        end
    end)

    task.delay(2.5, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(
                progressFill,
                TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Size = UDim2.new(0.88, 0, 1, 0)}
            ):Play()
        end
    end)

    return true
end


UpdateLoadingTheme()

local function ShowNotification(message)
    local notifContainer = gui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Parent = gui
        notifContainer.Size = UDim2.new(0, 280, 0, 70)
        notifContainer.Position = UDim2.new(1, -15, 1, -15)
        notifContainer.AnchorPoint = Vector2.new(1, 1)
        notifContainer.BackgroundTransparency = 1
        
        local notifLayout = Instance.new("UIListLayout")
        notifLayout.Parent = notifContainer
        notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
        notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        notifLayout.Padding = UDim.new(0, 8)
    end

    local card = Instance.new("Frame")
    card.Parent = notifContainer
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = Config.BgCard
    card.BackgroundTransparency = 0.1
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Parent = card
    cardStroke.Color = Config.ThemeColor
    cardStroke.Thickness = 1.5
    table.insert(allHubStrokes, cardStroke)

    local bellIcon = Instance.new("TextLabel")
    bellIcon.Parent = card
    bellIcon.Size = UDim2.new(0, 30, 0, 30)
    bellIcon.Position = UDim2.new(0, 10, 0, 8)
    bellIcon.BackgroundTransparency = 1
    bellIcon.Text = "🔔"
    bellIcon.TextSize = 18

    local textLbl = Instance.new("TextLabel")
    textLbl.Parent = card
    textLbl.Size = UDim2.new(1, -45, 0, 32)
    textLbl.Position = UDim2.new(0, 42, 0, 8)
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.GothamBold
    textLbl.TextSize = 12
    textLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLbl.Text = message
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.TextWrapped = true

    local progressBarBg = Instance.new("Frame")
    progressBarBg.Parent = card
    progressBarBg.Size = UDim2.new(1, -16, 0, 4)
    progressBarBg.Position = UDim2.new(0, 8, 1, -10)
    progressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    progressBarBg.BorderSizePixel = 0
    Instance.new("UICorner", progressBarBg).CornerRadius = UDim.new(1, 0)

    local progressBar = Instance.new("Frame")
    progressBar.Parent = progressBarBg
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Config.ThemeColor
    progressBar.BorderSizePixel = 0
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

    TweenService:Create(progressBar, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(2.5, function()
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            for _, child in ipairs(card:GetDescendants()) do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                elseif child:IsA("UIStroke") then
                    TweenService:Create(child, TweenInfo.new(0.3), {Transparency = 1}):Play()
                elseif child:IsA("Frame") then
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                end
            end
            task.wait(0.3)
            card:Destroy()
        end
    end)
end

local openLine = Instance.new("Frame")
openLine.Name = "OpenLine"
openLine.Parent = gui
openLine.Size = UDim2.new(0, 550, 0, 8)
openLine.Position = UDim2.new(0.5, 0, 0, 3)
openLine.AnchorPoint = Vector2.new(0.5, 0)
openLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
openLine.BackgroundTransparency = 0.85
openLine.BorderSizePixel = 0
Instance.new("UICorner", openLine).CornerRadius = UDim.new(1, 0)

local lineStroke = Instance.new("UIStroke")
lineStroke.Parent = openLine
lineStroke.Thickness = 2
lineStroke.Color = Config.ThemeColor
table.insert(allHubStrokes, lineStroke)

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
mainStroke.Color = Config.ThemeColor

local glowBorder = Instance.new("UIStroke")
glowBorder.Name = "GlowBorder"
glowBorder.Parent = main
glowBorder.Thickness = 4
glowBorder.Transparency = 0.4
glowBorder.Color = Config.ThemeColor

task.spawn(function()
    while main and main.Parent do
        TweenService:Create(glowBorder, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        task.wait(1.2)
        TweenService:Create(glowBorder, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
        task.wait(1.2)
    end
end)

local settingsWindow = Instance.new("Frame")
settingsWindow.Name = "SettingsWindow"
settingsWindow.Parent = gui
settingsWindow.Size = UDim2.new(0, 240, 0, Config.MainHeight)
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
settingsStroke.Color = Config.ThemeColor

task.spawn(function()
    while gui and gui.Parent do
        if main.Visible then
            -- Keep a constant 10px visual gap at every UI scale.
            -- The old formula used the unscaled MainWidth, which caused
            -- Small/Large to visually squeeze or spread the two windows.
            local scale = mainScale.Scale
            local scaledMainHalfWidth = (Config.MainWidth * scale) / 2
            settingsWindow.Position = UDim2.new(
                0.5,
                scaledMainHalfWidth + 10,
                0.5,
                0
            )
        end
        task.wait()
    end
end)

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Parent = settingsWindow
settingsTitle.Size = UDim2.new(1, 0, 0, 46)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙ Setting"
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 15
settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Center

local settingsLine = Instance.new("Frame")
settingsLine.Parent = settingsWindow
settingsLine.Size = UDim2.new(1, -20, 0, 1)
settingsLine.Position = UDim2.new(0, 10, 0, 45)
settingsLine.BackgroundColor3 = Config.BorderColor
settingsLine.BorderSizePixel = 0
table.insert(allHubLines, settingsLine)

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Parent = settingsWindow
settingsScroll.Size = UDim2.new(1, -10, 1, -55)
settingsScroll.Position = UDim2.new(0, 5, 0, 50)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 0
settingsScroll.ScrollBarImageTransparency = 1
settingsScroll.ScrollBarImageColor3 = Color3.new(1, 1, 1)
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Parent = settingsScroll
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 10)
settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ==================== PHẦN 1: THEME SECTION ====================
local themeDividerContainer = Instance.new("Frame")
themeDividerContainer.Parent = settingsScroll
themeDividerContainer.Size = UDim2.new(1, -10, 0, 40)
themeDividerContainer.BackgroundTransparency = 1
themeDividerContainer.LayoutOrder = 1

local themeTitleLbl = Instance.new("TextLabel")
themeTitleLbl.Parent = themeDividerContainer
themeTitleLbl.Size = UDim2.new(0, 0, 0, 20)
themeTitleLbl.Position = UDim2.new(0.5, 0, 0.5, -10)
themeTitleLbl.AnchorPoint = Vector2.new(0.5, 0.5)
themeTitleLbl.BackgroundTransparency = 1
themeTitleLbl.Font = Enum.Font.GothamBold
themeTitleLbl.TextSize = 13
themeTitleLbl.TextColor3 = Config.ThemeColor
themeTitleLbl.Text = "THEME"
themeTitleLbl.AutomaticSize = Enum.AutomaticSize.X
themeTitleLbl.ZIndex = 2
table.insert(allThemeTexts, themeTitleLbl)

local leftThemeLine = Instance.new("Frame")
leftThemeLine.Parent = themeDividerContainer
leftThemeLine.Size = UDim2.new(0.5, -45, 0, 2)
leftThemeLine.Position = UDim2.new(0, 0, 0.5, -1)
leftThemeLine.BackgroundColor3 = Config.ThemeColor
leftThemeLine.BackgroundTransparency = 0.3
leftThemeLine.BorderSizePixel = 0
Instance.new("UICorner", leftThemeLine).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, leftThemeLine)

local rightThemeLine = Instance.new("Frame")
rightThemeLine.Parent = themeDividerContainer
rightThemeLine.Size = UDim2.new(0.5, -45, 0, 2)
rightThemeLine.Position = UDim2.new(0.5, 45, 0.5, -1)
rightThemeLine.BackgroundColor3 = Config.ThemeColor
rightThemeLine.BackgroundTransparency = 0.3
rightThemeLine.BorderSizePixel = 0
Instance.new("UICorner", rightThemeLine).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, rightThemeLine)

local sliderCard = Instance.new("Frame")
sliderCard.Parent = settingsScroll
sliderCard.Size = UDim2.new(1, -10, 0, 55)
sliderCard.BackgroundColor3 = Config.BgCard
sliderCard.BackgroundTransparency = 0.2
sliderCard.BorderSizePixel = 0
sliderCard.LayoutOrder = 2
Instance.new("UICorner", sliderCard).CornerRadius = UDim.new(0, 8)

local sliderLbl = Instance.new("TextLabel")
sliderLbl.Parent = sliderCard
sliderLbl.Size = UDim2.new(1, -10, 0, 18)
sliderLbl.Position = UDim2.new(0, 8, 0, 5)
sliderLbl.BackgroundTransparency = 1
sliderLbl.Font = Enum.Font.GothamBold
sliderLbl.TextSize = 11
sliderLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
sliderLbl.Text = "Color Spectrum Selector:"
sliderLbl.TextXAlignment = Enum.TextXAlignment.Left

local sliderBar = Instance.new("Frame")
sliderBar.Parent = sliderCard
sliderBar.Size = UDim2.new(1, -16, 0, 12)
sliderBar.Position = UDim2.new(0, 8, 0, 28)
sliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBar.BorderSizePixel = 0
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Parent = sliderBar
rainbowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
})

local sliderBtn = Instance.new("TextButton")
sliderBtn.Parent = sliderBar
sliderBtn.Size = UDim2.new(0, 12, 0, 20)
local initialHue = select(1, Config.ThemeColor:ToHSV())
sliderBtn.Position = UDim2.new(initialHue, -6, 0.5, -10)
sliderBtn.BackgroundColor3 = Config.ThemeColor
sliderBtn.Text = ""
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(0, 3)
local sliderBtnStroke = Instance.new("UIStroke")
sliderBtnStroke.Parent = sliderBtn
sliderBtnStroke.Color = Color3.fromRGB(0, 0, 0)
sliderBtnStroke.Thickness = 1.5

local colorInputCard = Instance.new("Frame")
colorInputCard.Parent = settingsScroll
colorInputCard.Size = UDim2.new(1, -10, 0, 50)
colorInputCard.BackgroundColor3 = Config.BgCard
colorInputCard.BackgroundTransparency = 0.2
colorInputCard.BorderSizePixel = 0
colorInputCard.LayoutOrder = 3
Instance.new("UICorner", colorInputCard).CornerRadius = UDim.new(0, 8)

local colorInputLbl = Instance.new("TextLabel")
colorInputLbl.Parent = colorInputCard
colorInputLbl.Size = UDim2.new(0, 90, 1, 0)
colorInputLbl.Position = UDim2.new(0, 10, 0, 0)
colorInputLbl.BackgroundTransparency = 1
colorInputLbl.Font = Enum.Font.GothamBold
colorInputLbl.TextSize = 11
colorInputLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
colorInputLbl.Text = "Color Code:"
colorInputLbl.TextXAlignment = Enum.TextXAlignment.Left

local colorTextBox = Instance.new("TextBox")
colorTextBox.Parent = colorInputCard
colorTextBox.Size = UDim2.new(1, -105, 0, 30)
colorTextBox.Position = UDim2.new(0, 95, 0.5, -15)
colorTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
colorTextBox.BackgroundTransparency = 0.5
colorTextBox.BorderSizePixel = 0
colorTextBox.Font = Enum.Font.Code
colorTextBox.TextSize = 12
colorTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
colorTextBox.Text = "0, 229, 255"
colorTextBox.ClearTextOnFocus = false
Instance.new("UICorner", colorTextBox).CornerRadius = UDim.new(0, 4)

local function SyncColorSelector(color)
    if typeof(color) ~= "Color3" then
        return
    end

    local hue = select(1, color:ToHSV())
    sliderBtn.Position = UDim2.new(hue, -6, 0.5, -10)
    sliderBtn.BackgroundColor3 = color
    colorTextBox.Text = string.format(
        "%d, %d, %d",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

SyncColorSelector(Config.ThemeColor)

local applyThemeBtn = Instance.new("TextButton")
applyThemeBtn.Parent = settingsScroll
applyThemeBtn.Size = UDim2.new(1, -10, 0, 32)
applyThemeBtn.BackgroundColor3 = Config.ThemeColor
applyThemeBtn.BorderSizePixel = 0
applyThemeBtn.AutoButtonColor = false
applyThemeBtn.Font = Enum.Font.GothamBold
applyThemeBtn.TextSize = 12
applyThemeBtn.TextColor3 = Color3.fromRGB(30, 30, 40)
applyThemeBtn.Text = "APPLY THEME"
applyThemeBtn.LayoutOrder = 4
Instance.new("UICorner", applyThemeBtn).CornerRadius = UDim.new(0, 6)

local rainbowToggleCard = Instance.new("Frame")
rainbowToggleCard.Parent = settingsScroll
rainbowToggleCard.Size = UDim2.new(1, -10, 0, 42)
rainbowToggleCard.BackgroundColor3 = Config.BgCard
rainbowToggleCard.BackgroundTransparency = 0.2
rainbowToggleCard.BorderSizePixel = 0
rainbowToggleCard.LayoutOrder = 5
Instance.new("UICorner", rainbowToggleCard).CornerRadius = UDim.new(0, 8)

local rainbowToggleLbl = Instance.new("TextLabel")
rainbowToggleLbl.Parent = rainbowToggleCard
rainbowToggleLbl.Size = UDim2.new(1, -60, 1, 0)
rainbowToggleLbl.Position = UDim2.new(0, 10, 0, 0)
rainbowToggleLbl.BackgroundTransparency = 1
rainbowToggleLbl.Font = Enum.Font.GothamBold
rainbowToggleLbl.TextSize = 11
rainbowToggleLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
rainbowToggleLbl.Text = "Rainbow Continuous:"
rainbowToggleLbl.TextXAlignment = Enum.TextXAlignment.Left

local rainbowStatusDot = Instance.new("Frame")
rainbowStatusDot.Parent = rainbowToggleCard
rainbowStatusDot.Size = UDim2.new(0, 14, 0, 14)
rainbowStatusDot.Position = UDim2.new(1, -25, 0.5, -7)
rainbowStatusDot.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
rainbowStatusDot.BorderSizePixel = 0
Instance.new("UICorner", rainbowStatusDot).CornerRadius = UDim.new(1, 0)

local rainbowClickArea = Instance.new("TextButton")
rainbowClickArea.Parent = rainbowToggleCard
rainbowClickArea.Size = UDim2.new(1, 0, 1, 0)
rainbowClickArea.BackgroundTransparency = 1
rainbowClickArea.Text = ""

-- ==================== PHẦN 2: CONTROL SECTION ====================
local transDividerContainer = Instance.new("Frame")
transDividerContainer.Parent = settingsScroll
transDividerContainer.Size = UDim2.new(1, -10, 0, 40)
transDividerContainer.BackgroundTransparency = 1
transDividerContainer.LayoutOrder = 5.5

local transDividerTitleLbl = Instance.new("TextLabel")
transDividerTitleLbl.Parent = transDividerContainer
transDividerTitleLbl.Size = UDim2.new(0, 0, 0, 20)
transDividerTitleLbl.Position = UDim2.new(0.5, 0, 0.5, -10)
transDividerTitleLbl.AnchorPoint = Vector2.new(0.5, 0.5)
transDividerTitleLbl.BackgroundTransparency = 1
transDividerTitleLbl.Font = Enum.Font.GothamBold
transDividerTitleLbl.TextSize = 13
transDividerTitleLbl.TextColor3 = Config.ThemeColor
transDividerTitleLbl.Text = "CONTROL"
transDividerTitleLbl.AutomaticSize = Enum.AutomaticSize.X
transDividerTitleLbl.ZIndex = 2
table.insert(allThemeTexts, transDividerTitleLbl)

local leftTransLine = Instance.new("Frame")
leftTransLine.Parent = transDividerContainer
leftTransLine.Size = UDim2.new(0.5, -45, 0, 2)
leftTransLine.Position = UDim2.new(0, 0, 0.5, -1)
leftTransLine.BackgroundColor3 = Config.ThemeColor
leftTransLine.BackgroundTransparency = 0.3
leftTransLine.BorderSizePixel = 0
Instance.new("UICorner", leftTransLine).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, leftTransLine)

local rightTransLine = Instance.new("Frame")
rightTransLine.Parent = transDividerContainer
rightTransLine.Size = UDim2.new(0.5, -45, 0, 2)
rightTransLine.Position = UDim2.new(0.5, 45, 0.5, -1)
rightTransLine.BackgroundColor3 = Config.ThemeColor
rightTransLine.BackgroundTransparency = 0.3
rightTransLine.BorderSizePixel = 0
Instance.new("UICorner", rightTransLine).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, rightTransLine)

-- ==================== CONTROL: UI SIZE ====================
local uiSizeContainer = Instance.new("Frame")
uiSizeContainer.Parent = settingsScroll
uiSizeContainer.Size = UDim2.new(1, -10, 0, 50)
uiSizeContainer.BackgroundTransparency = 1
uiSizeContainer.BorderSizePixel = 0
uiSizeContainer.LayoutOrder = 5.8
uiSizeContainer.ClipsDescendants = true

local uiSizeSelector = Instance.new("TextButton")
uiSizeSelector.Parent = uiSizeContainer
uiSizeSelector.Size = UDim2.new(1, 0, 0, 50)
uiSizeSelector.Position = UDim2.new(0, 0, 0, 0)
uiSizeSelector.BackgroundColor3 = Config.BgCard
uiSizeSelector.BackgroundTransparency = 0
uiSizeSelector.BorderSizePixel = 0
uiSizeSelector.AutoButtonColor = false
uiSizeSelector.Font = Enum.Font.GothamBold
uiSizeSelector.TextSize = 11
uiSizeSelector.TextColor3 = Color3.fromRGB(220, 220, 230)
uiSizeSelector.TextXAlignment = Enum.TextXAlignment.Left
uiSizeSelector.Text = ""
Instance.new("UICorner", uiSizeSelector).CornerRadius = UDim.new(0, 8)

-- Animated green status dot for Select Exaggerated.
local uiSizeStatusDot = Instance.new("Frame")
uiSizeStatusDot.Name = "SelectExaggeratedStatusDot"
uiSizeStatusDot.Parent = uiSizeSelector
uiSizeStatusDot.Size = UDim2.new(0, 8, 0, 8)
uiSizeStatusDot.Position = UDim2.new(0, 12, 0.5, -4)
uiSizeStatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
uiSizeStatusDot.BackgroundTransparency = 0
uiSizeStatusDot.BorderSizePixel = 0
uiSizeStatusDot.ZIndex = uiSizeSelector.ZIndex + 1
Instance.new("UICorner", uiSizeStatusDot).CornerRadius = UDim.new(1, 0)

-- Separate label keeps a clean, fixed gap between the green dot and the text.
local uiSizeSelectorLabel = Instance.new("TextLabel")
uiSizeSelectorLabel.Name = "SelectExaggeratedLabel"
uiSizeSelectorLabel.Parent = uiSizeSelector
uiSizeSelectorLabel.Size = UDim2.new(1, -38, 1, 0)
uiSizeSelectorLabel.Position = UDim2.new(0, 30, 0, 0)
uiSizeSelectorLabel.BackgroundTransparency = 1
uiSizeSelectorLabel.Font = Enum.Font.GothamBold
uiSizeSelectorLabel.TextSize = 11
uiSizeSelectorLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
uiSizeSelectorLabel.TextXAlignment = Enum.TextXAlignment.Left
uiSizeSelectorLabel.TextYAlignment = Enum.TextYAlignment.Center
uiSizeSelectorLabel.Text = "Select Exaggerated: Medium"
uiSizeSelectorLabel.ZIndex = uiSizeSelector.ZIndex + 1

local uiSizeStatusStroke = Instance.new("UIStroke")
uiSizeStatusStroke.Parent = uiSizeStatusDot
uiSizeStatusStroke.Color = Color3.fromRGB(0, 255, 100)
uiSizeStatusStroke.Thickness = 1
uiSizeStatusStroke.Transparency = 0.25

task.spawn(function()
    while uiSizeStatusDot and uiSizeStatusDot.Parent do
        local fadeOut = TweenService:Create(uiSizeStatusDot, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.72})
        local strokeOut = TweenService:Create(uiSizeStatusStroke, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.75})
        fadeOut:Play()
        strokeOut:Play()
        fadeOut.Completed:Wait()
        if not uiSizeStatusDot.Parent then break end

        local fadeIn = TweenService:Create(uiSizeStatusDot, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0})
        local strokeIn = TweenService:Create(uiSizeStatusStroke, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.25})
        fadeIn:Play()
        strokeIn:Play()
        fadeIn.Completed:Wait()
    end
end)

local uiSizeOptions = Instance.new("Frame")
uiSizeOptions.Parent = uiSizeContainer
uiSizeOptions.Size = UDim2.new(1, 0, 0, 108)
uiSizeOptions.Position = UDim2.new(0, 0, 0, 52)
uiSizeOptions.BackgroundColor3 = Config.BgCard
uiSizeOptions.BackgroundTransparency = 0
uiSizeOptions.BorderSizePixel = 0
uiSizeOptions.Visible = false
Instance.new("UICorner", uiSizeOptions).CornerRadius = UDim.new(0, 8)

local uiSizeList = Instance.new("UIListLayout")
uiSizeList.Parent = uiSizeOptions
uiSizeList.SortOrder = Enum.SortOrder.LayoutOrder
uiSizeList.Padding = UDim.new(0, 2)

local uiSizeOpen = false
local uiSizeChoices = {"Small", "Medium", "Large"}

local uiScaleMap = UISizeScaleMap

local function ApplyUISize(choice)
    if not uiScaleMap[choice] then return end

    Config.UIExaggeratedSize = choice
    local targetScale = uiScaleMap[choice]

    -- Synchronize both panels' current target before starting the tween.
    -- This prevents one panel from retaining the previous Small/Large value.
    settingsScale.Scale = targetScale

    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    -- Both UI panels use the exact same scale value and tween.
    local mainTween = TweenService:Create(mainScale, tweenInfo, {Scale = targetScale})
    local settingsTween = TweenService:Create(settingsScale, tweenInfo, {Scale = targetScale})

    mainTween:Play()
    settingsTween:Play()

    -- Keep the settings panel attached to the main panel during the tween.
    task.spawn(function()
        while mainTween.PlaybackState == Enum.PlaybackState.Playing do
            if main.Visible then
                local scaledMainHalfWidth = (Config.MainWidth * mainScale.Scale) / 2
                settingsWindow.Position = UDim2.new(
                    0.5,
                    scaledMainHalfWidth + 10,
                    0.5,
                    0
                )
            end
            task.wait()
        end

        if main.Visible then
            local scaledMainHalfWidth = (Config.MainWidth * targetScale) / 2
            settingsWindow.Position = UDim2.new(
                0.5,
                scaledMainHalfWidth + 10,
                0.5,
                0
            )
        end
    end)

    uiSizeSelectorLabel.Text = "Select Exaggerated: " .. choice
end

local function SetUISizeMenu(open)
    uiSizeOpen = open
    uiSizeOptions.Visible = open
    local targetHeight = open and 164 or 50
    uiSizeContainer.Size = UDim2.new(1, -10, 0, targetHeight)
end

for order, choice in ipairs(uiSizeChoices) do
    local option = Instance.new("TextButton")
    option.Parent = uiSizeOptions
    option.Size = UDim2.new(1, -8, 0, 34)
    option.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    option.BackgroundTransparency = 0
    option.BorderSizePixel = 0
    option.AutoButtonColor = false
    option.Font = Enum.Font.GothamBold
    option.TextSize = 11
    option.TextColor3 = Color3.fromRGB(225, 225, 235)
    option.Text = choice
    option.LayoutOrder = order
    Instance.new("UICorner", option).CornerRadius = UDim.new(0, 6)

    option.MouseEnter:Connect(function()
        option.BackgroundColor3 = Config.ThemeColor
        option.TextColor3 = Color3.fromRGB(25, 25, 30)
    end)

    option.MouseLeave:Connect(function()
        option.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        option.TextColor3 = Color3.fromRGB(225, 225, 235)
    end)

    option.MouseButton1Click:Connect(function()
        ApplyUISize(choice)
        SetUISizeMenu(false)
    end)
end

uiSizeSelector.MouseButton1Click:Connect(function()
    SetUISizeMenu(not uiSizeOpen)
end)

ApplyUISize(Config.UIExaggeratedSize)

-- ==================== CONTROL: RAINBOW SPEED ====================
local rainbowSpeedCard = Instance.new("Frame")
rainbowSpeedCard.Parent = settingsScroll
rainbowSpeedCard.Size = UDim2.new(1, -10, 0, 94)
rainbowSpeedCard.BackgroundColor3 = Config.BgCard
rainbowSpeedCard.BackgroundTransparency = 0.2
rainbowSpeedCard.BorderSizePixel = 0
rainbowSpeedCard.LayoutOrder = 5.7
Instance.new("UICorner", rainbowSpeedCard).CornerRadius = UDim.new(0, 8)

local rainbowSpeedTitle = Instance.new("TextLabel")
rainbowSpeedTitle.Parent = rainbowSpeedCard
rainbowSpeedTitle.Size = UDim2.new(1, -16, 0, 20)
rainbowSpeedTitle.Position = UDim2.new(0, 8, 0, 5)
rainbowSpeedTitle.BackgroundTransparency = 1
rainbowSpeedTitle.Font = Enum.Font.GothamBold
rainbowSpeedTitle.TextSize = 11
rainbowSpeedTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
rainbowSpeedTitle.Text = "Rainbow Speed:"
rainbowSpeedTitle.TextXAlignment = Enum.TextXAlignment.Left

local rainbowSpeedPercentLabel = Instance.new("TextLabel")
rainbowSpeedPercentLabel.Parent = rainbowSpeedCard
rainbowSpeedPercentLabel.Size = UDim2.new(0, 55, 0, 20)
rainbowSpeedPercentLabel.Position = UDim2.new(1, -63, 0, 5)
rainbowSpeedPercentLabel.BackgroundTransparency = 1
rainbowSpeedPercentLabel.Font = Enum.Font.GothamBold
rainbowSpeedPercentLabel.TextSize = 11
rainbowSpeedPercentLabel.TextColor3 = Config.ThemeColor
rainbowSpeedPercentLabel.Text = "100%"
rainbowSpeedPercentLabel.TextXAlignment = Enum.TextXAlignment.Right
table.insert(allThemeTexts, rainbowSpeedPercentLabel)

local rainbowSpeedBar = Instance.new("Frame")
rainbowSpeedBar.Parent = rainbowSpeedCard
rainbowSpeedBar.Size = UDim2.new(1, -16, 0, 8)
rainbowSpeedBar.Position = UDim2.new(0, 8, 0, 32)
rainbowSpeedBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
rainbowSpeedBar.BorderSizePixel = 0
Instance.new("UICorner", rainbowSpeedBar).CornerRadius = UDim.new(1, 0)

local rainbowSpeedFill = Instance.new("Frame")
rainbowSpeedFill.Parent = rainbowSpeedBar
rainbowSpeedFill.Size = UDim2.new(Config.RainbowSpeedPercent / 300, 0, 1, 0)
rainbowSpeedFill.BackgroundColor3 = Config.ThemeColor
rainbowSpeedFill.BorderSizePixel = 0
Instance.new("UICorner", rainbowSpeedFill).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, rainbowSpeedFill)

local rainbowSpeedSliderBtn = Instance.new("TextButton")
rainbowSpeedSliderBtn.Parent = rainbowSpeedBar
rainbowSpeedSliderBtn.Size = UDim2.new(0, 12, 0, 18)
rainbowSpeedSliderBtn.Position = UDim2.new(Config.RainbowSpeedPercent / 300, -6, 0.5, -9)
rainbowSpeedSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rainbowSpeedSliderBtn.Text = ""
rainbowSpeedSliderBtn.AutoButtonColor = false
Instance.new("UICorner", rainbowSpeedSliderBtn).CornerRadius = UDim.new(0, 4)

local rainbowSpeedInput = Instance.new("TextBox")
rainbowSpeedInput.Parent = rainbowSpeedCard
rainbowSpeedInput.Size = UDim2.new(1, -16, 0, 28)
rainbowSpeedInput.Position = UDim2.new(0, 8, 0, 54)
rainbowSpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
rainbowSpeedInput.BackgroundTransparency = 0.5
rainbowSpeedInput.BorderSizePixel = 0
rainbowSpeedInput.Font = Enum.Font.Code
rainbowSpeedInput.TextSize = 12
rainbowSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
rainbowSpeedInput.Text = tostring(Config.RainbowSpeedPercent)
rainbowSpeedInput.PlaceholderText = "Speed % (10 - 300)"
rainbowSpeedInput.ClearTextOnFocus = false
rainbowSpeedInput.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", rainbowSpeedInput).CornerRadius = UDim.new(0, 4)

local rainbowSpeedDragging = false

local function SetRainbowSpeedPercent(value)
    value = math.clamp(math.floor((tonumber(value) or Config.RainbowSpeedPercent) + 0.5), 10, 300)
    Config.RainbowSpeedPercent = value
    local normalized = value / 300

    rainbowSpeedFill.Size = UDim2.new(normalized, 0, 1, 0)
    rainbowSpeedSliderBtn.Position = UDim2.new(normalized, -6, 0.5, -9)
    rainbowSpeedInput.Text = tostring(value)
    rainbowSpeedPercentLabel.Text = tostring(value) .. "%"

    return value
end

SetRainbowSpeedPercent(Config.RainbowSpeedPercent)

rainbowSpeedSliderBtn.MouseButton1Down:Connect(function()
    rainbowSpeedDragging = true
end)

rainbowSpeedBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        rainbowSpeedDragging = true
    end
end)

rainbowSpeedInput.FocusLost:Connect(function()
    local value = tonumber(rainbowSpeedInput.Text)
    if value then
        SetRainbowSpeedPercent(value)
    else
        rainbowSpeedInput.Text = tostring(Config.RainbowSpeedPercent)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not rainbowSpeedDragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local barX = rainbowSpeedBar.AbsolutePosition.X
    local barWidth = rainbowSpeedBar.AbsoluteSize.X
    if barWidth <= 0 then return end

    local mouseX = UserInputService:GetMouseLocation().X
    local normalized = math.clamp((mouseX - barX) / barWidth, 0, 1)
    SetRainbowSpeedPercent(10 + normalized * 290)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        rainbowSpeedDragging = false
    end
end)

local transparencyCard = Instance.new("Frame")
transparencyCard.Parent = settingsScroll
transparencyCard.Size = UDim2.new(1, -10, 0, 135)
transparencyCard.BackgroundColor3 = Config.BgCard
transparencyCard.BackgroundTransparency = 0.2
transparencyCard.BorderSizePixel = 0
transparencyCard.LayoutOrder = 6
Instance.new("UICorner", transparencyCard).CornerRadius = UDim.new(0, 8)

local transTitleLbl = Instance.new("TextLabel")
transTitleLbl.Parent = transparencyCard
transTitleLbl.Size = UDim2.new(1, -10, 0, 22)
transTitleLbl.Position = UDim2.new(0, 8, 0, 5)
transTitleLbl.BackgroundTransparency = 1
transTitleLbl.Font = Enum.Font.GothamBold
transTitleLbl.TextSize = 11
transTitleLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
transTitleLbl.Text = "UI & Debug Transparency:"
transTitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local transSliderBar = Instance.new("Frame")
transSliderBar.Parent = transparencyCard
transSliderBar.Size = UDim2.new(1, -16, 0, 8)
transSliderBar.Position = UDim2.new(0, 8, 0, 32)
transSliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
transSliderBar.BorderSizePixel = 0
Instance.new("UICorner", transSliderBar).CornerRadius = UDim.new(1, 0)

local transSliderFill = Instance.new("Frame")
transSliderFill.Parent = transSliderBar
transSliderFill.Size = UDim2.new(Config.UITransparency, 0, 1, 0)
transSliderFill.BackgroundColor3 = Config.ThemeColor
transSliderFill.BorderSizePixel = 0
Instance.new("UICorner", transSliderFill).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, transSliderFill)

local transSliderBtn = Instance.new("TextButton")
transSliderBtn.Parent = transSliderBar
transSliderBtn.Size = UDim2.new(0, 12, 0, 18)
transSliderBtn.Position = UDim2.new(Config.UITransparency, -6, 0.5, -9)
transSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
transSliderBtn.Text = ""
Instance.new("UICorner", transSliderBtn).CornerRadius = UDim.new(0, 3)

local transInputBox = Instance.new("TextBox")
transInputBox.Parent = transparencyCard
transInputBox.Size = UDim2.new(1, -16, 0, 28)
transInputBox.Position = UDim2.new(0, 8, 0, 50)
transInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
transInputBox.BackgroundTransparency = 0.5
transInputBox.BorderSizePixel = 0
transInputBox.Font = Enum.Font.Code
transInputBox.TextSize = 12
transInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
transInputBox.Text = tostring(Config.UITransparency)
transInputBox.ClearTextOnFocus = false
Instance.new("UICorner", transInputBox).CornerRadius = UDim.new(0, 4)

local applyTransBtn = Instance.new("TextButton")
applyTransBtn.Parent = transparencyCard
applyTransBtn.Size = UDim2.new(1, -16, 0, 28)
applyTransBtn.Position = UDim2.new(0, 8, 0, 86)
applyTransBtn.BackgroundColor3 = Config.ThemeColor
applyTransBtn.BorderSizePixel = 0
applyTransBtn.AutoButtonColor = false
applyTransBtn.Font = Enum.Font.GothamBold
applyTransBtn.TextSize = 11
applyTransBtn.TextColor3 = Color3.fromRGB(30, 30, 40)
applyTransBtn.Text = "APPLY TRANSPARENCY"
Instance.new("UICorner", applyTransBtn).CornerRadius = UDim.new(0, 6)

-- ==================== PHẦN 3: HOTKEY SECTION ====================
local hotkeyDividerContainer = Instance.new("Frame")
hotkeyDividerContainer.Parent = settingsScroll
hotkeyDividerContainer.Size = UDim2.new(1, -10, 0, 40)
hotkeyDividerContainer.BackgroundTransparency = 1
hotkeyDividerContainer.LayoutOrder = 6.5

local hotkeyDividerTitleLbl = Instance.new("TextLabel")
hotkeyDividerTitleLbl.Parent = hotkeyDividerContainer
hotkeyDividerTitleLbl.Size = UDim2.new(0, 0, 0, 20)
hotkeyDividerTitleLbl.Position = UDim2.new(0.5, 0, 0.5, -10)
hotkeyDividerTitleLbl.AnchorPoint = Vector2.new(0.5, 0.5)
hotkeyDividerTitleLbl.BackgroundTransparency = 1
hotkeyDividerTitleLbl.Font = Enum.Font.GothamBold
hotkeyDividerTitleLbl.TextSize = 13
hotkeyDividerTitleLbl.TextColor3 = Config.ThemeColor
hotkeyDividerTitleLbl.Text = "HOTKEY"
hotkeyDividerTitleLbl.AutomaticSize = Enum.AutomaticSize.X
hotkeyDividerTitleLbl.ZIndex = 2
table.insert(allThemeTexts, hotkeyDividerTitleLbl)

local leftHotkeyLine = Instance.new("Frame")
leftHotkeyLine.Parent = hotkeyDividerContainer
leftHotkeyLine.Size = UDim2.new(0.5, -45, 0, 2)
leftHotkeyLine.Position = UDim2.new(0, 0, 0.5, -1)
leftHotkeyLine.BackgroundColor3 = Config.ThemeColor
leftHotkeyLine.BackgroundTransparency = 0.3
leftHotkeyLine.BorderSizePixel = 0
Instance.new("UICorner", leftHotkeyLine).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, leftHotkeyLine)

local rightHotkeyLine = Instance.new("Frame")
rightHotkeyLine.Parent = hotkeyDividerContainer
rightHotkeyLine.Size = UDim2.new(0.5, -45, 0, 2)
rightHotkeyLine.Position = UDim2.new(0.5, 45, 0.5, -1)
rightHotkeyLine.BackgroundColor3 = Config.ThemeColor
rightHotkeyLine.BackgroundTransparency = 0.3
rightHotkeyLine.BorderSizePixel = 0
Instance.new("UICorner", rightHotkeyLine).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, rightHotkeyLine)

local hotkeyCard = Instance.new("Frame")
hotkeyCard.Parent = settingsScroll
hotkeyCard.Size = UDim2.new(1, -10, 0, 50)
hotkeyCard.BackgroundColor3 = Config.BgCard
hotkeyCard.BackgroundTransparency = 0.2
hotkeyCard.BorderSizePixel = 0
hotkeyCard.LayoutOrder = 7
Instance.new("UICorner", hotkeyCard).CornerRadius = UDim.new(0, 8)

local hotkeyLbl = Instance.new("TextLabel")
hotkeyLbl.Parent = hotkeyCard
hotkeyLbl.Size = UDim2.new(0, 110, 1, 0)
hotkeyLbl.Position = UDim2.new(0, 10, 0, 0)
hotkeyLbl.BackgroundTransparency = 1
hotkeyLbl.Font = Enum.Font.GothamBold
hotkeyLbl.TextSize = 11
hotkeyLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
hotkeyLbl.Text = "Toggle Hotkey:"
hotkeyLbl.TextXAlignment = Enum.TextXAlignment.Left

local hotkeyButtonBox = Instance.new("TextButton")
hotkeyButtonBox.Parent = hotkeyCard
hotkeyButtonBox.Size = UDim2.new(0, 95, 0, 30)
hotkeyButtonBox.Position = UDim2.new(1, -105, 0.5, -15)
hotkeyButtonBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
hotkeyButtonBox.BackgroundTransparency = 0.5
hotkeyButtonBox.BorderSizePixel = 0
hotkeyButtonBox.Font = Enum.Font.GothamBold
hotkeyButtonBox.TextSize = 12
hotkeyButtonBox.TextColor3 = Config.ThemeColor
hotkeyButtonBox.Text = tostring(Config.ToggleKey.Name)
Instance.new("UICorner", hotkeyButtonBox).CornerRadius = UDim.new(0, 6)
table.insert(allThemeTexts, hotkeyButtonBox)

local listeningKey = false
hotkeyButtonBox.MouseButton1Click:Connect(function()
    if listeningKey then return end
    listeningKey = true
    hotkeyButtonBox.Text = "Press Key..."
    hotkeyButtonBox.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Config.ToggleKey = input.KeyCode
            hotkeyButtonBox.Text = tostring(input.KeyCode.Name)
            hotkeyButtonBox.TextColor3 = Config.ThemeColor
            listeningKey = false
            ShowNotification("Hotkey changed to: " .. tostring(input.KeyCode.Name))
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
end)

-- ==================== PHẦN 4: DEBUG SECTION ====================
local debugToggleCard = Instance.new("Frame")
debugToggleCard.Parent = settingsScroll
debugToggleCard.Size = UDim2.new(1, -10, 0, 42)
debugToggleCard.BackgroundColor3 = Config.BgCard
debugToggleCard.BackgroundTransparency = 0.2
debugToggleCard.BorderSizePixel = 0
debugToggleCard.LayoutOrder = 8
Instance.new("UICorner", debugToggleCard).CornerRadius = UDim.new(0, 8)

local debugToggleLbl = Instance.new("TextLabel")
debugToggleLbl.Parent = debugToggleCard
debugToggleLbl.Size = UDim2.new(1, -60, 1, 0)
debugToggleLbl.Position = UDim2.new(0, 10, 0, 0)
debugToggleLbl.BackgroundTransparency = 1
debugToggleLbl.Font = Enum.Font.GothamBold
debugToggleLbl.TextSize = 11
debugToggleLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
debugToggleLbl.Text = "Show Debug Info:"
debugToggleLbl.TextXAlignment = Enum.TextXAlignment.Left

local debugStatusDot = Instance.new("Frame")
debugStatusDot.Parent = debugToggleCard
debugStatusDot.Size = UDim2.new(0, 14, 0, 14)
debugStatusDot.Position = UDim2.new(1, -25, 0.5, -7)
debugStatusDot.BackgroundColor3 = Config.ShowDebug and Color3.fromRGB(50, 230, 80) or Color3.fromRGB(230, 50, 50)
debugStatusDot.BorderSizePixel = 0
Instance.new("UICorner", debugStatusDot).CornerRadius = UDim.new(1, 0)

local debugClickArea = Instance.new("TextButton")
debugClickArea.Parent = debugToggleCard
debugClickArea.Size = UDim2.new(1, 0, 1, 0)
debugClickArea.BackgroundTransparency = 1
debugClickArea.Text = ""

local CONTENT_BORDER_COLOR = Color3.fromRGB(128, 128, 128)
local contentHoverRegistry = {}

local isRainbowRunning = false
local rainbowTransitionActive = false
local staticThemeColor = Config.ThemeColor
local rainbowHue = select(1, Config.ThemeColor:ToHSV())
local tabButtons = {}
local activeTabName = "Home"

local function ApplyGlobalTheme(newColor)
    Config.ThemeColor = newColor

    if not isRainbowRunning and not rainbowTransitionActive then
        staticThemeColor = newColor
    end
    
    mainStroke.Color = newColor
    glowBorder.Color = newColor
    settingsStroke.Color = newColor
    lineStroke.Color = newColor
    
    applyThemeBtn.BackgroundColor3 = newColor
    applyTransBtn.BackgroundColor3 = newColor
    transSliderFill.BackgroundColor3 = newColor
    
    for _, txtObj in ipairs(allThemeTexts) do
        if txtObj and txtObj.Parent then
            txtObj.TextColor3 = newColor
        end
    end
    
    for _, lineObj in ipairs(allHubLines) do
        if lineObj and lineObj.Parent then
            lineObj.BackgroundColor3 = newColor
        end
    end
end

task.spawn(function()
    while gui and gui.Parent do
        if isRainbowRunning then
            rainbowStatusDot.BackgroundColor3 = Color3.fromRGB(50, 230, 80)
            TweenService:Create(rainbowStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
            task.wait(0.5)
            TweenService:Create(rainbowStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.5)
        else
            rainbowStatusDot.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
            TweenService:Create(rainbowStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
            task.wait(0.5)
            TweenService:Create(rainbowStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.5)
        end
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        if Config.ShowDebug then
            debugStatusDot.BackgroundColor3 = Color3.fromRGB(50, 230, 80)
            TweenService:Create(debugStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
            task.wait(0.5)
            TweenService:Create(debugStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.5)
        else
            debugStatusDot.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
            TweenService:Create(debugStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
            task.wait(0.5)
            TweenService:Create(debugStatusDot, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.5)
        end
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        if isRainbowRunning and not rainbowTransitionActive and not themeLoadingActive then
            rainbowHue = (rainbowHue + (0.0025 * (Config.RainbowSpeedPercent / 100))) % 1
            local rainbowColor = Color3.fromHSV(rainbowHue, 1, 1)

            ApplyGlobalTheme(rainbowColor)
            sliderBtn.BackgroundColor3 = rainbowColor
            colorTextBox.Text = string.format(
                "%d, %d, %d",
                math.floor(rainbowColor.R * 255 + 0.5),
                math.floor(rainbowColor.G * 255 + 0.5),
                math.floor(rainbowColor.B * 255 + 0.5)
            )

            for _, strokeObj in ipairs(allHubStrokes) do
                if strokeObj and strokeObj.Parent and not contentHoverRegistry[strokeObj] then
                    strokeObj.Color = rainbowColor
                end
            end

            for strokeObj, state in pairs(contentHoverRegistry) do
                if strokeObj and strokeObj.Parent then
                    if state.hovered then
                        strokeObj.Color = rainbowColor
                        state.glow.BackgroundColor3 = rainbowColor
                    else
                        strokeObj.Color = CONTENT_BORDER_COLOR
                    end
                end
            end

            for name, btn in pairs(tabButtons) do
                local stroke = btn:FindFirstChildOfClass("UIStroke")

                if name == activeTabName then
                    btn.BackgroundColor3 = rainbowColor
                    btn.TextColor3 = Color3.fromRGB(30, 30, 40)
                    if stroke then
                        stroke.Color = rainbowColor
                    end
                else
                    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                    btn.TextColor3 = rainbowColor
                    if stroke then
                        stroke.Color = rainbowColor
                    end
                end
            end
        elseif not isRainbowRunning and not rainbowTransitionActive and not themeLoadingActive then
            ApplyGlobalTheme(staticThemeColor)

            for _, strokeObj in ipairs(allHubStrokes) do
                if strokeObj and strokeObj.Parent and not contentHoverRegistry[strokeObj] then
                    strokeObj.Color = staticThemeColor
                end
            end

            for strokeObj, state in pairs(contentHoverRegistry) do
                if strokeObj and strokeObj.Parent then
                    if state.hovered then
                        strokeObj.Color = staticThemeColor
                        state.glow.BackgroundColor3 = staticThemeColor
                    else
                        strokeObj.Color = CONTENT_BORDER_COLOR
                    end
                end
            end

            for name, btn in pairs(tabButtons) do
                local stroke = btn:FindFirstChildOfClass("UIStroke")

                if name == activeTabName then
                    btn.BackgroundColor3 = staticThemeColor
                    btn.TextColor3 = Color3.fromRGB(30, 30, 40)
                    if stroke then
                        stroke.Color = staticThemeColor
                    end
                else
                    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
                    if stroke then
                        stroke.Color = staticThemeColor
                    end
                end
            end
        end

        task.wait(0.03)
    end
end)

rainbowClickArea.MouseButton1Click:Connect(function()
    if themeLoadingActive or rainbowTransitionActive then
        return
    end

    local enableRainbow = not isRainbowRunning
    rainbowTransitionActive = true

    if enableRainbow then
        staticThemeColor = Config.ThemeColor
        rainbowHue = select(1, staticThemeColor:ToHSV())
        isRainbowRunning = false

        local firstRainbowColor = Color3.fromHSV(rainbowHue, 1, 1)
        local started = PlayAdvancedThemeLoading(
            firstRainbowColor,
            "RAINBOW MODE",
            "Starting Rainbow Continuous"
        )

        if not started then
            rainbowTransitionActive = false
            return
        end

        task.spawn(function()
            task.wait(THEME_LOADING_APPLY_DELAY)

            if not themeLoadingActive or not loadingScreen.Parent then
                rainbowTransitionActive = false
                return
            end

            isRainbowRunning = true
            rainbowTransitionActive = false
            ApplyGlobalTheme(firstRainbowColor)
            SyncColorSelector(firstRainbowColor)

            loadingStatus.Text = "RAINBOW ACTIVE"

            task.wait(THEME_LOADING_FINISH_DELAY)

            if themeLoadingActive then
                FinishAdvancedThemeLoading()
            end
        end)

        ShowNotification("Rainbow Continuous Loading...")
    else
        isRainbowRunning = false
        local restoreColor = staticThemeColor

        local started = PlayAdvancedThemeLoading(
            restoreColor,
            "RAINBOW MODE",
            "Returning To Static Theme"
        )

        if not started then
            rainbowTransitionActive = false
            return
        end

        task.spawn(function()
            task.wait(THEME_LOADING_APPLY_DELAY)

            if not themeLoadingActive or not loadingScreen.Parent then
                rainbowTransitionActive = false
                return
            end

            ApplyGlobalTheme(restoreColor)
            SyncColorSelector(restoreColor)

            rainbowTransitionActive = false
            loadingStatus.Text = "THEME RESTORED"

            task.wait(THEME_LOADING_FINISH_DELAY)

            if themeLoadingActive then
                FinishAdvancedThemeLoading()
            end
        end)

        ShowNotification("Rainbow Continuous Stopping...")
    end
end)

local draggingTrans = false
transSliderBtn.MouseButton1Down:Connect(function() draggingTrans = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingTrans = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingTrans and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = transSliderBar.AbsolutePosition.X
        local barSize = transSliderBar.AbsoluteSize.X
        local clampedX = math.clamp((mousePos - barPos) / barSize, 0, 1)
        transSliderBtn.Position = UDim2.new(clampedX, -6, 0.5, -9)
        transSliderFill.Size = UDim2.new(clampedX, 0, 1, 0)
        local valRounded = tonumber(string.format("%.2f", clampedX))
        transInputBox.Text = tostring(valRounded)
    end
end)

local debugSidebarFrame = Instance.new("Frame")
debugSidebarFrame.Name = "DebugSidebar"
debugSidebarFrame.Parent = gui
-- Tight height: 5 debug lines + small vertical padding.
debugSidebarFrame.Size = UDim2.new(0, 180, 0, 76)
debugSidebarFrame.Position = UDim2.new(1, -190, 1, -138)
debugSidebarFrame.BackgroundColor3 = Config.BgCard
debugSidebarFrame.BackgroundTransparency = Config.DebugTransparency
debugSidebarFrame.BorderSizePixel = 0
debugSidebarFrame.Visible = Config.ShowDebug
Instance.new("UICorner", debugSidebarFrame).CornerRadius = UDim.new(0, 8)
local debugSidebarStroke = Instance.new("UIStroke")
debugSidebarStroke.Parent = debugSidebarFrame
debugSidebarStroke.Thickness = 1
debugSidebarStroke.Color = Config.ThemeColor
table.insert(allHubStrokes, debugSidebarStroke)

local debugSidebarText = Instance.new("TextLabel")
debugSidebarText.Parent = debugSidebarFrame
debugSidebarText.Size = UDim2.new(1, -12, 0, 70)
debugSidebarText.Position = UDim2.new(0, 6, 0, 3)
debugSidebarText.TextWrapped = false
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
-- Tight height: title + key row with minimal bottom padding.
keyStatusSidebarFrame.Size = UDim2.new(0, 180, 0, 56)
keyStatusSidebarFrame.Position = UDim2.new(1, -190, 1, -56)
keyStatusSidebarFrame.BackgroundColor3 = Config.BgCard
keyStatusSidebarFrame.BackgroundTransparency = Config.DebugTransparency
keyStatusSidebarFrame.BorderSizePixel = 0
keyStatusSidebarFrame.Visible = Config.ShowDebug
Instance.new("UICorner", keyStatusSidebarFrame).CornerRadius = UDim.new(0, 8)
local keyStatusStroke = Instance.new("UIStroke")
keyStatusStroke.Parent = keyStatusSidebarFrame
keyStatusStroke.Thickness = 1
keyStatusStroke.Color = Config.ThemeColor
table.insert(allHubStrokes, keyStatusStroke)

local debugDividerBetween = Instance.new("Frame")
debugDividerBetween.Parent = gui
debugDividerBetween.Size = UDim2.new(0, 180, 0, 2)
debugDividerBetween.Position = UDim2.new(1, -190, 1, -60)
debugDividerBetween.BackgroundColor3 = Config.ThemeColor
debugDividerBetween.BackgroundTransparency = 0.2
debugDividerBetween.BorderSizePixel = 0
debugDividerBetween.Visible = Config.ShowDebug
Instance.new("UICorner", debugDividerBetween).CornerRadius = UDim.new(1, 0)
table.insert(allHubLines, debugDividerBetween)

applyTransBtn.MouseButton1Click:Connect(function()
    local val = tonumber(transInputBox.Text)
    if val then
        val = math.clamp(val, 0, 1)
        Config.UITransparency = val
        Config.DebugTransparency = val
        
        main.BackgroundTransparency = val
        settingsWindow.BackgroundTransparency = val
        debugSidebarFrame.BackgroundTransparency = val
        keyStatusSidebarFrame.BackgroundTransparency = val
        
        transSliderBtn.Position = UDim2.new(val, -6, 0.5, -9)
        transSliderFill.Size = UDim2.new(val, 0, 1, 0)
        transInputBox.Text = tostring(val)
        
        ShowNotification("Transparency applied successfully!")
    else
        ShowNotification("Invalid transparency number! Use 0 to 1")
    end
end)

debugClickArea.MouseButton1Click:Connect(function()
    Config.ShowDebug = not Config.ShowDebug
    debugSidebarFrame.Visible = Config.ShowDebug
    keyStatusSidebarFrame.Visible = Config.ShowDebug
    debugDividerBetween.Visible = Config.ShowDebug
    if Config.ShowDebug then
        ShowNotification("Debug Info Enabled!")
    else
        ShowNotification("Debug Info Disabled!")
    end
end)

local draggingSlider = false

sliderBtn.MouseButton1Down:Connect(function()
    if themeLoadingActive then
        return
    end

    if isRainbowRunning then
        isRainbowRunning = false
        ShowNotification("Rainbow Continuous Disabled via Slider!")
    end

    draggingSlider = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = sliderBar.AbsolutePosition.X
        local barSize = sliderBar.AbsoluteSize.X

        if barSize <= 0 then
            return
        end

        local clampedX = math.clamp(
            (mousePos - barPos) / barSize,
            0,
            1
        )

        local newColor = Color3.fromHSV(clampedX, 1, 1)

        sliderBtn.Position = UDim2.new(
            clampedX,
            -6,
            0.5,
            -10
        )

        sliderBtn.BackgroundColor3 = newColor
        colorTextBox.Text = string.format(
            "%d, %d, %d",
            math.floor(newColor.R * 255 + 0.5),
            math.floor(newColor.G * 255 + 0.5),
            math.floor(newColor.B * 255 + 0.5)
        )
    end
end)

applyThemeBtn.MouseButton1Click:Connect(function()
    if themeLoadingActive or rainbowTransitionActive then
        return
    end

    local r, g, b = colorTextBox.Text:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")

    local targetColor = nil

    if r and g and b then
        local rr = math.clamp(tonumber(r), 0, 255)
        local gg = math.clamp(tonumber(g), 0, 255)
        local bb = math.clamp(tonumber(b), 0, 255)

        targetColor = Color3.fromRGB(rr, gg, bb)
    else
        local hex = colorTextBox.Text:gsub("#", "")

        if #hex == 6 then
            local rHex = tonumber(hex:sub(1, 2), 16)
            local gHex = tonumber(hex:sub(3, 4), 16)
            local bHex = tonumber(hex:sub(5, 6), 16)

            if rHex and gHex and bHex then
                targetColor = Color3.fromRGB(rHex, gHex, bHex)
            end
        end
    end

    if not targetColor then
        ShowNotification("Invalid color format! Use R, G, B (e.g. 0,229,255)")
        return
    end

    isRainbowRunning = false
    rainbowTransitionActive = true

    staticThemeColor = targetColor
    SyncColorSelector(targetColor)

    local started = PlayAdvancedThemeLoading(
        targetColor,
        "FISHHUB",
        "Applying Theme & Reloading UI"
    )

    if not started then
        rainbowTransitionActive = false
        return
    end

    ShowNotification("Applying theme...")

    task.spawn(function()
        -- UI remains hidden for the entire apply phase.
        task.wait(THEME_LOADING_APPLY_DELAY)

        if not themeLoadingActive or not loadingScreen.Parent then
            rainbowTransitionActive = false
            return
        end

        -- Apply everything while the main UI is still hidden.
        ApplyGlobalTheme(targetColor)
        SyncColorSelector(targetColor)

        loadingStatus.Text = "THEME APPLIED"

        TweenService:Create(
            progressFill,
            TweenInfo.new(
                0.45,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {Size = UDim2.new(1, 0, 1, 0)}
        ):Play()

        rainbowTransitionActive = false

        task.wait(THEME_LOADING_FINISH_DELAY)

        if themeLoadingActive then
            FinishAdvancedThemeLoading()
        end

        ShowNotification("Theme applied successfully to UI & Lines!")
    end)
end)

local function ToggleSettings()
    if settingsWindow.Visible then
        settingsWindow.Visible = false
    else
        settingsWindow.Visible = true
    end
end

local currentTween = nil

-- Reliable GUI state.
-- Do NOT use BackgroundTransparency/Visible as the toggle state because
-- animations, theme loading, and other UI effects can temporarily change them.
local isMainOpen = false
local toggleSerial = 0
local lastToggleAt = 0
local TOGGLE_DEBOUNCE = 0.12

OpenGUI = function()
    toggleSerial = toggleSerial + 1
    local mySerial = toggleSerial

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    isMainOpen = true

    -- Never reset Main to 1.0 here: 1.0 means Medium.
    local selectedScale = UISizeScaleMap[Config.UIExaggeratedSize] or 1.0

    main.Visible = true
    settingsWindow.Visible = false

    if not Config.GUIAnimation then
        mainScale.Scale = selectedScale
        settingsScale.Scale = selectedScale
        main.BackgroundTransparency = Config.UITransparency
        return
    end

    -- Animate from a smaller version of the CURRENT selected size.
    mainScale.Scale = selectedScale * 0.85
    settingsScale.Scale = selectedScale
    main.BackgroundTransparency = 1

    local fadeTween = TweenService:Create(
        main,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {BackgroundTransparency = Config.UITransparency}
    )

    local scaleTween = TweenService:Create(
        mainScale,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Scale = selectedScale}
    )

    currentTween = fadeTween
    fadeTween:Play()
    scaleTween:Play()

    task.spawn(function()
        fadeTween.Completed:Wait()

        -- Ignore an old animation if the user toggled again.
        if mySerial ~= toggleSerial or not isMainOpen then
            return
        end

        currentTween = nil
        main.Visible = true
        mainScale.Scale = selectedScale
        settingsScale.Scale = selectedScale
    end)
end

CloseGUI = function()
    toggleSerial = toggleSerial + 1
    local mySerial = toggleSerial

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    isMainOpen = false
    settingsWindow.Visible = false

    local selectedScale = UISizeScaleMap[Config.UIExaggeratedSize] or 1.0

    if not Config.GUIAnimation then
        main.Visible = false
        mainScale.Scale = selectedScale
        settingsScale.Scale = selectedScale
        return
    end

    local fadeTween = TweenService:Create(
        main,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )

    local scaleTween = TweenService:Create(
        mainScale,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Scale = selectedScale * 0.85}
    )

    currentTween = fadeTween
    fadeTween:Play()
    scaleTween:Play()

    task.spawn(function()
        fadeTween.Completed:Wait()

        -- Hide based on the real state, not on a transparency comparison.
        -- This guarantees the UI is actually hidden after the hotkey press.
        if mySerial ~= toggleSerial or isMainOpen then
            return
        end

        main.Visible = false
        mainScale.Scale = selectedScale
        settingsScale.Scale = selectedScale
        currentTween = nil
    end)
end

ToggleMain = function()
    local now = os.clock()

    -- Prevent double-fire/rapid key repeat from immediately reopening the UI.
    if now - lastToggleAt < TOGGLE_DEBOUNCE then
        return
    end
    lastToggleAt = now

    if isMainOpen then
        CloseGUI()
    else
        OpenGUI()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    -- While choosing a new hotkey, the key belongs to the key-picker
    -- connection and must not simultaneously toggle the UI.
    if listeningKey then
        return
    end

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
line.BackgroundColor3 = Config.ThemeColor
line.BorderSizePixel = 0
table.insert(allHubLines, line)

local rightBottomStatus = Instance.new("TextLabel")
rightBottomStatus.Parent = main
rightBottomStatus.Size = UDim2.new(0, 200, 0, 20)
rightBottomStatus.Position = UDim2.new(1, -12, 1, -12)
rightBottomStatus.AnchorPoint = Vector2.new(1, 1)
rightBottomStatus.BackgroundTransparency = 1
rightBottomStatus.RichText = true
rightBottomStatus.Font = Enum.Font.GothamBold
rightBottomStatus.TextSize = 10
rightBottomStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
rightBottomStatus.TextXAlignment = Enum.TextXAlignment.Right
rightBottomStatus.TextYAlignment = Enum.TextYAlignment.Bottom

task.spawn(function()
    while rightBottomStatus and rightBottomStatus.Parent do
        rightBottomStatus.Text = "<font color='#00FF00'>•</font> Status: working | <font color='#A855F7'>•</font> Version: v1"
        task.wait(0.6)
        rightBottomStatus.Text = "<font color='#006600'>•</font> Status: working | <font color='#581C87'>•</font> Version: v1"
        task.wait(0.6)
    end
end)

local joinDiscordBtn = Instance.new("TextButton")
joinDiscordBtn.Parent = main
joinDiscordBtn.Size = UDim2.new(0, 140, 0, 24)
joinDiscordBtn.Position = UDim2.new(0, 12, 1, -12)
joinDiscordBtn.AnchorPoint = Vector2.new(0, 1)
joinDiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
joinDiscordBtn.BorderSizePixel = 0
joinDiscordBtn.AutoButtonColor = false
joinDiscordBtn.Font = Enum.Font.GothamBold
joinDiscordBtn.TextSize = 11
joinDiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
joinDiscordBtn.Text = "💬 Join Discord"
Instance.new("UICorner", joinDiscordBtn).CornerRadius = UDim.new(0, 6)

local joinDiscordStroke = Instance.new("UIStroke")
joinDiscordStroke.Parent = joinDiscordBtn
joinDiscordStroke.Color = Config.ThemeColor
joinDiscordStroke.Thickness = 1
table.insert(allHubStrokes, joinDiscordStroke)

local function GetCurrentAccentColor()
    if isRainbowRunning and not rainbowTransitionActive and not themeLoadingActive then
        return Color3.fromHSV(rainbowHue, 1, 1)
    end
    return Config.ThemeColor
end

local function CreateCursorGlow(parent)
    -- A single soft glow is used instead of horizontal/vertical glow bars.
    -- This prevents the cursor effect from leaving a visible cross-shaped trail.
    local glow = Instance.new("Frame")
    glow.Name = "CursorSoftGlow"
    glow.Parent = parent
    glow.Size = UDim2.new(0, 86, 0, 86)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.BackgroundColor3 = Config.ThemeColor
    glow.BackgroundTransparency = 0.93
    glow.BorderSizePixel = 0
    glow.Active = false
    glow.Visible = false
    glow.ZIndex = math.max(0, parent.ZIndex - 1)

    local corner = Instance.new("UICorner")
    corner.Parent = glow
    corner.CornerRadius = UDim.new(0, 24)

    -- Soft edge falloff. No UIStroke and no crossing bars.
    local gradient = Instance.new("UIGradient")
    gradient.Parent = glow
    gradient.Rotation = 45
    gradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.18, 0.98),
        NumberSequenceKeypoint.new(0.5, 0.72),
        NumberSequenceKeypoint.new(0.82, 0.98),
        NumberSequenceKeypoint.new(1, 1)
    })

    return glow
end

local function AddHoverGlow(card, stroke)
    if not card or not stroke then return end

    card.ClipsDescendants = true
    stroke.Color = CONTENT_BORDER_COLOR

    local state = {
        hovered = false,
        stroke = stroke,
        card = card,
        glow = CreateCursorGlow(card)
    }

    contentHoverRegistry[stroke] = state

    local function UpdateGlow(x, y)
        if not card.Parent then return end

        local accent = GetCurrentAccentColor()
        stroke.Color = accent
        state.glow.BackgroundColor3 = accent

        local localX = math.clamp(
            x or card.AbsoluteSize.X * 0.5,
            0,
            card.AbsoluteSize.X
        )

        local localY = math.clamp(
            y or card.AbsoluteSize.Y * 0.5,
            0,
            card.AbsoluteSize.Y
        )

        state.glow.Position = UDim2.fromOffset(localX, localY)
        state.glow.Visible = true
    end

    card.MouseEnter:Connect(function(x, y)
        state.hovered = true
        UpdateGlow(x, y)
    end)

    card.MouseMoved:Connect(function(x, y)
        if state.hovered then
            UpdateGlow(x, y)
        end
    end)

    card.MouseLeave:Connect(function()
        state.hovered = false
        state.glow.Visible = false
        stroke.Color = CONTENT_BORDER_COLOR
    end)
end

AddHoverGlow(joinDiscordBtn, joinDiscordStroke)

joinDiscordBtn.MouseButton1Click:Connect(function()
    local discordUrl = "https://discord.gg/zFN6Nd99fC"
    pcall(function()
        if setclipboard then
            setclipboard(discordUrl)
        end
    end)
    ShowNotification("Successfully copied Discord link!")
end)

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

local contentContainer = Instance.new("Frame")
contentContainer.Parent = main
contentContainer.Size = UDim2.new(1, -20, 1, -120)
contentContainer.Position = UDim2.new(0, 10, 0, 90)
contentContainer.BackgroundTransparency = 1

local tabs = {}

local function CreateTabContent(name)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name .. "Tab"
    tabFrame.Parent = contentContainer
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.Visible = false
    
    tabFrame.ScrollBarThickness = 0
    
    if name == "Home" then
        local homeLayout = Instance.new("UIListLayout")
        homeLayout.Parent = tabFrame
        homeLayout.SortOrder = Enum.SortOrder.LayoutOrder
        homeLayout.Padding = UDim.new(0, 12)

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
        table.insert(allHubStrokes, welcomeStroke)
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
        welcomeTitle.Text = "Welcome to FishHub!"
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

        local function CreateSectionDivider(text, order)
            local dividerContainer = Instance.new("Frame")
            dividerContainer.Parent = tabFrame
            dividerContainer.Size = UDim2.new(1, 0, 0, 30)
            dividerContainer.BackgroundTransparency = 1
            dividerContainer.LayoutOrder = order

            local textLbl = Instance.new("TextLabel")
            textLbl.Parent = dividerContainer
            textLbl.Size = UDim2.new(0, 0, 1, 0)
            textLbl.Position = UDim2.new(0.5, 0, 0, 0)
            textLbl.BackgroundTransparency = 1
            textLbl.Font = Enum.Font.GothamBold
            textLbl.TextSize = 12
            textLbl.TextColor3 = Config.ThemeColor
            textLbl.Text = string.upper(text)
            textLbl.AutomaticSize = Enum.AutomaticSize.X
            textLbl.AnchorPoint = Vector2.new(0.5, 0)
            table.insert(allThemeTexts, textLbl)

            local leftLine = Instance.new("Frame")
            leftLine.Parent = dividerContainer
            leftLine.Size = UDim2.new(0.5, -95, 0, 3)
            leftLine.Position = UDim2.new(0, 0, 0.5, -1.5)
            leftLine.BackgroundColor3 = Config.ThemeColor
            leftLine.BorderSizePixel = 0
            Instance.new("UICorner", leftLine).CornerRadius = UDim.new(1, 0)
            table.insert(allHubLines, leftLine)

            local rightLine = Instance.new("Frame")
            rightLine.Parent = dividerContainer
            rightLine.Size = UDim2.new(0.5, -95, 0, 3)
            rightLine.Position = UDim2.new(0.5, 95, 0.5, -1.5)
            rightLine.BackgroundColor3 = Config.ThemeColor
            rightLine.BorderSizePixel = 0
            Instance.new("UICorner", rightLine).CornerRadius = UDim.new(1, 0)
            table.insert(allHubLines, rightLine)
        end

        CreateSectionDivider("player status", 2)

        local statsContainer = Instance.new("Frame")
        statsContainer.Parent = tabFrame
        statsContainer.Size = UDim2.new(1, 0, 0, 130)
        statsContainer.BackgroundTransparency = 1
        statsContainer.LayoutOrder = 3

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = statsContainer
        gridLayout.CellSize = UDim2.new(0.5, -5, 0, 56)
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
            stroke.Color = Config.ThemeColor
            stroke.Thickness = 1
            table.insert(allHubStrokes, stroke)
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

        task.spawn(function()
            while tabFrame and tabFrame.Parent do
                pcall(function()
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
                            elseif ls:FindFirstChild("Honor") then honor = ls.Honor.Value
                            elseif ls:FindFirstChild("Bounty/Honor") then bounty = ls["Bounty/Honor"].Value end
                        end
                        if bounty == "0" and Player:FindFirstChild("Data") then
                            local data = Player.Data
                            if data:FindFirstChild("Bounty") then bounty = data.Bounty.Value
                            elseif data:FindFirstChild("Honor") then honor = data.Honor.Value
                            elseif data:FindFirstChild("Bounty/Honor") then bounty = data["Bounty/Honor"].Value end
                        end
                        factionVal.Text = tostring(bounty)
                    end
                end)
                task.wait(1)
            end
        end)

        CreateSectionDivider("information", 4)

        local profileCard = Instance.new("Frame")
        profileCard.Parent = tabFrame
        profileCard.Size = UDim2.new(1, 0, 0, 215)
        profileCard.BackgroundColor3 = Config.BgCard
        profileCard.BackgroundTransparency = 0.2
        profileCard.BorderSizePixel = 0
        profileCard.LayoutOrder = 5
        Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 10)
        local profileStroke = Instance.new("UIStroke")
        profileStroke.Parent = profileCard
        profileStroke.Color = Config.ThemeColor
        profileStroke.Thickness = 1
        table.insert(allHubStrokes, profileStroke)
        AddHoverGlow(profileCard, profileStroke)

        local avtImg = Instance.new("ImageLabel")
        avtImg.Parent = profileCard
        avtImg.Size = UDim2.new(0, 66, 0, 66)
        avtImg.Position = UDim2.new(0, 12, 0, 10)
        avtImg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        avtImg.BorderSizePixel = 0
        avtImg.Image = "rbxassetid://0"
        Instance.new("UICorner", avtImg).CornerRadius = UDim.new(1, 0)
        local avtStroke = Instance.new("UIStroke")
        avtStroke.Parent = avtImg
        avtStroke.Color = Config.ThemeColor
        avtStroke.Thickness = 2
        table.insert(allHubStrokes, avtStroke)

        task.spawn(function()
            pcall(function()
                local content = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                avtImg.Image = content
            end)
        end)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = profileCard
        nameLbl.Size = UDim2.new(1, -95, 0, 20)
        nameLbl.Position = UDim2.new(0, 90, 0, 10)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Text = Player.DisplayName
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local tagLbl = Instance.new("TextLabel")
        tagLbl.Parent = profileCard
        tagLbl.Size = UDim2.new(1, -95, 0, 16)
        tagLbl.Position = UDim2.new(0, 90, 0, 30)
        tagLbl.BackgroundTransparency = 1
        tagLbl.Font = Enum.Font.GothamMedium
        tagLbl.TextSize = 11
        tagLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        tagLbl.Text = "@" .. Player.Name
        tagLbl.TextXAlignment = Enum.TextXAlignment.Left

        local idLbl = Instance.new("TextLabel")
        idLbl.Parent = profileCard
        idLbl.Size = UDim2.new(1, -95, 0, 16)
        idLbl.Position = UDim2.new(0, 90, 0, 48)
        idLbl.BackgroundTransparency = 1
        idLbl.Font = Enum.Font.GothamMedium
        idLbl.TextSize = 11
        idLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        idLbl.Text = "UserID: " .. tostring(Player.UserId)
        idLbl.TextXAlignment = Enum.TextXAlignment.Left

        local executorLbl = Instance.new("TextLabel")
        executorLbl.Parent = profileCard
        executorLbl.Size = UDim2.new(1, -95, 0, 16)
        executorLbl.Position = UDim2.new(0, 90, 0, 66)
        executorLbl.BackgroundTransparency = 1
        executorLbl.Font = Enum.Font.GothamMedium
        executorLbl.TextSize = 11
        executorLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
        
        local executorName = "Unknown"
        pcall(function()
            if identifyexecutor then
                executorName = identifyexecutor()
            elseif getexecutorname then
                executorName = getexecutorname()
            end
        end)
        executorLbl.Text = "Executor: " .. tostring(executorName)
        executorLbl.TextXAlignment = Enum.TextXAlignment.Left

        local infoDivider = Instance.new("Frame")
        infoDivider.Parent = profileCard
        infoDivider.Size = UDim2.new(1, -20, 0, 1)
        infoDivider.Position = UDim2.new(0, 10, 0, 86)
        infoDivider.BackgroundColor3 = Config.ThemeColor
        infoDivider.BorderSizePixel = 0
        table.insert(allHubLines, infoDivider)

        local function CreateCopyRow(labelText, valToCopy, yPos)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = profileCard
            lbl.Size = UDim2.new(0, 75, 0, 24)
            lbl.Position = UDim2.new(0, 12, 0, yPos)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
            lbl.Text = labelText
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local valBox = Instance.new("TextBox")
            valBox.Parent = profileCard
            valBox.Size = UDim2.new(1, -170, 0, 24)
            valBox.Position = UDim2.new(0, 85, 0, yPos)
            valBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            valBox.BackgroundTransparency = 0.5
            valBox.BorderSizePixel = 0
            valBox.Font = Enum.Font.Code
            valBox.TextSize = 11
            valBox.TextColor3 = Config.ThemeColor
            valBox.Text = tostring(valToCopy)
            valBox.ClearTextOnFocus = false
            valBox.TextEditable = false
            Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)
            table.insert(allThemeTexts, valBox)

            local copyBtn = Instance.new("TextButton")
            copyBtn.Parent = profileCard
            copyBtn.Size = UDim2.new(0, 60, 0, 24)
            copyBtn.Position = UDim2.new(1, -72, 0, yPos)
            copyBtn.BackgroundColor3 = Config.ThemeColor
            copyBtn.BorderSizePixel = 0
            copyBtn.AutoButtonColor = false
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.TextSize = 11
            copyBtn.TextColor3 = Color3.fromRGB(30, 30, 40)
            copyBtn.Text = "COPY"
            Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 4)

            copyBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if setclipboard then
                        setclipboard(tostring(valToCopy))
                    end
                end)
                ShowNotification("Successfully copied " .. labelText .. "!")
            end)
        end

        CreateCopyRow("PlaceID:", game.PlaceId, 98)
        CreateCopyRow("JobID:", game.JobId, 128)

        local inputLbl = Instance.new("TextLabel")
        inputLbl.Parent = profileCard
        inputLbl.Size = UDim2.new(0, 75, 0, 24)
        inputLbl.Position = UDim2.new(0, 12, 0, 158)
        inputLbl.BackgroundTransparency = 1
        inputLbl.Font = Enum.Font.GothamBold
        inputLbl.TextSize = 11
        inputLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
        inputLbl.Text = "Input Job:"
        inputLbl.TextXAlignment = Enum.TextXAlignment.Left

        local customJobBox = Instance.new("TextBox")
        customJobBox.Parent = profileCard
        customJobBox.Size = UDim2.new(1, -170, 0, 24)
        customJobBox.Position = UDim2.new(0, 85, 0, 158)
        customJobBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        customJobBox.BackgroundTransparency = 0.5
        customJobBox.BorderSizePixel = 0
        customJobBox.Font = Enum.Font.Code
        customJobBox.TextSize = 11
        customJobBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        customJobBox.PlaceholderText = "Paste Job ID here..."
        customJobBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        customJobBox.Text = ""
        customJobBox.ClearTextOnFocus = false
        Instance.new("UICorner", customJobBox).CornerRadius = UDim.new(0, 4)

        local joinCustomBtn = Instance.new("TextButton")
        joinCustomBtn.Parent = profileCard
        joinCustomBtn.Size = UDim2.new(0, 60, 0, 24)
        joinCustomBtn.Position = UDim2.new(1, -72, 0, 158)
        joinCustomBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
        joinCustomBtn.BorderSizePixel = 0
        joinCustomBtn.AutoButtonColor = false
        joinCustomBtn.Font = Enum.Font.GothamBold
        joinCustomBtn.TextSize = 11
        joinCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinCustomBtn.Text = "JOIN"
        Instance.new("UICorner", joinCustomBtn).CornerRadius = UDim.new(0, 4)
        
        local joinCustomStroke = Instance.new("UIStroke")
        joinCustomStroke.Parent = joinCustomBtn
        joinCustomStroke.Color = Config.ThemeColor
        joinCustomStroke.Thickness = 1
        table.insert(allHubStrokes, joinCustomStroke)
        AddHoverGlow(joinCustomBtn, joinCustomStroke)

        joinCustomBtn.MouseButton1Click:Connect(function()
            local targetJobId = customJobBox.Text
            if targetJobId and targetJobId ~= "" then
                pcall(function()
                    ShowNotification("Teleporting to custom Job ID...")
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, Player)
                end)
            else
                ShowNotification("Please enter a valid Job ID first!")
            end
        end)

        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
    elseif name == "Function" then
        -- ================================================================
        -- FUNCTION MODULE LAUNCHER
        -- FishHub only launches external modules.
        -- Each module owns its COMPLETE page/UI and logic.
        -- ================================================================

        local MODULES = {
            Shop = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/Shop.lua",
            ["Setting farm"] = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/SettingFarm.lua",
            Farm = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/Farm.lua",
            ["Item and Quest"] = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/ItemAndQuest.lua",
            ["Teleport Island"] = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/TeleportIsland.lua",
            Fruit = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/Fruit.lua",
            ESP = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/ESP.lua",
            Setting = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub_GitHub_Complete/FunctionModules/Setting.lua"
        }

        local ModuleRunner = {}

        function ModuleRunner:CloseCurrentModule()
            local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not playerGui then return end

            local old = playerGui:FindFirstChild("FishHubExternalModule")
            if old then
                old:Destroy()
            end
        end

        function ModuleRunner:Run(name)
            local url = MODULES[name]
            if not url then return end

            self:CloseCurrentModule()

            task.spawn(function()
                local okHttp, source = pcall(function()
                    return game:HttpGet(url)
                end)

                if not okHttp or type(source) ~= "string" or source == "" then
                    warn("[FishHub] Module failed to download:", name, source)
                    return
                end

                local compiler = loadstring or load
                if type(compiler) ~= "function" then
                    warn("[FishHub] loadstring is unavailable.")
                    return
                end

                local chunk, compileError = compiler(source)
                if not chunk then
                    warn("[FishHub] Module compile error:", name, compileError)
                    return
                end

                local okRun, result = pcall(chunk, {
                    Name = name,
                    Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),
                    Close = function()
                        ModuleRunner:CloseCurrentModule()
                    end
                })

                if not okRun then
                    warn("[FishHub] Module runtime error:", name, result)
                end
            end)
        end

        -- Function cards stay lightweight: no feature code is embedded here.
        local function MakeModuleButton(parent, title, icon, order)
            local button = Instance.new("TextButton")
            button.Parent = parent
            button.LayoutOrder = order
            button.Size = UDim2.new(0.5, -8, 0, 72)
            button.BackgroundColor3 = Config.BgCard
            button.BackgroundTransparency = 0.15
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = ""

            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

            local stroke = Instance.new("UIStroke")
            stroke.Parent = button
            stroke.Color = Config.ThemeColor
            stroke.Thickness = 1

            local iconLabel = Instance.new("TextLabel")
            iconLabel.Parent = button
            iconLabel.Size = UDim2.new(0, 40, 1, 0)
            iconLabel.Position = UDim2.new(0, 8, 0, 0)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Text = icon
            iconLabel.TextSize = 22
            iconLabel.Font = Enum.Font.GothamBold

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Parent = button
            titleLabel.Size = UDim2.new(1, -58, 1, 0)
            titleLabel.Position = UDim2.new(0, 55, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextSize = 13
            titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.18), {
                    BackgroundTransparency = 0
                }):Play()
            end)

            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.18), {
                    BackgroundTransparency = 0.15
                }):Play()
            end)

            button.MouseButton1Click:Connect(function()
                ModuleRunner:Run(title)
            end)
        end

        local moduleContainer = Instance.new("ScrollingFrame")
        moduleContainer.Parent = tabFrame
        moduleContainer.Size = UDim2.new(1, 0, 1, 0)
        moduleContainer.BackgroundTransparency = 1
        moduleContainer.BorderSizePixel = 0
        moduleContainer.ScrollBarThickness = 3
        moduleContainer.CanvasSize = UDim2.new(0, 0, 0, 360)

        local moduleLayout = Instance.new("UIGridLayout")
        moduleLayout.Parent = moduleContainer
        moduleLayout.CellSize = UDim2.new(0.5, -8, 0, 72)
        moduleLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        moduleLayout.SortOrder = Enum.SortOrder.LayoutOrder

        MakeModuleButton(moduleContainer, "Shop", "🛒", 1)
        MakeModuleButton(moduleContainer, "Setting farm", "⚙️", 2)
        MakeModuleButton(moduleContainer, "Farm", "⚔️", 3)
        MakeModuleButton(moduleContainer, "Item and Quest", "📦", 4)
        MakeModuleButton(moduleContainer, "Teleport Island", "🏝️", 5)
        MakeModuleButton(moduleContainer, "Fruit", "🍎", 6)
        MakeModuleButton(moduleContainer, "ESP", "👁️", 7)
        MakeModuleButton(moduleContainer, "Setting", "🛠️", 8)

        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    elseif name == "Creative" then
        local creativeLayout = Instance.new("UIListLayout")
        creativeLayout.Parent = tabFrame
        creativeLayout.SortOrder = Enum.SortOrder.LayoutOrder
        creativeLayout.Padding = UDim.new(0, 15)
        creativeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local paddingFrame = Instance.new("Frame")
        paddingFrame.Parent = tabFrame
        paddingFrame.Size = UDim2.new(1, 0, 0, 40)
        paddingFrame.BackgroundTransparency = 1
        paddingFrame.LayoutOrder = 1

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
        table.insert(allHubStrokes, avtCardStroke)
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
        infoStroke.Color = Config.ThemeColor
        infoStroke.Thickness = 1.5
        table.insert(allHubStrokes, infoStroke)
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
        table.insert(allThemeTexts, scriptTitleLbl)

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
        label.Text = "This is the content of page: " .. name
        label.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    tabs[name] = tabFrame
    return tabFrame
end

CreateTabContent("Home")
CreateTabContent("Function")
CreateTabContent("Creative")

local function SwitchTab(tabName)
    activeTabName = tabName
    for name, frame in pairs(tabs) do
        if name == tabName then
            frame.Visible = true
        else
            frame.Visible = false
        end
    end
    
    if not isRainbowRunning then
        for name, btn in pairs(tabButtons) do
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if name == tabName then
                btn.BackgroundColor3 = Config.ThemeColor
                btn.TextColor3 = Color3.fromRGB(30, 30, 40)
                if stroke then stroke.Color = Config.ThemeColor end
            else
                btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                btn.TextColor3 = Color3.fromRGB(230, 230, 240)
                if stroke then stroke.Color = Config.ThemeColor end
            end
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
    btnStroke.Color = Config.ThemeColor
    btnStroke.Thickness = 1
    table.insert(allHubStrokes, btnStroke)
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    
    tabButtons[name] = btn
end

CreateNavButton("Home")
CreateNavButton("Function")
CreateNavButton("Creative")

local runningLineContainer = Instance.new("Frame")
runningLineContainer.Parent = main
runningLineContainer.Size = UDim2.new(1, 0, 0, 32)
runningLineContainer.Position = UDim2.new(0, 0, 0, 52)
runningLineContainer.BackgroundTransparency = 1
runningLineContainer.ZIndex = 5

local exactSideWidth = 180 
local exactMaxChars = 27    

local leftRunningLabel = Instance.new("TextLabel")
leftRunningLabel.Parent = runningLineContainer
leftRunningLabel.Size = UDim2.new(0, exactSideWidth, 1, 0)
leftRunningLabel.Position = UDim2.new(0, 10, 0, 0)
leftRunningLabel.BackgroundTransparency = 1
leftRunningLabel.Font = Enum.Font.Code
leftRunningLabel.TextSize = 13
leftRunningLabel.TextColor3 = Config.ThemeColor
leftRunningLabel.TextXAlignment = Enum.TextXAlignment.Right
leftRunningLabel.ClipsDescendants = true
leftRunningLabel.ZIndex = 5
table.insert(allThemeTexts, leftRunningLabel)

local rightRunningLabel = Instance.new("TextLabel")
rightRunningLabel.Parent = runningLineContainer
rightRunningLabel.Size = UDim2.new(0, exactSideWidth, 1, 0)
rightRunningLabel.Position = UDim2.new(1, -exactSideWidth - 10, 0, 0)
rightRunningLabel.BackgroundTransparency = 1
rightRunningLabel.Font = Enum.Font.Code
rightRunningLabel.TextSize = 13
rightRunningLabel.TextColor3 = Config.ThemeColor
rightRunningLabel.TextXAlignment = Enum.TextXAlignment.Left
rightRunningLabel.ClipsDescendants = true
rightRunningLabel.ZIndex = 5
table.insert(allThemeTexts, rightRunningLabel)

task.spawn(function()
    while runningLineContainer and runningLineContainer.Parent do
        for i = 0, exactMaxChars do
            if not (runningLineContainer and runningLineContainer.Parent) then break end
            leftRunningLabel.Text = string.rep("=", i) .. ">"
            rightRunningLabel.Text = "<" .. string.rep("=", i)
            task.wait(0.06)
        end
    end
end)

SwitchTab("Home")

local keyStatusTitle = Instance.new("TextLabel")
keyStatusTitle.Parent = keyStatusSidebarFrame
keyStatusTitle.Size = UDim2.new(1, -12, 0, 16)
keyStatusTitle.Position = UDim2.new(0, 6, 0, 4)
keyStatusTitle.BackgroundTransparency = 1
keyStatusTitle.Font = Enum.Font.GothamBold
keyStatusTitle.TextSize = 9.5
keyStatusTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
keyStatusTitle.Text = "KEY STATUS"
keyStatusTitle.TextXAlignment = Enum.TextXAlignment.Left

local keyInnerCard = Instance.new("Frame")
keyInnerCard.Parent = keyStatusSidebarFrame
keyInnerCard.Size = UDim2.new(1, -12, 0, 26)
keyInnerCard.Position = UDim2.new(0, 6, 0, 26)
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
    btnStroke.Color = Config.ThemeColor
    btnStroke.Thickness = 1
    table.insert(allHubStrokes, btnStroke)
    AddHoverGlow(btn, btnStroke)
    return btn
end

local closeBtn = CreateCircleButton("×", 12)
local hideBtn  = CreateCircleButton("─", 44)
local gearBtn  = CreateCircleButton("⚙", 76)

local confirm = Instance.new("Frame")
confirm.Name = "ThemeConfirm"
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
confirmStroke.Color = Config.ThemeColor
confirmStroke.Thickness = 1
table.insert(allHubStrokes, confirmStroke)
AddHoverGlow(confirm, confirmStroke)

local txt = Instance.new("TextLabel")
txt.Parent = confirm
txt.Size = UDim2.new(1, -20, 0, 40)
txt.Position = UDim2.new(0, 10, 0, 25)
txt.BackgroundTransparency = 1
txt.Font = Enum.Font.GothamBold
txt.TextSize = 13
txt.TextColor3 = Color3.fromRGB(240, 240, 240)
txt.TextWrapped = true
txt.TextXAlignment = Enum.TextXAlignment.Center
txt.TextYAlignment = Enum.TextYAlignment.Center

local yes = Instance.new("TextButton")
yes.Parent = confirm
yes.Size = UDim2.new(0.38, 0, 0, 30)
yes.Position = UDim2.new(0.08, 0, 1, -45)
yes.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
yes.TextColor3 = Color3.new(1, 1, 1)
yes.Font = Enum.Font.GothamBold
yes.TextSize = 12
Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 6)
local yesStroke = Instance.new("UIStroke")
yesStroke.Parent = yes
yesStroke.Color = Config.ThemeColor
yesStroke.Thickness = 1
table.insert(allHubStrokes, yesStroke)
AddHoverGlow(yes, yesStroke)

local no = Instance.new("TextButton")
no.Parent = confirm
no.Size = UDim2.new(0.38, 0, 0, 30)
no.Position = UDim2.new(0.54, 0, 1, -45)
no.BackgroundColor3 = Color3.fromRGB(55, 60, 75)
no.TextColor3 = Color3.new(1, 1, 1)
no.Font = Enum.Font.GothamBold
no.TextSize = 12
Instance.new("UICorner", no).CornerRadius = UDim.new(0, 6)
local noStroke = Instance.new("UIStroke")
noStroke.Parent = no
noStroke.Color = Config.ThemeColor
noStroke.Thickness = 1
table.insert(allHubStrokes, noStroke)
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