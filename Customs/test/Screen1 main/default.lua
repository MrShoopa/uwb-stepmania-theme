local t=Def.ActorFrame{
	FOV=90;
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'));
};

local t2=Def.ActorFrame{
	InitCommand=cmd(SetDrawByZPosition,true);
	OnCommand=cmd(
		--	zbuffer,true;
		Center;
		rotationy,0;
		linear,20;
		rotationy,360;
	);
};
for i=1,3 do
t2[#t2+1]=LoadActor('cd')..{
	OnCommand=cmd(
		backfacecull,false;
		x,(i-2)*150;
		z,math.abs(i-2)*50);
};
end;
t[#t+1]=t2;
return t;