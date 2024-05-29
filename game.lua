local utf8 = require("utf8")

require "rooms"

CYRYLLIC = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
CYRYLLIC_LOWER = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"

GAME_TITLE_TEXT = "- ЕРАРХТУР -"

INTRO_TEXT = {
	"В этом мире есть вещи",
	"о которых лучше не знать.",
	"А если всё таки знаешь",
	"- то лучше забыть.",
	"",
	"",
	"",
	"Тебе удалось всё-таки пробраться в",
	"ДК Ерархтура ночью чтобы изучить тайны",
	"которые скрывает его подвал.",
	"А может быть и Мамэ...",
	"Главное успеть до полуночи.",
}

HELP_TEXT = {
	"Как играть в эту игру.",
	"",
	"Ты можешь взаимодействовать с миром",
	"с помощью ввода с клавиатуры.",
	"Просто напиши что хочешь сделать",
	"",
	"Список базовых команд:",
	"осмотреться (о), инвернтарь (и),",
	"север (с), юг (ю), запад (з), восток (в),",
	"вверх (вв), вниз (вн),",
	"осмотреть/изучить (о/и) [предмет], взять [предмет],",
	"открыть [предмет/дверь]",
	"",
	"Остальное поймёшь по ходу игры...",
}

EXPLORE_YOURSELF_TEXT = {
	"Обыкновенный звёздник. Или звёздница.",
	"В темноте не разглядеть...",
	"Нет даже уверенности какого ты года.",
}

CANNOT_EXPLORE = "Ты не видишь здесь такого предмета."
CANNOT_TAKE = "Ты не можешь взять это с собой."
CANNOT_LISTEN = "Ты не слышишь ничего особенного."
CANNOT_OPEN = "Ты не можешь открыть это."
NOTHING_TO_OPEN = "Ты не можешь здесь ничего открыть."

needHint = 1

function look(world)
	local text = {}

	for _, v in ipairs(world.room.description) do
		table.insert(text, v)
	end

	if #world.room.dynamic > 0 then
		table.insert(text, "")
		for _, v in ipairs(world.room.dynamic) do
			for _, f in ipairs(v. inRoomDescription) do
				table.insert(text, f)
			end
		end
	end

	return text
end

function listen(world)
	local text = {}

	if #world.room.sounds > 0 then
		for _, v in ipairs(world.room.sounds) do
			table.insert(text, v)
		end
	else
		table.insert(text, CANNOT_LISTEN)
	end

	return text
end

function exploreYourself()
	local text = {}

	for _, v in ipairs(EXPLORE_YOURSELF_TEXT) do
		table.insert(text, v)
	end

	return text
end

function goTo(world, direction)
	local text = {}

	if world.room.directions[direction][1] == true then

		for _, v in ipairs(world.room.directions[direction][3]) do
			table.insert(text, v)
		end

		world.room = world.rooms[world.room.directions[direction][2]]

		-- table.insert(text, "- "..world.room.name.." -")
		table.insert(text, "")
		for _, v in ipairs(world.room.description) do
			table.insert(text, v)
		end

		if #world.room.dynamic > 0 then
		table.insert(text, "")
		for _, v in ipairs(world.room.dynamic) do
			for _, f in ipairs(v. inRoomDescription) do
				table.insert(text, f)
			end
		end
	end

	else
		for _, v in ipairs(world.room.directions[direction][2]) do
			table.insert(text, v)
		end

	end

	return text
end

function getShortDirections(world)
	local text = ""
	if world.room.directions["n"][1] == true then text = text.."С " end
	if world.room.directions["s"][1] == true then text = text.."Ю " end
	if world.room.directions["w"][1] == true then text = text.."З " end
	if world.room.directions["e"][1] == true then text = text.."В " end
	if world.room.directions["u"][1] == true then text = text.."ВВ " end
	if world.room.directions["d"][1] == true then text = text.."ВН " end
	return text
end

