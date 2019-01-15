local t = Def.ActorFrame {};
local haishin=GetUserPref_Theme("UserHaishin") or "Off";

if TC_GetPath("ScreenWithMenuElements","background") then
	t[#t+1] = Def.ActorFrame {
		LoadActor(TC_GetPath("ScreenWithMenuElements","background"),haishin);
	};
end;

return t;
