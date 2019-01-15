local pn=...;
local p=(pn==PLAYER_1) and 1 or 2;
local t=Def.ActorFrame{};
-- [ja] カロリー
local cal='Off';
if GAMESTATE:IsPlayerEnabled(pn) then
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
	cal=GetUserPref_Theme("UserShowCalories"..nm);
	if not cal then cal='Off' end;
end;
local cal_prof;
local cal_cur=0.0;
local cal_old=-1.0;
local cal_total=0.0;
if cal=='On' then
	t[#t+1]=Def.ActorFrame{
		LoadFont("Common Normal")..{
			CodeMessageCommand=function(self,params)
				if not getenv("Drill") or getenv("DrillRealTimeOpt") then
					if params.PlayerNumber==pn then
						if params.Name == "ScrollNomal" then
							self:y(SCREEN_BOTTOM-100);
						elseif params.Name=="ScrollReverse" then
							self:y(SCREEN_TOP+100);
						end;
					end;
				end;
			end;
			InitCommand=function(self)
				self:player(pn);
				self:diffuse(PlayerColor(pn));
				self:strokecolor(0,0,0,1);
				if IsReverse(pn) then
					self:y(SCREEN_TOP+100);
				else
					self:y(SCREEN_BOTTOM-100);
				end;
				setenv("cal"..p,0);
			end;
			OnCommand=function(self)
				local pro;
				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					cal_prof=PROFILEMAN:GetProfile(pn);
				else
					-- machine profile
					cal_prof=PROFILEMAN:GetMachineProfile();
				end;
				cal_total=cal_prof:GetCaloriesBurnedToday();
				cal_old=cal_cur;
				self:queuecommand("Cal");
			end;
			CalCommand=function(self)
				self:finishtweening();
				self:settextf("%.2f kcal\n%.2f kcal", cal_cur, cal_total+cal_cur);
				self:zoom(1.5);
				self:diffusealpha(0.5);
				self:linear(0.02);
				self:zoom(0.9);
				self:diffusealpha(1);
			end;
		};
	};
end;
oTime=0;
nTime=0;
wait=1.0/30;
local function update(self,dt)
	nTime=nTime+dt;
	if nTime-oTime>=wait then
		oTime=nTime;
		cal_cur=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetCaloriesBurned();
		if cal_old~=cal_cur then
			self:queuecommand("Cal");
			cal_old=cal_cur;
			setenv("cal"..p,cal_cur);
		end;
	end;
end;
t.InitCommand=cmd(SetUpdateFunction,update);
return t;