function explore(world, object)
	local text = {}

	for _, v in ipairs(world.room.static) do
		for _, o in ipairs(v.pronounce) do
			if object == o then
				for _, d in ipairs(v.description) do
					table.insert(text, d)
				end
			end
		end
	end

	for _, v in ipairs(world.room.dynamic) do
		for _, o in ipairs(v.pronounce) do
			if object == o then
				for _, d in ipairs(v.staticDescription) do
					table.insert(text, d)
				end
			end
		end
	end

	for _, v in ipairs(world.room.doors) do
		if object == "дверь" or object == "сундук" then
			if v.opened == true then
				for _, d in ipairs(v.openedDescription) do
					table.insert(text, d)
				end
			else
				for _, d in ipairs(v.closedDescription) do
					table.insert(text, d)
				end
			end
		end
	end

	for _, v in ipairs(world.inventory) do
		for _, o in ipairs(v.pronounce) do
			if object == o then
				table.insert(text, v.name)
				table.insert(text, "")
				for _, d in ipairs(v.description) do
					table.insert(text, d)
				end
			end
		end
	end




	if #text == 0 then
		text = {CANNOT_EXPLORE}
	end

	return text
end

function showInventory()
	local text = {}

	table.insert(text, "Список вещей в рюкзаке:")
	table.insert(text, "")
	if #world.inventory > 0 then
		for _, v in ipairs(world.inventory) do
			table.insert(text, "- "..v.name)
		end
	else
		table.insert(text, "- ПУСТО -")
	end

	return text
end

function take(world, object)
	local text = {}

	for i, v in ipairs(world.room.dynamic) do
		for _, o in ipairs(v.pronounce) do
			if object == o then
				table.insert(world.inventory, v)
				table.insert(text, "Теперь у тебя есть "..v.name)

				for _, a in ipairs(v.actions) do
					if a == "unlockway" then
						world.rooms[v.unlockwayaction.room].directions[v.unlockwayaction.direction] = v.unlockwayaction.newDirection
					end
				end

				world.room.dynamic[i] = nil
			end
		end
	end

	for i, v in ipairs(world.room.static) do
		for _, o in ipairs(v.pronounce) do
			if object == o then
				table.insert(text, CANNOT_TAKE)
			end
		end
	end

	if #text == 0 then
		text = {CANNOT_EXPLORE}
	end

	return text
end

function open(world, object)
	local text = {}

	if object == "дверь" then
		for i, v in ipairs(world.room.doors) do
			if v.opened == false then
				for j, h in ipairs(world.inventory) do
					for _, a in ipairs(h.actions) do
						if a == "open" and h.door == v.id then
							world.room.doors[j].opened = true
							world.room.directions[v.direction] = v.newDirection
							for _, t in ipairs(v.openedDescription) do
								table.insert(text, t)
							end
						end
					end
				end
			else
				table.insert(text, "Она же уже открыта.")
			end
		end
	end

	for i, v in ipairs(world.room.static) do
		for _, o in ipairs(v.pronounce) do
			if object == o then
				table.insert(text, CANNOT_OPEN)
			end
		end
	end

	if #text == 0 then
		text = {NOTHING_TO_OPEN}
	end

	return text
end





-- SYSTEM

function sixteenToNumber(char)
	if char == '0' then
		return 0
	elseif char == '1' then
		return 1
	elseif char == '2' then
		return 2
	elseif char == '3' then
		return 3
	elseif char == '4' then
		return 4
	elseif char == '5' then
		return 5
	elseif char == '6' then
		return 6
	elseif char == '7' then
		return 7
	elseif char == '8' then
		return 8
	elseif char == '9' then
		return 9
	elseif (char == 'A') or (char == 'a') then
		return 10
	elseif (char == 'B') or (char == 'b') then
		return 11
	elseif (char == 'C') or (char == 'c') then
		return 12
	elseif (char == 'D') or (char == 'd') then
		return 13
	elseif (char == 'E') or (char == 'e') then
		return 14
	elseif (char == 'F') or (char == 'f') then
		return 15
	else
		return 0
	end
