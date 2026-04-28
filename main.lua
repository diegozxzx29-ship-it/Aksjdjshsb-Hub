local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Definitive Fix",
   LoadingTitle = "Diego's Hub",
   LoadingSubtitle = "Tudo Restaurado + ESP Azul",
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
    AimSmoothing = 0.15,
    ESP = false,
    NoClip = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16
}

local savedPos1

-- // FUNÇÕES DE PERFORMANCE & SERVER // --

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
    Rayfield:Notify({Title = "Anti-Lag", Content = "Mapa otimizado!", Duration = 3})
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

-- // INTERFACE - ABA PLAYER // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "Ativar Anti-Lag (FPS Boost)", Callback = ApplyAntiLag })
MainTab:CreateToggle({ Name = "Velocidade Customizada", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Ajustar Velocidade", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) states.InfJump = v end })
MainTab:CreateToggle({ Name = "Instant Prompt", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })

-- // INTERFACE - ABA COMBAT // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateToggle({ Name = "Aimbot Suave", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateToggle({ Name = "ESP Corpo Azul (Chams)", CurrentValue = false, Callback = function(v) states.ESP = v end })

-- // INTERFACE - ABA TELEPORT // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "Salvar Posição", Callback = function() 
    if LocalPlayer.Character then 
        savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame 
        Rayfield:Notify({Title = "Sucesso", Content = "Posição salva!", Duration = 2})
    end 
end})
ServerTab:CreateButton({ Name = "Teleportar para Salvo", Callback = function() 
    if savedPos1 and LocalPlayer.Character then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 
    end 
end})
ServerTab:CreateButton({ Name = "Server Hop", Callback = ServerHop })
ServerTab:CreateButton({ Name = "Rejoin", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })

-- // LÓGICA ESP AZUL // --
local function ApplyESP(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = player.Character:FindFirstChild("OmniHighlight") or Instance.new("Highlight")
        highlight.Name = "OmniHighlight"
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(0, 170, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Enabled = states.ESP
    end
end

-- // LOOPS // --
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedToggle and states.WalkSpeedValue or 16
    end

    if states.Aimbot and LocalPlayer.Character then
        local target = nil
        local dist = 500
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

    if states.ESP then
        for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("OmniHighlight") then p.Character.OmniHighlight.Enabled = false end
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
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

Rayfield:Notify({Title = "Diego Hub", Content = "Tudo carregado e corrigido!", Duration = 5})
