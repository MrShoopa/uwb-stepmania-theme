local difn=GetUserPref_Theme("UserDifficultyName");
local difc=GetUserPref_Theme("UserDifficultyColor");
local wheelmode=GetUserPref_Theme("UserWheelMode");
local meter_type=GetUserPref_Theme("UserMeterType");

local BASE_TOP_CENTER_X=SCREEN_CENTER_X+_HS2
local BASE_TOP_CENTER_Y=SCREEN_CENTER_Y-108;
local DJACKET_CENTER_X=BASE_TOP_CENTER_X-170;
local DJACKET_CENTER_Y=BASE_TOP_CENTER_Y;
local DTITLE_CENTER_X=BASE_TOP_CENTER_X+90;
local DTITLE_CENTER_Y=BASE_TOP_CENTER_Y;

local BASE_BOTTOM_CENTER_X=SCREEN_CENTER_X+_HS2
local BASE_BOTTOM_CENTER_Y=SCREEN_CENTER_Y+90;
local SJACKET_CENTER_X=BASE_BOTTOM_CENTER_X-170;
local SJACKET_CENTER_Y=BASE_BOTTOM_CENTER_Y+25;
local INFO_CENTER_X=BASE_BOTTOM_CENTER_X+80;
local INFO_CENTER_Y=BASE_BOTTOM_CENTER_Y;
local BORDER_CENTER_X=INFO_CENTER_X-55;
local BORDER_CENTER_Y=INFO_CENTER_Y-60;
local STITLE_CENTER_X=INFO_CENTER_X;
local STITLE_CENTER_Y=BORDER_CENTER_Y;
local BORDER_W=210;
local BORDER_W2=BORDER_W/2;
local BORDER_W100=BORDER_W/100;

local sg,df;

local cal='Off';
local nm=ToEnumShortString(GetDrillPlayer());
if PROFILEMAN:GetNumLocalProfiles()>0 then
	for i=1,PROFILEMAN:GetNumLocalProfiles() do
		if PROFILEMAN:GetProfile(GetDrillPlayer()):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
			nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
			break
		end;
	end;
end;
local cal_prof;
if PROFILEMAN:IsPersistentProfile(GetDrillPlayer()) then
	-- player profile
	cal_prof = PROFILEMAN:GetProfile(GetDrillPlayer());
else
	-- machine profile
	cal_prof = PROFILEMAN:GetMachineProfile();
end;
cal=GetUserPref_Theme("UserShowCalories"..nm);
if not cal then cal='Off' end;
local cal_total=0;
if cal_prof then
	cal_total=cal_prof:GetCaloriesBurnedToday();
end;
local t=Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	SetMessageCommand=function(self,params)
		if params and params.Scroll then
			self:finishtweening();
		end;
		sg=nil;
		df=nil;
		gradepoint=0.0;
		if GetSelDrillResult()>0 then
			_,sg,df=GetDrillSong(GetLVInfo(""..GetSelDrillLevel().."-Song")[GetSelDrillResult()]);
			if sg then
				local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
				if stt then
					local st=sg:GetOneSteps(stt,df);
					gradepoint=GradeChk(st,GetDrillScore("W1",GetSelDrillResult()),
						GetDrillScore("W2",GetSelDrillResult()),GetDrillScore("W3",GetSelDrillResult()),
						GetDrillScore("W4",GetSelDrillResult()),GetDrillScore("W5",GetSelDrillResult()),
						GetDrillScore("MS",GetSelDrillResult()),GetDrillScore("OK",GetSelDrillResult()),
						GetDrillScore("HIT",GetSelDrillResult()));
				end;
			end;
		else
			local st_cnt=0;
			local hd_cnt=0;
			for stage=1,GetDrillMaxStage() do
				local _,_sg,_df=GetDrillSong(GetLVInfo(""..GetSelDrillLevel().."-Song")[stage]);
				if _sg then
					local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
					if stt then
						local st=_sg:GetOneSteps(stt,_df);
						st_cnt=st_cnt+st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_TapsAndHolds');
						hd_cnt=hd_cnt+st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_Holds');
						hd_cnt=hd_cnt+st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_Rolls');
					end;
				end;
			end;
			gradepoint=GradeChkSetMax(st_cnt,hd_cnt,GetDrillScore("W1",nil),
						GetDrillScore("W2",nil),GetDrillScore("W3",nil),
						GetDrillScore("W4",nil),GetDrillScore("W5",nil),
						GetDrillScore("MS",nil),GetDrillScore("OK",nil),
						GetDrillScore("HIT",nil));
		end;
		self:queuecommand('Set2');
	end;
