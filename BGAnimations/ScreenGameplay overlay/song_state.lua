local song=_SONG2();
local t=Def.ActorFrame{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_BOTTOM-50);
	end;
	OnCommand=function(self)
		self:diffusealpha(0);
		self:zoom(2);
		self:addy(-30);
		self:sleep(1.0);
		self:linear(0.2);
		self:diffusealpha(1);
		self:zoom(1);
		self:addy(30);
	end;
	OffCommand=function(self)
		self:sleep(1.0);
		self:linear(0.2);
		self:diffusealpha(0);
		self:zoom(0);
		self:addy(30);
	end;
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(200,40);
			self:diffuse(0,0,0.2,0.8);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:maxwidth(190/0.5);
			self:diffuse(Color("White"));
			self:shadowlength(1);
			self:zoom(0.5);
			self:y(-10);
			self:settext(song:GetDisplayFullTitle());
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:maxwidth(190/0.5);
			self:diffuse(Color("White"));
			self:shadowlength(1);
			self:zoom(0.5);
			self:y(10);
			self:settext(song:GetDisplayArtist());
		end;
	};
};
return t;