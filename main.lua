local utf8 = require("utf8")

require "game"
require "rooms"

function love.load()
	love.keyboard.setKeyRepeat(true)

	world = {
		rooms = ROOMS,
		-- room = ROOMS.hall,
		room = ROOMS.stairs_2, -- for debug
		inventory = {
			-- CROWBAR,
		},
		time = {
			h = 21,
			m = 58,
			s = 45,
		}
	}


	LINE_HEIGTH = 16
	-- TEXT_FONT = love.graphics.newFont('fonts/PressStart2P-Regular.ttf')
	TEXT_FONT = love.graphics.newFont('fonts/Chava-Regular.otf', LINE_HEIGTH)

	CONSOLE_TEXT = {}
	for i, v in ipairs(INTRO_TEXT) do
		table.insert(CONSOLE_TEXT, {v})
	end
	table.insert(CONSOLE_TEXT, {""})
	table.insert(CONSOLE_TEXT, {""})
	table.insert(CONSOLE_TEXT, {""})
	table.insert(CONSOLE_TEXT, {GAME_TITLE_TEXT, 3})
	table.insert(CONSOLE_TEXT, {""})
	table.insert(CONSOLE_TEXT, {""})
	table.insert(CONSOLE_TEXT, {""})

	INPUT_HISTORY = {}
	INPUT_HISTORY_POSITION = 0

	PLAYER_INPUT_LINE = ""

	STATE_PLAYER_INPUT = true

	BACKGROUND_COLOR =	hexToRgb("1d2021") -- rgb(29, 32, 33)
	UI_COLOR =			hexToRgb("d79921")
	TEXT_COLOR = 		hexToRgb("fbf1c7")
	PLAYER_COLOR =		hexToRgb("d79921")
	HELP_COLOR = 		hexToRgb("458588")
	HINT_COLOR = 		hexToRgb("616286")
	EVIL_COLOR = 		hexToRgb("cc241d")
end

function updateTime()
	world.time.s = world.time.s + 5
	if world.time.s >= 60 then
		world.time.m = world.time.m + 1
		world.time.s = 0
	end

	if world.time.m >= 60 then
		world.time.h = world.time.h + 1
		world.time.m = 0
	end

	if world.time.h >= 24 then
		world.time.h = 0
	end
end


