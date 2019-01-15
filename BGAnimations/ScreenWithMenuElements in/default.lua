local fSleepTime = 0.5;

return Def.ActorFrame{
	Def.Actor{
		OnCommand=cmd(sleep,fSleepTime);
	};
	Def.Quad{
		InitCommand=cmd(Center;zoomtowidth,SCREEN_WIDTH+2;diffuse,color("#2080FF");blend,'BlendMode_Add';);
		OnCommand=cmd(diffusealpha,1;zoomtoheight,0;linear,0.3;diffusealpha,0;zoomtoheight,SCREEN_HEIGHT+2;);
	};
};
