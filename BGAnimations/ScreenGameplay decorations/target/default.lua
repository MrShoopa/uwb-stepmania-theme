local pn=...;
local p=(pn==PLAYER_1) and 1 or 2;
local t=Def.ActorFrame{};

if not GAMESTATE:IsPlayerEnabled(pn) then
	return t;
end;

-- [ja] ターゲットスコアが有効かどうか 
local target='Off';
local nm=ToEnumShortString(pn);
if PROFILEMAN:GetNumLocalProfiles()>0
	and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
	for i=1,PROFILEMAN:GetNumLocalProfiles() do
		if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
			nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
			break
		end;
	end;
end;
target=GetUserPref_Theme("UserTarget"..nm);
if not target then target='Off' end;
if target=="Off" then
	return t;
end;

-- [ja] ライバル情報の取得 
local player_rival='';
if GetPlayerSaveProfileFile(pn)~='' then
	player_rival=GetBlockPrm(GetTextBlock(GetPlayerSaveProfileFile(pn),'Rival'),'1') or '';
end;
local rival_dp=0;

local target_sx=math.min((GAMESTATE:GetCurrentStyle():ColumnsPerPlayer())*64,SCREEN_CENTER_X-50);
local target_cnt=0;
local target_hi;
local target_total=0;
local target_hidp;
local target_dp;
local target_per;
local target_rev;
local target_pss;
if not GAMESTATE:IsCourseMode() then
	local pf;
	if nm==""..ToEnumShortString(pn) then
		pf=PROFILEMAN:GetMachineProfile();
	else
		if PROFILEMAN:IsPersistentProfile(pn) then
			-- player profile
			pf=PROFILEMAN:GetProfile(pn);
		else
			-- machine profile
			pf=PROFILEMAN:GetMachineProfile();
		end;
	end;
	target_hi=pf:GetHighScoreList(_SONG(),GAMESTATE:GetCurrentSteps(pn)):GetHighScores();
	target_total=yaGetRD(pn,'RadarCategory_TapsAndHolds')+yaGetRD(pn,'RadarCategory_Holds')+yaGetRD(pn,'RadarCategory_Rolls');
	target_pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
else
	local trail = GAMESTATE:GetCurrentTrail(pn);
	local tr_ent = trail:GetTrailEntries()
	local tr_max = #tr_ent;
	target_hi=PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentCourse(),trail):GetHighScores();
	for i=1,tr_max do
		local rv=tr_ent[i]:GetSteps():GetRadarValues(pn);
		target_total=target_total+rv:GetValue('RadarCategory_TapsAndHolds')+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls');
	end;
end;
if player_rival=='' or rival_name=='High Score' then
    player_rival = 'hiscore'
	target_hidp=GetScoreData(target_hi,"dp");
else
	local txt=GetCSRivalParameter(_SONG2(),_STEPS2(pn),player_rival);
	local rival_dp=GetCSRivalPercent(_STEPS2(pn),txt);
	target_hidp=rival_dp;
end;

local rival_mini  = {false,true,true,true,true};
local arrow_pos_y = {-75,75};
local rival_pos_x = {0,target_sx-30,target_sx-30,target_sx-30,target_sx-30};
local rival_pos_y = {-75,-100,-33,33,100};
local rival_zoom  = {1.0,0.8,0.8,0.8,0.8};
t[#t+1]=Def.ActorFrame{
	ScrollNomalMessageCommand=function(self, params)
		MESSAGEMAN:Broadcast("SetScrollNomal",{PlayerNumber=params.PlayerNumber,target_rev=false});
	end;
	ScrollReverseMessageCommand=function(self, params)
		MESSAGEMAN:Broadcast("SetScrollReverse",{PlayerNumber=params.PlayerNumber,target_rev=true});
	end;
	JudgmentMessageCommand = function(self, params)
		self:stoptweening();
		if params.Player==pn and params.TapNoteScore and
		   params.TapNoteScore ~= 'TapNoteScore_Invalid' and
		   params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
		   params.TapNoteScore ~= 'TapNoteScore_HitMine' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointMiss' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointHit' and
		   params.TapNoteScore ~= 'TapNoteScore_None' then
			self:stoptweening();
			self:sleep(0.02);
			target_cnt=target_cnt+1;
			local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			if (GAMESTATE:GetPlayerState(pn):GetPlayerController()~='PlayerController_Autoplay') then
				if params.HoldNoteScore=='HoldNoteScore_Held' then
					hd=hd+1;
				elseif params.TapNoteScore=='TapNoteScore_W1' then
					w1=w1+1;
				elseif params.TapNoteScore=='TapNoteScore_W2' then
					w2=w2+1;
				elseif params.TapNoteScore=='TapNoteScore_W3' then
					w3=w3+1;
				end;
			end;
			target_dp=(w1*3+w2*2+w3+hd*3)/(target_total*3);
			target_per=(target_dp-(target_hidp*target_cnt/target_total))*100;
			MESSAGEMAN:Broadcast("TargetScore",{
				PlayerNumber = pn,
				DPPlayer     = target_dp,
				DPCurrent    = target_cnt/target_total
			});
		end;
	end;
};
for i=1,5 do
	if i==1 or GAMESTATE:GetNumPlayersEnabled()<=1 then
		-- [ja] 二人プレイ時はライバル2以降を表示しない
		t[#t+1]=Def.ActorFrame{
			OnCommand=function(self)
				self:y(SCREEN_CENTER_Y);
			end;
			LoadActor(THEME:GetPathG('_Gameplay','Target'),pn,i,rival_mini[i])..{
				InitCommand=cmd(x,rival_pos_x[i]*((p==1) and 1 or -1);y,rival_pos_y[i];zoom,rival_zoom[i]);
				OnCommand=function(self)
					if i==1 then
						-- [ja] ターゲットスコア初期位置
						self:y(arrow_pos_y[IsReverse(pn) and 2 or 1]);
					end;
				end;
				SetScrollNomalMessageCommand=function(self,params)
					if i==1 and params.PlayerNumber==pn then
						-- [ja] 通常スクロール
						self:stoptweening();
						self:linear(0.2);
						self:y(arrow_pos_y[1]);
					end;
				end;
				SetScrollReverseMessageCommand=function(self,params)
					if i==1 and params.PlayerNumber==pn then
						-- [ja] Reverseスクロール
						self:stoptweening();
						self:linear(0.2);
						self:y(arrow_pos_y[2]);
					end;
				end;
			};
		};
	end;
end;

return t;
