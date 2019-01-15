local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,Color("Black"));
		OnCommand=cmd(diffusealpha,1;linear,0.3;diffusealpha,0;
			sleep,1;linear,0.3;diffusealpha,1);
	};
};
return t;