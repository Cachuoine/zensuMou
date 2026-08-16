--// FishHub - Function.lua
local Function = {}

local function clear(p)
    for _,c in ipairs(p:GetChildren()) do c:Destroy() end
end

local function corner(p,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=p
end

local function stroke(p,color)
    local s=Instance.new("UIStroke")
    s.Color=color
    s.Thickness=1
    s.Transparency=.25
    s.Parent=p
end

function Function:Load(tabFrame,themeColor)
    if not tabFrame then return end
    clear(tabFrame)
    themeColor=themeColor or Color3.fromRGB(0,200,255)

    local root=Instance.new("Frame")
    root.Size=UDim2.new(1,0,0,520)
    root.BackgroundTransparency=1
    root.Parent=tabFrame

    local search=Instance.new("TextBox")
    search.Size=UDim2.new(1,-12,0,38)
    search.Position=UDim2.new(0,6,0,5)
    search.BackgroundColor3=Color3.fromRGB(5,5,8)
    search.BorderSizePixel=0
    search.PlaceholderText="search..."
    search.PlaceholderColor3=Color3.fromRGB(105,105,120)
    search.Text=""
    search.TextColor3=Color3.fromRGB(235,235,245)
    search.Font=Enum.Font.GothamMedium
    search.TextSize=11
    search.ClearTextOnFocus=false
    search.Parent=root
    corner(search,8)
    stroke(search,themeColor)

    local grid=Instance.new("Frame")
    grid.Size=UDim2.new(1,-12,0,450)
    grid.Position=UDim2.new(0,6,0,52)
    grid.BackgroundTransparency=1
    grid.Parent=root

    local layout=Instance.new("UIGridLayout")
    layout.CellSize=UDim2.new(.48,0,0,108)
    layout.CellPadding=UDim2.new(.04,0,0,10)
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.Parent=grid

    local names={"Shop","Setting Farm","Farm","Item & Quest","Island","Fruit","Setting"}
    local cards={}

    for _,name in ipairs(names) do
        local b=Instance.new("TextButton")
        b.Name=name:gsub("%s+","")
        b.BackgroundColor3=Color3.fromRGB(5,5,8)
        b.BorderSizePixel=0
        b.AutoButtonColor=false
        b.Text=""
        b.Parent=grid
        corner(b,10)
        stroke(b,Color3.fromRGB(55,55,68))

        local title=Instance.new("TextLabel")
        title.Size=UDim2.new(1,-18,0,24)
        title.Position=UDim2.new(0,9,0,14)
        title.BackgroundTransparency=1
        title.Text=name
        title.TextColor3=Color3.fromRGB(225,225,235)
        title.Font=Enum.Font.GothamBold
        title.TextSize=12
        title.TextXAlignment=Enum.TextXAlignment.Left
        title.Parent=b

        local state=Instance.new("TextLabel")
        state.Size=UDim2.new(1,-18,0,20)
        state.Position=UDim2.new(0,9,0,43)
        state.BackgroundTransparency=1
        state.Text="Ready"
        state.TextColor3=Color3.fromRGB(110,110,125)
        state.Font=Enum.Font.GothamMedium
        state.TextSize=9
        state.TextXAlignment=Enum.TextXAlignment.Left
        state.Parent=b

        cards[#cards+1]={Button=b,Name=name}
    end

    local function refresh(q)
        q=string.lower(q or "")
        for _,item in ipairs(cards) do
            item.Button.Visible=q=="" or string.find(string.lower(item.Name),q,1,true)~=nil
        end
    end

    search:GetPropertyChangedSignal("Text"):Connect(function()
        refresh(search.Text)
    end)

    for _,item in ipairs(cards) do
        item.Button.MouseEnter:Connect(function()
            item.Button.BackgroundColor3=Color3.fromRGB(12,12,18)
        end)
        item.Button.MouseLeave:Connect(function()
            item.Button.BackgroundColor3=Color3.fromRGB(5,5,8)
        end)
    end
end

return Function
