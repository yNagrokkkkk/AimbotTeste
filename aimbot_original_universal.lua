-- Serviços

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer


-- Configurações

local fov = 150

local fovMin, fovMax = 50, 400

local alvoParte = "Head"

local aimbotAtivo = false

local espAtivo = false

local segurandoTiro = false

local teamCheck = true


-- GUI

local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "AimbotUniversalGUI"

screenGui.ResetOnSpawn = false

screenGui.Parent = playerGui


-- Menu principal com scroll

local scrollFrame = Instance.new("ScrollingFrame")

scrollFrame.Size = UDim2.new(0, 320, 0, 400)

scrollFrame.Position = UDim2.new(0, 50, 0, 50)

scrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

scrollFrame.BorderSizePixel = 2

scrollFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)

scrollFrame.ScrollBarThickness = 6

scrollFrame.Parent = screenGui


-- Botão abrir/fechar

local menuAberto = true

local toggleMenuBtn = Instance.new("TextButton", screenGui)

toggleMenuBtn.Size = UDim2.new(0, 120, 0, 30)

toggleMenuBtn.Position = UDim2.new(1, -130, 0, 10)

toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

toggleMenuBtn.TextColor3 = Color3.new(1,1,1)

toggleMenuBtn.Font = Enum.Font.GothamBold

toggleMenuBtn.TextScaled = true

toggleMenuBtn.Text = "Fechar Menu"


toggleMenuBtn.MouseButton1Click:Connect(function()

menuAberto = not menuAberto

scrollFrame.Visible = menuAberto

toggleMenuBtn.Text = menuAberto and "Fechar Menu" or "Abrir Menu"

end)


-- Barra de arrastar

local dragBar = Instance.new("TextLabel", scrollFrame)

dragBar.Size = UDim2.new(1,0,0,30)

dragBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

dragBar.Text = "by yNagrok - Clique e Arraste"

dragBar.TextColor3 = Color3.new(1,1,1)

dragBar.Font = Enum.Font.Gotham


dragBar.Active = true

dragBar.Draggable = true


-- Função botão padrão

local function criarBotao(txt, parent, pos, callback)

local btn = Instance.new("TextButton", parent)

btn.Size = UDim2.new(0, 140, 0, 30)

btn.Position = pos

btn.BackgroundColor3 = Color3.fromRGB(50,50,50)

btn.TextColor3 = Color3.new(1,1,1)

btn.Font = Enum.Font.GothamBold

btn.TextScaled = true

btn.Text = txt

btn.MouseButton1Click:Connect(callback)

return btn

end


-- Abas

local aimbotPanel = Instance.new("Frame", scrollFrame)

aimbotPanel.Size = UDim2.new(1, -20, 0, 550)

aimbotPanel.Position = UDim2.new(0, 10, 0, 40)

aimbotPanel.BackgroundTransparency = 1


local espPanel = Instance.new("Frame", scrollFrame)

espPanel.Size = UDim2.new(1, -20, 0, 550)

espPanel.Position = UDim2.new(0, 10, 0, 40)

espPanel.BackgroundTransparency = 1

espPanel.Visible = false


local aimbotTab = criarBotao("Aimbot", scrollFrame, UDim2.new(0, 10, 0, 5), function()

aimbotPanel.Visible = true

espPanel.Visible = false

end)


local espTab = criarBotao("ESP", scrollFrame, UDim2.new(0, 170, 0, 5), function()

aimbotPanel.Visible = false

espPanel.Visible = true

end)


-- Botões AIMBOT

local aimbotBtn = criarBotao("Aimbot: Desativado", aimbotPanel, UDim2.new(0, 0, 0, 10), function()

aimbotAtivo = not aimbotAtivo

aimbotBtn.BackgroundColor3 = aimbotAtivo and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)

aimbotBtn.Text = "Aimbot: "    .. (aimbotAtivo    and "Ativado" or "Desativado")

end)

aimbotBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)


