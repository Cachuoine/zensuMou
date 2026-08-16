local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player=Players.LocalPlayer
if not player then return end
local gui=player:WaitForChild("PlayerGui",10)
local hub=gui and gui:FindFirstChild("FishHub")
local tab=hub and hub:FindFirstChild("FunctionTab")
if not tab then return end

for _,child in ipairs(tab:GetChildren()) do child:Destroy() end
tab.ScrollBarThickness=0
tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
tab.CanvasSize=UDim2.new()

local function theme()
    local main=hub:FindFirstChild("MainWindow")
    local s=main and main:FindFirstChildOfClass("UIStroke")
    return s and s.Color or Color3.fromRGB(0,229,255)
end
local function corner(o,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r or 10)c.Parent=o end
local function stroke(o,t)local s=Instance.new("UIStroke")s.Color=theme()s.Thickness=1s.Transparency=t or .2s.Parent=o return s end

local root=Instance.new("Frame")root.Parent=tab root.Size=UDim2.new(1,-8,0,0)root.AutomaticSize=Enum.AutomaticSize.Y root.BackgroundTransparency=1
local list=Instance.new("UIListLayout")list.Parent=root list.Padding=UDim.new(0,10)list.HorizontalAlignment=Enum.HorizontalAlignment.Center

local searchFrame=Instance.new("Frame")searchFrame.Parent=root searchFrame.Size=UDim2.new(1,-12,0,44)
searchFrame.BackgroundColor3=Color3.fromRGB(7,8,12)searchFrame.BackgroundTransparency=.04 searchFrame.BorderSizePixel=0 corner(searchFrame,10)
stroke(searchFrame,.2)
local icon=Instance.new("TextLabel")icon.Parent=searchFrame icon.Size=UDim2.new(0,38,1,0)icon.BackgroundTransparency=1 icon.Text="⌕"
icon.Font=Enum.Font.GothamBold icon.TextSize=20 icon.TextColor3=theme()
local search=Instance.new("TextBox")search.Parent=searchFrame search.Size=UDim2.new(1,-48,1,0)search.Position=UDim2.new(0,42,0,0)
search.BackgroundTransparency=1 search.BorderSizePixel=0 search.ClearTextOnFocus=false search.PlaceholderText="search..."
search.PlaceholderColor3=Color3.fromRGB(105,110,125)search.Text=""search.Font=Enum.Font.GothamMedium search.TextSize=11
search.TextColor3=Color3.fromRGB(240,240,245)search.TextXAlignment=Enum.TextXAlignment.Left

local grid=Instance.new("Frame")grid.Parent=root grid.Size=UDim2.new(1,-12,0,0)grid.AutomaticSize=Enum.AutomaticSize.Y grid.BackgroundTransparency=1
local gl=Instance.new("UIGridLayout")gl.Parent=grid gl.CellSize=UDim2.new(.5,-6,0,86)gl.CellPadding=UDim2.new(0,10,0,10)
gl.HorizontalAlignment=Enum.HorizontalAlignment.Center gl.SortOrder=Enum.SortOrder.LayoutOrder

local names={"shop","setting farm","farm","item & quest","island","fruit","setiing"}
local cards={}
for i,name in ipairs(names) do
    local card=Instance.new("TextButton")card.Parent=grid card.LayoutOrder=i card.Name="Function_"..name:gsub("%s+","_")
    card.BackgroundColor3=Color3.fromRGB(7,8,12)card.BackgroundTransparency=.05 card.BorderSizePixel=0 card.AutoButtonColor=false card.Text=""
    corner(card,10)local s=stroke(card,.22)
    local dot=Instance.new("Frame")dot.Parent=card dot.Size=UDim2.new(0,6,0,6)dot.Position=UDim2.new(0,11,0,11)
    dot.BackgroundColor3=theme()dot.BorderSizePixel=0 corner(dot,6)
    local title=Instance.new("TextLabel")title.Parent=card title.Size=UDim2.new(1,-24,0,24)title.Position=UDim2.new(0,12,.5,-12)
    title.BackgroundTransparency=1 title.Text=name title.Font=Enum.Font.GothamBold title.TextSize=12 title.TextColor3=Color3.fromRGB(238,238,245)
    title.TextXAlignment=Enum.TextXAlignment.Center
    cards[#cards+1]={root=card,name=name,stroke=s,dot=dot}
end

local function filter()
    local q=string.lower(search.Text or "")
    for _,item in ipairs(cards) do
        item.root.Visible=q=="" or string.find(string.lower(item.name),q,1,true)~=nil
    end
end
search:GetPropertyChangedSignal("Text"):Connect(filter)
for _,item in ipairs(cards) do
    item.root.MouseEnter:Connect(function()
        TweenService:Create(item.root,TweenInfo.new(.15,Enum.EasingStyle.Quint),{BackgroundTransparency=0}):Play()
        TweenService:Create(item.stroke,TweenInfo.new(.15),{Thickness=1.5,Color=theme()}):Play()
    end)
    item.root.MouseLeave:Connect(function()
        TweenService:Create(item.root,TweenInfo.new(.15,Enum.EasingStyle.Quint),{BackgroundTransparency=.05}):Play()
        TweenService:Create(item.stroke,TweenInfo.new(.15),{Thickness=1,Color=theme()}):Play()
    end)
end

task.spawn(function()
    while tab.Parent and root.Parent do
        local c=theme()
        icon.TextColor3=c
        for _,item in ipairs(cards) do item.stroke.Color=c item.dot.BackgroundColor3=c end
        for _,o in ipairs(root:GetDescendants()) do if o:IsA("UIStroke") then o.Color=c end end
        task.wait(.45)
    end
end)
