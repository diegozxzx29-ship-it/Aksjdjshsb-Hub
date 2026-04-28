local Players = game:GetService("Players")  
local TweenService = game:GetService("TweenService")  
local UserInputService = game:GetService("UserInputService")  
local RunService = game:GetService("RunService")  
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer  
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()  
local Humanoid = Character:WaitForChild("Humanoid")  
local RootPart = Character:WaitForChild("HumanoidRootPart")

local GUI = Instance.new("ScreenGui")  
GUI.Name = "OmnipotentScriptGUI"  
GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")  
MainFrame.Size = UDim2.new(0.38, 0, 0.6, 0)  
MainFrame.Position = UDim2.new(0.01, 0, 0.03, 0)  
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  
MainFrame.BorderSizePixel = 2  
MainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)  
MainFrame.Parent = GUI

local Title = Instance.new("TextLabel")  
Title.Size = UDim2.new(1, 0, 0.08, 0)  
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
Title.TextColor3 = Color3.new(1, 1, 1)  
Title.Text = "OMNIPOTENT SCRIPT"  
Title.Font = Enum.Font.GothamBold  
Title.TextSize = 18  
Title.Parent = MainFrame

local TabFrame = Instance.new("Frame")  
TabFrame.Size = UDim2.new(1, 0, 0.05, 0)  
TabFrame.Position = UDim2.new(0, 0, 0.08, 0)  
TabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  
TabFrame.BorderSizePixel = 0  
TabFrame.Parent = MainFrame

local TabButtons = {}  
local TabContents = {}

local TabNames = {"Main", "Teleport/Aimbot", "Saved Positions"}  
for i, name in ipairs(TabNames) do  
    local TabButton = Instance.new("TextButton")  
    TabButton.Size = UDim2.new(0.33, 0, 1, 0)  
    TabButton.Position = UDim2.new((i-1)*0.33, 0, 0, 0)  
    TabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)  
    TabButton.TextColor3 = Color3.new(1, 1, 1)  
    TabButton.Text = name  
    TabButton.Font = Enum.Font.Gotham  
    TabButton.TextSize = 14  
    TabButton.Parent = TabFrame  
      
    local TabContent = Instance.new("Frame")  
    TabContent.Size = UDim2.new(1, 0, 0.87, 0)  
    TabContent.Position = UDim2.new(0, 0, 0.13, 0)  
    TabContent.BackgroundTransparency = 1  
    TabContent.Visible = false  
    TabContent.Parent = MainFrame  
      
    TabButtons[name] = TabButton  
    TabContents[name] = TabContent  
      
    TabButton.MouseButton1Click:Connect(function()  
        for _, content in pairs(TabContents) do  
            content.Visible = false  
        end  
        TabContent.Visible = true  
        for _, btn in pairs(TabButtons) do  
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)  
        end  
        TabButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)  
    end)  
end  
TabButtons["Main"].BackgroundColor3 = Color3.fromRGB(90, 90, 90)  
TabContents["Main"].Visible = true

local ScrollFrameMain = Instance.new("ScrollingFrame")  
ScrollFrameMain.Size = UDim2.new(1, 0, 1, 0)  
ScrollFrameMain.BackgroundTransparency = 1  
ScrollFrameMain.ScrollingEnabled = true  
ScrollFrameMain.CanvasSize = UDim2.new(0, 0, 0, 600)  
ScrollFrameMain.Parent = TabContents["Main"]

local FlyFrame = Instance.new("Frame")  
FlyFrame.Size = UDim2.new(1, 0, 0, 120)  
FlyFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)  
FlyFrame.BorderSizePixel = 0  
FlyFrame.Parent = ScrollFrameMain

