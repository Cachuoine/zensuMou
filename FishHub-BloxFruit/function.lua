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
    lbl.RichText = props.rich or false
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

SectionHeader(Tab, "🏃 MOVEMENT", nextOrder())
MakeSlider(Tab, "WalkSpeed", 16, 250, 16)
MakeSlider(Tab, "JumpPower", 50, 300, 50)
MakeToggle(Tab, "Infinite Jump", false, function(state)
    if state then
        _G.FishHubInfiniteJump = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                if Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                    Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end)
    else
        if _G.FishHubInfiniteJump then
            _G.FishHubInfiniteJump:Disconnect()
            _G.FishHubInfiniteJump = nil
        end
    end
end)
MakeToggle(Tab, "Noclip", false, function(state)
    if state then
        _G.FishHubNoclip = true
        task.spawn(function()
            while _G.FishHubNoclip and Player and Player.Character do
                pcall(function()
                    for _, p in ipairs(Player.Character:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end)
                RunService.Stepped:Wait()
            end
        end)
    else
        _G.FishHubNoclip = false
    end
end)

SectionHeader(Tab, "⚔ COMBAT", nextOrder())
MakeToggle(Tab, "Auto-Clicker", false, function(state)
    if state then
        _G.FishHubAutoClick = true
        task.spawn(function()
            while _G.FishHubAutoClick do
                pcall(function()
                    mouse1click()
                end)
                task.wait(0.05)
            end
        end)
    else
        _G.FishHubAutoClick = false
    end
end)
MakeActionButton(Tab, "Reset Character", "Respawn your character immediately", Color3.fromRGB(255, 120, 120), function()
    pcall(function() Player:LoadCharacter() end)
end)

SectionHeader(Tab, "🧰 UTILITY", nextOrder())
MakeActionButton(Tab, "Server Hop", "Find a different server of the same game", Color3.fromRGB(140, 200, 255), function()
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local servers = HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/0?sortOrder=Asc&limit=100")
        )
        if servers and servers.data and #servers.data > 0 then
            local chosen
            for _, s in ipairs(servers.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    chosen = s
                    break
                end
            end
            if chosen then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen.id, Player)
            end
        end
    end)
end)
MakeActionButton(Tab, "Rejoin Current Server", "Teleport back into the same place", Color3.fromRGB(180, 140, 255), function()
    pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end)
end)
MakeToggle(Tab, "Anti-AFK", false, function(state)
    if state then
        _G.FishHubAntiAfk = true
        task.spawn(function()
            local VirtualUser = game:GetService("VirtualUser")
            while _G.FishHubAntiAfk do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                task.wait(60)
            end
        end)
    else
        _G.FishHubAntiAfk = false
    end
end)

Tab.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
end)
