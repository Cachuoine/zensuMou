-- [[ UIController.lua - Khởi tạo giao diện ScreenGui ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local UIController = {}

function UIController.CreateMainUI()
    -- Xóa UI cũ nếu đã tồn tại để tránh trùng lặp
    if CoreGui:FindFirstChild("FishHubUI") then
        CoreGui.FishHubUI:Destroy()
    end

    -- 1. Tạo ScreenGui tổng
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishHubUI"
    ScreenGui.ResetOnSpawn = false
    
    -- Đưa vào CoreGui (ưu tiên trên Executor) hoặc PlayerGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- 2. Khung Menu chính (Main Frame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 260)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- Cho phép nắm kéo menu di chuyển
    MainFrame.Parent = ScreenGui

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 10)
    FrameCorner.Parent = MainFrame

    -- 3. Thanh tiêu đề (Title Bar)
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, 0, 0, 45)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
    TitleLabel.Text = "   🐟 FishHub - Blox Fruits Auto Farm"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleLabel

    -- 4. Nút Bật / Tắt Auto Farm
    local AutoFarmBtn = Instance.new("TextButton")
    AutoFarmBtn.Name = "AutoFarmToggle"
    AutoFarmBtn.Size = UDim2.new(0.85, 0, 0, 45)
    AutoFarmBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60) -- Đỏ (Tắt)
    AutoFarmBtn.Text = "Auto Farm Level: OFF"
    AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoFarmBtn.TextSize = 16
    AutoFarmBtn.Font = Enum.Font.SourceSansBold
    AutoFarmBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = AutoFarmBtn

    -- 5. Xử lý sự kiện bấm nút Auto Farm
    local isFarmActive = false
    AutoFarmBtn.MouseButton1Click:Connect(function()
        isFarmActive = not isFarmActive
        
        -- Gọi Controller AutoFarm
        local success, AutoFarm = pcall(function()
            return require(game:GetService("ReplicatedStorage"):WaitForChild("bloxfruit"):WaitForChild("Controllers"):WaitForChild("AutoFarm"))
        end)

        if isFarmActive then
            AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 80) -- Xanh (Bật)
            AutoFarmBtn.Text = "Auto Farm Level: ON"
            if success and AutoFarm then AutoFarm.Start() end
        else
            AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60) -- Đỏ (Tắt)
            AutoFarmBtn.Text = "Auto Farm Level: OFF"
            if success and AutoFarm then AutoFarm.Stop() end
        end
    end)

    print("[UIController]: Đã hiển thị giao diện thành công!")
    return ScreenGui
end

return UIController
