local difn,difc,meter_type=...;
local t=Def.ActorFrame{FOV=60;};

-- SongList 
local sg;
local df;
local sm=1;
t[#t+1]=Def.ActorFrame{
	SetMessageCommand=function(self)
		sm=#GetLVInfo(GetSelDrillLevel().."-Song");
	end;
};
for i=1,5 do
t[#t+1]=Def.ActorFrame{
	-- [ja] 1曲当たりの縦スペースは64px 
	OnCommand=function(self)
		self:addy(-SCREEN_HEIGHT);
		self:decelerate(_TT.S_IN);
		self:addy(SCREEN_HEIGHT);
	end;
	OffCommand=function(self)
		self:accelerate(_TT.S_OUT);
		self:addy(SCREEN_HEIGHT);
	end;
	SetMessageCommand=function(self)
		if sm<5 then
			self:y(-230+i*80);
			self:addy((4-sm)*40+32);
		else
			self:y(-210+i*70);
		end;
	end;
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(200,64);
		end;
		SetMessageCommand=function(self)
			if i<=sm then
				_,sg,df=GetDrillSong(GetLVInfo(GetSelDrillLevel().."-Song")[i]);
			end;
			if sg and df then
				self:diffuse(_DifficultyCOLOR2(difc,df));
			else
				self:diffuse(Color("Black"));
			end;
			self:diffusealpha(0.5);
			if i<=sm then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(left);
			self:diffuse(Color("White"));
			self:strokecolor(BoostColor(waieiColor("Dark"),0.25));
		end;
		SetMessageCommand=function(self)
			self:x(-95);
			self:y(-24);
			self:zoom(0.6);
			if i<=sm then
				_,sg,_=GetDrillSong(GetLVInfo(GetSelDrillLevel().."-Song")[i]);
				if sg then
					self:settext("Stage"..i);
				else
					self:settext("Stage"..i.." <ERROR>");
				end;
			else
				self:settext("");
			end;
		end;
	};
	Def.Banner{
		InitCommand=function(self)
			self:horizalign(left);
		end;
		SetMessageCommand=function(self)
			if i<=sm then
				_,sg,_=GetDrillSong(GetLVInfo(GetSelDrillLevel().."-Song")[i]);
				if sg then
					if sg:HasBanner() then
						self:LoadFromCachedBanner(sg:GetBannerPath());
					else
						self:Load(THEME:GetPathG("Common fallback","banner"));
					end;
				else
					self:Load(THEME:GetPathG("_Drills/banner","error"));
				end;
			else
				self:Load(THEME:GetPathG("","_blank"));
			end;
			self:scaletofit(-48,-15,48,15);
			self:x(-95);
			self:y(0);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(left);
			self:maxwidth(190/0.75);
		end;
		SetMessageCommand=function(self)
			self:x(-95);
			self:y(20);
			self:zoom(0.75);
			self:diffuse(BoostColor(waieiColor("Text"),1.5));
			self:strokecolor(BoostColor(waieiColor("Text"),0.5));
			if i<=sm then
				_,sg,_=GetDrillSong(GetLVInfo(GetSelDrillLevel().."-Song")[i]);
				if sg then
					self:settext(sg:GetDisplayFullTitle());
				else
					self:diffuse(waieiColor("Red"));
					self:strokecolor(Color("Black"));
					self:settext("Song not found.");
				end;
			else
				self:settext("");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:maxwidth(190/0.75);
		end;
		SetMessageCommand=function(self)
			self:x(95);
			self:y(-20);
			self:zoom(0.6);
			if i<=sm then
				_,sg,df=GetDrillSong(GetLVInfo(GetSelDrillLevel().."-Song")[i]);
				if df then
					self:diffuse(_DifficultyCOLOR(df));
					self:strokecolor(BoostColor(_DifficultyCOLOR(df),0.5));
					if sg then
						self:settext(string.upper(_DifficultyNAME2(difn,df)));
					else
						self:settext("");
					end;
				else
					self:settext("");
				end;
			else
				self:settext("");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:maxwidth(190);
		end;
		SetMessageCommand=function(self)
			self:x(95);
			self:y(-2);
			if i<=sm then
				_,sg,df=GetDrillSong(GetLVInfo(GetSelDrillLevel().."-Song")[i]);
				if df then
					self:diffuse(_DifficultyCOLOR(df));
					self:strokecolor(BoostColor(_DifficultyCOLOR(df),0.5));
					if sg then
						local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
						if stt then
							self:settext(GetSongs(sg,stt..'-'..df));
						else
							self:settext("");
						end;
					else
						self:settext("");
					end;
				else
					self:settext("");
				end;
			else
				self:settext("");
			end;
		end;
	};
};
end;
return t;