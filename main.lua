local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Diego Hub",
   LoadingTitle = "Diego Hub",
   LoadingSubtitle = "Preparando módulos de elite...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DiegoHubConfig", 
      FileName = "MainConfig"
   },
   KeySystem = false
})

-- // SERVIÇOS DO SISTEMA // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- // VARIÁVEIS DE CONTROLE // --
_G.AimbotEnabled = false
_G.AimPart = "Head"
_G.ESP_Ativo = false
_G.AntiRagdoll = false
_G.InfiniteJump = false
_G.InstantPrompt = false
_G.SavedPosition = nil
_G.LoopTeleport = false
_G.TargetPlayerTP = ""
local NoclipConn = nil

-- // CARREGAMENTO DE SCRIPTS EXTERNOS // --
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/UselessManS90/TriggerBot/main/TriggBot"))()
    loadstring(game:HttpGet("https://pastebin.com/raw/KiSYpej6", true))()
end)

-- // ABA STATUS (FPS & PING) // --
local StatusTab = Window:CreateTab("Status", 4483362458)
local FPSLabel = StatusTab:CreateLabel("FPS: Calculando...")
local PingLabel = StatusTab:CreateLabel("Ping: Calculando...")

RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = math.floor(player:GetNetworkPing() * 1000)
    FPSLabel:Set("FPS: " .. fps)
    PingLabel:Set("Ping: " .. ping .. " ms")
end)

-- // ABA COMBATE // --
local CombatTab = Window:CreateTab("Combate", 4483362458)

CombatTab:CreateButton({
   Name = "Ativar God Mode (Universal)",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
   end,
})

CombatTab:CreateToggle({
   Name = "Aimbot Assist",
   CurrentValue = false,
   Callback = function(Value) _G.AimbotEnabled = Value end,
})

CombatTab:CreateDropdown({
   Name = "Alvo da Mira (Baseado na Imagem)",
   Options = {"Cabeça", "Corpo", "Pés"},
   CurrentOption = {"Cabeça"},
   Callback = function(Option)
      if Option[1] == "Cabeça" then _G.AimPart = "Head"
      elseif Option[1] == "Corpo" then _G.AimPart = "HumanoidRootPart"
      elseif Option[1] == "Pés" then _G.AimPart = "LeftFoot" end
   end,
})

-- // ABA TELEPORTE // --
local TPTab = Window:CreateTab("Teleporte", 4483362458)

TPTab:CreateSection("Teleporte por Coordenadas")
TPTab:CreateButton({
   Name = "Salvar Posição Atual",
   Callback = function()
       if player.Character then 
           _G.SavedPosition = player.Character.HumanoidRootPart.Position 
           Rayfield:Notify({Title = "Salvo!", Content = "Coordenadas registradas.", Duration = 2})
       end
   end,
})

TPTab:CreateButton({
   Name = "Teleportar para Salvo",
   Callback = function()
       if _G.SavedPosition and player.Character then 
           player.Character.HumanoidRootPart.CFrame = CFrame.new(_G.SavedPosition) 
       end
   end,
})

TPTab:CreateSection("Teleporte para Jogadores")
local function getPlayers()
    local tbl = {}
    for _, v in pairs(Players:GetPlayers()) do if v ~= player then table.insert(tbl, v.Name) end end
    return tbl
end

local PLDropdown = TPTab:CreateDropdown({
   Name = "Selecionar Jogador",
   Options = getPlayers(),
   CurrentOption = {""},
   Callback = function(Option) _G.TargetPlayerTP = Option[1] end,
})

TPTab:CreateButton({
   Name = "Ir até o Jogador / Atualizar",
   Callback = function()
       PLDropdown:Refresh(getPlayers(), true)
       if _G.TargetPlayerTP ~= "" then
           local target = Players:FindFirstChild(_G.TargetPlayerTP)
           if target and target.Character then
               player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
           end
       end
   end,
})

-- // ABA MOVIMENTAÇÃO // --
local MoveTab = Window:CreateTab("Movimentação", 4483362458)

MoveTab:CreateToggle({
   Name = "Noclip",
   Callback = function(Value)
      if Value then
          NoclipConn = RunService.Stepped:Connect(function()
              if player.Character then
                  for _, v in pairs(player.Character:GetDescendants()) do
                      if v:IsA("BasePart") then v.CanCollide = false end
                  end
              end
          end)
      else
          if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
      end
   end,
})

MoveTab:CreateToggle({Name = "Pulo Infinito", Callback = function(Value) _G.InfiniteJump = Value end})
MoveTab:CreateToggle({Name = "Anti-Ragdoll", Callback = function(Value) _G.AntiRagdoll = Value end})
MoveTab:CreateButton({Name = "Painel Fly", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end})

-- // ABA VISUAL // --
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
   Name = "Ativar ESP Chams",
   Callback = function(Value)
      _G.ESP_Ativo = Value
      if Value then
          spawn(function()
              while _G.ESP_Ativo do
                  for _, v in pairs(Players:GetPlayers()) do
                      if v ~= player and v.Character then
                          local h = v.Character:FindFirstChild("GetReal") or Instance.new("Highlight", v.Character)
                          h.Name = "GetReal"
                          h.FillColor = v.TeamColor.Color
                          h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                      end
                  end
                  task.wait(1)
              end
              for _, v in pairs(Players:GetPlayers()) do
                  if v.Character and v.Character:FindFirstChild("GetReal") then v.Character.GetReal:Destroy() end
              end
          end)
      end
   end,
})

-- // ABA SERVIDOR // --
local ServerTab = Window:CreateTab("Servidor", 4483362458)
ServerTab:CreateButton({Name = "Server Hop", Callback = function() TeleportService:Teleport(game.PlaceId, player) end})
ServerTab:CreateButton({Name = "Rejoin", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end})
ServerTab:CreateToggle({Name = "Interação Instantânea (E)", Callback = function(Value) _G.InstantPrompt = Value end})

-- // LÓGICAS GLOBAIS DE EXECUÇÃO // --

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = nil
        local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild(_G.AimPart) then
                local pos, vis = camera:WorldToViewportPoint(v.Character[_G.AimPart].Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if m < dist then target = v dist = m end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character[_G.AimPart].Position) end
    end
end)

-- Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and player.Character then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- Interação Instantânea
ProximityPromptService.PromptButtonHoldBegan:Connect(function(p)
    if _G.InstantPrompt then fireproximityprompt(p) end
end)

-- Anti-Ragdoll
local function anti(c)
    c:WaitForChild("Humanoid").StateChanged:Connect(function(_, s)
        if _G.AntiRagdoll and (s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.FallingDown) then
            c.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end
player.CharacterAdded:Connect(anti)
if player.Character then anti(player.Character) end

Rayfield:Notify({Title = "Diego Hub", Content = "Sistema Diego Hub Totalmente Carregado!", Duration = 5})
