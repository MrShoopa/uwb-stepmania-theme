local customscore_b2;
if GetCustomScoreMode()=="non" and GAMESTATE:GetPlayMode()=='PlayMode_Regular'
	and not PREFSMAN:GetPreference("PercentageScoring") then
		customscore_b2=true;
	else
		customscore_b2=false;
end;

local t=Def.ActorFrame{};

if customscore_b2 then
	t[#t+1]=Def.ActorFrame{
		LoadActor("_ScreenGameplay ScoreFrame/B2Score",PLAYER_1);
	};
end;

return t;