destination="Vermilion City"
Mount_name=""
Water_Mount_name=""

routes_counter=1
--maps[current_map][next_map][entrance_Num][x1,y1,x2,y2,teleport_num]
--teleport_num: -1 for just go, 0 for dig, number larger than 0 are the choise when NPC ask you where to go
maps={}

maps=["Vermilion City"]={};
maps=["Vermilion City"]["Route 6"]={{x1,y1,x2,y2,-1}}

--TO-DO
--routes[route][next_map][map_name][entrance_Num]
routes=["Kanto-Johto-Sinnoh"]={{"Route 6",1},{}}

function onStart()
	start_place=getMapName()
	if start_place ~="Vermilion City" and start_place ~="Olivine City" and start_place ~="Canalave City" then
		fatal("The start place must be one from Vermilion,  Olivine or Canalave")
	if destination ~="Vermilion City" and destination ~="Olivine City" and destination ~="Canalave City" then
		fatal("The destination must be one from Vermilion,  Olivine or Canalave")
	direction=choose_route(start_place,destination)
end

function onPathAction()
	SetMount(Mount_name)
	SetWaterMount(Water_Mount_name)
	
	local digIndex = 0
	
	for i = getTeamSize() , 1 , -1 do
		if hasMove(i, "Dig") and getPokemonHappiness(i) >= 150 then digIndex = i end
	end
	
	if pkDig > 0 then
		digSpots = getActiveDigSpots() -- Returns a table of every available dig spot on the map
		
		if digSpots[1] then -- If digSpots has at least one value
			pushDialogAnswer(digIndex) -- Queue the next dialog answer as the index of the Pokemon with Dig
			return talkToNpcOnCell(digSpots[1]["x"], digSpots[1]["y"]) -- Activate the dig spot
		end
    end
    -- If there are no available dig spots on this map, or that is to say, digSpots[1] == nil, execute the code below
    current_map=getMapName()
	print("current_map")
	print(current_map)
	next_map=routes[direction][routes_counter][1]
	entrance_Num=routes[direction][routes_counter][2]
    to_next_map(current_map,next_map,entrance_Num)
	print("after function to_next_map")
	print(getMapName())
	if current_map~=getMapName() and next_map==getMapName() then
		routes_counter=routes_counter+1
	else
		fatal("In the wrong map")
	end
    -- etc.
end

function onBattleAction()
    if isWildBattle() and isOpponentShiny() then 
        if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
            return
        end
    end
	if isWildBattle() then
		opp_name=getOpponentName()
		if opp_name=="Diglett" or opp_name=="Dugtrio" then
			return attack() or sendUsablePokemon()
		else
			return run()
    return attack() or sendUsablePokemon() or run()
end

local function choose_route(start_place,destination)
--[[
direction : 1.Kanto-Johto-Sinnoh; 2.Johto-Kanto-Sinnoh;3.Sinnoh-Kanto-Johto;4.Sinnoh-Johto-Kanto
]]--
	if start_place=="Vermilion City" then
		return "Kanto-Johto-Shinoh"
	elseif start_place=="Olivine City" then
		return "Johto-Kanto-Shinoh"
	else
		if destination=="Vermilion City" then
			return "Shinoh-Johto-Kanto"
		elseif destination=="Olivine City" then
			return "Shinoh-Kanto-Johto"
	end
end

local function to_next_map(current_map,next_map,entrance_Num)
	local cor
	for i =1,5 do
		cor[i]=maps[current_map][next_map][entrance_Num][i]
	end
	if cor[5]==0 then
		local digIndex = 0
		for i = getTeamSize() , 1 , -1 do
		if hasMove(i, "Dig") and getPokemonHappiness(i) >= 150 then digIndex = i end
		end
		pushDialogAnswer(digIndex)
		talkToNpcOnCell(cor[1],cor[2]) 
	elseif cor[5]==-1 then
		moveToRectangle(cor[1],cor[2], cor[3], cor[4])
	else
		pushDialogAnswer(cor[5])
		talkToNpcOnCell(cor[1],cor[2])
end