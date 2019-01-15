function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner")
end

local t=Def.ActorFrame{};
local song = _SONG();
local jacketmode=0;
local course=GAMESTATE:GetCurrentCourse();
local steps={};
local title={};

t[#t+1] = Def.ActorFrame {
  InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+10);
	LoadFont("Common Normal") .. {
		InitCommand=cmd(strokecolor,Color("Outline");diffuse,Color("White");diffusebottomedge,Color("Blue");zoom,0.75;y,20);
		BeginCommand=function(self)
			local text = "";
			local SongOrCourse;
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				if SongOrCourse:GetEstimatedNumStages() == 1 then
					text = SongOrCourse:GetEstimatedNumStages() .." Stage / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				else
					text = SongOrCourse:GetEstimatedNumStages() .." Stages / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				end
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				text = SecondsToMSSMsMs( SongOrCourse:MusicLengthSeconds() );
			end;
			self:settext(text);
		end;
		OnCommand=cmd(diffusealpha,0;addx,-60;diffusealpha,1;addx,60;addx,60;diffusealpha,0);
	};
};

t[#t+1]=Def.ActorFrame{
	Lyric_Egg_S();
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
	end;
	Def.Actor{
		InitCommand=function(self)
			steps={GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_1)),GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_2))};
			if (not song) and course then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
				local e = trail:GetTrailEntries()
				if #e > 0 then
					song = e[1]:GetSong()
					steps={e[1]:GetSteps(),e[1]:GetSteps()};
				end;
			end;
		end;
	};
	LoadActor(TC_GetPath('GameReady','Background')) .. {
		OnCommand=cmd(diffusealpha,0;zoom,2;
			linear,0.25;diffusealpha,1;zoomy,1.5;zoomtowidth,SCREEN_WIDTH;
			sleep,1.5;linear,0.25;zoomy,1;sleep,0.5);
	};
	LoadActor(TC_GetPath('GameReady','Light L')) .. {
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;
			diffuse,_DifficultyCOLOR(steps[1]:GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(addx,640;diffusealpha,0;
			sleep,0.5;linear,1.45;addx,-640;diffusealpha,0.8;sleep,0.05;diffusealpha,1;sleep,0.5);
	};
	LoadActor(TC_GetPath('GameReady','Light R')) .. {
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;
			diffuse,_DifficultyCOLOR(steps[2]:GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(addx,-640;diffusealpha,0;
			sleep,0.5;linear,1.45;addx,640;diffusealpha,0.8;sleep,0.05;diffusealpha,1;sleep,0.5);
	};
	Def.Sprite{
		InitCommand=function(self)
			self:LoadBackground(GetSongBanner(song));
			jacketmode=0;
			self:rate(1.0);
			self:scaletofit(0,0,192,192);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.3125))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			self:y(0);
			self:x(-210);
			self:diffusealpha(0);
			self:addx(-30);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(30);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
	};
	LoadActor(TC_GetPath('GameReady','Banner')) .. {
		InitCommand=function(self)
			self:scaletofit(0,0,200,200);
			self:y(0);
			self:x(-210);
			self:diffusealpha(0);
			self:addx(-30);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(30);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(left);
			title=GetSplitTitle(song);
			self:x(-102);
			self:y(-14);
			self:maxwidth(410/1.2);
			self:zoom(1.2);
			self:settextf("%s",song:GetDisplayFullTitle());
			self:strokecolor(Color("Black"));
			self:diffusealpha(0);
			self:addx(-90);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(90);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(left);
			self:x(-100);
			self:y(16);
			self:maxwidth(410);
			self:settextf("%s",song:GetDisplayArtist());
			self:strokecolor(Color("Black"));
			self:diffusealpha(0);
			self:addx(-90);
			self:sleep(1.8);
			self:linear(0.2);
			self:addx(90);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
	};
	LoadFont("Common Normal") .. {
		InitCommand=cmd(strokecolor,Color("Outline");diffuse,Color("White");diffusebottomedge,Color("Blue");zoom,0.75;y,20);
		BeginCommand=function(self)
			local text = "";
			local SongOrCourse;
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				if SongOrCourse:GetEstimatedNumStages() == 1 then
					text = SongOrCourse:GetEstimatedNumStages() .." Stage / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				else
					text = SongOrCourse:GetEstimatedNumStages() .." Stages / ".. SecondsToMSSMsMs( TrailUtil.GetTotalSeconds(trail) );
				end
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				text = SecondsToMSSMsMs( SongOrCourse:MusicLengthSeconds() );
			end;
			self:settext(text);
		end;
		OnCommand=cmd(diffusealpha,0;addx,-60;linear,0.25;diffusealpha,1;addx,60;sleep,1.5;linear,0.25;addx,60;diffusealpha,0);
	};
};

return t;
