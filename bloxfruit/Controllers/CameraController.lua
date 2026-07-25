-- [[ Camera Controller ]] --
local CameraController = {}
local RunService = game:GetService("RunService")

-- Khóa camera hướng về mục tiêu đang đánh
function CameraController.LockToTarget(targetPart)
    pcall(function()
        if targetPart and targetPart.Parent then
            workspace.CurrentCamera.CFrame = CFrame.new(
                workspace.CurrentCamera.CFrame.Position, 
                targetPart.Position
            )
        end
    end)
end

return CameraController
