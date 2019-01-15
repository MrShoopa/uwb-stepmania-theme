local function TweetResult(pn)
    local pname = PROFILEMAN:GetPlayerName(pn);
    if not pname or pname=='' then
        _SYS('You must set player name.');
        return;
    end;
	local function CreateUrl(str)
		local str_url = '';
		for i=1,string.len(str) do
			local str_byte=string.byte(str,i);
			str_url = str_url..'%'..string.format("%02x",str_byte);
		end;
		return str_url;
	end;
	local song=_SONG();
	local overlimit=GetUserPref_Theme("UserRadarOverLimit") or 'On';
	local MinCombo_=GetUserPref_Theme("UserMinCombo");
	local JudgeLabel=GetUserPref_Theme("UserJudgementLabel") or 'DDR';
	local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));
	local ss = STATSMAN:GetCurStageStats();
	local pss = ss:GetPlayerStageStats( pn );
	local ps = GAMESTATE:GetPlayerState( pn );
	local pct = pss:GetPercentDancePoints()*100;
	local st = _STEPS2(pn);
	local stt = st:GetStepsType();
	local diff = st:GetDifficulty();
	local cd = string.upper(_DifficultyNAME2("DDR SuperNOVA", diff));
	local meter='0';
	local pr = PROFILEMAN:GetProfile(pn);
	
	local highscore=0;
	local scorelist = pr:GetHighScoreList(song,GAMESTATE:GetCurrentSteps(pn));
	local scores = scorelist:GetHighScores();
	if pct>=GetScoreData(scores,"dp")*100 and pct>0 then
		highscore=1;
	end;
	
	-- [ja] 難易度
	local mt = GetUserPref_Theme("UserMeterType") or 'Default';
	if song:HasStepsTypeAndDifficulty(stt,diff) then
		if mt=='DDR X' then
			meter = GetConvertDifficulty_DDRX(song,st,GetNoLoadSongPrm(song,'metertype'));
		elseif mt=='LV100' then
			meter = GetConvertDifficulty_LV100(song,st);
		else
			meter = st:GetMeter();
		end;
	end;
	local metermode=string.upper(mt);
	
	-- [ja] フルコン
	local fc = 0;
	if pss:FullComboOfScore('TapNoteScore_W4') then
		if pss:FullComboOfScore('TapNoteScore_W1') then
			fc=1;
		elseif pss:FullComboOfScore('TapNoteScore_W2') and MinCombo>=2 then
			fc=2;
		elseif pss:FullComboOfScore('TapNoteScore_W3') and MinCombo>=3 then
			fc=3;
		elseif pss:FullComboOfScore('TapNoteScore_W4') and MinCombo>=4 then
			fc=4;
		else
			fc=0;
		end;
	else
		fc=0;
	end;
	
	-- [ja] 曲の色
	local n_song="";
	local col = '';
	if song then
		local n_group=""..song:GetGroupName();
		n_song=string.lower(GetSong2Folder(song));
		local metertype=GetSongs_str(n_group.."/"..n_song,'metertype') or 'ddr';
		local menucolor=GetSongs_str(n_group.."/"..n_song,'color');
		if not menucolor then
			if IsBossColor(song,metertype) then
				c=Color("Red");
			else
				c=waieiColor("WheelDefault");
			end;
		else
			c=menucolor;
		end;
		col = ''..c[1]..','..c[2]..','..c[3]..','..c[4];
		metertype = string.upper(metertype);
		if metermode ~= 'DEFAULT' then
			if metermode=='DDR X' and metertype == 'DDR' then
				metermode = 'DDR';
			end;
		else
			metermode = metertype;
		end;
	end;
	
	-- [ja] グレード
	local grade = '8';
	local gr = pss:GetGrade();
	if gr == 'Grade_Tier01' then
		grade = '0';
	elseif gr == 'Grade_Tier02' then
		grade = '1';
	elseif gr == 'Grade_Tier03' then
		grade = '2';
	elseif gr == 'Grade_Tier04' then
		grade = '3';
	elseif gr == 'Grade_Tier05' then
		grade = '4';
	elseif gr == 'Grade_Tier06' then
		grade = '5';
	elseif gr == 'Grade_Tier07' then
		grade = '6';
	else
		grade = '7';
	end;
	
	-- [ja] オプション
	local option = ps:GetPlayerOptionsString("ModsLevel_Preferred");
	
	-- [ja] グループ名
	local gn = song:GetGroupName();

	-- [ja] ダンスポイント
	local dp;
	if pct==100 then
		dp = '100';
	else
		dp = string.format("%2.2f",pct);
	end;
	
	-- [ja] ラベル
	local label='0';
	if JudgeLabel=='DDR' then
		label='1';
	elseif JudgeLabel=='DDR SuperNOVA' then
		label='2';
	else
		label='0';
	end;
	
	local param='?';
	param=param..'scoremode='..string.upper((GetUserPref_Theme("UserCustomScore") or 'SM5'))..'&';
	param=param..'score='..pss:GetScore()..'&';
	param=param..'dp='..dp..'&';
	param=param..'fc='..fc..'&';
	param=param..'j_w1='..pss:GetTapNoteScores('TapNoteScore_W1')..'&';
	param=param..'j_w2='..pss:GetTapNoteScores('TapNoteScore_W2')..'&';
	param=param..'j_w3='..pss:GetTapNoteScores('TapNoteScore_W3')..'&';
	param=param..'j_w4='..pss:GetTapNoteScores('TapNoteScore_W4')..'&';
	param=param..'j_w5='..pss:GetTapNoteScores('TapNoteScore_W5')..'&';
	param=param..'j_ms='..pss:GetTapNoteScores('TapNoteScore_Miss')..'&';
	param=param..'j_ok='..pss:GetHoldNoteScores('HoldNoteScore_Held')..'&';
	param=param..'j_mc='..pss:MaxCombo()..'&';
	param=param..'judge='..label..'&';
	param=param..'color='..col..'&';
	-- date time
	param=param..'tm_y='..Year()..'&';
	param=param..'tm_m='..(MonthOfYear()+1)..'&';
	param=param..'tm_d='..DayOfMonth()..'&';
	param=param..'tm_h='..Hour()..'&';
	param=param..'tm_mi='..Minute()..'&';
	param=param..'ultimate='..(IsUltimateLife() and 1 or 0)..'&';
	param=param..'style='..string.upper(GAMESTATE:GetCurrentGame():GetName())..'&';
	param=param..'mode='..string.upper(GAMESTATE:GetCurrentStyle():GetName())..'&';
	param=param..'timing='..GetTimingDifficulty()..'&';
	param=param..'life='..GetLifeDifficulty()..'&';
	param=param..'difficulty='..cd..'&';
	-- metertype mode
	param=param..'mtm='..metermode..'&';
	param=param..'level='..meter..'&';
	param=param..'grade='..grade..'&';
	param=param..'option='..option..'&';
	param=param..'r_str='..yaGetRadarVal(song,pn,'Stream',false,overlimit)..'&';
	param=param..'r_vol='..yaGetRadarVal(song,pn,'Voltage',false,overlimit)..'&';
	param=param..'r_air='..yaGetRadarVal(song,pn,'Air',false,overlimit)..'&';
	param=param..'r_frz='..yaGetRadarVal(song,pn,'Freeze',false,overlimit)..'&';
	param=param..'r_cha='..yaGetRadarVal(song,pn,'Chaos',false,overlimit)..'&';
	param=param..'theme='..(TC_GetwaieiMode()==1 and 'waiei' or '')..'&';
	param=param..'sub='..string.lower(TC_GetColorName())..'&';
	param=param..'hscore='..highscore..'&';
	-- GUID
	local guid = (pr and pr:GetGUID() or '0');
	param=param..'guid='..guid..'&';
	local url = URLEncode('http://sm.waiei.net/web/tweet.php'..param);
	--local url = URLEncode('http://localhost/web/tweet.php'..param);
	-- [ja] バイト単位で取り出さないと文字化けするので
	local md5=''
	md5 = md5..pss:GetScore()..dp..meter..grade..guid;
	md5 = md5..pss:GetTapNoteScores('TapNoteScore_W1')..pss:GetTapNoteScores('TapNoteScore_W3');
	md5 = md5..pss:GetTapNoteScores('TapNoteScore_W2')..pss:GetTapNoteScores('TapNoteScore_W4');
	md5 = md5..pss:GetTapNoteScores('TapNoteScore_Miss')..pss:GetHoldNoteScores('HoldNoteScore_Held');
	md5 = md5..pss:GetTapNoteScores('TapNoteScore_W5')..pss:MaxCombo();
	md5 = CRYPTMAN:MD5String(md5);
	url=url..'md5='..CreateUrl(md5)..'&';
	-- group name
	--url=url..'gn='..CreateUrl(string.lower(gn))..'&';
	local ogn = GetGroupParameterEx(song,'originalname');
	url=url..'gn='..((ogn=='') and string.lower(gn) or string.lower(ogn))..'&';
	-- song folder name
	--url=url..'fn='..CreateUrl(string.lower(n_song))..'&';
	url=url..'fn='..string.lower(n_song)..'&';
	-- [ja] プレイヤー名
	local player = (PROFILEMAN:GetPlayerName(pn) or '---');
	url=url..'player='..CreateUrl(player)..'&';
	-- [ja] グループ名（Group.ini）
	local pk = (GetGroups(gn, "name") or ((ogn~="") and ogn or gn));
	url=url..'package='..CreateUrl(pk)..'&';
	-- [ja] 曲名
	local title = song:GetDisplayFullTitle();
	url=url..'title='..CreateUrl(title)..'&';
	-- [ja] アーティスト名
	local artist = song:GetDisplayArtist();
	url=url..'artist='..CreateUrl(artist)..'&';
	GAMESTATE:ApplyGameCommand("urlnoexit,"..url);
