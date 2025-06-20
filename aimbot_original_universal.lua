
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.ResetOnSpawn = false
screenGui.Name = "AimbotGUI"

local function criarBotao(texto, posY)
	local b = Instance.new("TextButton", screenGui)
	b.Size = UDim2.new(0, 200, 0, 50)
	b.Position = UDim2.new(0, 20, 0, posY)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.BorderSizePixel = 2
	b.Text = texto
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	return b
end

local fov, fovMin, fovMax = 150, 50, 400
local aimbotAtivo = false

local toggleButton = criarBotao("Ativar Aimbot", 0.75)
local aumentarFOV = criarBotao("+ FOV", 0.82)
local diminuirFOV = criarBotao("- FOV", 0.89)

local statusFOV = Instance.new("TextLabel", screenGui)
statusFOV.Size = UDim2.new(0, 200, 0, 30)
statusFOV.Position = UDim2.new(0, 20, 0, 0.96)
statusFOV.BackgroundTransparency = 1
statusFOV.TextColor3 = Color3.new(1, 1, 1)
statusFOV.TextScaled = true
statusFOV.Font = Enum.Font.Gotham
statusFOV.Text = "FOV: " .. tostring(fov)

toggleButton.MouseButton1Click:Connect(function()
	aimbotAtivo = not aimbotAtivo
	toggleButton.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot"
	toggleButton.BackgroundColor3 = aimbotAtivo and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(50, 50, 50)
end)

aumentarFOV.MouseButton1Click:Connect(function()
	fov = math.min(fov + 25, fovMax)
	statusFOV.Text = "FOV: " .. tostring(fov)
end)

diminuirFOV.MouseButton1Click:Connect(function()
	fov = math.max(fov - 25, fovMin)
	statusFOV.Text = "FOV: " .. tostring(fov)
end)

local function distancia2D(p1, p2)
	return ((p1.X - p2.X)^2 + (p1.Y - p2.Y)^2)^0.5
end

local function obterAlvo()
	local camera, jogadores = workspace.CurrentCamera, game.Players:GetPlayers()
	local alvoMaisProximo, menorDistancia = nil, fov

	for _, inimigo in ipairs(jogadores) do
		if inimigo ~= player and inimigo.Team ~= player.Team and inimigo.Character and inimigo.Character:FindFirstChild("HumanoidRootPart") and inimigo.Character.Humanoid.Health > 0 then
			local pos, naTela = camera:WorldToViewportPoint(inimigo.Character.HumanoidRootPart.Position)
			if naTela then
				local dist = distancia2D(Vector2.new(pos.X, pos.Y), Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2))
				if dist < menorDistancia then
					menorDistancia = dist
					alvoMaisProximo = inimigo
				end
			end
		end
	end
	return alvoMaisProximo
end

local function mirarNoAlvo(alvo)
	local camera, hrp = workspace.CurrentCamera, alvo.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
	end
end

game:GetService("RunService").RenderStepped:Connect(function()
	if aimbotAtivo then
		local alvo = obterAlvo()
		if alvo then
			mirarNoAlvo(alvo)
		end
	end
end)
