local sname = Var "LoadingScreen";
local lifeWidth,haishin,pn=...;
local lifeWidth_2=lifeWidth/2;

local beat=0;
local life=0;
local life_t=0;
local col_l=Color("Blue");
local col_b=Color("Blue");
local col_h=0;
local add_base=tonumber(GetUserPref_Theme("UserAnimationFPS")) or 60;
local bar_up=0.006*60/add_base;
local bar_dw=0.015*60/add_base;
local bat_up=0.1  *60/add_base;
local bat_dw=0.1  *60/add_base;
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

local t=Def.ActorFrame{
	LoadActor("waiei"..TC_GetwaieiMode(),life_type,mem,maxlife,lifeWidth,haishin,pn);
};

t.GameplayTimerMessageCommand=function(self,params)
	local screen=SCREENMAN:GetTopScreen();
	if screen:GetScreenType()=='ScreenType_Gameplay'
		or screen:GetScreenType()=='ScreenType_Attract' then
		local glm=screen:GetLifeMeter(pn);
		if glm then
			life_t=glm:GetLife();
			if maxlife<=0 then
				if glm:IsInDanger() then
					lmode = 'HealthState_Danger';
				elseif glm:IsHot() or life>=1.0 then
					lmode = 'HealthState_Hot';
				elseif glm:IsFailing() then
					lmode = 'HealthState_Dead';
				else
					lmode = 'HealthState_Alive';
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
			if lmode=='HealthState_Danger' then
				col_l = col_ld;
				col_h = 0;
				col_b = col_ld;
			elseif lmode=='HealthState_Hot' then
				col_l = col_lh;
				col_h = params.Sec*100%360;
				col_b = HSV( col_h,1.0,1.0 );
			elseif lmode=='HealthState_Dead' then
				col_l = col_ld;
				col_h = 0;
				col_b = col_ld;
			else
				col_l = col_ln;
				col_h = 0;
				col_b = col_lb;
			end;
		end;
	end;
	if sname==nil or sname=="ScreenHowToPlay" then
		beat=_MUSICSECOND()*75/60;
	elseif pn==PLAYER_1 then
		beat=params.BeatP1;
	else
		beat=params.BeatP2;
	end;
	if life~=life_t then
		if math.abs(life-life_t)<0.0003 then
			life=life_t;
		else
			if life<life_t then	-- [ja] 増加 
				life=life+((life_type=='bar') and bar_up or bat_up);
				if life>life_t then
					life=life_t;
				end;
			else				-- [ja] 減少 
				life=life-((life_type=='bar') and bar_dw or bat_dw);
				if life<life_t then
					life=life_t;
				end;
			end;
		end;
	end;
	MESSAGEMAN:Broadcast("BarTimer",{
		Song      = params.Song,
		Sec       = params.Sec*100%360,
		BeatGlobal= params.Beat,
		Beat      = beat,
		Mode      = lmode,
		Life      = life,
		Player    = pn,
		ColorLight= col_l,
		ColorBar  = col_b,
		ColorHue  = col_h
	});
end;

return t;