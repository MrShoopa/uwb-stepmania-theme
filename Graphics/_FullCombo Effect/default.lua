local MinCombo_=GetUserPref_Theme("UserMinCombo");
local MinCombo=(MinCombo_=='TapNoteScore_W3') and 3 or ((MinCombo_=='TapNoteScore_W1') and 1 or ((MinCombo_=='TapNoteScore_W2') and 2 or 4));

local t=Def.ActorFrame{};
-- [ja]フルコンボエフェクト
local function GetFullComboEffectPosX(pn)
	local r=SCREEN_CENTER_X;
	local p;
	local st=GAMESTATE:GetCurrentStyle():GetStyleType();
	if GAMESTATE:GetNumPlayersEnabled()==1 and Center1Player() then
		r=SCREEN_CENTER_X;
	else
		if pn==PLAYER_1 then
			p="1";
		else
			p="2";
		end;
		r=THEME:GetMetric("ScreenGameplay","PlayerP"..p..ToEnumShortString(st).."X");
	end;
	return r;
end;
local function GetFullComboEffectSizeX(pn)
	local r=0;
	local one=THEME:GetMetric("ArrowEffects","ArrowSpacing");
	local stt=GAMESTATE:GetCurrentSteps(pn):GetStepsType();
	if stt=='StepsType_Dance_Single' then
		r=one*4;
	elseif stt=='StepsType_Dance_Double' then
		r=one*8;
	elseif stt=='StepsType_Dance_Couple' then
		r=one*4;
	elseif stt=='StepsType_Dance_Solo' then
		r=one*6;
	elseif stt=='StepsType_Dance_Threepanel' then
		r=one*3;
	else
		r=SCREEN_WIDTH;
	end;
	return r;
end;
local function GetFullComboEffectColor(pss)
	local r=color("1.0,1.0,1.0,1.0");
		if pss:FullComboOfScore('TapNoteScore_W1') then
			r=GameColor.Judgment["JudgmentLine_W1"];
		elseif pss:FullComboOfScore('TapNoteScore_W2') and MinCombo>=2 then
			r=GameColor.Judgment["JudgmentLine_W2"];
		elseif pss:FullComboOfScore('TapNoteScore_W3') and MinCombo>=3 then
			r=GameColor.Judgment["JudgmentLine_W3"];
		elseif pss:FullComboOfScore('TapNoteScore_W4') and MinCombo>=4 then
			r=GameColor.Judgment["JudgmentLine_W4"];
		end;
	return r;
end;
local function GetFullComboJudgmentCount(pss)
	local r=0;
		if pss:FullComboOfScore('TapNoteScore_W1') then
			r=1;
		elseif pss:FullComboOfScore('TapNoteScore_W2') and MinCombo>=2 then
			r=2;
		elseif pss:FullComboOfScore('TapNoteScore_W3') and MinCombo>=3 then
			r=3;
		elseif pss:FullComboOfScore('TapNoteScore_W4') and MinCombo>=4 then
			r=4;
		end;
	return r;
end;

