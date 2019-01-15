local pn=...;
return Def.ActorFrame{
	LoadActor("underlay")..{
		InitCommand=function(self)
			self:zoom(0.75);
			self:diffuse(PlayerColor(pn));
			self:diffusealpha(0.75);
		end;
	};
	LoadActor("overlay")..{
		InitCommand=function(self)
			self:zoom(1);
			self:diffusealpha(0.3);
		end;
	};
};