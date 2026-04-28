local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DIEGO HUB | V33 AIMBOT FIX",
   LoadingTitle = "Aimbot Reconstruído",
   LoadingSubtitle = "Mira Lisa + Prediction + Tudo ON",
   ConfigurationSaving = { Enabled = false }
})

-- // VARIÁVEIS // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local states = {
    Aimbot = false,
    AimFOV = 150,
    AimSmooth = 0.25, -- 0.1 é muito forte, 0.5 é suave. 0.25 é o ponto doce.
    NoClip = false,
    InfJump = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16,
    ESP_Chams = false,
    ESP_Names = false,
    ShiftLock = false,
    AntiRagdoll = false,
    InstantPrompt = false
}
local savedPos1

-- // UI SHIFT LOCK // --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ShiftLockButton = Instance.new("Frame", ScreenGui)
ShiftLockButton.Size = UDim2.new(0, 55, 0, 55)
ShiftLockButton.Position = UDim2.new(0.82, 0, 0.40, 0)
ShiftLockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ShiftLockButton.BackgroundTransparency = 0.3
ShiftLockButton.Visible = false
Instance.new("UICorner", ShiftLockButton).CornerRadius = UDim.new(1, 0)
local ClickBtn = Instance.new("TextButton", ShiftLockButton)
ClickBtn.Size = UDim2.new(1, 0, 1, 0); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""
local lockActive = false
ClickBtn.MouseButton1Click:Connect(function()
    if not states.ShiftLock then return end
    lockActive = not lockActive
    ShiftLockButton.BackgroundColor3 = lockActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
end)

-- // ABA: PLAYER & FPS // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateToggle({ Name = "Instant Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })
MainTab:CreateToggle({ Name = "ANTI-RAGDOLL", CurrentValue = false, Callback = function(v) states.AntiRagdoll = v end })
MainTab:CreateButton({ Name = "Fly GUI V3", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end })
MainTab:CreateToggle({ Name = "Habilitar Shift Lock", CurrentValue = false, Callback = function(v) states.ShiftLock = v; ShiftLockButton.Visible = v end })
MainTab:CreateToggle({ Name = "Velocidade", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Studs", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) states.InfJump = v end })

-- // ABA: COMBAT & ESP // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateSection("Aimbot Config (Mobile)")
CombatTab:CreateToggle({ Name = "Ativar Aimbot", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Tamanho FOV", Range = {50, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) states.AimFOV = v end })
CombatTab:CreateSlider({ Name = "Suavidade (Smooth)", Range = {1, 10}, Increment = 1, CurrentValue = 3, Callback = function(v) states.AimSmooth = v/10 end })

CombatTab:CreateSection("Visuais")
CombatTab:CreateToggle({ Name = "ESP Corpo (Chams)", CurrentValue = false, Callback = function(v) states.ESP_Chams = v end })
CombatTab:CreateToggle({ Name = "ESP Nomes + Dist", CurrentValue = false, Callback = function(v) states.ESP_Names = v end })

-- // ABA: SERVER & TP // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "REJOIN", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })
ServerTab:CreateButton({ Name = "SERVER HOP", Callback = function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    for _, s in pairs(servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id) return end end
end })
ServerTab:CreateButton({ Name = "Salvar Pos", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "TP Pos", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })

-- // LÓGICA AIMBOT MELHORADA // --
local function GetClosestTarget()
    local target = nil
    local dist = states.AimFOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mouseDist < dist then
                    -- Wall Check Simples
                    local ray = Ray.new(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500)
                    local part = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, p.Character})
                    if not part then
                        dist = mouseDist
                        target = p.Character.Head
                    end
                end
            end
        end
    end
    return target
end

-- // LOOP PRINCIPAL // --
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Aimbot Fix
    if states.Aimbot then
        local t = GetClosestTarget()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), states.AimSmooth)
        end
    end

    -- Shift Lock Fix
    if states.ShiftLock and lockActive and hrp and hum then
        hum.AutoRotate = false
        local lv = Camera.CFrame.LookVector
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lv.X, 0, lv.Z))
    elseif hum then
        hum.AutoRotate = true
    end

    -- Instant Prompt
    if states.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end
    end

    -- ESP & Anti-Ragdoll
    if states.AntiRagdoll and hum then
        if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(1) end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local color = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
            local high = p.Character:FindFirstChild("OmniH") or Instance.new("Highlight", p.Character)
            high.Name = "OmniH"; high.FillColor = color; high.Enabled = states.ESP_Chams
            
            local targetHrp = p.Character.HumanoidRootPart
            local gui = targetHrp:FindFirstChild("OmniT") or Instance.new("BillboardGui", targetHrp)
            gui.Name = "OmniT"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0,100,0,50); gui.Enabled = states.ESP_Names
            local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = color; label.TextSize = 12
            label.Text = p.Name .. " [" .. math.floor((targetHrp.Position - hrp.Position).Magnitude) .. "m]"
        end
    end
end)

-- NoClip & Speed
RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if states.WalkSpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedValue
    end
end)
UserInputService.JumpRequest:Connect(function() if states.InfJump and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:ChangeState(3) end end)
