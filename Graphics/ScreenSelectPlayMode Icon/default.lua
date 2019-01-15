local gc = Var("GameCommand");
local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame { 
  GainFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconGainFocusCommand");
  LoseFocusCommand=THEME:GetMetric(Var "LoadingScreen","IconLoseFocusCommand");
--	IconGainFocusCommand=cmd(stoptweening;glowshift;decelerate,0.125;zoom,1);
--	IconLoseFocusCommand=cmd(stoptweening;stopeffect;decelerate,0.125;zoom,fZoom);

	--[[
	LoadActor("_background base")..{
		InitCommand=cmd(diffuse,ModeIconColors[gc:GetName()]);
	};
	LoadActor("_background effect");
	LoadActor("_gloss");
	LoadActor("_stroke");
	LoadActor("_cutout");
	--]]
	LoadActor("icon_"..gc:GetName())..{
		DisabledCommand=cmd(zoom,0.5);
		EnabledCommand=cmd(zoom,1.0);
		OffCommand=cmd(linear,0.2;diffusealpha,0;zoomy,0;);
	};
};
return t