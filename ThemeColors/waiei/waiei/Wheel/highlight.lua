return Def.ActorFrame{
	LoadActor("_highlight")..{
		InitCommand=function(self)
			self:y(-48);
		end;
	};
};