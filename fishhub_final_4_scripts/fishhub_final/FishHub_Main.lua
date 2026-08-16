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
    ToggleKey = Enum.KeyCode.K,
    ThemeColor = Color3.fromRGB(0, 229, 255),
    BgMain = Color3.fromRGB(45, 45, 52),
    BgCard = Color3.fromRGB(55, 55, 65),
    BorderColor = Color3.fromRGB(90, 90, 110),
    ShowDebug = true,
    UITransparency = 0.25,
    DebugTransparency = 0.25,
    RainbowSpeedPercent = 100,
}
local OpenGUI, CloseGUI, ToggleMain
local gui = Instance.new("ScreenGui")
gui.Name = "FishHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui
local allHubStrokes = {}
local allHubLines = {}
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
local THEME_LOADING_APPLY_DELAY = 2.15
local THEME_LOADING_FINISH_DELAY = 0.15
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
        TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    )
    fade:Play()
    task.delay(0.5, function()
        if not loadingScreen or not loadingScreen.Parent then
            themeLoadingActive = false
            RestoreUIAfterThemeLoading()
            return
        end
        loadingScreen.Visible = false
        progressFill.Size = UDim2.new(1, 0, 1, 0)
        loadingCard.BackgroundTransparency = 0.08
        loadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
        loadingTitle.TextTransparency = 1
        loadingText.TextTransparency = 1
        loadingDots.TextTransparency = 1
        loadingStatus.TextTransparency = 1
        task.defer(function()
            if loadingScreen.Visible == false then
                progressFill.Size = UDim2.new(0, 0, 1, 0)
            end
        end)
        loadingGlow.Size = UDim2.new(0, 280, 0, 280)
        loadingGlow.BackgroundTransparency = 1
        loadingRing.Size = UDim2.new(0, 42, 0, 42)
        loadingRing.Rotation = 0
        themeLoadingActive = false
        RestoreUIAfterThemeLoading()
    end)
    return
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
    TweenService:Create(progressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.18, 0, 1, 0)}):Play()
    task.delay(0.45, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(progressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.42, 0, 1, 0)}):Play()
        end
    end)
    task.delay(0.9, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(progressFill, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.68, 0, 1, 0)}):Play()
        end
    end)
    task.delay(1.45, function()
        if themeLoadingActive and loadingScreen.Parent then
            TweenService:Create(progressFill, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 0, 1, 0)}):Play()
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
openLine.Size = UDim2.new(0,500,0,40)
openLine.Position = UDim2.new(0.5,0,0,8)
openLine.AnchorPoint = Vector2.new(0.5,0)
openLine.BackgroundColor3 = Color3.fromRGB(11,13,20)
openLine.BackgroundTransparency = 0.03
openLine.BorderSizePixel = 0
openLine.ZIndex = 900
Instance.new("UICorner",openLine).CornerRadius = UDim.new(1,0)
local openGradient = Instance.new("UIGradient")
openGradient.Parent = openLine
openGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(8,10,16)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(28,31,43)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(8,10,16))})
local openStroke = Instance.new("UIStroke")
openStroke.Parent = openLine
openStroke.Thickness = 1.5
openStroke.Color = Config.ThemeColor
openStroke.Transparency = 0.08
table.insert(allHubStrokes,openStroke)
local openGlow = Instance.new("UIStroke")
openGlow.Parent = openLine
openGlow.Thickness = 7
openGlow.Color = Config.ThemeColor
openGlow.Transparency = 0.86
table.insert(allHubStrokes,openGlow)
local openDot = Instance.new("Frame")
openDot.Parent = openLine
openDot.Size = UDim2.new(0,8,0,8)
openDot.Position = UDim2.new(0,18,0.5,0)
openDot.AnchorPoint = Vector2.new(0.5,0.5)
openDot.BackgroundColor3 = Config.ThemeColor
openDot.BorderSizePixel = 0
openDot.ZIndex = 902
Instance.new("UICorner",openDot).CornerRadius = UDim.new(1,0)
local openDotGlow = Instance.new("UIStroke")
openDotGlow.Parent = openDot
openDotGlow.Thickness = 3
openDotGlow.Color = Config.ThemeColor
openDotGlow.Transparency = 0.35
local openTitle = Instance.new("TextLabel")
openTitle.Parent = openLine
openTitle.Size = UDim2.new(0,190,1,0)
openTitle.Position = UDim2.new(0,34,0,0)
openTitle.BackgroundTransparency = 1
openTitle.Font = Enum.Font.GothamBold
openTitle.TextSize = 12
openTitle.TextColor3 = Color3.fromRGB(242,244,250)
openTitle.RichText = true
openTitle.Text = '<font color="#173B63">FISH</font><font color="#3B285E">HUB</font>'
openTitle.TextXAlignment = Enum.TextXAlignment.Left
openTitle.ZIndex = 902
local openSub = Instance.new("TextLabel")
openSub.Parent = openLine
openSub.Size = UDim2.new(0,90,1,0)
openSub.Position = UDim2.new(0,108,0,0)
openSub.BackgroundTransparency = 1
openSub.Font = Enum.Font.Code
openSub.TextSize = 8
openSub.TextColor3 = Color3.fromRGB(135,140,155)
openSub.Text = "CONTROL PANEL"
openSub.TextXAlignment = Enum.TextXAlignment.Left
openSub.ZIndex = 902
local openStatus = Instance.new("TextLabel")
openStatus.Parent = openLine
openStatus.Size = UDim2.new(0,65,1,0)
openStatus.Position = UDim2.new(1,-92,0,0)
openStatus.BackgroundTransparency = 1
openStatus.Font = Enum.Font.GothamBold
openStatus.TextSize = 9
openStatus.TextColor3 = Config.ThemeColor
openStatus.Text = "OPEN"
openStatus.TextXAlignment = Enum.TextXAlignment.Right
openStatus.ZIndex = 902
local openIcon = Instance.new("TextLabel")
openIcon.Parent = openLine
openIcon.Size = UDim2.new(0,18,1,0)
openIcon.Position = UDim2.new(1,-22,0,0)
openIcon.BackgroundTransparency = 1
openIcon.Font = Enum.Font.GothamBold
openIcon.TextSize = 15
openIcon.TextColor3 = Config.ThemeColor
openIcon.Text = "^"
openIcon.ZIndex = 902
local lineButton = Instance.new("TextButton")
lineButton.Parent = openLine
lineButton.Size = UDim2.fromScale(1,1)
lineButton.BackgroundTransparency = 1
lineButton.Text = ""
lineButton.AutoButtonColor = false
lineButton.ZIndex = 903
local openHover = false
lineButton.MouseEnter:Connect(function()
openHover=true
TweenService:Create(openLine,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{Size=UDim2.new(0,520,0,42),BackgroundTransparency=0}):Play()
TweenService:Create(openGlow,TweenInfo.new(0.18),{Transparency=0.55}):Play()
TweenService:Create(openStroke,TweenInfo.new(0.18),{Transparency=0}):Play()
end)
lineButton.MouseLeave:Connect(function()
openHover=false
TweenService:Create(openLine,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{Size=UDim2.new(0,500,0,40),BackgroundTransparency=0.03}):Play()
TweenService:Create(openGlow,TweenInfo.new(0.18),{Transparency=0.86}):Play()
TweenService:Create(openStroke,TweenInfo.new(0.18),{Transparency=0.08}):Play()
end)
lineButton.MouseButton1Click:Connect(function()
if ToggleMain then ToggleMain() end
end)
task.spawn(function()
local phase=0
while gui and gui.Parent do
phase=(phase+0.008)%1
openGradient.Offset=Vector2.new(phase*2-1,0)
if not openHover then
TweenService:Create(openDotGlow,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.75}):Play()
task.wait(0.8)
TweenService:Create(openDotGlow,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.3}):Play()
task.wait(0.8)
else
task.wait(0.08)
end
end
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
local function CreateSectionDivider(title, order)
    local container = Instance.new("Frame")
    container.Parent = settingsScroll
    container.Size = UDim2.new(1, -10, 0, 28)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Position = UDim2.new(0.5, 0, 0, 0)
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Config.ThemeColor
    label.Text = title
    label.AutomaticSize = Enum.AutomaticSize.X
    label.ZIndex = 2
    table.insert(allThemeTexts, label)
    local line = Instance.new("Frame")
    line.Parent = container
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 0, 18)
    line.BackgroundColor3 = Config.ThemeColor
    line.BorderSizePixel = 0
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = line
    gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.9),NumberSequenceKeypoint.new(0.18, 0.55),NumberSequenceKeypoint.new(0.38, 0.2),NumberSequenceKeypoint.new(0.5, 0),NumberSequenceKeypoint.new(0.62, 0.2),NumberSequenceKeypoint.new(0.82, 0.55),NumberSequenceKeypoint.new(1, 0.9)})
    table.insert(allHubLines, line)
