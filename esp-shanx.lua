-- ============================================
-- SHANX LUA v5 | UNIVERSAL ESP
-- "See Everything, Touch Nothing"
-- Login: shanx / shanx | User: bronisseske
-- Tab: Visual, Player, Configure, Settings
-- ESP Custom Name | HP Text | Anti-Kick | Safe Mode
-- ============================================

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ===== DRAWING API =====
local hasDrawing = pcall(function() return Drawing.new("Line") end)
if not hasDrawing then warn("[ShanX] Drawing API tidak tersedia.") return end

-- ===== ANTI-KICK =====
local antiKickActive = false
local function enableAntiKick()
    if antiKickActive then return true end
    local ok = pcall(function()
        if hookmetamethod and getrawmetatable and newcclosure and checkcaller then
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" and not checkcaller() then return nil end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
            antiKickActive = true
            return true
        end
        return false
    end)
    return ok and antiKickActive
end

-- ===== LOGIN CONFIG =====
local LOGIN = {
    Username = "shanx",
    Password = "shanx",
    RobloxUser = "bronisseske",
}

-- ===== WARNA =====
local COLOR_BLUE = Color3.fromRGB(80, 140, 220)
local COLOR_BLUE_DIM = Color3.fromRGB(50, 90, 150)
local COLOR_BLUE_GLOW = Color3.fromRGB(120, 170, 240)
local COLOR_DARK = Color3.fromRGB(15, 18, 26)
local COLOR_DARK_LIGHT = Color3.fromRGB(22, 26, 38)
local COLOR_DARK_MID = Color3.fromRGB(35, 42, 58)
local COLOR_TEXT = Color3.fromRGB(240, 245, 255)
local COLOR_TEXT_DIM = Color3.fromRGB(140, 155, 180)
local COLOR_SUCCESS = Color3.fromRGB(80, 200, 130)
local COLOR_DANGER = Color3.fromRGB(220, 80, 90)

-- ===== CONFIG =====
local Config = {
    -- ESP
    Enabled = false,
    Box = false,
    Name = false,
    Distance = false,
    HealthBar = false,
    Skeleton = false,
    Tracer = false,
    Chams = false,
    Count = false,
    HPText = false,
    TeamCheck = true,
    
    -- Custom Name
    CustomNames = {},
    
    -- Visual
    Fullbright = false,
    NoFog = false,
    Crosshair = false,
    Watermark = false,
    FOV = 70,
    
    -- Player
    SpeedEnabled = false,
    SpeedAmount = 16,
    JumpEnabled = false,
    JumpAmount = 50,
    InfinityJump = false,
    FlyEnabled = false,
    FlySpeed = 50,
    Noclip = false,
    Invisible = false,
    
    -- Configure
    AutoRejoin = false,
    ServerHop = false,
    AntiAFK = false,
    
    -- Settings
    ESPColor = Color3.fromRGB(30, 60, 120),
    MaxDistance = 1000,
    LoopDelay = 0.1,
}

-- ===== BONE CONNECTIONS =====
local R15_BONES = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}
local R6_BONES = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}

local function getBoneConnections(char)
    if char:FindFirstChild("UpperTorso") then return R15_BONES
    elseif char:FindFirstChild("Torso") then return R6_BONES end
    return R15_BONES
end

-- ===== HELPER =====
local function newDraw(type, props)
    local ok, obj = pcall(function() return Drawing.new(type) end)
    if not ok or not obj then return nil end
    for k, v in pairs(props) do pcall(function() obj[k] = v end) end
    return obj
end

local function isTeammate(player)
    if not Config.TeamCheck then return false end
    if not LocalPlayer.Team or not player.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function getCustomName(username)
    if Config.CustomNames[username] then
        return Config.CustomNames[username]
    end
    return username
end

-- ============================================
-- LOGIN PAGE
-- ============================================
local loginGui = Instance.new("ScreenGui")
loginGui.Name = "ShanX_Login"
loginGui.ResetOnSpawn = false
loginGui.IgnoreGuiInset = true
loginGui.Parent = PlayerGui

local loginPanel = Instance.new("Frame")
loginPanel.Size = UDim2.new(0, 340, 0, 330)
loginPanel.Position = UDim2.new(0.5, -170, 0.5, -165)
loginPanel.BackgroundColor3 = COLOR_DARK
loginPanel.BackgroundTransparency = 0.05
loginPanel.BorderSizePixel = 0
loginPanel.Parent = loginGui

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 16)
loginCorner.Parent = loginPanel

local loginStroke = Instance.new("UIStroke")
loginStroke.Color = COLOR_BLUE_DIM
loginStroke.Thickness = 1
loginStroke.Transparency = 0.3
loginStroke.Parent = loginPanel

