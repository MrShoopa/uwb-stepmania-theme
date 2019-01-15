local t = Def.ActorFrame {FOV=60;};
t[#t+1]=EXF_ScreenStageInformation();

local tcol=GetUserPref_Theme("UserColorPath");
local haishin=GetUserPref_Theme("UserHaishin");

local playMode = GAMESTATE:GetPlayMode()
if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
	curStage = playMode;
end;
local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

-- [ja] 歌詞の隠し機能を初期化（この画面で↑↑←→↓と入力） 
Setwaiei("LyricEgg",false);

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif GAMESTATE:IsCourseMode() then
	local course=GAMESTATE:GetCurrentCourse();
	if course:IsNonstop() then
		sStage = "Stage_Nonstop";
	elseif course:IsOni() then
		sStage = "Stage_Oni";
	elseif course:IsEndless() then
		sStage = "Stage_Endless";
	else
		sStage = sStage;
	end;
else
	sStage = sStage;
end;

if GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("CourseDisplay");
end;

t[#t+1] = LoadActor("songinfo");	-- [ja] 楽曲タイトル表記
t[#t+1] = LoadActor("script");

local ano_stage={
	Stage_1st="1",
	Stage_2nd="2",
	Stage_3rd="3",
	Stage_4th="4",
	Stage_5th="5",
	Stage_6th="6",
	Stage_Final="final",
	Stage_Extra1="extra1",
	Stage_Extra2="extra2",
	Stage_Nonstop="1",
	Stage_Oni="oni",
	Stage_Endless="endless",
	Stage_Event="event",
};

-- [ja] ステージアナウンサー処理とステージ数テキストファイル名の取得
local stagetext_file = '';
if not IsDrill() then
	stagetext_file = THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage) );
	t[#t+1] = Def.Actor {
		OnCommand=function(self)
			SOUND:PlayAnnouncer("stage " .. ano_stage[sStage]);
		end;
	};
else
	local stage_cnt={"1st","2nd","3rd","4th","5th","6th","extra1","final"};
	local ano_stage_drill={"1","2","3","4","5","6","7"};
	local stcnt=1;
	if GetDrillStage()>=GetDrillMaxStage() then
		stcnt=8;
	else
		stcnt=math.min(GetDrillStage(),7)
	end;
	stagetext_file = THEME:GetPathG("ScreenStageInformation", "Stage " .. stage_cnt[stcnt] );
	t[#t+1] = Def.Actor {
		OnCommand=function(self)
			if math.min(GetDrillStage(),7)<=#ano_stage_drill then
				SOUND:PlayAnnouncer("stage " .. ano_stage_drill[math.min(GetDrillStage(),7)]);
			end;
		end;
		
	};
end;
t[#t+1] = LoadActor("stagetext",stagetext_file);	-- [ja] XX STAGE表記

t[#t+1] = Def.ActorFrame {
	Lyric_Egg_S();	-- [ja] 歌詞ファイル読み込み処理
	Def.Actor{
		InitCommand=function(self)
			EnableUltimate(true);
			SetUltimateLife(false);
			EXF_ScreenStageInformation_Init();
		end;
		CodeCommand=function(self,params)
			if not IsDrill() and not IsEXFolder()
				and not GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2() then
				if params.Name=="UltimateLife" and not IsUltimateLife() then
					SetUltimateLife(true);
				end;
			end;
		end;
	};
};

return t