local games = {
	[85211729168715] = {name = "BloxFruit", status = "support", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit.lua"},
	[79091703265657] = {name = "BloxFruit", status = "support", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit.lua"},
	[100117331123089] = {name = "BloxFruit", status = "support", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit.lua"},
	[73902483975735] = {name = "BloxFruit", status = "support", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit.lua"},
	[134381727982611] = {name = "Evomon", status = "support"}, url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/evomon.lua"},
}
local currentPlaceId = game.PlaceId
local currentGameInfo = games[currentPlaceId]
local gameName = currentGameInfo and currentGameInfo.name or "Game"
local statusType = currentGameInfo and currentGameInfo.status or "not_supported"
local gameUrl = currentGameInfo and currentGameInfo.url or nil
local isAllowed = (statusType == "support" and gameUrl ~= nil)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHubCheckGame"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
local AlertBox = Instance.new("Frame")
AlertBox.Size = UDim2.new(0, 260, 0, 45)
AlertBox.AnchorPoint = Vector2.new(1, 1)
AlertBox.Position = UDim2.new(1, -20, 1, -20)
AlertBox.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
AlertBox.BackgroundTransparency = 0.2
AlertBox.Parent = ScreenGui
local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = AlertBox
local BoxStroke = Instance.new("UIStroke")
local strokeColor = Color3.fromRGB(0, 255, 128)
if statusType == "coming" then
	strokeColor = Color3.fromRGB(255, 180, 0)
elseif statusType == "not_supported" then
	strokeColor = Color3.fromRGB(255, 50, 80)
end
BoxStroke.Color = strokeColor
BoxStroke.Thickness = 1.2
BoxStroke.Transparency = 0.4
BoxStroke.Parent = AlertBox
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 8, 0, 8)
Dot.Position = UDim2.new(0, 15, 0.5, -4)
Dot.BackgroundColor3 = BoxStroke.Color
Dot.Parent = AlertBox
local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = Dot
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -35, 1, 0)
TextLabel.Position = UDim2.new(0, 30, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Dot.BackgroundColor3
TextLabel.TextSize = 12
TextLabel.Font = Enum.Font.Code
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
if statusType == "support" then
	TextLabel.Text = "[" .. gameName .. "]: support"
elseif statusType == "coming" then
	TextLabel.Text = "[" .. gameName .. "]: coming soon"
else
	TextLabel.Text = "[FISHHUB]: not support"
end
TextLabel.Parent = AlertBox
task.spawn(function()
	for i = 1, 4 do
		TweenService:Create(Dot, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
		TweenService:Create(TextLabel, TweenInfo.new(0.25), {TextTransparency = 0.5}):Play()
		task.wait(0.25)
		TweenService:Create(Dot, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
		TweenService:Create(TextLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
		task.wait(0.25)
	end
	if not isAllowed then
		Player:Kick("[FISHHUB] Game not support")
	else
		ScreenGui:Destroy()
		task.spawn(function()
			pcall(function()
				loadstring(game:HttpGet(gameUrl))()
			end)
		end)
	end
end)