--Base(BOTTOM)
	Def.Quad{
	--LoadActor(THEME:GetPathG("_SelectMusic/white","banner"))..{
		OnCommand=function(self)
			self:zoomto(510,220);
			self:diffuse(1.0,1.0,1.0,0.66);
			self:x(BASE_BOTTOM_CENTER_X);
			self:y(BASE_BOTTOM_CENTER_Y);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(left);
			self:diffuse(waieiColor("Text"));
			self:strokecolor(Color("White"));
			self:maxwidth(150/0.75);
			self:x(BASE_BOTTOM_CENTER_X-250);
			self:y(BASE_BOTTOM_CENTER_Y-95);
			self:settext("Information");
		end;
	};
--Jacket
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(left);
			self:diffuse(waieiColor("Dark"));
			self:strokecolor(Color("White"));
			self:maxwidth(150/0.75);
			self:zoom(0.75);
			self:x(SJACKET_CENTER_X-75);
			self:y(SJACKET_CENTER_Y-90);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:settext("Main Results");
			else
				self:settext("Stage "..GetSelDrillResult());
			end;
		end;
	};
	Def.Banner{
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:Load(GetLVInfo(""..GetSelDrillLevel().."-Jacket"));
			else
				if sg then
					self:Load(GetSongGPath(wheelmode,sg));
				else
					self:Load(THEME:GetPathG("Common fallback","jacket"));
				end;
			end;
			self:scaletofit(-75,-75,75,75);
			self:x(SJACKET_CENTER_X);
			self:y(SJACKET_CENTER_Y);
		end;
	};