end;

----------------------------------------------------------------------------------------------


local vStats = STATSMAN:GetCurStageStats();
local cscore;
if GetUserPref_Theme("UserCustomScore") ~= nil then
	cscore = GetUserPref_Theme("UserCustomScore");
else
	cscore = 'Off';
end;

local function CreateStats( pnPlayer )
	-- Actor Templates
	local aLabel = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	local aText = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	-- DA STATS, JIM!!
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer );
	-- Organized Stats.
	local tStats = {
		W1			= pnStageStats:GetTapNoteScores('TapNoteScore_W1');
		W2			= pnStageStats:GetTapNoteScores('TapNoteScore_W2');
		W3			= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
		W4			= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
		W5			= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pnStageStats:GetTapNoteScores('TapNoteScore_Miss');
		HitMine		= pnStageStats:GetTapNoteScores('TapNoteScore_HitMine');
		AvoidMine	= pnStageStats:GetTapNoteScores('TapNoteScore_AvoidMine');
		Held		= pnStageStats:GetHoldNoteScores('HoldNoteScore_Held');
		LetGo		= pnStageStats:GetHoldNoteScores('HoldNoteScore_LetGo');
		Total		= 1;
		HoldsAndRolls = 0;
		Seconds		= pnStageStats:GetCurrentLife();
	};
	if GAMESTATE:GetCurrentSteps(pnPlayer) then
		tStats["Total"]=yaGetRD(pnPlayer,'RadarCategory_TapsAndHolds')+yaGetRD(pnPlayer,'RadarCategory_Holds')+yaGetRD(pnPlayer,'RadarCategory_Rolls');
	elseif _COURSE() then
		local entry=_COURSE():GetCourseEntries();
		-- [ja] 仮置き 
		tStats["Total"]=(tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"]);
	end;
	-- Organized Equation Values
	local tValues = {
		-- marvcount*7 + perfcount*6 + greatcount*5 + goodcount*4 + boocount*2 + okcount*7
		ITG			= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 ), 
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount + okcount + ngcount)*7
		ITG_MAX		= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7,
		-- marvcount*3 + perfcount*2 + greatcount*1 - boocount*4 - misscount*8 + okcount*6
		MIGS		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 ),
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount)*3 + (okcount + ngcount)*6
		MIGS_MAX	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 ),
		SN2	= (math.round( (tStats["W1"] + tStats["W2"] + tStats["W3"]/2+tStats["Held"])*100000/math.max(tStats["Total"],1)-(tStats["W2"] + tStats["W3"]))*10),
	};
	if cscore=="SuperNOVA2" then
		tValues["SN2"]		= (tStats["W1"]*5 + tStats["W2"]*4 + tStats["W3"]*3 + tStats["W4"]*2 + tStats["W5"] + tStats["Held"]*5);
	end;

	local t = Def.ActorFrame {};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,5);
		Def.Quad{
			InitCommand=cmd(visible,false);
			UpdateNetEvalStatsMessageCommand=function(self,params)
				local st=params.Steps;
				tStats["HoldsAndRolls"] = st:GetRadarValues(pnPlayer):GetValue('RadarCategory_Holds')+st:GetRadarValues(pnPlayer):GetValue('RadarCategory_Rolls');
				tStats["Total"]	= math.max(st:GetRadarValues(pnPlayer):GetValue('RadarCategory_TapsAndHolds')+tStats["HoldsAndRolls"],1);
				self:sleep(0.01);
				self:queuecommand("NetScore")
			end;
			NetScoreCommand=function(self)
				local p=((pnPlayer=='PlayerNumber_P1') and 1 or 2);
				tStats["W1"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W1NumberP"..p):GetText());
				tStats["W2"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W2NumberP"..p):GetText());
				tStats["W3"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W3NumberP"..p):GetText());
				tStats["W4"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W4NumberP"..p):GetText());
				tStats["W5"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("W5NumberP"..p):GetText());
				tStats["Miss"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("MissNumberP"..p):GetText());
				tStats["Held"]	= tonumber(SCREENMAN:GetTopScreen():GetChild("HeldNumberP"..p):GetText());
				tStats["LetGo"]	= tStats["HoldsAndRolls"]-tStats["Held"];
				tValues["ITG"]		= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 );
				tValues["ITG_MAX"]	= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7;
				tValues["MIGS"]		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 );
				tValues["MIGS_MAX"]	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 );
				if cscore~="SuperNOVA2" then
					tValues["SN2"]		= (math.round( (tStats["W1"] + tStats["W2"] + tStats["W3"]/2+tStats["Held"])*100000/math.max(tStats["Total"],1)-(tStats["W2"] + tStats["W3"]))*10);
				else
					tValues["SN2"]		= (tStats["W1"]*5 + tStats["W2"]*4 + tStats["W3"]*3 + tStats["W4"]*2 + tStats["W5"] + tStats["Held"]*5);
				end;
			end;
		};
		Def.Quad{
			InitCommand=cmd(zoomto,120,130;diffuse,Color( "Black" ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:faderight(0.8);
				else
					self:fadeleft(0.8);
				end;
			end;
		};
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,-34);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="ITG DP:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,5;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%04i",tValues["ITG"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["ITG"])};
		aText .. { InitCommand=cmd(x,7;y,7;vertalign,bottom;zoom,0.5;diffusealpha,0.5;settext,"/"); };
		aText .. { InitCommand=cmd(x,16;y,7;horizalign,left;vertalign,bottom;zoom,0.5;settextf,"%04i",tValues["ITG_MAX"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["ITG_MAX"])};
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,5);
		Def.Quad{
			InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
			OnCommand=function(self)
				if pnPlayer==PLAYER_1 then
					self:skewx(0.13);
					self:diffuselowerleft(0,0,0,0);
				else
					self:skewx(-0.13);
					self:diffuselowerright(0,0,0,0);
				end;
				self:blend("BlendMode_Add");
			end;
		};
		aLabel .. { Text="MIGS DP:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
		aText .. { InitCommand=cmd(x,5;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%04i",tValues["MIGS"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["MIGS"])};
		aText .. { InitCommand=cmd(x,7;y,7;vertalign,bottom;zoom,0.5;diffusealpha,0.7;settext,"/"); };
		aText .. { InitCommand=cmd(x,16;y,7;horizalign,left;vertalign,bottom;zoom,0.5;settextf,"%04i",tValues["MIGS_MAX"]);
					UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
					NetScoreCommand=cmd(settextf,"%04i",tValues["MIGS_MAX"])};
	};
	if GAMESTATE:IsCourseMode() then 
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(y,46);
			Def.Quad{
				InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
				OnCommand=function(self)
					if pnPlayer==PLAYER_1 then
						self:skewx(0.13);
						self:diffuselowerleft(0,0,0,0);
					else
						self:skewx(-0.13);
						self:diffuselowerright(0,0,0,0);
					end;
					self:blend("BlendMode_Add");
				end;
			};
			aLabel .. { Text="TotalSeconds:"; InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
			aText .. { InitCommand=cmd(x,50;y,7;horizalign,right;
				vertalign,bottom;zoom,0.6;settext,SecondsToMMSSMsMs(vStats:GetPlayerStageStats(pnPlayer):GetAliveSeconds()));};
		};
	else
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(y,46);
			Def.Quad{
				InitCommand=cmd(zoomto,116,30;diffuse,PlayerColor( pnPlayer ));
				OnCommand=function(self)
					if pnPlayer==PLAYER_1 then
						self:skewx(0.13);
						self:diffuselowerleft(0,0,0,0);
					else
						self:skewx(-0.13);
						self:diffuselowerright(0,0,0,0);
					end;
					self:blend("BlendMode_Add");
				end;
			};
			aLabel .. { Text=((cscore~="SuperNOVA2") and "SN2 SCORE:" or "SM5 SCORE:"); InitCommand=cmd(x,-52;y,-8;zoomy,0.4) };
			aText .. { InitCommand=cmd(x,50;y,7;horizalign,right;vertalign,bottom;zoom,0.6;settextf,"%7i",tValues["SN2"]);
						UpdateNetEvalStatsMessageCommand=cmd(sleep,0.01;queuecommand,"NetScore";);
						NetScoreCommand=cmd(settextf,"%7i",tValues["SN2"])};
		};
	end;
	return t
end;

local t = Def.ActorFrame {
	CodeMessageCommand=function(self, params)
		if not GAMESTATE:IsCourseMode() then
			if params.Name=="Tweet" or params.Name=="Tweet2" then
				TweetResult(GetSidePlayer(params.PlayerNumber));
			end;
		end;
	end;
};
if not THEME:GetMetric( Var "LoadingScreen","Summary" ) then
	GAMESTATE:IsPlayerEnabled(PLAYER_1)
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_1);x,SCREEN_LEFT+55;y,SCREEN_TOP+120);
		CreateStats( PLAYER_1 );
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_2);x,SCREEN_RIGHT-55;y,SCREEN_TOP+120);
		CreateStats( PLAYER_2 );
	};
end;
return t