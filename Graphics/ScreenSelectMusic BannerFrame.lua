local t=Def.ActorFrame{};
if TC_GetwaieiMode()==2 then
	t[#t+1]=LoadActor(THEME:GetPathG("","_BannerFrame/waiei2_BannerFrame"));
else
	t[#t+1]=LoadActor(THEME:GetPathG("","_BannerFrame/waiei1_BannerFrame"));
end;
return t;