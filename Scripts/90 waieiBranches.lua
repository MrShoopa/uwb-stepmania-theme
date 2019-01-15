
Branch_Theme = {
	Welcomewaiei = function()
		if GetUserPref_Theme("waieiThemeVersion") ~= nil then
			local s=GetUserPref_Theme("waieiThemeVersion");
			local n=(""..GetThemeVersionInformation("Version"))
			if string.sub(s,1,4)~=string.sub(n,1,4) then
				return "ScreenWelcomewaiei";
			elseif s~=n then
				SetUserPref_Theme("waieiThemeVersion",GetThemeVersionInformation("Version"));
				return Branch.AfterInit();
			else
				return Branch.AfterInit();
			end;
		else
			SetUserPref_Theme("waieiThemeVersion",GetThemeVersionInformation("Version"));
			return "ScreenWelcomewaiei";
		end;
	end,
	AfterProfileSave = function()
		if GAMESTATE:IsEventMode() then
			return SelectMusicOrCourse()
		elseif STATSMAN:GetCurStageStats():AllFailed() or GAMESTATE:IsCourseMode() then
			if GAMESTATE:GetCurrentStageIndex()<2 then
				return "ScreenGameOver"
			else
				return "ScreenEvaluationSummary"
			end;
		elseif GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() == 0 then
			return "ScreenEvaluationSummary"
		else
			return SelectMusicOrCourse()
		end
	end,
	AfterSummary = function()
		return "ScreenProfileSaveSummary"
	end,
	PlayerOptions = function()
		local pm = GAMESTATE:GetPlayMode()
		local restricted = { "PlayMode_Rave",
			--"PlayMode_Battle" -- ??
		}
		local optionsScreen = "ScreenPlayerOptions"
		for i=1,#restricted do
			if restricted[i] == pm then
				optionsScreen = "ScreenPlayerOptionsRestricted"
			end
		end
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return optionsScreen
		else
			return "ScreenStageInformation"
		end
	end,
	SongOptions = function()
		if SCREENMAN:GetTopScreen():GetGoToOptions()
			and GAMESTATE:GetPlayMode() ~= "PlayMode_Oni" 
			and not GAMESTATE:IsAnExtraStage()
			and not IsDrill() then
			return "ScreenSongOptions"
		else
			return "ScreenStageInformation"
		end
	end,
};
