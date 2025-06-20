-- Aimbot avançado - Menu arrastável, FOV circular, mira só ao atirar local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local LocalPlayer = Players.LocalPlayer local Camera = workspace.CurrentCamera

-- Configurações local aimbotAtivo = false local espAtivo = false local fov = 150 local fovMin, fovMax = 50, 400 local alvoParte = "Head" local segurandoTiro = false

-- GUI local playerGui = LocalPlayer:WaitForChild("PlayerGui") local screenGui = Instance.new("ScreenGui", playerGui) screenGui.Name = "AimbotGUI" screenGui.ResetOnSpawn = false

-- Frame arrastável do menu local frame = Instance.new("Frame", screenGui) frame.Size = UDim2.new(0, 250, 0, 300) frame.Position = UDim2.new(0, 100, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local dragging = false local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = frame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

RunService.Heartbeat:Connect(function() if dragging and dragInput then local delta = dragInput.Position - dragStart frame.Position = UDim2.new( startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y ) end end)

-- Botão helper local function criarBotao(text, posY, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -20, 0, 30) btn.Position = UDim2.new(0, 10, 0, posY) btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(50,50,50) btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.GothamBold btn.TextScaled = true btn.MouseButton1Click:Connect(callback) return btn end

local aimbotBtn = criarBotao("Ativar Aimbot", 10, function() aimbotAtivo = not aimbotAtivo aimbotBtn.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot" end)

criarBotao("+ FOV", 50, function() fov = math.min(fov + 25, fovMax) end) criarBotao("- FOV", 90, function() fov = math.max(fov - 25, fovMin) end)

criarBotao("Cabeça", 130, function() alvoParte = "Head" end) criarBotao("Peito", 170, function() alvoParte = "HumanoidRootPart" end) criarBotao("Perna", 210, function() alvoParte = "LeftLeg" end)

local espBtn = criarBotao("Ativar ESP", 250, function() espAtivo = not espAtivo espBtn.Text = espAtivo and "Desativar ESP" or "Ativar ESP" end)

-- FOV visual CIRCULAR perfeito local fovCircle = Drawing.new("Circle") fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) fovCircle.Radius = fov fovCircle.Color = Color3.fromRGB(255,0,0) fovCircle.Thickness = 2 fovCircle.Transparency = 0.5 fovCircle.Filled = false fovCircle.Visible = true

-- Detecção de tiro UserInputService.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then segurandoTiro = true end end)

UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then segurandoTiro = false end end)

-- Função de mira local function obterAlvo() local alvo, menorDist = nil, fov for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild(alvoParte) and plr.Character.Humanoid.Health > 0 then local pos, naTela = Camera:WorldToViewportPoint(plr.Character[alvoParte].Position) if naTela then local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude if dist < menorDist then alvo, menorDist = plr, dist end end end end return alvo end

-- ESP básico local espBoxes = {} local function criarESP(plr) local adorn = Instance.new("BoxHandleAdornment") adorn.Size = Vector3.new(4,6,1) adorn.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") adorn.Color3 = Color3.fromRGB(0,255,0) adorn.Transparency = 0.5 adorn.AlwaysOnTop = true adorn.ZIndex = 10 adorn.Parent = Camera return adorn end

RunService.RenderStepped:Connect(function() -- Atualizar círculo do FOV fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) fovCircle.Radius = fov

-- Atualizar ESP for plr, box in pairs(espBoxes) do if not espAtivo or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then box:Destroy() espBoxes[plr] = nil else box.Adornee = plr.Character.HumanoidRootPart end end if espAtivo then for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and not espBoxes[plr] and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then espBoxes[plr] = criarESP(plr) end end end -- Aimbot só enquanto segurando o tiro if aimbotAtivo and segurandoTiro then local alvo = obterAlvo() if alvo and alvo.Character and alvo.Character:FindFirstChild(alvoParte) then Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvo.Character[alvoParte].Position) end end 

end)

-- Inicialização visual espBtn.Text = "Ativar ESP" aimbotBtn.Text = "Ativar Aimbot"

