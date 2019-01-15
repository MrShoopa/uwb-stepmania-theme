local file = ...;
return Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-15);
	LoadActor( file ) .. {
		OnCommand=cmd(
			diffusealpha,0;linear,0.2;diffusealpha,1;
			sleep,0.5;linear,0.2;diffusealpha,0
		);
	};
	LoadActor( file ) .. {
		OnCommand=cmd(
			zoom,1.01;blend,"BlendMode_Add";diffusealpha,0;
			sleep,0.6;diffusealpha,1;
		--	linear,1.0;zoom,0.99;diffusealpha,0;
		);
	};
};