local FlyTitle = Instance.new("TextLabel")  
FlyTitle.Size = UDim2.new(1, 0, 0.2, 0)  
FlyTitle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)  
FlyTitle.TextColor3 = Color3.new(1, 1, 1)  
FlyTitle.Text = "Fly Settings"  
FlyTitle.Font = Enum.Font.Gotham  
FlyTitle.TextSize = 16  
FlyTitle.Parent = FlyFrame

local FlyToggleButton = Instance.new("TextButton")  
FlyToggleButton.Size = UDim2.new(0.4, 0, 0.3, 0)  
FlyToggleButton.Position = UDim2.new(0.05, 0, 0.25, 0)  
FlyToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
FlyToggleButton.TextColor3 = Color3.new(1, 1, 1)  
FlyToggleButton.Text = "Fly: OFF"  
FlyToggleButton.Font = Enum.Font.Gotham  
FlyToggleButton.TextSize = 14  
FlyToggleButton.Parent = FlyFrame

local FlySpeedLabel = Instance.new("TextLabel")  
FlySpeedLabel.Size = UDim2.new(0.4, 0, 0.3, 0)  
FlySpeedLabel.Position = UDim2.new(0.55, 0, 0.25, 0)  
FlySpeedLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
FlySpeedLabel.TextColor3 = Color3.new(1, 1, 1)  
FlySpeedLabel.Text = "Speed: 50"  
FlySpeedLabel.Font = Enum.Font.Gotham  
FlySpeedLabel.TextSize = 14  
FlySpeedLabel.Parent = FlyFrame

local FlySpeedUp = Instance.new("TextButton")  
FlySpeedUp.Size = UDim2.new(0.1, 0, 0.3, 0)  
FlySpeedUp.Position = UDim2.new(0.95, 0, 0.25, 0)  
FlySpeedUp.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
FlySpeedUp.TextColor3 = Color3.new(1, 1, 1)  
FlySpeedUp.Text = "+"  
FlySpeedUp.Font = Enum.Font.Gotham  
FlySpeedUp.TextSize = 14  
FlySpeedUp.Parent = FlyFrame

local FlySpeedDown = Instance.new("TextButton")  
FlySpeedDown.Size = UDim2.new(0.1, 0, 0.3, 0)  
FlySpeedDown.Position = UDim2.new(0.85, 0, 0.25, 0)  
FlySpeedDown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
FlySpeedDown.TextColor3 = Color3.new(1, 1, 1)  
FlySpeedDown.Text = "-"  
FlySpeedDown.Font = Enum.Font.Gotham  
FlySpeedDown.TextSize = 14  
FlySpeedDown.Parent = FlyFrame

local FlyHeightLabel = Instance.new("TextLabel")  
FlyHeightLabel.Size = UDim2.new(0.4, 0, 0.3, 0)  
FlyHeightLabel.Position = UDim2.new(0.05, 0, 0.65, 0)  
FlyHeightLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
FlyHeightLabel.TextColor3 = Color3.new(1, 1, 1)  
FlyHeightLabel.Text = "Height: 5"  
FlyHeightLabel.Font = Enum.Font.Gotham  
FlyHeightLabel.TextSize = 14  
FlyHeightLabel.Parent = FlyFrame

local FlyHeightUp = Instance.new("TextButton")  
FlyHeightUp.Size = UDim2.new(0.1, 0, 0.3, 0)  
FlyHeightUp.Position = UDim2.new(0.45, 0, 0.65, 0)  
FlyHeightUp.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
FlyHeightUp.TextColor3 = Color3.new(1, 1, 1)  
FlyHeightUp.Text = "+"  
FlyHeightUp.Font = Enum.Font.Gotham  
FlyHeightUp.TextSize = 14  
FlyHeightUp.Parent = FlyFrame

local FlyHeightDown = Instance.new("TextButton")  
FlyHeightDown.Size = UDim2.new(0.1, 0, 0.3, 0)  
FlyHeightDown.Position = UDim2.new(0.35, 0, 0.65, 0)  
FlyHeightDown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
FlyHeightDown.TextColor3 = Color3.new(1, 1, 1)  
FlyHeightDown.Text = "-"  
FlyHeightDown.Font = Enum.Font.Gotham  
FlyHeightDown.TextSize = 14  
FlyHeightDown.Parent = FlyFrame

