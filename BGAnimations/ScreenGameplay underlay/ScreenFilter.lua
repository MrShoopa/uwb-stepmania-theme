local t=Def.ActorFrame{};

local filter={'Off','Off'};
for pn in ivalues(PlayerNumber) do
	if GAMESTATE:IsPlayerEnabled(pn) then
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
		filter[p]=GetUserPref_Theme("UserScreenFilter"..nm);
		if not filter[p] then filter[p]='Off' end;
	end;
end;

local song;
local start;
local last;
local function SongChk()
	if (not song) or (song ~= _SONG()) then
		song = _SONG();
		if song then
			start = song:GetFirstBeat();
			last = song:GetLastBeat();
		end;
	end;
end;
t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		SongChk();
		self:queuecommand("Loop");
	end;
	LoopCommand=function(self)
		self:finishtweening();
		SongChk();
		self:sleep(0.1);
		self:queuecommand("Loop");
	end;
};

local function GetFilterSizeX(pn)
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
	elseif stt=='StepsType_Dance_Routine' then
		r=one*8;
	elseif stt=='StepsType_Pump_Single' then	--[ja] オブジェが大きくないので少なくても足りる？ 
		r=one*4;
	elseif stt=='StepsType_Pump_Halfdouble' then
		r=one*5.25;
	elseif stt=='StepsType_Pump_Double' then
		r=one*8.5;
	elseif stt=='StepsType_Pump_Couple' then
		r=one*4;
	elseif stt=='StepsType_Pump_Routine' then
		r=one*8.5;
	elseif stt=='StepsType_Kb7_Single' then
		r=one*8;
	elseif stt=='StepsType_Bm_Single5' then
		r=one*5;
	elseif stt=='StepsType_Bm_Versus5' then
		r=one*5;
	elseif stt=='StepsType_Bm_Single7' then
		r=one*7;
	elseif stt=='StepsType_Bm_Versus7' then
		r=one*7;
	elseif stt=='StepsType_Maniax_Single' then
		r=one*4;
	elseif stt=='StepsType_Maniax_Double' then
		r=one*8;
	elseif stt=='StepsType_Techno_Single4' then
		r=one*4;
	elseif stt=='StepsType_Techno_Single5' then
		r=one*5;
	elseif stt=='StepsType_Techno_Single8' then
		r=one*8;
	elseif stt=='StepsType_Techno_Double4' then
		r=one*8;
	elseif stt=='StepsType_Techno_Double5' then
		r=one*10;
	elseif stt=='StepsType_Techno_Double8' then
		r=one*9.5;
	else
		r=SCREEN_WIDTH;
	end;
	return r;
end;

for pn in ivalues(PlayerNumber) do
	local p=(pn==PLAYER_1) and 1 or 2;
	t[#t+1]=Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(y,SCREEN_CENTER_Y;diffuse,Color("Black"););
			OnCommand=function(self)
				self:x(GetStepZonePosX(pn));
				self:zoomto(GetFilterSizeX(pn)+20,SCREEN_HEIGHT);
				self:fadeleft(1/32);
				self:faderight(1/32);
				if filter[p] == 'Off' then
					self:diffusealpha(0);
				elseif filter[p] == '25%' then
					self:diffusealpha(0.25);
				elseif filter[p] == '50%' then
					self:diffusealpha(0.5);
				elseif filter[p] == '75%' then
					self:diffusealpha(0.75);
				else
					self:diffusealpha(1);
				end;
				self:visible(0);
				self:queuecommand("Loop");
			end;
			-- [ja] Update関数は重いので0.1秒間隔で監視 
			LoopCommand=function(self)
				self:finishtweening();
				if song then
					local now = GAMESTATE:GetSongBeat();
					if (now >= start-8.0) and (now <= last) then
						if GAMESTATE:IsPlayerEnabled(pn) then
							self:visible(1);
						else
							self:visible(0);
						end;
					else
						self:visible(0);
					end;
				end;
				self:sleep(0.1);
				self:queuecommand("Loop");
			end;
		};
	};
end;

return t;
