-- [[ Weapon Config ]] --
local WeaponConfig = {
    -- Loại vũ khí chính ưu tiên sử dụng: "Melee", "Sword", "Blox Fruit", "Gun"
    PrimaryWeapon = "Melee",
    
    -- Tùy chọn bật/tắt Fast Attack (Đánh nhanh)
    FastAttack = true,
    
    -- Cấu hình kỹ năng (Skills) tự động tung chiêu khi đánh quái
    Skills = {
        Z = { Enabled = true, HoldTime = 0 },
        X = { Enabled = true, HoldTime = 0 },
        C = { Enabled = true, HoldTime = 0 },
        V = { Enabled = true, HoldTime = 0 },
        F = { Enabled = false, HoldTime = 0 }, -- Thường tắt F để tránh bay nhầm đi chỗ khác
    }
}

return WeaponConfig
