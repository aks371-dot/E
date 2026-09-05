local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("MiMenuPersonalizado") then
    CoreGui.MiMenuPersonalizado:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MiMenuPersonalizado"
gui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleMenuBtn"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
toggleBtn.Text = "MENU"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 13
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 25)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0, 170, 100)
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleLabel.Text = "   Steal a Egg | Custom Menu"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

local closeTitleBtn = Instance.new("TextButton")
closeTitleBtn.Size = UDim2.new(0, 28, 0, 28)
closeTitleBtn.Position = UDim2.new(1, -34, 0, 6)
closeTitleBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
closeTitleBtn.Text = "X"
closeTitleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeTitleBtn.Font = Enum.Font.SourceSansBold
closeTitleBtn.TextSize = 14
closeTitleBtn.Parent = titleLabel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeTitleBtn

local btnFarm = Instance.new("TextButton")
btnFarm.Size = UDim2.new(0.9, 0, 0, 38)
btnFarm.Position = UDim2.new(0.05, 0, 0.28, 0)
btnFarm.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
btnFarm.Text = "Auto-Farm: OFF"
btnFarm.TextColor3 = Color3.fromRGB(200, 200, 200)
btnFarm.Font = Enum.Font.SourceSansSemibold
btnFarm.TextSize = 15
btnFarm.Parent = mainFrame

local btnFarmCorner = Instance.new("UICorner")
btnFarmCorner.CornerRadius = UDim.new(0, 8)
btnFarmCorner.Parent = btnFarm

local btnGod = Instance.new("TextButton")
btnGod.Size = UDim2.new(0.9, 0, 0, 38)
btnGod.Position = UDim2.new(0.05, 0, 0.50, 0)
btnGod.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
btnGod.Text = "God Mode: OFF"
btnGod.TextColor3 = Color3.fromRGB(200, 200, 200)
btnGod.Font = Enum.Font.SourceSansSemibold
btnGod.TextSize = 15
btnGod.Parent = mainFrame

local btnGodCorner = Instance.new("UICorner")
btnGodCorner.CornerRadius = UDim.new(0, 8)
btnGodCorner.Parent = btnGod

local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)
closeTitleBtn.MouseButton1Click:Connect(toggleMenu)

local autoFarmActive = false
local godModeActive = false
local flySpeed = 50
local currentTween = nil
local godConnection = nil

local RarityPriority = {["Secret"] = 5, ["Mythic"] = 4, ["Legendary"] = 3, ["Epic"] = 2, ["Rare"] = 1}

local function getBestEgg()
    local bestEgg, highestPriority = nil, 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            for rarityName, priority in pairs(RarityPriority) do
                local matchesName = string.find(string.lower(obj.Name), string.lower(rarityName))
                local matchesAttr = obj:GetAttribute("Rarity") and string.find(string.lower(tostring(obj:GetAttribute("Rarity"))), string.lower(rarityName))
                if (matchesName or matchesAttr) and priority > highestPriority then
                    bestEgg = obj
                    highestPriority = priority
                end
            end
        end
    end
    return bestEgg
end

local function flyTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local dist = (root.Position - targetCFrame.Position).Magnitude
    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(root, TweenInfo.new(dist / flySpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame * CFrame.new(0, 3, 0)})
    currentTween:Play()
    return currentTween
end

btnFarm.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        btnFarm.Text = "Auto-Farm: ON"
        btnFarm.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        btnFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        task.spawn(function()
            while autoFarmActive do
                local target = getBestEgg()
                if target and target:IsDescendantOf(Workspace) then
                    local cf = target:IsA("Model") and target:GetPivot() or target.CFrame
                    local tw = flyTo(cf)
                    if tw then tw.Completed:Wait() end
                end
                task.wait(0.5)
            end
        end)
    else
        btnFarm.Text = "Auto-Farm: OFF"
        btnFarm.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btnFarm.TextColor3 = Color3.fromRGB(200, 200, 200)
        if currentTween then currentTween:Cancel() end
    end
end)

btnGod.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        btnGod.Text = "God Mode: ON"
        btnGod.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        btnGod.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        godConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
            end
        end)
    else
        btnGod.Text = "God Mode: OFF"
        btnGod.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btnGod.TextColor3 = Color3.fromRGB(200, 200, 200)
        if godConnection then godConnection:Disconnect() godConnection = nil end
    end
end)
