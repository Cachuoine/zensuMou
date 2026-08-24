local context = ...
if type(context) ~= "table" then return end

local Players=context.Players
local TweenService=context.TweenService
local Tab=context.Tab
local Config=context.Config or {}
local GetAccent=context.GetCurrentAccentColor or function() return Config.ThemeColor or Color3.fromRGB(0,229,255) end
local ShowNotification=context.ShowNotification or function() end

local root=Instance.new("Frame")
root.Name="CreativeContent"
root.Parent=Tab
root.Size=UDim2.fromScale(1,1)
root.BackgroundTransparency=1

local themeItems={}
local hue=0

local function accent()
    if Config.RainbowEnabled then
        return Color3.fromHSV(hue,.82,1)
    end
    return GetAccent()
end

local title=Instance.new("TextLabel")
title.Parent=root
title.Size=UDim2.new(1,-10,0,28)
title.Position=UDim2.new(0,5,0,5)
title.BackgroundTransparency=1
title.Text="CREATIVE"
title.Font=Enum.Font.GothamBold
title.TextSize=15
title.TextColor3=accent()
title.TextXAlignment=Enum.TextXAlignment.Center
table.insert(themeItems,title)

local line=Instance.new("Frame")
line.Parent=root
line.Size=UDim2.new(1,-80,0,1)
line.Position=UDim2.new(.5,0,0,38)
line.AnchorPoint=Vector2.new(.5,0)
line.BackgroundColor3=accent()
line.BorderSizePixel=0
table.insert(themeItems,line)

local sub=Instance.new("TextLabel")
sub.Parent=root
sub.Size=UDim2.new(1,-20,0,20)
sub.Position=UDim2.new(0,10,0,47)
sub.BackgroundTransparency=1
sub.Text="COMMUNITY LINKS"
sub.Font=Enum.Font.Code
sub.TextSize=9
sub.TextColor3=Color3.fromRGB(145,150,165)
sub.TextXAlignment=Enum.TextXAlignment.Center

local holder=Instance.new("Frame")
holder.Parent=root
holder.Size=UDim2.new(1,0,0,130)
holder.Position=UDim2.new(0,0,0,72)
holder.BackgroundTransparency=1

local layout=Instance.new("UIListLayout",holder)
layout.FillDirection=Enum.FillDirection.Horizontal
layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
layout.VerticalAlignment=Enum.VerticalAlignment.Center
layout.Padding=UDim.new(0,24)

local function social(label,assetId,url)
    local b=Instance.new("ImageButton")
    b.Parent=holder
    b.Size=UDim2.new(0,70,0,70)
    b.BackgroundColor3=Color3.fromRGB(36,38,49)
    b.BorderSizePixel=0
    b.AutoButtonColor=false
    b.Image="rbxassetid://"..assetId
    b.ScaleType=Enum.ScaleType.Fit
    b.ImageTransparency=.06
    Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
    local st=Instance.new("UIStroke",b)
    st.Thickness=1.5
    st.Color=accent()
    table.insert(themeItems,st)
    local scale=Instance.new("UIScale",b)
    b.MouseEnter:Connect(function()
        TweenService:Create(scale,TweenInfo.new(.2,Enum.EasingStyle.Back),{Scale=1.12}):Play()
        TweenService:Create(b,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(48,51,64)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(scale,TweenInfo.new(.2),{Scale=1}):Play()
        TweenService:Create(b,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(36,38,49)}):Play()
    end)
    b.MouseButton1Click:Connect(function()
        pcall(function() if setclipboard then setclipboard(url) end end)
        ShowNotification(label.." link copied")
    end)
    return b
end

social("Discord",79178042116025,"https://discord.gg/zFN6Nd99fC")
social("Facebook",121038275317096,"https://www.facebook.com/dao.huy.lam.09/")
social("TikTok",71597520923112,"https://www.tiktok.com/")

local footer=Instance.new("TextLabel")
footer.Parent=root
footer.Size=UDim2.new(1,-20,0,40)
footer.Position=UDim2.new(0,10,1,-48)
footer.BackgroundTransparency=1
footer.Text="FISHHUB  •  CREATIVE"
footer.Font=Enum.Font.GothamBold
footer.TextSize=10
footer.TextColor3=Color3.fromRGB(130,135,150)
footer.TextXAlignment=Enum.TextXAlignment.Center

task.spawn(function()
    while root and root.Parent do
        hue=(hue+math.max(.001,(tonumber(Config.RainbowSpeedPercent) or 100)/100000))%1
        local c=accent()
        for _,obj in ipairs(themeItems) do
            if obj and obj.Parent then
                if obj:IsA("UIStroke") then obj.Color=c
                elseif obj:IsA("Frame") then obj.BackgroundColor3=c
                elseif obj:IsA("TextLabel") then obj.TextColor3=c end
            end
        end
        task.wait(.03)
    end
end)

return {Destroy=function() if root and root.Parent then root:Destroy() end end}