local fovLabel = Instance.new("TextLabel", aimbotPanel)

fovLabel.Size = UDim2.new(1, 0, 0, 25)

fovLabel.Position = UDim2.new(0, 0, 0, 50)

fovLabel.BackgroundTransparency = 1

fovLabel.TextColor3 = Color3.new(1,1,1)

fovLabel.Font = Enum.Font.Gotham

fovLabel.Text = "FOV: " .. fov

fovLabel.TextScaled = true


criarBotao("+ FOV", aimbotPanel, UDim2.new(0, 0, 0, 80), function()

fov = math.min(fov + 25, fovMax)

fovLabel.Text = "FOV: " .. fov

end)


criarBotao("- FOV", aimbotPanel, UDim2.new(0, 150, 0, 80), function()

fov = math.max(fov - 25, fovMin)

fovLabel.Text = "FOV: " .. fov

end)


-- Seleção parte mirar

local alvoLabel = Instance.new("TextLabel", aimbotPanel)

alvoLabel.Size = UDim2.new(1,0,0,25)

alvoLabel.Position = UDim2.new(0,0,0,120)

alvoLabel.BackgroundTransparency = 1

alvoLabel.TextColor3 = Color3.new(1,1,1)

alvoLabel.Font = Enum.Font.Gotham

alvoLabel.Text = "Parte: "..alvoParte

alvoLabel.TextScaled = true


local function mudarAlvo(parte)

alvoParte = parte

alvoLabel.Text = "Parte: "..alvoParte

end


criarBotao("Cabeça", aimbotPanel, UDim2.new(0,0,0,150), function()

mudarAlvo("Head")

end)

criarBotao("Peito", aimbotPanel, UDim2.new(0,0,0,180), function()

mudarAlvo("HumanoidRootPart")

end)

criarBotao("Perna", aimbotPanel, UDim2.new(0,0,0,210), function()

mudarAlvo("LeftLeg")

end)


-- Botão ESP

local espBtn = criarBotao("ESP: Desativado", espPanel, UDim2.new(0, 0, 0, 10), function()

espAtivo = not  espAtivo

espBtn.BackgroundColor3 = espAtivo and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)

espBtn.Text = "ESP: " .. (espAtivo and "Ativado" or "Desativado")

end)

espBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)


-- Input tiro

UserInputService.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

segurandoTiro = true

end

end)

UserInputService.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

segurandoTiro = false

end

end)


-- Função obter alvo

local function  obterAlvo()

local alvo, menorDist = nil, fov

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then

local parte = plr.Character:FindFirstChild(alvoParte)

if parte then

local pos, naTela = Camera:WorldToViewportPoint(parte.Position)

if naTela then

local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

if dist < menorDist then

alvo, menorDist = plr, dist

end

end

end

end

end

return    alvo  

end


-- FOV círculo

local fovCircle = Drawing.new("Circle")

fovCircle.Visible = true

fovCircle.Color = Color3.fromRGB(255,0,0)

fovCircle.Thickness = 2

fovCircle.Filled = false


RunService.RenderStepped:Connect(function()

fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

fovCircle.Radius = fov

if aimbotAtivo and   segurandoTiro   then

    alvo = obterAlvo()  

if   alvo   and alvo.Character and alvo.Character:FindFirstChild(alvoParte) then

Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvo.Character[alvoParte].Position)

end

end

end)


-- ESP borda

local espBoxes = {}

local function   atualizarESP() 

for _, box in pairs(espBoxes) do

if box then box:Destroy() end

end

table.clear(espBoxes)


if not   espAtivo   then return end


for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then

local box = Instance.new("BoxHandleAdornment")

box.Size = Vector3.new(3,6,1)

box.Color3 = Color3.new(1,0,0)

box.Transparency = 1

box.AlwaysOnTop = true

box.ZIndex = 5

box.Adornee = plr.Character.HumanoidRootPart

-- Configurações

FOV local = 150

end

end

end


RunService.RenderStepped:Connect(atualizarESP)

