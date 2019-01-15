local t = Def.ActorFrame {};
local haishin=GetUserPref_Theme("UserHaishin");

if TC_GetwaieiMode()==2 then
	t[#t+1] = Def.ActorFrame {
		LoadActor("bg",haishin);
	};
else
	t[#t+1] = Def.ActorFrame {
		LoadActor(TC_GetPath("ScreenSelectEXMusic","background"),haishin);
	};
end;

return t;
