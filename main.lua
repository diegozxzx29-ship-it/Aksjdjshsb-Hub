local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DIEGO HUB | V32 ULTIMATE FIX",
   LoadingTitle = "Diego's Final Version",
   LoadingSubtitle = "Shift Lock Pro + Instant Prompts",
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

-- // UI DO SHIFT LOCK AZUL // --
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
    
    -- Forçar o fim da rotação automática para não bugar o ataque em movimento
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.AutoRotate = not lockActive
    end
end)

-- // ABA: PLAYER & FPS // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateToggle({ Name = "Instant Proximity Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })
MainTab:CreateToggle({ Name = "ANTI-RAGDOLL", CurrentValue = false, Callback = function(v) states.AntiRagdoll = v end })
MainTab:CreateButton({ Name = "Abrir Fly GUI (V3)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end })
MainTab:CreateToggle({ Name = "Habilitar Shift Lock", CurrentValue = false, Callback = function(v) states.ShiftLock = v; ShiftLockButton.Visible = v end })
MainTab:CreateToggle({ Name = "Velocidade", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Valor Velocidade", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) states.InfJump = v end })

-- // ABA: COMBAT & ESP // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateToggle({ Name = "ESP Corpo (Chams)", CurrentValue = false, Callback = function(v) states.ESP_Chams = v end })
CombatTab:CreateToggle({ Name = "ESP Nomes + Distância", CurrentValue = false, Callback = function(v) states.ESP_Names = v end })

-- // ABA: SERVER & TP // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "REJOIN", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })
ServerTab:CreateButton({ Name = "SERVER HOP", Callback = function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    for _, s in pairs(servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id) return end end
end })
ServerTab:CreateSection("Posição")
ServerTab:CreateButton({ Name = "Salvar Posição", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "TP para Salvo", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })

-- // LOOP PRINCIPAL // --
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- SHIFT LOCK MELHORADO: Trava o boneco na direção da câmera e desliga rotação
    if states.ShiftLock and lockActive and hrp and hum then
        hum.AutoRotate = false
        local lookVector = Camera.CFrame.LookVector
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
    elseif hum then
        hum.AutoRotate = true
    end

    -- Instant Prompt
    if states.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end

    -- Anti-Ragdoll
    if states.AntiRagdoll and hum then
        if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    -- ESP Fix
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local color = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
            
            local high = p.Character:FindFirstChild("OmniHigh") or Instance.new("Highlight", p.Character)
            high.Name = "OmniHigh"; high.FillColor = color; high.Enabled = states.ESP_Chams

            local targetHrp = p.Character.HumanoidRootPart
            local gui = targetHrp:FindFirstChild("OmniTag") or Instance.new("BillboardGui", targetHrp)
            gui.Name = "OmniTag"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0,100,0,50); gui.Enabled = states.ESP_Names
            local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = color; label.TextSize = 14; 
            label.Text = p.Name .. " [" .. math.floor((targetHrp.Position - hrp.Position).Magnitude) .. "m]"
        end
    end
end)

-- NoClip / Speed / Jump
RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if states.WalkSpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedValue
    end
end)
UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:ChangeState(3) end
end)