--ClearBorder
	Def.Quad{
		OnCommand=function(self)
			self:zoomto(330,70);
			self:x(STITLE_CENTER_X);
			self:y(STITLE_CENTER_Y);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:diffuse(waieiColor("Light"));
				self:diffusealpha(0.66);
				self:fadeleft(0.5);
			else
				self:diffuse(_DifficultyCOLOR2(difc,df));
				self:diffusealpha(0.66);
				self:fadeleft(0.5);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:horizalign(left);
			self:diffuse(waieiColor("Dark"));
			self:x(BORDER_CENTER_X-BORDER_W2-1);
			self:y(BORDER_CENTER_Y);
			self:zoomto(BORDER_W+2,10+2);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:horizalign(left);
			self:diffuse(0,0,0.3,1.0);
		--	self:diffusetopedge(Color("White"));
			self:x(BORDER_CENTER_X-BORDER_W2);
			self:y(BORDER_CENTER_Y);
			self:zoomto(BORDER_W,10);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:horizalign(right);
			self:diffuse(Color("Yellow"));
		--	self:diffusetopedge(Color("White"));
			self:x(BORDER_CENTER_X+BORDER_W2);
			self:y(BORDER_CENTER_Y);
			self:zoomto((100-tonumber(GetDRInfo("Border")))*BORDER_W100,10);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:horizalign(left);
			self:diffuse(Color("Blue"));
		--	self:diffusetopedge(Color("White"));
			self:diffusealpha(0.75);
			self:x(BORDER_CENTER_X-BORDER_W2);
			self:y(BORDER_CENTER_Y);
			self:zoomto(0,10);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
				self:linear(1.0);
				self:zoomto(GetDrillScore("DP",nil)*BORDER_W,10);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_Drills/drill","border"))..{
		InitCommand=function(self)
			self:horizalign(left);
			self:x(BORDER_CENTER_X-BORDER_W2-1+(tonumber(GetDRInfo("Border"))*BORDER_W100));
			self:y(BORDER_CENTER_Y-20);
			self:animate(false);
			self:setstate(2);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(THEME:GetPathG("_Drills/drill","border"))..{
		InitCommand=function(self)
			self:horizalign(left);
			self:x(BORDER_CENTER_X-BORDER_W2-1);
			if GetDrillFailed() then
				self:setstate(0);
			else
				self:setstate(1);
			end;
			self:y(BORDER_CENTER_Y+20);
			self:animate(false);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
				self:linear(1.0);
				self:x(BORDER_CENTER_X-BORDER_W2-1+(GetDrillScore("DP",nil)*BORDER_W));
			else
				self:visible(false);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(right);
			self:diffuse(waieiColor("Text"));
			self:strokecolor(Color("White"));
			self:zoom(1.2);
			self:maxwidth(100/1.2);
			self:x(BORDER_CENTER_X+BORDER_W2+105);
			self:y(BORDER_CENTER_Y-2);
			self:settextf("%1.2f%%",GetDrillScore("DP",nil)*100);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(right);
			self:vertalign(bottom);
			self:zoom(0.75);
			self:maxwidth(280/0.75);
			self:x(STITLE_CENTER_X+115);
			self:y(STITLE_CENTER_Y+27);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(false);
			else
				self:visible(true);
				self:diffuse(_DifficultyCOLOR2(difc,df));
				self:strokecolor(BoostColor(_DifficultyCOLOR2(difc,df),0.5));
				self:settext(_DifficultyNAME2(difn,df));
			end;
		end;
	};
--SongTitle & Meter 
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:vertalign(bottom);
			self:zoom(1.2);
			self:maxwidth(160/1.2);
			self:x(STITLE_CENTER_X+140);
			self:y(STITLE_CENTER_Y+25);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(false);
			else
				self:visible(true);
				self:diffuse(_DifficultyCOLOR2(difc,df));
				self:strokecolor(BoostColor(_DifficultyCOLOR2(difc,df),0.5));
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
			end;
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(left);
			self:diffuse(waieiColor("Text"));
			self:strokecolor(Color("White"));
			self:maxwidth(320);
			self:x(STITLE_CENTER_X-160);
			self:y(STITLE_CENTER_Y-20);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(false);
			else
				self:visible(true);
				self:settext(sg:GetDisplayFullTitle());
			end;
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(left);
			self:diffuse(waieiColor("Text"));
			self:strokecolor(Color("White"));
			self:maxwidth(280/0.8);
			self:zoom(0.8);
			self:x(STITLE_CENTER_X-160);
			self:y(STITLE_CENTER_Y+3);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:visible(false);
			else
				self:visible(true);
				self:settext(sg:GetDisplayArtist());
			end;
		end;
	};
--Grade
	LoadActor(THEME:GetPathG("_GradeDisplay Normal/GradeDisplayEval","List"))..{
		OnCommand=function(self)
			self:animate(false);
			self:x(INFO_CENTER_X+80);
			self:y(INFO_CENTER_Y+62);
		end;
		Set2MessageCommand=function(self)
			if (GetSelDrillResult()==0 and GetDrillFailed()) or GetDrillScore("LIFE",GetSelDrillResult())<=0 then
				self:setstate(7);
			elseif GetDrillScore("DP",GetSelDrillResult())>0 and GetDrillScore("W3",GetSelDrillResult())==0
				and GetDrillScore("W4",GetSelDrillResult())==0 and GetDrillScore("W5",GetSelDrillResult())==0
				and GetDrillScore("MS",GetSelDrillResult())==0 and GetDrillScore("NG",GetSelDrillResult())==0 then
				if GetDrillScore("W2",GetSelDrillResult())==0 then
					self:setstate(0);
				else
					self:setstate(1);
				end;
			elseif gradepoint>=tonumber(THEME:GetMetric("PlayerStageStats","GradePercentTier03")) then
				self:setstate(2);
			elseif gradepoint>=tonumber(THEME:GetMetric("PlayerStageStats","GradePercentTier04")) then
				self:setstate(3);
			elseif gradepoint>=tonumber(THEME:GetMetric("PlayerStageStats","GradePercentTier05")) then
				self:setstate(4);
			elseif gradepoint>=tonumber(THEME:GetMetric("PlayerStageStats","GradePercentTier06")) then
				self:setstate(5);
			else
				self:setstate(6);
			end;
		end;
	};
