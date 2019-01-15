local t = Def.ActorFrame{
	LoadActor("EditMenu Left")..{
		InitCommand=cmd(zoomx,-1);
	};
};

return t;