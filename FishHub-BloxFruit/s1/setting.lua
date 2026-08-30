-- setting.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FishHub_SettingUI") then
    PlayerGui.FishHub_SettingUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHub_SettingUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

local BackBtn = Instance.new("TextButton", TopBar)
BackBtn.Size = UDim2.new(0, 60, 0, 30)
BackBtn.Position = UDim2.new(0, 10, 0.5, -15)
BackBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
BackBtn.Text = "← Back"
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.TextSize = 13
BackBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 6)

-- Thanh tìm kiếm đã được đồng bộ chuẩn xác giống hệt các file phía trên
local SearchBox = Instance.new("TextBox", TopBar)
SearchBox.Size = UDim2.new(0, 200, 0, 30)
SearchBox.Position = UDim2.new(0, 80, 0.5, -15)
SearchBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
SearchBox.PlaceholderText = "Tìm kiếm cấu hình..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchBox.TextSize = 13
SearchBox.Font = Enum.Font.Gotham
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, 0, 1, -45)
ContentArea.Position = UDim2.new(0, 0, 0, 45)
ContentArea.BackgroundTransparency = 1

local RightContent = Instance.new("ScrollingFrame", ContentArea)
RightContent.Size = UDim2.new(1, -20, 1, 0)
RightContent.Position = UDim2.new(0, 10, 0, 0)
RightContent.BackgroundTransparency = 1
RightContent.CanvasSize = UDim2.new(0, 0, 0, 0)
RightContent.ScrollBarThickness = 4

local ContentText = Instance.new("TextLabel", RightContent)
ContentText.Size = UDim2.new(1, 0, 1, 0)
ContentText.Position = UDim2.new(0, 0, 0, 10)
ContentText.BackgroundTransparency = 1
ContentText.TextColor3 = Color3.fromRGB(210, 210, 230)
ContentText.TextSize = 13
ContentText.Font = Enum.Font.Gotham
ContentText.TextXAlignment = Enum.TextXAlignment.Left
ContentText.TextYAlignment = Enum.TextYAlignment.Top
ContentText.TextWrapped = true
ContentText.Text = "Cài đặt chung cho hệ thống FishHub."
