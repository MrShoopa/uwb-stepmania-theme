ResetAnnouncer();
DrillOptionsReset_inTitle();

waieiLoadPref();

local mtimer=45.2;
local t=Def.ActorFrame{};
t[#t+1]=EXF_ScreenTitleMenu();
t[#t+1]=Def.ActorFrame{
	LoadActor("../ScreenWithMenuElements overlay/default")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+40);
	};
	Def.Quad{
	  InitCommand=cmd(Center;zoomto,SCREEN_WIDTH+1,SCREEN_HEIGHT+1;
		diffuse,Color("Black");diffusealpha,0;);
	  OnCommand=cmd(playcommand,"Loop";);
	  LoopCommand=function(self)
		self:finishtweening();
		self:sleep(0.1);
		mtimer=mtimer-0.1;
		if mtimer<=0 then
			self:linear(0.5);
			self:diffusealpha(1);
			self:sleep(0.5);
			self:queuecommand("Next");
		end;
		self:queuecommand("Loop");
	  end;
	  NextCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenHowToPlay");
	  end;
	};
};

return t;