-- ===============================
-- AUTO BUY KNIFE + LOADRING FIABLE
-- ===============================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ===============================
-- Inicializar toggle seguro
-- ===============================
if _G.AutoBuyKnife == nil then
    _G.AutoBuyKnife = false
end

-- ===============================
-- Esperar que el juego y objetos estén listos
-- ===============================
local function esperarTodo()
    -- Esperar que el juego cargue
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    -- Esperar Character y HRP
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Esperar leaderstats
    local leaderstats = LocalPlayer:WaitForChild("leaderstats")
    local coins = leaderstats:WaitForChild("Coins")

    -- Esperar pedestal
    local spawnm = Workspace:WaitForChild("Spawnm")
    local knifePedestal = spawnm:WaitForChild("KnifePedestal")
    local prompt = knifePedestal:FindFirstChild("BuyKnife")

    return char, hrp, coins, knifePedestal, prompt
end

-- ===============================
-- Función para teletransportar y activar prompt
-- ===============================
local function teleportaYActiva()
    if not _G.AutoBuyKnife then return end
    local char, hrp, coins, knifePedestal, prompt = esperarTodo()

    -- Teletransportar al jugador cerca del pedestal
    local pedestalPos = knifePedestal.Position
    local teleportPos = pedestalPos + Vector3.new(0, 3, -5)
    hrp.CFrame = CFrame.new(teleportPos)

    -- Mover cámara
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = CFrame.new(teleportPos, pedestalPos)

    -- Activar ProximityPrompt
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
    end

    task.wait(0.2)
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = char:WaitForChild("Humanoid")
end

-- ===============================
-- Función principal de chequeo
-- ===============================
local function checkTeamAndStats()
    if not _G.AutoBuyKnife then return end
    local char, hrp, coins = esperarTodo()
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Lobby" and coins.Value >= 5000 then
        teleportaYActiva()
    end
end

-- ===============================
-- Ejecutar con delay para Loadring
-- ===============================
task.delay(1, function()
    checkTeamAndStats()
end)

-- ===============================
-- Conectar cambios de Team y Coins
-- ===============================
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(checkTeamAndStats)
LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Coins"):GetPropertyChangedSignal("Value"):Connect(checkTeamAndStats)

-- ===============================
-- Función toggle manual
-- ===============================
function ToggleAutoBuyKnife()
    _G.AutoBuyKnife = not _G.AutoBuyKnife
    if _G.AutoBuyKnife then
        task.delay(0.2, checkTeamAndStats)
    end
end
