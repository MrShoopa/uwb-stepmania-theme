return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,Color((TC_GetwaieiMode()==2) and 'White' or 'Black');diffusealpha,0);
		OnCommand=cmd(sleep,math.max(TC_GetMetric('Wait','GameplayOut')-2.0,0.5);linear,0.2;diffusealpha,1;);
	};
	LoadActor("song_graphic");
	LoadActor(THEME:GetPathG( "_cleared/cleared", "text" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,2;);
		OnCommand=cmd(sleep,math.max(TC_GetMetric('Wait','GameplayOut')-1.5,1.0);linear,0.2;diffusealpha,1;zoom,1;
			sleep,0.5;linear,1.0;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG( "_cleared/cleared", "text" ) ) .. {
		InitCommand=cmd(scaletocover,0,0,1280,480;Center;diffusealpha,0;zoom,1;blend,"BlendMode_Add");
		OnCommand=cmd(sleep,math.max(TC_GetMetric('Wait','GameplayOut')-1.0,1.5);diffusealpha,1;
			linear,0.4;diffusealpha,0;zoom,2);
	};
--	LoadActor(THEME:GetPathB("ScreenGameplay","overlay/songtitle"));
	LoadActor(THEME:GetPathG("_FullCombo","Effect"));
};