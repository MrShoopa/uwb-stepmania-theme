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
	LoadActor("_wakaba") .. {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT);
	};
	LoadActor("../line") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#ffffff"));rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/48,SCREEN_HEIGHT*1.5/96);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 2 or 0,(haishin=="Off") and -0.2 or 0;
			diffusealpha,0.05;blend,"BlendMode_Add";bob;effectmagnitude,0.5,0,15;effectperiod,4);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../panel") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;diffuse,ColorLightTone(color("#b4ff64"));y,20;rotationy,-20;customtexturerect,0,0,SCREEN_WIDTH*1.5/480,SCREEN_HEIGHT*1.5/480);
		OnCommand=cmd(texcoordvelocity,(haishin=="Off") and 1 or 0,(haishin=="Off") and -0.05 or 0;diffuserightedge,1,1,1,0.5;);
		--bob;effectmagnitude,50,0,35;
	};
	LoadActor("../fan_1") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-150;y,80;zoom,1.5;rotationy,75;rotationx,-25;diffuse,Color("White");spin;effectmagnitude,0,0,20;);
	};
	LoadActor("light") .. {
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y;
			horizalign,left;vertalign,top);
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
