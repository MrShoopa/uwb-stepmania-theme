local t=Def.ActorFrame{};-- = LoadFallbackB()
t[#t+1]=EXF_ScreenGameplay();

local customscore=GetCustomScoreMode();
local cscore;
if GetUserPref_Theme("UserCustomScore") ~= nil then
	cscore = GetUserPref_Theme("UserCustomScore");
else
	cscore = 'Off';
end;

local haishin;
if GetUserPref_Theme("UserHaishin") ~= nil then
	haishin = GetUserPref_Theme("UserHaishin");
else
	haishin = 'Off';
end;

t[#t+1]=LoadActor("chg_options");

t[#t+1]=Def.ActorFrame{
	LoadActor("target",PLAYER_1)..{
		InitCommand=cmd(player,PLAYER_1;
			x,GetStepZonePosX(PLAYER_1););
	};
	LoadActor("target",PLAYER_2)..{
		InitCommand=cmd(player,PLAYER_2;
			x,GetStepZonePosX(PLAYER_2););
	};
	LoadActor("cal",PLAYER_1)..{
		InitCommand=cmd(player,PLAYER_1;
			x,SCREEN_LEFT+95;);
	};
	LoadActor("cal",PLAYER_2)..{
		InitCommand=cmd(player,PLAYER_2;
			x,SCREEN_RIGHT-95;);
	};
};
local scoreType=GetUserPref("UserPrefScoringMode");


for pn in ivalues(PlayerNumber) do
	local songMeterDisplay = Def.ActorFrame{
		InitCommand=function(self) 
			self:y(SCREEN_CENTER_Y); 
			self:x((pn==PLAYER_1) and (SCREEN_LEFT+5) or (SCREEN_RIGHT-5));
			self:player(pn); 
			self:rotationz(-90); 
		end;
		Def.Quad {
			InitCommand=cmd(zoomto,THEME:GetMetric("SongMeterDisplay","StreamWidth")+2,12);
			OnCommand=cmd(diffuse,Color("Black");fadetop,0.2;fadebottom,0.2;diffusealpha,0.5);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,THEME:GetMetric("SongMeterDisplay","StreamWidth"),4);
			OnCommand=cmd(diffuse,color("#C0C0C0");diffusealpha,0.5);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,THEME:GetMetric("SongMeterDisplay","StreamWidth")-2,2);
			OnCommand=cmd(diffuse,Color("White");diffusealpha,0.5);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
		LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'Container ' .. PlayerNumberToString(pn) ) ) .. {
			OnCommand=cmd(diffusealpha,1);
			OffCommand=cmd(linear,0.5;zoomy,0);
		};
	};
	t[#t+1] = songMeterDisplay
end;


t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");

if not GAMESTATE:IsCourseMode() then
local stepcnt={0,0}
t[#t+1] = Def.Actor{
	JudgmentMessageCommand = function(self, params)
		if params.TapNoteScore and
		   params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
		   params.TapNoteScore ~= 'TapNoteScore_HitMine' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointMiss' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointHit' and
		   params.TapNoteScore ~= 'TapNoteScore_None'
		then
			if customscore=="old" then
				Scoring[scoreType](params, 
					STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player))
			elseif customscore=="5b2" then
				local pn=((params.Player==PLAYER_1) and 1 or 2);
				stepcnt[pn]=stepcnt[pn]+1;
				CustomScore_SM5b2(params,cscore,GAMESTATE:GetCurrentSteps(params.Player),stepcnt[pn]);
			elseif customscore=="5b1" then
				local pn=((params.Player==PLAYER_1) and 1 or 2);
				stepcnt[pn]=stepcnt[pn]+1;
				CustomScore_SM5b1(params,cscore,GAMESTATE:GetCurrentSteps(params.Player),stepcnt[pn]);
			else
				local pn=((params.Player==PLAYER_1) and 1 or 2);
				stepcnt[pn]=stepcnt[pn]+1;
				CustomScore_SM5a2(params,cscore,GAMESTATE:GetCurrentSteps(params.Player),stepcnt[pn]);
			end;
		end
	end;
	InitCommand=function(self)
		if customscore=="non" then
			CustomScore_SM5a2_Init();
		end;
	end;
	OffCommand=function(self)
		if customscore=="non" then
			CustomScore_SM5a2_Out();
		end;
	end;
};
end;
if GetSMVersion()>50 then
	t[#t+1]=use_newfield_actor(tonumber(THEME:GetMetric('Player','ReceptorArrowsYStandard'))*(-1));
end;

return t;
