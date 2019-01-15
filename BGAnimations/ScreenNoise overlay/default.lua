return Def.ActorFrame{
	LoadActor("video3")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:vertalign(top);
			self:x(SCREEN_RIGHT);
			self:y(SCREEN_TOP);
		end;
	}
};