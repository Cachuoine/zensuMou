local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local FIREBASE_URL = "https://fishhub-35d18-default-rtdb.firebaseio.com/keys"
local GET_KEY_WEBSITE = "https://fishhub-online.netlify.app/"
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = Lighting
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberpunkAnchorLoadingSystem"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundTransparency = 1
LoadingFrame.Parent = ScreenGui
local AnchorRing = Instance.new("Frame")
AnchorRing.Size = UDim2.new(0, 120, 0, 120)
AnchorRing.AnchorPoint = Vector2.new(0.5, 0.5)
AnchorRing.Position = UDim2.new(0.5, 0, 0.43, 0)
AnchorRing.BackgroundTransparency = 1
AnchorRing.Parent = LoadingFrame
for i = 1, 4 do
	local hook = Instance.new("Frame")
	hook.Size = UDim2.new(0, 16, 0, 8)
	hook.AnchorPoint = Vector2.new(0.5, 0.5)
	hook.BackgroundColor3 = Color3.fromRGB(0, 242, 254)
	hook.BorderSizePixel = 0
	local angle = math.rad((i - 1) * 90)
	local radius = 60
	hook.Position = UDim2.new(0.5, math.cos(angle) * radius, 0.5, math.sin(angle) * radius)
	hook.Rotation = (i - 1) * 90
	hook.Parent = AnchorRing
	local hookCorner = Instance.new("UICorner")
	hookCorner.CornerRadius = UDim.new(1, 0)
	hookCorner.Parent = hook
	local hookStroke = Instance.new("UIStroke")
	hookStroke.Color = Color3.fromRGB(255, 255, 255)
	hookStroke.Thickness = 1
	hookStroke.Parent = hook
end
local outerStroke = Instance.new("UIStroke")
outerStroke.Color = Color3.fromRGB(0, 242, 254)
outerStroke.Thickness = 2.5
outerStroke.Transparency = 0.2
outerStroke.Parent = AnchorRing
local outerCorner = Instance.new("UICorner")
outerCorner.CornerRadius = UDim.new(1, 0)
outerCorner.Parent = AnchorRing
local InnerSpinner = Instance.new("Frame")
InnerSpinner.Size = UDim2.new(0, 70, 0, 70)
InnerSpinner.AnchorPoint = Vector2.new(0.5, 0.5)
InnerSpinner.Position = UDim2.new(0.5, 0, 0.43, 0)
InnerSpinner.BackgroundColor3 = Color3.fromRGB(0, 242, 254)
InnerSpinner.BackgroundTransparency = 0.7
InnerSpinner.Parent = LoadingFrame
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(1, 0)
innerCorner.Parent = InnerSpinner
local innerStroke = Instance.new("UIStroke")
innerStroke.Color = Color3.fromRGB(255, 0, 128)
innerStroke.Thickness = 2
innerStroke.Parent = InnerSpinner
for i = 1, 4 do
	local innerHook = Instance.new("Frame")
	innerHook.Size = UDim2.new(0, 10, 0, 5)
	innerHook.AnchorPoint = Vector2.new(0.5, 0.5)
	innerHook.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
	innerHook.BorderSizePixel = 0
	local angle = math.rad((i - 1) * 90)
	local radius = 35
	innerHook.Position = UDim2.new(0.5, math.cos(angle) * radius, 0.5, math.sin(angle) * radius)
	innerHook.Rotation = (i - 1) * 90
	innerHook.Parent = InnerSpinner
	local innerHookCorner = Instance.new("UICorner")
	innerHookCorner.CornerRadius = UDim.new(1, 0)
	innerHookCorner.Parent = innerHook