--FullCombo 
	LoadActor(THEME:GetPathG("_GradeDisplay Normal/GradeDisplay","FullCombo"))..{
		OnCommand=function(self)
			self:animate(false);
			self:x(INFO_CENTER_X+150);
			self:y(INFO_CENTER_Y+80);
		end;
		Set2MessageCommand=function(self)
			local fctype=nil;
			-- [ja] やべぇこれすっげーめんどい 
			-- [ja] Boo,Miss,NG,Hitの合計値が0、各ステージのコンボ数がTAPSの値より多ければとりあえずFC扱いで 
			if GetDrillScore("DP",GetSelDrillResult())>0 and GetDrillScore("W5",GetSelDrillResult())==0
					and GetDrillScore("MS",GetSelDrillResult())==0 and GetDrillScore("NG",GetSelDrillResult())==0
					and GetDrillScore("HIT",GetSelDrillResult())==0 then
				local fcstage=true;
				if GetSelDrillResult()==0 then
					for stage=1,GetDrillMaxStage() do
						local _,_sg,_df=GetDrillSong(GetLVInfo(""..GetSelDrillLevel().."-Song")[stage]);
						if _sg then
							local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
							if stt then
								local st=_sg:GetOneSteps(stt,_df);
								if GetDrillScore("COMBO",stage)<st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_TapsAndHolds') then
									fcstage=false;
									break;
								end;
							else
								fcstage=false;
							end;
						else
							fcstage=false;
						end;
					end;
				else
					if sg then
						local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
						if stt then
							local st=sg:GetOneSteps(stt,df);
							if GetDrillScore("COMBO",GetSelDrillResult())<st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_TapsAndHolds') then
								fcstage=false;
							end;
						else
							fcstage=false;
						end;
					else
						fcstage=false;
					end;
				end;
				if fcstage then
					if GetDrillScore("W4",GetSelDrillResult())==0 then
						if GetDrillScore("W3",GetSelDrillResult())==0 then
							if GetDrillScore("W2",GetSelDrillResult())==0 then
								fctype="JudgmentLine_W1";
							else
								fctype="JudgmentLine_W2";
							end;				
						else
							fctype="JudgmentLine_W3";
						end;			
					else
						fctype="JudgmentLine_W4";
					end;
				else
					fctype=nil;
				end;
			else
				fctype=nil;
			end;
			if fctype then
				if fctype=="JudgmentLine_W1" then
					self:setstate(1);
					self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
					self:zoom(2.5/2);
				elseif fctype=="JudgmentLine_W2" then
					self:setstate(1);
					self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
					self:zoom(2.2/2);
				elseif fctype=="JudgmentLine_W3" then
					self:setstate(1);
					self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
					self:zoom(2.0/2);
				elseif fctype=="JudgmentLine_W4" then
					self:setstate(2);
					self:diffuse(GameColor.Judgment["JudgmentLine_W4"]);
					self:zoom(2.5/2);
				else
					self:setstate(0);
					self:zoom(0);
					self:diffuse(1.0,1.0,1.0,0);
				end;
			else
				self:setstate(0);
				self:zoom(0);
				self:diffuse(1.0,1.0,1.0,0);
			end;
		end;
	};
-- Life
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(left);
			self:diffuse(BoostColor(waieiColor("Text"),1.2));
			self:strokecolor(Color("Outline"));
			self:maxwidth(80/0.66);
			self:zoom(0.66);
			self:x(INFO_CENTER_X-10);
			self:y(INFO_CENTER_Y-14);
		end;
		Set2MessageCommand=function(self)
			self:settext((GetSelDrillResult()==0) and "LIFE (Avg)" or "LIFE");
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(right);
			self:diffuse(BoostColor(waieiColor("Text"),1.5));
			self:strokecolor(Color("Outline"));
			self:maxwidth(90/0.66);
			self:zoom(0.66);
			self:x(INFO_CENTER_X+130);
			self:y(INFO_CENTER_Y-14);
		end;
		Set2MessageCommand=function(self)
			self:settextf("%3.1f%%",GetDrillScore("LIFE",GetSelDrillResult())*100);
		end;
	};
