local t = Def.ActorFrame{};
if C_GetCurName() and FileExist(THEME:GetCurrentThemeDirectory()
		.."Customs/"..C_GetCurName().."/Screen4 main") then
	t[#t+1] = Def.ActorFrame{
		LoadActor("../Customs/"..C_GetCurName().."/Screen4 main");
	};
else
	t[#t+1] = LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"));
end;
return t;