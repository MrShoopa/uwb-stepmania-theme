local sname = Var "LoadingScreen";
local lifeWidth,haishin,pn=...;
local lifeWidth_2=lifeWidth/2;
--local pn=PLAYER_1;
local t=Def.ActorFrame{};

local beat=0;
local msec=0;
local life=0;
local life_t=0;
local lmode='HealthState_Alive';
local col_ln=TC_GetColor("Life Normal");
local col_lh=TC_GetColor("Life Hot");
local col_ld=TC_GetColor("Life Danger");
local col_lb=TC_GetColor("Life Bar");
if IsEXFolder() then
	if GetEXFLife()=="MFC" then
		col_ld=GameColor.Judgment["JudgmentLine_W1"];
	elseif GetEXFLife()=="PFC" then
		--col_ld=GameColor.Judgment["JudgmentLine_W2"];
		col_ld=Color("Yellow");	-- [ja] 色が薄くて分かりにくかったので変更 
	end;
elseif IsDrill() then
	if GetDrillLife()=="MFC" then
		col_ld=GameColor.Judgment["JudgmentLine_W1"];
	elseif GetDrillLife()=="PFC" then
		--col_ld=GameColor.Judgment["JudgmentLine_W2"];
		col_ld=Color("Yellow");	-- [ja] 色が薄くて分かりにくかったので変更 
	end;
end;
local maxlife=0;
if GetSMVersion()<=30 then
	local songoptions=GAMESTATE:GetSongOptionsString();
	local l_songoptions=string.lower(songoptions);
	local isbattery_s;
	local isbattery_e;
	isbattery_s,isbattery_e=string.find(l_songoptions,"%d+lives");
	if isbattery_s then
		maxlife=tonumber(string.sub(l_songoptions,isbattery_s,isbattery_e-5));
	else
		maxlife=0;
	end;
else
	local ps=GAMESTATE:GetPlayerState(pn);
	if ps then
		local po=ps:GetPlayerOptions('ModsLevel_Preferred');
		if po:LifeSetting()=='LifeType_Battery' then
			maxlife=po:BatteryLives();
		end;
	end;
end;
local life_type='Normal';
local mem=20;
if maxlife>8 then
	mem=20;
	life_type='bar';
elseif maxlife>0 then
	mem=maxlife;
	life_type='battery';
else
	mem=20;
	life_type='bar';
