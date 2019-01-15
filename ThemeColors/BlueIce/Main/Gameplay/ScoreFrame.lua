return Def.ActorFrame{
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(180,26);
			self:diffuse(1,1,1,0.5);
			self:fadeleft(0.5);
			self:faderight(0.5);
		end;
	};
};