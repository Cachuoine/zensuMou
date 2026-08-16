-- setting.lua
local gui, main, Config, allHubStrokes, allHubLines, allThemeTexts, ShowNotification, ApplyGlobalTheme, PlayAdvancedThemeLoading, FinishAdvancedThemeLoading, UpdateLoadingTheme, StopLoadingAnimation = ...

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

if not gui or not main then return end

-- Kiểm tra nếu bảng Setting đã tồn tại thì bật/tắt (toggle), nếu chưa thì tạo mới
local settingsWindow = gui:FindFirstChild("SettingsWindow")
if settingsWindow then
    settingsWindow.Visible = not settingsWindow.Visible
    return
end

local mainScale = main:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", main)

settingsWindow = Instance.new("Frame")
settingsWindow.Name = "SettingsWindow"
settingsWindow.Parent = gui
settingsWindow.Size = UDim2.new(0, 240, 0, Config.MainHeight)
settingsWindow.AnchorPoint = Vector2.new(0, 0.5)
settingsWindow.BackgroundColor3 = Config.BgMain
settingsWindow.BackgroundTransparency = Config.UITransparency
settingsWindow.BorderSizePixel = 0
settingsWindow.Visible = true

local settingsScale = Instance.new("UIScale")
settingsScale.Parent = settingsWindow
settingsScale.Scale = 1
Instance.new("UICorner", settingsWindow).CornerRadius = UDim.new(0, 14)

local settingsStroke = Instance.new("UIStroke")
settingsStroke.Parent = settingsWindow
settingsStroke.Thickness = 2
settingsStroke.Color = Config.ThemeColor