end;
local mem_2=mem/2;
local mem_1=1.0/mem;
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(rotationy,(pn==PLAYER_1) and 0 or 180);
	OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;addx,(pn==PLAYER_1) and -100 or 100;diffusealpha,0);
	LoadActor(TC_GetPath("Life","life left"))..{
		OnCommand=cmd(x,-lifeWidth_2-12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	};
	LoadActor(TC_GetPath("Life","life right"))..{
		OnCommand=cmd(x,lifeWidth_2+12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	};
	LoadActor(TC_GetPath("Life","life center"))..{
		OnCommand=cmd(zoomtowidth,lifeWidth;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	};
	LoadActor(TC_GetPath("Life","light left"))..{
		OnCommand=function(self)
			(cmd(x,-lifeWidth_2-12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1;blend,"BlendMode_Add";))(self);
			if haishin=="Off" then
				(cmd(diffuseramp;effectcolor1,0,0.68,0.93,0.8;effectcolor2,0,0.68,0.93,0.3;effectclock,'beat';))(self);
			else
				self:diffuse(0,0.68,0.93,0.8);
			end;
		end;
		MoveBarCommand=function(self)
			if lmode=='HealthState_Danger' then
				self:effectcolor1(col_ld[1],col_ld[2],col_ld[3],0.8);
				self:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.3);
			elseif lmode=='HealthState_Dead' then
				self:effectcolor1(col_ld[1],col_ld[2],col_ld[3],0.8);
				self:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.3);
			elseif lmode=='HealthState_Hot' then
				self:effectcolor1(col_lh[1],col_lh[2],col_lh[3],0.8);
				self:effectcolor2(col_lh[1],col_lh[2],col_lh[3],0.3);
			else
				self:effectcolor1(col_ln[1],col_ln[2],col_ln[3],0.8);
				self:effectcolor2(col_ln[1],col_ln[2],col_ln[3],0.3);
			end;
		end;
	};
	LoadActor(TC_GetPath("Life","light right"))..{
		OnCommand=function(self)
			(cmd(x,lifeWidth_2+12;diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1;blend,"BlendMode_Add";))(self);
			if haishin=="Off" then
				(cmd(diffuseramp;effectcolor1,0,0.68,0.93,0.8;effectcolor2,0,0.68,0.93,0.3;effectclock,'beat';))(self);
			else
				self:diffuse(0,0.68,0.93,0.8);
			end;
		end;
		MoveBarCommand=function(self)
			if lmode=='HealthState_Danger' then
				self:effectcolor1(col_ld[1],col_ld[2],col_ld[3],0.8);
				self:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.3);
			elseif lmode=='HealthState_Dead' then
				self:effectcolor1(col_ld[1],col_ld[2],col_ld[3],0.8);
				self:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.3);
			elseif lmode=='HealthState_Hot' then
				self:effectcolor1(col_lh[1],col_lh[2],col_lh[3],0.8);
				self:effectcolor2(col_lh[1],col_lh[2],col_lh[3],0.3);
			else
				self:effectcolor1(col_ln[1],col_ln[2],col_ln[3],0.8);
				self:effectcolor2(col_ln[1],col_ln[2],col_ln[3],0.3);
			end;
		end;
	};
	LoadActor(TC_GetPath("Life","light center"))..{
		InitCommand=cmd(zoomtowidth,lifeWidth*2;blend,"BlendMode_Add");
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		MoveBarCommand=function(self)
			local beat2 = 0.1*(beat*10%20);
			self:cropleft(0.5-(beat2/4));
			self:cropright(beat2/4);
			self:x((beat2/4)*(lifeWidth*2)-lifeWidth_2);
			if lmode=='HealthState_Danger' then
				self:diffuse(col_ld);
			elseif lmode=='HealthState_Dead' then
				self:diffuse(col_ld);
			elseif lmode=='HealthState_Hot' then
				self:diffuse(ColorLightTone(HSV( msec,1.0,1.0 )));
			else
				self:diffuse(col_lb);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-2,18);
			self:diffuse(0,0.68,0.93,1);
			self:blend("BlendMode_Add");
		end;
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		MoveBarCommand=function(self)
			if lmode=='HealthState_Danger' then
				self:diffuse(col_ld);
			elseif lmode=='HealthState_Dead' then
				self:diffuse(col_ld);
			elseif lmode=='HealthState_Hot' then
				local beat1 = 0.1*(beat*10%10);
				self:diffuse(HSV((msec+350)%360,1.0,1.0-(beat1/2)));
			else
				self:diffuse(col_lb);
			end;
			if life>0.0 then
				local p=life;
					self:cropright(1-p);
			else
				self:cropright(1);
			end;
			self:diffusetopedge(0,0.15,0.3,0.5);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-2,8);
			self:y(-3);
			self:diffuse(0.8,0.8,0.8,0.5);
			self:diffusebottomedge(0.2,0.2,0.2,0);
			self:blend("BlendMode_Add");
		end;
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		MoveBarCommand=function(self)
			if life>0.0 then
				local p=life;
				self:cropright(1-p);
			else
				self:cropright(1);
			end;
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,lifeWidth-2,18;horizalign,left;x,-lifeWidth/2+1;
			diffuse,0,0,0,0;diffuseleftedge,0.0,0.0,0.0,0.3;);
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffuseleftedge,0.0,0.0,0.0,0.3;);
		MoveBarCommand=function(self)
			if life>=1.0 then
				self:zoomtowidth((lifeWidth-2));
				self:diffuseleftedge(0,0,0,0.2);
			elseif life>0.0 then
				local p=life;
				self:zoomtowidth((lifeWidth-2)*p);
				self:diffuseleftedge(0,0,0,0.3);
			else
				self:zoomtowidth(0);
			end;
		end;
	};
};
if maxlife>1 then
	for l=1,maxlife-1 do
		t[#t+1]=LoadActor(TC_GetPath("Life","life border"))..{
			InitCommand=cmd(x,(lifeWidth/maxlife)*l-lifeWidth/2);
			OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		};
	end;
end;

local oTime=0;
local nTime=0;
local count=0;
local wait=1.0/60;
local function update(self,dt)
	nTime=nTime+dt;
	-- [ja] 1回分の処理 
	if nTime-oTime>wait then
		oTime=oTime+wait;
		local screen=SCREENMAN:GetTopScreen();
		if screen:GetScreenType()=='ScreenType_Gameplay'
			or screen:GetScreenType()=='ScreenType_Attract' then
			local glm=screen:GetLifeMeter(pn);
			if glm then
				life_t=glm:GetLife();
				--[[
				if life_type=='battery' then
					life_t=life_t*maxlife/8;
				elseif life_type=='battery4' then
					life_t=life_t*maxlife/4;
				end;
				--]]
				if maxlife<=0 then
					if glm:IsInDanger() then
						lmode='HealthState_Danger';
					elseif glm:IsHot() or life>=1.0 then
						lmode='HealthState_Hot';
					elseif glm:IsFailing() then
						lmode='HealthState_Dead';
					else
						lmode='HealthState_Alive';
					end;
				else
					if glm:GetLivesLeft()==1 then
						lmode='HealthState_Danger';
					elseif glm:GetLivesLeft()==glm:GetTotalLives() then
						lmode='HealthState_Hot';
					elseif glm:GetLivesLeft()<1 then
						lmode='HealthState_Dead';
					else
						lmode='HealthState_Alive';
					end;
				end;
			end;
		end;
		if sname=="ScreenHowToPlay" then
			beat=_MUSICSECOND()*75/60;
		else
			beat=GetPlayerSongBeat(pn);
		end;
		msec = _MUSICSECOND()*100%360;
		if life~=life_t then
			if math.abs(life-life_t)<0.0003 then
				life=life_t;
			else
				if life<life_t then	-- [ja] 増加 
					life=life+((life_type=='bar') and 0.003 or 1.0);
					if life>life_t then
						life=life_t;
					end;
				else				-- [ja] 減少 
					life=life-((life_type=='bar') and 0.005 or 1.0);
					if life<life_t then
						life=life_t;
					end;
				end;
			end;
		end;
		self:queuecommand("MoveBar");
	end;
end;
t.InitCommand=cmd(SetUpdateFunction,update);

return t;