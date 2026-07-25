-- [[ Quest Controller ]] --
local QuestController = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra xem người chơi hiện tại đã có nhiệm vụ hay chưa (dựa vào PlayerGui)
function QuestController.HasActiveQuest()
    local success, result = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local mainGui = playerGui:FindFirstChild("Main")
            if mainGui then
                local questGui = mainGui:FindFirstChild("Quest")
                if questGui and questGui.Visible then
                    return true
                end
            end
        end
        return false
    end)
    return success and result
end

-- Gửi yêu cầu nhận nhiệm vụ lên Server
function QuestController.AcceptQuest(questName, questLevel)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            if commF then
                -- Blox Fruits sử dụng CommF_ để tương tác nhận quest
                commF:InvokeServer("StartQuest", questName, questLevel)
            end
        end
    end)
end

-- Gửi yêu cầu hủy nhiệm vụ hiện tại
function QuestController.AbandonQuest()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            if commF then
                commF:InvokeServer("AbandonQuest")
            end
        end
    end)
end

return QuestController
