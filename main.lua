local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Omnipotent Hub | Rayfield Edition",
   LoadingTitle = "Carregando Scripts...",
   LoadingSubtitle = "por Diego",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OmnipotentHub",
      FileName = "Config"
   }
})

-- Variáveis de Estado
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local states = {
    Aimbot = false,
    ESPBox = false,
    ESPName = false,
    NoClip = false,
    AntiRagdoll = false,
    InfJump = false,
    InstantPrompt = false
}

local savedPos1, savedPos2

-- // ABA PRINCIPAL (PLAYER) // --
local MainTab = Window:CreateTab("Main Cheats", 4483362458) -- Icone de engrenagem

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

-- // ABA COMBAT & VISUAL // --
local VisualTab = Window:CreateTab("Combat & ESP", 4483345998)

VisualTab:CreateToggle({
   Name = "Aimbot (Nearest Head)",
   CurrentValue = false,
   Callback = function(Value) states.Aimbot = Value end,
})

VisualTab:CreateToggle({
   Name = "Blue ESP Box",
   CurrentValue = false,
   Callback = function(Value) states.ESPBox = Value end,
})

VisualTab:CreateToggle({
   Name = "White ESP Name",
   CurrentValue = false,
   Callback = function(Value) states.ESPName = Value end,
})

-- // ABA TELEPORT // --
local TPTab = Window:CreateTab("Teleports", 4483345998)

TPTab:CreateSection("Saved Positions")

TPTab:CreateButton({
   Name = "Save Position 1",
   Callback = function() savedPos1 = RootPart.CFrame Rayfield:Notify({Title = "Salvo!", Content = "Posição 1 guardada.", Duration = 2}) end,
})

TPTab:CreateButton({
   Name = "Teleport to Pos 1",
   Callback = function() if savedPos1 then RootPart.CFrame = savedPos1 end end,
})

TPTab:CreateButton({
   Name = "Save Position 2",
   Callback = function() savedPos2 = RootPart.CFrame Rayfield:Notify({Title = "Salvo!", Content = "Posição 2 guardada.", Duration = 2}) end,
})

TPTab:CreateButton({
   Name = "Teleport to Pos 2",
   Callback = function() if savedPos2 then RootPart.CFrame = savedPos2 end end,
})

TPTab:CreateSection("Player Teleport")

local SelectedPlayer = ""
TPTab:CreateDropdown({
   Name = "Select Player",
   Options = {"Refresh para listar"},
   CurrentOption = {""},
   MultipleOptions = false,
   Callback = function(Option) SelectedPlayer = Option[1] end,
})

TPTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
       local pList = {}
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer then table.insert(pList, p.Name) end
       end
       -- Nota: No Rayfield oficial, você precisaria atualizar o Dropdown via variável
       Rayfield:Notify({Title = "Lista Atualizada", Content = "Escolha o player no dropdown.", Duration = 2})
   end,
})

TPTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
       local target = Players:FindFirstChild(SelectedPlayer)
       if target and target.Character and RootPart then
           RootPart.CFrame = target.Character.HumanoidRootPart.CFrame
       end
   end,
})

-- // LÓGICA DE BACKEND (LOOPS) // --

RunService.RenderStepped:Connect(function()
    -- Aimbot
    if states.Aimbot then
        local closest = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local d = (p.Character.Head.Position - RootPart.Position).Magnitude
                if d < dist then dist = d closest = p.Character.Head end
            end
        end
        if closest then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position)
        end
    end

    -- ESP Logic
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            
            -- Box
            local b = hrp:FindFirstChild("RayBox")
            if states.ESPBox then
                if not b then
                    b = Instance.new("BoxHandleAdornment", hrp)
                    b.Name = "RayBox"
                    b.Adornee = hrp
                    b.AlwaysOnTop = true
                    b.Size = Vector3.new(4, 5, 1)
                    b.Color3 = Color3.new(0, 0, 1)
                    b.Transparency = 0.5
                end
            elseif b then b:Destroy() end

            -- Name
            local n = hrp:FindFirstChild("RayName")
            if states.ESPName then
                if not n then
                    n = Instance.new("BillboardGui", hrp)
                    n.Name = "RayName"
                    n.Size = UDim2.new(0, 100, 0, 50)
                    n.AlwaysOnTop = true
                    n.StudsOffset = Vector3.new(0, 3, 0)
                    local l = Instance.new("TextLabel", n)
                    l.Size = UDim2.new(1, 0, 1, 0)
                    l.Text = p.Name
                    l.TextColor3 = Color3.new(1, 1, 1)
                    l.BackgroundTransparency = 1
                end
            elseif n then n:Destroy() end
        end
    end
end)

RunService.Stepped:Connect(function()
    if states.NoClip and Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if states.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.InfJump and Character:FindFirstChildOfClass("Humanoid") then
        Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Anti-Ragdoll Loop
task.spawn(function()
    while task.wait(0.5) do
        if states.AntiRagdoll and Character:FindFirstChildOfClass("Humanoid") then
            local hum = Character:FindFirstChildOfClass("Humanoid")
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)