function love.update()
	WW = love.graphics.getWidth()
	WH = love.graphics.getHeight()

	if #CONSOLE_TEXT > 100 then
		table.remove(CONSOLE_TEXT, 1)
	end

	if STATE_PLAYER_INPUT then
		-- PLAYER INPUT LOGIC
	
	else
		-- GAME LOGIC

		answer, clear, color = parcer(world, INPUT_HISTORY[#INPUT_HISTORY])
		if clear then
			CONSOLE_TEXT = {}
		else
			if #answer > 0 then
				for i, str in ipairs(answer) do
					table.insert(CONSOLE_TEXT, {str, color})
				end
				table.insert(CONSOLE_TEXT, {""})
			end
		end

		updateTime()
		STATE_PLAYER_INPUT = true
	end
end

function love.textinput(t)
	if STATE_PLAYER_INPUT then
		PLAYER_INPUT_LINE = PLAYER_INPUT_LINE .. t
		INPUT_HISTORY_POSITION = 0
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if STATE_PLAYER_INPUT then
		if key == "backspace" then
			-- get the byte offset to the last UTF-8 character in the string.
			local byteoffset = utf8.offset(PLAYER_INPUT_LINE, -1)

			if byteoffset then
				-- remove the last UTF-8 character.
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				PLAYER_INPUT_LINE = string.sub(PLAYER_INPUT_LINE, 1, byteoffset - 1)
			end
		end

		if key == "space" then
			PLAYER_INPUT_LINE = PLAYER_INPUT_LINE .. " "
		end

		if key == "up" then
			if INPUT_HISTORY_POSITION < #INPUT_HISTORY then
				INPUT_HISTORY_POSITION = INPUT_HISTORY_POSITION + 1
				PLAYER_INPUT_LINE = INPUT_HISTORY[#INPUT_HISTORY - INPUT_HISTORY_POSITION + 1]
			end
		end

		if key == "down" then
			if INPUT_HISTORY_POSITION > 1 then
				INPUT_HISTORY_POSITION = INPUT_HISTORY_POSITION - 1
				PLAYER_INPUT_LINE = INPUT_HISTORY[#INPUT_HISTORY - INPUT_HISTORY_POSITION + 1]
			elseif INPUT_HISTORY_POSITION == 1 then
				INPUT_HISTORY_POSITION = 0
				PLAYER_INPUT_LINE = ""
			end
		end

		if key == "return" then
			if #PLAYER_INPUT_LINE > 0 then
				table.insert(CONSOLE_TEXT, {PLAYER_INPUT_LINE, 1})
				table.insert(CONSOLE_TEXT, {""})
				table.insert(INPUT_HISTORY, PLAYER_INPUT_LINE)
				PLAYER_INPUT_LINE = ""
				INPUT_HISTORY_POSITION = 0
				STATE_PLAYER_INPUT = false
			end
		end
	end
end



function love.draw()
	love.graphics.setBackgroundColor(BACKGROUND_COLOR)

	love.graphics.setFont(TEXT_FONT)
	for i, str in ipairs(CONSOLE_TEXT) do
		if str[2] == 0 then
			love.graphics.setColor(HELP_COLOR)
		elseif str[2] == 1 then
			love.graphics.setColor(PLAYER_COLOR)
		elseif str[2] == 2 then
			love.graphics.setColor(HINT_COLOR)
		elseif str[2] == 3 then
			love.graphics.setColor(EVIL_COLOR)
		else
			love.graphics.setColor(TEXT_COLOR)
		end

		love.graphics.print("  "..str[1], LINE_HEIGTH, WH - (#CONSOLE_TEXT - i + 1) * LINE_HEIGTH - LINE_HEIGTH*6)

	end

	love.graphics.setColor(PLAYER_COLOR)
	love.graphics.print("> "..PLAYER_INPUT_LINE, LINE_HEIGTH, WH - LINE_HEIGTH*4)

	love.graphics.setColor(UI_COLOR)
	love.graphics.rectangle("fill", LINE_HEIGTH*0.5, WH - LINE_HEIGTH*2, WW - LINE_HEIGTH, LINE_HEIGTH*1.5, LINE_HEIGTH*0.25)

	love.graphics.setColor(BACKGROUND_COLOR)
	love.graphics.print(world.room.name, LINE_HEIGTH, WW - TEXT_FONT:getHeight(world.room.name)*1.6)

	local shortDirectionsText = getShortDirections(world)
	-- love.graphics.print(shortDirectionsText, WW - TEXT_FONT:getWidth(shortDirectionsText) - LINE_HEIGTH, WW - TEXT_FONT:getHeight(shortDirectionsText)*1.6)

	local timeText = ""
	timeText = timeText..world.time.h..":"
	if world.time.m < 10 then
		timeText = timeText.."0"..world.time.m..":"
	else
		timeText = timeText..world.time.m..":"
	end

	if world.time.s < 10 then
		timeText = timeText.."0"..world.time.s
	else
		timeText = timeText..world.time.s
	end
	-- love.graphics.print(timeText, WW/2 - TEXT_FONT:getWidth(timeText)/2 - LINE_HEIGTH, WW - TEXT_FONT:getHeight(timeText)*1.6)
	love.graphics.print("| "..shortDirectionsText.." | "..timeText, WW - TEXT_FONT:getWidth("| "..shortDirectionsText.." | "..timeText) - LINE_HEIGTH, WW - TEXT_FONT:getHeight("| "..shortDirectionsText.." | "..timeText)*1.6)

	local steps = 25
	for i = 1, steps do
		love.graphics.setColor(BACKGROUND_COLOR[1], BACKGROUND_COLOR[2], BACKGROUND_COLOR[3], 1/steps*5)
		-- love.graphics.setColor(1, 0, 0, 1/steps*10)
		love.graphics.rectangle("fill", 0, 0, WW, 25 + i*5)
	end

	love.graphics.setColor(UI_COLOR)
	love.graphics.rectangle("line", 0 + LINE_HEIGTH/4, 0 + LINE_HEIGTH/4, WW - LINE_HEIGTH/2, WH - LINE_HEIGTH/2, LINE_HEIGTH*0.25)
end