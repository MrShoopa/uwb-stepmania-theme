local haishin = ...;
local t=Def.ActorFrame {
  FOV=90;
  InitCommand=cmd(Center);
	LoadActor("_bg_01") .. {
		InitCommand=cmd(zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;);
	};
	LoadActor("white") .. {
		InitCommand=cmd(blend,"BlendMode_Add");
	};
	LoadActor("_bg_02") .. {
		InitCommand=cmd(zoomto,SCREEN_HEIGHT,SCREEN_HEIGHT;blend,"BlendMode_Add");
		OnCommand=function(self)
			self:finishtweening();
			self:diffusealpha(1);
			self:rotationz(0);
			self:zoomto(SCREEN_HEIGHT,SCREEN_HEIGHT);
			self:spring(25);
			self:diffusealpha(0.5);
			self:rotationz(180);
			self:zoomto(SCREEN_WIDTH,SCREEN_WIDTH);
			self:spring(25);
			self:diffusealpha(1);
			self:rotationz(360);
			self:zoomto(SCREEN_HEIGHT,SCREEN_HEIGHT);
			self:queuecommand("On");
		end;
	};
	LoadActor("_bg_02") .. {
		InitCommand=cmd(zoomto,SCREEN_HEIGHT*2,SCREEN_HEIGHT*2;blend,"BlendMode_Add";diffusealpha,0.3;);
	};
	LoadActor("_over_01") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.5;);
		OnCommand=cmd(texcoordvelocity,0.02,0;);
	};
	LoadActor("_over_02") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.5;);
		OnCommand=cmd(texcoordvelocity,-0.02,0;);
	};
	LoadActor("komono") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.5;zoomto,SCREEN_WIDTH,SCREEN_WIDTH*480/640);
		OnCommand=cmd(texcoordvelocity,0.005,0.01;);
	};
	LoadActor("komono") .. {
		InitCommand=cmd(blend,"BlendMode_Add";diffusealpha,0.3;zoomto,SCREEN_WIDTH,SCREEN_WIDTH*480/640);
		OnCommand=cmd(spin;effectmagnitude,0,0,8);
	};
	LoadActor("../fan_1") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-150;y,80;zoom,1.5;rotationy,75;rotationx,-25;diffuse,ColorLightTone(color("#0064FF"));spin;effectmagnitude,0,0,20;blend,'BlendMode_Add');
	};
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0.3);
	};
};

return t;