end

function hexToRgb(hexText)
	local rgbArray = {0, 0, 0}
	rgbArray[1] = (sixteenToNumber(string.sub(hexText, 1, 1)) * 16 + sixteenToNumber(string.sub(hexText, 2, 2))) / 255
	rgbArray[2] = (sixteenToNumber(string.sub(hexText, 3, 3)) * 16 + sixteenToNumber(string.sub(hexText, 4, 4))) / 255
	rgbArray[3] = (sixteenToNumber(string.sub(hexText, 5, 5)) * 16 + sixteenToNumber(string.sub(hexText, 6, 6))) / 255
	return rgbArray
end

function toLowerCyr(text)
	local i = 1
	local newText = ""
	while i <= #text do
		local wasCyr = false

		for j = 1, #CYRYLLIC do
			if string.sub(text, i, i+1) == string.sub(CYRYLLIC, j, j+1) then
				wasCyr = true
				newText = newText .. string.sub(CYRYLLIC_LOWER, j, j+1)
				i = i + 2
			end
		end

		for j = 1, #CYRYLLIC_LOWER do
			if string.sub(text, i, i+1) == string.sub(CYRYLLIC_LOWER, j, j+1) then
				wasCyr = true
				newText = newText .. string.sub(CYRYLLIC_LOWER, j, j+1)
				i = i + 2
			end
		end

		if not wasCyr then
			i = i + 1
		end
	end
	return newText
end

function parcer(world, inputtext)
	local text = inputtext:gsub("[%p%c]", "")
	local words = {}

	for s in text:gmatch("([^ ]+)") do words[#words+1] = s end

	for i, v in ipairs(words) do
		words[i] = toLowerCyr(v)
	end

	if #words == 0 then
		return {}, false
	end

	for i, w in ipairs(words) do
		
		-- PARCER LOGIC
		if w == "помощь" then
			return HELP_TEXT, false, 0

		elseif w == "очистить" then
			return {}, true

		elseif w == "осмотреться" or (w == "о" and (#words == 1 or words[i+1] == "комнату")) then
			return look(world)

		elseif w == "прислушаться" or w == "слушать" or w == "звук" then
			return listen(world)

		elseif w == "север" or (w == "с" and #words == 1) then
			return goTo(world, "n")

		elseif w == "юг" or (w == "ю" and #words == 1) then
			return goTo(world, "s")

		elseif w == "запад" or (w == "з" and #words == 1) then
			return goTo(world, "w")

		elseif w == "восток" or (w == "в" and #words == 1) then
			return goTo(world, "e")

		elseif w == "вверх" or w == "наверх" or (w == "вв" and #words == 1) then
			return goTo(world, "u")

		elseif w == "вниз" or ((w == "вн" or w == "н") and #words == 1) then
			return goTo(world, "d")

		elseif (w == "изучить" or w == "осмотреть" or w == "о" or w == "и") and i < #words then
			if words[i+1] == "рюкзак" or words[i+1] == "сумку" or words[i+1] == "инвентарь" then
				return showInventory(world)
			elseif words[i+1] == "себя" or words[i+1] == "меня" then
				return exploreYourself()
			else
				return explore(world, words[i+1])
			end

		elseif w == "инвентарь" or w == "инвентаре" or (w == "и" and #words == 1) then
			return showInventory(world)

		elseif (w == "взять" or w == "забрать" or w == "поднять" or w == "украсть") and i < #words then
			return take(world, words[i+1])

		elseif (w == "открыть" or w == "отпереть") and i < #words then
			return open(world, words[i+1])

		-- elseif w == "привет" then
		-- 	return {'И тебе привет!'}
		end

	end

	if needHint >= 3 then
		needHint = 1
		return {"Извини, что ты хочешь сделать?", 'Введи "ПОМОЩЬ" чтобы посмотреть', 'достпные команды.'}, false
	else
		needHint = needHint + 1
		return {"Извини, что ты хочешь сделать?"}, false
	end
end