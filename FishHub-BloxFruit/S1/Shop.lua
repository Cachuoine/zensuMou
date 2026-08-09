-- Tạo ScreenGui chứa giao diện
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitScreen"
screenGui.IgnoreGuiInset = true -- Trùm kín cả mép trên màn hình
screenGui.Parent = playerGui

-- Tạo khung nền màu đen
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Màu đen
background.BorderSizePixel = 0
background.Parent = screenGui

-- Tạo chữ "Blox Fruit"
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 400, 0, 100)
textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
textLabel.BackgroundTransparency = 1 -- Trong suốt khung nền chữ
textLabel.Text = "Blox Fruit"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Chữ màu trắng (hoặc vàng tùy ý)
textLabel.TextScaled = true -- Tự động co giãn chữ vừa khung
textLabel.Font = Enum.Font.FredokaOne -- Kiểu chữ đậm, nổi bật phong cách game
textLabel.Parent = background
