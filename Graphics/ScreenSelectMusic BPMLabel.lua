return Def.ActorFrame {
	LoadFont("Common Normal") .. {
		Text="BPM";
		OnCommand=cmd(horizalign,left;vertalign,top;strokecolor,Color("Black");zoom,0.5;zoomy,0;linear,0.2;zoomy,0.5;);
		--THEME:GetMetric("ScreenSelectMusic","BPMLabelOnCommand");
		OffCommand=THEME:GetMetric("ScreenSelectMusic","BPMLabelOffCommand");
	};
};