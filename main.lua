local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Ultimate Edition",
   LoadingTitle = "Diego's Personal Script",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = false }
})

-- Variáveis
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local states = {
    Aimbot = false,
    AimRange = 500, -- Alcance do Aimbot
    ESP = false,
    NoClip = false,
    AntiRagdoll = false,
    InfJump = false,
    InstantPrompt = false,
    WalkSpeed = 16
}

local savedPos1, savedPos2

-- // ABA PRINCIPAL // --
local MainTab = Window:CreateTab("Movement & Game", 4483362458)

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value) states.WalkSpeed = Value end,
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

MainTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value) states.AntiRagdoll = Value end,
})

MainTab:CreateToggle({
   Name = "Instant Proximity Prompts",
   CurrentValue = false,
   Callback = function(Value) states.InstantPrompt = Value end,
})

-- // ABA COMBAT // --
local CombatTab = Window:CreateTab("Combat & ESP", 4483345998)

CombatTab:CreateToggle({
   Name = "Aimbot (Enemy Only)",
   CurrentValue = false,
   Callback = function(Value) states.Aimbot = Value end,
})

CombatTab:CreateSlider({
   Name = "Aimbot Range",
   Range = {50, 2000},
   Increment = 50,
   Suffix = "Studs",
   CurrentValue = 500,
   Callback = function(Value) states.AimRange = Value end,
})

CombatTab:CreateToggle({
   Name = "Team-Based ESP (Box & Name)",
   CurrentValue = false,
   Callback = function(Value) states.ESP = Value end,
})

-- // ABA TELEPORT & SERVER // --
local ServerTab = Window:CreateTab("Server & TP", 4483345998)

ServerTab:CreateSection("Positions")
ServerTab:CreateButton({ Name = "Save Pos 1", Callback = function() savedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end })
ServerTab:CreateButton({ Name = "Teleport Pos 1", Callback = function() if savedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos1 end end })
ServerTab:CreateButton({ Name = "Save Pos 2", Callback = function() savedPos2 = LocalPlayer.Character.HumanoidRootPart.CFrame end })
ServerTab:CreateButton({ Name = "Teleport Pos 2", Callback = function() if savedPos2 then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPos2 end end })

ServerTab:CreateSection("Server Utils")
ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
        for _, v in pairs(x.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end,
})
ServerTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })

-- // LOGICA // --

RunService.RenderStepped:Connect(function()
    -- WalkSpeed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = states.WalkSpeed
    end

    -- Aimbot
    if states.Aimbot then
        local closest = nil
        local dist = states.AimRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local d = (p.Character.Head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = p.Character.Head
                end
            end
        end
        if closest then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position)
        end
    end

    -- ESP Team-Based
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local color = isEnemy and Color3.new(1, 0, 0) or Color3.new(0, 0, 1)

            -- Box
            local b = hrp:FindFirstChild("OmniBox")
            if states.ESP then
                if not b then
                    b = Instance.new("BoxHandleAdornment", hrp)
                    b.Name = "OmniBox"
                    b.Adornee = hrp
                    b.AlwaysOnTop = true
                    b.Size = Vector3.new(4.5, 6, 1) -- Box aumentada
                    b.Transparency = 0.5
                end
                b.Color3 = color
            elseif b then b:Destroy() end

            -- Name
            local n = hrp:FindFirstChild("OmniName")
            if states.ESP then
                if not n then
                    n = Instance.new("BillboardGui", hrp)
                    n.Name = "OmniName"
                    n.Size = UDim2.new(0, 100, 0, 50)
                    n.AlwaysOnTop = true
                    n.StudsOffset = Vector3.new(0, 4, 0)
                    local l = Instance.new("TextLabel", n)
                    l.Size = UDim2.new(1, 0, 1, 0)
                    l.BackgroundTransparency = 1
                    l.Font = Enum.Font.GothamBold
                    l.TextSize = 14
                end
                n.TextLabel.Text = p.Name
                n.TextLabel.TextColor3 = color
            elseif n then n:Destroy() end
        end
    end
end)

-- NoClip & Prompts
RunService.Stepped:Connect(function()
    if states.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if states.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if states.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)

Rayfield:Notify({Title = "Sucesso!", Content = "Omnipotent Hub Carregado", Duration = 3})
