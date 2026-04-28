local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Clean Edition",
   LoadingTitle = "Diego's Hub",
   LoadingSubtitle = "Foco em Performance",
   ConfigurationSaving = { Enabled = false }
})

-- // VARIÁVEIS DE SERVIÇO // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local states = {
    Aimbot = false,
    AimRange = 500,
    AimSmoothing = 0.15,
    ESP = false,
    NoClip = false,
    AntiRagdoll = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16
}

local savedPos1, savedPos2

-- // FUNÇÕES DE UTILIDADE // --

local function ServerHop()
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local raw = game:HttpGet(Api)
    local servers = HttpService:JSONDecode(raw)
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
            return
        end
    end
end

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
    Rayfield:Notify({Title = "Anti-Lag", Content = "Gráficos reduzidos para máximo FPS!", Duration = 3})
end

-- // ABA: PLAYER & FPS // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "Ativar Anti-Lag (FPS Boost)", Callback = ApplyAntiLag })
MainTab:CreateToggle({ Name = "Velocidade Customizada", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Ajustar Velocidade", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) states.InfJump = v end })
MainTab:CreateToggle({ Name = "Anti Ragdoll", CurrentValue = false, Callback = function(v) states.AntiRagdoll = v end })
MainTab:CreateToggle({ Name = "Instant Proximity Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })

-- // ABA: COMBAT & ESP // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateToggle({ Name = "Aimbot Suave (Inimigos)", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Alcance da Mira", Range = {50, 1500}, Increment = 50, CurrentValue = 500, Callback = function(v) states.AimRange = v end })
CombatTab:CreateToggle({ Name = "ESP por Time (Box/Nome)", CurrentValue = false, Callback = function(v) states.ESP = v end })

-- // ABA: SERVER & TP // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "Salvar Posição 1", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "Teleportar para 1", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })
ServerTab:CreateButton({ Name = "Server Hop", Callback = ServerHop })
ServerTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })

-- // LOOPS DE FUNCIONAMENTO // --

RunService.RenderStepped:Connect(function()
    -- WalkSpeed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedToggle and states.WalkSpeedValue or 16
    end

    -- Aimbot Suave (Lógica de mira que não trava a câmera)
    if states.Aimbot and LocalPlayer.Character then
        local target = nil
        local dist = states.AimRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local mag = (head.Position - Camera.CFrame.Position).Magnitude
                if mag < dist then
                    local _, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then dist = mag target = head end
                end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), states.AimSmoothing)
        end
    end

    -- ESP Team-Based
    if states.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local isEnemy = (p.Team ~= LocalPlayer.Team)
                local color = isEnemy and Color3.new(1, 0, 0) or Color3.new(0, 0, 1)

                local b = hrp:FindFirstChild("OmniBox") or Instance.new("BoxHandleAdornment", hrp)
                b.Name = "OmniBox"; b.Adornee = hrp; b.AlwaysOnTop = true; b.Size = Vector3.new(4, 5.5, 1); b.Transparency = 0.6; b.Color3 = color; b.Visible = true

                local n = hrp:FindFirstChild("OmniName") or Instance.new("BillboardGui", hrp)
                n.Name = "OmniName"; n.Size = UDim2.new(0, 100, 0, 50); n.AlwaysOnTop = true; n.StudsOffset = Vector3.new(0, 3.5, 0); n.Visible = true
                local l = n:FindFirstChild("TextLabel") or Instance.new("TextLabel", n)
                l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = p.Name; l.TextColor3 = color; l.Font = Enum.Font.GothamBold; l.TextSize = 12
            end
        end
    else
        -- Limpa o ESP quando desligado
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if hrp:FindFirstChild("OmniBox") then hrp.OmniBox:Destroy() end
                if hrp:FindFirstChild("OmniName") then hrp.OmniName:Destroy() end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if states.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end
    end
    if states.AntiRagdoll and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum:GetState() == Enum.HumanoidStateType.Ragdoll then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

Rayfield:Notify({Title = "Diego Hub", Content = "Script carregado sem rádio.", Duration = 4})
