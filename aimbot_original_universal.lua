-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configurações básicas
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

-- FRAME PRINCIPAL com borda vermelha
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.Parent = screenGui

-- ScrollingFrame para o conteúdo rolável
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -80)
scrollFrame.Position = UDim2.new(0, 10, 0, 70)
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- altura dupla para rolar
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

-- Barra para arrastar o menu
local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
dragBar.Text = "by yNagrok - Clique e Arraste"
dragBar.TextColor3 = Color3.fromRGB(255,255,255)
dragBar.Font = Enum.Font.Gotham
dragBar.Parent = mainFrame

-- Botão para fechar/abrir o menu
local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 80, 0, 30)
toggleMenuBtn.Position = UDim2.new(1, -85, 0, 0)
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(70,0,0)
toggleMenuBtn.TextColor3 = Color3.new(1,1,1)
toggleMenuBtn.Font = Enum.Font.GothamBold
toggleMenuBtn.Text = "Fechar"
toggleMenuBtn.Parent = screenGui

local menuVisivel = true
toggleMenuBtn.MouseButton1Click:Connect(function()
    menuVisivel = not menuVisivel
    mainFrame.Visible = menuVisivel
    toggleMenuBtn.Text = menuVisivel and "Fechar" or "Abrir"
end)

-- Variáveis de drag
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

-- Criar botões funcionais reutilizáveis (que vão para scrollFrame)
local function criarBotao(texto, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.Text = texto
    btn.TextScaled = true
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function criarLabel(texto, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 280, 0, 25)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.Text = texto
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = scrollFrame
    return label
end

-- Variáveis do script
local aimbotTabAtivo = true
local espTabAtivo = false

-- Abas
local aimbotTab = Instance.new("TextButton")
aimbotTab.Size = UDim2.new(0, 160, 0, 30)
aimbotTab.Position = UDim2.new(0, 0, 0, 35)
aimbotTab.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
aimbotTab.TextColor3 = Color3.fromRGB(255,255,255)
aimbotTab.Font = Enum.Font.GothamBold
aimbotTab.Text = "Aimbot"
aimbotTab.Parent = mainFrame

local espTab = Instance.new("TextButton")
espTab.Size = UDim2.new(0, 160, 0, 30)
espTab.Position = UDim2.new(0, 160, 0, 35)
espTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
espTab.TextColor3 = Color3.fromRGB(255,255,255)
espTab.Font = Enum.Font.GothamBold
espTab.Text = "ESP"
espTab.Parent = mainFrame

local function mostrarAimbot()
    scrollFrame:ClearAllChildren()
    -- Conteúdo Aimbot
    local y = 10
    local aimbotToggleBtn = criarBotao("Aimbot: "..(aimbotAtivo and "Ativado" or "Desativado"), y, function()
        aimbotAtivo = not aimbotAtivo
        aimbotToggleBtn.Text = "Aimbot: "..(aimbotAtivo and "Ativado" or "Desativado")
    end)
    y = y + 50

    local fovLabel = criarLabel("FOV: "..fov, y)
    y = y + 40

    local fovUpBtn = criarBotao("+ FOV", y, function()
        fov = math.min(fov + 25, fovMax)
        fovLabel.Text = "FOV: "..fov
    end)
    y = y + 40

    local fovDownBtn = criarBotao("- FOV", y, function()
        fov = math.max(fov - 25, fovMin)
        fovLabel.Text = "FOV: "..fov
    end)
    y = y + 50

    local alvoLabel = criarLabel("Parte para mirar: "..alvoParte, y)
    y = y + 40

    local botaoCabeca = criarBotao("Cabeça", y, function()
        alvoParte = "Head"
        alvoLabel.Text = "Parte para mirar: "..alvoParte
    end)
    y = y + 40

    local botaoPeito = criarBotao("Peito", y, function()
        alvoParte = "HumanoidRootPart"
        alvoLabel.Text = "Parte para mirar: "..alvoParte
    end)
    y = y + 40

    local botaoPerna = criarBotao("Perna", y, function()
        alvoParte = "LeftLeg"
        alvoLabel.Text = "Parte para mirar: "..alvoParte
    end)
end

local function mostrarESP()
    scrollFrame:ClearAllChildren()
    local y = 10
    local espToggleBtn = criarBotao("ESP: "..(espAtivo and "Ativado" or "Desativado"), y, function()
        espAtivo = not espAtivo
        espToggleBtn.Text = "ESP: "..(espAtivo and "Ativado" or "Desativado")
    end)
end

aimbotTab.MouseButton1Click:Connect(function()
    aimbotTab.BackgroundColor3 = Color3.fromRGB(70,0,0)
    espTab.BackgroundColor3 = Color3.fromRGB(20,20,20)
    aimbotTabAtivo = true
    espTabAtivo = false
    mostrarAimbot()
end)

espTab.MouseButton1Click:Connect(function()
    espTab.BackgroundColor3 = Color3.fromRGB(70,0,0)
    aimbotTab.BackgroundColor3 = Color3.fromRGB(20,20,20)
    espTabAtivo = true
    aimbotTabAtivo = false
    mostrarESP()
end)

mostrarAimbot()

-- Controle disparo (mouse e touch)
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

-- Função para obter alvo com team check
local function obterAlvo()
    local alvo, menorDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if LocalPlayer.Team and plr.Team and plr.Team == LocalPlayer.Team then
                -- Ignorar aliados
            else
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
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    fovCircle.Radius = fov

    if aimbotAtivo and segurandoTiro then
        local alvo = obterAlvo()
        if alvo and alvo.Character and alvo.Character:FindFirstChild(alvoParte) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvo.Character[alvoParte].Position)
        end
    end
end)

-- ESP com SurfaceGui bordado
local espBoxes = {}

local function criarOuAtualizarESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            if LocalPlayer.Team and plr.Team and plr.Team == LocalPlayer.Team then
                if espBoxes[plr] then
                    espBoxes[plr]:Destroy()
                    espBoxes[plr] = nil
                end
            else
                if not espBoxes[plr] then
                    local surfaceGui = Instance.new("SurfaceGui")
                    surfaceGui.Face = Enum.NormalId.Front
                    surfaceGui.Adornee = plr.Character.HumanoidRootPart
                    surfaceGui.AlwaysOnTop = true
                    surfaceGui.Parent = plr.Character.HumanoidRootPart

                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundTransparency = 1
                    frame.BorderColor3 = Color3.new(1,0,0)
                    frame.BorderSizePixel = 2
                    frame.Parent = surfaceGui

                    espBoxes[plr] = surfaceGui
                end
            end
        else
            if espBoxes[plr] then
                espBoxes[plr]:Destroy()
                espBoxes[plr] = nil
            end
        end
    end

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
