ModeIconColors = {
	Easy		= color("#00C0ff"),
	Normal		= color("#00C0ff"),
	Hard		= color("#00C0ff"),
	Rave		= color("#64C000"),
	Nonstop		= color("#ffff00"),
	Extended	= color("#ffff00"),
	Drill		= color("#ff0000"),
	Oni			= color("#ff8000"),
	Endless		= color("#ff0000"),
}
GameColor = {
	PlayerColors = {
		PLAYER_1 = color("#0089cf"),
		PLAYER_2 = color("#cf408d"),
		PLAYER_3 = color("#ef403d"),
	},
	Difficulty = {
		--[[ These are for 'Custom' Difficulty Ranks. It can be very  useful
		in some cases, especially to apply new colors for stuff you
		couldn't before. (huh? -aj) ]]
		Beginner	= color("#ff32f8"),			-- light cyan
		Easy		= color("#2cff00"),			-- green
		Medium		= color("#fee600"),			-- yellow
		Hard		= color("#ff2f39"),			-- red
		Challenge	= color("#1cd8ff"),			-- light blue
		Edit		= color("0.8,0.8,0.8,1"),	-- gray
		Couple		= color("#ed0972"),			-- hot pink
		Routine		= color("#ff9a00"),			-- orange
		--[[ These are for courses, so let's slap them here in case someone
		wanted to use Difficulty in Course and Step regions. ]]
		Difficulty_Beginner	= color("#ff32f8"),		-- purple
		Difficulty_Easy		= color("#2cff00"),		-- green
		Difficulty_Medium	= color("#fee600"),		-- yellow
		Difficulty_Hard		= color("#ff2f39"),		-- red
		Difficulty_Challenge	= color("#1cd8ff"),	-- light blue
		Difficulty_Edit 	= color("0.8,0.8,0.8,1"),		-- gray
		Difficulty_Couple	= color("#ed0972"),				-- hot pink
		Difficulty_Routine	= color("#ff9a00")				-- orange
	},
	Stage = {
		Stage_1st	= color("#32d8ff"),
		Stage_2nd	= color("#32d8ff"),
		Stage_3rd	= color("#32d8ff"),
		Stage_4th	= color("#32d8ff"),
		Stage_5th	= color("#32d8ff"),
		Stage_6th	= color("#32d8ff"),
		Stage_Next	= color("#32d8ff"),
		Stage_Final	= color("#ffff80"),
		Stage_Extra1	= color("#ff1010"),
		Stage_Extra2	= color("#e0e0ff"),
		Stage_Nonstop	= color("#FFFFFF"),
		Stage_Oni	= color("#FFFFFF"),
		Stage_Endless	= color("#FFFFFF"),
		Stage_Event	= color("#FFFFFF"),
		Stage_Demo	= color("#FFFFFF"),
	},
	Judgment = {
		JudgmentLine_W1		= color("#bfeaff"),
		JudgmentLine_W2		= color("#fff568"),
		JudgmentLine_W3		= color("#60e040"),
		JudgmentLine_W4		= color("#34bfff"),
		JudgmentLine_W5		= color("#e44dff"),
		JudgmentLine_Held	= color("#FFFFFF"),
		JudgmentLine_Miss	= color("#ff3c3c"),
		JudgmentLine_MaxCombo	= color("#ffc600")
	},
}

function PlayerColor( pn )
	if TC_GetPlayerColorMode()==2 then
		return ((pn==PLAYER_1) and GameColor.PlayerColors["PLAYER_1"] or GameColor.PlayerColors["PLAYER_2"]);
	else
		return ((pn==PLAYER_1) and GameColor.PlayerColors["PLAYER_3"] or GameColor.PlayerColors["PLAYER_1"]);
	end;
	return color("1,1,1,1")
end
function PlayerScoreColor( pn )
	if pn == PLAYER_1 then return GameColor.PlayerColors["PLAYER_1"] end
	if pn == PLAYER_2 then return GameColor.PlayerColors["PLAYER_2"] end
	return color("1,1,1,1")
end

GameColor.Difficulty["Crazy"] = GameColor.Difficulty["Hard"]
GameColor.Difficulty["Freestyle"] = GameColor.Difficulty["Easy"]
GameColor.Difficulty["Nightmare"] = GameColor.Difficulty["Challenge"]
GameColor.Difficulty["HalfDoubleEasy"] = GameColor.Difficulty["Easy"]
GameColor.Difficulty["HalfDoubleMedium"] = GameColor.Difficulty["Medium"]
GameColor.Difficulty["HalfDoubleHard"] = GameColor.Difficulty["Hard"]
GameColor.Difficulty["HalfDoubleExpert"] = GameColor.Difficulty["Expert"]

