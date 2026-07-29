-- Đây là script nội dung phụ để test chức năng gọi URL khi ấn vào nút Main
print("Đã tải thành công Script Test Phụ từ URL!")

-- Bạn có thể tạo thêm các giao diện hoặc tính năng nhỏ ở đây để test
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FishHub") then
    local mainWin = PlayerGui.FishHub:FindFirstChild("MainWindow")
    if mainWin then
        -- Tạo một thông báo nhỏ bên trong khi load xong script phụ
        print("FishHub MainWindow đã sẵn sàng nhận script phụ.")
    end
end
