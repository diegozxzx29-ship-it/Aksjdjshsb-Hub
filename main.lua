local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Final v3",
   LoadingTitle = "Diego's Personal Hub",
   LoadingSubtitle = "Full Fix - No Music",
   ConfigurationSaving = { Enabled = false }
})

-- // VARIÁVEIS // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local states = {
    Aimbot = false,
    AimRange = 500,
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

-- // FUNÇÕES // --
local function ApplyAntiLag()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") then v.Transparency = 1 end
    end
    Rayfield:Notify({Title = "FPS", Content = "Boost Ativado", Duration = 2})
end

-- // INTERFACE // --
local MainTab = Window:CreateTab("Player & FPS", 4483362458)
MainTab:CreateButton({ Name = "Ativar Anti-Lag", Callback = ApplyAntiLag })
MainTab:CreateToggle({ Name = "Velocidade", CurrentValue = false, Callback = function(v) states.WalkSpeedToggle = v end })
MainTab:CreateSlider({ Name = "Studs de Velocidade", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) states.WalkSpeedValue = v end })
MainTab:CreateToggle({ Name = "Instant Proximity Prompts", CurrentValue = false, Callback = function(v) states.InstantPrompt = v end })
MainTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(v) states.NoClip = v end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) states.InfJump = v end })

local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)
CombatTab:CreateToggle({ Name = "Aimbot Pro", CurrentValue = false, Callback = function(v) states.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Alcance (Studs)", Range = {100, 2000}, Increment = 50, CurrentValue = 500, Callback = function(v) states.AimRange = v end })
CombatTab:CreateToggle({ Name = "ESP Team Color (Corpo)", CurrentValue = false, Callback = function(v) states.ESP_Chams = v end })
CombatTab:CreateToggle({ Name = "ESP Name + Distância", CurrentValue = false, Callback = function(v) states.ESP_Names = v end })

local ServerTab = Window:CreateTab("Server & TP", 4483345998)
ServerTab:CreateButton({ Name = "Salvar Posição", Callback = function() if LocalPlayer.Character then savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end })
ServerTab:CreateButton({ Name = "Teleportar", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })
ServerTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end })

-- // LÓGICA DE VISUAIS // --
local function UpdateESP(p)
    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local isEnemy = (p.Team ~= LocalPlayer.Team)
        local color = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)
        
        -- Chams
        local highlight = p.Character:FindFirstChild("OmniHighlight") or Instance.new("Highlight", p.Character)
        highlight.Name = "OmniHighlight"
        highlight.FillColor = color
        highlight.Enabled = states.ESP_Chams
        
        -- Names
        local hrp = p.Character.HumanoidRootPart
        local gui = hrp:FindFirstChild("OmniNameTag") or Instance.new("BillboardGui", hrp)
        gui.Name = "OmniNameTag"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0,100,0,50); gui.StudsOffset = Vector3.new(0,3,0)
        gui.Enabled = states.ESP_Names
        
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
        local target, dist = nil, states.AimRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local mag = (p.Character.Head.Position - Camera.CFrame.Position).Magnitude
                if mag < dist then
                    local _, screen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if screen then dist = mag target = p.Character.Head end
                end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), states.AimSmoothing) end
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
