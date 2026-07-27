-- Security/KeySystem.lua
local HWID = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/Security/HWID.lua"))()
local Network = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/Core/Network.lua"))()
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cachuoine/zensuMou/refs/heads/main/FishHub/FishHubCollect/Core/Config.lua"))()

local KeySystem = {}

function KeySystem.Verify(inputKey)
    local currentHWID = HWID.Get()
    
    -- Gọi dữ liệu key từ Firebase (ví dụ cấu trúc lưu trữ trên firebase theo key)
    local keyData = Network:Get("Keys/" .. tostring(inputKey))
    
    if not keyData then
        return false, "Key không tồn tại trên hệ thống!"
    end
    
    -- Kiểm tra xem key đã bị khóa hoặc hết hạn chưa
    if keyData.Status == "Revoked" then
        return false, "Key này đã bị vô hiệu hóa!"
    end
    
    -- Kiểm tra HWID (nếu key đã được gán cho máy khác)
    if keyData.HWID and keyData.HWID ~= "" and keyData.HWID ~= currentHWID then
        return false, "Key này đã được sử dụng bởi thiết bị khác!"
    end
    
    -- Nếu chưa có HWID thì gán HWID hiện tại vào key trên Firebase
    if not keyData.HWID or keyData.HWID == "" then
        Network:Post("Keys/" .. tostring(inputKey), {
            HWID = currentHWID,
            LastUsed = os.time()
        })
    end
    
    return true, "Xác thực thành công!"
end

function KeySystem.OpenKeyLink()
    if syn and syn.request then
        syn.request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
            Body = game:GetService("HttpService"):JSONEncode({args = {code = Config.KeyWebsiteUrl}, cmd = "BROWSER_OPEN", nonce = "1"})
        })
    elseif setclipboard then
        setclipboard(Config.KeyWebsiteUrl)
        print("[FishHub] Đã sao chép link lấy key vào clipboard của bạn!")
    end
end

return KeySystem