local loginHeader = Instance.new("Frame")
loginHeader.Size = UDim2.new(1, 0, 0, 70)
loginHeader.BackgroundColor3 = COLOR_DARK_LIGHT
loginHeader.BackgroundTransparency = 0.2
loginHeader.BorderSizePixel = 0
loginHeader.Parent = loginPanel

local lhCorner = Instance.new("UICorner")
lhCorner.CornerRadius = UDim.new(0, 16)
lhCorner.Parent = loginHeader

local lhFix = Instance.new("Frame")
lhFix.Size = UDim2.new(1, 0, 0, 16)
lhFix.Position = UDim2.new(0, 0, 1, -16)
lhFix.BackgroundColor3 = COLOR_DARK_LIGHT
lhFix.BackgroundTransparency = 0.2
lhFix.BorderSizePixel = 0
lhFix.Parent = loginHeader

local logoCircle = Instance.new("Frame")
logoCircle.Size = UDim2.new(0, 40, 0, 40)
logoCircle.Position = UDim2.new(0.5, -20, 0, 8)
logoCircle.BackgroundColor3 = COLOR_BLUE
logoCircle.BackgroundTransparency = 0.3
logoCircle.BorderSizePixel = 0
logoCircle.Parent = loginHeader

local lcCorner = Instance.new("UICorner")
lcCorner.CornerRadius = UDim.new(1, 0)
lcCorner.Parent = logoCircle

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "SX"
logoText.TextColor3 = COLOR_TEXT
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 16
logoText.Parent = logoCircle

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 18)
loginTitle.Position = UDim2.new(0, 0, 0, 48)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "SHANX LUA v5"
loginTitle.TextColor3 = COLOR_TEXT
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 12
loginTitle.Parent = loginHeader

-- Username
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, -40, 0, 14)
userLabel.Position = UDim2.new(0, 20, 0, 90)
userLabel.BackgroundTransparency = 1
userLabel.Text = "USERNAME"
userLabel.TextColor3 = COLOR_TEXT_DIM
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 9
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.Parent = loginPanel

local userInput = Instance.new("TextBox")
userInput.Size = UDim2.new(1, -40, 0, 40)
userInput.Position = UDim2.new(0, 20, 0, 108)
userInput.BackgroundColor3 = COLOR_DARK_LIGHT
userInput.BackgroundTransparency = 0.3
userInput.Text = ""
userInput.PlaceholderText = "Masukkan username..."
userInput.TextColor3 = COLOR_TEXT
userInput.PlaceholderColor3 = COLOR_TEXT_DIM
userInput.Font = Enum.Font.Gotham
userInput.TextSize = 13
userInput.BorderSizePixel = 0
userInput.ClearTextOnFocus = false
userInput.Parent = loginPanel

local userCorner = Instance.new("UICorner")
userCorner.CornerRadius = UDim.new(0, 10)
userCorner.Parent = userInput

local userStroke = Instance.new("UIStroke")
userStroke.Color = COLOR_DARK_MID
userStroke.Thickness = 1
userStroke.Transparency = 0.3
userStroke.Parent = userInput

-- Password
local passLabel = Instance.new("TextLabel")
passLabel.Size = UDim2.new(1, -40, 0, 14)
passLabel.Position = UDim2.new(0, 20, 0, 160)
passLabel.BackgroundTransparency = 1
passLabel.Text = "PASSWORD"
passLabel.TextColor3 = COLOR_TEXT_DIM
passLabel.Font = Enum.Font.GothamBold
passLabel.TextSize = 9
passLabel.TextXAlignment = Enum.TextXAlignment.Left
passLabel.Parent = loginPanel

local passInput = Instance.new("TextBox")
passInput.Size = UDim2.new(1, -40, 0, 40)
passInput.Position = UDim2.new(0, 20, 0, 178)
passInput.BackgroundColor3 = COLOR_DARK_LIGHT
passInput.BackgroundTransparency = 0.3
passInput.Text = ""
passInput.PlaceholderText = "Masukkan password..."
passInput.TextColor3 = COLOR_TEXT
passInput.PlaceholderColor3 = COLOR_TEXT_DIM
passInput.Font = Enum.Font.Gotham
passInput.TextSize = 13
passInput.BorderSizePixel = 0
passInput.ClearTextOnFocus = false
passInput.Parent = loginPanel

local passCorner = Instance.new("UICorner")
passCorner.CornerRadius = UDim.new(0, 10)
passCorner.Parent = passInput

local passStroke = Instance.new("UIStroke")
passStroke.Color = COLOR_DARK_MID
passStroke.Thickness = 1
passStroke.Transparency = 0.3
passStroke.Parent = passInput

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 18)
statusLabel.Position = UDim2.new(0, 20, 0, 228)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = COLOR_DANGER
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 10
statusLabel.Parent = loginPanel

