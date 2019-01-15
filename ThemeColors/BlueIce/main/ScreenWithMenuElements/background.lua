local haishin = ...;
local hsv_h=180;
local rnd_linear={1.0,0.3,0.2,0.5,0.2,0.3};
local rnd_sleep={1.0,2.3,3.2,3.5,0.2,2.3};
local t=Def.ActorFrame {
  FOV=90;
	--[[
	Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("#002080"););
	};
	--]]
	LoadActor("_bg1").. {
		InitCommand=cmd(scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;fadebottom,1;);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=function(self)
			self:finishtweening();
			-- [ja] 赤が汚かったので紫→橙になるように調整 
			self:diffuse(HSV((hsv_h%320),0.66,1.0));
			self:y(SCREEN_HEIGHT+SCREEN_CENTER_Y);
			self:linear(3.0);
			self:y(-SCREEN_CENTER_X);
			self:sleep(1.5);
			self:queuecommand("Loop");
		end;
	};
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;fadetop,1;);
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=function(self)
			self:finishtweening();
			self:y(SCREEN_HEIGHT+SCREEN_CENTER_Y);
			self:sleep(1.5);
			self:diffuse(HSV((hsv_h%320),0.66,1.0));
			self:y(-SCREEN_CENTER_X);
			self:linear(3.0);
			self:y(SCREEN_HEIGHT+SCREEN_CENTER_Y);
			self:queuecommand("Loop");
		end;
	};
	LoadActor("_bg2").. {
		InitCommand=cmd(scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
	};
	LoadActor("fan_1") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+20;zoom,1.5;rotationx,-50;blend,"BlendMode_Add";
			diffuse,color("#003060");spin;effectmagnitude,0,0,20);
	};
	LoadActor("_bg3").. {
		InitCommand=cmd(scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT;blend,"BlendMode_Add");
		OnCommand=cmd(playcommand,"Loop");
		LoopCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0.5);
			self:linear(rnd_linear[math.floor(math.random(#rnd_linear)+0.99)]);
			self:diffusealpha(0);
			self:sleep(rnd_sleep[math.floor(math.random(#rnd_sleep)+0.99)]);
			self:queuecommand("Loop");
		end;
	};
	Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("#002040");diffusealpha,0.5;fadetop,0.5;fadebottom,0.5);
	};
};

local d=0;
local w=1.0/10;
local function update(self,dt)
	d=d+dt;
	if d>w then
		hsv_h=hsv_h+1;
		d=d-w;
	end;
end;
t.InitCommand=cmd(SetUpdateFunction,update);

return t;
