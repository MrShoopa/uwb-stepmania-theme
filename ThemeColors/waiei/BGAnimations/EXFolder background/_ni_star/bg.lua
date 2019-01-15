local haishin = ...;
local t=Def.ActorFrame {
  FOV=90;
  InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT/2;y,-SCREEN_HEIGHT/4);
		OnCommand=cmd(diffuse,color("#203070");diffusetopedge,color("#001060"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT/2;y,SCREEN_CENTER_Y-(SCREEN_HEIGHT/4));
		OnCommand=cmd(diffuse,color("#203070");diffusebottomedge,color("#9999ff"));
	};
	LoadActor("../../ScreenWithMenuElements background/line") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2.2,SCREEN_HEIGHT*2;diffuse,color("#ffffff");rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/48,SCREEN_HEIGHT*1.5/96;blend,'BlendMode_Add');
		OnCommand=cmd(texcoordvelocity,2,-0.2;diffuserightedge,1,1,0.4,0.2;bob;effectmagnitude,0.5,0,15;effectperiod,4;linear,0.3;rotationy,25;x,-80);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../../ScreenWithMenuElements background/panel") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#ffff00"));y,20;rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/480,SCREEN_HEIGHT*1.5/480);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 1 or 0,(haishin=="Off") and -0.05 or 0;diffuserightedge,1,1,1,0.5;);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../../ScreenWithMenuElements background/fan_1") .. {
		InitCommand=cmd(zoom,1.5;rotationy,75;rotationx,-25;diffuse,color("#ffffff");spin;effectmagnitude,0,0,20;blend,'BlendMode_Add');
		OnCommand=cmd(x,SCREEN_CENTER_X-150;y,80;linear,0.3;x,-220;y,-50;rotationx,200;)
	};
	LoadActor("../../ScreenWithMenuElements background/_ni_star/_particleLoader") .. {
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
	LoadActor(THEME:GetPathG("information/Information","Cube2")) .. {
		InitCommand=cmd(rotationx,-45;diffuse,ColorLightTone(color("#0064FF"));spin;effectmagnitude,0,20,0;);
		OnCommand=cmd(x,-220;y,-50;zoom,SCREEN_HEIGHT/800;linear,0.3;x,SCREEN_CENTER_X-150;y,80;rotationx,45;)
	};
};

return t;