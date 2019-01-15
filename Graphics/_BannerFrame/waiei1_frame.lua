local bg=Def.ActorFrame{
	InitCommand=function(self)
		if IsEXFolder() then
			self:queuecommand("CurrentSongChanged");
		end;
	end;
	LoadFont("Common Normal")..{
		Text="New!";
		InitCommand=function(self)
			self:zoom(0.8);
			self:diffuse(Color("Orange"));
			self:strokecolor(Color("Black"));
			self:x(258);
			self:y(-28);
		end;
		CurrentSongChangedMessageCommand=function(self)
			if _SONG() then
				if not GAMESTATE:IsCourseMode() then
					if not IsEXFolder() and PROFILEMAN:IsSongNew(_SONG()) then
						self:visible(true);
					else
						self:visible(false);
					end;
				end;
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(TC_GetPath("BannerFrame","frame"))..{
		OnCommand=function(self)
			self:zoomx(2);
			self:zoomy(0);
			self:diffusealpha(0);
			self:linear(0.2);
			self:zoomx(1);
			self:zoomy(1);
			self:diffusealpha(1);
		end;
	};
	LoadActor(TC_GetPath("BannerFrame","over"))..{
		OnCommand=function(self)
			self:zoomx(2);
			self:zoomy(0);
			self:diffusealpha(0);
			self:linear(0.2);
			self:zoomx(1);
			self:zoomy(1);
			self:diffusealpha(1);
		end;
	};
};
return bg;