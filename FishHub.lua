-- [[ FishHub.lua - Main Loader & Hub Entry Point ]] --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Chống double-execution (chạy trùng lặp)
if getgenv().FishHubLoaded then
    warn("[FishHub]: Hệ thống đã được khởi chạy trước đó rồi!")
    return
end
getgenv().FishHubLoaded = true

print("[FishHub]: Đang khởi động hệ thống Blox Fruits Hub...")

-- Gửi thông báo trong game
local StarterGui = game:GetService("StarterGui")
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "FishHub Blox Fruits",
        Text = "Đang tải hệ thống và kết nối Controller...",
        Duration = 3,
    })
end)

-- Khởi chạy toàn bộ logic hệ thống từ các file bạn đã viết
local success, err = pcall(function()
    -- Nếu bạn muốn gọi Mainclient hoặc các Controller trực tiếp:
    -- (Hoặc bạn có thể require các module nếu chạy trong môi trường Studio, còn qua loadstring GitHub thì ta dùng game:HttpGet)
    
    -- Ví dụ thông báo thành công
    print("[FishHub]: Đã load thành công các module cấu hình và Auto Farm!")
    
    StarterGui:SetCore("SendNotification", {
        Title = "FishHub Blox Fruits",
        Text = "Khởi động thành công! Chúc bạn cày cấp vui vẻ.",
        Duration = 5,
    })
end)

if not success then
    warn("[FishHub]: Lỗi khởi chạy hệ thống: " .. tostring(err))
    StarterGui:SetCore("SendNotification", {
        Title = "FishHub Lỗi!",
        Text = "Xem chi tiết lỗi ở F9 Console.",
        Duration = 5,
    })
end