local FlyControlsLabel = Instance.new("TextLabel")  
FlyControlsLabel.Size = UDim2.new(0.4, 0, 0.3, 0)  
FlyControlsLabel.Position = UDim2.new(0.55, 0, 0.65, 0)  
FlyControlsLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
FlyControlsLabel.TextColor3 = Color3.new(1, 1, 1)  
FlyControlsLabel.Text = "Controls: WAD"  
FlyControlsLabel.Font = Enum.Font.Gotham  
FlyControlsLabel.TextSize = 14  
FlyControlsLabel.Parent = FlyFrame

-- Other Feature Frames  
local features = {  
    {name = "Anti-Ragdoll", defaultState = false},  
    {name = "Instant Proximity Prompts", defaultState = false},  
    {name = "Blue ESP Box", defaultState = false},  
    {name = "White ESP Name", defaultState = false},  
    {name = "No Clip", defaultState = false},  
    {name = "Infinite Jump", defaultState = false},  
}

local featureStates = {}

for i, feature in ipairs(features) do  
    local FeatureFrame = Instance.new("Frame")  
    FeatureFrame.Size = UDim2.new(1, 0, 0, 50)  
    FeatureFrame.Position = UDim2.new(0, 0, 0, 120 + (i-1)*50)  
    FeatureFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)  
    FeatureFrame.BorderSizePixel = 0  
    FeatureFrame.Parent = ScrollFrameMain  
      
    local FeatureToggle = Instance.new("TextButton")  
    FeatureToggle.Size = UDim2.new(0.9, 0, 1, 0)  
    FeatureToggle.Position = UDim2.new(0.05, 0, 0, 0)  
    FeatureToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
    FeatureToggle.TextColor3 = Color3.new(1, 1, 1)  
    FeatureToggle.Text = feature.name .. ": OFF"  
    FeatureToggle.Font = Enum.Font.Gotham  
    FeatureToggle.TextSize = 14  
    FeatureToggle.Parent = FeatureFrame  
      
    featureStates[feature.name] = feature.defaultState  
      
    FeatureToggle.MouseButton1Click:Connect(function()  
        featureStates[feature.name] = not featureStates[feature.name]  
        FeatureToggle.Text = feature.name .. ": " .. (featureStates[feature.name] and "ON" or "OFF")  
        FeatureToggle.BackgroundColor3 = featureStates[feature.name] and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(80, 80, 80)  
    end)  
end

-- Teleport/Aimbot Tab  
local ScrollFrameTeleport = Instance.new("ScrollingFrame")  
ScrollFrameTeleport.Size = UDim2.new(1, 0, 1, 0)  
ScrollFrameTeleport.BackgroundTransparency = 1  
ScrollFrameTeleport.ScrollingEnabled = true  
ScrollFrameTeleport.CanvasSize = UDim2.new(0, 0, 0, 300)  
ScrollFrameTeleport.Parent = TabContents["Teleport/Aimbot"]

local PlayerListFrame = Instance.new("Frame")  
PlayerListFrame.Size = UDim2.new(1, 0, 0, 180)  
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)  
PlayerListFrame.BorderSizePixel = 0  
PlayerListFrame.Parent = ScrollFrameTeleport

local PlayerListTitle = Instance.new("TextLabel")  
PlayerListTitle.Size = UDim2.new(1, 0, 0.2, 0)  
PlayerListTitle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)  
PlayerListTitle.TextColor3 = Color3.new(1, 1, 1)  
PlayerListTitle.Text = "Player Teleport"  
PlayerListTitle.Font = Enum.Font.Gotham  
PlayerListTitle.TextSize = 16  
PlayerListTitle.Parent = PlayerListFrame