local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -40, 0, 44)
loginBtn.Position = UDim2.new(0, 20, 0, 252)
loginBtn.BackgroundColor3 = COLOR_BLUE
loginBtn.Text = "LOGIN"
loginBtn.TextColor3 = COLOR_TEXT
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 13
loginBtn.BorderSizePixel = 0
loginBtn.AutoButtonColor = false
loginBtn.Parent = loginPanel

local lbCorner = Instance.new("UICorner")
lbCorner.CornerRadius = UDim.new(0, 10)
lbCorner.Parent = loginBtn

loginBtn.MouseEnter:Connect(function()
    TweenService:Create(loginBtn, TweenInfo.new(0.2), { BackgroundColor3 = COLOR_BLUE_GLOW }):Play()
end)
loginBtn.MouseLeave:Connect(function()
    TweenService:Create(loginBtn, TweenInfo.new(0.2), { BackgroundColor3 = COLOR_BLUE }):Play()
end)

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0, 16)
footerLabel.Position = UDim2.new(0, 0, 1, -20)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "ShanX Lua v5 © 2026"
footerLabel.TextColor3 = COLOR_TEXT_DIM
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextSize = 9
footerLabel.TextTransparency = 0.5
footerLabel.Parent = loginPanel

-- ============================================
-- LOGIN LOGIC
-- ============================================
local function onLoginSuccess()
    enableAntiKick()
    local tw = TweenService:Create(loginPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
    })
    tw:Play()
    tw.Completed:Connect(function()
        loginGui:Destroy()
        task.wait(0.3)
        if _G.ShanX_StartESP then _G.ShanX_StartESP() end
    end)
end

loginBtn.MouseButton1Click:Connect(function()
    local user = userInput.Text
    local pass = passInput.Text
    
    if LocalPlayer.Name ~= LOGIN.RobloxUser then
        statusLabel.Text = "Username Roblox Kamu Tidak Terdaftar"
        statusLabel.TextColor3 = COLOR_DANGER
        return
    end
    
    if user == LOGIN.Username and pass == LOGIN.Password then
        statusLabel.Text = "Login berhasil! Loading..."
        statusLabel.TextColor3 = COLOR_SUCCESS
        task.wait(0.5)
        onLoginSuccess()
    else
        statusLabel.Text = "Username atau password salah!"
        statusLabel.TextColor3 = COLOR_DANGER
    end
end)

userInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then passInput:CaptureFocus() end
end)
passInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then loginBtn.MouseButton1Click:Fire() end
end)