end
CreateSectionDivider("THEME", 1)
local colorPalette=Instance.new("Frame")
colorPalette.Name="ColorPalette"
colorPalette.Parent=settingsScroll
colorPalette.Size=UDim2.new(1,-10,0,178)
colorPalette.BackgroundColor3=Color3.fromRGB(18,20,28)
colorPalette.BorderSizePixel=0
colorPalette.LayoutOrder=2
Instance.new("UICorner",colorPalette).CornerRadius=UDim.new(0,12)
local paletteStroke=Instance.new("UIStroke")
paletteStroke.Parent=colorPalette
paletteStroke.Thickness=1
paletteStroke.Color=Config.ThemeColor
table.insert(allHubStrokes,paletteStroke)
local paletteTitle=Instance.new("TextLabel")
paletteTitle.Parent=colorPalette
paletteTitle.Size=UDim2.new(1,-20,0,22)
paletteTitle.Position=UDim2.new(0,10,0,6)
paletteTitle.BackgroundTransparency=1
paletteTitle.Text="THEME COLOR"
paletteTitle.Font=Enum.Font.GothamBold
paletteTitle.TextSize=10
paletteTitle.TextColor3=Color3.fromRGB(180,185,200)
paletteTitle.TextXAlignment=Enum.TextXAlignment.Left
local palettePreview=Instance.new("Frame")
palettePreview.Parent=colorPalette
palettePreview.Size=UDim2.new(0,34,0,20)
palettePreview.Position=UDim2.new(1,-44,0,7)
palettePreview.BackgroundColor3=Config.ThemeColor
palettePreview.BorderSizePixel=0
Instance.new("UICorner",palettePreview).CornerRadius=UDim.new(0,6)
local paletteValue=Instance.new("TextLabel")
paletteValue.Parent=colorPalette
paletteValue.Size=UDim2.new(0,90,0,18)
paletteValue.Position=UDim2.new(1,-140,0,8)
paletteValue.BackgroundTransparency=1
paletteValue.TextColor3=Color3.fromRGB(150,155,170)
paletteValue.Font=Enum.Font.Code
paletteValue.TextSize=9
paletteValue.TextXAlignment=Enum.TextXAlignment.Right
local svArea=Instance.new("Frame")
svArea.Parent=colorPalette
svArea.Size=UDim2.new(1,-54,0,118)
svArea.Position=UDim2.new(0,10,0,34)
svArea.BackgroundColor3=Color3.fromHSV(0,1,1)
svArea.BorderSizePixel=0
svArea.ClipsDescendants=true
Instance.new("UICorner",svArea).CornerRadius=UDim.new(0,8)
local svWhite=Instance.new("Frame")
svWhite.Parent=svArea
svWhite.Size=UDim2.fromScale(1,1)
svWhite.BackgroundColor3=Color3.new(1,1,1)
svWhite.BorderSizePixel=0
local whiteGradient=Instance.new("UIGradient")
whiteGradient.Parent=svWhite
whiteGradient.Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1))
whiteGradient.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
whiteGradient.Rotation=0
local svBlack=Instance.new("Frame")
svBlack.Parent=svArea
svBlack.Size=UDim2.fromScale(1,1)
svBlack.BackgroundColor3=Color3.new(0,0,0)
svBlack.BorderSizePixel=0
local blackGradient=Instance.new("UIGradient")
blackGradient.Parent=svBlack
blackGradient.Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0))
blackGradient.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
blackGradient.Rotation=90
local svButton=Instance.new("TextButton")
svButton.Parent=svArea
svButton.Size=UDim2.fromScale(1,1)
svButton.BackgroundTransparency=1
svButton.Text=""
svButton.AutoButtonColor=false
svButton.ZIndex=5
local svCursor=Instance.new("Frame")
svCursor.Parent=svArea
svCursor.Size=UDim2.new(0,12,0,12)
svCursor.AnchorPoint=Vector2.new(0.5,0.5)
svCursor.BackgroundColor3=Color3.new(1,1,1)
svCursor.BorderSizePixel=0
svCursor.ZIndex=7
Instance.new("UICorner",svCursor).CornerRadius=UDim.new(1,0)
local svCursorStroke=Instance.new("UIStroke")
svCursorStroke.Parent=svCursor
svCursorStroke.Thickness=2
svCursorStroke.Color=Color3.new(0,0,0)
local hueBar=Instance.new("Frame")
hueBar.Parent=colorPalette
hueBar.Size=UDim2.new(0,18,0,118)
hueBar.Position=UDim2.new(1,-32,0,34)
hueBar.BackgroundColor3=Color3.new(1,1,1)
hueBar.BorderSizePixel=0
hueBar.ZIndex=4
Instance.new("UICorner",hueBar).CornerRadius=UDim.new(1,0)
local hueGradient=Instance.new("UIGradient")
hueGradient.Parent=hueBar
hueGradient.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
ColorSequenceKeypoint.new(0.1667,Color3.fromRGB(255,255,0)),
ColorSequenceKeypoint.new(0.3333,Color3.fromRGB(0,255,0)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
ColorSequenceKeypoint.new(0.6667,Color3.fromRGB(0,0,255)),
ColorSequenceKeypoint.new(0.8333,Color3.fromRGB(255,0,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))
})
hueGradient.Rotation=90
local hueButton=Instance.new("TextButton")
hueButton.Parent=hueBar
hueButton.Size=UDim2.fromScale(1,1)
hueButton.BackgroundTransparency=1
hueButton.Text=""
hueButton.AutoButtonColor=false
hueButton.ZIndex=5
local hueCursor=Instance.new("Frame")
hueCursor.Parent=hueBar
hueCursor.Size=UDim2.new(1,0,0,4)
hueCursor.AnchorPoint=Vector2.new(0,0.5)
hueCursor.BackgroundColor3=Color3.new(1,1,1)
hueCursor.BorderSizePixel=0
hueCursor.ZIndex=7
local hueCursorStroke=Instance.new("UIStroke")
hueCursorStroke.Parent=hueCursor
hueCursorStroke.Thickness=1
hueCursorStroke.Color=Color3.new(0,0,0)
local selectedThemeColor=Config.ThemeColor
local pickerHue,pickerSaturation,pickerValue=Config.ThemeColor:ToHSV()
local function UpdateThemePicker()
local hueColor=Color3.fromHSV(pickerHue,1,1)
svArea.BackgroundColor3=hueColor
svCursor.Position=UDim2.new(pickerSaturation,0,1-pickerValue,0)
hueCursor.Position=UDim2.new(0,0,pickerHue,0)
selectedThemeColor=Color3.fromHSV(pickerHue,pickerSaturation,pickerValue)
palettePreview.BackgroundColor3=selectedThemeColor
local r,g,b=selectedThemeColor.R*255,selectedThemeColor.G*255,selectedThemeColor.B*255
paletteValue.Text=string.format("#%02X%02X%02X",math.floor(r+0.5),math.floor(g+0.5),math.floor(b+0.5))
end
local function GetMousePosition()
local mouse=Players.LocalPlayer:GetMouse()
return Vector2.new(mouse.X,mouse.Y)
end
local function UpdateSVFromPosition(pos)
local abs=svButton.AbsolutePosition
local size=svButton.AbsoluteSize
if size.X<=0 or size.Y<=0 then return end
pickerSaturation=math.clamp((pos.X-abs.X)/size.X,0,1)
pickerValue=math.clamp(1-(pos.Y-abs.Y)/size.Y,0,1)
UpdateThemePicker()
end
local function UpdateHueFromPosition(pos)
local abs=hueButton.AbsolutePosition
local size=hueButton.AbsoluteSize
if size.Y<=0 then return end
pickerHue=math.clamp((pos.Y-abs.Y)/size.Y,0,1)
UpdateThemePicker()
end
local pickerDragging=nil
local function StopRainbowForManualColor()
isRainbowRunning=false
rainbowTransitionActive=false
rainbowTransitionSerial=(rainbowTransitionSerial or 0)+1
if rainbowToggle then
rainbowToggle.Text="RAINBOW CONTINUOUS"
end
end
svButton.MouseButton1Down:Connect(function()
StopRainbowForManualColor()
pickerDragging="SV"
UpdateSVFromPosition(GetMousePosition())
ApplyGlobalTheme(selectedThemeColor)
end)
hueButton.MouseButton1Down:Connect(function()
StopRainbowForManualColor()
pickerDragging="HUE"
UpdateHueFromPosition(GetMousePosition())
ApplyGlobalTheme(selectedThemeColor)
end)
UserInputService.InputChanged:Connect(function(input)
if input.UserInputType~=Enum.UserInputType.MouseMovement or not pickerDragging then return end
local pos=GetMousePosition()
if pickerDragging=="SV" then
UpdateSVFromPosition(pos)
else
UpdateHueFromPosition(pos)
end
if not isRainbowRunning and typeof(selectedThemeColor)=="Color3" then
ApplyGlobalTheme(selectedThemeColor)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
pickerDragging=nil
end
end)
UpdateThemePicker()
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
applyThemeBtn.LayoutOrder = 3
Instance.new("UICorner", applyThemeBtn).CornerRadius = UDim.new(0, 6)
local rainbowToggleCard = Instance.new("Frame")
rainbowToggleCard.Parent = settingsScroll
rainbowToggleCard.Size = UDim2.new(1, -10, 0, 42)
rainbowToggleCard.BackgroundColor3 = Config.BgCard
rainbowToggleCard.BackgroundTransparency = 0.2
rainbowToggleCard.BorderSizePixel = 0
rainbowToggleCard.LayoutOrder = 4
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
local rainbowToggleBox = Instance.new("Frame")
rainbowToggleBox.Parent = rainbowToggleCard
rainbowToggleBox.Size = UDim2.new(0, 16, 0, 16)
rainbowToggleBox.Position = UDim2.new(1, -26, 0.5, -8)
rainbowToggleBox.BackgroundColor3 = Color3.fromRGB(24, 25, 34)
rainbowToggleBox.BorderSizePixel = 0
rainbowToggleBox.ZIndex = 2
Instance.new("UICorner", rainbowToggleBox).CornerRadius = UDim.new(0, 4)
local rainbowToggleStroke = Instance.new("UIStroke")
rainbowToggleStroke.Parent = rainbowToggleBox
rainbowToggleStroke.Thickness = 1.5
rainbowToggleStroke.Color = Config.ThemeColor
rainbowToggleStroke.Transparency = 0.15
local rainbowToggleCircle = Instance.new("Frame")
rainbowToggleCircle.Parent = rainbowToggleBox
rainbowToggleCircle.Size = UDim2.new(0, 8, 0, 8)
rainbowToggleCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
rainbowToggleCircle.AnchorPoint = Vector2.new(0.5, 0.5)
rainbowToggleCircle.BackgroundColor3 = Config.ThemeColor
rainbowToggleCircle.BorderSizePixel = 0
rainbowToggleCircle.Visible = false
rainbowToggleCircle.ZIndex = 3
Instance.new("UICorner", rainbowToggleCircle).CornerRadius = UDim.new(1, 0)
local rainbowClickArea = Instance.new("TextButton")
rainbowClickArea.Parent = rainbowToggleCard
rainbowClickArea.Size = UDim2.new(1, 0, 1, 0)
rainbowClickArea.BackgroundTransparency = 1
rainbowClickArea.Text = ""
CreateSectionDivider("CONTROL", 5.5)
local rainbowSpeedCard = Instance.new("Frame")
rainbowSpeedCard.Parent = settingsScroll
rainbowSpeedCard.Size = UDim2.new(1, -10, 0, 112)
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
local rainbowSpeedNote = Instance.new("TextLabel")
rainbowSpeedNote.Parent = rainbowSpeedCard
rainbowSpeedNote.Size = UDim2.new(1, -16, 0, 16)
rainbowSpeedNote.Position = UDim2.new(0, 8, 0, 88)
rainbowSpeedNote.BackgroundTransparency = 1
rainbowSpeedNote.Font = Enum.Font.Code
rainbowSpeedNote.TextSize = 10
rainbowSpeedNote.TextColor3 = Color3.fromRGB(145, 145, 165)
rainbowSpeedNote.Text = "NOTE: SPEED RANGE 10 - 300%"
rainbowSpeedNote.TextXAlignment = Enum.TextXAlignment.Center
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
local debugToggleCard = Instance.new("Frame")
debugToggleCard.Parent = settingsScroll
debugToggleCard.Size = UDim2.new(1, -10, 0, 42)
debugToggleCard.BackgroundColor3 = Config.BgCard
debugToggleCard.BackgroundTransparency = 0.2
debugToggleCard.BorderSizePixel = 0
debugToggleCard.LayoutOrder = 6
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
local debugToggleBox = Instance.new("Frame")
debugToggleBox.Parent = debugToggleCard
debugToggleBox.Size = UDim2.new(0, 16, 0, 16)
debugToggleBox.Position = UDim2.new(1, -26, 0.5, -8)
debugToggleBox.BackgroundColor3 = Color3.fromRGB(24, 25, 34)
debugToggleBox.BorderSizePixel = 0
debugToggleBox.ZIndex = 2
Instance.new("UICorner", debugToggleBox).CornerRadius = UDim.new(0, 4)
local debugToggleStroke = Instance.new("UIStroke")
debugToggleStroke.Parent = debugToggleBox
debugToggleStroke.Thickness = 1.5
debugToggleStroke.Color = Config.ThemeColor
debugToggleStroke.Transparency = 0.15
local debugToggleCircle = Instance.new("Frame")
debugToggleCircle.Parent = debugToggleBox
debugToggleCircle.Size = UDim2.new(0, 8, 0, 8)
debugToggleCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
debugToggleCircle.AnchorPoint = Vector2.new(0.5, 0.5)
debugToggleCircle.BackgroundColor3 = Config.ThemeColor
debugToggleCircle.BorderSizePixel = 0
debugToggleCircle.Visible = Config.ShowDebug
debugToggleCircle.ZIndex = 3
Instance.new("UICorner", debugToggleCircle).CornerRadius = UDim.new(1, 0)
local debugClickArea = Instance.new("TextButton")
debugClickArea.Parent = debugToggleCard
debugClickArea.Size = UDim2.new(1, 0, 1, 0)
debugClickArea.BackgroundTransparency = 1
debugClickArea.Text = ""
CreateSectionDivider("HOTKEY", 6.5)
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
    if openStroke then openStroke.Color = newColor end
    if openGlow then openGlow.Color = newColor end
    if openAccent then openAccent.BackgroundColor3 = newColor end
    if openStatus then openStatus.TextColor3 = newColor end
    if openIcon then openIcon.TextColor3 = newColor end
    if lineStroke then lineStroke.Color = newColor end
    if applyThemeBtn then applyThemeBtn.BackgroundColor3 = newColor end
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
local function UpdateToggleIndicators(accentColor)
    accentColor = accentColor or Config.ThemeColor
    rainbowToggleStroke.Color = accentColor
    rainbowToggleCircle.BackgroundColor3 = accentColor
    rainbowToggleCircle.Visible = isRainbowRunning
    debugToggleStroke.Color = accentColor
    debugToggleCircle.BackgroundColor3 = accentColor
    debugToggleCircle.Visible = Config.ShowDebug
