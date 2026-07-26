-- [[ FishHub - Master Script Hub Loader ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

if getgenv().FishHubRunning then
    warn("[FishHub]: Script Hub đã được chạy trước đó!")
    return
end
getgenv().FishHubRunning = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Tải Controller AutoFarm từ GitHub
local autoFarmUrl = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Controllers/AutoFarm.lua"
local success, AutoFarm = pcall(function()
    return loadstring(game:HttpGet(autoFarmUrl))()
end)

if not success or not AutoFarm then
    warn("[FishHub Error]: Không thể tải AutoFarm Controller!")
end

-- 2. Dựng Giao Diện UI Script Hub chuẩn (Có Menu, Tab, Nút bấm mượt mà)
if CoreGui:FindFirstChild("FishHubUI") then
    CoreGui.FishHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHubUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Khung chính của Hub)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo thả khung Hub trên màn hình
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

-- Tiêu đề Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 34, 45)
Title.Text = "  🐟 FishHub | Blox Fruits Master"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner", Title)
TitleCorner.CornerRadius = UDim.new(0, 10)

-- Nút bấm bật/tắt Auto Farm bên trong Hub
local ToggleFarmBtn = Instance.new("TextButton")
ToggleFarmBtn.Size = UDim2.new(0, 200, 0, 45)
ToggleFarmBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleFarmBtn.BackgroundColor3 = Color3.fromRGB(225, 60, 60)
ToggleFarmBtn.Text = "Auto Farm: OFF"
ToggleFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarmBtn.Font = Enum.Font.SourceSansBold
ToggleFarmBtn.TextSize = 16
ToggleFarmBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner", ToggleFarmBtn)
BtnCorner.CornerRadius = UDim.new(0, 8)

local farmActive = false
ToggleFarmBtn.MouseButton1Click:Connect(function()
    farmActive = not farmActive
    if farmActive then
        ToggleFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 80)
        ToggleFarmBtn.Text = "Auto Farm: ON"
        if AutoFarm and AutoFarm.Start then AutoFarm.Start() end
    else
        ToggleFarmBtn.BackgroundColor3 = Color3.fromRGB(225, 60, 60)
        ToggleFarmBtn.Text = "Auto Farm: OFF"
        if AutoFarm and AutoFarm.Stop then AutoFarm.Stop() end
    end
end)

-- Nút thu nhỏ/ẩn hiện Hub (Phím tắt hoặc nút bấm)
print("[FishHub]: Khởi chạy Script Hub thành công!")
