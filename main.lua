local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | FINAL FIX v6",
   LoadingTitle = "Diego's Hub",
   LoadingSubtitle = "Anti-Lag & Server Hop Restaurados",
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
    AimRange = 500,
    AimFOV = 150,
    AimSmoothing = 0.1,
    ESP_Chams = false,
    ESP_Names = false,
    NoClip = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16
}

local savedPos1

-- // FUNÇÕES DE PERFORMANCE E SERVIDOR // --

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

-- // ABA: PLAYER & FPS // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "Ativar Anti-Lag (FPS Boost)", Callback = ApplyAntiLag })
MainTab:CreateToggle({ Name = "Velocidade Customizada", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Ajustar Velocidade", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) states.InfJump = v end })
MainTab:CreateToggle({ Name = "Instant Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })

-- // ABA: COMBAT & ESP // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateSection("Aimbot Inteligente")
CombatTab:CreateToggle({ Name = "Ativar Aimbot", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Raio da Mira (FOV)", Range = {50, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) states.AimFOV = v end })
CombatTab:CreateSlider({ Name = "Distância Máxima (Studs)", Range = {50, 3000}, Increment = 50, CurrentValue = 500, Callback = function(v) states.AimRange = v end })
CombatTab:CreateSlider({ Name = "Suavidade", Range = {1, 50}, Increment = 1, CurrentValue = 10, Callback = function(v) states.AimSmoothing = v/100 end })

CombatTab:CreateSection("Visual (Times)")
CombatTab:CreateToggle({ Name = "ESP Corpo (Chams)", CurrentValue = false, Callback = function(v) states.ESP_Chams = v end })
CombatTab:CreateToggle({ Name = "ESP Nome + Distância", CurrentValue = false, Callback = function(v) states.ESP_Names = v end })

-- // ABA: SERVER & TP // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "Server Hop (Trocar de Sala)", Callback = ServerHop })
ServerTab:CreateButton({ Name = "Rejoin (Entrar de Novo)", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })
ServerTab:CreateSection("Teletransporte")
ServerTab:CreateButton({ Name = "Salvar Posição", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "Teleportar para Salvo", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })

-- // LÓGICA DE VISUAIS // --
local function UpdateESP(p)
    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local isEnemy = (p.Team ~= LocalPlayer.Team)
        local color = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
        
        local highlight = p.Character:FindFirstChild("OmniHighlight") or Instance.new("Highlight", p.Character)
        highlight.Name = "OmniHighlight"
        highlight.FillColor = color
        highlight.Enabled = states.ESP_Chams
        
        local hrp = p.Character.HumanoidRootPart
        local gui = hrp:FindFirstChild("OmniNameTag") or Instance.new("BillboardGui", hrp)
        gui.Name = "OmniNameTag"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0,100,0,50); gui.StudsOffset = Vector3.new(0,3,0); gui.Enabled = states.ESP_Names
        
        local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = color; label.Font = "GothamBold"; label.TextSize = 12
        local dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        label.Text = p.Name .. " [" .. dist .. "s]"
    end
end

-- // LOOPS // --
RunService.RenderStepped:Connect(function()
    if states.WalkSpeedToggle and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedValue
    end

    if states.Aimbot and LocalPlayer.Character then
        local target = nil
        local shortestMouseDist = states.AimFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local worldPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(worldPos.X, worldPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    local studDist = (head.Position - Camera.CFrame.Position).Magnitude
                    if mouseDist < shortestMouseDist and studDist < states.AimRange then
                        shortestMouseDist = mouseDist
                        target = head
                    end
                end
            end
        end
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), states.AimSmoothing)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do UpdateESP(p) end
end)

RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if states.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(3)
    end
end)

Rayfield:Notify({Title = "Diego Hub", Content = "Tudo carregado! Server Hop e Anti-Lag ativos.", Duration = 4})
