local pn,rn=...;
local p=(pn==PLAYER_1) and 1 or 2;
local t=Def.ActorFrame{};
local player_rival='';

if GetPlayerSaveProfileFile(pn)~='' then
	player_rival=GetBlockPrm(GetTextBlock(GetPlayerSaveProfileFile(pn),'Rival'),rn);
else
	return t;
end;
if player_rival=='' then
	return t;
end;

local rival_name='';
local rival_avatar='';
local rival_mode=0;
local rival_dp=0;
if player_rival then
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
local target_hi;
local target_total=0;
local target_hidp;
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
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			(cmd(zoom,0.7;
				diffuse,0.8,0.8,0.8,1;strokecolor,Color("Outline");))(self);
				if pn==PLAYER_2 then
					self:x(70);
					self:horizalign(left);
				else
					self:horizalign(right);
					self:x(-70);
				end;
				self:settextf("%4.2f%%",0);
		end;
		TargetScoreMessageCommand = function(self,params)
			if params.pn==pn then
				self:finishtweening();
				local target_per=(params.target_dp-(target_hidp*params.target_cnt/target_total))*100;
				local add_ch="";
				if target_per<-0.0081 then
					self:diffuse(ColorLightTone(Color("Red")));
					add_ch="";
					MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_WIN});
				elseif target_per>0.0081 then
					self:diffuse(ColorLightTone(Color("Blue")));
					add_ch="+";
					MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_LOSE});
				else
					self:diffuse(0.8,0.8,0.8,1);
					add_ch=" ";
					MESSAGEMAN:Broadcast('AvatarChanged',{id=3+5*p+rn,t=AVATAR_NORMAL});
				end;
				self:settextf("%s%4.2f%%",add_ch,target_per);
				self:zoom(1.0);
				self:linear(0.02);
				self:zoom(0.7);
			end;
		end;
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:linear(0.1);
				self:y((not target_rev) and 45 or -50);
			end;
		end;
	};
	LoadActor(THEME:GetPathG('_Avatar','graphics/rival'),3+5*p+rn,rival_avatar)..{
		SetMessageCommand=function(self,params)
			if params.pn==pn then
				self:finishtweening();
				self:zoomy(1);
				self:linear(0.1);
				if pn==PLAYER_2 then
					self:x(32);
					if rival_mode==1 then
						self:rotationy(180);
					end;
				else
					self:x(-32);
				end;
				self:y((not target_rev) and 55 or -40);
				self:zoom(0.6);
			end;
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			if rival_name~='' then
				self:finishtweening();
				self:visible(true);
				self:zoom(0.6);
				if pn==PLAYER_2 then
					self:x(70);
					self:horizalign(left);
				else
					self:horizalign(right);
					self:x(-70);
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
				self:y((not target_rev) and 65 or -50);
			end;
		end;
	};
};

return t;