local gc = Var "GameCommand";
local t = Def.ActorFrame {};
-- Background!
t[#t+1] = Def.ActorFrame {
	OffFocusedCommand=cmd(finishtweening;glow,Color("White");decelerate,0.2;zoom,2;glow,Color("Invisible");diffusealpha,0);
-- 	GainFocusCommand=cmd(visible,true);
-- 	LoseFocusCommand=cmd(visible,false);
 	Def.Quad {
		InitCommand=cmd(zoomto,470,160;diffuse,Color("Blue");diffusealpha,0;fadeleft,0.5;faderight,0.5);
		GainFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,0.5);
		LoseFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,0);
	};
 	Def.Quad {
		InitCommand=cmd(zoomto,470,160;diffuse,Color("Blue");diffusealpha,0;fadeleft,1;faderight,1;blend,"BlendMode_Add");
		GainFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.125;diffusealpha,0);
	};
};
-- Text Frame
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,-140;y,-10);
	OffFocusedCommand=cmd(finishtweening;glow,Color("White");decelerate,0.2;zoom,2;glow,Color("Invisible");diffusealpha,0);
	Def.Quad {
		InitCommand=cmd(horizalign,left;zoomto,320,2;diffuse,Color("White");
			diffusealpha,0;fadeleft,0.35;faderight,0.35);
		GainFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
	};
	LoadFont("common normal")..{
		Text=gc:GetName();
		InitCommand=cmd(horizalign,left;diffuse,color("White");
			strokecolor,ColorDarkTone(Color("Blue"));diffusealpha,0;y,-30);
		GainFocusCommand=cmd(stoptweening;decelerate,0.25;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;accelerate,0.25;diffusealpha,0;diffusealpha,0);
	};
	LoadFont("common normal")..{
		Text=THEME:GetString(Var "LoadingScreen", gc:GetName() .. "Explanation");
		InitCommand=cmd(horizalign,right;x,320;y,40;shadowlength,1;diffusealpha,0;zoom,0.5;y,-20);
		GainFocusCommand=cmd(stoptweening;y,40-16;decelerate,0.25;diffusealpha,1;y,40;maxheight,60;);
		LoseFocusCommand=cmd(stoptweening;y,40;accelerate,0.25;diffusealpha,0;y,40+16;diffusealpha,0);
	};
};
-- t.GainFocusCommand=cmd(visible,true);
-- t.LoseFocusCommand=cmd(visible,false);
return t