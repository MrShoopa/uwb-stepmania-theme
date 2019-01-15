local haishin = ...;
local t=Def.ActorFrame {
  FOV=90;
  InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT/2;y,-SCREEN_HEIGHT/4);
		OnCommand=cmd(diffuse,color("#689506");diffusetopedge,color("#48a632"));
	};
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT/2;y,SCREEN_CENTER_Y-(SCREEN_HEIGHT/4));
		OnCommand=cmd(diffuse,color("#689506");diffusebottomedge,color("#b4ff64"));
	};
	LoadActor("../../ScreenWithMenuElements background/_wakaba/_wakaba") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT);
	};
	LoadActor("../../ScreenWithMenuElements background/line") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2.2,SCREEN_HEIGHT*2;diffuse,color("#ffffff");rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/48,SCREEN_HEIGHT*1.5/96);
		OnCommand=cmd(texcoordvelocity,2,-0.2;diffusealpha,0.2;bob;effectmagnitude,0.5,0,15;effectperiod,4;linear,0.3;rotationy,25;x,-80);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../../ScreenWithMenuElements background/panel") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#b4ff64"));y,20;rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/480,SCREEN_HEIGHT*1.5/480);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 1 or 0,(haishin=="Off") and -0.05 or 0;diffuserightedge,1,1,1,0.5;blend,'BlendMode_Add';);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../../ScreenWithMenuElements background/fan_1") .. {
		InitCommand=cmd(zoom,1.5;rotationy,75;rotationx,-25;diffuse,Color("White");spin;effectmagnitude,0,0,20;blend,'BlendMode_Add');
		OnCommand=cmd(x,SCREEN_CENTER_X-150;y,80;;linear,0.3;x,-220;y,-50;rotationx,200;)
	};
	LoadActor("../../ScreenWithMenuElements background/_wakaba/light") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;
			horizalign,left;vertalign,top;rotationz,180);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=cmd(diffusealpha,1;
			sleep,0.05;diffusealpha,0.5;sleep,0.05;diffusealpha,1;
			sleep,0.08;diffusealpha,0.5;sleep,0.05;diffusealpha,1;
			sleep,0.4;
			sleep,0.05;diffusealpha,0.5;sleep,0.07;diffusealpha,1;
			sleep,0.05;diffusealpha,0.5;sleep,0.03;diffusealpha,1;
			sleep,0.55;queuecommand,"Loop");
	};
};

return t;
