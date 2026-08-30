-- server.lua
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu có
if PlayerGui:FindFirstChild("FishHub_ServerUI") then
    PlayerGui.FishHub_ServerUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHub_ServerUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Top Bar (Nút Back & Thanh tìm kiếm)
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

local SearchBox = Instance.new("TextBox", TopBar)
SearchBox.Size = UDim2.new(0, 200, 0, 30)
SearchBox.Position = UDim2.new(0, 80, 0.5, -15)
SearchBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
SearchBox.PlaceholderText = "Tìm kiếm tính năng..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchBox.TextSize = 13
SearchBox.Font = Enum.Font.Gotham
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)

-- Content Area (Chia 2 bên)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, 0, 1, -45)
ContentArea.Position = UDim2.new(0, 0, 0, 45)
ContentArea.BackgroundTransparency = 1

local LeftMenu = Instance.new("ScrollingFrame", ContentArea)
LeftMenu.Size = UDim2.new(0, 160, 1, 0)
LeftMenu.BackgroundTransparency = 1
LeftMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
LeftMenu.ScrollBarThickness = 2

local UIListLayout = Instance.new("UIListLayout", LeftMenu)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Đường kẻ dọc ngăn cách
local Divider = Instance.new("Frame", ContentArea)
Divider.Size = UDim2.new(0, 2, 1, -10)
Divider.Position = UDim2.new(0, 160, 0, 5)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Divider.BorderSizePixel = 0

local RightContent = Instance.new("ScrollingFrame", ContentArea)
RightContent.Size = UDim2.new(1, -165, 1, 0)
RightContent.Position = UDim2.new(0, 165, 0, 0)
RightContent.BackgroundTransparency = 1
RightContent.CanvasSize = UDim2.new(0, 0, 0, 0)
RightContent.ScrollBarThickness = 4

local ContentText = Instance.new("TextLabel", RightContent)
ContentText.Size = UDim2.new(1, -20, 1, 0)
ContentText.Position = UDim2.new(0, 10, 0, 10)
ContentText.BackgroundTransparency = 1
ContentText.TextColor3 = Color3.fromRGB(210, 210, 230)
ContentText.TextSize = 13
ContentText.Font = Enum.Font.Gotham
ContentText.TextXAlignment = Enum.TextXAlignment.Left
ContentText.TextYAlignment = Enum.TextYAlignment.Top
ContentText.TextWrapped = true

-- Dữ liệu Tabs
local tabs = {
    {name = "island even", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/server/islandeven.lua"},
    {name = "boss", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/server/boss.lua"},
    {name = "miss", url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub-BloxFruit/s1/server/missserver.lua"}
}

local currentBtn = nil

for i, tabInfo in ipairs(tabs) do
    local TabBtn = Instance.new("TextButton", LeftMenu)
    TabBtn.Size = UDim2.new(1, -10, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    TabBtn.Text = "   " .. tabInfo.name:upper()
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    -- Hiệu ứng vạch kẻ dọc bên trái mỗi tab
    local AnimLine = Instance.new("Frame", TabBtn)
    AnimLine.Size = UDim2.new(0, 3, 0, 0)
    AnimLine.Position = UDim2.new(0, 0, 0.5, 0)
    AnimLine.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    AnimLine.BorderSizePixel = 0

    TabBtn.MouseButton1Click:Connect(function()
        if currentBtn == TabBtn then return end
        
        -- Reset các tab khác
        for _, child in ipairs(LeftMenu:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
                child.TextColor3 = Color3.fromRGB(160, 160, 180)
                local line = child:FindFirstChildOfClass("Frame")
                if line then line:TweenSize(UDim2.new(0, 3, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true) end
            end
        end
        
        -- Kích hoạt tab hiện tại
        currentBtn = TabBtn
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        AnimLine:TweenSize(UDim2.new(0, 3, 0, 24), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        AnimLine.Position = UDim2.new(0, 0, 0.5, -12)

        -- Load nội dung từ URL
        local success, result = pcall(function()
            return game:HttpGet(tabInfo.url)
        end)
        if success then
            ContentText.Text = result
        else
            ContentText.Text = "Không thể tải nội dung từ URL: " .. tabInfo.url
        end
    end)

    -- Vào luôn tab đầu tiên
    if i == 1 then
        TabBtn:EmitCI = true
        task.spawn(function()
            TabBtn.MouseButton1Click:Fire()
        end)
    end
end
