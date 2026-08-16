local C = ...
local Tab = C.Tab
local TweenService = C.TweenService

Tab:ClearAllChildren()
Tab.ScrollBarThickness=0
Tab.AutomaticCanvasSize=Enum.AutomaticSize.Y
Tab.CanvasSize=UDim2.new(0,0,0,0)

local Theme=function() return C.GetThemeColor() end
local Root=Instance.new("Frame")
Root.Parent=Tab
Root.Size=UDim2.new(1,-8,0,0)
Root.AutomaticSize=Enum.AutomaticSize.Y
Root.BackgroundTransparency=1

local layout=Instance.new("UIListLayout")
layout.Parent=Root
layout.Padding=UDim.new(0,10)
layout.HorizontalAlignment=Enum.HorizontalAlignment.Center

local function Corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 9)
    c.Parent=o
end

local function Stroke(o)
    local s=Instance.new("UIStroke")
    s.Color=Theme()
    s.Thickness=1
    s.Transparency=0.2
    s.Parent=o
    return s
end

local searchFrame=Instance.new("Frame")
searchFrame.Parent=Root
searchFrame.Size=UDim2.new(1,-12,0,42)
searchFrame.BackgroundColor3=Color3.fromRGB(7,8,12)
searchFrame.BackgroundTransparency=0.05
searchFrame.BorderSizePixel=0
Corner(searchFrame,9)
Stroke(searchFrame)

local icon=Instance.new("TextLabel")
icon.Parent=searchFrame
icon.Size=UDim2.new(0,34,1,0)
icon.BackgroundTransparency=1
icon.Text="⌕"
icon.Font=Enum.Font.GothamBold
icon.TextSize=19
icon.TextColor3=Theme()

local search=Instance.new("TextBox")
search.Parent=searchFrame
search.Size=UDim2.new(1,-44,1,0)
search.Position=UDim2.new(0,40,0,0)
search.BackgroundTransparency=1
search.BorderSizePixel=0
search.ClearTextOnFocus=false
search.PlaceholderText="search..."
search.PlaceholderColor3=Color3.fromRGB(105,110,125)
search.Text=""
search.Font=Enum.Font.GothamMedium
search.TextSize=11
search.TextColor3=Color3.fromRGB(240,240,245)
search.TextXAlignment=Enum.TextXAlignment.Left

local grid=Instance.new("Frame")
grid.Parent=Root
grid.Size=UDim2.new(1,-12,0,0)
grid.AutomaticSize=Enum.AutomaticSize.Y
grid.BackgroundTransparency=1

local gridLayout=Instance.new("UIGridLayout")
gridLayout.Parent=grid
gridLayout.CellSize=UDim2.new(0.5,-6,0,82)
gridLayout.CellPadding=UDim2.new(0,10,0,10)
gridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
gridLayout.SortOrder=Enum.SortOrder.LayoutOrder

local names={"shop","setting farm","farm","item & quest","island","fruit","setiing"}
local cards={}

for index,name in ipairs(names) do
    local card=Instance.new("TextButton")
    card.Parent=grid
    card.Name="Function_"..name:gsub("%s+","_")
    card.LayoutOrder=index
    card.BackgroundColor3=Color3.fromRGB(7,8,12)
    card.BackgroundTransparency=0.05
    card.BorderSizePixel=0
    card.AutoButtonColor=false
    card.Text=""
    Corner(card,10)
    local s=Stroke(card)
    local title=Instance.new("TextLabel")
    title.Parent=card
    title.Size=UDim2.new(1,-20,0,22)
    title.Position=UDim2.new(0,10,0.5,-11)
    title.BackgroundTransparency=1
    title.Text=name
    title.Font=Enum.Font.GothamBold
    title.TextSize=12
    title.TextColor3=Color3.fromRGB(238,238,245)
    title.TextXAlignment=Enum.TextXAlignment.Center
    local dot=Instance.new("Frame")
    dot.Parent=card
    dot.Size=UDim2.new(0,5,0,5)
    dot.Position=UDim2.new(0,10,0,10)
    dot.BackgroundColor3=Theme()
    dot.BorderSizePixel=0
    Corner(dot,5)
    cards[index]={root=card,name=name,stroke=s,title=title}
end

local function Filter()
    local q=string.lower(search.Text or "")
    for _,item in ipairs(cards) do
        item.root.Visible=q=="" or string.find(string.lower(item.name),q,1,true)~=nil
    end
end
search:GetPropertyChangedSignal("Text"):Connect(Filter)

for _,item in ipairs(cards) do
    item.root.MouseEnter:Connect(function()
        TweenService:Create(item.root,TweenInfo.new(0.15,Enum.EasingStyle.Quint),{BackgroundTransparency=0}):Play()
        TweenService:Create(item.stroke,TweenInfo.new(0.15),{Color=Theme(),Thickness=1.5}):Play()
    end)
    item.root.MouseLeave:Connect(function()
        TweenService:Create(item.root,TweenInfo.new(0.15,Enum.EasingStyle.Quint),{BackgroundTransparency=0.05}):Play()
        TweenService:Create(item.stroke,TweenInfo.new(0.15),{Color=Theme(),Thickness=1}):Play()
    end)
    item.root.MouseButton1Click:Connect(function()
        if C.Notify then C.Notify(item.name.." is ready.") end
    end)
end

task.spawn(function()
    while Tab.Parent and Root.Parent do
        local color=Theme()
        icon.TextColor3=color
        for _,item in ipairs(cards) do
            item.stroke.Color=color
            item.root:FindFirstChildOfClass("Frame").BackgroundColor3=color
        end
        task.wait(0.5)
    end
end)
