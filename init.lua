--[[UPDATE IN 6:49 12/31/2023]]

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

assert(engine, "😿🙀💩☠️🤡🤮🤢😡😱🙉🐵🐒🦍🦧")

-- get modules
local function getModule(name)
	return loadstring(game:HttpGet(("https://raw.githubusercontent.com/0x235z/ACS/main.lua/Modules/%s.lua"):format(name)))
end

-- loadstrings
local Libary = getModule("Libary")
local Drawing = getModule("Drawing").new()
local Calls = getModule("Calls")
local Esp = getModule("Esp")

-- public
local player = Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- guide combat
local combat_tab = Libary:CreateTab("Combat")
local combat_section = combat_tab:CreateSection("Main")
local combat_config = combat_tab:CreateSection("Config")

-- guide events
local events_tab = Libary:CreateTab("Troll")
local events_section = events_tab:CreateSection("Main")
local events_section2 = events_tab:CreateSection("Players")

-- slient aim & others section funcs
do
	-- sem hookfunction ou getupvalues e setupvalues nao da ne nigga
	combat_section:CreateToggle("Slient Aim", function(state)
		print("thug")
	end)

	combat_section:CreateLabel(math.random() ,"Visual")

	local esp_color, team_color = Color3.fromRGB(255, 0, 0), false
	combat_section:CreateToggle("ESP", function(state)
		Esp.active(esp_color, team_color)
	end)

	combat_section:CreateLabel(math.random(), "Gun mods")

	local tool, data, fov = nil, nil, 70
	character.ChildAdded:Connect(function(child: Instance) 
		if child:IsA("Tool") and child:FindFirstChild("ACS_Modulo") then
			tool = child
			camera.FieldOfView = fov

			if tool.ACS_Modulo:FindFirstChild("Variaveis") and tool.ACS_Modulo.Variaveis:FindFirstChild("Settings") then
				data = require(tool.ACS_Modulo.Variaveis.Settings)
			end
		end
	end)

	combat_section:CreateSlider("Ammo", 1, 100, 30, false, function(value)
		if data then
			data.Ammo = value * 10
			tool.ACS_Modulo.Variaveis.StoredAmmo.Value = value * 100
		end
	end)

	combat_section:CreateSlider("Damage", 1, 150, 30, false, function(value : number)
		if data then
			data.LimbsDamage = {value / 1.5, value / 1.5}
			data.TorsoDamage = {value / 1.3, value / 1.3}
			data.HeadDamage = {value, value}
		end
	end)

	combat_section:CreateSlider("Fire rate", 10, 100, 20, false, function(value : number) 
		if data then
			data.FireRate = value * 50
		end
	end)

	combat_section:CreateToggle("Explosion bullet", function(state) 
		if data then
			data.ExplosiveHit = if state then true else false
		end
	end)
	
	combat_section:CreateToggle("No can break", function(state)
		if data then
			data.CanBreak = if state then false else true
		end
	end)

	combat_section:CreateSlider("Recoil", 0, 10, 3, false, function(value : number)
		if data then
			data.VRecoil = {value, value}
			data.HRecoil = {value, value}
			data.MaxRecoilPower = value
			data.MinRecoilPower = value / 2
		end
	end)

	combat_section:CreateSlider("Spread", 0, 50, 20, false, function(value : number) 
		if data then
			data.MinSpread = value / 2
			data.MaxSpread = value
		end
	end)

	combat_section:CreateSlider("Fov", 70, 120, 70, false, function(value : number) 
		if tool and tool.Parent == character then
			camera.FieldOfView = value
		end

		fov = value
	end)

	combat_config:CreateToggle("Visible fov", function(state)
		Drawing.Frame.Visible = state
		Drawing:update_draw()
	end)

	combat_config:CreateToggle("Team check", function(state)
		print("bla bla bla")
	end)

	combat_config:CreateSlider("Fov size", 50, 350, 75, false, function(value : number)
		Drawing.Frame.Size = UDim2.new(value + .05, 0, value, 0)
	end)
	
	combat_config:CreateSlider("Fov thickness", 1, 10, 1, false, function(value : number)
		Drawing.UIStroke.Thickness = value
	end)

	combat_config:CreateColorPicker("Fov color", Drawing.UIStroke.Color, function(color) 
		Drawing.UIStroke.Color = color
	end)

	combat_config:CreateLabel(math.random(), "ESP config")
	
	combat_config:CreateToggle("Team color", function(state) 
		team_color = state
	end)

	combat_config:CreateColorPicker("Esp color", Color3.fromRGB(255, 0, 0), function(color) 
		esp_color = color
		for i, v in shared.highs do
			if v.Enabled and not team_color then
				v.FillColor = color
				v.OutlineColor = color
			end
		end
	end)

	combat_config:CreateLabel(math.random(), "Gun model")
	
	local materials = {}
	for i, v in Enum.Material:GetEnumItems() do
		table.insert(materials, v.Name)
	end

	-- organize in alphabetical order
	table.sort(materials, function(a, b)
		return a:byte() < b:byte()
	end)

	local gun_model : Model
	combat_config:CreateDropdown("Materials", materials, 1, function(select)
		if gun_model then
			for i, v in gun_model:GetDescendants() do
				if v:IsA("BasePart") then
					v.Material = Enum.Material[select]
				end
			end
		end
	end)

	combat_config:CreateColorPicker("Gun color", Color3.fromRGB(255, 0, 0), function(color)
		if gun_model then
			for i, v in gun_model:GetDescendants() do
				if v:IsA("BasePart") then
					v.Color = color
				end
			end
		end
	end)

	camera.ChildAdded:Connect(function(child: Instance) 
		if child:IsA("Model") then
			gun_model = child
		end
	end)
end

-- events section funcs
do
	local events = engine.Eventos

	--load shareds
	for i, v in events:GetChildren() do
		shared[v.Name:lower()] = false
	end

	events_section:CreateToggle("Whizz", function(state)
		shared.whizz = state
		while shared.whizz do
			for i, v in Players:GetPlayers() do
				task.spawn(events.Whizz.FireServer, events.Whizz, v)
			end
			task.wait()
		end
	end)

	local Intensity = 50
	events_section:CreateSlider("Supress intensity", 0, 100, 50, false, function(value : number)
		Intensity = value
	end)

	events_section:CreateToggle("Suppression", function(state)
		shared.suppression = state
		while shared.suppression do
			for i, v in Players:GetPlayers() do
				task.spawn(events.Suppression.FireServer, events.Suppression, v, Intensity, .5)
			end
			task.wait()
		end
	end)

	events_section2:CreateButton("Kill all", function()
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
	local dropdown_players = events_section2:CreateDropdown("Players", players, 1, function(select)
		target_name = select
	end)

	Players.PlayerAdded:Connect(function(v)
		table.insert(players, v.Name)
		dropdown_players.Refresh(players, 1, function(select)
			target_name = select
		end)
	end)

	Players.PlayerRemoving:Connect(function(v)
		table.remove(players, table.find(players, v.Name))
		dropdown_players.Refresh(players, 1, function(select)
			target_name = select
		end)
	end)

	events_section2:CreateButton("Kill player", function()
		local target = Players:FindFirstChild(target_name)
		local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")

		if humanoid then
			task.spawn(events.Damage.FireServer, events.Damage, humanoid, math.huge, 0, 0)
		end
	end)

	events_section2:CreateButton("God player", function()
		local target = Players:FindFirstChild(target_name)
		local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")

		if humanoid then
			task.spawn(events.Damage.FireServer, events.Damage, humanoid, -math.huge, 0, 0)
		end
	end)
end
