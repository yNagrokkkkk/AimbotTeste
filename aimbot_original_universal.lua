-- Aimbot Universal Roblox - Compatível com qualquer jogo, seguro contra erros local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local LocalPlayer = Players.LocalPlayer local Camera = workspace.CurrentCamera

local aimbotAtivo = false local fov = 150 local fovMin, fovMax = 50, 400 local alvoParte = "Head" local segurandoTiro = false

local playerGui = LocalPlayer:WaitForChild("PlayerGui") local screenGui = Instance.new("ScreenGui", playerGui) screenGui.Name = "AimbotUniversalGUI" screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui) frame.Size = UDim2.new(0, 250, 0, 300) frame.Position = UDim2.new(0, 100, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local dragging, dragInput, dragStart, startPos frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = frame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end) RunService.Heartbeat:Connect(function() if dragging and dragInput then local delta = dragInput.Position - dragStart frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

local function criarBotao(text, posY, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -20, 0, 30) btn.Position = UDim2.new(0, 10, 0

