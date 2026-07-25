-- [[ FishHub.lua - Cập nhật vòng lặp Auto Farm thực tế ]] --
-- (Giữ nguyên phần khởi tạo UI ở trên của bạn, chỉ thay thế đoạn hàm StartAutoFarm bên dưới)

local function StartAutoFarm()
    task.spawn(function()
        print("[AutoFarm]: Đã kích hoạt hệ thống cày cấp tự động.")
        
        while isFarmActive do
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then 
                    return 
                end
                
                local hrp = character.HumanoidRootPart
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if humanoid and humanoid.Health > 0 then
                    -- 1. Kiểm tra nhiệm vụ hiện tại (Quest check)
                    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") 
                    and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                    
                    if not questGui or not questGui.Visible then
                        -- Nếu chưa nhận nhiệm vụ -> Di chuyển đến NPC nhận quest theo cấp độ
                        -- print("[AutoFarm]: Đang tìm và nhận nhiệm vụ...")
                        -- (Code nhận quest sẽ đặt ở đây)
                    else
                        -- Nếu đã có nhiệm vụ -> Tìm quái tương ứng để farm
                        -- print("[AutoFarm]: Đang tìm quái để tiêu diệt...")
                        -- (Code tìm quái & tween đến quái sẽ đặt ở đây)
                    end
                end
            end)
            task.wait(0.5) -- Tốc độ quét vòng lặp
        end
        
        print("[AutoFarm]: Đã dừng hệ thống cày cấp.")
    end)
end