-- ============================================
-- ESP SYSTEM
-- ============================================
_G.ShanX_StartESP = function()
    local ESPData = {}
    
    local function createESP(player)
        if player == LocalPlayer or ESPData[player] then return end
        local data = {
            box = {}, skeleton = {}, tracer = nil,
            hpBG = nil, hpFill = nil,
            nameText = nil, distText = nil,
            hpText = nil,
            chams = nil, character = nil,
        }
        for i = 1, 4 do table.insert(data.box, newDraw("Line", {Visible=false, Thickness=1, Color=Config.ESPColor, Transparency=1})) end
        for i = 1, 14 do table.insert(data.skeleton, newDraw("Line", {Visible=false, Thickness=1, Color=Config.ESPColor, Transparency=1})) end
        data.tracer = newDraw("Line", {Visible=false, Thickness=1, Color=Config.ESPColor, Transparency=1})
        data.hpBG = newDraw("Line", {Visible=false, Thickness=3, Color=COLOR_DARK, Transparency=1})
        data.hpFill = newDraw("Line", {Visible=false, Thickness=3, Color=COLOR_SUCCESS, Transparency=1})
        data.nameText = newDraw("Text", {Visible=false, Size=14, Center=true, Outline=true, Color=COLOR_TEXT})
        data.distText = newDraw("Text", {Visible=false, Size=12, Center=true, Outline=true, Color=Config.ESPColor})
        data.hpText = newDraw("Text", {Visible=false, Size=12, Center=true, Outline=true, Color=COLOR_SUCCESS})
        
        ESPData[player] = data
        
        if player.Character then data.character = player.Character end
        player.CharacterAdded:Connect(function(c)
            local ok = pcall(function() c:WaitForChild("Humanoid", 5) end)
            if ok then task.wait(0.2) data.character = c end
        end)
    end
    
    local function removeESP(player)
        local d = ESPData[player]
        if not d then return end
        for _, l in pairs(d.box) do pcall(function() l:Remove() end) end
        for _, l in pairs(d.skeleton) do pcall(function() l:Remove() end) end
        if d.tracer then pcall(function() d.tracer:Remove() end) end
        if d.hpBG then pcall(function() d.hpBG:Remove() end) end
        if d.hpFill then pcall(function() d.hpFill:Remove() end) end
        if d.nameText then pcall(function() d.nameText:Remove() end) end
        if d.distText then pcall(function() d.distText:Remove() end) end
        if d.hpText then pcall(function() d.hpText:Remove() end) end
        if d.chams then pcall(function() d.chams:Destroy() end) end
        ESPData[player] = nil
    end
    
    local function hideAll(d)
        for _, l in pairs(d.box) do if l then l.Visible = false end end
        for _, l in pairs(d.skeleton) do if l then l.Visible = false end end
        if d.tracer then d.tracer.Visible = false end
        if d.hpBG then d.hpBG.Visible = false end
        if d.hpFill then d.hpFill.Visible = false end
        if d.nameText then d.nameText.Visible = false end
        if d.distText then d.distText.Visible = false end
        if d.hpText then d.hpText.Visible = false end
    end
    
    for _, p in pairs(Players:GetPlayers()) do createESP(p) end
    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)
    
    -- ===== COUNT LABEL =====
    local countGui = Instance.new("ScreenGui")
    countGui.Name = "ShanXCount"
    countGui.ResetOnSpawn = false
    countGui.Parent = PlayerGui
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0, 220, 0, 28)
    countLabel.Position = UDim2.new(0.5, -110, 0, 10)
    countLabel.BackgroundColor3 = COLOR_DARK
    countLabel.BackgroundTransparency = 0.3
    countLabel.TextColor3 = COLOR_BLUE
    countLabel.Font = Enum.Font.Code
    countLabel.TextSize = 14
    countLabel.Text = "Enemies: 0"
    countLabel.Visible = false
    countLabel.Parent = countGui
    
    local ccCorner = Instance.new("UICorner")
    ccCorner.CornerRadius = UDim.new(0, 6)
    ccCorner.Parent = countLabel
    
    -- ===== WATERMARK =====
    local watermarkGui = Instance.new("ScreenGui")
    watermarkGui.Name = "ShanXWatermark"
    watermarkGui.ResetOnSpawn = false
    watermarkGui.Parent = PlayerGui
    
    local watermark = Instance.new("TextLabel")
    watermark.Size = UDim2.new(0, 200, 0, 24)
    watermark.Position = UDim2.new(0, 10, 1, -34)
    watermark.BackgroundColor3 = COLOR_DARK
    watermark.BackgroundTransparency = 0.4
    watermark.TextColor3 = COLOR_BLUE
    watermark.Font = Enum.Font.GothamBold
    watermark.TextSize = 11
    watermark.Text = "ShanX Lua v5 | User: " .. LocalPlayer.Name
    watermark.Visible = false
    watermark.Parent = watermarkGui
    
    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 6)
    wmCorner.Parent = watermark
    
    -- ===== CROSSHAIR =====
    local crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "ShanXCrosshair"
    crosshairGui.ResetOnSpawn = false
    crosshairGui.Parent = PlayerGui
    
    local chLine1 = Instance.new("Frame")
    chLine1.Size = UDim2.new(0, 20, 0, 2)
    chLine1.Position = UDim2.new(0.5, -10, 0.5, -1)
    chLine1.BackgroundColor3 = COLOR_BLUE
    chLine1.BorderSizePixel = 0
    chLine1.Visible = false
    chLine1.Parent = crosshairGui
    
    local chLine2 = Instance.new("Frame")
    chLine2.Size = UDim2.new(0, 2, 0, 20)
    chLine2.Position = UDim2.new(0.5, -1, 0.5, -10)
    chLine2.BackgroundColor3 = COLOR_BLUE
    chLine2.BorderSizePixel = 0
    chLine2.Visible = false
    chLine2.Parent = crosshairGui
    
    -- ===== ESP LOOP =====
    local nearbyEnemyCount = 0
    
    task.spawn(function()
        while task.wait(Config.LoopDelay) do
            if not Config.Enabled then
                for _, d in pairs(ESPData) do hideAll(d) end
                if countLabel then countLabel.Visible = false end
                nearbyEnemyCount = 0
                continue
            end
            
            nearbyEnemyCount = 0
            
            for player, data in pairs(ESPData) do
                local char = data.character or player.Character
                if not char or not char.Parent or isTeammate(player) then
                    hideAll(data)
                    if data.chams then data.chams.Enabled = false end
                    continue
                end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local head = char:FindFirstChild("Head")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not humanoid or not head or not hrp or humanoid.Health <= 0 then
                    hideAll(data)
                    if data.chams then data.chams.Enabled = false end
                    continue
                end
                
                -- Chams
                if Config.Chams then
                    if not data.chams or not data.chams.Parent then
                        local h = Instance.new("Highlight")
                        h.Name = "ShanXChams"
                        h.Adornee = char
                        h.FillColor = Config.ESPColor
                        h.FillTransparency = 0.6
                        h.OutlineColor = Config.ESPColor
                        h.OutlineTransparency = 0
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = char
                        data.chams = h
                    else
                        data.chams.Enabled = true
                        data.chams.Adornee = char
                        data.chams.FillColor = Config.ESPColor
                        data.chams.OutlineColor = Config.ESPColor
                    end
                else
                    if data.chams then data.chams.Enabled = false end
                end
                
                local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
                if dist > Config.MaxDistance then hideAll(data) continue end
                if dist < 300 then nearbyEnemyCount = nearbyEnemyCount + 1 end
                
                local topWorld = head.Position + Vector3.new(0, 0.5, 0)
                local botWorld = hrp.Position + Vector3.new(0, -3, 0)
                local headScreen, headOn = Camera:WorldToViewportPoint(topWorld)
                local botScreen, botOn = Camera:WorldToViewportPoint(botWorld)
                if not (headOn and botOn) then hideAll(data) continue end
                
                local boxTop = headScreen.Y
                local boxBot = botScreen.Y
                local boxH = boxBot - boxTop
                local boxW = boxH * 0.55
                local boxCX = headScreen.X
                local boxL = boxCX - boxW/2
                local boxR = boxCX + boxW/2
                
                -- Box
                if Config.Box then
                    data.box[1].From = Vector2.new(boxL, boxTop); data.box[1].To = Vector2.new(boxR, boxTop); data.box[1].Visible = true; data.box[1].Color = Config.ESPColor
                    data.box[2].From = Vector2.new(boxL, boxBot); data.box[2].To = Vector2.new(boxR, boxBot); data.box[2].Visible = true; data.box[2].Color = Config.ESPColor
                    data.box[3].From = Vector2.new(boxL, boxTop); data.box[3].To = Vector2.new(boxL, boxBot); data.box[3].Visible = true; data.box[3].Color = Config.ESPColor
                    data.box[4].From = Vector2.new(boxR, boxTop); data.box[4].To = Vector2.new(boxR, boxBot); data.box[4].Visible = true; data.box[4].Color = Config.ESPColor
                else
                    for _, l in pairs(data.box) do l.Visible = false end
                end
                
                -- Health Bar
                if Config.HealthBar then
                    local hpPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local barX = boxL - 6
                    data.hpBG.From = Vector2.new(barX, boxTop); data.hpBG.To = Vector2.new(barX, boxBot); data.hpBG.Visible = true
                    local fillTop = boxBot - ((boxBot - boxTop) * hpPct)
                    data.hpFill.From = Vector2.new(barX, fillTop); data.hpFill.To = Vector2.new(barX, boxBot); data.hpFill.Visible = true
                    if hpPct > 0.5 then data.hpFill.Color = COLOR_SUCCESS
                    elseif hpPct > 0.25 then data.hpFill.Color = Color3.fromRGB(200, 170, 60)
                    else data.hpFill.Color = COLOR_DANGER end
                else
                    data.hpBG.Visible = false; data.hpFill.Visible = false
                end
                
                -- Name (CUSTOM NAME)
                if Config.Name then
                    data.nameText.Text = getCustomName(player.Name)
                    data.nameText.Position = Vector2.new(boxCX, boxTop - 16)
                    data.nameText.Visible = true
                else data.nameText.Visible = false end
                
                -- Distance
                if Config.Distance then
                    data.distText.Text = string.format("[%d]", dist)
                    data.distText.Position = Vector2.new(boxCX, boxBot + 6)
                    data.distText.Color = Config.ESPColor
                    data.distText.Visible = true
                else data.distText.Visible = false end
                
                -- Tracer
                if Config.Tracer then
                    data.tracer.From = Vector2.new(Camera.ViewportSize.X/2, 0)
                    data.tracer.To = Vector2.new(headScreen.X, headScreen.Y)
                    data.tracer.Color = Config.ESPColor
                    data.tracer.Visible = true
                else data.tracer.Visible = false end
                
                -- Skeleton
                if Config.Skeleton then
                    local bones = getBoneConnections(char)
                    for i, conn in ipairs(bones) do
                        if data.skeleton[i] then
                            local pA = char:FindFirstChild(conn[1])
                            local pB = char:FindFirstChild(conn[2])
                            if pA and pB then
                                local sA, onA = Camera:WorldToViewportPoint(pA.Position)
                                local sB, onB = Camera:WorldToViewportPoint(pB.Position)
                                if onA and onB then
                                    data.skeleton[i].From = Vector2.new(sA.X, sA.Y)
                                    data.skeleton[i].To = Vector2.new(sB.X, sB.Y)
                                    data.skeleton[i].Visible = true
                                    data.skeleton[i].Color = Config.ESPColor
                                else data.skeleton[i].Visible = false end
                            else data.skeleton[i].Visible = false end
                        end
                    end
                    for i = #bones + 1, 14 do
                        if data.skeleton[i] then data.skeleton[i].Visible = false end
                    end
                else
                    for _, l in pairs(data.skeleton) do l.Visible = false end
                end
                
                -- HP Text
                if Config.HPText then
                    data.hpText.Text = math.floor(humanoid.Health) .. " HP"
                    data.hpText.Position = Vector2.new(boxCX, boxTop - 30)
                    data.hpText.Visible = true
                else data.hpText.Visible = false end
            end
            
            if countLabel then
                countLabel.Visible = Config.Count
                countLabel.Text = "Enemies: " .. nearbyEnemyCount
                countLabel.TextColor3 = nearbyEnemyCount > 0 and COLOR_DANGER or COLOR_BLUE
            end
        end
    end)
    
    -- ===== VISUAL LOOPS =====
    task.spawn(function()
        local Lighting = game:GetService("Lighting")
        local origBrightness = Lighting.Brightness
        local origAmbient = Lighting.Ambient
        local origOutdoor = Lighting.OutdoorAmbient
        local origFogEnd = Lighting.FogEnd
        local origFogStart = Lighting.FogStart
        
        while task.wait(0.5) do
            if Config.Fullbright then
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(178, 178, 178)
                Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
            else
                Lighting.Brightness = origBrightness
                Lighting.Ambient = origAmbient
                Lighting.OutdoorAmbient = origOutdoor
            end
            
            if Config.NoFog then
                Lighting.FogEnd = 100000
                Lighting.FogStart = 100000
            else
                Lighting.FogEnd = origFogEnd
                Lighting.FogStart = origFogStart
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(0.2) do
            chLine1.Visible = Config.Crosshair
            chLine2.Visible = Config.Crosshair
            watermark.Visible = Config.Watermark
            Camera.FieldOfView = Config.FOV
        end
    end)
    
    -- ===== PLAYER FEATURES =====
    task.spawn(function()
        while task.wait(0.2) do
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if Config.SpeedEnabled then hum.WalkSpeed = Config.SpeedAmount end
                    if Config.JumpEnabled then hum.JumpPower = Config.JumpAmount end
                end
            end
        end
    end)
    
    UserInputService.JumpRequest:Connect(function()
        if Config.InfinityJump then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(0.2) do
            if Config.Noclip then
                local char = LocalPlayer.Character
                if char then
                    for _, p in pairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(0.2) do
            if Config.Invisible then
                local char = LocalPlayer.Character
                if char then
                    for _, p in pairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.LocalTransparencyModifier = 1
                            p.Transparency = 1
                        end
                    end
                end
            end
        end
    end)
    
    local flyBV = nil
    local flyBG = nil
    task.spawn(function()
        while task.wait(0.1) do
            if Config.FlyEnabled then
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if not flyBV then
                            flyBV = Instance.new("BodyVelocity")
                            flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                            flyBV.Velocity = Vector3.new(0, 0, 0)
                            flyBV.Parent = hrp
                        end
                        if not flyBG then
                            flyBG = Instance.new("BodyGyro")
                            flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                            flyBG.P = 1000
                            flyBG.Parent = hrp
                        end
                        local moveDir = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                        flyBV.Velocity = moveDir * Config.FlySpeed
                        flyBG.CFrame = Camera.CFrame
                    end
                end
            else
                if flyBV then flyBV:Destroy() flyBV = nil end
                if flyBG then flyBG:Destroy() flyBG = nil end
            end
        end
    end)
    
    -- ===== CONFIGURE FEATURES =====
    task.spawn(function()
        while task.wait(60) do
            if Config.AntiAFK then
                pcall(function()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
                end)
            end
        end
    end)
    
    LocalPlayer.OnTeleport:Connect(function()
        if Config.AutoRejoin then
            pcall(function()
                local TeleportService = game:GetService("TeleportService")
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end
    end)
    
    task.spawn(function()
        while task.wait(5) do
            if Config.ServerHop then
                Config.ServerHop = false
                pcall(function()
                    local TeleportService = game:GetService("TeleportService")
                    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                    local response = HttpService:JSONDecode(game:HttpGet(url))
                    if response and response.data then
                        for _, server in ipairs(response.data) do
                            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                                break
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    -- ============================================
    -- RAYFIELD LOADER
    -- ============================================
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
        Name = "ShanX Lua v5",
        LoadingTitle = "ShanX Lua",
        LoadingSubtitle = "ESP Custom Name | Safe Mode",
        Theme = "DarkBlue",
        ToggleUIKeybind = "Z",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "ShanX",
            FileName = "ShanXConfigV5",
        },
        Discord = { Enabled = false },
        KeySystem = false,
    })
    
    -- ===== TAB VISUAL =====
    local VisualTab = Window:CreateTab("Visual", 4483362458)
    
    VisualTab:CreateSection("ESP Elements")
    
    VisualTab:CreateToggle({Name = "Enable ESP", CurrentValue = Config.Enabled, Flag = "Enabled", Callback = function(v) Config.Enabled = v end})
    VisualTab:CreateToggle({Name = "Box ESP", CurrentValue = Config.Box, Flag = "Box", Callback = function(v) Config.Box = v end})
    VisualTab:CreateToggle({Name = "Name ESP", CurrentValue = Config.Name, Flag = "Name", Callback = function(v) Config.Name = v end})
    VisualTab:CreateToggle({Name = "Distance", CurrentValue = Config.Distance, Flag = "Distance", Callback = function(v) Config.Distance = v end})
    VisualTab:CreateToggle({Name = "Health Bar", CurrentValue = Config.HealthBar, Flag = "HealthBar", Callback = function(v) Config.HealthBar = v end})
    VisualTab:CreateToggle({Name = "Skeleton", CurrentValue = Config.Skeleton, Flag = "Skeleton", Callback = function(v) Config.Skeleton = v end})
    VisualTab:CreateToggle({Name = "Tracer", CurrentValue = Config.Tracer, Flag = "Tracer", Callback = function(v) Config.Tracer = v end})
    VisualTab:CreateToggle({Name = "Chams", CurrentValue = Config.Chams, Flag = "Chams", Callback = function(v) Config.Chams = v end})
    VisualTab:CreateToggle({Name = "Count", CurrentValue = Config.Count, Flag = "Count", Callback = function(v) Config.Count = v end})
    VisualTab:CreateToggle({Name = "HP Text", CurrentValue = Config.HPText, Flag = "HPText", Callback = function(v) Config.HPText = v end})
    VisualTab:CreateToggle({Name = "TeamCheck", CurrentValue = Config.TeamCheck, Flag = "TeamCheck", Callback = function(v) Config.TeamCheck = v end})
    
    VisualTab:CreateSection("ESP Custom Name")
    
    local customNameInput = VisualTab:CreateInput({
        Name = "Add Custom Name",
        PlaceholderText = "username=customname",
        RemoveTextAfterFocusLost = true,
        Callback = function(text)
            if text and text ~= "" then
                local username, customName = text:match("^([^=]+)=(.+)$")
                if username and customName then
                    username = username:gsub("%s+", "")
                    customName = customName:gsub("^%s+", ""):gsub("%s+$", "")
                    Config.CustomNames[username] = customName
                    Rayfield:Notify({
                        Title = "Custom Name Added",
                        Content = username .. " → " .. customName,
                        Duration = 3,
                    })
                else
                    Rayfield:Notify({
                        Title = "Format Salah",
                        Content = "Gunakan: username=customname",
                        Duration = 3,
                    })
                end
            end
        end,
    })
    
    local clearBtn = VisualTab:CreateButton({
        Name = "Clear All Custom Names",
        Callback = function()
            Config.CustomNames = {}
            Rayfield:Notify({Title = "Cleared", Content = "Semua custom name dihapus", Duration = 2})
        end,
    })
    
    -- List custom names
    local nameList = VisualTab:CreateLabel("Custom Names: (kosong)")
    
    -- Update list setiap 2 detik
    task.spawn(function()
        while task.wait(2) do
            local list = ""
            local count = 0
            for username, customName in pairs(Config.CustomNames) do
                list = list .. username .. " → " .. customName .. "\n"
                count = count + 1
                if count >= 5 then
                    list = list .. "... (+" .. (count - 5) .. " more)"
                    break
                end
            end
            if list == "" then list = "Custom Names: (kosong)" end
            pcall(function() nameList:Set(list) end)
        end
    end)
    
    VisualTab:CreateSection("Visual Effects")
    
    VisualTab:CreateToggle({Name = "Fullbright", CurrentValue = Config.Fullbright, Flag = "Fullbright", Callback = function(v) Config.Fullbright = v end})
    VisualTab:CreateToggle({Name = "No Fog", CurrentValue = Config.NoFog, Flag = "NoFog", Callback = function(v) Config.NoFog = v end})
    VisualTab:CreateToggle({Name = "Crosshair", CurrentValue = Config.Crosshair, Flag = "Crosshair", Callback = function(v) Config.Crosshair = v end})
    VisualTab:CreateToggle({Name = "Watermark", CurrentValue = Config.Watermark, Flag = "Watermark", Callback = function(v) Config.Watermark = v end})
    
    -- ===== TAB PLAYER =====
    local PlayerTab = Window:CreateTab("Player", 4483362458)
    
    PlayerTab:CreateSection("Movement")
    
    PlayerTab:CreateToggle({Name = "Enable Speed", CurrentValue = Config.SpeedEnabled, Flag = "SpeedEnabled", Callback = function(v) Config.SpeedEnabled = v end})
    PlayerTab:CreateSlider({Name = "Speed Amount", Range = {16, 50}, Increment = 1, Suffix = "studs", CurrentValue = Config.SpeedAmount, Flag = "SpeedAmount", Callback = function(v) Config.SpeedAmount = v end})
    PlayerTab:CreateToggle({Name = "Enable Jump", CurrentValue = Config.JumpEnabled, Flag = "JumpEnabled", Callback = function(v) Config.JumpEnabled = v end})
    PlayerTab:CreateSlider({Name = "Jump Amount", Range = {50, 150}, Increment = 5, Suffix = "power", CurrentValue = Config.JumpAmount, Flag = "JumpAmount", Callback = function(v) Config.JumpAmount = v end})
    PlayerTab:CreateToggle({Name = "Infinity Jump", CurrentValue = Config.InfinityJump, Flag = "InfinityJump", Callback = function(v) Config.InfinityJump = v end})
    
    PlayerTab:CreateSection("Fly")
    
    PlayerTab:CreateToggle({Name = "Fly", CurrentValue = Config.FlyEnabled, Flag = "FlyEnabled", Callback = function(v) Config.FlyEnabled = v end})
    PlayerTab:CreateSlider({Name = "Fly Speed", Range = {10, 100}, Increment = 5, Suffix = "studs", CurrentValue = Config.FlySpeed, Flag = "FlySpeed", Callback = function(v) Config.FlySpeed = v end})
    
    PlayerTab:CreateSection("Misc")
    
    PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = Config.Noclip, Flag = "Noclip", Callback = function(v) Config.Noclip = v end})
    PlayerTab:CreateToggle({Name = "Invisible", CurrentValue = Config.Invisible, Flag = "Invisible", Callback = function(v) Config.Invisible = v end})
    
    -- ===== TAB CONFIGURE =====
    local ConfigureTab = Window:CreateTab("Configure", 4483362458)
    
    ConfigureTab:CreateSection("Server")
    
    ConfigureTab:CreateToggle({Name = "Auto Rejoin", CurrentValue = Config.AutoRejoin, Flag = "AutoRejoin", Callback = function(v) Config.AutoRejoin = v end})
    ConfigureTab:CreateToggle({Name = "Server Hop", CurrentValue = Config.ServerHop, Flag = "ServerHop", Callback = function(v) Config.ServerHop = v end})
    ConfigureTab:CreateToggle({Name = "Anti-AFK", CurrentValue = Config.AntiAFK, Flag = "AntiAFK", Callback = function(v) Config.AntiAFK = v end})
    
    -- ===== TAB SETTINGS =====
    local SettingsTab = Window:CreateTab("Settings", 4483362458)
    
    SettingsTab:CreateSection("Appearance")
    
    SettingsTab:CreateColorPicker({
        Name = "ESP Color",
        Color = Config.ESPColor,
        Flag = "ESPColor",
        Callback = function(color) Config.ESPColor = color end,
    })
    
    SettingsTab:CreateSlider({
        Name = "Max Distance",
        Range = {100, 3000},
        Increment = 50,
        Suffix = "studs",
        CurrentValue = Config.MaxDistance,
        Flag = "MaxDistance",
        Callback = function(v) Config.MaxDistance = v end,
    })
    
    SettingsTab:CreateSlider({
        Name = "Loop Delay",
        Range = {0.05, 0.5},
        Increment = 0.05,
        Suffix = "s",
        CurrentValue = Config.LoopDelay,
        Flag = "LoopDelay",
        Callback = function(v) Config.LoopDelay = v end,
    })
    
    SettingsTab:CreateSlider({
        Name = "FOV",
        Range = {50, 120},
        Increment = 5,
        Suffix = "°",
        CurrentValue = Config.FOV,
        Flag = "FOV",
        Callback = function(v) Config.FOV = v end,
    })
    
    SettingsTab:CreateSection("Info")
    SettingsTab:CreateLabel("ShanX Lua v5 | Safe Mode")
    SettingsTab:CreateLabel("Anti-Kick: " .. (antiKickActive and "ACTIVE" or "NOT SUPPORTED"))
    SettingsTab:CreateLabel("All features OFF by default")
    
    Rayfield:LoadConfiguration()
    
    print("[ShanX Lua v5] ESP Loaded | Custom Name | Anti-Kick: " .. (antiKickActive and "YES" or "NO"))
end

print("[ShanX Lua v5] Login Loaded | User: shanx | Pass: shanx | Roblox: bronisseske")