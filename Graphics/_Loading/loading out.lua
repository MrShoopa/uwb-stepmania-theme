local anime_sec=0.4;
return Def.ActorFrame{
	InitCommand=function(self)
		--self:x(SCREEN_WIDTH-100);
		--self:y(SCREEN_HEIGHT-100);
		self:Center();
		self:addy(-10);
	end;
	OnCommand=function(self)
		self:bouncebegin(anime_sec);
		self:diffusealpha(0);
	--	self:zoomx(4);
	--	self:zoomy(0);
		self:zoom(4);
		self:rotationy(360);
	end;
	LoadActor("_frame")..{
		InitCommand=function(self)
			self:diffusealpha(1);
			self:zoom(1);
		end;
	};
	LoadActor("_under")..{
		InitCommand=function(self)
			self:zoom(1);
			self:blend("BlendMode_Add");
		end;
	};
	LoadActor("_over")..{
		InitCommand=function(self)
			self:zoom(1);
		end;
	};
	LoadActor("_text")..{
		InitCommand=function(self)
			self:zoom(1);
		end;
		OnCommand=function(self)
			self:bouncebegin(anime_sec);
			self:rotationy(-360);
			self:zoomx(0);
		end;
	};
};