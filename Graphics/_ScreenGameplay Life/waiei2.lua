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
local col_ln=TC_GetColor("Life Normal") or Color("Blue");
local col_lh=TC_GetColor("Life Hot") or Color("Blue");
local col_ld=TC_GetColor("Life Danger") or Color("Red");
local col_lb=TC_GetColor("Life Bar") or Color("Blue");
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
elseif maxlife>4 then
	mem=8;
	life_type='battery8';
elseif maxlife>0 then
	mem=4;
	life_type='battery4';
else
	mem=20;
	life_type='bar';
end;
local mem_2=mem/2;
local mem_1=1.0/mem;
t[#t+1]=Def.ActorFrame{
--	InitCommand=cmd(rotationy,(pn==PLAYER_1) and 0 or 180;skewx,-1.2;);
	InitCommand=cmd(rotationy,(pn==PLAYER_1) and 0 or 180;);
	OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	LoadActor("lifeframe_underlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(1);
			self:zoomtowidth(lifeWidth-2);
		end;
	};
	LoadActor("lifeframe_underlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(0);
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
		end;
	};
	LoadActor("lifeframe_underlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(2);
			self:horizalign(left);
			self:x((lifeWidth-2)/2);
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
			self:diffuse(0,0,0,0.25);
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:rotationz(180);
			self:x((lifeWidth-2)/2);
			self:diffuse(0,0,0,0.25);
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
			self:diffuseshift();
			self:effectcolor2(col_lb);
			self:effectcolor1(col_lb[1],col_lb[2],col_lb[3],0.25);
			self:effectclock("bgm");
			self:blend("BlendMode_Add");
		end;
		MoveBarCommand=function(self)
			if lmode=='HealthState_Danger' then
				self:effectcolor1(col_ld);
				self:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.25);
			else
				self:effectcolor1(col_lb);
				self:effectcolor2(col_lb[1],col_lb[2],col_lb[3],0.25);
			end;
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:rotationz(180);
			self:x((lifeWidth-2)/2);
			self:diffuseshift();
			self:effectcolor2(col_lb);
			self:effectcolor1(col_lb[1],col_lb[2],col_lb[3],0.25);
			self:effectclock("bgm");
			self:blend("BlendMode_Add");
		end;
		MoveBarCommand=function(self)
			if lmode=='HealthState_Danger' then
				self:effectcolor1(col_ld);
				self:effectcolor2(col_ld[1],col_ld[2],col_ld[3],0.25);
			else
				self:effectcolor1(col_lb);
				self:effectcolor2(col_lb[1],col_lb[2],col_lb[3],0.25);
			end;
		end;
	};
	LoadActor("lifeframe_border_l")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
		end;
	};
	LoadActor("lifeframe_border_l")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:rotationz(180);
			self:x((lifeWidth-2)/2);
		end;
	};
	LoadActor("life in")..{
		InitCommand=function(self)
			self:zoomto(lifeWidth-4,32);
			self:blend("BlendMode_Add");
		end;
		MoveBarCommand=function(self)
			if life>0.0 then
				local p=life;
					self:cropright(1-p);
			else
				self:cropright(1);
			end;
			local beat2 = 0.05*(beat*10%10);
			--[[
			self:cropbottom(0.5-beat2);
			self:croptop(beat2);
			self:y(-beat2*32+8);
			--]]
			self:croptop(0.5-beat2);
			self:cropbottom(beat2);
			self:y(beat2*32-8);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-4,16);
			self:diffuse(0,0.68,0.93,1);
			self:blend("BlendMode_Add");
		end;
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
			self:diffusealpha(0.5);
		--	self:diffusebottomedge(0,0.0,0.0,0.5);
		--	self:fadetop(0.5);
			self:blend("BlendMode_Add");
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-4,2);
			--self:y(-3);
			--self:fadebottom(0.5);
			self:diffuse(1,1,1,0.2);
			self:blend("BlendMode_Add");
		end;
		MoveBarCommand=function(self)
			if life>0.0 then
				local p=life;
				self:cropright(1-p);
			else
				self:cropright(1);
			end;
			--self:y(7.0*(math.cos(beat%1.0*math.pi*2)));
			local beat_=(beat+0.1);
			self:y(8-16.0*(beat_%1.0));
			self:diffusealpha(0.4-(beat_%1.0)*0.4);
		end;
	};
	LoadActor("lifeframe_overlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(1);
			self:zoomtowidth(lifeWidth-4);
			--self:blend("BlendMode_Add");
		end;
	};
	LoadActor("lifeframe_overlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(0);
			self:horizalign(right);
			self:x(-(lifeWidth-4)/2);
			--self:blend("BlendMode_Add");
		end;
	};
	LoadActor("lifeframe_overlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(2);
			self:horizalign(left);
			self:x((lifeWidth-4)/2);
			--self:blend("BlendMode_Add");
		end;
	};
	LoadActor("light center")..{
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
};
if life_type~='bar' then
	for l=1,mem-1 do
		t[#t+1]=LoadActor("life border")..{
			InitCommand=cmd(x,(lifeWidth/mem)*l-lifeWidth/2);
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
				if life_type=='battery8' then
					life_t=life_t*maxlife/8;
				elseif life_type=='battery4' then
					life_t=life_t*maxlife/4;
				end;
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
					life=life+((life_type=='bar') and 0.003 or 0.1);
					if life>life_t then
						life=life_t;
					end;
				else				-- [ja] 減少 
					life=life-((life_type=='bar') and 0.005 or 0.1);
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