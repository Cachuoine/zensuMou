-- [[ UI Controller ]] --
local UIController = {}

function UIController.CreateMainUI()
    local success, result = pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BloxFruitAutoFarmUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = game.CoreGui

        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 320, 0, 220)
        MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
        MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Text = "Blox Fruits - Auto Farm Hub"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 16
        Title.Font = Enum.Font.SourceSansBold
        Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Title.Parent = MainFrame

        return ScreenGui
    end)
    return success and result
end

return UIController
