local pn = ...;
local difcolor=GetUserPref_Theme("UserDifficultyColor");
local difname=GetUserPref_Theme("UserDifficultyName");
local meter_type=GetUserPref_Theme("UserMeterType");
local t=Def.ActorFrame{};
if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor("waiei2_pane",pn,difcolor,difname,meter_type);
else
	t[#t+1]=LoadActor("waiei1_pane",pn,difcolor,difname,meter_type);
end;
return t;