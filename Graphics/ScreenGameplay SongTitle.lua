local t = Def.ActorFrame{};
if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor(THEME:GetPathG("_ScreenGameplay","Title/waiei2"));
else
	t[#t+1]=LoadActor(THEME:GetPathG("_ScreenGameplay","Title/waiei1"));
end;
return t;
