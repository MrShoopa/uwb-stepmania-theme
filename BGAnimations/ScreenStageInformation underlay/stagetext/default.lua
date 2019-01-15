local file = ...;
local t=Def.ActorFrame{};
if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor('waiei2',file);
else
	t[#t+1]=LoadActor('waiei1',file);
end;

return t;
