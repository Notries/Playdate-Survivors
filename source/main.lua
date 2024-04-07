import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/GameOver'
import 'scenes/GameOver2'
import 'scenes/CombatOne'

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Score = 0,
	HighScore = 0
},
1,
true,
true)

Noble.GameData.reset("Score")

Noble.showFPS = true

Noble.new(CombatOne)