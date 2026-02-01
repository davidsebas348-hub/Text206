-- ===============================
-- AUTO BUY KNIFE CON TP Y LOADSTRING
-- ===============================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Toggle global
if _G.AutoBuyKnife == nil then
    _G.AutoBuyKnife = false
end

-- Flag para que solo se ejecute 1 vez por TP
local yaTP = false

-- Función para esperar Character y HRP
local function esperarPersonajeYHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hrp
end

-- Función para teletransportar y activar el loadstring
local function teleportaYActiva()
    if not _G.AutoBuyKnife or yaTP then return end
    yaTP = true -- marcar como ejecutado

    local char, hrp = esperarPersonajeYHRP()

    -- Esperar 1.5 segundos antes de teletransportar
    task.wait(1.5)

    -- Obtener pedestal
    local spawnm = Workspace:WaitForChild("Spawnm")
    local knifePedestal = spawnm:WaitForChild("KnifePedestal")
    local pedestalPos = knifePedestal.Position
    local teleportPos = pedestalPos + Vector3.new(0,3,-5)
    hrp.CFrame = CFrame.new(teleportPos)

    -- Mover cámara
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(teleportPos, pedestalPos)

    -- Ejecutar el loadstring del pedestal
    loadstring(game:HttpGet("https://raw.githubusercontent.com/davidsebas348-hub/Text191/refs/heads/main/Text192.lua", true))()

    -- Restaurar cámara
    task.wait(0.2)
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = char:WaitForChild("Humanoid")
end

-- Función de chequeo principal
local function checkTeamAndStats()
    if not _G.AutoBuyKnife then return end

    local leaderstats = LocalPlayer:WaitForChild("leaderstats")
    local coinsStat = leaderstats:WaitForChild("Coins")

    if LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby" and coinsStat.Value >= 5000 then
        teleportaYActiva()
    else
        yaTP = false -- resetear si salimos del Lobby
    end
end

-- Ejecutar al inicio y conectar cambios
task.delay(1, checkTeamAndStats)
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(checkTeamAndStats)
LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Coins"):GetPropertyChangedSignal("Value"):Connect(checkTeamAndStats)

-- Función toggle manual
function ToggleAutoBuyKnife()
    _G.AutoBuyKnife = not _G.AutoBuyKnife
    if _G.AutoBuyKnife then
        task.delay(0.2, checkTeamAndStats)
    end
end
