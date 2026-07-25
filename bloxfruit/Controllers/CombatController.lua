-- [[ Combat Controller ]] --
local CombatController = {}
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Mô phỏng click chuột đánh quái
function CombatController.Attack()
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.05)
        VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end

-- Tự động trang bị vũ khí từ Backpack
function CombatController.EquipWeapon(weaponName)
    pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        if backpack and character then
            -- Kiểm tra nếu chưa cầm vũ khí đó thì trang bị vào
            if not character:FindFirstChild(weaponName) then
                local tool = backpack:FindFirstChild(weaponName)
                if tool then
                    LocalPlayer.Character.Humanoid:EquipTool(tool)
                end
            end
        end
    end)
end

return CombatController
