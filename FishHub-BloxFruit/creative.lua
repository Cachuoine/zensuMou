local ctx = ...
if type(ctx) ~= "table" then return end

local Tab = ctx.Tab
local Config = ctx.Config
local Players = ctx.Players
local TweenService = ctx.TweenService
local UserInputService = ctx.UserInputService
local ShowNotification = ctx.ShowNotification
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local THEME = (Config and Config.ThemeColor) or Color3.fromRGB(0, 229, 255)
local BG_CARD = Color3.fromRGB(28, 30, 42)
local TEXT_MAIN = Color3.fromRGB(240, 244, 252)
local TEXT_DIM = Color3.fromRGB(165, 172, 190)

local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.Parent = parent
    c.CornerRadius = UDim.new(0, radius or 10)
    return c
end

local function AddStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Parent = parent
    s.Color = color or THEME
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.3
    return s
end

local function MakeLabel(parent, props)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.Font = props.font or Enum.Font.GothamMedium
    lbl.TextSize = props.size or 12
    lbl.TextColor3 = props.color or TEXT_MAIN
    lbl.Text = props.text or ""
    lbl.TextXAlignment = props.alignX or Enum.TextXAlignment.Left
    lbl.TextYAlignment = props.alignY or Enum.TextYAlignment.Center
    lbl.Size = props.size_ or UDim2.new(1, 0, 0, 18)
    lbl.Position = props.pos or UDim2.new(0, 0, 0, 0)
    return lbl
end

local function AddPaddingScrollingFrame(sf, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.Parent = sf
    p.PaddingLeft = UDim.new(0, left or 14)
    p.PaddingRight = UDim.new(0, right or 14)
    p.PaddingTop = UDim.new(0, top or 14)
    p.PaddingBottom = UDim.new(0, bottom or 14)
    return p
end

local function MakeToggle(parent, title, default, callback)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = BG_CARD
    card.BorderSizePixel = 0
    AddCorner(card, 8)
    AddStroke(card, THEME, 1, 0.6)
    MakeLabel(card, {
        text = title, size = 12, color = TEXT_MAIN,
        size_ = UDim2.new(1, -64, 1, 0), pos = UDim2.new(0, 14, 0, 0)
    })
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = card
    toggleBg.Size = UDim2.new(0, 40, 0, 22)
    toggleBg.Position = UDim2.new(1, -52, 0.5, 0)
    toggleBg.AnchorPoint = Vector2.new(0, 0.5)
    toggleBg.BackgroundColor3 = default and THEME or Color3.fromRGB(50, 54, 70)
    toggleBg.BorderSizePixel = 0
    AddCorner(toggleBg, 999)
    local knob = Instance.new("Frame")
    knob.Parent = toggleBg
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    AddCorner(knob, 999)
    local state = default and true or false
    local function fire(anim)
        if anim then
            TweenService:Create(toggleBg, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundColor3 = state and THEME or Color3.fromRGB(50, 54, 70)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            }):Play()
        end
        if callback then callback(state) end
    end
    fire(false)
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.MouseButton1Click:Connect(function()
        state = not state
        fire(true)
    end)
    return card
end

