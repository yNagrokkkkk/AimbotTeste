-- Aimbot Universal Roblox COMPLETO - Mobile Compatível - By yNagrok -- Recursos: Menu móvel, fechar/abrir, FOV circular, indicador status, ESP toggle

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Camera = workspace.CurrentCamera local LocalPlayer = Players.LocalPlayer

-- CONFIGS local fov = 150 local fovMin, fovMax = 50, 400 local alvoParte = "Head" local aimbotAtivo = false local espAtivo = false local segurandoTiro = false

-- GUI local playerGui = LocalPlayer:WaitForChild("PlayerGui") local screenGui = Instance.new("ScreenGui", playerGui) screenGui.Name = "AimbotUniversalGUI" screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui) mainFrame.Size = UDim2.new(0, 250, 0, 350) mainFrame.Position = UDim2.new(0, 50, 0, 50) mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20) mainFrame.BorderSizePixel = 0

local dragBar = Instance.new("TextLabel", mainFrame) dragBar.Size = UDim2.new(1,0,0,30) dragBar.BackgroundColor3 = Color3.fromRGB(40,40,40) dragBar.Text = "by yNagrok - Clique e Arraste" dragBar.TextColor3 = Color3.new(1,1,1) dragBar.Font = Enum.Font.Gotham

local dragging, dragInput, dragStart, startPos

dragBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

dragBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

RunService.Heartbeat:Connect(function() if dragging and dragInput then local delta = dragInput.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local function criarBotao(txt, posY, callback) local btn = Instance.new("TextButton", mainFrame) btn.Size = UDim2.new(1, -20, 0, 30) btn.Position = UDim2.new(0, 10, 0, posY) btn.Text = txt btn.BackgroundColor3 = Color3.fromRGB(50,50,50) btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.GothamBold btn.TextScaled = true btn.MouseButton1Click:Connect(callback) return btn end

local menuVisivel = true local toggleBtn = criarBotao("Fechar Menu", 40, function() menuVisivel = not menuVisivel for _,v in ipairs(mainFrame:GetChildren()) do if v:IsA("TextButton") and v ~= toggleBtn then v.Visible = menuVisivel end end toggleBtn.Text = menuVisivel and "Fechar Menu" or "Abrir Menu" end)

local aimbotBtn = criarBotao("Ativar Aimbot", 80, function() aimbotAtivo = not aimbotAtivo aimbotBtn.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot" end)

local espBtn = criarBotao("Ativar ESP", 120, function() espAtivo = not espAtivo espBtn.Text = espAtivo and "Desativar ESP" or "Ativar ESP" end)

criarBotao("+ FOV", 160, function() fov = math.min(fov + 25, fovMax) end) criarBotao("- FOV", 200, function() fov = math.max(fov - 25, fovMin) end) criarBotao("Cabeça", 240, function() alvoParte = "Head" end) criarBotao("Peito", 280, function() alvoParte = "HumanoidRootPart" end) criarBotao("Perna", 320, function() alvoParte = "LeftLeg" end)

-- INPUT Tiro UserInputService.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then segurandoTiro = true end end) UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then segurandoTiro = false end end)

-- ESP local espBoxes = {} function atualizarESP() for _,v in pairs(espBoxes) do if v and v.Adornee then v:Destroy() end end table.clear(espBoxes)

if not espAtivo then return end for _,plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then local box = Instance.new("BoxHandleAdornment") box.Size = Vector3.new(3,6,1) box.Color3 = Color3.new(1,0,0) box.AlwaysOnTop = true box.Adornee = plr.Character.HumanoidRootPart box.ZIndex = 5 box.Parent = workspace table.insert(espBoxes, box) end end 

end

RunService.RenderStepped:Connect(atualizarESP)

-- Aimbot local function obterAlvo() local alvo, menorDist = nil, fov for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then local parte = plr.Character:FindFirstChild(alvoParte) if parte then local pos, naTela = Camera:WorldToViewportPoint(parte.Position) if naTela then local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude if dist < menorDist then alvo, menorDist = plr, dist end end end end end return alvo end

-- FOV Círculo local fovCircle = Drawing.new("Circle") fovCircle.Visible = true fovCircle.Color = Color3.fromRGB(0,255,0) fovCircle.Thickness = 2 fovCircle.Filled = false

RunService.RenderStepped:Connect(function() fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) fovCircle.Radius = fov

if aimbotAtivo and segurandoTiro then local alvo = obterAlvo() if alvo and alvo.Character and alvo.Character:FindFirstChild(alvoParte) then Camera.CFrame = CFrame.new(Camera.CFrame.Position, alvo.Character[alvoParte].Position) end end 

end)

aimbotBtn.Text = "Ativar Aimbot"

