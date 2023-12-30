-- classes
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- check engine
local engine
for i, v in ReplicatedStorage:GetChildren() do
	if v.Name:find("Engine") or v:FindFirstChild("Eventos") and v:FindFirstChild("GunModels") then
		engine = v; break
	end
end

if not engine then
	return warn("Error to load hub")
end

-- get modules
local function getModule(name)
	return loadstring(game:HttpGet(("https://raw.githubusercontent.com/0x235z/ACS/main.lua/Modules/%s.lua"):format(name)))
end

local Libary = getModule("Libary")
local Drawing = getModule("Drawing")
local Calls = getModule("Calls")

-- public
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local comabat_tab = Libary:CreateTab("Combat")
local combat_section = comabat_tab:CreateSection("Main")
local combat_config = comabat_tab:CreateSection("Config")
local troll_tab = Libary:CreateTab("Troll")
local troll_section = troll_tab:CreateSection("Main")
local troll_section2 = troll_tab:CreateSection("Players")

-- slient aim & others
do
	combat_section:CreateToggle("Slient Aim", function(state)
		print("not")
	end)

	combat_section:CreateLabel(tostring(math.random()) ,"Visual")

	combat_section:CreateToggle("ESP", function(state) 
		print("not")
	end)

	-- toggles config
	combat_config:CreateToggle("Visible fov", function(state)
		Drawing.Frame.Visible = state
	end)

	combat_config:CreateToggle("Team check", function(state)
		print("not")
	end)

	-- sliders config
	combat_config:CreateSlider("Fov size", 50, 350, 75, false, function(value : number)
		Drawing.Frame.Size = UDim2.new(value + .05, 0, value, 0)
	end)
	
	combat_config:CreateSlider("Fov thickness", 1, 10, 1, false, function(value : number)
		Drawing.UIStroke.Thickness = value
	end)

	-- color picker config
	combat_config:CreateColorPicker("Fov color", Drawing.UIStroke.Color, function(color) 
		Drawing.UIStroke.Color = color
	end)

	combat_config:CreateLabel(tostring(math.random()), "ESP config")
end

do
	local events = engine.Eventos

	--load shareds
	for i, v in events:GetChildren() do
		shared[v.Name:lower()] = false
	end
	
	troll_section:CreateToggle("Whizz", function(state)
		shared.whizz = state
		while shared.whizz do
			for i, v in Players:GetPlayers() do
				task.spawn(events.Whizz.FireServer, events.Whizz, v)
			end
			task.wait()
		end
	end)

	local Intensity = 50
	troll_section:CreateSlider("Supress intensity", 0, 100, 50, false, function(value : number)
		Intensity = value
	end)

	troll_section:CreateToggle("Suppression", function(state)
		shared.suppression = state
		while shared.suppression do
			for i, v in Players:GetPlayers() do
				task.spawn(events.Suppression.FireServer, events.Suppression, v, Intensity, .5)
			end
			task.wait()
		end
	end)

	-- section 2 troll
	troll_section2:CreateButton("Kill all", function()
		for i, v in game.Players:GetPlayers() do
			local humanoid = v.Character and v.Character:FindFirstChild("Humanoid")

			if v ~= player and humanoid then
				task.spawn(events.Damage.FireServer, events.Damage, humanoid, math.huge, 0, 0)
			end
		end
	end)

	local players = {}
	for i, v in game.Players:GetPlayers() do
		table.insert(players, v.Name)
	end

	local target_name
	local dropdown_players = troll_section2:CreateDropdown("Players", players, math.random(1, #players), function(select)
		target_name = select
	end)

	Players.PlayerAdded:Connect(function(v)
		table.insert(players, v.Name)
		dropdown_players.Refresh(players, math.random(1, #players), function(select)
			target_name = select
		end)
	end)

	Players.PlayerRemoving:Connect(function(v)
		table.remove(players, table.find(players, v.Name))
		dropdown_players.Refresh(players, math.random(1, #players), function(select)
			target_name = select
		end)
	end)

	troll_section2:CreateButton("Kill player", function()
		local target = Players:FindFirstChild(target_name)
		local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")

		if humanoid then
			task.spawn(events.Damage.FireServer, events.Damage, humanoid, math.huge, 0, 0)
		end
	end)

	troll_section2:CreateButton("God player", function()
		local target = Players:FindFirstChild(target_name)
		local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")

		if humanoid then
			task.spawn(events.Damage.FireServer, events.Damage, humanoid, -math.huge, 0, 0)
		end
	end)
end

-- update position draw
task.spawn(function()
	while true do
		Drawing.Frame.Position = UDim2.new(0, (mouse.X - (Drawing.Frame.Size.X.Scale / 2)), 0, (mouse.Y - (Drawing.Frame.Size.Y.Scale / 2)))
		task.wait(.001)
	end
end)