end
local CenterAnchorIcon = Instance.new("TextLabel")
CenterAnchorIcon.Size = UDim2.new(0, 40, 0, 40)
CenterAnchorIcon.AnchorPoint = Vector2.new(0.5, 0.5)
CenterAnchorIcon.Position = UDim2.new(0.5, 0, 0.43, 0)
CenterAnchorIcon.BackgroundTransparency = 1
CenterAnchorIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
CenterAnchorIcon.TextSize = 22
CenterAnchorIcon.Font = Enum.Font.GothamBold
CenterAnchorIcon.Text = "⚓"
CenterAnchorIcon.Parent = LoadingFrame
local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0, 400, 0, 50)
LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingText.Position = UDim2.new(0.5, 0, 0.58, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.TextColor3 = Color3.fromRGB(0, 242, 254)
LoadingText.TextSize = 15
LoadingText.Font = Enum.Font.Code
LoadingText.Text = "SYSTEM INITIALIZING..."
LoadingText.Parent = LoadingFrame
local flyingData = {
	{text = "[ SECURE KEY ]", startPos = UDim2.new(0.15, 0, 0.15, 0)},
	{text = "[ AUTHENTICATING ]", startPos = UDim2.new(0.85, 0, 0.2, 0)},
	{text = "[ ENCRYPTION ]", startPos = UDim2.new(0.1, 0, 0.85, 0)},
	{text = "[ ANCHOR INITIALIZED ]", startPos = UDim2.new(0.9, 0, 0.8, 0)},
}
local flyingUIElements = {}
for _, data in ipairs(flyingData) do
	local el = Instance.new("TextLabel")
	el.Size = UDim2.new(0, 150, 0, 45)
	el.AnchorPoint = Vector2.new(0.5, 0.5)
	el.Position = data.startPos
	el.BackgroundColor3 = Color3.fromRGB(13, 17, 23)
	el.BackgroundTransparency = 0.3
	el.TextColor3 = Color3.fromRGB(0, 242, 254)
	el.TextSize = 13
	el.Font = Enum.Font.Code
	el.Text = data.text
	el.Visible = false
	el.Parent = ScreenGui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = el
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 242, 254)
	stroke.Transparency = 0.3
	stroke.Parent = el
	table.insert(flyingUIElements, el)
end
local GetKeyFrame = Instance.new("Frame")
GetKeyFrame.Size = UDim2.new(0, 420, 0, 310)
GetKeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
GetKeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
GetKeyFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
GetKeyFrame.BackgroundTransparency = 0.35
GetKeyFrame.Visible = false
GetKeyFrame.Parent = ScreenGui
local gkCorner = Instance.new("UICorner")
gkCorner.CornerRadius = UDim.new(0, 12)
gkCorner.Parent = GetKeyFrame
local gkStroke = Instance.new("UIStroke")
gkStroke.Color = Color3.fromRGB(0, 242, 254)
gkStroke.Thickness = 1.5
gkStroke.Transparency = 0.4
gkStroke.Parent = GetKeyFrame
local AnchorIcon = Instance.new("TextLabel")
AnchorIcon.Size = UDim2.new(0, 40, 0, 40)
AnchorIcon.AnchorPoint = Vector2.new(0.5, 0)
AnchorIcon.Position = UDim2.new(0.5, 0, 0, 12)
AnchorIcon.BackgroundTransparency = 1
AnchorIcon.TextColor3 = Color3.fromRGB(0, 242, 254)
AnchorIcon.TextSize = 28
AnchorIcon.Font = Enum.Font.GothamBold
AnchorIcon.Text = "⚓"
AnchorIcon.Parent = GetKeyFrame
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Position = UDim2.new(0.5, 0, 0, 56)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.Text = "FISHHUB SECURITY"
Title.Parent = GetKeyFrame
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.Position = UDim2.new(1, -12, 0, 12)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
CloseButton.BackgroundTransparency = 0.3
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.Parent = GetKeyFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseButton
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
	blurEffect:Destroy()
