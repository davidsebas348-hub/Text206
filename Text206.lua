-- ===============================
-- AUTO BUY KNIFE + TOGGLE FIABLE
-- ===============================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Esperar a que el juego esté cargado
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Toggle global
if _G.AutoBuyKnife == nil then
    _G.AutoBuyKnife = false
end
_G.AutoBuyKnife = not _G.AutoBuyKnife -- cambia cada ejecución

-- Referencias al pedestal y prompt
local knifePedestal = Workspace:WaitForChild("Spawnm"):WaitForChild("KnifePedestal")
local prompt = knifePedestal:FindFirstChild("BuyKnife") -- Cambia si otro prompt

-- Función para esperar personaje y HRP
local function esperarPersonajeYHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hrp
end

-- Función para teletransportar y activar prompt
local function teleportaYActiva()
    if not _G.AutoBuyKnife then return end
    local char, hrp = esperarPersonajeYHRP()

    -- Teletransportar al jugador
    local pedestalPos = knifePedestal.Position
    local teleportPos = pedestalPos + Vector3.new(0,3,-5)
    hrp.CFrame = CFrame.new(teleportPos)

    -- Mover cámara
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(teleportPos, pedestalPos)

    -- Activar ProximityPrompt
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        wait(0.1)
        prompt:InputHoldEnd()
    end

    wait(0.2)
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = char:WaitForChild("Humanoid")
end

-- Función principal
local function checkTeamAndStats()
    if not _G.AutoBuyKnife then return end

    local leaderstats = LocalPlayer:WaitForChild("leaderstats")
    local coinsStat = leaderstats:WaitForChild("Coins")

    if LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby" and coinsStat.Value >= 5000 then
        teleportaYActiva()
    end
end

-- Ejecutar al inicio
checkTeamAndStats()

-- Conectar cambios de team y coins
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(checkTeamAndStats)
LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Coins"):GetPropertyChangedSignal("Value"):Connect(checkTeamAndStats)

-- Función toggle manual
function ToggleAutoBuyKnife()
    _G.AutoBuyKnife = not _G.AutoBuyKnife
    if _G.AutoBuyKnife then
        checkTeamAndStats()
    end
end
