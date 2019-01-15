local t = LoadFallbackB();

t[#t+1]=EXF_ScreenEvaluation();
if TC_GetwaieiMode()==2 then
	t[#t+1]= Def.ActorFrame{
		LoadActor("waiei2");
	};
else
	t[#t+1]= Def.ActorFrame{
		LoadActor("waiei1");
	};
end;

--[[
for i=1,5 do
t[#t+1]= LoadActor(THEME:GetPathG('_Gameplay','Target'),PLAYER_1,i,true)..{
	InitCommand=cmd(x,SCREEN_WIDTH-150;y,100+(i-1)*75;zoom,1.0);
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("TargetScore",{
			PlayerNumber = PLAYER_1,
			DPPlayer     = STATSMAN:GetPlayedStageStats(1):GetPlayerStageStats(PLAYER_1):GetPercentDancePoints(),
			DPCurrent    = 1.0
		});
	end;
};
end;
--]]

return t;