local pn = ...;
local t=Def.ActorFrame{};

-- [ja] スコアフレーム
if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor(TC_GetPath("Gameplay","ScoreFrame"));
else
	t[#t+1]=LoadActor(TC_GetPath("ScreenGameplay","ScoreFrame"))..{
		InitCommand=cmd(diffuseupperleft,0,0,0,0;zoomy,0.7;y,4);
	};
end;

-- [ja] スコア表示
t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathB("ScreenGameplay","overlay/score"),pn)..{
		InitCommand=cmd(player,pn;);
	};
};
return t;