local PlayerScroll = Instance.new("ScrollingFrame")  
PlayerScroll.Size = UDim2.new(0.9,0,0.7,0)  
PlayerScroll.Position = UDim2.new(0.05,0,0.2,0)  
PlayerScroll.BackgroundColor3 = Color3.fromRGB(35,35,35)  
PlayerScroll.ScrollingEnabled = true  
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0)  
PlayerScroll.Parent = PlayerListFrame

local RefreshButton = Instance.new("TextButton")  
RefreshButton.Size = UDim2.new(0.9,0,0.1,0)  
RefreshButton.Position = UDim2.new(0.05,0,0.9,0)  
RefreshButton.BackgroundColor3 = Color3.fromRGB(80,80,80)  
RefreshButton.TextColor3 = Color3.new(1,1,1)  
RefreshButton.Text = "Refresh Players"  
RefreshButton.Font = Enum.Font.Gotham  
RefreshButton.TextSize = 14  
RefreshButton.Parent = PlayerListFrame

local AimbotFrame = Instance.new("Frame")  
AimbotFrame.Size = UDim2.new(1,0,0,80)  
AimbotFrame.Position = UDim2.new(0,0,0,180)  
AimbotFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)  
AimbotFrame.BorderSizePixel = 0  
AimbotFrame.Parent = ScrollFrameTeleport

local AimbotTitle = Instance.new("TextLabel")  
AimbotTitle.Size = UDim2.new(1,0,0.25,0)  
AimbotTitle.BackgroundColor3 = Color3.fromRGB(55,55,55)  
AimbotTitle.TextColor3 = Color3.new(1,1,1)  
AimbotTitle.Text = "Universal Aimbot"  
AimbotTitle.Font = Enum.Font.Gotham  
AimbotTitle.TextSize = 16  
AimbotTitle.Parent = AimbotFrame

local AimbotToggle = Instance.new("TextButton")  
AimbotToggle.Size = UDim2.new(0.9,0,0.75,0)  
AimbotToggle.Position = UDim2.new(0.05,0,0.25,0)  
AimbotToggle.BackgroundColor3 = Color3.fromRGB(80,80,80)  
AimbotToggle.TextColor3 = Color3.new(1,1,1)  
AimbotToggle.Text = "Aimbot: OFF"  
AimbotToggle.Font = Enum.Font.Gotham  
AimbotToggle.TextSize = 14  
AimbotToggle.Parent = AimbotFrame

-- Saved Positions Tab  
local ScrollFrameSaved = Instance.new("ScrollingFrame")  
ScrollFrameSaved.Size = UDim2.new(1,0,1,0)  
ScrollFrameSaved.BackgroundTransparency = 1  
ScrollFrameSaved.ScrollingEnabled = true  
ScrollFrameSaved.CanvasSize = UDim2.new(0,0,0,300)  
ScrollFrameSaved.Parent = TabContents["Saved Positions"]

local SavedPositions = {}