-- DancePoints
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(left);
			self:diffuse(BoostColor(waieiColor("Text"),1.2));
			self:strokecolor(Color("Outline"));
			self:maxwidth(80/0.66);
			self:zoom(0.66);
			self:x(INFO_CENTER_X-10);
			self:y(INFO_CENTER_Y+2);
			self:settext("DANCEPOINTS");
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(right);
			self:diffuse(BoostColor(waieiColor("Text"),1.5));
			self:strokecolor(Color("Outline"));
			self:maxwidth(90/0.66);
			self:zoom(0.66);
			self:x(INFO_CENTER_X+130);
			self:y(INFO_CENTER_Y+2);
		end;
		Set2MessageCommand=function(self)
			self:settextf("%3.1f%%",GetDrillScore("DP",GetSelDrillResult())*100);
		end;
	};
-- MaxCombo
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(left);
			self:diffuse(BoostColor(waieiColor("Text"),1.2));
			self:strokecolor(Color("Outline"));
			self:maxwidth(80/0.66);
			self:zoom(0.66);
			self:x(INFO_CENTER_X-10);
			self:y(INFO_CENTER_Y+18);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:settext("");
			else
				self:settext("MAXCOMBO");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		OnCommand=function(self)
			self:horizalign(right);
			self:diffuse(BoostColor(waieiColor("Text"),1.5));
			self:strokecolor(Color("Outline"));
			self:maxwidth(90/0.66);
			self:zoom(0.66);
			self:x(INFO_CENTER_X+118);
			self:y(INFO_CENTER_Y+18);
		end;
		Set2MessageCommand=function(self)
			if GetSelDrillResult()==0 then
				self:settext("");
			else
				self:settextf("%3d",GetDrillScore("COMBO",GetSelDrillResult()));
			end;
		end;
	};
-- カロリー 
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:player(PLAYER_1);
			--self:diffuse(PlayerColor(PLAYER_1));
			self:diffuse(Color("White"));
			self:strokecolor(PlayerColor(GetDrillPlayer()));
			self:zoom(0.8)
			self:x((GetDrillPlayer()==PLAYER_1) and 80+_HS or SCREEN_RIGHT-80);
			self:y(SCREEN_BOTTOM-60);
		end;
		Set2MessageCommand=function(self)
			self:settextf("%.2f kcal\n%.2f kcal", GetDrillScore("CAL",GetSelDrillResult()), cal_total);
		end;
	};
-- Options
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:player(PLAYER_1);
			--self:diffuse(PlayerColor(PLAYER_1));
			self:diffuse(PlayerColor(GetDrillPlayer()));
			self:zoom(0.5);
			self:maxwidth(320/0.5);
			self:horizalign(right);
			self:x(INFO_CENTER_X+170);
			self:y(INFO_CENTER_Y+100);
			local ps = GAMESTATE:GetPlayerState(GetDrillPlayer());
			local po = ps:GetPlayerOptions("ModsLevel_Preferred");
			local modstr = ps:GetPlayerOptionsString("ModsLevel_Preferred")
			self:settext(modstr);
		end;
	};

	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		InitCommand=function(self)
			self:x(BASE_BOTTOM_CENTER_X-270);
			self:y(BASE_BOTTOM_CENTER_Y);
		end;
	};
	LoadActor(THEME:GetPathG("EditMenu","Right"))..{
		InitCommand=function(self)
			self:x(BASE_BOTTOM_CENTER_X+270);
			self:y(BASE_BOTTOM_CENTER_Y);
		end;
	};
	LoadActor("judgments",INFO_CENTER_X,INFO_CENTER_Y);
};
return t;