local rander = string.lower(split(',',PREFSMAN:GetPreference('VideoRenderers'))[1]);
function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner");
end;
local s;
local function _S()
	if not s then
		s=_SONG2();
	end;
	return s;
end;

local t=Def.ActorFrame{};
local scale=20;
local sizex=520;
local sizey=170;
local title={};
if rander=='opengl' then
	t[#t+1]= Def.ActorFrameTexture{
		Name = "Tex";
		InitCommand=function(self)
			self:SetTextureName( "Tex" );
			self:SetWidth(SCREEN_WIDTH/scale);
			self:SetHeight(SCREEN_HEIGHT/scale);
			self:EnableAlphaBuffer(true);
			self:Create();
		end;
		OnCommand=function(self)
			self:Draw();
			self:visible(true);
		end;
		Def.Quad{
			InitCommand=cmd(FullScreen;diffuse,0,0,0,1);
		};
		Def.Sprite{
			InitCommand=function(self)
				local s=_S();
				local g='';
				if s and s:HasBackground() then
					g=s:GetBackgroundPath()
				else
					g=THEME:GetPathG('common','fallback background');
				end;
				self:LoadBackground(g);
				self:scaletofit(0,0,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale);
			end;
			OnCommand=cmd(diffuse,1,1,1,PREFSMAN:GetPreference('BGBrightness'));
		};
		--Def.ActorProxy{ Name = "ProxyBK"; OnCommand=function(self) self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('SongBackground')); end },
		Def.ActorProxy{ 
			Name = "ProxyUL"; 
			OnCommand=function(self) 
				self:x(0);
				self:y(0); 
				self:SetTarget(SCREENMAN:GetTopScreen():GetChild('SongBackground')); 
				self:scaletofit(0,0,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale);
			end;
		};
		Def.ActorProxy{ 
			Name = "ProxyP1"; 
			OnCommand=function(self) 
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('PlayerP1')); 
				end;
			end;
		};
		Def.ActorProxy{ 
			Name = "ProxyP2"; 
			OnCommand=function(self) 
				if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
					self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('PlayerP2')); 
				end;
			end;
		};
	};
	t[#t+1]=Def.ActorFrame{
		Def.Sprite{
			Texture = "Tex";
			OnCommand=function(self)
				self:FullScreen();
				self:cropleft((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:cropright((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:croptop((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
				self:cropbottom((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
				self:x(0);
				self:y(0);
			end;
		};
		OnCommand=function(self)
			self:Center();
			self:SetDrawByZPosition(true);
			self:draworder(10000);
		end;
		HereWeGoMessageCommand=cmd(diffusealpha,1.0;sleep,0.5;linear,0.5;diffusealpha,0);
	};
else
	t[#t+1]=Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(blend,'BlendMode_Add';diffuse,0.8,0.9,1,0.5;FullScreen);
			OnCommand=function(self)
				self:cropleft((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:cropright((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:croptop((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
				self:cropbottom((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
				self:x(0);
				self:y(0);
			end;
		};
		OnCommand=function(self)
			self:Center();
			self:SetDrawByZPosition(true);
			self:draworder(10000);
		end;
		HereWeGoMessageCommand=cmd(diffusealpha,1.0;sleep,0.5;linear,0.5;diffusealpha,0);
	};
end;
t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_objects/_ready","frame"))..{
		InitCommand=function(self)
			self:zoomto(sizex+10,sizey+10);
			self:x(0);
			self:y(0);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:diffuse(0,0,0,0.5);
			self:zoomto(162,162);
			self:x(-175);
			self:y(0);
		end;
	};
	Def.Sprite{
		InitCommand=function(self)
			local s=_S();
			local g='';
			if s then
				local tmp={};
				tmp=GetBannerStat(s,GetWheelMode());
				g=tmp[1];
			else
				g=THEME:GetPathG('common','fallback jacket');
			end;
			self:LoadBackground(g);
			self:scaletofit(0,0,160,160);
			self:x(-175);
			self:y(0);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			local s=_S();
			self:horizalign(left);
			title=GetSplitTitle(s);
			self:x(-70);
			if title[2]~="" then
				self:y(8);
			else
				self:y(20);
			end;
			self:maxwidth(310/1.2);
			self:zoom(1.2);
			self:settextf("%s",title[1]);
			self:strokecolor(0,0,0,0.5);
			self:diffusealpha(0);
			self:diffusealpha(1);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(left);
			self:x(-70);
			self:y(32);
			self:maxwidth(310/0.9);
			self:zoom(0.9);
			self:settextf("%s",title[2]);
			self:strokecolor(0,0,0,0.5);
			self:diffusealpha(0);
			self:diffusealpha(1);
		end;
	};
	LoadFont("Common normal") .. {
		Name="SARTIST";
		InitCommand=function(self)
			local s=_S();
			self:horizalign(left);
			self:x(-70);
			if title[2]~="" then
				self:y(60);
			else
				self:y(56);
			end;
			self:maxwidth(310);
			self:settextf("%s",s:GetDisplayArtist());
			self:strokecolor(0,0,0,0.5);
			self:diffusealpha(0);
			self:diffusealpha(1);
		end;
	};
	OnCommand=function(self)
		self:Center();
		self:SetDrawByZPosition(true);
		self:draworder(10000);
	end;
	HereWeGoMessageCommand=cmd(diffusealpha,1.0;sleep,0.5;linear,0.5;diffusealpha,0);
};

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
	--[[
	読み取り優先順位はこんな感じ？ 
	*** 1番 ***
	Def.ActorFrame{
		InitCommand=cmd(*** 3番 ***);
			Def.Actor(){
				InitCommand=cmd(*** 4番 ***);
			}
			Def.Actor(){
				InitCommand=function(self) *** 2番 *** end;
			}
	}
	--]]
	Def.Actor{InitCommand=function(self) SongChk(); end;};
	--[[
	LoadActor(THEME:GetPathG("_Ready","Background")) .. {
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
		Name="PICTG";
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
	Def.Sprite{
		Name="PICTF";
		InitCommand=function(self)
			self:LoadBackground(THEME:GetPathG("_Frame","Banner"));
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
	--]]
	LoadActor(THEME:GetPathG("_Ready","Text Ready")) .. {
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
	LoadActor(THEME:GetPathG("_Ready","Text Go")) .. {
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
			if (now >= start-8.0) and not an_go then
				MESSAGEMAN:Broadcast('HereWeGo');
				if an~='' then
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
				end;
				an_go=true;
			end;
		end;
	};
	--[[
	LoadFont("Common normal") .. {
		Name="STITLE";
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
		Name="SARTIST";
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
	--]]
};

--[[
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
	LoadActor(THEME:GetPathG("_Ready","Light L")) .. {
		Name="RLIGHTL";
		InitCommand=cmd(finishtweening;zoomtowidth,SCREEN_WIDTH;
			diffuse,_DifficultyCOLOR(_STEPS2(GetSidePlayer(PLAYER_1)):GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(diffusealpha,1;linear,2.0;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_Ready","Light R")) .. {
		Name="RLIGHTR";
		InitCommand=cmd(finishtweening;zoomtowidth,SCREEN_WIDTH;
			diffuse,_DifficultyCOLOR(_STEPS2(GetSidePlayer(PLAYER_2)):GetDifficulty());
			blend,'BlendMode_Add';);
		OnCommand=cmd(diffusealpha,1;linear,2.0;diffusealpha,0);
	};
};
--]]

return t;
