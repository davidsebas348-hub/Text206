-- ===============================
-- TELEPORT + LOADSTRING ONCE + CAMARA ENFOCANDO EL PEDestal
-- ===============================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Coordenadas a teletransportar
local teleportCoords = Vector3.new(6, 25, 182) -- Cambia a la que quieras

-- Pedestal / prompt (para enfocar cámara)
local knifePedestal = Workspace:WaitForChild("Spawnm"):WaitForChild("KnifePedestal")
local prompt = knifePedestal:FindFirstChild("BuyKnife") -- Cambia si otro prompt

-- Flag para que solo se ejecute una vez por TP
local hasTeleported = false

-- Función para ejecutar teletransporte y loadstring
local function doTeleportAndLoad()
    if hasTeleported then return end
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Espera 1.5 segundos antes de teletransportar
    wait(1.5)

    -- Teletransportar
    hrp.CFrame = CFrame.new(teleportCoords)

    -- Enfocar cámara hacia el pedestal
    if knifePedestal then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(teleportCoords, knifePedestal.Position)
    end

    -- Ejecutar loadstring
    loadstring(game:HttpGet("https://raw.githubusercontent.com/davidsebas348-hub/Text191/refs/heads/main/Text192.lua", true))()

    hasTeleported = true
end

-- Detectar team y ejecutar
local function checkTeam()
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby" then
        doTeleportAndLoad()
    end
end

-- Ejecutar al inicio
checkTeam()

-- Conectar cambios de team
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(checkTeam)
