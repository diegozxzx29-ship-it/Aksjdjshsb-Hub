local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | TEAM ADAPT V16",
   LoadingTitle = "Diego's Hub",
   LoadingSubtitle = "Auto-Time Adaptável + Todas Funções",
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
local Mouse = LocalPlayer:GetMouse()

local states = {
    Aimbot = false,
    AutoShoot = false,
    AimRange = 500,
    AimFOV = 150,
    AimSmoothing = 0.02,
    ESP_Chams = false,
    ESP_Names = false,
    NoClip = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16
}

local savedPos1

-- // ABA: PLAYER & FPS // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "Ativar Anti-Lag", Callback = function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") then v.Transparency = 1 end
    end
end })
MainTab:CreateToggle({ Name = "Velocidade", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Studs Speed", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) states.InfJump = v end })
MainTab:CreateToggle({ Name = "Instant Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })

-- // ABA: COMBAT & ESP // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateSection("Aimbot (Auto-Team Check)")
CombatTab:CreateToggle({ Name = "Aimbot Inteligente", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateToggle({ Name = "Auto Atirar", CurrentValue = false, Callback = function(v) states.AutoShoot = v end })
CombatTab:CreateSlider({ Name = "FOV", Range = {50, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) states.AimFOV = v end })
CombatTab:CreateSlider({ Name = "Distância", Range = {50, 3000}, Increment = 50, CurrentValue = 500, Callback = function(v) states.AimRange = v end })

CombatTab:CreateSection("Visuais (Inimigo=Vermelho / Amigo=Azul)")
CombatTab:CreateToggle({ Name = "ESP Corpo", CurrentValue = false, Callback = function(v) states.ESP_Chams = v end })
CombatTab:CreateToggle({ Name = "ESP Nome + Dist", CurrentValue = false, Callback = function(v) states.ESP_Names = v end })

-- // ABA: SERVER // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "Server Hop", Callback = function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    for _, s in pairs(servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id) return end end
end })
ServerTab:CreateButton({ Name = "Rejoin", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })
ServerTab:CreateButton({ Name = "Salvar Pos", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "TP Pos", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })

-- // FUNÇÃO DE CHECAGEM DE INIMIGO // --
local function GetTarget()
    local target = nil
    local shortestMouseDist = states.AimFOV
    
    for _, p in pairs(Players:GetPlayers()) do
        -- SÓ MIRA SE: Não for eu, não for do meu time, tiver personagem vivo
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    local studs = (head.Position - Camera.CFrame.Position).Magnitude
                    
                    if dist < shortestMouseDist and studs < states.AimRange then
                        shortestMouseDist = dist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

-- // LOOP PRINCIPAL // --
RunService.RenderStepped:Connect(function()
    -- Speed
    if states.WalkSpeedToggle and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedValue
    end

    -- Combat (Aimbot & AutoShoot)
    if states.Aimbot then
        local target = GetTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            if states.AutoShoot then mouse1click() end
        end
    end

    -- Visuais Dinâmicos (ESP)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            local alive = p.Character.Humanoid.Health > 0
            -- AQUI A MÁGICA: A cor muda na hora se o time mudar
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local color = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
            
            -- Chams
            local high = p.Character:FindFirstChild("OmniHighlight") or Instance.new("Highlight", p.Character)
            high.Name = "OmniHighlight"
            high.FillColor = color
            high.Enabled = (states.ESP_Chams and alive)
            
            -- NameTags
            local hrp = p.Character.HumanoidRootPart
            local gui = hrp:FindFirstChild("OmniNameTag") or Instance.new("BillboardGui", hrp)
            gui.Name = "OmniNameTag"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0,100,0,50); gui.Enabled = (states.ESP_Names and alive)
            
            if gui.Enabled then
                local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
                label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = color; label.TextSize = 12; label.Font = "GothamBold"
                local d = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                label.Text = p.Name .. " [" .. d .. "s]"
            end
        end
    end
end)

-- NoClip & Prompts
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
