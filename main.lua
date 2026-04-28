local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Versão Final",
   LoadingTitle = "Diego's Hub",
   LoadingSubtitle = "Otimizado por Gemini AI",
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
    AimSmoothing = 0.12,
    ESP = false,
    NoClip = false,
    AntiRagdoll = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16
}

local savedPos1, savedPos2

-- // FUNÇÕES AUXILIARES // --

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
    Rayfield:Notify({Title = "Anti-Lag", Content = "Gráficos reduzidos com sucesso!", Duration = 3})
end

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

-- // ABAS DA INTERFACE // --

local MainTab = Window:CreateTab("Player & FPS", 4483362458)

MainTab:CreateButton({
    Name = "Ativar Anti-Lag (FPS Boost)",
    Callback = function() ApplyAntiLag() end,
})

MainTab:CreateToggle({
   Name = "Ativar Velocidade Customizada",
   CurrentValue = false,
   Callback = function(Value) states.WalkSpeedToggle = Value end,
})

MainTab:CreateSlider({
   Name = "Ajustar Velocidade",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) states.WalkSpeedValue = Value end,
})

MainTab:CreateToggle({
   Name = "No Clip",
   CurrentValue = false,
   Callback = function(Value) states.NoClip = Value end,
})

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) states.InfJump = Value end,
})

local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)

CombatTab:CreateToggle({
   Name = "Aimbot Suave (Apenas Inimigos)",
   CurrentValue = false,
   Callback = function(Value) states.Aimbot = Value end,
})

CombatTab:CreateSlider({
   Name = "Alcance da Mira (Studs)",
   Range = {50, 1500},
   Increment = 50,
   CurrentValue = 500,
   Callback = function(Value) states.AimRange = Value end,
})

CombatTab:CreateToggle({
   Name = "ESP de Times (Box/Nome)",
   CurrentValue = false,
   Callback = function(Value) states.ESP = Value end,
})

local ServerTab = Window:CreateTab("Server & TP", 4483345998)

ServerTab:CreateSection("Posições Salvas")
ServerTab:CreateButton({ Name = "Salvar Posição 1", Callback = function() savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end })
ServerTab:CreateButton({ Name = "Teleportar para 1", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })
ServerTab:CreateButton({ Name = "Salvar Posição 2", Callback = function() savedPos2 = LocalPlayer.Character.HumanoidRootPart.CFrame end })
ServerTab:CreateButton({ Name = "Teleportar para 2", Callback = function() if savedPos2 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos2 end end })

ServerTab:CreateSection("Utilidades do Servidor")
ServerTab:CreateButton({ Name = "Server Hop (Mudar de Server)", Callback = function() ServerHop() end })
ServerTab:CreateButton({ Name = "Rejoin (Reconectar)", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })

-- // LÓGICA DE EXECUÇÃO (LOOPS) // --

RunService.RenderStepped:Connect(function()
    -- Controle de Velocidade
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedToggle and states.WalkSpeedValue or 16
    end

    -- Aimbot Suave Otimizado
    if states.Aimbot and LocalPlayer.Character then
        local target = nil
        local dist = states.AimRange
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local mag = (head.Position - Camera.CFrame.Position).Magnitude
                
                if mag < dist then
                    local _, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        dist = mag
                        target = head
                    end
                end
            end
        end

        if target then
            local targetPos = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, states.AimSmoothing)
        end
    end
end)

-- Loop do ESP (Time-Based)
task.spawn(function()
    while task.wait(0.1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local isEnemy = (p.Team ~= LocalPlayer.Team)
                local color = isEnemy and Color3.new(1, 0, 0) or Color3.new(0, 0, 1)

                -- Lógica da Box
                local b = hrp:FindFirstChild("OmniBox")
                if states.ESP then
                    if not b then
                        b = Instance.new("BoxHandleAdornment", hrp)
                        b.Name = "OmniBox"
                        b.Adornee = hrp
                        b.AlwaysOnTop = true
                        b.Size = Vector3.new(4, 5.5, 1)
                        b.Transparency = 0.6
                    end
                    b.Color3 = color
                elseif b then b:Destroy() end

                -- Lógica do Nome
                local n = hrp:FindFirstChild("OmniName")
                if states.ESP then
                    if not n then
                        n = Instance.new("BillboardGui", hrp)
                        n.Name = "OmniName"
                        n.Size = UDim2.new(0, 100, 0, 50)
                        n.AlwaysOnTop = true
                        n.StudsOffset = Vector3.new(0, 3.5, 0)
                        local l = Instance.new("TextLabel", n)
                        l.Size = UDim2.new(1, 0, 1, 0)
                        l.BackgroundTransparency = 1
                        l.Font = Enum.Font.GothamBold
                        l.TextSize = 12
                    end
                    n.TextLabel.Text = p.Name
                    n.TextLabel.TextColor3 = color
                elseif n then n:Destroy() end
            end
        end
    end
end)

-- NoClip & Outros
RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

Rayfield:Notify({Title = "Sucesso!", Content = "Diego Hub pronto para uso.", Duration = 3})