end)
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.88, 0, 0, 45)
KeyInput.AnchorPoint = Vector2.new(0.5, 0)
KeyInput.Position = UDim2.new(0.5, 0, 0.33, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(5, 7, 12)
KeyInput.BackgroundTransparency = 0.5
KeyInput.TextColor3 = Color3.fromRGB(0, 242, 254)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Paste your FishHub key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 110, 130)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Code
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = GetKeyFrame
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = KeyInput
local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(0, 242, 254)
inputStroke.Transparency = 0.6
inputStroke.Parent = KeyInput
local BtnPrimary = Instance.new("TextButton")
BtnPrimary.Size = UDim2.new(0.88, 0, 0, 42)
BtnPrimary.AnchorPoint = Vector2.new(0.5, 0)
BtnPrimary.Position = UDim2.new(0.5, 0, 0.60, 0)
BtnPrimary.BackgroundColor3 = Color3.fromRGB(0, 242, 254)
BtnPrimary.TextColor3 = Color3.fromRGB(6, 8, 15)
BtnPrimary.TextSize = 14
BtnPrimary.Font = Enum.Font.GothamBold
BtnPrimary.Text = "GET-KEY"
BtnPrimary.Parent = GetKeyFrame
local btn1Corner = Instance.new("UICorner")
btn1Corner.CornerRadius = UDim.new(0, 8)
btn1Corner.Parent = BtnPrimary
BtnPrimary.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(GET_KEY_WEBSITE)
		BtnPrimary.Text = "COPIED WEBSITE LINK!"
		task.wait(1.5)
		BtnPrimary.Text = "GET-KEY"
	else
		BtnPrimary.Text = "CHECK CONSOLE FOR LINK"
		task.wait(1.5)
		BtnPrimary.Text = "GET-KEY"
	end
end)
local BtnSecondary = Instance.new("TextButton")
BtnSecondary.Size = UDim2.new(0.88, 0, 0, 36)
BtnSecondary.AnchorPoint = Vector2.new(0.5, 0)
BtnSecondary.Position = UDim2.new(0.5, 0, 0.78, 0)
BtnSecondary.BackgroundTransparency = 1
BtnSecondary.TextColor3 = Color3.fromRGB(0, 242, 254)
BtnSecondary.TextSize = 13
BtnSecondary.Font = Enum.Font.GothamBold
BtnSecondary.Text = "VERIFY KEY"
BtnSecondary.Parent = GetKeyFrame
local btn2Stroke = Instance.new("UIStroke")
btn2Stroke.Color = Color3.fromRGB(0, 242, 254)
btn2Stroke.Transparency = 0.5
btn2Stroke.Parent = BtnSecondary
local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 8)
btn2Corner.Parent = BtnSecondary
local ToastNotification = Instance.new("Frame")
ToastNotification.Size = UDim2.new(0, 260, 0, 45)
ToastNotification.AnchorPoint = Vector2.new(1, 1)
ToastNotification.Position = UDim2.new(1, -20, 1, -20)
ToastNotification.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
ToastNotification.BackgroundTransparency = 0.2
ToastNotification.Visible = false
ToastNotification.Parent = ScreenGui
local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 8)
toastCorner.Parent = ToastNotification
local toastStroke = Instance.new("UIStroke")
toastStroke.Color = Color3.fromRGB(0, 242, 254)
toastStroke.Thickness = 1.2
toastStroke.Transparency = 0.4
toastStroke.Parent = ToastNotification
local ToastText = Instance.new("TextLabel")
ToastText.Size = UDim2.new(1, 0, 1, 0)
ToastText.BackgroundTransparency = 1
ToastText.TextColor3 = Color3.fromRGB(0, 242, 254)
ToastText.TextSize = 12
ToastText.Font = Enum.Font.Code
ToastText.Text = ""
ToastText.Parent = ToastNotification
local function showToast(message, isSuccess, isError)
	ToastText.Text = "  " .. message
	if isSuccess then
		toastStroke.Color = Color3.fromRGB(0, 255, 128)
		ToastText.TextColor3 = Color3.fromRGB(0, 255, 128)
	elseif isError then
		toastStroke.Color = Color3.fromRGB(255, 50, 80)
		ToastText.TextColor3 = Color3.fromRGB(255, 50, 80)
	else
		toastStroke.Color = Color3.fromRGB(0, 242, 254)
		ToastText.TextColor3 = Color3.fromRGB(0, 242, 254)
	end
	ToastNotification.Visible = true
	ToastNotification.Size = UDim2.new(0, 0, 0, 45)
	TweenService:Create(ToastNotification, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 260, 0, 45)
	}):Play()
