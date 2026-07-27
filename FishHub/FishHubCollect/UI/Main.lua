-- UI/Main.lua
local CoreGui = game:GetService("CoreGui")
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/UI/Theme.lua"))()
local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/Security/KeySystem.lua"))()

local MainUI = {}

function MainUI.RenderKeyUI()
    if CoreGui:FindFirstChild("FishHubKeySystem") then
        CoreGui.FishHubKeySystem:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishHubKeySystem"
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 420, 0, 240)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -120)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Theme.Primary
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame
    
    -- Tiêu đề
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 30)
    Title.Position = UDim2.new(0, 20, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "FishHub-Collect | Xác Thực Key"
    Title.TextColor3 = Theme.Accent
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame
    
    -- Ô nhập Key
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -40, 0, 45)
    TextBox.Position = UDim2.new(0, 20, 0, 65)
    TextBox.BackgroundColor3 = Theme.Container
    TextBox.BorderSizePixel = 0
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = "Nhập Key của bạn tại đây..."
    TextBox.PlaceholderColor3 = Theme.TextGray
    TextBox.Text = ""
    TextBox.TextColor3 = Theme.TextWhite
    TextBox.TextSize = 14
    TextBox.Parent = MainFrame
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = TextBox
    
    -- Nút Lấy Key
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.48, 0, 0, 40)
    GetKeyBtn.Position = UDim2.new(0, 20, 0, 125)
    GetKeyBtn.BackgroundColor3 = Theme.Container
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "Lấy Key"
    GetKeyBtn.TextColor3 = Theme.TextWhite
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Parent = MainFrame
    
    local BtnCorner1 = Instance.new("UICorner")
    BtnCorner1.CornerRadius = UDim.new(0, 8)
    BtnCorner1.Parent = GetKeyBtn
    
    GetKeyBtn.MouseButton1Click:Connect(function()
        KeySystem.OpenKeyLink()
    end)
    
    -- Nút Xác Thực
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.48, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.52, -20, 0, 125)
    VerifyBtn.BackgroundColor3 = Theme.Primary
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Text = "Xác Thực"
    VerifyBtn.TextColor3 = Theme.TextWhite
    VerifyBtn.TextSize = 14
    VerifyBtn.Parent = MainFrame
    
    local BtnCorner2 = Instance.new("UICorner")
    BtnCorner2.CornerRadius = UDim.new(0, 8)
    BtnCorner2.Parent = VerifyBtn
    
    VerifyBtn.MouseButton1Click:Connect(function()
        local success, msg = KeySystem.Verify(TextBox.Text)
        if success then
            ScreenGui:Destroy()
            -- Gọi hàm mở giao diện Hub chính ở đây sau khi vượt Key thành công
        else
            warn("[FishHub] " .. msg)
        end
    end)
end

return MainUI