task.spawn(function()
    while gui and gui.Parent and settingsWindow and settingsWindow.Parent do
        if main.Visible then
            local scale = mainScale.Scale
            local scaledMainHalfWidth = (Config.MainWidth * scale) / 2
            settingsWindow.Position = UDim2.new(0.5, scaledMainHalfWidth + 10, 0.5, 0)
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
    table.insert(allHubLines, line)
end

CreateSectionDivider("THEME", 1)

local colorPalette = Instance.new("Frame")
colorPalette.Name = "ColorPalette"
colorPalette.Parent = settingsScroll
colorPalette.Size = UDim2.new(1, -10, 0, 178)
colorPalette.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
colorPalette.BorderSizePixel = 0
colorPalette.LayoutOrder = 2
Instance.new("UICorner", colorPalette).CornerRadius = UDim.new(0, 12)

local paletteStroke = Instance.new("UIStroke")
paletteStroke.Parent = colorPalette
paletteStroke.Thickness = 1
paletteStroke.Color = Config.ThemeColor
table.insert(allHubStrokes, paletteStroke)

local paletteTitle = Instance.new("TextLabel")
paletteTitle.Parent = colorPalette
paletteTitle.Size = UDim2.new(1, -20, 0, 22)
paletteTitle.Position = UDim2.new(0, 10, 0, 6)
paletteTitle.BackgroundTransparency = 1
paletteTitle.Text = "THEME COLOR"
paletteTitle.Font = Enum.Font.GothamBold
paletteTitle.TextSize = 10
paletteTitle.TextColor3 = Color3.fromRGB(180, 185, 200)
paletteTitle.TextXAlignment = Enum.TextXAlignment.Left

local palettePreview = Instance.new("Frame")
palettePreview.Parent = colorPalette
palettePreview.Size = UDim2.new(0, 34, 0, 20)
palettePreview.Position = UDim2.new(1, -44, 0, 7)
palettePreview.BackgroundColor3 = Config.ThemeColor
palettePreview.BorderSizePixel = 0
Instance.new("UICorner", palettePreview).CornerRadius = UDim.new(0, 6)

local paletteValue = Instance.new("TextLabel")
paletteValue.Parent = colorPalette
paletteValue.Size = UDim2.new(0, 90, 0, 18)
paletteValue.Position = UDim2.new(1, -140, 0, 8)
paletteValue.BackgroundTransparency = 1
paletteValue.TextColor3 = Color3.fromRGB(150, 155, 170)
paletteValue.Font = Enum.Font.Code
paletteValue.TextSize = 9
paletteValue.TextXAlignment = Enum.TextXAlignment.Right

local svArea = Instance.new("Frame")
svArea.Parent = colorPalette
svArea.Size = UDim2.new(1, -54, 0, 118)
svArea.Position = UDim2.new(0, 10, 0, 34)
svArea.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
svArea.BorderSizePixel = 0
svArea.ClipsDescendants = true
Instance.new("UICorner", svArea).CornerRadius = UDim.new(0, 8)

local svWhite = Instance.new("Frame")
svWhite.Parent = svArea
svWhite.Size = UDim2.fromScale(1, 1)
svWhite.BackgroundColor3 = Color3.new(1, 1, 1)
svWhite.BorderSizePixel = 0
local whiteGradient = Instance.new("UIGradient")
whiteGradient.Parent = svWhite
whiteGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

local svBlack = Instance.new("Frame")
svBlack.Parent = svArea
svBlack.Size = UDim2.fromScale(1, 1)
svBlack.BackgroundColor3 = Color3.new(0, 0, 0)
svBlack.BorderSizePixel = 0
local blackGradient = Instance.new("UIGradient")
blackGradient.Parent = svBlack
blackGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
blackGradient.Rotation = 90

local svButton = Instance.new("TextButton")
svButton.Parent = svArea
svButton.Size = UDim2.fromScale(1, 1)
svButton.BackgroundTransparency = 1
svButton.Text = ""
svButton.AutoButtonColor = false
svButton.ZIndex = 5

local svCursor = Instance.new("Frame")
svCursor.Parent = svArea
svCursor.Size = UDim2.new(0, 12, 0, 12)
svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
svCursor.BackgroundColor3 = Color3.new(1, 1, 1)
svCursor.BorderSizePixel = 0
svCursor.ZIndex = 7
Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
local svCursorStroke = Instance.new("UIStroke")
svCursorStroke.Parent = svCursor
svCursorStroke.Thickness = 2
svCursorStroke.Color = Color3.new(0, 0, 0)

local hueBar = Instance.new("Frame")
hueBar.Parent = colorPalette
hueBar.Size = UDim2.new(0, 18, 0, 118)
hueBar.Position = UDim2.new(1, -32, 0, 34)
hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
hueBar.BorderSizePixel = 0
hueBar.ZIndex = 4
Instance.new("UICorner", hueBar).CornerRadius = UDim.new(1, 0)

local hueGradient = Instance.new("UIGradient")
hueGradient.Parent = hueBar
hueGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.1667, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.3333, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.6667, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.8333, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
hueGradient.Rotation = 90

local hueButton = Instance.new("TextButton")
hueButton.Parent = hueBar
hueButton.Size = UDim2.fromScale(1, 1)
hueButton.BackgroundTransparency = 1
hueButton.Text = ""
hueButton.AutoButtonColor = false
hueButton.ZIndex = 5

local hueCursor = Instance.new("Frame")
hueCursor.Parent = hueBar
hueCursor.Size = UDim2.new(1, 0, 0, 4)
hueCursor.AnchorPoint = Vector2.new(0, 0.5)
hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
hueCursor.BorderSizePixel = 0
hueCursor.ZIndex = 7
local hueCursorStroke = Instance.new("UIStroke")
hueCursorStroke.Parent = hueCursor
hueCursorStroke.Thickness = 1
hueCursorStroke.Color = Color3.new(0, 0, 0)

local selectedThemeColor = Config.ThemeColor
local pickerHue, pickerSaturation, pickerValue = Config.ThemeColor:ToHSV()

local function UpdateThemePicker()
    local hueColor = Color3.fromHSV(pickerHue, 1, 1)
    svArea.BackgroundColor3 = hueColor
    svCursor.Position = UDim2.new(pickerSaturation, 0, 1 - pickerValue, 0)
    hueCursor.Position = UDim2.new(0, 0, pickerHue, 0)
    selectedThemeColor = Color3.fromHSV(pickerHue, pickerSaturation, pickerValue)
    palettePreview.BackgroundColor3 = selectedThemeColor
    local r, g, b = selectedThemeColor.R * 255, selectedThemeColor.G * 255, selectedThemeColor.B * 255
    paletteValue.Text = string.format("#%02X%02X%02X", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
end

local function GetMousePosition()
    local mouse = Players.LocalPlayer:GetMouse()
    return Vector2.new(mouse.X, mouse.Y)
end

local function UpdateSVFromPosition(pos)
    local abs = svButton.AbsolutePosition
    local size = svButton.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then return end
    pickerSaturation = math.clamp((pos.X - abs.X) / size.X, 0, 1)
    pickerValue = math.clamp(1 - (pos.Y - abs.Y) / size.Y, 0, 1)
    UpdateThemePicker()
end

local function UpdateHueFromPosition(pos)
    local abs = hueButton.AbsolutePosition
    local size = hueButton.AbsoluteSize
    if size.Y <= 0 then return end
    pickerHue = math.clamp((pos.Y - abs.Y) / size.Y, 0, 1)
    UpdateThemePicker()
end

local pickerDragging = nil
svButton.MouseButton1Down:Connect(function()
    pickerDragging = "SV"
    UpdateSVFromPosition(GetMousePosition())
    if ApplyGlobalTheme then ApplyGlobalTheme(selectedThemeColor) end
end)

hueButton.MouseButton1Down:Connect(function()
    pickerDragging = "HUE"
    UpdateHueFromPosition(GetMousePosition())
    if ApplyGlobalTheme then ApplyGlobalTheme(selectedThemeColor) end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement or not pickerDragging then return end
    local pos = GetMousePosition()
    if pickerDragging == "SV" then
        UpdateSVFromPosition(pos)
    else
        UpdateHueFromPosition(pos)
    end
    if ApplyGlobalTheme and typeof(selectedThemeColor) == "Color3" then
        ApplyGlobalTheme(selectedThemeColor)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        pickerDragging = nil
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

applyThemeBtn.MouseButton1Click:Connect(function()
    local targetColor = selectedThemeColor
    if typeof(targetColor) ~= "Color3" then return end
    if PlayAdvancedThemeLoading then
        PlayAdvancedThemeLoading(targetColor, "FISHHUB", "Applying Theme & Reloading UI")
    end
    if ShowNotification then ShowNotification("Applying theme...") end
    task.spawn(function()
        task.wait(2.15)
        local ok = pcall(function()
            if ApplyGlobalTheme then ApplyGlobalTheme(targetColor) end
        end)
        if ShowNotification then ShowNotification("Theme applied successfully!") end
        if FinishAdvancedThemeLoading then FinishAdvancedThemeLoading() end
    end)
end)

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
            if ShowNotification then ShowNotification("Hotkey changed to: " .. tostring(input.KeyCode.Name)) end
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
end)