end
UpdateToggleIndicators(Config.ThemeColor)
task.spawn(function()
    while gui and gui.Parent do
        if isRainbowRunning and not rainbowTransitionActive and not themeLoadingActive then
            rainbowHue = (rainbowHue + (0.0025 * (Config.RainbowSpeedPercent / 100))) % 1
            local rainbowColor = Color3.fromHSV(rainbowHue, 1, 1)
            ApplyGlobalTheme(rainbowColor)
            UpdateToggleIndicators(rainbowColor)
            pickerHue = rainbowHue
            UpdateThemePicker()
            palettePreview.BackgroundColor3 = rainbowColor
            local rr, gg, bb = rainbowColor.R * 255, rainbowColor.G * 255, rainbowColor.B * 255
            paletteValue.Text = string.format("#%02X%02X%02X", math.floor(rr + 0.5), math.floor(gg + 0.5), math.floor(bb + 0.5))
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
            UpdateToggleIndicators(staticThemeColor)
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
        local firstRainbowColor = Color3.fromHSV(rainbowHue, 1, 1)
        if not PlayAdvancedThemeLoading(firstRainbowColor, "RAINBOW MODE", "Starting Rainbow Continuous") then
            rainbowTransitionActive = false
            return
        end
        task.spawn(function()
            local token = loadingAnimationToken
            task.wait(THEME_LOADING_APPLY_DELAY)
            if token ~= loadingAnimationToken or not themeLoadingActive or not loadingScreen.Parent then
                rainbowTransitionActive = false
                themeLoadingActive = false
                StopLoadingAnimation()
                RestoreUIAfterThemeLoading()
                return
            end
            isRainbowRunning = true
            rainbowTransitionActive = false
            Config.ThemeColor = firstRainbowColor
            UpdateLoadingTheme()
            local ok = pcall(function()
                ApplyGlobalTheme(firstRainbowColor)
            end)
            if not ok then
                Config.ThemeColor = firstRainbowColor
                UpdateLoadingTheme()
            end
            selectedThemeColor = firstRainbowColor
            palettePreview.BackgroundColor3 = firstRainbowColor
            local fr, fg, fb = firstRainbowColor.R * 255, firstRainbowColor.G * 255, firstRainbowColor.B * 255
            paletteValue.Text = string.format("#%02X%02X%02X", math.floor(fr + 0.5), math.floor(fg + 0.5), math.floor(fb + 0.5))
            UpdateToggleIndicators(firstRainbowColor)
            loadingStatus.Text = "RAINBOW ACTIVE"
            TweenService:Create(progressFill, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            task.delay(0.35, function()
                if themeLoadingActive then
                    FinishAdvancedThemeLoading()
                end
            end)
        end)
        ShowNotification("Rainbow Continuous Loading...")
    else
        local restoreColor = staticThemeColor
        isRainbowRunning = false
        if not PlayAdvancedThemeLoading(restoreColor, "RAINBOW MODE", "Returning To Static Theme") then
            rainbowTransitionActive = false
            return
        end
        task.spawn(function()
            local token = loadingAnimationToken
            task.wait(THEME_LOADING_APPLY_DELAY)
            if token ~= loadingAnimationToken or not themeLoadingActive or not loadingScreen.Parent then
                rainbowTransitionActive = false
                themeLoadingActive = false
                StopLoadingAnimation()
                RestoreUIAfterThemeLoading()
                return
            end
            Config.ThemeColor = restoreColor
            local ok = pcall(function()
                ApplyGlobalTheme(restoreColor)
            end)
            if not ok then
                Config.ThemeColor = restoreColor
                UpdateLoadingTheme()
            end
            pickerHue, pickerSaturation, pickerValue = restoreColor:ToHSV()
            selectedThemeColor = restoreColor
            rainbowTransitionActive = false
            UpdateLoadingTheme()
            UpdateToggleIndicators(restoreColor)
            loadingStatus.Text = "THEME RESTORED"
            TweenService:Create(progressFill, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            task.delay(0.35, function()
                if themeLoadingActive then
                    FinishAdvancedThemeLoading()
                end
            end)
        end)
        ShowNotification("Rainbow Continuous Stopping...")
    end
end)

local debugSidebarFrame = Instance.new("Frame")
debugSidebarFrame.Name = "DebugSidebar"
debugSidebarFrame.Parent = gui
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
local function SetDebugVisibility(enabled)
    Config.ShowDebug = enabled == true
    debugToggleCircle.Visible = Config.ShowDebug
    debugSidebarFrame.Visible = Config.ShowDebug
    keyStatusSidebarFrame.Visible = Config.ShowDebug
    debugDividerBetween.Visible = Config.ShowDebug
    UpdateToggleIndicators(GetCurrentAccentColor())
end
debugClickArea.Active = true
debugClickArea.AutoButtonColor = false
debugClickArea.Activated:Connect(function()
    SetDebugVisibility(not Config.ShowDebug)
    if Config.ShowDebug then
        ShowNotification("Debug Info Enabled!")
    else
        ShowNotification("Debug Info Disabled!")
    end
end)
applyThemeBtn.MouseButton1Click:Connect(function()
    if themeLoadingActive or rainbowTransitionActive then return end
    local targetColor = selectedThemeColor
    if typeof(targetColor) ~= "Color3" then return end
    isRainbowRunning = false
    rainbowTransitionActive = true
    staticThemeColor = targetColor
    local started = PlayAdvancedThemeLoading(targetColor, "FISHHUB", "Applying Theme & Reloading UI")
    if not started then rainbowTransitionActive = false return end
    ShowNotification("Applying theme...")
    task.spawn(function()
        task.wait(THEME_LOADING_APPLY_DELAY)
        if not themeLoadingActive or not loadingScreen.Parent then
            rainbowTransitionActive = false
            themeLoadingActive = false
            RestoreUIAfterThemeLoading()
            return
        end
        local ok = pcall(ApplyGlobalTheme, targetColor)
        if not ok then
            Config.ThemeColor = targetColor
            UpdateLoadingTheme()
        end
        selectedThemeColor = targetColor
        loadingStatus.Text = ok and "THEME APPLIED" or "THEME APPLIED WITH SAFE RECOVERY"
        TweenService:Create(progressFill, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.delay(0.5, function()
            rainbowTransitionActive = false
            if themeLoadingActive then FinishAdvancedThemeLoading() end
        end)
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
    local selectedScale = 1.0
    main.Visible = true
    settingsWindow.Visible = false
    if not Config.GUIAnimation then
        mainScale.Scale = selectedScale
        settingsScale.Scale = selectedScale
        main.BackgroundTransparency = Config.UITransparency
        return
    end
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
    local selectedScale = 1.0
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
local now=os.clock()
if now-lastToggleAt<TOGGLE_DEBOUNCE then return end
lastToggleAt=now
if isMainOpen then
CloseGUI()
openStatus.Text="CLOSED"
openIcon.Text="v"
else
OpenGUI()
openStatus.Text="OPEN"
openIcon.Text="^"
end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end
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
rightBottomStatus.Position = UDim2.new(1, -12, 1, -9)
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
joinDiscordBtn.Position = UDim2.new(0, 12, 1, -3)
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
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
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

local RemoteTabModules = {
    Home = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/home.lua",
    Function = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/function.lua",
    Creative = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/creative.lua"
}

local LoadedTabModules = {}

local function LoadRemoteTabModule(tabName)
    local url = RemoteTabModules[tabName]
    if not url then return end
    if LoadedTabModules[tabName] then
        return
    end

    LoadedTabModules[tabName] = true

    task.spawn(function()
        local ok, source = pcall(function()
            return game:HttpGet(url)
        end)

        if not ok or type(source) ~= "string" or source == "" then
            LoadedTabModules[tabName] = nil
            ShowNotification("Failed to fetch " .. tabName .. " module.")
            return
        end

        local compileOk, module = pcall(loadstring, source)
        if not compileOk or type(module) ~= "function" then
            LoadedTabModules[tabName] = nil
            ShowNotification("Failed to compile " .. tabName .. " module.")
            return
        end

        local runOk, runError = pcall(module)
        if not runOk then
            LoadedTabModules[tabName] = nil
            ShowNotification(tabName .. " module error: " .. tostring(runError))
        end
    end)
end

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        LoadRemoteTabModule(tabName)
    end)
end

LoadRemoteTabModule("Home")

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
    txt.Text = "Do you want to close FishHub?"
    yes.Text = "Yes"
    no.Text = "No"
    confirm.Visible = true
end)
yes.MouseButton1Click:Connect(function() gui:Destroy() end)
no.MouseButton1Click:Connect(function() confirm.Visible = false end)
hideBtn.MouseButton1Click:Connect(function() CloseGUI() end)
gearBtn.MouseButton1Click:Connect(function() ToggleSettings() end)
OpenGUI()