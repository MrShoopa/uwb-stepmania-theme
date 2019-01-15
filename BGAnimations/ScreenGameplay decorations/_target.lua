local pn=...;
local p=(pn==PLAYER_1) and 1 or 2;
local t=Def.ActorFrame{};

if not GAMESTATE:IsPlayerEnabled(pn) then
	return t;
end;

-- [ja] ターゲットスコア 
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
	player_rival=GetBlockPrm(GetTextBlock(GetPlayerSaveProfileFile(pn),'Rival'),'1');
end;
local rival_name='';
local rival_avatar='';
local rival_mode=0;
if player_rival and player_rival~='' then
	rival_name=GetCSRivalName(player_rival);
	local chkdir='./CSRealScore/'..player_rival..'/';
	if FILEMAN:DoesFileExist(chkdir..'waieiAvatar.ini') then
		rival_avatar=chkdir..'waieiAvatar.ini';
		rival_mode=1;
	elseif FileExist(chkdir..'CSAvatar') then
		rival_avatar=GetFileExist(chkdir..'CSAvatar');
		rival_mode=2;
	else
		if string.lower(player_rival)=='hiscore'
			or string.lower(player_rival)=='highscore' then
			rival_name='High Score';
			rival_avatar=GetNoImageAvatar('hiscore');
		else
			if rival_name=='' then
				rival_avatar=GetNoImageAvatar(DayOfYear()%9+1);
			else
				rival_avatar=GetNoImageAvatar(tonumber(string.byte(rival_name))%9+1);
			end;
		end;
		rival_mode=0;
	end;
end;
if rival_avatar=='' then
	rival_avatar=THEME:GetPathG('','_blank');
	rival_mode=0;
end;
local rival_dp=0;

local target_sx=256;
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
	target_hidp=GetScoreData(target_hi,"dp");
else
	local txt=GetCSRivalParameter(_SONG2(),_STEPS2(pn),player_rival);
	local rival_dp=GetCSRivalPercent(_STEPS2(pn),txt);
	target_hidp=rival_dp;