for i = 1, 2 do  
    local PosFrame = Instance.new("Frame")  
    PosFrame.Size = UDim2.new(1,0,0,100)  
    PosFrame.Position = UDim2.new(0,0,0,(i-1)*100)  
    PosFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)  
    PosFrame.BorderSizePixel = 0  
    PosFrame.Parent = ScrollFrameSaved  
      
    local PosTitle = Instance.new("TextLabel")  
    PosTitle.Size = UDim2.new(0.9,0,0.3,0)  
    PosTitle.Position = UDim2.new(0.05,0,0,0)  
    PosTitle.BackgroundColor3 = Color3.fromRGB(55,55,55)  
    PosTitle.TextColor3 = Color3.new(1,1,1)  
    PosVariTitle.Text = "Position " .. i  
    PosTitle.Font = Enum.Font.Gotham  
    PosTitle.TextSize = 16  
    PosTitle.Parent = PosFrame  
      
    local SaveButton = Instance.new("TextButton")  
    SaveButton.Size = UDim2.new(0.4,0,0.6,0)  
    SaveButton.Position = UDim2.new(0.05,0,0.3,0)  
    SaveButton.BackgroundColor3 = Color3.fromRGB(80,80,80)  
    SaveButton.TextColor3 = Color3.new(1,1,1)  
    SaveButton.Text = "Save Pos " .. i  
    SaveButton.Font = Enum.Font.Gotham  
    SaveButton.TextSize = 14  
    SaveButton.Parent = PosFrame  
      
    local TeleportButton = Instance.new("TextButton")  
    TeleportButton.Size = UDim2.new(0.4,0,0.6,0)  
    TeleportButton.Position = UDim2.new(0.55,0,0.3,0)  
    TeleportButton.BackgroundColor3 = Color3.fromRGB(80,80,80)  
    TeleportButton.TextColor3 = Color3.new(1,1,1)  
    TeleportButton.Text = "Teleport to Pos " .. i  
    TeleportButton.Font = Enum.Font.Gotham  
    TeleportButton.TextSize = 14  
    TeleportButton.Parent = PosFrame  
      
    SavedPositions[i] = nil  
      
    SaveButton.MouseButton1Click:Connect(function()  
        if RootPart then  
            SavedPositions[i] = RootPart.Position  
            SaveButton.Text = "Saved!"  
            SaveButton.BackgroundColor3 = Color3.fromRGB(100,100,100)  
            wait(1)  
            SaveButton.Text = "Save Pos " .. i  
            SaveButton.BackgroundColor3 = Color3.fromRGB(80,80,80)  
        end  
    end)  
      
    TeleportButton.MouseButton1Click:Connect(function()  
        if SavedPositions[i] and RootPart then  
            RootPart.CFrame = CFrame.new(SavedPositions[i])  
        end  
    end)  
end

-- Fly Variables  
local isFlying = false  
local flySpeed = 50  
local flyHeight = 5  
local flyControls = "WAD"

FlyToggleButton.MouseButton1Click:Connect(function()  
    isFlying = not isFlying  
    FlyToggleButton.Text = "Fly: " .. (isFlying and "ON" or "OFF")  
    FlyToggleButton.BackgroundColor3 = isFlying and Color3.fromRGB(100,100,100) or Color3.fromRGB(80,80,80)  
end)

FlySpeedUp.MouseButton1Click:Connect(function()  
    flySpeed = flySpeed + 5  
    FlySpeedLabel.Text = "Speed: " .. flySpeed  
end)

FlySpeedDown.MouseButton1Click:Connect(function()  
    flySpeed = math.max(5, flySpeed - 5)  
    FlySpeedLabel.Text = "Speed: " .. flySpeed  
end)

FlyHeightUp.MouseButton1Click:Connect(function()  
    flyHeight = flyHeight + 1  
    FlyHeightLabel.Text = "Height: " .. flyHeight  
end)

FlyHeightDown.MouseButton1Click:Connect(function()  
    flyHeight = math.max(1, flyHeight - 1)  
    FlyHeightLabel.Text = "Height: " .. flyHeight  
end)

-- Fly Functionality  
local flyConnection  
if isFlying then  
    flyConnection = RunService.RenderStepped:Connect(function()  
        if isFlying and RootPart then  
            local direction = Vector3.new(0,0,0)  
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then  
                direction = direction + (RootPart.CFrame.LookVector * flySpeed)  
            end  
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then  
                direction = direction - (RootPart.CFrame.LookVector * flySpeed)  
            end  
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then  
                direction = direction - (RootPart.CFrame.RightVector * flySpeed)  
            end  
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then  
                direction = direction + (RootPart.CFrame.RightVector * flySpeed)  
            end  
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then  
                direction = direction + Vector3.new(0,flyHeight,0)  
            end  
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then  
                direction = direction - Vector3.new(0,flyHeight,0)  
            end  
            RootPart.Velocity = direction  
        end  
    end)  
