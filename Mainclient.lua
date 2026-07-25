-- [[ Mainclient.lua ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

if getgenv().ProjectLoaded then
    warn("System already loaded!")
    return
end
getgenv().ProjectLoaded = true

print("Initializing Mainclient...")

local CoreGui = game:GetService("CoreGui")

-- Tải Controller AutoFarm từ GitHub của bạn
local AutoFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/zensuMou/bloxfruit/main/UI/Controllers/AutoFarm.lua"))()

-- Tạo UI đơn giản để test nút bấm
if CoreGui:FindFirstChild("BloxFruitUI") then CoreGui.BloxFruitUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BloxFruitUI"

local Btn = Instance.new("TextButton", ScreenGui)
Btn.Size = UDim2.new(0, 200, 0, 50)
Btn.Position = UDim2.new(0.5, -100, 0.2, 0)
Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Btn.Text = "Toggle Auto Farm: OFF"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

local active = false
Btn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Btn.Text = "Toggle Auto Farm: ON"
        AutoFarm.Start()
    else
        Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Btn.Text = "Toggle Auto Farm: OFF"
        AutoFarm.Stop()
    end
end)

print("Mainclient Loaded Successfully!")
