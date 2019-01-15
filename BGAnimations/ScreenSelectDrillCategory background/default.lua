local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"));
	Def.Sound {
		InitCommand=function(self)
			self:load(THEME:GetPathS("_DrillCategory","music"));
			self:stop();
			self:queuecommand("Play");
		end;
		PlayCommand=cmd(play);
	};
};
return t;