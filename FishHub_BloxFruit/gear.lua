local function CreateGear(context)
    context = context or {}
    local Players=context.Players or game:GetService("Players")
    local UserInputService=context.UserInputService or game:GetService("UserInputService")
    local TweenService=context.TweenService or game:GetService("TweenService")
    local Config=context.Config or {}
    local gui=context.gui
    local main=context.main
    local ShowNotification=context.ShowNotification or function() end
    local allHubStrokes=context.allHubStrokes or {}
    local allHubLines=context.allHubLines or {}
    local allThemeTexts=context.allThemeTexts or {}

    local window=Instance.new("Frame")
    window.Name="SettingsWindow"
    window.Parent=gui
    window.Size=UDim2.new(0,330,0,230)
    window.Position=UDim2.new(.5,0,.5,0)
    window.AnchorPoint=Vector2.new(.5,.5)
    window.BackgroundColor3=Config.BgMain or Color3.fromRGB(45,45,52)
    window.BorderSizePixel=0
    window.Visible=false
    Instance.new("UICorner",window).CornerRadius=UDim.new(0,12)
    local ws=Instance.new("UIStroke",window)
    ws.Thickness=1.5
    ws.Color=Config.ThemeColor or Color3.fromRGB(0,229,255)

    local title=Instance.new("TextLabel",window)
    title.Size=UDim2.new(1,-24,0,30)
    title.Position=UDim2.new(0,12,0,8)
    title.BackgroundTransparency=1
    title.Text="SETTINGS"
    title.Font=Enum.Font.GothamBold
    title.TextSize=14
    title.TextColor3=Color3.fromRGB(240,242,248)
    title.TextXAlignment=Enum.TextXAlignment.Left

    local function row(y,label)
        local r=Instance.new("Frame",window)
        r.Size=UDim2.new(1,-24,0,42)
        r.Position=UDim2.new(0,12,0,y)
        r.BackgroundColor3=Color3.fromRGB(34,36,47)
        r.BorderSizePixel=0
        Instance.new("UICorner",r).CornerRadius=UDim.new(0,8)
        local t=Instance.new("TextLabel",r)
        t.Size=UDim2.new(1,-110,1,0)
        t.Position=UDim2.new(0,12,0,0)
        t.BackgroundTransparency=1
        t.Text=label
        t.Font=Enum.Font.GothamMedium
        t.TextSize=10.5
        t.TextColor3=Color3.fromRGB(220,223,232)
        t.TextXAlignment=Enum.TextXAlignment.Left
        return r
    end

    local hotkeyRow=row(48,"HOTKEY")
    local hotkey=Instance.new("TextButton",hotkeyRow)
    hotkey.Size=UDim2.new(0,92,0,28)
    hotkey.Position=UDim2.new(1,-104,.5,-14)
    hotkey.BackgroundColor3=Color3.fromRGB(48,51,63)
    hotkey.BorderSizePixel=0
    hotkey.AutoButtonColor=false
    hotkey.Text=(Config.ToggleKey and Config.ToggleKey.Name) or "LeftControl"
    hotkey.Font=Enum.Font.GothamBold
    hotkey.TextSize=9
    hotkey.TextColor3=Config.ThemeColor or Color3.fromRGB(0,229,255)
    Instance.new("UICorner",hotkey).CornerRadius=UDim.new(0,7)

    local rainbowRow=row(98,"RAINBOW")
    local rainbow=Instance.new("TextButton",rainbowRow)
    rainbow.Size=UDim2.new(0,92,0,28)
    rainbow.Position=UDim2.new(1,-104,.5,-14)
    rainbow.BackgroundColor3=Color3.fromRGB(48,51,63)
    rainbow.BorderSizePixel=0
    rainbow.AutoButtonColor=false
    rainbow.Text=Config.RainbowEnabled and "ON" or "OFF"
    rainbow.Font=Enum.Font.GothamBold
    rainbow.TextSize=9
    rainbow.TextColor3=Config.ThemeColor or Color3.fromRGB(0,229,255)
    Instance.new("UICorner",rainbow).CornerRadius=UDim.new(0,7)

    local hint=Instance.new("TextLabel",window)
    hint.Size=UDim2.new(1,-24,0,40)
    hint.Position=UDim2.new(0,12,1,-48)
    hint.BackgroundTransparency=1
    hint.Text="Click HOTKEY, then press any keyboard key.\nLeftControl is handled as Enum.KeyCode.LeftControl."
    hint.Font=Enum.Font.Code
    hint.TextSize=8.5
    hint.TextColor3=Color3.fromRGB(125,130,145)
    hint.TextWrapped=true
    hint.TextXAlignment=Enum.TextXAlignment.Left

    local listening=false
    local inputConnection

    local function setHotkey(keyCode)
        if typeof(keyCode)~="EnumItem" or keyCode.EnumType~=Enum.KeyCode then return end
        Config.ToggleKey=keyCode
        hotkey.Text=keyCode.Name
        ShowNotification("Hotkey set to "..keyCode.Name)
    end

    hotkey.Activated:Connect(function()
        if listening then return end
        listening=true
        hotkey.Text="PRESS KEY"
        hotkey.TextColor3=Color3.fromRGB(255,215,90)
    end)

    inputConnection=UserInputService.InputBegan:Connect(function(input,processed)
        if not listening then return end
        if input.UserInputType~=Enum.UserInputType.Keyboard then return end
        if input.KeyCode==Enum.KeyCode.Unknown then return end
        listening=false
        -- Explicit LeftControl support; do not use string matching or RightControl aliases.
        if input.KeyCode==Enum.KeyCode.LeftControl then
            setHotkey(Enum.KeyCode.LeftControl)
        else
            setHotkey(input.KeyCode)
        end
        hotkey.TextColor3=Config.ThemeColor or Color3.fromRGB(0,229,255)
    end)

    rainbow.Activated:Connect(function()
        Config.RainbowEnabled=not (Config.RainbowEnabled==true)
        rainbow.Text=Config.RainbowEnabled and "ON" or "OFF"
    end)

    local hue=0
    local alive=true
    task.spawn(function()
        while alive and window.Parent do
            hue=(hue+math.max(.001,(tonumber(Config.RainbowSpeedPercent) or 100)/100000))%1
            local c=Config.RainbowEnabled and Color3.fromHSV(hue,.82,1) or Config.ThemeColor or Color3.fromRGB(0,229,255)
            ws.Color=c
            hotkey.TextColor3=c
            rainbow.TextColor3=c
            for _,obj in ipairs(allHubStrokes) do
                if obj and obj.Parent then obj.Color=c end
            end
            for _,obj in ipairs(allHubLines) do
                if obj and obj.Parent then obj.BackgroundColor3=c end
            end
            for _,obj in ipairs(allThemeTexts) do
                if obj and obj.Parent and obj:IsA("TextLabel") then obj.TextColor3=c end
            end
            if Config.RainbowEnabled then
                rainbow.Text="ON"
            end
            task.wait(.03)
        end
    end)

    local function show()
        window.Visible=true
        window.Position=UDim2.new(.5,0,.5,18)
        TweenService:Create(window,TweenInfo.new(.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(.5,0,.5,0)}):Play()
    end

    local function hide()
        window.Visible=false
        listening=false
    end

    return {
        Toggle=function()
            if window.Visible then hide() else show() end
        end,
        Close=hide,
        IsListeningKey=function() return listening end,
        GetCurrentAccentColor=function()
            return Config.ThemeColor or Color3.fromRGB(0,229,255)
        end,
        Destroy=function()
            alive=false
            if inputConnection then inputConnection:Disconnect() end
            if window then window:Destroy() end
        end
    }
end

return CreateGear
