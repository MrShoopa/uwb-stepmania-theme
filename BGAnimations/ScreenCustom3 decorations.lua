local t = Def.ActorFrame{};
if C_GetCurName() and FileExist(THEME:GetCurrentThemeDirectory()
		.."Customs/"..C_GetCurName().."/Screen3 sub") then
	t[#t+1] = Def.ActorFrame{
		LoadActor("../Customs/"..C_GetCurName().."/Screen3 sub");
	};
end;
return t;