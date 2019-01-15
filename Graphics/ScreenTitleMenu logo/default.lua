local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("","_Logo/default"));
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:strokecolor(Color("Black"));
			self:diffuse(Color("White"));
			self:x(120);
			self:y(65);
			self:zoom(0.7);
			self:settextf("v%4.3f",GetThemeVersionInformation("Version"));
		end;
	};
};

return t;
