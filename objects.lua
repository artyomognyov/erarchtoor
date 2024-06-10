-- STATIC OBJECTS

PRONOUNCES = {
	FLOOR = {"пол", "полы", "земля", "землю", "плитка", "плитку", "плитки", "ковёр", "ковры", "паркет"},
	WALL = {"стена", "стену", "стены"},
	WINDOW = {"окно", "окошко", "окна", "окошки", "решётка", "решётки", "стена", "стену", "стены"},

	EXIT_LAMP = {"лампа", "лампу", "лампы", "дверь", "свет"},

	SIGN = {"табличка", "табличку", "надпись", "текст", "дверь", "проход"},
	WALL_TEXT = {"надпись", "текст", "стена", "стену", "стены"},
}

OBJECTS = {

	LAMP = {
		pronounce = {"лампа", "лампу", "лампы"},
		description = {
			"Обычная лампа, ничего особенного.",
		}
	},

	-- SPECIAL

	SIGN_1 = {
		pronounce = PRONOUNCES.SIGN,
		description = {
			"Табличка над проходом с текстом:",
			"",
			"- Lasciate ogne speranza,",
			"- voi ch’entrate.",
		},
	},

	WALL_TEXT_1 = {
		pronounce = PRONOUNCES.WALL_TEXT,
		description = {
			"Ты пытаешься прочитать слова написаные на стене.",
			"Тебе удаётся разобрать:",
			"",
			"- Мой соотрядус ушёл на 4 этаж",
			"- Количество дней: ||||| ||||| ||||| |",
		}
	},

	-- COMMON

	FLOOR_ONGROUND = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"Типичный пол в сельском ДК, выложеный",
			"белой плиткой.",
			"",
			"",
		}
	},

	FLOOR_STAGE = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	FLOOR_CABINETS = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	FLOOR_TOILET = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	FLOOR_UNDERGROUND_DRY = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	FLOOR_UNDERGROUND_WET = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	FLOOR_UNDERGROUND_BLACK = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	FLOOR_UNDERGROUND_BLOOD = {
		pronounce = PRONOUNCES.FLOOR,
		description = {
			"",
			"",
			"",
		}
	},

	WALL_DEFAULT = {
		pronounce = PRONOUNCES.WALL,
		description = {
			"Ничего обычного на стенах ты не видишь.",
		}
	},

	WALL_UNDERGROUND_DRY = {
		pronounce = PRONOUNCES.WALL,
		description = {
			"",
			"",
			"",
		}
	},

	WALL_UNDERGROUND_WET = {
		pronounce = PRONOUNCES.WALL,
		description = {
			"",
			"",
			"",
		}
	},

	WALL_UNDERGROUND_BLACK = {
		pronounce = PRONOUNCES.WALL,
		description = {
			"",
			"",
			"",
		}
	},

	WALL_UNDERGROUND_BLOOD = {
		pronounce = PRONOUNCES.WALL,
		description = {
			"",
			"",
			"",
		}
	},

	WINDOW_DEFAULT = {
		pronounce = PRONOUNCES.WINDOW,
		description = {
			"",
			"",
			"",
		}
	},

	WINDOW_CLOSET_1 = {
		pronounce = PRONOUNCES.WINDOW,
		description = {
			"Маленькое окошко на уровне метра от пола.",
			"Ты заглядываешь внутрь и видишь точно",
			"такую же кладовку. Она забита хламом,",
			"среди которого ты можешь найти",
			"что-то полезное.",
		}
	},

	EXIT_LAMP = {
		pronounce = PRONOUNCES.EXIT_LAMP,
		description = {
			'Зеленоватая лампа с надписью "ВЫХОД".',
			"Используется при пожаре.",
		}
	},


}