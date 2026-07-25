-- [[ Skill Controller ]] --
local SkillController = {}
local VirtualInputManager = game:GetService("VirtualInputManager")

local skillKeys = {
    Enum.KeyCode.Z,
    Enum.KeyCode.X,
    Enum.KeyCode.C,
    Enum.KeyCode.V,
    Enum.KeyCode.F
}

-- Kích hoạt tuần tự các skill
function SkillController.UseSkills()
    pcall(function()
        for _, key in ipairs(skillKeys) do
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
            task.wait(0.1) -- Độ trễ nhỏ giữa các lần bấm skill
        end
    end)
end

return SkillController
