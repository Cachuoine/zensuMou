-- [[ Inventory Controller ]] --
local InventoryController = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra item có trong Backpack hoặc Character không
function InventoryController.HasItem(itemName)
    local success, result = pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        
        if (backpack and backpack:FindFirstChild(itemName)) or (character and character:FindFirstChild(itemName)) then
            return true
        end
        return false
    end)
    return success and result
end

return InventoryController