local SongIni={};
t[#t+1] = Def.Actor{
	OffCommand = function(self)
		SongIni=getenv("SongIni");
	end;
};
for pn in ivalues(PlayerNumber) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_CENTER_Y);
		LoadActor("underlay")..{
			InitCommand = cmd(player,pn;diffusealpha,0);
			OffCommand = function(self)
				local ss = STATSMAN:GetCurStageStats();
				local pss = ss:GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if SongIni then
						if SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]
							and SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]));
						elseif SongIni["FC_Color"] and SongIni["FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["FC_Color"]));
						end;
					end;
					self:x(GetFullComboEffectPosX(pn));
					self:blend('BlendMode_Add');
					self:zoomtowidth(GetFullComboEffectSizeX(pn)*2);
					self:zoomy(0);
					self:diffusealpha(0);
					self:linear(0.3);
					self:zoomtowidth(GetFullComboEffectSizeX(pn));
					self:zoomy(0.5);
					self:diffusealpha(1);
					self:linear(1.2);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
		LoadActor("underlay")..{
			InitCommand = cmd(player,pn;diffusealpha,0);
			OffCommand = function(self)
				local ss = STATSMAN:GetCurStageStats();
				local pss = ss:GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if SongIni then
						if SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]
							and SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]));
						elseif SongIni["FC_Color"] and SongIni["FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["FC_Color"]));
						end;
					end;
					self:x(GetFullComboEffectPosX(pn));
					if not IsReverse(pn) then
						self:y(SCREEN_CENTER_Y);
					else
						self:y(-SCREEN_CENTER_Y);
					end;
					self:blend('BlendMode_Add');
					self:zoomtowidth(GetFullComboEffectSizeX(pn)*1.5);
					self:zoomy(0);
					self:diffusealpha(0);
					self:linear(0.5);
					self:zoomtowidth(GetFullComboEffectSizeX(pn)*1.5);
					self:zoomy(1);
					self:diffusealpha(1);
					self:linear(1.0);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
		LoadActor("fan_1")..{
			InitCommand = cmd(player,pn;diffusealpha,0);
			OffCommand = function(self)
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if SongIni then
						if SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]
							and SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]));
						elseif SongIni["FC_Color"] and SongIni["FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["FC_Color"]));
						end;
					end;
					self:x(GetFullComboEffectPosX(pn));
					self:blend('BlendMode_Add');
					self:zoom(2);
					self:diffusealpha(0);
					--self:sleep(0.5);
					self:linear(0.3);
					self:zoom(1);
					self:diffusealpha(1);
					self:linear(0.7);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand = cmd(player,pn;diffusealpha,0;);
			OffCommand = function(self)
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				self:diffuse(GetFullComboEffectColor(pss));
				if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
					if SongIni then
						if SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]
							and SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["W"..GetFullComboJudgmentCount(pss).."FC_Color"]));
						elseif SongIni["FC_Color"] and SongIni["FC_Color"]~="" then
							self:diffuse(Str2Color(SongIni["FC_Color"]));
						end;
					end;
					local fctext="Full Combo!";
					if pss:FullComboOfScore('TapNoteScore_W1') then
						fctext="".._JudgementLabel("TapNoteScore_W1").." Full Combo!";
					elseif pss:FullComboOfScore('TapNoteScore_W2') then
						fctext="".._JudgementLabel("TapNoteScore_W2").." Full Combo!";
					elseif pss:FullComboOfScore('TapNoteScore_W3') then
						fctext="Full Combo!";
					elseif pss:FullComboOfScore('TapNoteScore_W4') then
						fctext="".._JudgementLabel("TapNoteScore_W4").." Full Combo!";
					end;
					if SongIni then
						if SongIni["CLEARED_Text"] and SongIni["CLEARED_Text"]~="" then
							fctext=SongIni["CLEARED_Text"];
						end;
					end;
					self:settext(fctext);
					self:strokecolor(Color("Outline"));
					self:maxwidth(200);
					self:rotationz(-15);
					self:x(GetFullComboEffectPosX(pn));
					if not IsReverse(pn) then
						self:y(80);
					else
						self:y(-80);
					end;
					self:zoom(8);
					self:diffusealpha(0);
					--self:sleep(0.2);
					self:bounceend(0.3);
					self:zoom(1.5);
					self:diffusealpha(1);
					self:sleep(0.5);
					self:linear(1.0);
					self:diffusealpha(0);
				else
					self:diffusealpha(0);
				end;
			end;
		};
	};
end;
t[#t+1] = Def.Actor{
	OffCommand = function(self)
		local f_fullcombo=false;
		local f_failed=false;
		local p_fullcombo=0;
		local p_failed=0;
		for pn in ivalues(PlayerNumber) do
			local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
			if pss:FullComboOfScore('TapNoteScore_W'..MinCombo) then
				f_fullcombo=true;
				p_fullcombo=pn;
			end;
			if not p_failed and pss:GetFailed() then
				f_failed=true;
				p_failed=pn;
			end;
		end;
		if STATSMAN:GetCurStageStats():AllFailed() then
			-- [ja] 全員ゲームオーバーなのでフルコンボアナウンスなし 
			f_fullcombo=false;
			f_failed=true;
		end;
		if f_fullcombo and p_fullcombo~=p_failed then
			SOUND:PlayAnnouncer("-waiei gameplay fullcombo");
		elseif not f_failed then
			SOUND:PlayAnnouncer("-waiei gameplay not fullcombo");
		end;
	end;
};

return t;