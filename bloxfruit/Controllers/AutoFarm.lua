-- [[ Controllers/AutoFarm.lua ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local AutoFarmController = {}
local isRunning = false

-- Gọi module TweenUtil an toàn qua GitHub Raw Link chuẩn
local success, TweenUtil = pcall(function()
    local url = "https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/bloxfruit/Modules/TweenUtil.lua"
    return loadstring(game:HttpGet(url))()
end)

if not success or not TweenUtil then
    warn("[AutoFarm Error]: Không thể tải hoặc biên dịch TweenUtil.lua từ GitHub!")
end

function AutoFarmController.Start()
    if isRunning then return end
    isRunning = true
    print("[AutoFarm Controller]: Đã BẮT ĐẦU.")
    
    task.spawn(function()
        while isRunning do
            task.wait(1)
            print("[AutoFarm]: Đang chạy vòng lặp farm...")
            
            -- Ví dụ sử dụng TweenUtil nếu đã load thành công
            if TweenUtil and TweenUtil.TweenTo then
                -- TweenUtil.TweenTo(CFrame.new(0, 100, 0))
            end
        end
    end)
end

function AutoFarmController.Stop()
    isRunning = false
    print("[AutoFarm Controller]: Đã DỪNG.")
end

-- QUAN TRỌNG: Phải trả về bảng để Loader nhận diện được
return AutoFarmController
