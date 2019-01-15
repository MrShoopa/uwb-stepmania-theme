function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner");
end;

local t=Def.ActorFrame{};

local chksec=0.02;
local song;
local bannerpath;
local bannerpath_old;
local start = 0.0;
local now = 0.0;
local now_s;
local now_p;
local beat;
local an_rd=false;
local an_go=false;
local function SongChk()
	local ret=false;
	if (not song) or (song ~= _SONG2()) then
		if GAMESTATE:IsCourseMode() then
			GAMESTATE:ClearStageModifiersIllegalForCourse();
		end;
		song = _SONG2();
		if song then
			start = song:GetFirstBeat();
			bannerpath=GetSongBanner(song);
		end;
		ret=true;
	else
		now = GAMESTATE:GetSongBeat();
		now_s = GAMESTATE:GetSongPosition():GetMusicSeconds()*100%360;
		now_p = now_s%30;
		beat=(10*now)%40;
	end;
	return ret;
end;

local changesong=false
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(Center;);
	OnCommand=function(self)
		ResetAnnouncer();
		InputCurrentAnnouncer();
		MuteAnnouncer();
		self:queuecommand("Loop");
	end;
	LoopCommand=function(self)
		if SongChk() then
			changesong=true;
			self:finishtweening();
			self:playcommand("ChangeSong");
		end;
		if now<start then
			self:finishtweening();
			self:visible(true);
			self:sleep(chksec);
			self:queuecommand("Loop");
		else
			self:visible(false);
			if GAMESTATE:IsCourseMode() then
				self:sleep(0.1);
				self:queuecommand("Loop");
			end;
		end;
	end;
	-- [ja] 最初に曲情報を読み取る 
	Def.Actor{InitCommand=function(self) SongChk(); end;};
	LoadActor(TC_GetPath('GameReady','Background')) .. {
		Name="BG";
		InitCommand=function(self)
			self:diffusealpha(1);
			self:zoomtowidth(SCREEN_WIDTH);
			self:zoomy(1);
		end;
		LoopCommand=function(self)
			if (now < start-4.5) then
				self:diffusealpha(1);
				self:zoomtowidth(SCREEN_WIDTH);
				self:zoomy(1);
			end;
			if (now >= start-4.5) and (now < start-4.0) then
				local tmp = 1.0-((now-(start-4.5))*2);
				self:diffusealpha(tmp);
				self:zoomy(tmp);
			elseif (now >= start-4.0) then
				self:diffusealpha(0);
				self:zoomto(0,0);				
			end;
		end;
	};
	Def.Sprite{
		InitCommand=function(self)
			self:LoadBackground(bannerpath);
			bannerpath_old=bannerpath;
			self:scaletofit(0,0,192,192);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.3125))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			self:y(0);
			self:x(-210);
		end;
		ChangeSongCommand=function(self)
			self:playcommand("Init");
		end;
		LoopCommand=function(self)
			if (now < start-13.5) then
				self:diffusealpha(1);
			elseif (now >= start-13.5) and (now < start-12.0) then
				local tmp = 1.0-((now-(start-13.5))*2);
				self:diffusealpha(tmp);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	LoadActor(TC_GetPath('GameReady','Banner')) .. {
		InitCommand=function(self)
			self:scaletofit(0,0,200,200);
			self:y(0);
			self:x(-210);
		end;
		LoopCommand=function(self)
			if (now < start-13.5) then
				self:diffusealpha(1);
			elseif (now >= start-13.5) and (now < start-12.0) then
				local tmp = 1.0-((now-(start-13.5))*2);
				self:diffusealpha(tmp);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	LoadActor(TC_GetPath('GameReady','Text Ready')) .. {
		Name="READY";
		InitCommand=cmd(y,-2;diffusealpha,0);
		LoopCommand=function(self)
			if (now >= start-12.0) and (now < start-11.5) then
				local tmp = (now-(start-12.0))*2;
				self:diffusealpha(tmp);
				self:zoomx(2.0-tmp);
				self:zoomy(tmp);
			elseif (now >= start-11.5) and (now < start-8.5) then
				self:diffusealpha(1);
				self:zoomx(1);
				self:zoomy(1);
			elseif (now >= start-8.5) and (now < start-8.0) then
				local tmp = 1.0-((now-(start-8.5))*2);
				self:diffusealpha(tmp);
				self:zoomx(2.0-tmp);
				self:zoomy(tmp);
			else
				self:diffusealpha(0);
			end;
			if (now >= start-12.0) and (now < start-8.0) and
				an~="" and not an_rd then
				if not GAMESTATE:IsDemonstration() then
					ResetAnnouncer();
					SOUND:PlayAnnouncer("gameplay ready");
				end;
				an_rd=true;
			end;
		end;
	};
	LoadActor(TC_GetPath('GameReady','Text Go')) .. {
		Name="GO";
		InitCommand=cmd(y,-2;diffusealpha,0);
		LoopCommand=function(self)
			if (now >= start-8.0) and (now < start-7.5) then
				local tmp = (now-(start-8.0))*2;
				self:diffusealpha(tmp);
				self:zoomx(2.0-tmp);
				self:zoomy(tmp);
			elseif (now >= start-7.5) and (now < start-4.5) then
				self:diffusealpha(1);
				self:zoomx(1);
				self:zoomy(1);
			elseif (now >= start-4.5) and (now < start-4.0) then
				local tmp = 1.0-((now-(start-4.5))*2);
				self:diffusealpha(tmp);
				self:zoomx(2.0-tmp);
				self:zoomy(tmp);
			else
				self:diffusealpha(0);
			end;
			if (now >= start-8.0) and an~="" and not an_go then
				if not GAMESTATE:IsDemonstration() then
					ResetAnnouncer();
					local stage=GAMESTATE:GetCurrentStage();
					if stage=="Stage_Final" then
						SOUND:PlayAnnouncer("gameplay here we go final");
					elseif stage=="Stage_Extra1" or stage=="Stage_Extra2" then
						SOUND:PlayAnnouncer("gameplay here we go extra");
					else
						SOUND:PlayAnnouncer("gameplay here we go normal");
					end;
				end;
				an_go=true;
			end;
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(left);
			self:x(-102);
			self:y(-14);
			self:maxwidth(410/1.2);
			self:zoom(1.2);
			self:settextf("%s",song:GetDisplayFullTitle());
			self:strokecolor(Color("Outline"));
		end;
		ChangeSongCommand=function(self)
			self:playcommand("Init");
		end;
		LoopCommand=function(self)
			if (now < start-13.5) then
				self:diffusealpha(1);
			elseif (now >= start-13.5) and (now < start-12.0) then
				local tmp = 1.0-((now-(start-13.5))*2);
				self:diffusealpha(tmp);
			else
				self:diffusealpha(0);
			end;
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(left);
			self:x(-100);
			self:y(16);
			self:maxwidth(410);
			self:settextf("%s",song:GetDisplayArtist());
			self:strokecolor(Color("Outline"));
		end;
		ChangeSongCommand=function(self)
			self:playcommand("Init");
		end;
		LoopCommand=function(self)
			if (now < start-13.5) then
				self:diffusealpha(1);
			elseif (now >= start-13.5) and (now < start-12.0) then
				local tmp = 1.0-((now-(start-13.5))*2);
				self:diffusealpha(tmp);
			else
				self:diffusealpha(0);
			end;
		end;
	};
};

t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(Center;queuecommand,"Loop");
	LoopCommand=function(self)
		if changesong then
			self:finishtweening();
			self:queuecommand("Init");
			self:queuecommand("On");
			changesong=false;
		end;
		self:sleep(0.1);
		self:queuecommand("Loop");
	end;
	LoadActor(TC_GetPath('GameReady','Light L')) .. {
		InitCommand=cmd(finishtweening;zoomtowidth,SCREEN_WIDTH;
			diffuse,_DifficultyCOLOR(_STEPS2(GetSidePlayer(PLAYER_1)):GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(diffusealpha,1;linear,2.0;diffusealpha,0);
	};
	LoadActor(TC_GetPath('GameReady','Light R')) .. {
		InitCommand=cmd(finishtweening;zoomtowidth,SCREEN_WIDTH;
			diffuse,_DifficultyCOLOR(_STEPS2(GetSidePlayer(PLAYER_2)):GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(diffusealpha,1;linear,2.0;diffusealpha,0);
	};
};

return t;
