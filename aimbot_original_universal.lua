-- Aimbot Universal Roblox - Compatível com qualquer jogo, seguro contra erros
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotAtivo = false
local fov = 150
local fovMin, fovMax = 50, 400
local alvoParte = "Head"
local segurandoTiro = false

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AimbotUniversalGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function criarBotao(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local aimbotBtn = criarBotao("Ativar Aimbot", 10, function()
    aimbotAtivo = not aimbotAtivo
    aimbotBtn.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot"
end)
criarBotao("+ FOV", 50, function() fov = math.min(fov + 25, fovMax) end)
criarBotao("- FOV", 90, function() fov = math.max(fov - 25, fovMin) end)
criarBotao("Cabeça", 130, function() alvoParte = "Head" end)
criarBotao("Peito", 170, function() alvoParte = "HumanoidRootPart" end)
criarBotao("Perna", 210, function() alvoParte = "LeftLeg" end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then segurandoTiro = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then segurandoTiro = false end
end)

local function obterAlvo()
    local alvo, menorDist = nil, fov
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local parte = plr.Character:FindFirstChild(alvoParte)
            if parte then
                local pos, naTela = Camera:WorldToViewportPoint(parte.Position)
                if naTela then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < menorDist then alvo, menorDist = plr, dist end
                end
            end
        end
    end
    return alvo
end

RunService.RenderStepped:Connect(function()
    if aimbotAtivo and segurandoTiro then
        local alvo = obterAlvo()
        if alvo and alvo.Character and alvo.Character:FindFirstChild(alvoParte) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvo.Character[alvoParte].Position)
        end
    end
end)

aimbotBtn.Text = "Ativar Aimbot"
