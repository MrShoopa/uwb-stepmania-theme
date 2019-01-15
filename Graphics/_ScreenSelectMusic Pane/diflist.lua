local pn,difcolor,difname,meter_type=...;
local t=Def.ActorFrame{};
if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor("waiei2_list",pn,difcolor,difname,meter_type);
else
	t[#t+1]=LoadActor("waiei1_list",pn,difcolor,difname,meter_type);
end;
return t;