local function MakeSlider(parent, title, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = BG_CARD
    card.BorderSizePixel = 0
    AddCorner(card, 8)
    AddStroke(card, THEME, 1, 0.6)
    MakeLabel(card, {
        text = title, size = 12, color = TEXT_MAIN,
        size_ = UDim2.new(1, -90, 0, 18), pos = UDim2.new(0, 14, 0, 6)
    })
    local valueLbl = MakeLabel(card, {
        text = tostring(default), size = 12, color = THEME, font = Enum.Font.Code,
        size_ = UDim2.new(0, 60, 0, 18), pos = UDim2.new(1, -74, 0, 6)
    })
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("Frame")
    track.Parent = card
    track.Size = UDim2.new(1, -28, 0, 6)
    track.Position = UDim2.new(0, 14, 0, 36)
    track.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
    track.BorderSizePixel = 0
    AddCorner(track, 999)
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = THEME
    fill.BorderSizePixel = 0
    AddCorner(fill, 999)
    local value = default
    local dragging = false
    local function updateFromX(x)
        local absX = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local ratio = absX / math.max(track.AbsoluteSize.X, 1)
        value = math.floor(min + (max - min) * ratio + 0.5)
        value = math.clamp(value, min, max)
        fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
        valueLbl.Text = tostring(value)
        if callback then callback(value) end
    end
    local btn = Instance.new("TextButton")
    btn.Parent = track
    btn.Size = UDim2.new(1, 0, 1, 20)
    btn.Position = UDim2.new(0, 0, 0, -10)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.MouseButton1Down:Connect(function() dragging = true end)
    btn.MouseButton1Up:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    if callback then callback(value) end
    return card
end

local function MakeActionButton(parent, title, subtitle, color, callback)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = BG_CARD
    card.BorderSizePixel = 0
    AddCorner(card, 10)
    local stroke = AddStroke(card, color or THEME, 1.2, 0.4)
    local accent = Instance.new("Frame")
    accent.Parent = card
    accent.Size = UDim2.new(0, 3, 1, -16)
    accent.Position = UDim2.new(0, 10, 0, 8)
    accent.BackgroundColor3 = color or THEME
    accent.BorderSizePixel = 0
    AddCorner(accent, 999)
    MakeLabel(card, {
        text = title, size = 13, color = TEXT_MAIN, font = Enum.Font.GothamBold,
        size_ = UDim2.new(1, -30, 0, 20), pos = UDim2.new(0, 22, 0, 10)
    })
    MakeLabel(card, {
        text = subtitle, size = 10, color = TEXT_DIM,
        size_ = UDim2.new(1, -30, 0, 16), pos = UDim2.new(0, 22, 0, 30)
    })
    local btn = Instance.new("TextButton")
    btn.Parent = card
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.05, Thickness = 1.6}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.4, Thickness = 1.2}):Play()
    end)
    if callback then btn.MouseButton1Click:Connect(callback) end
    return card
end

Tab.ScrollBarThickness = 4
Tab.ScrollBarImageColor3 = THEME
AddPaddingScrollingFrame(Tab, 14, 14, 14, 14)
local list = Instance.new("UIListLayout")
list.Parent = Tab
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local order = 0
local function nextOrder() order = order + 1 return order end

local function SectionHeader(parent, text, lo)
    local h = Instance.new("Frame")
    h.Parent = parent
    h.Size = UDim2.new(1, 0, 0, 22)
    h.BackgroundTransparency = 1
    h.LayoutOrder = lo or nextOrder()
    local lbl = MakeLabel(h, {
        text = text, size = 10, color = TEXT_DIM, font = Enum.Font.GothamBold,
        size_ = UDim2.new(1, 0, 1, 0), pos = UDim2.new(0, 4, 0, 0)
    })
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return h
end

