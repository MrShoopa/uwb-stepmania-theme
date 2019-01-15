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
		if not filter[p] or filter[p]=="" then filter[p]='Off' end;
	end;
end;

-- [ja] 曲情報は曲が変更されたときに1回更新する
local song;
local start;
local last;
t[#t+1]=Def.ActorFrame{
	ChangedGameplaySongMessageCommand=function(self,params)
		if params.Song then
			song=params.Song
			start = song:GetFirstBeat();
			last = song:GetLastBeat();
		end;
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
				self:visible(false);
			end;
			GameplayTimerMessageCommand=function(self,params)
				if params.Song then
					local beat = params.Beat;
					if (beat >= start-8.0) and (beat <= last) then
						if GAMESTATE:IsPlayerEnabled(pn) then
							self:visible(true);
						else
							self:visible(false);
						end;
					else
						self:visible(0);
					end;
				end;
			end;
		};
	};
end;

return t;
