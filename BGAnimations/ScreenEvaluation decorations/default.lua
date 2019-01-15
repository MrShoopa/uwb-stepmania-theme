local summary=THEME:GetMetric( Var "LoadingScreen","Summary" );
local t=Def.ActorFrame{};
if not IsDrill() then
	if summary then
		t[#t+1]=LoadActor("summary");
	else
		t[#t+1]=LoadActor("normal");
	end;
	t[#t+1]= LoadActor(THEME:GetPathG('_Avatar','graphics/show'),310,true)..{
		InitCommand=cmd(y,SCREEN_BOTTOM-90);
		OnCommand=function(self)
			for pn in ivalues(PlayerNumber) do
				if GAMESTATE:IsPlayerEnabled(pn) then
					local p=(pn==PLAYER_1) and 1 or 2;
					local pss = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(pn);
					local pct = pss:GetPercentDancePoints();
					if PROFILEMAN:IsPersistentProfile(pn) then
						-- player profile
						profile = PROFILEMAN:GetProfile(pn);
					else
						-- machine profile
						profile = PROFILEMAN:GetMachineProfile();
					end;
					scorelist = profile:GetHighScoreList(_SONG(),GAMESTATE:GetCurrentSteps(pn));
					local scores = scorelist:GetHighScores();
					if pct>=GetScoreData(scores,"dp") then
						MESSAGEMAN:Broadcast("AvatarChanged",{id=p,t=AVATAR_WIN});
					else
						MESSAGEMAN:Broadcast("AvatarChanged",{id=p,t=AVATAR_NORMAL});
					end;
				end;
			end;
		end;
	};
end;

return t;