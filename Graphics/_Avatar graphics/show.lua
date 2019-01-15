local offsetx,angle,zoom=...;
offsetx=offsetx or 35;
zoom=zoom or 0.6;
return Def.ActorFrame{
	LoadActor(THEME:GetPathG('_Avatar','graphics'),1,GetPlayerAvatar(PLAYER_1))..{
		InitCommand=cmd(visible,GAMESTATE:IsPlayerEnabled(PLAYER_1));
		OnCommand=cmd(zoomx,zoom*2;zoomy,0;
			x,offsetx;rotationy,angle and 0 or 180;
			linear,0.2;zoom,zoom;);
		OffCommand=cmd(linear,0.2;zoomx,zoom*2;zoomy,0);
	};
	LoadActor(THEME:GetPathG('_Avatar','graphics'),2,GetPlayerAvatar(PLAYER_2))..{
		InitCommand=cmd(visible,GAMESTATE:IsPlayerEnabled(PLAYER_2));
		OnCommand=cmd(zoomx,zoom*2;zoomy,0;
			x,SCREEN_RIGHT-offsetx;rotationy,angle and 180 or 0;
			linear,0.2;zoom,zoom;);
		OffCommand=cmd(linear,0.2;zoomx,zoom*2;zoomy,0);
	};
};