-- Shop.lua
-- Đảm bảo tương thích 100% với cấu trúc hiện tại của FishHub Blox Fruit

local ShopModule = {}

function ShopModule.Load(parentContainer)
    -- Xóa nội dung cũ nếu có để tránh trùng lặp
    for _, child in ipairs(parentContainer:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    -- Tạo Main Layout cho Shop UI
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = parentContainer
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)

    -- Hàm tạo một Item/Toggle trong Shop
    local function CreateShopOption(name, description, callback)
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, 0, 0, 50)
        itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = parentContainer

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = itemFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 15, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.SourceSansBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Text = name
        titleLabel.Parent = itemFrame

        local actionButton = Instance.new("TextButton")
        actionButton.Size = UDim2.new(0, 100, 0, 30)
        actionButton.Position = UDim2.new(1, -115, 0.5, -15)
        actionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        actionButton.BorderSizePixel = 0
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionButton.TextSize = 13
        actionButton.Font = Enum.Font.SourceSansBold
        actionButton.Text = "Execute"
        actionButton.Parent = itemFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = actionButton

        local active = false
        actionButton.MouseButton1Click:Connect(function()
            active = not active
            if active then
                actionButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                actionButton.Text = "Active"
            else
                actionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                actionButton.Text = "Execute"
            end
            if callback then
                callback(active)
            end
        end)
    end

    -- Thêm các tính năng vào Shop UI
    CreateShopOption("Auto Buy Legendary Swords", "Tự động mua các kiếm mạnh (Saber, Rengoku...)", function(state)
        print("Auto Buy Swords State: " .. tostring(state))
    end)

    CreateShopOption("Auto Buy Haki (Step/Enhancement)", "Tự động mua Buso/Observation Haki", function(state)
        print("Auto Buy Haki State: " .. tostring(state))
    end)

    CreateShopOption("Black Market Auto Buy", "Mua nguyên liệu và vật phẩm đặc biệt", function(state)
        print("Black Market State: " .. tostring(state))
    end)
end

return ShopModule
