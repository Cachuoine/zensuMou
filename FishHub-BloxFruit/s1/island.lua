return function(ctx)
    assert(type(ctx)=="table","island.lua: context required")
    local parent=assert(ctx.Parent or ctx.Content or ctx.Tab,"island.lua: Function module parent missing")
    local TweenService=ctx.TweenService or game:GetService("TweenService")
    local Config=ctx.Config or {}
    local accent=function() return Config.ThemeColor or Color3.fromRGB(0,229,255) end

    local root=Instance.new("Frame")
    root.Name="islandRoot"; root.Parent=parent; root.Size=UDim2.new(1,-8,0,92); root.BackgroundColor3=Color3.fromRGB(24,26,35); root.BorderSizePixel=0
    Instance.new("UICorner",root).CornerRadius=UDim.new(0,9)
    local stroke=Instance.new("UIStroke",root); stroke.Thickness=1; stroke.Color=accent(); stroke.Transparency=.25

    local title=Instance.new("TextLabel",root); title.Size=UDim2.new(1,-20,0,24); title.Position=UDim2.new(0,10,0,9); title.BackgroundTransparency=1; title.Font=Enum.Font.GothamBold; title.TextSize=12; title.Text="ISLAND"; title.TextColor3=accent(); title.TextXAlignment=Enum.TextXAlignment.Left
    local desc=Instance.new("TextLabel",root); desc.Size=UDim2.new(1,-20,0,32); desc.Position=UDim2.new(0,10,0,38); desc.BackgroundTransparency=1; desc.Font=Enum.Font.GothamMedium; desc.TextSize=9; desc.TextWrapped=true; desc.Text="Island and teleport controls belong here. Content is mounted inside Function → ISLAND."; desc.TextColor3=Color3.fromRGB(150,155,170); desc.TextXAlignment=Enum.TextXAlignment.Left

    task.spawn(function()
        while root and root.Parent do
            local c=accent(); stroke.Color=c; title.TextColor3=c
            task.wait(.08)
        end
    end)

    return root
end
