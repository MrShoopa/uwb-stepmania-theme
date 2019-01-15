local waieiInfo={
	BGScale="Off",
	Haishin="Off",
	BGRatio=1.333333,
	BGStart=1.0,
};

function SetwaieiInfo(prm,var)
	if prm=="BGScale" then
		waieiInfo["BGScale"]=var;
	elseif prm=="Haishin" then
		waieiInfo["Haishin"]=var;
	elseif prm=="BGRatio" then
		if var~="" then
			waieiInfo["BGRatio"]=tonumber(var);
		else
			waieiInfo["BGRatio"]=1.333333;
		end;
	elseif prm=="BGStart" then
		waieiInfo["BGStart"]=var;
	end;
end;

function GetwaieiInfo(prm)
	if prm=="BGScale" then
		return waieiInfo["BGScale"];
	elseif prm=="Haishin" then
		return waieiInfo["Haishin"];
	elseif prm=="BGRatio" then
		if var~="" then
			return waieiInfo["BGRatio"];
		else
			return waieiInfo["BGRatio"];
		end;
	elseif prm=="BGStart" then
		return waieiInfo["BGStart"];
	end;
	return nil;
end;

function Actor:scale_or_crop_background()
	local gw = self:GetWidth()
	local gh = self:GetHeight()

	local graphicAspect = gw/gh
	local displayAspect = DISPLAY:GetDisplayWidth()/DISPLAY:GetDisplayHeight()

	local bgs = GetBGScale();
	if bgs == 'Cover' then
		self:scaletocover( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
	else
		self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
	end;

end;

local function CurGameName()
	return GAMESTATE:GetCurrentGame():GetName()
end

function ComboContinue()
	local Continue = {
		dance = GetUserPref_Theme("UserMinCombo"),
		pump = GetUserPref_Theme("UserMinCombo"),
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4",
		techno = GetUserPref_Theme("UserMinCombo")
	}
	return Continue[CurGameName()]
end

function ComboMaintain()
	local Maintain = {
		dance = GetUserPref_Theme("UserMinCombo"),
		pump = GetUserPref_Theme("UserMinCombo"),
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4",
		techno = GetUserPref_Theme("UserMinCombo")
	}
	return Maintain[CurGameName()]
end

function GameCompatibleModes()
	local Modes = {
		dance = "Single,Versus,Double,Solo,Couple",
		pump = "Single,Versus,Double,HalfDouble,Couple,Routine",
		beat = "5Keys,Versus5,7Keys,10Keys,14Keys,Versus7",
		kb7 = "KB7",
		para = "Single",
		maniax = "Single,Versus,Double",
		-- todo: add versus modes for technomotion
		techno = "Single4,Single5,Single8,Double4,Double5,Double8",
		lights = "Single" -- lights shouldn't be playable
	}
	return Modes[CurGameName()]
end

function AllowOptionsMenu()
  if GAMESTATE:IsAnExtraStage() then
    return false
  else
    return true
  end
end

function Actor:LyricCommand(side)
	if true then
		self:visible(false);
		return
	end;
end;

function ScreenSelectMusic:setupmusicstagemods()
	Trace( "setupmusicstagemods" )
	local pm = GAMESTATE:GetPlayMode()

	if pm == "PlayMode_Battle" or pm == "PlayMode_Rave" then
		local so = GAMESTATE:GetDefaultSongOptions()
		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	elseif GAMESTATE:IsAnExtraStage() then
		if GAMESTATE:GetPreferredSongGroup() == "---Group All---" then
			local song = GAMESTATE:GetCurrentSong()
			GAMESTATE:SetPreferredSongGroup( song:GetGroupName() )
		end

		local bExtra2 = GAMESTATE:IsExtraStage2()
		local style = GAMESTATE:GetCurrentStyle()
		local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style )
		local po, so
		if bExtra2 then
			po = THEME:GetMetric("SongManager","OMESPlayerModifiers")
			so = THEME:GetMetric("SongManager","OMESStageModifiers")
		else
			po = THEME:GetMetric("SongManager","ExtraStagePlayerModifiers")
			so = THEME:GetMetric("SongManager","ExtraStageStageModifiers")
		end

		local difficulty = steps:GetDifficulty()
		local Reverse = PlayerNumber:Reverse()

		GAMESTATE:SetCurrentSong( song )
		GAMESTATE:SetPreferredSong( song )

-- [ja] EXFolderのオプションを保持するため一部コメント化 
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			--[ja] ↓AutoSetStyleがOFFの時、2重にStyleがセットされてしまう問題の対策
			if THEME:GetMetric("Common","AutoSetStyle") == true then
				GAMESTATE:SetCurrentSteps( pn, steps )
			end
			GAMESTATE:SetCurrentSteps( pn, steps )
--			GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
			GAMESTATE:SetPreferredDifficulty( pn, difficulty )
--			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end

--		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
--		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	end
end;

-- [ja] 落ちるんでCyberiaStyle8のものと差し替え 
function ScreenSelectMusic:setupcoursestagemods()
	local mode = GAMESTATE:GetPlayMode()

	if mode == "PlayMode_Oni" then
		local po = "clearall,default"
		-- Let SSMusic set battery.
		--local sob = "failimmediate,battery"
		local so = "failimmediate"
		local Reverse = PlayerNumber:Reverse()

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
--			GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
			MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
		end

		GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
		MESSAGEMAN:Broadcast( "SongOptionsChanged" )
	end
end;

--[ja] NightlyBuildsの最新版で処理がおかしいので暫定対応 
function Center1Player()
	local styleType = GAMESTATE:GetCurrentStyle():GetStyleType();
	-- always center in OnePlayerTwoSides ( Doubles ) or TwoPlayersSharedSides ( Couples )
	if styleType == "StyleType_OnePlayerTwoSides" or 
		styleType == "StyleType_TwoPlayersSharedSides" then
		return true
	-- only Center1P if Pref enabled and OnePlayerOneSide.
	-- (implicitly excludes Rave, Battle, Versus, Routine)
	elseif PREFSMAN:GetPreference("Center1Player") then
		return styleType == "StyleType_OnePlayerOneSide"
	else
		return false
	end
end

-- Round to nearest integer.
function math.round(n)
	if n > 0 then
		return math.floor(n+0.5)
	else
		return math.ceil(n-0.5)
	end
end
