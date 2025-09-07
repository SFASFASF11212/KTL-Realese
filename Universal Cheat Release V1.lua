-- Load UI library
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Create window
local Window = lib:MakeWindow({
    Title = "KTL Hub : Universal",
    SubTitle = "By Uzi, Legend, And Tr3x",
    SaveFolder = "KTL Hub | Universal.lua"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://112061134720873", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local scriptStart = tick()

-- Vars
local speedValue, jumpValue, fovValue = 16, 50, camera.FieldOfView
local infJumpEnabled, noclipEnabled, aimbotEnabled, triggerBotEnabled = false, false, false, false

-- Find best text function
local function getTextFunc(tab)
    for _, fn in ipairs({"AddParagraph", "AddLabel", "AddText"}) do
        if typeof(tab[fn]) == "function" then
            return function(title, content)
                if fn == "AddParagraph" then
                    return tab:AddParagraph({Title = title, Content = content})
                else
                    return tab[fn](tab, title .. "\n" .. content)
                end
            end
        end
    end
    return function(_, _) end
end

-- ========= HOME =========
local Home = Window:MakeTab({"Home", "home"})
local addText = getTextFunc(Home)
addText("Welcome", "KTL Hub : Universal\nMade by Uzi, Legend, and Tr3x")
Home:AddDiscordInvite({
    Name = "Join KTL Discord",
    Logo = "rbxassetid://112061134720873",
    Invite = "https://discord.gg/4yhuJhEzJX"
})

-- ========= PLAYER =========
local PlayerTab = Window:MakeTab({"Player", "user"})
addText = getTextFunc(PlayerTab)
addText("Player Controls", "Adjust your stats")

PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0, Max = 500, Default = 16,
    Callback = function(v) speedValue = v end
})
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 0, Max = 500, Default = 50,
    Callback = function(v) jumpValue = v end
})
PlayerTab:AddSlider({
    Name = "FOV",
    Min = 70, Max = 120, Default = camera.FieldOfView,
    Callback = function(v) fovValue = v end
})

-- ========= ESP IN PLAYER TAB =========
local espEnabled = false
local espSize = 4
local espColor = Color3.fromRGB(0, 255, 0)
local ESPBoxes = {}

-- Function to create ESP box
local function createESP(player)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
    box.Size = Vector3.new(espSize, espSize*1.5, espSize/2)
    box.Color3 = espColor
    box.AlwaysOnTop = true
    box.Transparency = 0.5
    box.ZIndex = 2
    box.Parent = game:GetService("CoreGui")
    ESPBoxes[player] = box
end

-- Function to remove all ESP
local function removeAllESP()
    for _, box in pairs(ESPBoxes) do
        if box then box:Destroy() end
    end
    ESPBoxes = {}
end

-- Update loop
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not ESPBoxes[player] then createESP(player) end
                local box = ESPBoxes[player]
                if box and player.Character:FindFirstChild("HumanoidRootPart") then
                    box.Adornee = player.Character.HumanoidRootPart
                    box.Size = Vector3.new(espSize, espSize*1.5, espSize/2)
                    box.Color3 = espColor
                end
            end
        end
    else
        removeAllESP()
    end
end)

-- Add ESP toggle to Player tab
PlayerTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(v)
        espEnabled = v
        if not v then removeAllESP() end
    end
})

-- ESP Size slider
PlayerTab:AddSlider({
    Name = "ESP Size",
    Min = 1, Max = 10, Increase = 0.5, Default = 4,
    Callback = function(v)
        espSize = v
    end
})

-- ESP Color dropdown
PlayerTab:AddDropdown({
    Name = "ESP Color",
    Options = {"Green", "Red", "Blue", "Yellow", "Purple"},
    Default = "Green",
    Callback = function(v)
        if v == "Green" then espColor = Color3.fromRGB(0, 255, 0)
        elseif v == "Red" then espColor = Color3.fromRGB(255, 0, 0)
        elseif v == "Blue" then espColor = Color3.fromRGB(0, 0, 255)
        elseif v == "Yellow" then espColor = Color3.fromRGB(255, 255, 0)
        elseif v == "Purple" then espColor = Color3.fromRGB(128, 0, 128)
        end
    end
})



PlayerTab:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(s) infJumpEnabled = s end})
PlayerTab:AddToggle({Name = "NoClip", Default = false, Callback = function(s) noclipEnabled = s end})
PlayerTab:AddToggle({Name = "Aimbot (Hold Right Click)", Default = false, Callback = function(s) aimbotEnabled = s end})
PlayerTab:AddToggle({Name = "Trigger Bot (Crosshair Fire)", Default = false, Callback = function(s) triggerBotEnabled = s end})

-- ========= INFO =========
local Info = Window:MakeTab({"Info", "info"})
addText = getTextFunc(Info)

local execName, execVer = "Unknown", ""
pcall(function() if identifyexecutor then execName, execVer = identifyexecutor() end end)
local execBlock = addText("Executor", execName .. (execVer ~= "" and " v"..execVer or ""))

local playerBlock = addText("Player", ("Name: %s\nDisplay: %s\nUserId: %s")
    :format(LocalPlayer.Name, LocalPlayer.DisplayName, tostring(LocalPlayer.UserId)))

local gameName = "Unknown"
pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
local gameBlock = addText("Game", ("Name: %s\nPlaceId: %s\nJobId: %s")
    :format(gameName, tostring(game.PlaceId), tostring(game.JobId)))

local fpsBlock   = addText("FPS", "Loading...")
local pingBlock  = addText("Ping", "Loading...")
local timeBlock  = addText("Session Time", "Loading...")
local playersBlk = addText("Players", "Loading...")

-- ========= SERVER =========
local Server = Window:MakeTab({"Server", "server"})
addText = getTextFunc(Server)

Server:AddButton({Name = "Rejoin", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})
Server:AddButton({Name = "Server Hop", Callback = function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end})
Server:AddButton({Name = "Copy JobId", Callback = function()
    setclipboard(game.JobId)
end})

-- ========= BACKEND =========
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

local frames = 0
RunService.RenderStepped:Connect(function() frames += 1 end)
task.spawn(function()
    while task.wait(1) do
        fpsBlock:Set("FPS", tostring(frames)) frames = 0
        pcall(function()
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            pingBlock:Set("Ping", math.floor(ping) .. " ms")
        end)
        local age = math.floor(tick() - scriptStart)
        timeBlock:Set("Session Time", ("%d min %d sec"):format(age//60, age%60))
        playersBlk:Set("Players", ("%d/%d"):format(#Players:GetPlayers(), Players.MaxPlayers))
    end
end)

RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed, hum.JumpPower = speedValue, jumpValue
        hum.UseJumpPower = true
    end
    camera.FieldOfView = fovValue
end)

-- Aimbot Logic (Hold Right Click)
local function getClosestPlayer()
    local closest, distance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if dist < distance then
                    closest, distance = head, dist
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)

-- Trigger Bot Logic
local function isTargetValid(part)
    local model = part:FindFirstAncestorOfClass("Model")
    if not model or model == LocalPlayer.Character then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

RunService.RenderStepped:Connect(function()
    if triggerBotEnabled then
        local mousePos = UserInputService:GetMouseLocation()
        local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        params.FilterType = Enum.RaycastFilterType.Blacklist

        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if result and result.Instance and isTargetValid(result.Instance) then
            mouse1click()
        end
    end
end)

Window.OnUnload = function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed, hum.JumpPower = 16, 50 end
    camera.FieldOfView = 70
end

lib:SetTheme("Dark")
Window:SelectTab(Home)