end;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		self:zoomy(0);
		target_rev=IsReverse(pn);
		MESSAGEMAN:Broadcast("Set",{pn=pn,target_rev=target_rev});
	end;
	CodeMessageCommand=function(self,params)
		if not IsDrill() or GetDrillRealTimeOpt() then
			if params.PlayerNumber==pn then
				if params.Name == "ScrollNomal" then
					target_rev=false;
					MESSAGEMAN:Broadcast("Set",{pn=pn,target_rev=target_rev});
				elseif params.Name == "ScrollReverse" then
					target_rev=true;
					MESSAGEMAN:Broadcast("Set",{pn=pn,target_rev=target_rev});
				end;
			end;
		end;
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
			MESSAGEMAN:Broadcast("TargetScore",{pn=pn,target_dp=target_dp,target_per=target_per,target_cnt=target_cnt});
		end;
	end;
	SetMessageCommand=function(self,params)
		if params.pn==pn then
			self:stoptweening();
			self:zoomy(1);
			self:linear(0.1);
			if not params.target_rev then
				self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYStandard")+55);
			else
				self:y(SCREEN_CENTER_Y+THEME:GetMetric("Player","ReceptorArrowsYReverse")-70);
			end;
		end;
	end;
	Def.Quad{
		InitCommand=cmd(zoomto,target_sx+2,20;horizalign,left;x,-target_sx/2-1;diffuse,0,0,0,0.5;);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,target_sx/3+2,16;horizalign,left;y,18;x,target_sx/6-1;diffuse,0,0,0,0.5;);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,target_sx,18;horizalign,left;x,-target_sx/2;diffuse,1,1,1,0.5;);
		OnCommand=function(self)
			self:zoomx(0);
			self:zoomy(18);
		end;
		TargetScoreMessageCommand = function(self,params)
		if params.pn==pn then
			self:stoptweening();
			self:zoomx(target_sx*(target_hidp*target_cnt/target_total));
			self:zoomy(18);
			end;
		end;
		OffCommand=function(self)
			self:zoomx(target_sx*(target_hidp*target_cnt/target_total));
			self:zoomy(18);
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,0,18;horizalign,left;x,-target_sx/2;diffuse,PlayerColor(pn););
		TargetScoreMessageCommand = function(self,params)
			if params.pn==pn then
				self:stoptweening();
				self:zoomx(target_sx*params.target_dp);
				self:zoomy(18);
				self:diffusealpha(0.5);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			(cmd(zoom,0.8;x,target_sx/2-42;y,-1;
				diffuse,0.8,0.8,0.8,1;strokecolor,Color("Outline");))(self);
				self:settextf("%4.2f%%",0);
		end;
		TargetScoreMessageCommand = function(self,params)
			if params.pn==pn then
				self:finishtweening();
				local add_ch="";
				if params.target_per<-0.0081 then
					self:diffuse(ColorLightTone(Color("Red")));
					add_ch="";
				elseif params.target_per>0.0081 then
					self:diffuse(ColorLightTone(Color("Blue")));
					add_ch="+";
				else
					self:diffuse(0.8,0.8,0.8,1);
					add_ch=" ";
				end;
				self:settextf("%4.2f%%",params.target_dp*100);
				self:zoom(1.0);
				self:linear(0.02);
				self:zoom(0.8);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			(cmd(zoom,0.7;x,target_sx/2-42;y,15;
				diffuse,0.8,0.8,0.8,1;strokecolor,Color("Outline");))(self);
				self:settextf("%4.2f%%",0);
		end;
		TargetScoreMessageCommand = function(self,params)
			if params.pn==pn then
				self:finishtweening();
				local add_ch="";
				if params.target_per<-0.0081 then
					self:diffuse(ColorLightTone(Color("Red")));
					add_ch="";
					MESSAGEMAN:Broadcast('AvatarChanged',{id=p,t=AVATAR_LOSE});
					MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p,t=AVATAR_WIN});
				elseif params.target_per>0.0081 then
					self:diffuse(ColorLightTone(Color("Blue")));
					add_ch="+";
					MESSAGEMAN:Broadcast('AvatarChanged',{id=p,t=AVATAR_WIN});
					MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p,t=AVATAR_LOSE});
				else
					self:diffuse(0.8,0.8,0.8,1);
					add_ch=" ";
					MESSAGEMAN:Broadcast('AvatarChanged',{id=p,t=AVATAR_NORMAL});
					MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p,t=AVATAR_NORMAL});
				end;
				self:settextf("%s%4.2f%%",
					add_ch,params.target_per);
				self:zoom(1.0);
				self:linear(0.02);
				self:zoom(0.7);
			end;
		end;
	};
	LoadActor(THEME:GetPathG('_Avatar','graphics'),p,GetPlayerAvatar(pn))..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoomy(1);
				self:linear(0.1);
				if SCREEN_WIDTH/SCREEN_HEIGHT>1.777 then
					if pn==PLAYER_1 then
						self:x(-target_sx/2-42);
						self:rotationy(180);
					else
						self:x(target_sx/2+42);
					end;
					self:y(0);
					self:zoom(0.75);
				elseif SCREEN_WIDTH/SCREEN_HEIGHT>=1.6 then
					if pn==PLAYER_1 then
						self:x(-target_sx/2-36);
						self:rotationy(180);
					else
						self:x(target_sx/2+36);
					end;
					self:y(0);
					self:zoom(0.66);
				else
					if pn==PLAYER_1 then
						self:x(-target_sx/2+36);
						self:rotationy(180);
					else
						self:x(target_sx/2-36);
					end;
					self:y((not params.target_rev) and 40 or -45);
					self:zoom(0.6);
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG('_Avatar','graphics/rival'),3+5*p,rival_avatar)..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoomy(1);
				self:linear(0.1);
				if pn==PLAYER_2 then
					self:x(-target_sx/2+32);
					if rival_mode==1 then
						self:rotationy(180);
					end;
				else
					self:x(target_sx/2-32);
				end;
				self:y((not params.target_rev) and 55 or -40);
				self:zoom(0.6);
			end;
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			if rival_name~='' then
				self:visible(true);
				self:zoom(0.6);
				if pn==PLAYER_2 then
					self:x(-target_sx/2+70);
					self:horizalign(left);
				else
					self:horizalign(right);
					self:x(target_sx/2-70);
				end;
				self:diffuse(BoostColor(PlayerColor(pn),1.8));
				self:strokecolor(Color('Outline'));
				self:skewx(-0.2);
				self:settext(rival_name);
			else
				self:visible(false);
			end;
		end;
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:linear(0.1);
				self:y((not params.target_rev) and 45 or -50);
			end;
		end;
	};
	LoadActor('rival',pn,2)..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoom(0.8);
				if pn==PLAYER_1 then
					self:x(target_sx/2);
				else
					self:x(0);
				end;
				self:linear(0.1);
				self:y((not params.target_rev) and 135 or -190);
			end;
		end;
	};
	LoadActor('rival',pn,3)..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoom(0.8);
				if pn==PLAYER_1 then
					self:x(0);
				else
					self:x(-target_sx/2);
				end;
				self:linear(0.1);
				self:y((not params.target_rev) and 135 or -190);
			end;
		end;
	};
	LoadActor('rival',pn,4)..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoom(0.8);
				if pn==PLAYER_1 then
					self:x(target_sx/2);
				else
					self:x(0);
				end;
				self:linear(0.1);
				self:y((not params.target_rev) and 185 or -240);
			end;
		end;
	};
	LoadActor('rival',pn,5)..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoom(0.8);
				if pn==PLAYER_1 then
					self:x(0);
				else
					self:x(-target_sx/2);
				end;
				self:linear(0.1);
				self:y((not params.target_rev) and 185 or -240);
			end;
		end;
	};
};

return t;
