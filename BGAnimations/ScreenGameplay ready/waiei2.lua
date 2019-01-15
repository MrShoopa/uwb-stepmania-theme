local song=nil;
local bn_w=160;
local bn_h= 90;
local g=THEME:GetPathG("","_blank");
local w=1.0;
local h=1.0;
local banner=THEME:GetPathG("Common fallback","banner");
local start = nil;

local an=GetCurrentAnnouncer();
MuteAnnouncer();
local an_rd=false;
local an_go=false;
local clear_pause=false;

local function GetSongBanner(s)
	if s then
		local path = s:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner");
end;

local sizex=SCREEN_WIDTH+2;
local sizey=100;
local title={};

-- [ja] アナウンサー 
local t=Def.ActorFrame{
	OnCommand=function(self)
		self:linear(0.5);
		self:queuecommand('ClearPause');
	end;
	ClearPauseCommand=function(self)
		clear_pause=true;
	end;
	HereWeGoMessageCommand=function(self)
		self:sleep(1);
		self:queuecommand('ResetAnnouncer');
	end;
	GameplayTimerMessageCommand=function(self,params)
		if start then
			if an~="" and not an_rd then
				if not GAMESTATE:IsDemonstration() then
					if (params.Beat >= start-12.0) then
						an_rd=true;
						ResetAnnouncer();
						SOUND:PlayAnnouncer("gameplay ready");
						an=GetCurrentAnnouncer();
						MuteAnnouncer();
					end;
				end;
			end;
			if clear_pause then
				if (params.Beat >= start-8.0) and not an_go then
					an_go=true;
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
				end;
			end;
		end;
	end;
	ChangedGameplaySongMessageCommand=function(self,params)
		if GAMESTATE:IsCourseMode() then
			GAMESTATE:ClearStageModifiersIllegalForCourse();
		elseif params.Song then
			start = params.Start;
			banner = params.Path;
		end;
		an_rd=false;
		an_go=false;
		clear_pause=false;
		if (params.Beat < start-12.0) then
			ResetAnnouncer();
			an = GetCurrentAnnouncer();
			MuteAnnouncer();
		end;
	end;
};

local excmd=function(self)
	self:linear(0.3);
	self:cropleft((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
	self:cropright((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
	self:croptop((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
	self:cropbottom((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
end;

t[#t+1]=Def.ActorFrame{
    -- バナーサイズ取得用（非表示）
	Def.Sprite{
		ChangedGameplaySongMessageCommand=function(self,params)
			g=GetSongBanner(params.Song);
			self:LoadBackground(g);
			w=self:GetWidth();
			h=self:GetHeight();
			self:visible(false);
			MESSAGEMAN:Broadcast("SetBanner",{
				Path   = g,
				Width  = w,
				Height = h
			});
		end;
	};
    -- 背景ぼかし処理
	LoadActor(
		THEME:GetPathG("_Filter", "blur"),
		THEME:GetPathG("_Song", "bg/bga"),
		GetwaieiBulrSize(), true, excmd	)..{
		InitCommand=cmd(
			halign, SCREEN_CENTER_X;
			valign, SCREEN_CENTER_Y;
			x,0;
			y,0;
		);
		ChangedGameplaySongMessageCommand=function(self,params)
			MESSAGEMAN:Broadcast("Blur");
		end;
	};
    -- フレーム
	LoadActor(THEME:GetPathG("_objects/_ready","frame"))..{
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH+50,SCREEN_HEIGHT+50);
			self:x(0);
			self:y(0);
		end;
		BlurMessageCommand=function(self,params)
			self:linear(0.3);
			self:zoomto(sizex+20,sizey+4);
		end;
	};
    -- バナー枠
	Def.Quad{
		InitCommand=cmd(visible,false);
		SetBannerMessageCommand=function(self,pamars)
			self:diffuse(0,0,0,0.5);
			self:zoomto(bn_w+2,bn_w*pamars.Height/pamars.Width+2);
			self:x(-175);
			self:y(0);
			self:visible(true);
		end;
	};
    -- バナー
	Def.Sprite{
		InitCommand=cmd(visible,false);
		SetBannerMessageCommand=function(self,pamars)
			self:LoadBackground(pamars.Path);
			if pamars.Width/pamars.Height>bn_w/bn_h then
				self:scaletofit(0,0,bn_w,bn_h);
			else
				self:scaletocover(0,0,bn_w,bn_h);
				local cr=(bn_w*pamars.Height/pamars.Width-bn_h)/2/(bn_w*pamars.Height/pamars.Width);
				self:croptop(cr);
				self:cropbottom(cr);
			end;
			self:x(-175);
			self:y(0);
			self:visible(true);
		end;
	};
    -- 曲名（アーティスト等含む）
	LoadActor(THEME:GetPathG('_Song','title'),320,left)..{
		InitCommand=function(self)
			self:x(-70);
			self:y(0);
		end;
	};
	OnCommand=function(self)
		self:Center();
		self:SetDrawByZPosition(true);
		self:draworder(10000);
	end;
	HereWeGoMessageCommand=cmd(
		diffusealpha,1.0;sleep,0.5;linear,0.5;diffusealpha,0
	);
};

--[[
t[#t+1]=Def.ActorFrame{
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
	Def.Actor{InitCommand=function(self) SongChk(); end;};
	LoadActor("text_ready") .. {
		Name="READY";
		InitCommand=cmd(y,0;diffusealpha,0);
		LoopCommand=function(self)
			if (now >= start-12.0) and (now < start-11.0) then
				self:diffusealpha((now-(start-12.0)));
				self:y(-10-60*(now-(start-12.0)));
			elseif (now >= start-11.0) and (now < start-10.0) then
				self:y(-70);
			elseif (now >= start-10.0) and (now < start-8.0) then
				self:y(-70);
				self:diffusealpha(1-(now-(start-10.0))*0.5);
			elseif (now >= start-8.0) then
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
		InitCommand=cmd(visible,false;x,260;diffusealpha,0);
		LoopCommand=function(self)
			if (now >= start-8.0) and (now < start-7.5) then
				local tmp = (now-(start-8.0))*2;
				self:diffusealpha(tmp);
			elseif (now >= start-7.5) and (now < start-4.5) then
				self:diffusealpha(1);
			elseif (now >= start-4.5) and (now < start-4.0) then
				local tmp = 1.0-((now-(start-4.5))*2);
				self:diffusealpha(tmp);
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
};
	--]]

return t;
