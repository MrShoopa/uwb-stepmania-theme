local file = ...;
return Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-15);
	LoadActor( file ) .. {
		OnCommand=cmd(zoom,0.8;diffusealpha,0;addx,-60;linear,0.25;diffusealpha,1;addx,60;sleep,1.5;linear,0.25;addx,60;diffusealpha,0);
	};
};