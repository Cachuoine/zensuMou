-- Security/HWID.lua
local HWID = {}

function HWID.Get()
    local success, hwid = pcall(function()
        -- Sử dụng các hàm đặc trưng của exploit để lấy HWID
        if gethwid then
            return gethwid()
        elseif syn and syn.get_hwid then
            return syn.get_hwid()
        elseif RBXId then
            return RBXId
        else
            -- Dự phòng nếu exploit không hỗ trợ trực tiếp hàm gethwid
            return game:GetService("RbxAnalyticsService"):GetClientId()
        end
    end)
    
    if success and hwid then
        return tostring(hwid)
    else
        return "UNKNOWN_HWID"
    end
end

return HWID
