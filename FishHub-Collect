-- FishHub-Collect.lua
local BASE_URL = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/"

-- Hàm Toast Notification nổi ở góc phải bên dưới
local function ShowToast(title, message, duration)
    duration = duration or 3
    local CoreGui = game:GetService("CoreGui")
    
    if CoreGui:FindFirstChild("FishHubToast") then
        CoreGui.FishHubToast:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishHubToast"
    ScreenGui.Parent = CoreGui
    
    local ToastFrame = Instance.new("Frame")
    ToastFrame.Size = UDim2.new(0, 280, 0, 70)
    ToastFrame.Position = UDim2.new(1, -290, 1, 0)
    ToastFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    ToastFrame.BorderSizePixel = 0
    ToastFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = ToastFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(139, 92, 246)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = ToastFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 22)
    TitleLabel.Position = UDim2.new(0, 12, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(56, 189, 248)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ToastFrame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -20, 0, 30)
    DescLabel.Position = UDim2.new(0, 12, 0, 30)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = message
    DescLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    DescLabel.TextSize = 12
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = ToastFrame
    
    ToastFrame:TweenPosition(UDim2.new(1, -290, 1, -80), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    
    task.spawn(function()
        task.wait(duration)
        pcall(function()
            ToastFrame:TweenPosition(UDim2.new(1, -290, 1, 20), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            task.wait(0.3)
            ScreenGui:Destroy()
        end)
    end)
end

ShowToast("FishHub-Collect", "Đang khởi động hệ thống...", 3)

local success, bootstrapCode = pcall(function()
    return game:HttpGet(BASE_URL .. "Bootstrap.lua")
end)

if success and bootstrapCode then
    local func, err = loadstring(bootstrapCode)
    if func then
        pcall(func)
    else
        ShowToast("Lỗi Hệ Thống", "Lỗi biên dịch Bootstrap!", 4)
    end
else
    ShowToast("Lỗi Kết Nối", "Không thể tải Bootstrap từ GitHub!", 4)
end
