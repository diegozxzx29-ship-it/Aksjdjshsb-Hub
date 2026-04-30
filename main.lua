local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Diego Hub",
   LoadingTitle = "Diego Hub",
   LoadingSubtitle = "Carregando todas as funções...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DiegoHubConfig", 
      FileName = "MainConfig"
   },
   KeySystem = false
})

-- // VARIÁVEIS DE CONTROLE // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.AimbotEnabled = false
_G.AimPart = "Head"
_G.ESP_Ativo = false
_G.AntiRagdoll = false
_G.InfiniteJump = false
_G.InstantPrompt = false
_G.TargetPlayerTP = ""
local NoclipConn = nil

-- // SCRIPTS EXTERNOS // --
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/UselessManS90/TriggerBot/main/TriggBot"))()
    loadstring(game:HttpGet("https://pastebin.com/raw/KiSYpej6", true))()
end)

-- // ABA COMBATE // --
local CombatTab = Window:CreateTab("Combate", 4483362458)

CombatTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Callback = function(Value) _G.AimbotEnabled = Value end,
})

CombatTab:CreateDropdown({
   Name = "Alvo da Mira",
   Options = {"Cabeça", "Corpo", "Pés"},
   CurrentOption = {"Cabeça"},
   Callback = function(Option)
      if Option[1] == "Cabeça" then _G.AimPart = "Head"
      elseif Option[1] == "Corpo" then _G.AimPart = "HumanoidRootPart"
      elseif Option[1] == "Pés" then _G.AimPart = "LeftFoot" end
   end,
})

CombatTab:CreateButton({
   Name = "Ativar God Mode",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
   end,
})

-- // ABA TELEPORTE // --
local TPTab = Window:CreateTab("Teleporte", 4483362458)

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
   Name = "Teleportar / Atualizar Lista",
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
MoveTab:CreateButton({Name = "Ativar Fly", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end})

-- // ABA VISUAL & OUTROS // --
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateToggle({Name = "Interação Instantânea (E)", Callback = function(Value) _G.InstantPrompt = Value end})
MiscTab:CreateButton({Name = "Server Hop", Callback = function() TeleportService:Teleport(game.PlaceId, player) end})

-- // LÓGICAS GLOBAIS // --

-- Loop do Aimbot
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

Rayfield:Notify({Title = "Diego Hub", Content = "Todas as funções foram integradas!", Duration = 5})