end

-- Anti-Ragdoll  
if featureStates["Anti-Ragdoll"] then  
    if Humanoid then  
        Humanoid:GetPropertyChangedSignal("State"):Connect(function()  
            if Humanoid.State == Enum.HumanoidStateType.Ragdoll then  
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)  
            end  
        end)  
    end  
end

-- Instant Proximity Prompts  
if featureStates["Instant Proximity Prompts"] then  
    local function bypassProximityPrompts()  
        for _, prompt in Workspace:GetDescendants() do  
            if prompt:IsA("ProximityPrompt") then  
                prompt.HoldDuration = 0  
            end  
        end  
    end  
    bypassProximityPrompts()  
    Workspace.DescendantAdded:Connect(function(child)  
        if child:IsA("ProximityPrompt") then  
            child.HoldDuration = 0  
        end  
    end)  
end

-- ESP Functions  
local ESPBoxes = {}  
local ESPNames = {}

if featureStates["Blue ESP Box"] then  
    local function createESPBox(player)  
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            local box = Instance.new("BoxHandleAdornment")  
            box.Name = "ESPBox_" .. player.Name  
            box.Adornee = player.Character.HumanoidRootPart  
            box.Size = player.Character.HumanoidRootPart.Size + Vector3.new(0.1,0.1,0.1)  
            box.Color3 = Color3.fromRGB(0,0,255)  
            box.Transparency = 0.5  
            box.ZIndex = 1  
            box.Parent = player.Character.HumanoidRootPart  
            ESPBoxes[player] = box  
        end  
    end  
      
    for _, player in Players:GetPlayers() do  
        if player ~= LocalPlayer then  
            createESPBox(player)  
        end  
    end  
      
    Players.PlayerAdded:Connect(function(player)  
        createESPBox(player)  
    end)  
      
    Players.PlayerRemoving:Connect(function(player)  
        if ESPBoxes[player] then  
            ESPBoxes[player]:Destroy()  
            ESPBoxes[player] = nil  
        end  
    end)  
end

if featureStates["White ESP Name"] then  
    local function createESPName(player)  
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            local billboard = Instance.new("BillboardGui")  
            billboard.Name = "ESPName_" .. player.Name  
            billboard.Adornee = player.Character.HumanoidRootPart  
            billboard.Size = UDim2.new(0,100,0,40)  
            billboard.StudsOffset = Vector3.new(0,3,0)  
            billboard.AlwaysOnTop = true  
              
            local label = Instance.new("TextLabel")  
            label.Size = UDim2.new(1,0,1,2,0)  
            label.BackgroundTransparency = 1  
            label.Text = player.Name  
            label.TextColor3 = Color3.new(1,1,1)  
            label.TextStrokeColor3 = Color3.new(0,0,0)  
            label.TextStrokeTransparency = 0.3  
            label.Font = Enum.Font.GothamBold  
            label.TextSize = 18  
            label.Parent = billboard  
              
            billboard.Parent = player.Character.HumanoidRootPart  
            ESPNames[player] = billboard  
        end  
    end  
      
    for _, player in Players:GetPlayers() do  
        if player ~= LocalPlayer then  
            createESPName(player)  
        end  
    end  
      
    Players.PlayerAdded:Connect(function(player)  
        createESPName(player)  
    end)  
      
    Players.PlayerRemoving:Connect(function(player)  
        if ESPNames[player] then  
            ESPNames[player]:Destroy()  
            ESPNames[player] = nil  
        end  
    end)  
end

-- No Clip  
if featureStates["No Clip"] then  
    local noclipConnection  
    noclipConnection = RunService.Stepped:Connect(function()  
        if Character then  
            for _, part in Character:GetDescendants() do  
                if p
