local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Definitive Edition",
   LoadingTitle = "Diego's Hub",
   LoadingSubtitle = "Aimbot Pro + ESP Name/Dist",
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
    AimSmoothing = 0.1, -- Menor = Mais rápido/colado
    ESP_Chams = false,
    ESP_Names = false,
    NoClip = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16
}

local savedPos1

-- // FUNÇÕES DE UTILIDADE // --

local function ApplyAntiLag()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    game:GetService("Lighting").GlobalShadows = false
    Rayfield:Notify({Title = "Anti-Lag", Content = "FPS Estabilizado!", Duration = 3})
end

-- // ABA: PLAYER // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "Ativar Anti-Lag (FPS Boost)", Callback = ApplyAntiLag })
MainTab:CreateToggle({ Name = "Velocidade Customizada", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Ajustar Velocidade", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) states.InfJump = v end })

-- // ABA: COMBAT (MELHORADA) // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateSection("Mira")
CombatTab:CreateToggle({ Name = "Aimbot Pro (Suave)", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Suavidade da Mira", Range = {1, 50}, Increment = 1, CurrentValue = 10, Callback = function(v) states.AimSmoothing = v/100 end })

CombatTab:CreateSection("Visual")
CombatTab:CreateToggle({ Name = "ESP Corpo Azul (Chams)", CurrentValue = false, Callback = function(v) states.ESP_Chams = v end })
CombatTab:CreateToggle({ Name = "ESP Name (Nome + Distância)", CurrentValue = false, Callback = function(v) states.ESP_Names = v end })

-- // ABA: TELEPORT // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "Salvar Posição", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "Teleportar para Salvo", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })
ServerTab:CreateButton({ Name = "Server Hop", Callback = function() --[[Função ServerHop]] end })

-- // LOGICA DO ESP NAME + DISTANCE // --
local function UpdateNames(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local gui = hrp:FindFirstChild("OmniNameTag") or Instance.new("BillboardGui", hrp)
        
        gui.Name = "OmniNameTag"
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 100, 0, 50)
        gui.StudsOffset = Vector3.new(0, 3, 0)
        gui.Enabled = states.ESP_Names

        local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        
        local dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        label.Text = player.Name .. " [" .. dist .. "m]"
    end
end

-- // LOOPS PRINCIPAIS // --
RunService.RenderStepped:Connect(function()
    -- WalkSpeed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedToggle and states.WalkSpeedValue or 16
    end

    -- Aimbot Pro (Melhorado)
    if states.Aimbot and LocalPlayer.Character then
        local target = nil
        local shortestDist = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mag < shortestDist then
                        shortestDist = mag
                        target = p.Character.Head
                    end
                end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), states.AimSmoothing)
        end
    end

    -- ESP Chams e Names
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Lógica Chams
            local highlight = p.Character:FindFirstChild("OmniHighlight") or Instance.new("Highlight", p.Character)
            highlight.Name = "OmniHighlight"
            highlight.FillColor = Color3.fromRGB(0, 170, 255)
            highlight.Enabled = states.ESP_Chams
            
            -- Lógica Names
            if states.ESP_Names then UpdateNames(p)
            elseif p.Character.HumanoidRootPart:FindFirstChild("OmniNameTag") then
                p.Character.HumanoidRootPart.OmniNameTag.Enabled = false
            end
        end
    end
end)

-- NoClip e Outros
RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

Rayfield:Notify({Title = "Diego Hub", Content = "Script Atualizado: ESP Name + Aimbot Pro", Duration = 4})
