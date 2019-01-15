
local t=Def.ActorFrame{FOV=60;};
if TC_GetwaieiMode()==1 then
	local haishin=GetUserPref_Theme("UserHaishin");
	local cube=((haishin=="Off") and "Cube2" or "Cube1");
	t[#t+1]=LoadActor(THEME:GetPathG("","_objects/"..cube)) .. {
		InitCommand=cmd(y,SCREEN_CENTER_Y-50;rotationx,-45;
		diffuse,ColorLightTone(color("#0064FF"));spin;effectmagnitude,0,20,0;);
		OnCommand=cmd(x,SCREEN_RIGHT;zoom,0;decelerate,1.0;x,SCREEN_CENTER_X-220;zoom,SCREEN_HEIGHT/800;)
	};
end;
return t;