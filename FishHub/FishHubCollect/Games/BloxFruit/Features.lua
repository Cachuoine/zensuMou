-- Games/BloxFruit/Features.lua
local BloxFruitFeatures = {}

function BloxFruitFeatures.StartAutoFarm(enabled)
    if enabled then
        print("[BloxFruit] Đã bật tính năng Auto Farm!")
        -- Viết logic farm level/quest tại đây
    else
        print("[BloxFruit] Đã tắt tính năng Auto Farm!")
    end
end

function BloxFruitFeatures.StartAutoChest(enabled)
    if enabled then
        print("[BloxFruit] Đã bật tính năng Lượm Rương tự động!")
        -- Viết logic lượm rương tại đây
    end
end

return BloxFruitFeatures
