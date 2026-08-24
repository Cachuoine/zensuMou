return function(context)
    assert(type(context)=="table","creative.lua: context required")
    local Tab=assert(context.Tab,"Creative tab missing")
    local TweenService=context.TweenService or game:GetService("TweenService")
    local Config=context.Config or {}
    local ShowNotification=context.ShowNotification or function() end

    local old=Tab:FindFirstChild("CreativeRoot")
    if old then old:Destroy() end

    local root=Instance.new("Frame")
    root.Name="CreativeRoot"; root.Parent=Tab; root.Size=UDim2.fromScale(1,1); root.BackgroundTransparency=1
    local scroll=Instance.new("ScrollingFrame")
    scroll.Parent=root; scroll.Size=UDim2.fromScale(1,1); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=0; scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.CanvasSize=UDim2.new()
    local list=Instance.new("UIListLayout",scroll); list.Padding=UDim.new(0,10); list.HorizontalAlignment=Enum.HorizontalAlignment.Center
    local pad=Instance.new("UIPadding",scroll); pad.PaddingTop=UDim.new(0,10); pad.PaddingBottom=UDim.new(0,14); pad.PaddingLeft=UDim.new(0,8); pad.PaddingRight=UDim.new(0,8)

    local function accent() return Config.ThemeColor or Color3.fromRGB(0,229,255) end
    local function section(title,sub,height)
        local f=Instance.new("Frame",scroll); f.Size=UDim2.new(1,0,0,height or 64); f.BackgroundColor3=Color3.fromRGB(20,22,30); f.BorderSizePixel=0
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)
        local st=Instance.new("UIStroke",f); st.Thickness=1; st.Color=accent(); st.Transparency=.2
        local t=Instance.new("TextLabel",f); t.Size=UDim2.new(1,-24,0,22); t.Position=UDim2.new(.5,0,0,8); t.AnchorPoint=Vector2.new(.5,0); t.BackgroundTransparency=1; t.Text=title; t.Font=Enum.Font.GothamBold; t.TextSize=12; t.TextColor3=accent()
        local s=Instance.new("TextLabel",f); s.Size=UDim2.new(1,-24,0,18); s.Position=UDim2.new(.5,0,0,32); s.AnchorPoint=Vector2.new(.5,0); s.BackgroundTransparency=1; s.Text=sub; s.Font=Enum.Font.Code; s.TextSize=8; s.TextColor3=Color3.fromRGB(150,155,170)
        return f,st,t,s
    end

    local header,hstroke,htitle,hsub=section("CREATIVE","FISHHUB • SOCIAL & COMMUNITY",64)
    local connect,cstroke,ctitle=section("CONNECT","Three circular links • theme + rainbow ready",178)

    local row=Instance.new("Frame",connect); row.Size=UDim2.new(1,-30,0,112); row.Position=UDim2.new(.5,0,0,52); row.AnchorPoint=Vector2.new(.5,0); row.BackgroundTransparency=1
    local layout=Instance.new("UIListLayout",row); layout.FillDirection=Enum.FillDirection.Horizontal; layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; layout.VerticalAlignment=Enum.VerticalAlignment.Center; layout.Padding=UDim.new(0,26)

    local buttons={}
    local function circle(icon,label,callback)
        local holder=Instance.new("Frame",row); holder.Size=UDim2.new(0,82,0,108); holder.BackgroundTransparency=1
        local b=Instance.new("TextButton",holder); b.Size=UDim2.new(0,62,0,62); b.Position=UDim2.new(.5,0,0,0); b.AnchorPoint=Vector2.new(.5,0); b.BackgroundColor3=Color3.fromRGB(29,31,42); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Text=icon; b.Font=Enum.Font.GothamBold; b.TextSize=18; b.TextColor3=accent()
        Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
        local bs=Instance.new("UIStroke",b); bs.Thickness=1.5; bs.Color=accent()
        local glow=Instance.new("Frame",b); glow.Size=UDim2.new(1,10,1,10); glow.Position=UDim2.new(.5,0,.5,0); glow.AnchorPoint=Vector2.new(.5,.5); glow.BackgroundColor3=accent(); glow.BackgroundTransparency=.92; glow.BorderSizePixel=0; glow.ZIndex=b.ZIndex-1
        Instance.new("UICorner",glow).CornerRadius=UDim.new(1,0)
        local l=Instance.new("TextLabel",holder); l.Size=UDim2.new(1,0,0,24); l.Position=UDim2.new(.5,0,0,72); l.AnchorPoint=Vector2.new(.5,0); l.BackgroundTransparency=1; l.Text=label; l.Font=Enum.Font.GothamBold; l.TextSize=8; l.TextColor3=accent()
        table.insert(buttons,{b=b,bs=bs,glow=glow,label=l})
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.16,Enum.EasingStyle.Back),{Size=UDim2.new(0,70,0,70)}):Play(); TweenService:Create(glow,TweenInfo.new(.16),{BackgroundTransparency=.82}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.16,Enum.EasingStyle.Quint),{Size=UDim2.new(0,62,0,62)}):Play(); TweenService:Create(glow,TweenInfo.new(.16),{BackgroundTransparency=.92}):Play() end)
        b.Activated:Connect(callback)
    end

    circle("D","DISCORD",function() ShowNotification("Discord button pressed") end)
    circle("f","FACEBOOK",function() ShowNotification("Facebook button pressed") end)
    circle("♪","TIKTOK",function() ShowNotification("TikTok button pressed") end)

    local style,sstroke,stitle,ssub=section("STYLE","Theme color and rainbow are shared with FishHub",72)
    task.spawn(function()
        while root and root.Parent do
            local c=accent()
            for _,o in ipairs(root:GetDescendants()) do
                if o:IsA("UIStroke") then o.Color=c end
                if o:IsA("TextLabel") and (o==htitle or o==ctitle or o==stitle or o==ssub or o.Parent==header or o.Parent==connect or o.Parent==style) then
                    if o~=hsub then o.TextColor3=c end
                end
            end
            for _,x in ipairs(buttons) do x.bs.Color=c; x.glow.BackgroundColor3=c; x.label.TextColor3=c; x.b.TextColor3=c end
            task.wait(.08)
        end
    end)
end
