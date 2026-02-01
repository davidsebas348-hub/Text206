-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Referencias al pedestal y prompt
local knifePedestal = workspace:WaitForChild("Spawnm"):WaitForChild("KnifePedestal")
local prompt = knifePedestal:FindFirstChild("BuyKnife") -- Cambia si quieres otro prompt

-- Función para teletransportar, enfocar y activar prompt
local function teleportaYActiva()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Teletransportar un poco atrás para que la cámara enfoque bien
    local pedestalPos = knifePedestal.Position
    local teleportPos = pedestalPos + Vector3.new(0, 3, -5)
    hrp.CFrame = CFrame.new(teleportPos)

    -- Cambiar cámara a scriptable y enfocar al pedestal
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(teleportPos, pedestalPos)

    wait(0.2) -- Esperar que todo se cargue

    -- Activar el ProximityPrompt
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        wait(0.1)
        prompt:InputHoldEnd()
    end

    wait(0.5) -- Espera un poquito antes de devolver control
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = character:WaitForChild("Humanoid")
end

-- Función principal que verifica stats y team
local function checkTeamAndStats()
    local leaderstats = player:WaitForChild("leaderstats")
    local coinsStat = leaderstats:FindFirstChild("Coins") -- Cambia si tu stat tiene otro nombre
    if not coinsStat then return end

    -- Solo si estamos en Lobby y tenemos 5000 o más coins
    if player.Team and player.Team.Name == "Lobby" and coinsStat.Value >= 5000 then
        teleportaYActiva()
    end
end

-- Ejecutar al inicio
checkTeamAndStats()

-- Escuchar cambios de team
player:GetPropertyChangedSignal("Team"):Connect(function()
    checkTeamAndStats()
end)

-- Escuchar cambios en las coins (por si suben mientras ya estás en Lobby)
local leaderstats = player:WaitForChild("leaderstats")
local coinsStat = leaderstats:WaitForChild("Coins")
coinsStat:GetPropertyChangedSignal("Value"):Connect(function()
    checkTeamAndStats()
end)
