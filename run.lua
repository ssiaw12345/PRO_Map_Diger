destination="Vermilion City"
Mount_name=""
Water_Mount_name=""

map_counter=1
--maps[current_map][next_map][x1,y1,x2,y2,if_use_dig_to_teleport]
maps={}

maps=["Vermilion City"]={};
maps=["Vermilion City"]["Route 6"]={x1,y1,x2,y2,false}
--TO-DO

routes=["Kanto-Johto-Shinoh"]={"Route 6",""}

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
	next_map=routes[direction][map_counter]
    to_next_map(current_map,next_map)
	if current_map~=getMapName() then
		map_counter=map_counter+1
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

local function to_next_map(current_map,next_map)
--[[
direction : 1.Kanto-Johto-Shinoh; 2.Johto-Kanto-Shinoh;3.Shinoh-Kanto-Johto;4.Shinoh-Johto-Kanto
]]--
	local cor
	for i =1,5 do
		cor[i]=maps[current_map][next_map][i]
	end
	if cor[5] then
		local digIndex = 0
		for i = getTeamSize() , 1 , -1 do
		if hasMove(i, "Dig") and getPokemonHappiness(i) >= 150 then digIndex = i end
		end
		pushDialogAnswer(digIndex)
		talkToNpcOnCell(cor[1],cor[2]) 
	else
		moveToRectangle(cor[1],cor[2], cor[3], cor[4])
	
end