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

-- GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUniversalGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- FRAME PRINCIPAL
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- preto
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- vermelho
mainFrame.Parent = screenGui

-- Botão abrir/fechar menu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -40, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Barra para arrastar o menu
local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dragBar.Text = "by yNagrok - Clique e Arraste"
dragBar.TextColor3 = Color3.fromRGB(255, 255, 255)
dragBar.Font = Enum.Font.Gotham
dragBar.Parent = mainFrame

-- Variáveis para drag
local dragging, dragInput, dragStart, startPos

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Painéis e Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -70)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

local aimbotPanel = Instance.new("Frame")
aimbotPanel.Size = UDim2.new(1, 0, 1, 0)
aimbotPanel.BackgroundTransparency = 1
aimbotPanel.Parent = scrollFrame

local espPanel = Instance.new("Frame")
espPanel.Size = UDim2.new(1, 0, 1, 0)
espPanel.BackgroundTransparency = 1
espPanel.Visible = false
espPanel.Parent = scrollFrame

-- Abas no topo
local aimbotTab = Instance.new("TextButton")
aimbotTab.Size = UDim2.new(0, 160, 0, 30)
aimbotTab.Position = UDim2.new(0, 0, 0, 30)
aimbotTab.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
aimbotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotTab.Font = Enum.Font.GothamBold
aimbotTab.Text = "Aimbot"
aimbotTab.Parent = mainFrame

local espTab = Instance.new("TextButton")
espTab.Size = UDim2.new(0, 160, 0, 30)
espTab.Position = UDim2.new(0, 160, 0, 30)
espTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.Font = Enum.Font.GothamBold
espTab.Text = "ESP"
espTab.Parent = mainFrame

-- Função para mudar abas
local function ativarAba(aba)
    if aba == "aimbot" then
        aimbotPanel.Visible = true
        espPanel.Visible = false
        aimbotTab.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
        espTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
    else
        aimbotPanel.Visible = false
        espPanel.Visible = true
        aimbotTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        espTab.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
    end
end

aimbotTab.MouseButton1Click:Connect(function()
    ativarAba("aimbot")
end)

espTab.MouseButton1Click:Connect(function()
    ativarAba("esp")
end)

ativarAba("aimbot")

-- Funções para criar botões e labels
local function criarBotao(texto, parent, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.Text = texto
    btn.TextScaled = true
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function criarLabel(texto, parent, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 280, 0, 25)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.Text = texto
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

-- Variáveis do painel Aimbot
local aimbotToggleBtn = criarBotao("Aimbot: Desativado", aimbotPanel, 10, function()
    aimbotAtivo = not aimbotAtivo
    aimbotToggleBtn.Text = "Aimbot: " .. (aimbotAtivo and "Ativado" or "Desativado")
end)

local fovLabel = criarLabel("FOV: " .. fov, aimbotPanel, 60)

local fovUpBtn = criarBotao("+ FOV", aimbotPanel, 100, function()
    fov = math.min(fov + 25, fovMax)
    fovLabel.Text = "FOV: " .. fov
end)

local fovDownBtn = criarBotao("- FOV", aimbotPanel, 140, function()
    fov = math.max(fov - 25, fovMin)
    fovLabel.Text = "FOV: " .. fov
end)

local alvoLabel = criarLabel("Parte para mirar: " .. alvoParte, aimbotPanel, 190)

local function mudarAlvo(parte)
    alvoParte = parte
    alvoLabel.Text = "Parte para mirar: " .. alvoParte
end

local botaoCabeca = criarBotao("Cabeça", aimbotPanel, 230, function()
    mudarAlvo("Head")
end)

local botaoPeito = criarBotao("Peito", aimbotPanel, 270, function()
    mudarAlvo("HumanoidRootPart")
end)

local botaoPerna = criarBotao("Perna", aimbotPanel, 310, function()
    mudarAlvo("LeftLeg")
end)

-- Variáveis do painel ESP
local espToggleBtn = criarBotao("ESP: Desativado", espPanel, 10, function()
    espAtivo = not espAtivo
    espToggleBtn.Text = "ESP: " .. (espAtivo and "Ativado" or "Desativado")
end)

-- Controlar disparo (mouse e touch)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        segurandoTiro = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        segurandoTiro = false
    end
end)

-- Função para checar se player é inimigo (team check)
local function isEnemy(player)
    if not player.Team or not LocalPlayer.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

-- Obter alvo dentro do FOV e que seja inimigo
local function obterAlvo()
    local alvo, menorDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if isEnemy(plr) then
                local parte = plr.Character:FindFirstChild(alvoParte)
                if parte then
                    local pos, naTela = Camera:WorldToViewportPoint(parte.Position)
                    if naTela then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < menorDist and dist <= fov then
                            alvo = plr
                            menorDist = dist
                        end
                    end
                end
            end
        end
    end
    return alvo
end

-- Círculo FOV visual
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Color = Color3.fromRGB(255, 0, 0) -- vermelho
fovCircle.Thickness = 2
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Radius = fov

    if aimbotAtivo and segurandoTiro then
        local alvo = obterAlvo()
        if alvo and alvo.Character and alvo.Character:FindFirstChild(alvoParte) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvo.Character[alvoParte].Position)
        end
    end
end)

-- ESP com BoxHandleAdornment (bordas)
local espBoxes = {}

local function criarOuAtualizarESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            if isEnemy(plr) then
                if not espBoxes[plr] then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(3, 6, 1)
                    box.Color3 = Color3.new(1, 0, 0)
                    box.AlwaysOnTop = true
                    box.Adornee = plr.Character.HumanoidRootPart
                    box.ZIndex = 5
                    box.Parent = workspace
                    espBoxes[plr] = box
                else
                    espBoxes[plr].Adornee = plr.Character.HumanoidRootPart
                end
            else
                if espBoxes[plr] then
                    espBoxes[plr]:Destroy()
                    espBoxes[plr] = nil
                end
            end
        else
            if espBoxes[plr] then
                espBoxes[plr]:Destroy()
                espBoxes[plr] = nil
            end
        end
    end

    -- Remove boxes de jogadores que saíram
    for plr, box in pairs(espBoxes) do
        if not table.find(Players:GetPlayers(), plr) then
            box:Destroy()
            espBoxes[plr] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espAtivo then
        criarOuAtualizarESP()
    else
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end
end)
