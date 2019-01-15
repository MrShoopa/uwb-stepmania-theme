local iPN,difcolor,difname,meter_type = ...;
assert(iPN,"[Graphics/PaneDisplay text.lua] No PlayerNumber Provided.");

local t = Def.ActorFrame {};
local function GetRadarData( pnPlayer, rcRadarCategory )
	local tRadarValues;
	local StepsOrTrail;
	local fDesiredValue = 0;
	if GAMESTATE:GetCurrentSteps( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentSteps( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	elseif GAMESTATE:GetCurrentTrail( pnPlayer ) then
		StepsOrTrail = GAMESTATE:GetCurrentTrail( pnPlayer );
		fDesiredValue = StepsOrTrail:GetRadarValues( pnPlayer ):GetValue( rcRadarCategory );
	else
		StepsOrTrail = nil;
	end;
	return fDesiredValue;
end;

local function CreatePaneDisplayItem( _pnPlayer, _sLabel, _rcRadarCategory )
	return Def.ActorFrame {
		LoadFont("Common Normal") .. {
			Text=string.upper( THEME:GetString("PaneDisplay",_sLabel) );
			InitCommand=cmd(horizalign,left;x,-30);
			OnCommand=cmd(zoom,0.4;diffuse,1,1,1,1;shadowlength,1);
		};
		LoadFont("Common Normal") .. {
			Text="000";
			InitCommand=cmd(x,9;horizalign,left);
			OnCommand=function(self)
				(cmd(zoom,0.4;diffuse,1,1,1,1))(self);
				local _song = GAMESTATE:GetCurrentSong()
				local _course = GAMESTATE:GetCurrentCourse()
				if not _song and not _course then
					self:settext("000");
					self:diffusealpha(0.3);
				else
					if not GetEXFCurrentSong_ShowStepInfo() then
						self:settext("???");
						self:diffusealpha(0.8);
					else
						self:settextf("%03i", GetRadarData( _pnPlayer, _rcRadarCategory ) );
						if GetRadarData( _pnPlayer, _rcRadarCategory )==0 then
							self:diffusealpha(0.3);
						else
							self:diffusealpha(1);
						end;
					end;
				end
			end;
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			SetCommand=function(self)
				local _song = GAMESTATE:GetCurrentSong()
				local _course = GAMESTATE:GetCurrentCourse()
				if not _song and not _course then
					self:settext("000");
					self:diffusealpha(0.3);
				else
					if not GetEXFCurrentSong_ShowStepInfo() then
						self:settext("???");
						self:diffusealpha(0.8);
					else
						self:settextf("%03i", GetRadarData( _pnPlayer, _rcRadarCategory ) );
						if GetRadarData( _pnPlayer, _rcRadarCategory )==0 then
							self:diffusealpha(0.3);
						else
							self:diffusealpha(1);
						end;
					end;
				end
			end;
		};
	};
end;

--[[ Numbers ]]
local song=nil;
local course=nil;
local dif=nil;
local mst;
t[#t+1] = Def.ActorFrame {
	FOV=90;
	InitCommand=function(self)
		if IsEXFolder() and not GAMESTATE:IsPlayerEnabled(iPN) then
			self:visible(false);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
	PlayerJoinedMessageCommand=cmd(playcommand,"Set");
	OnCommand=cmd(playcommand,"Set");
	Def.Actor{
		SetCommand=function(self)
			mst=GAMESTATE:GetCurrentSteps(iPN);
			song=_SONG();
			course=_COURSE();
			if mst then
				dif=mst:GetDifficulty();
			end;
			if song then
				st=GAMESTATE:GetCurrentSteps(iPN);
			elseif course then
				tr=GAMESTATE:GetCurrentTrail(iPN);
				if tr then
					self:visible(true);
					dif=tr:GetDifficulty();
				end;
			elseif not GAMESTATE:IsCourseMode() then
				self:visible(true);
			end;
			if (song and st) or (course and tr) then
				local pro;
				if PROFILEMAN:IsPersistentProfile(iPN) then
					-- player profile
					pro=PROFILEMAN:GetProfile(iPN);
				else
					-- machine profile
					pro=PROFILEMAN:GetMachineProfile();
				end;
				dp=0;
				sc=0;
				if pro then
					local SongOrCourse=song or course;
					local StepOrTrail=st or tr;
					local hiscore=pro:GetHighScoreList(SongOrCourse,StepOrTrail):GetHighScores();
					for h=1,#hiscore do
						if hiscore[h]:GetPercentDP()*100>dp then
							dp=hiscore[h]:GetPercentDP()*100;
							sc=hiscore[h]:GetScore();
						end;
					end;
				end;
			end;
		end;
	};
	LoadActor(TC_GetPath("Pane","color"))..{
		InitCommand=function(self)
			--self:horizalign((iPN==PLAYER_1) and left or right);
			self:y(1);
			if iPN==PLAYER_1 then
				self:x(-38);
			else
				self:x(38);
				self:rotationy(180);
			end;
			--self:blend("BlendMode_Add");
		end;
		SetCommand=function(self)
			if dif and song then
				self:diffuse(_DifficultyCOLOR2(difcolor,dif));
			else
				self:diffuse(1.0,1.0,1.0,0.3);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:y(-8);
			self:zoom(0.6);
			self:maxwidth(60/0.6);
			self:strokecolor(Color("Black"))
			self:x((iPN==PLAYER_1) and -135 or 135);
		end;
		SetCommand=function(self)
			if dif and song then
				self:diffuse(_DifficultyLightCOLOR2(difcolor,dif));
				self:settext(string.upper(_DifficultyNAME2(difname,dif)));
			else
				self:diffuse(0.75,0.75,0.75,1.0);
				self:settext("FOLDER");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:y(8);
			self:zoom(0.6);
			self:maxwidth(60/0.6);
			self:strokecolor(Color("Black"))
			self:x((iPN==PLAYER_1) and -135 or 135);
			--self:blend("BlendMode_Add");
		end;
		SetCommand=function(self)
			if dif and song then
				self:diffuse(_DifficultyLightCOLOR2(difcolor,dif));
				if not GetEXFCurrentSong_ShowHiScore() then
					self:settextf("%5.2f%%",0);
				elseif dp>=100 then
					self:settextf("%3d%%",dp);
				else
					self:settextf("%5.2f%%",dp);
				end;
			else
				self:diffuse(0.75,0.75,0.75,1.0);
				self:settextf("%5.2f%%",0);
			end;
		end;
	};
	-- Left 
	CreatePaneDisplayItem( iPN, "Taps", 'RadarCategory_TapsAndHolds' ) .. {
		InitCommand=cmd(x,-68;y,-9);
	};
	CreatePaneDisplayItem( iPN, "Jumps", 'RadarCategory_Jumps' ) .. {
		InitCommand=cmd(x,-68;y,0);
	};
	CreatePaneDisplayItem( iPN, "Holds", 'RadarCategory_Holds' ) .. {
		InitCommand=cmd(x,-68;y,9);
	};
	-- Center
	CreatePaneDisplayItem( iPN, "Mines", 'RadarCategory_Mines' ) .. {
		InitCommand=cmd(x,0;y,-9);
	};
	CreatePaneDisplayItem( iPN, "Rolls", 'RadarCategory_Rolls' ) .. {
		InitCommand=cmd(x,0;y,0);
	};
	CreatePaneDisplayItem( iPN, "Lifts", 'RadarCategory_Lifts' ) .. {
		InitCommand=cmd(x,0;y,9);
	};
	-- Right
	CreatePaneDisplayItem( iPN, "Hands", 'RadarCategory_Hands' ) .. {
		InitCommand=cmd(x,68;y,-9);
	};
	CreatePaneDisplayItem( iPN, "Fakes", 'RadarCategory_Fakes' ) .. {
		InitCommand=cmd(x,68;y,0);
	};
};
return t;