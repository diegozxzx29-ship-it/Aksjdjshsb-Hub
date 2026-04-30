local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Diego Hub",
   LoadingTitle = "Diego Hub",
   LoadingSubtitle = "Carregando módulos e scripts externos...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DiegoHubConfig", 
      FileName = "MainConfig"
   },
   KeySystem = false
})

-- // SERVIÇOS // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- // VARIÁVEIS DE CONTROLE // --
_G.AimbotEnabled = false
_G.AimPart = "Head"
_G.ESP_Ativo = false
_G.AntiRagdoll = false
_G.InfiniteJump = false
_G.InstantPrompt = false
_G.SavedPosition = nil
_G.LoopTeleport = false
local NoclipConn = nil

-- // CARREGAMENTO DE SCRIPTS EXTERNOS // --
-- TriggerBot (Créditos: xHeptc / Xiba)
loadstring(game:HttpGet("https://raw.githubusercontent.com/UselessManS90/TriggerBot/main/TriggBot"))()
-- Script Adicional (Pastebin)
loadstring(game:HttpGet("https://pastebin.com/raw/KiSYpej6",true))()

-- // ABA STATUS // --
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

-- // ABA TELEPORTE // --
local TPTab = Window:CreateTab("Teleporte", 4483362458)

local PlayerDropdown = TPTab:CreateDropdown({
   Name = "Selecionar Jogador",
   Options = {}, 
   Callback = function(Option) _G.TargetPlayerTP = Option[1] end,
})

TPTab:CreateButton({
   Name = "Atualizar Lista / Teleportar",
   Callback = function()
       local names = {}
       for _, v in pairs(Players:GetPlayers()) do if v ~= player then table.insert(names, v.Name) end end
       PlayerDropdown:Refresh(names, true)
       
       if _G.TargetPlayerTP then
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

MoveTab:CreateToggle({Name = "Infinite Jump", Callback = function(Value) _G.InfiniteJump = Value end})
MoveTab:CreateToggle({Name = "Anti-Ragdoll", Callback = function(Value) _G.AntiRagdoll = Value end})

MoveTab:CreateButton({
   Name = "Painel de Voo (Fly)",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
   end,
})

-- // LÓGICAS GLOBAIS // --
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if _G.InstantPrompt then fireproximityprompt(prompt) end
end)

Rayfield:Notify({
   Title = "Diego Hub",
   Content = "TriggerBot e módulos prontos!",
   Duration = 5,
})
