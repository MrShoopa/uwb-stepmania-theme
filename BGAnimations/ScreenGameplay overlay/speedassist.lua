local pn=...;
local pAssist=false;
local invalid_time=0.15;
-- [ja] 停止時間が極端に短い場合は表示しない仕様に変更(1.335) 
local p=(pn==PLAYER_1) and 1 or 2;
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
pAssist=(GetUserPref_Theme("UserSpeedAssist"..nm)=='On');
if not pAssist then pAssist=false end;

local t=Def.ActorFrame{};
if not pAssist then
	return;
end;
local pStepZoneX=GetStepZonePosX(pn);
local pStepZoneY=SCREEN_CENTER_Y;
local now = 0.0;

local stopPosList;
local stopSecList;
local stopNowCnt;
local function setStopList(pn)
	if not GAMESTATE:IsPlayerEnabled(pn) then
		stopPosList={-1};
		stopSecList={-1};
		return;
	end;
	local st=GAMESTATE:GetCurrentSteps(pn);
	if st then
		local td=st:GetTimingData();
		if td:HasStops() then
			local strStops=td:GetStops();
			local i2=1;
			for i=1,#strStops do
				local stopData=split("=",strStops[i]);
				if tonumber(stopData[2])>=invalid_time then
					stopPosList[i2]=tonumber(stopData[1]);
					stopSecList[i2]=tonumber(stopData[2]);
					i2=i2+1;
				end;
			end;
		else
			stopPosList={-1};
			stopSecList={-1};
		end;
	end;
end;

local now;
local function SongChk()
	local ret=false;
	if (not song) or (song ~= _SONG2()) then
		song = _SONG2();
		ret=true;
	end;
	now=_MUSICSECOND();
	return ret;
end;

local chksec=0.025;
t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		self:queuecommand("Loop");
	end;
	LoopCommand=function(self)
		if SongChk() then
			self:finishtweening();
			self:playcommand("ChangeSong");
		end;
		self:finishtweening();
		self:visible(true);
		self:sleep(chksec);
		self:queuecommand("Loop");
	end;
	Def.Actor{
		OnCommand=function(self)
			stopPosList={0};
			stopSecList={0};
			stopNowCnt=1;
			setStopList(pn);
		end;
		ChangeSongCommand=function(self)
			self:playcommand("On");
		end;
	};
	LoadActor(THEME:GetPathG("_objects/_circle","glow100px"))..{
		Name="Glow";
		InitCommand=cmd(diffuse,Color("Red");blend,"BlendMode_Add";
			x,pStepZoneX;y,pStepZoneY;diffusealpha,0;visible,pAssist;diffusealpha,0;);
		LoopCommand=function(self)
			if stopPosList[1]~=-1 and stopNowCnt<=#stopPosList then
				beat=1.0*Sec2PlayerBeat(pn,now);
				if 1.0*beat>=stopPosList[stopNowCnt] and stopSecList[stopNowCnt]>invalid_time then
					local stopBegin=PlayerBeat2Sec(pn,stopPosList[stopNowCnt]);
					local stopEnd=stopBegin+stopSecList[stopNowCnt];
					if now>=stopEnd+0.1 then
						self:diffusealpha(0);
					elseif now>=stopEnd then
						self:diffusealpha(1.0-(now-stopEnd)*10);
						self:zoom(1.0+(now-stopEnd)*10);
					elseif now<stopBegin+0.1 then
						self:diffusealpha(1.0-(stopBegin+0.1-now)*10);
						self:zoom(1.0+(stopBegin+0.1-now)*10);
					else
						self:diffusealpha(1.0);
						self:zoom(1.0);
					end;
				else
						self:diffusealpha(0);
				end;
			else
					self:diffusealpha(0);
			end;
			self:sleep(chksec);
			self:queuecommand("Loop");
		end;
	};
	LoadActor(THEME:GetPathG("_objects/_circle","100px"))..{
		Name="Circle";
		InitCommand=cmd(diffuse,Color("Red");blend,"BlendMode_Add";
			x,pStepZoneX;y,pStepZoneY;diffusealpha,0;visible,pAssist;diffusealpha,0;);
		LoopCommand=function(self)
			if stopPosList[1]~=-1 and stopNowCnt<=#stopPosList then
				beat=1.0*Sec2PlayerBeat(pn,now);
				if 1.0*beat>=stopPosList[stopNowCnt] and stopSecList[stopNowCnt]>invalid_time then
					local stopBegin=PlayerBeat2Sec(pn,stopPosList[stopNowCnt]);
					local stopEnd=stopBegin+stopSecList[stopNowCnt];
					if now>=stopEnd+0.1 then
						self:diffusealpha(0);
						stopNowCnt=stopNowCnt+1;
					elseif now>=stopEnd then
						self:diffusealpha(1.0-(now-stopEnd)*10);
						self:zoom(1.0+(now-stopEnd)*10);
					elseif now<stopBegin+0.1 then
						self:diffusealpha(1.0-(stopEnd-now)/stopSecList[stopNowCnt]);
						self:zoom(1.0-(stopEnd-now)/stopSecList[stopNowCnt]);
					else
						self:diffusealpha(1.0-(stopEnd-now)/stopSecList[stopNowCnt]);
						self:zoom(1.0-(stopEnd-now)/stopSecList[stopNowCnt]);
					end;
				else
						self:diffusealpha(0);
				end;
			else
					self:diffusealpha(0);
			end;
			self:sleep(chksec);
			self:queuecommand("Loop");
		end;
	};
};

return t;
