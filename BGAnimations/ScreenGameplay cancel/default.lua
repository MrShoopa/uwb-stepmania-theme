return Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("0,0,0,0.5");sleep,0.15;diffusealpha,1;sleep,0.15);
	};
	LoadActor(THEME:GetPathS("_Screen","cancel")) .. {
		StartTransitioningCommand=cmd(play);
	};
	LoadActor(THEME:GetPathG("_Loading/loading","begin"))..{
		OnCommand=cmd(zoomx,4;zoomy,0;diffusealpha,0;linear,0.2;
			zoomx,1;zoomy,1;diffusealpha,1);
	};
};