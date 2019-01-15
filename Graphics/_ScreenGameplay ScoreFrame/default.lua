local t=Def.ActorFrame{};
	if TC_GetwaieiMode()==2 then
		t[#t+1]=LoadActor(TC_GetPath("ScreenGameplay","ScoreFrame"));
	else
		t[#t+1]=LoadActor(TC_GetPath("ScreenGameplay","ScoreFrame"))..{
			InitCommand=cmd(diffuseupperleft,0,0,0,0;zoomy,0.7;y,4);
		};
	end;
return t;
