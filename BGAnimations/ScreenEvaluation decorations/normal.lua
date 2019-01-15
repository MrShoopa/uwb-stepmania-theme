local t = LoadFallbackB();

t[#t+1]=EXF_ScreenEvaluation();
if TC_GetwaieiMode()==2 then
	t[#t+1]= Def.ActorFrame{
		LoadActor("waiei2");
	};
else
	t[#t+1]= Def.ActorFrame{
		LoadActor("waiei1");
	};
end;

return t;