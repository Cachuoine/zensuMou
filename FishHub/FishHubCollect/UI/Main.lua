-- UI/Main.lua
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("FishHubMainUI") then
    CoreGui.FishHubMainUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHubMainUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(139, 92, 246)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 15)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "FishHub-Collect | Thành Công!"
Title.TextColor3 = Color3.fromRGB(56, 189, 248)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -30, 0, 30)
SubTitle.Position = UDim2.new(0, 15, 0, 55)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "Đã kết nối thành công từ file GitHub qua executor!"
SubTitle.TextColor3 = Color3.fromRGB(148, 163, 184)
SubTitle.TextSize = 13
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = MainFrame
