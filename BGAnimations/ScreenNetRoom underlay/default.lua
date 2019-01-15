local t;
t=Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(zoomto,200,380;diffuse,0,0,0,0.75;
			x,(GAMESTATE:IsHumanPlayer(PLAYER_1)) and SCREEN_CENTER_X-210 or SCREEN_CENTER_X+200;
			y,SCREEN_CENTER_Y+10);
	};
};
return t;