SectionHeader(Tab, "👁 VISUAL", nextOrder())
MakeToggle(Tab, "Player ESP (Name + Distance)", false, function(state)
    if state then
        if _G.FishHubESP then return end
        _G.FishHubESP = true
        local highlights = {}
        local labels = {}
        local function addESP(plr)
            if plr == Player then return end
            if not plr.Character then return end
            local hl = Instance.new("Highlight")
            hl.Name = "FishHubESP_HL"
            hl.Adornee = plr.Character
            hl.FillTransparency = 0.7
            hl.OutlineTransparency = 0
            hl.FillColor = THEME
            hl.OutlineColor = THEME
            hl.Parent = plr.Character
            highlights[plr] = hl
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local bg = Instance.new("BillboardGui")
                bg.Name = "FishHubESP_BG"
                bg.Adornee = head
                bg.Size = UDim2.new(0, 140, 0, 36)
                bg.StudsOffset = Vector3.new(0, 2.2, 0)
                bg.AlwaysOnTop = true
                bg.Parent = head
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "Name"
                nameLbl.BackgroundTransparency = 1
                nameLbl.Size = UDim2.new(1, 0, 0, 18)
                nameLbl.Font = Enum.Font.GothamBold
                nameLbl.TextSize = 11
                nameLbl.TextColor3 = THEME
                nameLbl.TextStrokeTransparency = 0.5
                nameLbl.Text = plr.DisplayName
                nameLbl.Parent = bg
                local distLbl = Instance.new("TextLabel")
                distLbl.Name = "Dist"
                distLbl.BackgroundTransparency = 1
                distLbl.Size = UDim2.new(1, 0, 0, 16)
                distLbl.Position = UDim2.new(0, 0, 0, 18)
                distLbl.Font = Enum.Font.Code
                distLbl.TextSize = 10
                distLbl.TextColor3 = Color3.new(1, 1, 1)
                distLbl.TextStrokeTransparency = 0.5
                distLbl.Parent = bg
                labels[plr] = {bg = bg, dist = distLbl}
            end
        end
        local function removeESP(plr)
            if highlights[plr] then highlights[plr]:Destroy(); highlights[plr] = nil end
            if labels[plr] and labels[plr].bg then labels[plr].bg:Destroy(); labels[plr] = nil end
        end
        for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
        _G.FishHubESPConn1 = Players.PlayerAdded:Connect(addESP)
        _G.FishHubESPConn2 = Players.PlayerRemoving:Connect(removeESP)
        _G.FishHubESPLoop = RunService.RenderStepped:Connect(function()
            for plr, data in pairs(labels) do
                if plr.Character and Player.Character and plr.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("Head") then
                    local dist = (plr.Character.Head.Position - Player.Character.Head.Position).Magnitude
                    data.dist.Text = string.format("[%d studs]", math.floor(dist))
                end
            end
        end)
        _G.FishHubESPCleanup = function()
            for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
        end
    else
        _G.FishHubESP = false
        pcall(function() _G.FishHubESPConn1:Disconnect() end)
        pcall(function() _G.FishHubESPConn2:Disconnect() end)
        pcall(function() _G.FishHubESPLoop:Disconnect() end)
        if _G.FishHubESPCleanup then pcall(_G.FishHubESPCleanup) end
    end
end)
MakeToggle(Tab, "Fullbright", false, function(state)
    pcall(function()
        local lighting = game:GetService("Lighting")
        if state then
            lighting.Brightness = 2
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
        else
            lighting.Brightness = 1
            lighting.GlobalShadows = true
            lighting.FogEnd = 100000
        end
    end)
end)
MakeSlider(Tab, "FOV (Camera)", 30, 120, 70, function(value)
    pcall(function()
        if Player and Player:FindFirstChildOfClass("PlayerScripts") then
            Camera.FieldOfView = value
        end
    end)
end)

SectionHeader(Tab, "📷 CAMERA", nextOrder())
MakeToggle(Tab, "Free Cam (hold to fly)", false, function(state)
    if state then
        if not Player or not Player.Character then return end
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = 0 humanoid.JumpPower = 0 end
        _G.FishHubFreeCam = true
        task.spawn(function()
            local speed = 1.2
            while _G.FishHubFreeCam and Player and Player.Character do
                local move = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
                if move.Magnitude > 0 then
                    Camera.CFrame = Camera.CFrame + move.Unit * speed
                end
                task.wait()
            end
        end)
    else
        _G.FishHubFreeCam = false
        if Player and Player.Character then
            local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 humanoid.JumpPower = 50 end
        end
    end
end)
MakeActionButton(Tab, "Reset Camera", "Snap camera back to your character", Color3.fromRGB(180, 140, 255), function()
    pcall(function()
        if Player and Player.Character and Player.Character:FindFirstChild("Head") then
            Camera.CameraSubject = Player.Character:FindFirstChildOfClass("Humanoid")
            Camera.CameraType = Enum.CameraType.Custom
        end
    end)
end)

SectionHeader(Tab, "✨ AESTHETIC", nextOrder())
MakeActionButton(Tab, "Night Vision", "Brighter ambient for dark areas", Color3.fromRGB(120, 230, 200), function()
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.Technology = Enum.Technology.Future
        lighting.Brightness = 4
        lighting.Ambient = Color3.fromRGB(178, 178, 178)
        lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    end)
end)
MakeActionButton(Tab, "Reset Lighting", "Restore default lighting settings", Color3.fromRGB(255, 180, 100), function()
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.Technology = Enum.Technology.Compatibility
        lighting.Brightness = 1
        lighting.Ambient = Color3.fromRGB(0, 0, 0)
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        lighting.GlobalShadows = true
    end)
end)

Tab.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
end)
