-- Tạo giao diện (UI) chọn Script Blox Fruits

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "ScriptHubSelector"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Blox Fruits Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Hàm tạo nút bấm chạy script
local function createButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = MainFrame
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    
    Button.MouseButton1Click:Connect(callback)
end

-- Thêm các nút script vào giao diện

createButton("APPLEHUB", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexHerrySeek/AppleHub/refs/heads/main/loader/main.lua"))()
end)

createButton("NANAHUB", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NaNaTV36/NaNaTVHubPremium/refs/heads/main/mainpremium.lua"))()
end)

createButton("QUANTUMHUB", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
end)

createButton("REALKIDHUB", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
end)

createButton("GRAVITYHUB", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))()
end)

createButton("NIGHTHUB", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/BF-Beta.lua"))()
end)

createButton("NIGHTMYSTICHUB", function()
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
    getgenv().team = "Marines"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-NightMystic/Bloxfruits/refs/heads/main/Script.lua"))()
end)
