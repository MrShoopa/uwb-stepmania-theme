local timer=tonumber(THEME:GetMetric("ScreenLogo","TimerSeconds"));
local nTime=0;
local sys_key=true;
ResetAnnouncer();
setenv("_ScreenStart",false);
local nextscreenname="";
local t=Def.ActorFrame{
	OnCommand=function(self)
		SOUND:PlayAnnouncer("title menu game name");
	end;
	OffScreenCommand=function(self)
		self:finishtweening();
		sys_key=false;
		setenv("_ScreenStart",true);
		self:sleep(0.4);
		self:queuecommand(nextscreenname);
	end;
	NextScreenCommand=function(self)
		setenv("_ScreenStart",nil);
		SCREENMAN:SetNewScreen("ScreenHowToPlay");
	end;
	GoTitleScreenCommand=function(self)
		setenv("_ScreenStart",nil);
		SCREENMAN:SetNewScreen("ScreenTitleMenu");
	end;
	GoInitScreenCommand=function(self)
		setenv("_ScreenStart",nil);
		SCREENMAN:SetNewScreen("ScreenInit");
	end;
	CodeCommand=function(self,params)
		if sys_key then
			self:finishtweening();
			if (params.Name == 'Left' or params.Name == 'Right')
				and nTime>1.0 then
				nextscreenname="NextScreen";
				self:queuecommand("OffScreen");
			elseif params.Name == 'Start' or params.Name == 'Back' then
				nextscreenname="GoTitleScreen";
				--nextscreenname="ScreenAMVTest";
				self:queuecommand("OffScreen");
			end;
		end;
	end;
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
		OffScreenCommand=function(self)
			self:diffusealpha(0);
			self:linear(0.4);
			self:diffusealpha(1);
		end;
	};
	LoadActor(THEME:GetPathS("Common","start"))..{
		OffScreenCommand=function(self)
			if nextscreenname=="GoTitleScreen" then
				self:play();
			end;
		end;
	};
};

local anno_title=1;
local function update(self,dt)
	nTime=nTime+dt;
	if not getenv("_ScreenStart") then
		if nTime/8>anno_title then
			SOUND:PlayAnnouncer("title menu attract");
			anno_title=anno_title+1;
		end;
		if nTime>=timer then
			nextscreenname="NextScreen";
			self:queuecommand("OffScreen");
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update);

return t;