ReloadSongFlag();
local t = Def.ActorFrame{
	LoadActor(THEME:GetPathB("ScreenWithMenuElements","background/waiei2_bg"))..{
		InitCommand=cmd(scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0.1,0.4,0.5);
	};
	LoadActor(THEME:GetPathG("","_Logo"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;
			x,SCREEN_RIGHT-200;y,SCREEN_BOTTOM-160);
	};
};
return t;