end
local function verifyKeyAction()
	local enteredKey = string.gsub(KeyInput.Text, "^%s*(.-)%s*$", "%1")
	if enteredKey == "" or not string.match(enteredKey, "^FishHub%-") then
		showToast("INVALID KEY FORMAT!", false, true)
		task.wait(1.5)
		ToastNotification.Visible = false
		return
	end
	showToast("VERIFYING WITH FIREBASE...", false, false)
	local success, response = pcall(function()
		local url = FIREBASE_URL .. "/" .. enteredKey .. ".json"
		return game:HttpGet(url)
	end)
	if success then
		if response and response ~= "null" and response ~= "" then
			showToast("KEY SUCCESSFUL! ACCESS GRANTED", true, false)
			task.wait(1.2)
			ScreenGui:Destroy()
			blurEffect:Destroy()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/checkgame.lua"))()
		else
			local fallbackSuccess, fallbackResponse = pcall(function()
				return game:HttpGet(FIREBASE_URL .. ".json")
			end)
			local found = false
			if fallbackSuccess and fallbackResponse and fallbackResponse ~= "null" then
				local decoded = HttpService:JSONDecode(fallbackResponse)
				if type(decoded) == "table" then
					for k, v in pairs(decoded) do
						if k == enteredKey or v == enteredKey or (type(v) == "table" and (v.key == enteredKey or v.Key == enteredKey)) then
							found = true
							break
						end
					end
				end
			end
			if found then
				showToast("KEY SUCCESSFUL! ACCESS GRANTED", true, false)
				task.wait(1.2)
				ScreenGui:Destroy()
				blurEffect:Destroy()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/checkgame.lua"))()
			else
				showToast("KEY NOT FOUND / EXPIRED!", false, true)
				task.wait(1.5)
				ToastNotification.Visible = false
			end
		end
	else
		showToast("CONNECTION ERROR!", false, true)
		task.wait(1.5)
		ToastNotification.Visible = false
	end
end
BtnSecondary.MouseButton1Click:Connect(verifyKeyAction)
KeyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		verifyKeyAction()
	end
end)
task.spawn(function()
	TweenService:Create(blurEffect, TweenInfo.new(0.8), {Size = 20}):Play()
	local spinTween = TweenService:Create(AnchorRing, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Rotation = 360
	})
	local innerSpinTween = TweenService:Create(InnerSpinner, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Rotation = -360
	})
	local iconSpinTween = TweenService:Create(CenterAnchorIcon, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Rotation = 360
	})
	spinTween:Play()
	innerSpinTween:Play()
	iconSpinTween:Play()
	spinTween.Completed:Wait()
	TweenService:Create(AnchorRing, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	TweenService:Create(InnerSpinner, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	TweenService:Create(CenterAnchorIcon, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), TextTransparency = 1}):Play()
	TweenService:Create(LoadingText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	task.wait(0.3)
	LoadingFrame.Visible = false
	for _, el in ipairs(flyingUIElements) do
		el.Visible = true
		el.Size = UDim2.new(0, 0, 0, 0)
		local flyTween = TweenService:Create(el, TweenInfo.new(1.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 160, 0, 50),
			Rotation = 720
		})
		flyTween:Play()
	end
	task.wait(1.1)
	for _, el in ipairs(flyingUIElements) do
		el.Visible = false
	end
	GetKeyFrame.Size = UDim2.new(0, 0, 0, 0)
	GetKeyFrame.Visible = true
	local popTween = TweenService:Create(GetKeyFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 420, 0, 310)
	})
	popTween:Play()
end)
