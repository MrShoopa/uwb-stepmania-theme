local bg=Def.ActorFrame{
	InitCommand=function(self)
		if IsEXFolder() then
			self:queuecommand("CurrentSongChanged");
		end;
	end;
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(14,70);
			self:x(-135);
			self:y(24);
			self:diffuse(Color("Black"));
			self:diffusealpha(0.25);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(14,70);
			self:x(-135);
			self:y(24);
			self:blend("BlendMode_Add");
		end;
		CurrentSongChangedMessageCommand=function(self)
			if _SONG() then
				if not GAMESTATE:IsCourseMode() then
					if not IsEXFolder() and PROFILEMAN:IsSongNew(_SONG()) then
						self:diffuse(Color("Red"));
						self:diffusealpha(1.0);
					else
						self:diffuse(Color("Blue"));
						self:diffusealpha(0.25);
					end;
				end;
			else
				local wheel_sel=getenv("WheelName") or "";
				if wheel_sel=="EXFolder" then
					self:diffuse(Color("Red"));
				else
					self:diffuse(Color("Purple"));
				end;
				self:diffusealpha(0.5);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		Text="N\ne\nw";
		InitCommand=function(self)
			self:zoom(0.5);
			self:diffuse(Color("White"));
			self:strokecolor(0,0,0,0.1);
			self:x(-135);
			self:y(24);
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
		InitCommand=function(self)
			self:x(60);
			self:y(5);
		end;
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
	LoadActor(TC_GetPath("BannerFrame","frame"))..{
		InitCommand=function(self)
			self:blend("BlendMode_Add");
			self:diffuse(1.0,1.0,1.0,1.0);
			self:diffusetopedge(0,0,0,0);
			self:x(60);
			self:y(5);
		end;
		OnCommand=function(self)
			self:diffusealpha(1);
			self:fadeleft(1);
			self:faderight(1);
			self:queuecommand("Loop");
		end;
		LoopCommand=function(self)
			self:finishtweening();
			self:linear(2.0);
			self:fadeleft(0.5);
			self:faderight(0.5);
			self:diffusealpha(0.0);
			self:linear(2.0);
			self:fadeleft(1);
			self:faderight(1);
			self:diffusealpha(1);
			self:queuecommand("Loop");
		end;
		OffCommand=function(self)
			self:finishtweening();
		end;
	};
};
return bg;