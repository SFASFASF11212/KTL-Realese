local _Gx = loadstring(game:HttpGet("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x72\x61\x77\x2e\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6f\x6e\x74\x65\x6e\x74\x2e\x63\x6f\x6d\x2f\x74\x62\x61\x6f\x31\x34\x33\x2f\x4c\x69\x62\x72\x61\x72\x79\x2d\x75\x69\x2f\x72\x65\x66\x73\x2f\x68\x65\x61\x64\x73\x2f\x6d\x61\x69\x6e\x2f\x52\x65\x64\x7a\x68\x75\x62\x75\x69"))()
local _W = _Gx:MakeWindow({Title = "\75\84\76\32\72\117\98\32\58\32\85\110\105\118\101\114\115\97\108", SubTitle = "\66\121\32\85\122\105\44\32\76\101\103\101\110\100\44\32\65\110\100\32\84\114\51\120", SaveFolder = "\75\84\76\32\72\117\98\32\124\32\85\110\105\118\101\114\115\97\108\46\108\117\97"})
_W:AddMinimizeButton({Button = {Image = "rbxassetid://112061134720873", BackgroundTransparency = 0}, Corner = {CornerRadius = UDim.new(35, 1)}})

local S = game:GetService
local P, R, U, ST, M, T = S("Players"), S("RunService"), S("UserInputService"), S("Stats"), S("MarketplaceService"), S("TeleportService")
local L, C, Sx = P.LocalPlayer, workspace.CurrentCamera, tick()
local ws, jp, fv = 16, 50, C.FieldOfView
local ij, nc, ab, tb = false, false, false, false

local function _T(t)
    for _, f in ipairs({"AddParagraph", "AddLabel", "AddText"}) do
        if typeof(t[f]) == "function" then
            return function(a, b)
                return f == "AddParagraph" and t:AddParagraph({Title = a, Content = b}) or t[f](t, a .. "\n" .. b)
            end
        end
    end
    return function() end
end

local H = _W:MakeTab({"Home", "home"})
local _HT = _T(H)
_HT("Welcome", "\75\84\76\32\72\117\98\32\58\32\85\110\105\118\101\114\115\97\108\n\77\97\100\101\32\98\121\32\85\122\105\44\32\76\101\103\101\110\100\44\32\97\110\100\32\84\114\51\120")
H:AddDiscordInvite({Name = "Join KTL Discord", Logo = "rbxassetid://112061134720873", Invite = "https://discord.gg/4yhuJhEzJX"})

local PT = _W:MakeTab({"Player", "user"})
_HT = _T(PT)
_HT("Player Controls", "Adjust your stats")

PT:AddSlider({Name = "WalkSpeed", Min = 0, Max = 500, Default = ws, Callback = function(v) ws = v end})
PT:AddSlider({Name = "JumpPower", Min = 0, Max = 500, Default = jp, Callback = function(v) jp = v end})
PT:AddSlider({Name = "FOV", Min = 70, Max = 120, Default = fv, Callback = function(v) fv = v end})

PT:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(s) ij = s end})
PT:AddToggle({Name = "NoClip", Default = false, Callback = function(s) nc = s end})
PT:AddToggle({Name = "Aimbot (Hold Right Click)", Default = false, Callback = function(s) ab = s end})
PT:AddToggle({Name = "Trigger Bot (Crosshair Fire)", Default = false, Callback = function(s) tb = s end})

local I = _W:MakeTab({"Info", "info"})
_HT = _T(I)

local exn, exv = "Unknown", ""
pcall(function() if identifyexecutor then exn, exv = identifyexecutor() end end)
_HT("Executor", exn .. (exv ~= "" and " v" .. exv or ""))

_HT("Player", ("Name: %s\nDisplay: %s\nUserId: %s"):format(L.Name, L.DisplayName, tostring(L.UserId)))

local gn = "Unknown"
pcall(function() gn = M:GetProductInfo(game.PlaceId).Name end)
_HT("Game", ("Name: %s\nPlaceId: %s\nJobId: %s"):format(gn, tostring(game.PlaceId), tostring(game.JobId)))

local fB, pB, tB, plB = _HT("FPS", "Loading..."), _HT("Ping", "Loading..."), _HT("Session Time", "Loading..."), _HT("Players", "Loading...")

local Srv = _W:MakeTab({"Server", "server"})
_HT = _T(Srv)
Srv:AddButton({Name = "Rejoin", Callback = function() T:TeleportToPlaceInstance(game.PlaceId, game.JobId, L) end})
Srv:AddButton({Name = "Server Hop", Callback = function() T:Teleport(game.PlaceId, L) end})
Srv:AddButton({Name = "Copy JobId", Callback = function() setclipboard(game.JobId) end})

U.JumpRequest:Connect(function()
    if ij then
        local h = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

R.Stepped:Connect(function()
    if nc and L.Character then
        for _, v in ipairs(L.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

local f = 0
R.RenderStepped:Connect(function() f += 1 end)
task.spawn(function()
    while task.wait(1) do
        fB:Set("FPS", tostring(f)) f = 0
        pcall(function()
            local p = ST.Network.ServerStatsItem["Data Ping"]:GetValue()
            pB:Set("Ping", math.floor(p) .. " ms")
        end)
        local a = math.floor(tick() - Sx)
        tB:Set("Session Time", ("%d min %d sec"):format(a // 60, a % 60))
        plB:Set("Players", ("%d/%d"):format(#P:GetPlayers(), P.MaxPlayers))
    end
end)

R.Heartbeat:Connect(function()
    local h = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed, h.JumpPower = ws, jp
        h.UseJumpPower = true
    end
    C.FieldOfView = fv
end)

local function _CP()
    local c, d = nil, math.huge
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= L and p.Character and p.Character:FindFirstChild("Head") then
            local h = p.Character.Head
            local s, o = C:WorldToViewportPoint(h.Position)
            if o then
                local dist = (Vector2.new(s.X, s.Y) - U:GetMouseLocation()).Magnitude
                if dist < d then c, d = h, dist end
            end
        end
    end
    return c
end

R.RenderStepped:Connect(function()
    if ab and U:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = _CP()
        if t then C.CFrame = CFrame.new(C.CFrame.Position, t.Position) end
    end
end)

local function _TV(p)
    local m = p:FindFirstAncestorOfClass("Model")
    if not m or m == L.Character then return false end
    local h = m:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function mouse1click()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

R.RenderStepped:Connect(function()
    if tb
