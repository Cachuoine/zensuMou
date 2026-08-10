-- ================================================================
-- FishHub External Function Module
-- This file is intentionally independent from FishHub's main UI.
-- Replace this test UI with the real module implementation later.
-- ================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MODULE_NAME = 'FRUIT'
local ICON = '🍎'
local DESCRIPTION = 'Fruit module is running.'

local old = playerGui:FindFirstChild("FishHubExternalModule")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FishHubExternalModule"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(420, 250)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
main.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.Parent = main
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(75, 75, 90)
stroke.Thickness = 1

local title = Instance.new("TextLabel")
title.Parent = main
title.Position = UDim2.fromOffset(20, 20)
title.Size = UDim2.new(1, -70, 0, 34)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(245, 245, 250)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = ICON .. "  " .. MODULE_NAME

local close = Instance.new("TextButton")
close.Parent = main
close.AnchorPoint = Vector2.new(1, 0)
close.Position = UDim2.new(1, -14, 0, 14)
close.Size = UDim2.fromOffset(30, 30)
close.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
close.BorderSizePixel = 0
close.Text = "×"
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(230, 230, 235)
close.Font = Enum.Font.GothamBold
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local divider = Instance.new("Frame")
divider.Parent = main
divider.Position = UDim2.fromOffset(20, 64)
divider.Size = UDim2.new(1, -40, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
divider.BorderSizePixel = 0

local status = Instance.new("TextLabel")
status.Parent = main
status.Position = UDim2.fromOffset(20, 90)
status.Size = UDim2.new(1, -40, 0, 70)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamMedium
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(190, 190, 200)
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.Text = DESCRIPTION

local badge = Instance.new("TextLabel")
badge.Parent = main
badge.Position = UDim2.fromOffset(20, 180)
badge.Size = UDim2.fromOffset(105, 30)
badge.BackgroundColor3 = Color3.fromRGB(25, 45, 30)
badge.BorderSizePixel = 0
badge.Text = "●  TEST READY"
badge.TextSize = 10
badge.TextColor3 = Color3.fromRGB(120, 230, 140)
badge.Font = Enum.Font.GothamBold
Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 7)

return {
    Name = MODULE_NAME,
    Gui = gui,
    Close = function()
        if gui and gui.Parent then
            gui:Destroy()
        end
    end
}
