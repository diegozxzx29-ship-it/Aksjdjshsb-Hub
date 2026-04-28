local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DIEGO HUB | FINAL V24",
   LoadingTitle = "Diego's Final Script",
   LoadingSubtitle = "ESP Name Fixed - No AutoShoot",
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
    AimSmoothing = 0.3,
    NoClip = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeedToggle = false,
    WalkSpeedValue = 16,
    ESP_Chams = false,
    ESP_Names = false
}
local savedPos1

-- // ABA: PLAYER & FPS // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "FPS Boost (Anti-Lag)", Callback = function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") then v.Transparency = 1 end
    end
end })
MainTab:CreateToggle({ Name = "Velocidade", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Studs Speed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) states.InfJump = v end })
MainTab:CreateToggle({ Name = "Instant Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })

-- // ABA: COMBAT & ESP // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateSection("Aimbot Mobile")
CombatTab:CreateToggle({ Name = "Aimbot (Lock-On)", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Raio FOV", Range = {50, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) states.AimFOV = v end })

CombatTab:CreateSection("Visuais (Nomes Corrigidos)")
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
ServerTab:CreateButton({ Name = "Salvar Pos", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "TP Pos", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })

-- // LÓGICA DE ALVO // --
local function GetTarget()
    local target = nil
    local shortestDist = states.AimFOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
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
    if states.WalkSpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeedValue
    end

    if states.Aimbot then
        local head = GetTarget()
        if head then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), states.AimSmoothing)
        end
    end

    -- ESP NAME FIX --
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local color = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
            local hum = p.Character:FindFirstChild("Humanoid")
            local alive = hum and hum.Health > 0

            -- Chams
            local high = p.Character:FindFirstChild("OmniHighlight") or Instance.new("Highlight", p.Character)
            high.Name = "OmniHighlight"; high.FillColor = color; high.Enabled = (states.ESP_Chams and alive)
            
            -- Name Fix
            local hrp = p.Character.HumanoidRootPart
            local gui = hrp:FindFirstChild("OmniNameTag") or Instance.new("BillboardGui", hrp)
            gui.Name = "OmniNameTag"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0,100,0,50); gui.StudsOffset = Vector3.new(0,3,0); gui.Enabled = (states.ESP_Names and alive)
            
            local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.TextColor3 = color; label.TextSize = 14; label.Font = Enum.Font.GothamBold
            
            if gui.Enabled then
                local dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                label.Text = p.Name .. " [" .. dist .. "m]"
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
    if states.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(3)
    end
end)
