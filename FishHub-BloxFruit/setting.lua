-- FishHub external Settings / Gear module
return function(ctx)
    local Players=ctx.Players
    local TweenService=ctx.TweenService
    local UserInputService=ctx.UserInputService
    local gui=ctx.gui
    local main=ctx.main
    local mainScale=ctx.mainScale
    local gearBtn=ctx.gearBtn
    local Config=ctx.Config
    local allHubStrokes=ctx.allHubStrokes
    local allHubLines=ctx.allHubLines
    local allThemeTexts=ctx.allThemeTexts
    local AddHoverGlow=ctx.AddHoverGlow
    local ShowNotification=ctx.ShowNotification

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
if ctx.onManualColorChanged then
    ctx.onManualColorChanged(selectedThemeColor)
end
end
svButton.MouseButton1Down:Connect(function()
StopRainbowForManualColor()
pickerDragging="SV"
UpdateSVFromPosition(GetMousePosition())
if ctx.onManualColorChanged then ctx.onManualColorChanged(selectedThemeColor) end
end)
hueButton.MouseButton1Down:Connect(function()
StopRainbowForManualColor()
pickerDragging="HUE"
UpdateHueFromPosition(GetMousePosition())
if ctx.onManualColorChanged then ctx.onManualColorChanged(selectedThemeColor) end
end)
UserInputService.InputChanged:Connect(function(input)
if input.UserInputType~=Enum.UserInputType.MouseMovement or not pickerDragging then return end
local pos=GetMousePosition()
if pickerDragging=="SV" then
UpdateSVFromPosition(pos)
else
UpdateHueFromPosition(pos)
end
if not isRainbowRunning and typeof(selectedThemeColor)=="Color3" and ctx.onManualColorChanged then
ctx.onManualColorChanged(selectedThemeColor)
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

    -- Gear is created by MainWindow.
    -- This module only binds Settings behavior to that existing button.
    if not gearBtn then
        error("setting.lua: gearBtn was not supplied by Main")
    end
    local gearStroke=gearBtn:FindFirstChildOfClass("UIStroke")

    local rainbowRunning=false
    local debugEnabled=Config.ShowDebug==true
    local destroyed=false

    local function setVisible(value,animate)
        if destroyed then return end
        value=value==true
        if value and not main.Visible then return end
        if settingsWindow.Visible==value then return end
        settingsWindow.Visible=value
        if value and animate and Config.GUIAnimation then
            settingsScale.Scale=0.88
            TweenService:Create(settingsScale,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
        else
            settingsScale.Scale=1
        end
    end

    gearBtn.MouseButton1Click:Connect(function() setVisible(not settingsWindow.Visible,true) end)

    rainbowClickArea.MouseButton1Click:Connect(function()
        if ctx.isBusy and ctx.isBusy() then return end
        rainbowRunning=not rainbowRunning
        rainbowToggleCircle.Visible=rainbowRunning
        if ctx.onRainbowChanged then ctx.onRainbowChanged(rainbowRunning) end
    end)

    debugClickArea.Active=true
    debugClickArea.AutoButtonColor=false
    debugClickArea.Activated:Connect(function()
        debugEnabled=not debugEnabled
        Config.ShowDebug=debugEnabled
        debugToggleCircle.Visible=debugEnabled
        if ctx.onDebugChanged then ctx.onDebugChanged(debugEnabled) end
        ShowNotification(debugEnabled and "Debug Info Enabled!" or "Debug Info Disabled!")
    end)

    applyThemeBtn.MouseButton1Click:Connect(function()
        if ctx.isBusy and ctx.isBusy() then return end
        if typeof(selectedThemeColor)~="Color3" then return end
        if ctx.onApplyTheme then ctx.onApplyTheme(selectedThemeColor) end
    end)

    return {
        Toggle=function() setVisible(not settingsWindow.Visible,true) end,
        Open=function() setVisible(true,true) end,
        Close=function() setVisible(false,false) end,
        IsVisible=function() return settingsWindow.Visible end,
        IsListeningKey=function() return listeningKey==true end,
        SetVisible=function(_,v,animate) setVisible(v,animate) end,
        SetRainbowState=function(_,v) rainbowRunning=v==true; rainbowToggleCircle.Visible=rainbowRunning end,
        SetDebugState=function(_,v) debugEnabled=v==true; debugToggleCircle.Visible=debugEnabled end,
        SetThemeColor=function(_,color)
            if typeof(color)~="Color3" then return end
            selectedThemeColor=color
            pickerHue,pickerSaturation,pickerValue=color:ToHSV()
            UpdateThemePicker()
        end,
        ApplyAccent=function(_,color)
            if typeof(color)~="Color3" then return end
            gearStroke.Color=color
            settingsStroke.Color=color
            applyThemeBtn.BackgroundColor3=color
            rainbowToggleStroke.Color=color
            rainbowToggleCircle.BackgroundColor3=color
            debugToggleStroke.Color=color
            debugToggleCircle.BackgroundColor3=color
            hotkeyButtonBox.TextColor3=color
        end,
        Destroy=function()
            destroyed=true
            if settingsWindow then settingsWindow:Destroy() end
            -- Gear is owned by MainWindow, so it stays with Main.
        end,
    }
end
