--[[ [ja] ドリルモード実装方法 
必要ファイルは以下の通りです
91 Drill.lua 		本体 
91 Life.lua			ライフ設定 
100 StepMania.lua	StepMania本体のバージョン判定 
90 waieiPrefs.lua 	オプションリストの設定（List_XXX関数） 
91 Code.lua		ドリルモードのキー操作定義（DrillXXX関数） 
99 FileRW.lua		iniファイルの読み取り 
まだあったかも・・・ 
下2つのファイルは必要関数だけ取り出して別ファイルに書いたほうがいいかも 

Metrics.iniにも結構変更点があります 
「Drill」で片っ端から検索してそれに該当する場所を書き直せば自作テーマでも実装可能なはず 
ライフ関連は [LifeMeterBar] の修正が必須 
あとは [ScreenPlayerOptions] の LineNames と [ScreenDrillOptions] 

Languageにもドリル専用の項目があるので追加してください 

Soundsフォルダに下記ファイル追加
_DrillCategory music.redir
_DrillDifficulty music.redir
_music drill (loop).ogg

ゲーム中倍速変更等のオプションやリザルトの消費カロリーの数値を渡すところは 
スクリプトファイルを見てうまいことやってください（なげやり） 

その他
90 waieiBranches.lua でドリルモード時はSongOptionsに入られないように設定しています 
スコアの保存場所は Save/プロファイル（/番号）/Drills にあります 
アナウンサーに以下のファイルを入れておくことでしゃべってくれます 
・ドリルカテゴリー選択画面突入時
	-waiei ScreenSelectDrillCategory Intro
・ドリルカテゴリー決定時 
	-waiei ScreenSelectDrillCategory comment
・ドリルレベル選択画面突入時
	-waiei ScreenSelectDrillDifficulty Intro
・ドリルレベル決定時 
	-waiei ScreenSelectDrillDifficulty comment
※ - も必須です 
画像は Graphics の _Drills フォルダと _GradeDisplay Normal フォルダを 
うまいこと使ってください 

別途下記ファイルに関数を書いておく必要があります 
ScreenTitleMenu overlay	 → DrillOptionsReset_inTitle();
ScreenSelectMusic in	 → DrillSelectMusic_in();
ScreenGameplay overlay	 → DrillGameplay()();
ScreenEvaluation in		 → DrillEvaluation_in();
]]--


__DRILL__ = true;

-- [ja] Drillモード 
local drill=false;
function IsDrill()
	return drill;
end;
function DrillStart()
	drill=true;
end;
function DrillEnd()
	drill=false;
end;

-- [ja] プレイヤー 
local drillPlayer=nil;
function SetDrillPlayer(pn)
	drillPlayer=pn;
end;
function GetDrillPlayer()
	return drillPlayer;
end;

-- [ja] プロファイルのディレクトリ 
local drillProfileDir="";
function SetDrillPlayerProfileDir(dir)
	drillProfileDir=dir;
end;
function GetDrillPlayerProfileDir()
	return drillProfileDir;
end;

-- [ja] ドリルカテゴリーの番号 
local drillSelCategory=1;
function SetSelDrillCategory(i)
	drillSelCategory=i;
end;
local function SetSelDrillCategory_Area(i)
	SetSelDrillCategory(GetSelDrillCategory_Area(i));
end;
function SetSelDrillCategoryA(i)
	SetSelDrillCategory_Area(i);
end;
function SetSelDrillCategoryR(i)
	SetSelDrillCategory_Area(GetSelDrillCategory()+i);
end;
function GetSelDrillCategory()
	return drillSelCategory;
end;
function GetSelDrillCategory_Area(i)
	if CntDRFile()>0 then
		if i>CntDRFile() then
			i=((i-1)%CntDRFile())+1;
		else
			while(i<1) do
				i=i+CntDRFile();
			end;
		end;
	end;
	return i;
end;

-- [ja] ドリルレベルの番号 
local drillSelLevel=1;
function SetSelDrillLevel(i)
	drillSelLevel=i;
end;
local function SetSelDrillLevel_Area(i)
	SetSelDrillLevel(GetSelDrillLevel_Area(i));
end;
function SetSelDrillLevelA(i)
	SetSelDrillLevel_Area(i);
end;
function SetSelDrillLevelR(i)
	SetSelDrillLevel_Area(GetSelDrillLevel()+i);
end;
function GetSelDrillLevel()
	return drillSelLevel;
end;
function GetSelDrillLevel_Area(i)
	if CntLVInfo()>0 then
		if i>CntLVInfo() then
			i=((i-1)%CntLVInfo())+1;
		else
			while(i<1) do
				i=i+CntLVInfo();
			end;
		end;
	end;
	return i;
end;

-- [ja] ドリルリザルトの番号 
local drillSelResult=1;
function SetSelDrillResult(i)
	drillSelResult=i;
end;
local function SetSelDrillResult_Area(i)
	SetSelDrillResult(GetSelDrillResult_Area(i));
end;
function SetSelDrillResultA(i)
	SetSelDrillResult_Area(i);
end;
function SetSelDrillResultR(i)
	SetSelDrillResult_Area(GetSelDrillResult()+i);
end;
function GetSelDrillResult()
	return drillSelResult;
end;
function GetSelDrillResult_Area(i)
	if GetDrillMaxStage()>0 then
		if i>GetDrillMaxStage() then
			i=((i-1)%GetDrillMaxStage());	-- [ja] 0があるので+1は不要 
		else
			while(i<0) do
				i=i+(GetDrillMaxStage()+1);
			end;
		end;
	end;
	return i;
end;

-- [ja] Failed状態 
local drillFailed=false;
function SetDrillFailed(failed)
	drillFailed=failed;
end;
function GetDrillFailed()
	return drillFailed;
end;
function IsDrillFailed()
	return GetDrillFailed();
end;

-- [ja] ドリル時のライフ 
local drillLife=""
function SetDrillLife(life)
	drillLife=life;
end;
function GetDrillLife()
	return drillLife;
end;

-- [ja] ライフ残量 
local drillLifeRemaining=nil;
function SetDrillLifeRemaining(f)
	drillLifeRemaining=f;
end;
function GetDrillLifeRemaining()
	return drillLifeRemaining;
end;

-- [ja] ライフ回復量 
local drillLifeRecovery=0;
function SetDrillLifeRecovery(f)
	drillLifeRecovery=f;
end;
function GetDrillLifeRecovery()
	return drillLifeRecovery;
end;

-- [ja] 状態 ※D3テーマではDrillChkに相当 
local drillState="";
function SetDrillState(state)
	drillState=state;
end;
function GetDrillState()
	return drillState;
end;

-- [ja] 現在のステージ 
local drillStage=0;
function SetDrillStage(stage)
	drillStage=stage;
end;
function GetDrillStage()
	return drillStage;
end;

-- [ja] 最大ステージ 
local drillMaxStage=1;
function SetDrillMaxStage(stage)
	drillMaxStage=stage;
end;
function GetDrillMaxStage()
	return drillMaxStage;
end;

-- [ja] リアルタイムオプション変更の許可 
local drillRealTimeOpt=false;
function SetDrillRealTimeOpt(b)
	drillRealTimeOpt=b;
end;
function GetDrillRealTimeOpt()
	return drillRealTimeOpt;
end;

-- [ja] ライフの状態 どこで使っている？ 
local drillLifeStats={};
function SetDrillLifeStats(ls)
	drillLifeStats=ls;
end;
function GetDrillLifeStats()
	return drillLifeStats;
end;

-- [ja] ライフの最大値 
local drillMaxLife=0;
function SetDrillMaxLife(i)
	drillMaxLife=i;
end;
function GetDrillMaxLife()
	return drillMaxLife;
end;

-- [ja] スコア 
local drillScoreArray={};
function SetDrillScoreArray(val)
	drillScoreArray=val;
end;
function GetDrillScoreArray()
	return drillScoreArray;
end;

function GetDrillScore(prm,stage)
	if stage and stage>0 then
		return drillScoreArray["Drill_"..prm.."-"..stage];
	else
		return drillScoreArray["Drill_"..prm];
	end;
end;

-- [ja] ドリルファイルの情報 
local drFile={};
function InitDRFile()
	drFile={};
end;
function SetDRFile(cnt,prm)
	drFile[cnt]=prm;
end;
function GetDRFile(cnt)
	return drFile[cnt];
end;
function CntDRFile()
	return #drFile;
end;

-- [ja] ドリルカテゴリーの情報 
local drInfo={};
function InitDRInfo()
	drInfo={};
end;
function SetDRInfo(val,prm)
	drInfo[val]=prm;
end;
function RepDRInfo(tbl)	--[ja] 置き換え（テーブルそのものを変更） 
	drInfo=tbl;
end;
function GetDRInfo(val)
	return drInfo[val];
end;

-- [ja] ドリルレベルの情報 
local lvInfo={};
function InitLVInfo()
	lvInfo={};
end;
function SetLVInfo(val,prm)
	lvInfo[val]=prm;
end;
function GetLVInfo(val)
	return lvInfo[val];
end;
function CntLVInfo()
	return GetDRInfo("Level");
end;

-- [ja] ドリルレベルのスコア 
local lvScore={};
function InitLVScore()
	lvScore={};
end;
function SetLVScore(val,prm)
	lvScore[val]=prm;
end;
function GetLVScore(val)
	return lvScore[val];
end;


function InitDrillCategory()
	if GAMESTATE:GetNumPlayersEnabled()<=1 then
		InitDRFile();
		InitDRInfo();
		DrillStart();
	--	setenv("EventMode",GAMESTATE:IsEventMode());
		SetUserPref_Theme("DrillEventMode",GAMESTATE:IsEventMode());
		GAMESTATE:SetTemporaryEventMode(true);
		SetDrillPlayer((GAMESTATE:IsHumanPlayer(PLAYER_1)) and PLAYER_1 or PLAYER_2);
		local drFolder=FILEMAN:GetDirListing("./Drills/",true,true);

		local drCnt=0;

		for df=1,#drFolder do
			local crsList=FILEMAN:GetDirListing(drFolder[df].."/",false,true);
			for crs=1,#crsList do
				if string.find(string.lower(crsList[crs]),".*%.crs$") then
					--[[
					local tmp=split("/",drFolder[df]);
					drFolder[df]=tmp[#tmp];
					--]]
					local tmp=split("/",crsList[crs]);
					crsList[crs]=tmp[#tmp];
					local drData=GetTextBlock(drFolder[df].."/"..crsList[crs],"main");
					if string.find(string.lower(GAMESTATE:GetCurrentStyle():GetStepsType()),
						"^.*_"..string.lower(GetCRSPrm(drData,"PLAYSTYLE")).."$") then
						drCnt=drCnt+1;
						SetDRFile(drCnt,drFolder[df].."/"..crsList[crs]);
						SetDRInfo(""..GetDRFile(drCnt).."-Path",drFolder[df]);
						SetDRInfo(""..GetDRFile(drCnt).."-File",drFolder[df].."/"..crsList[crs]);
						local tmp=split("/",drFolder[df].."/"..crsList[crs]);
						SetDRInfo(""..GetDRFile(drCnt).."-File",tmp[#tmp-1].."_"..tmp[#tmp]);
						SetDRInfo(""..GetDRFile(drCnt).."-Title",GetCRSPrm(drData,"DRILL"));
						SetDRInfo(""..GetDRFile(drCnt).."-Color",GetCRSPrm(drData,"MENUCOLOR"));
						SetDRInfo(""..GetDRFile(drCnt).."-Ctrl",GetCRSPrm(drData,"CONTROLLER"));
						SetDRInfo(""..GetDRFile(drCnt).."-Style",string.lower(GetCRSPrm(drData,"PLAYSTYLE")));
						SetDRInfo(""..GetDRFile(drCnt).."-Life",string.lower(GetCRSPrm(drData,"LIFEMETER")));
						SetDRInfo(""..GetDRFile(drCnt).."-LDif",GetCRSPrm(drData,"LIFEDIFFICULTY"));
						SetDRInfo(""..GetDRFile(drCnt).."-TDif",GetCRSPrm(drData,"TIMINGDIFFICULTY"));
						SetDRInfo(""..GetDRFile(drCnt).."-Recovery",GetCRSPrm(drData,"RECOVERY"));
						SetDRInfo(""..GetDRFile(drCnt).."-SOpt",GetCRSPrm(drData,"STATICOPTIONS"));
						if GetDRInfo(""..GetDRFile(drCnt).."-SOpt")=="" then
							SetDRInfo(""..GetDRFile(drCnt).."-SOpt",GetCRSPrm(drData,"PLAYEROPTIONS"));
						end;
						SetDRInfo(""..GetDRFile(drCnt).."-SOpt",string.lower(GetDRInfo(""..GetDRFile(drCnt).."-SOpt")));
						SetDRInfo(""..GetDRFile(drCnt).."-ROpt",GetCRSPrm(drData,"REALTIMEOPTIONS"));
						if GetDRInfo(""..GetDRFile(drCnt).."-ROpt")=="" then
							SetDRInfo(""..GetDRFile(drCnt).."-ROpt",GetCRSPrm(drData,"GAMEPLAYOPTIONS"));
						end;
						SetDRInfo(""..GetDRFile(drCnt).."-ROpt",string.lower(GetDRInfo(""..GetDRFile(drCnt).."-ROpt")));
						SetDRInfo(""..GetDRFile(drCnt).."-Banner",drFolder[df].."/"..GetCRSPrm(drData,"BANNER"));
						if GetCRSPrm(drData,"BANNER")=="" or not FILEMAN:DoesFileExist(GetDRInfo(""..GetDRFile(drCnt).."-Banner")) then
							SetDRInfo(""..GetDRFile(drCnt).."-Banner",THEME:GetPathG("Common fallback","banner"));
						end;
						SetDRInfo(""..GetDRFile(drCnt).."-Jacket",drFolder[df].."/"..GetCRSPrm(drData,"JACKET"));
						if GetCRSPrm(drData,"JACKET")=="" or not FILEMAN:DoesFileExist(GetDRInfo(""..GetDRFile(drCnt).."-Jacket")) then
							SetDRInfo(""..GetDRFile(drCnt).."-Jacket",THEME:GetPathG("Common fallback","jacket"));
						end;
						SetDRInfo(""..GetDRFile(drCnt).."-Border",GetCRSPrm(drData,"CLEARBORDER"));
						SetDRInfo(""..GetDRFile(drCnt).."-Background",GetCRSPrm(drData,"BACKGROUND"));
						SetDRInfo(""..GetDRFile(drCnt).."-Bgm",GetCRSPrm(drData,"BGM"));
						SetDRInfo(""..GetDRFile(drCnt).."-ResultBackground",GetCRSPrm(drData,"RESULTBACKGROUND"));
						if GetDRInfo(""..GetDRFile(drCnt).."-ResultBackground")=="" then
							SetDRInfo(""..GetDRFile(drCnt).."-ResultBackground",GetCRSPrm(drData,"RESULTBG"));
						end;
						-- [ja] BGMと背景はファイル名だけで登録し、空白文字でなければディレクトリを追加する 
						if GetDRInfo(""..GetDRFile(drCnt).."-Background")~="" then
							SetDRInfo(""..GetDRFile(drCnt).."-Background",drFolder[df].."/"..GetDRInfo(""..GetDRFile(drCnt).."-Background"));
						end;
						if GetDRInfo(""..GetDRFile(drCnt).."-Bgm")~="" then
							SetDRInfo(""..GetDRFile(drCnt).."-Bgm",drFolder[df].."/"..GetDRInfo(""..GetDRFile(drCnt).."-Bgm"));
						end;
						if GetDRInfo(""..GetDRFile(drCnt).."-ResultBackground")~="" then
							SetDRInfo(""..GetDRFile(drCnt).."-ResultBackground",drFolder[df].."/"..GetDRInfo(""..GetDRFile(drCnt).."-ResultBackground"));
						end;
						-- [ja] 空白文字だと困るパラメータの定義 
						if GetDRInfo(""..GetDRFile(drCnt).."-Color")=="" then
							SetDRInfo(""..GetDRFile(drCnt).."-Color","0.92,0.11,0.47,1.0");
						end;
						if GetDRInfo(""..GetDRFile(drCnt).."-LDif")=="" then
							SetDRInfo(""..GetDRFile(drCnt).."-LDif","1.0");
						end;
						if GetDRInfo(""..GetDRFile(drCnt).."-TDif")=="" then
							SetDRInfo(""..GetDRFile(drCnt).."-TDif","1.0");
						end;
						if not tonumber(GetDRInfo(""..GetDRFile(drCnt).."-Recovery")) then
							SetDRInfo(""..GetDRFile(drCnt).."-Recovery","0.0");
						end;
						if not tonumber(GetDRInfo(""..GetDRFile(drCnt).."-Border")) then
							SetDRInfo(""..GetDRFile(drCnt).."-Border","0.0");
						end;
					end;
				end;
			end;
		end;

		if GetUserPref_Theme("DrillOldLLevel") and GetUserPref_Theme("DrillOldLLevel")~="" then
			PREFSMAN:SetPreference("LifeDifficultyScale",GetUserPref_Theme("DrillOldLLevel"));
		end;
		if GetUserPref_Theme("DrillOldTLevel") and GetUserPref_Theme("DrillOldTLevel")~="" then
			PREFSMAN:SetPreference("TimingWindowScale",GetUserPref_Theme("DrillOldTLevel"));
		end;
		if GetUserPref_Theme("DrillOldW1") and GetUserPref_Theme("DrillOldTLevel")~="" then
			PREFSMAN:SetPreference("AllowW1",GetUserPref_Theme("DrillOldW1"));
		end;
		SetUserPref_Theme("DrillOldLLevel",PREFSMAN:GetPreference("LifeDifficultyScale"));
		SetUserPref_Theme("DrillOldTLevel",PREFSMAN:GetPreference("TimingWindowScale"));
		SetUserPref_Theme("DrillOldW1",PREFSMAN:GetPreference("AllowW1"));
	--	setenv("DrillOldLLevel",PREFSMAN:GetPreference("LifeDifficultyScale"));
	--	setenv("DrillOldTLevel",PREFSMAN:GetPreference("AllowW1"));
	--	setenv("DrillOldW1",PREFSMAN:GetPreference("AllowW1"));
		PREFSMAN:SetPreference("AllowW1","AllowW1_Everywhere");
		local pdir=PROFILEMAN:GetProfileDir('ProfileSlot_Player1');
		if pdir=="" then
			pdir=PROFILEMAN:GetProfileDir('ProfileSlot_Machine');
		end;
		
		SetDrillPlayerProfileDir(pdir);
		
		local DrillPrfClear={};
		for i=1,drCnt do
		-- [ja] スコアの読み込み 
			drMax=1;
			while(true) do
				local drlData=GetTextBlock(GetDRFile(i),"level"..drMax);
				if #drlData==0 then
					break;
				end;
				drMax=drMax+1;
			end;
			SetDRInfo(""..GetDRFile(i).."-ClearLevel",0);
			SetDRInfo(""..GetDRFile(i).."-ClearName","NO DATA");
			for j=1,drMax do
				local drpData=GetTextBlock(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo(""..GetDRFile(i).."-File").."/Level"..j..".sav","main");
				local drpClear=GetCRSPrm(drpData,"clear");
				if drpClear~="" and drpClear~="0" and j>GetDRInfo(""..GetDRFile(i).."-ClearLevel") then
					local drpCombo=tonumber(GetCRSPrm(drpData,"combo"));
					local drpDP=math.floor(tonumber(GetCRSPrm(drpData,"dancepoints"))*100);
					--if (tonumber(drpClear)/2-drpDP)==drpCombo then	-- [ja] elseなら不正なデータ 
						SetDRInfo(""..GetDRFile(i).."-ClearLevel",j);
						SetDRInfo(""..GetDRFile(i).."-ClearName",GetCRSPrm(drpData,"name"));
						if GetDRInfo(""..GetDRFile(i).."-ClearName")=="" then
							SetDRInfo(""..GetDRFile(i).."-ClearName","Level"..j);
						end;
					--end;
				end;
			end;
		end;
	end;
end;

function KillDrill()
	if IsDrill() then
		PREFSMAN:SetPreference("LifeDifficultyScale",GetUserPref_Theme("DrillOldLLevel"));
		PREFSMAN:SetPreference("TimingWindowScale",GetUserPref_Theme("DrillOldTLevel"));
		PREFSMAN:SetPreference("AllowW1",GetUserPref_Theme("DrillOldW1"));
	--	setenv("DrillOldLLevel",false);
	--	setenv("DrillOldTLevel",false);
		if GetUserPref_Theme("DrillEventMode") or GetUserPref_Theme("DrillEventMode")=="" then
			GAMESTATE:SetTemporaryEventMode(tobool(GetUserPref_Theme("DrillEventMode")));
			SetUserPref_Theme("DrillEventMode","");
		end;
		SetUserPref_Theme("DrillOldLLevel","");
		SetUserPref_Theme("DrillOldTLevel","");
		SetUserPref_Theme("DrillOldW1","");
		SetSelDrillCategory(1);
		SetSelDrillLevel(1);
		SetSelDrillResult(0);
		SetDrillLife("");
		DrillEnd();
	end;
end;

function DrillSelectMusic_in()
	local ActorDrill=Def.ActorFrame{
		InitCommand=function(self)
			if not getenv("Announcers") then
				InputCurrentAnnouncer();
				MuteAnnouncer();
			end;
		end;
		OnCommand=function(self)
			if IsDrill() then
				if string.find(GetDrillState(),"SetStage%d+") then
					local stage=GetDrillStage();
					--local lvInfo={};
					--lvInfo=getenv("lvInfo");
					if stage>GetDrillMaxStage() then
						SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
					end;
					local sys_sellevel=GetSelDrillLevel();
					local path,song,dif=GetDrillSong(GetLVInfo(""..GetSelDrillLevel().."-Song")[stage]);
					ResetAnnouncer();
					if song then
						GAMESTATE:SetCurrentSong(song);	--[ja] 強制曲設定 
						GAMESTATE:SetCurrentSteps(GetDrillPlayer(),
							song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),dif));
						SetDrillState("PlayStage"..stage);
						if GetDRInfo("SOpt")=="true" and stage<=1 then
							SCREENMAN:SetNewScreen("ScreenPlayerOptions");
						else
							if GetDRInfo("SOpt")=="false" and stage<=1 then
								-- [ja] 強制倍速1x 
								local ps = GAMESTATE:GetPlayerState(GAMESTATE:GetMasterPlayerNumber());
								local po_so=ps:GetPlayerOptions('ModsLevel_Song');
								po_so:CMod(1,9999);
								po_so:XMod(1,9999);
								local po_pr=ps:GetPlayerOptions('ModsLevel_Preferred');
								po_pr:CMod(1,9999);
								po_pr:XMod(1,9999);
								if GetSMVersion()<=30 then
									local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", C1, 1x";
									ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
								end;
							end;
							SCREENMAN:SetNewScreen("ScreenStageInformation");
						end;
					else
						SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
					end;
				elseif string.find(GetDrillState(),"PlayStage%d+") then
					ResetAnnouncer();
					SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
				elseif GetDrillState()=="Finish" then
					ResetAnnouncer();
					if GetUserPref_Theme("DrillEventMode")=="false" then
						-- [ja] イベントモードではないのでゲーム終了 
						KillDrill();
						SCREENMAN:SetNewScreen("ScreenGameOver");
					else
						SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
					end;
				end;
			end;
		end;
	};
	return ActorDrill;
end;

-- [ja] コース書式の#SONGからディレクトリとsong型と難易度を返す 
function GetDrillSong(strSong)
	local tmp=split(":",strSong);
	tmp[1]=string.gsub(tmp[1],"\\","/");
	local path=split("/",tmp[1]);
	local song=GetFolder2Song(path[#path-1],path[#path]);
	local dif_name=string.lower(tmp[2]);
	local dif='Difficulty_Easy';
	if dif_name=="beginner" then
		dif='Difficulty_Beginner';
	elseif dif_name=="normal" or dif_name=="basic"
		or dif_name=="light" or dif_name=="easy" then
		dif='Difficulty_Easy';
	elseif dif_name=="another" or dif_name=="trick"
		or dif_name=="standard" or dif_name=="medium" then
		dif='Difficulty_Medium';
	elseif dif_name=="maniac" or dif_name=="ssr"
		or dif_name=="heavy" or dif_name=="hard" then
		dif='Difficulty_Hard';
	elseif dif_name=="challenge" or dif_name=="oni"
		or dif_name=="smaniac" then
		dif='Difficulty_Challenge';
	elseif dif_name=="edit" then
		dif='Difficulty_Edit';
	else
		dif='Difficulty_Easy';
	end;
	return path,song,dif;
end;

function DrillGameplay()
	local ActorDrill=Def.ActorFrame{
		BeginCommand=function(self)
			if IsDrill() then
				if tonumber(GetDrillLife()) and GetDrillLifeRemaining() then
					-- [ja] 1以上のバッテリーライフ 
					local life=1.0;
					if GetDrillLifeRecovery()>=0 then
						life=math.floor(GetDrillLife()*GetDrillLifeRemaining()+0.9)-GetDrillLife();
					else
						life=GetDrillLife()-SCREENMAN:GetTopScreen():GetLifeMeter(GetDrillPlayer()):GetLivesLeft();
					end;
					SCREENMAN:GetTopScreen():GetLifeMeter(GetDrillPlayer()):ChangeLives(life);
				end;
			end;
		end;
		OffCommand=function(self)
			if IsDrill() then
				self:sleep(2.5);
				if string.find(GetDrillState(),"PlayStage%d+") then
					SetDrillScore(GetDrillStage());
					if not GetDrillFailed() then
						local life=SCREENMAN:GetTopScreen():GetLifeMeter(GetDrillPlayer()):GetLife();
						SetDrillLifeRemaining(life);
						if GetDrillStage()+1>GetDrillMaxStage() then
							SetDrillState("Finish");
							-- [ja] クリア 
						else
							SetDrillStage(GetDrillStage()+1);
							SetDrillState("SetStage"..GetDrillStage());
							-- [ja] 次ステージ 
						end;
					else
						-- [ja] Failed 
						SetDrillState("Finish");
							-- [ja] リザルトへ 
					end;
				elseif GetDrillState()~="Finish" then
					-- [ja] 異常事態 
					self:queuecommand("DrillError");
				end;
			end;
		end;
		DrillErrorCommand=function(self)
			SCREENMAN:SystemMessage("ERROR : "..GetDrillState())
			SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
		end;
	};
	local function DrillUpdate()
		if IsDrill() and not GetDrillFailed() then
			if GAMESTATE:GetPlayerState(GetDrillPlayer()):GetHealthState()=='HealthState_Dead' then
				SetDrillFailed(true)
				local dif=GAMESTATE:GetCurrentSteps(GetDrillPlayer()):GetDifficulty();
				if dif==Difficulty[1] or dif==Difficulty[2] then
					SCREENMAN:GetTopScreen():PostScreenMessage('SM_Pause', 0.5);
					SCREENMAN:GetTopScreen():PostScreenMessage('SM_BeginFailed', 0.5);
				end;
			end;
		end;
	end;
	ActorDrill.InitCommand=cmd(SetUpdateFunction,DrillUpdate);
	return ActorDrill;
end;

function DrillEvaluation_in()
	-- [ja] GameplayのOffから次ステージへ遷移するとプレイ中に戻った扱いされてスコアが保存されない？のでこちらで対処 
	local ActorDrill=Def.ActorFrame{
		InitCommand=function(self)
			if not IsDrill() then
				ResetAnnouncer();
			end;
		end;
		OnCommand=function(self)
			if IsDrill() then
				if GetDrillState()=="Finish" then
					SCREENMAN:SetNewScreen("ScreenDrillEvaluation");
				else
					if not GetDrillFailed() then
						if GetDrillLifeRecovery()>=0 then
							SetDrillLifeRemaining(math.min(math.max(GetDrillLifeRemaining()+GetDrillLifeRecovery(),0),1));
						end;
						SCREENMAN:SetNewScreen("ScreenSelectMusic");
					else
						SetDrillState("Finish");
						SCREENMAN:SetNewScreen("ScreenDrillEvaluation");
					end;
				end;
			end;
		end;
	};
	return ActorDrill;
end;

function ReadDrillData()
	local folder=GetDRFile(GetSelDrillCategory());
-- [ja] 全ドリルカテゴリ情報を保持し続けるとメモリがもったいないので選択したもの以外破棄 
	--setenv("drFile",drFile);
	local tmp={};
	tmp["Path"]=GetDRInfo(""..folder.."-Path");
	tmp["File"]=GetDRInfo(""..folder.."-File");
	tmp["Title"]=GetDRInfo(""..folder.."-Title");
	tmp["Color"]=GetDRInfo(""..folder.."-Color");
	tmp["Ctrl"] =GetDRInfo(""..folder.."-Ctrl");
	tmp["Style"]=GetDRInfo(""..folder.."-Style");
	tmp["Life"] =GetDRInfo(""..folder.."-Life");
	tmp["LDif"] =GetDRInfo(""..folder.."-LDif");
	tmp["Recovery"]=GetDRInfo(""..folder.."-Recovery");
	tmp["TDif"] =GetDRInfo(""..folder.."-TDif");
	tmp["SOpt"] =GetDRInfo(""..folder.."-SOpt");
	tmp["ROpt"]	=GetDRInfo(""..folder.."-ROpt");
	tmp["Banner"]=GetDRInfo(""..folder.."-Banner");
	tmp["Jacket"]=GetDRInfo(""..folder.."-Jacket");
	tmp["Border"]=GetDRInfo(""..folder.."-Border");
	tmp["ClearLevel"]=GetDRInfo(""..folder.."-ClearLevel");
	tmp["ClearName"]=GetDRInfo(""..folder.."-ClearName");
	tmp["Background"]=GetDRInfo(""..folder.."-Background");
	tmp["Bgm"]=GetDRInfo(""..folder.."-Bgm");
	tmp["ResultBackground"]=GetDRInfo(""..folder.."-ResultBackground");
--
	InitLVInfo();
	local drLevel=1;
	while(true) do
		local drlData=GetTextBlock(folder,"level"..drLevel);
		if #drlData==0 then
			break;
		else
			SetLVInfo(""..drLevel.."-Banner",tmp["Path"].."/"..GetCRSPrm(drlData,"BANNER"));
			if GetCRSPrm(drlData,"BANNER")=="" or not FILEMAN:DoesFileExist(GetLVInfo(""..drLevel.."-Banner")) then
				SetLVInfo(""..drLevel.."-Banner",THEME:GetPathG("Common fallback","banner"));
			end;
			SetLVInfo(""..drLevel.."-Jacket",tmp["Path"].."/"..GetCRSPrm(drlData,"JACKET"));
			if GetCRSPrm(drlData,"JACKET")=="" or not FILEMAN:DoesFileExist(GetLVInfo(""..drLevel.."-Jacket")) then
				SetLVInfo(""..drLevel.."-Jacket",THEME:GetPathG("Common fallback","jacket"));
			end;
			SetLVInfo(""..drLevel.."-Color",GetCRSPrm(drlData,"MENUCOLOR"));
			SetLVInfo(""..drLevel.."-Song",GetCRSPrm2(drlData,"SONG"));
			SetLVInfo(""..drLevel.."-Name",GetCRSPrm(drlData,"NAME"));
			-- [ja] 空白文字だと困るパラメータの定義 
			if GetLVInfo(""..drLevel.."-Name")=="" then
				SetLVInfo(""..drLevel.."-Name","Level"..drLevel);
			end;
			if GetLVInfo(""..drLevel.."-Color")=="" then
				SetLVInfo(""..drLevel.."-Color","0.92,0.11,0.47,1.0");
			end;
		end;
		drLevel=drLevel+1;
	end;
	tmp["Level"]=drLevel-1;	-- [ja] 最高レベル 
	--setenv("drInfo",tmp);
	RepDRInfo(tmp);
	--setenv("lvInfo",lvInfo);
end;

function InitDrillLevel()
	--local lvScore={};
	InitLVScore();
	-- [ja] セーブデータの読み取り 
	for i=1,GetDRInfo("Level") do
		SetLVScore(""..i.."-Clear",false);
		SetLVScore(""..i.."-DP",0.0);
		SetLVScore(""..i.."-PlayCnt",0);
		SetLVScore(""..i.."-ClearCnt",0);
		local drpData=GetTextBlock(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo("File").."/Level"..i..".sav","main");
		if #drpData>0 then
			local drpClear=GetCRSPrm(drpData,"clear");
			if drpClear~="" and drpClear~="0" then
				local drpCombo=tonumber(GetCRSPrm(drpData,"combo"));
				local drpDP=math.floor(tonumber(GetCRSPrm(drpData,"dancepoints"))*100);
				--if (tonumber(drpClear)/2-drpDP)==drpCombo then	-- [ja] elseなら不正なデータ 
					SetLVScore(""..i.."-Clear",true);
				--end;
			end;
			SetLVScore(""..i.."-DP",tonumber(GetCRSPrm(drpData,"dancepoints")));
			local drpCnt=GetCRSPrm(drpData,"count");
			if drpCnt~="" then
				local tmp=split(":",drpCnt);
				SetLVScore(""..i.."-PlayCnt",tonumber(tmp[1]));
				SetLVScore(""..i.."-ClearCnt",tonumber(tmp[2]));
			end;
		end;
	end;
	--setenv("lvScore",lvScore);
end;

function InitDrillLife()
	--local drInfo={};
	--drInfo=getenv("drInfo");
	SetDrillFailed(false);
	SetDrillLifeRemaining(nil);
	--local lLife=string.lower(drInfo["Life"]);
	local lLife=string.lower(GetDRInfo("Life"));
	if lLife=="ultimate" then
		SetDrillLife("Ultimate");
	elseif lLife=="hard" then
		SetDrillLife("Hard");
	elseif lLife=="norecover" then
		SetDrillLife("NoRecover");
	elseif lLife=="hardnorecover" then
		SetDrillLife("Hard");
	elseif lLife=="suddendeath" then
		SetDrillLife("SuddenDeath");
	elseif tonumber(life) then
		SetDrillLife(""..math.max(tonumber(life),1));
	elseif lLife=="mfc" or lLife=="w1fc" then
		SetDrillLife("MFC");
	elseif lLife=="pfc" or lLife=="w2fc" then
		SetDrillLife("PFC");
	elseif lLife=="fc" or lLife=="w3fc" then
		SetDrillLife("FC");
	elseif string.find(lLife,"^%d$") then
		SetDrillLife(lLife);
	else
		SetDrillLife("Normal");
	end;
	if string.find(GetDrillLife(),"^%d$") then
		-- [ja] バッテリーライフ 
		if GetSMVersion()>30 then
			for p=1,2 do
				local pn=(p==1) and PLAYER_1 or PLAYER_2;
				if GAMESTATE:IsPlayerEnabled(pn) then
					local ps=GAMESTATE:GetPlayerState(pn);
					if ps then
						local po=ps:GetPlayerOptions('ModsLevel_Preferred');
						po:LifeSetting('LifeType_Battery');
						po:BatteryLives(tonumber(GetDrillLife()));
					end;
				end;
			end;
		else
			GAMESTATE:ApplyGameCommand( "mod,battery");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,"..GetDrillLife().."lives");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		end;
		SetDrillMaxLife(GetDrillLife());
	elseif GetDrillLife()=="MFC" or GetDrillLife()=="PFC" or GetDrillLife()=="FC" then
		-- [ja] バッテリーライフ（残量1） 
		if GetSMVersion()>30 then
			for p=1,2 do
				local pn=(p==1) and PLAYER_1 or PLAYER_2;
				if GAMESTATE:IsPlayerEnabled(pn) then
					local ps=GAMESTATE:GetPlayerState(pn);
					if ps then
						local po=ps:GetPlayerOptions('ModsLevel_Preferred');
						po:LifeSetting('LifeType_Battery');
						po:BatteryLives(1);
					end;
				end;
			end;
		else
			GAMESTATE:ApplyGameCommand( "mod,battery");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,1lives");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		end;
		SetDrillMaxLife(1);
	else
		if tonumber(GetDRInfo("LDif")) then
			PREFSMAN:SetPreference("LifeDifficultyScale",math.max(GetDRInfo("LDif"),0.01));
		end;
		if tonumber(GetDRInfo("TDif")) then
			PREFSMAN:SetPreference("TimingWindowScale",math.max(GetDRInfo("TDif"),0.01));
		end;
		if GetSMVersion()>30 then
			for p=1,2 do
				local pn=(p==1) and PLAYER_1 or PLAYER_2;
				if GAMESTATE:IsPlayerEnabled(pn) then
					local ps=GAMESTATE:GetPlayerState(pn);
					if ps then
						local po=ps:GetPlayerOptions('ModsLevel_Preferred');
						po:LifeSetting('LifeType_Bar');
						if lLife=="norecover" or lLife=="hardnorecover" then
							po:DrainSetting('DrainType_NoRecover');
						elseif lLife=="norecover" or lLife=="suddendeath" then
							po:DrainSetting('DrainType_SuddenDeath');
						else
							po:DrainSetting('DrainType_Normal');
						end;
					end;
				end;
			end;
		else
			GAMESTATE:ApplyGameCommand( "mod,bar");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			if lLife=="norecover" or lLife=="hardnorecover" then
				GAMESTATE:ApplyGameCommand( "mod,norecover");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			elseif lLife=="norecover" or lLife=="suddendeath" then
				GAMESTATE:ApplyGameCommand( "mod,suddendeath");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			else
				GAMESTATE:ApplyGameCommand( "mod,normal-drain");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			end;
		end;
		SetDrillMaxLife(0);	-- [ja] 0の場合通常ライフ 
	end;
	SetDrillLifeRecovery(tonumber(GetDRInfo("Recovery")));
end;

local DrillScore={};
function InitDrillScore(maxstage)
	-- [ja] トータル 
	DrillScore["Drill_W1"]=0;
	DrillScore["Drill_W2"]=0;
	DrillScore["Drill_W3"]=0;
	DrillScore["Drill_W4"]=0;
	DrillScore["Drill_W5"]=0;
	DrillScore["Drill_MS"]=0;
	DrillScore["Drill_OK"]=0;
	DrillScore["Drill_NG"]=0;
	DrillScore["Drill_HIT"]=0;
	DrillScore["Drill_COMBO"]=0;
	DrillScore["Drill_DP"]=0;	--[ja] 平均DP 
	DrillScore["Drill_LIFE"]=0;	--[ja] 平均ライフ 
	DrillScore["Drill_CAL"]=0;	--[ja] 合計消費カロリー 
	-- [ja] ステージ毎 
	for i=1,maxstage do
		DrillScore["Drill_W1-"..i]=0;
		DrillScore["Drill_W2-"..i]=0;
		DrillScore["Drill_W3-"..i]=0;
		DrillScore["Drill_W4-"..i]=0;
		DrillScore["Drill_W5-"..i]=0;
		DrillScore["Drill_MS-"..i]=0;
		DrillScore["Drill_OK-"..i]=0;
		DrillScore["Drill_NG-"..i]=0;
		DrillScore["Drill_HIT-"..i]=0;
		DrillScore["Drill_COMBO-"..i]=0;
		DrillScore["Drill_DP-"..i]=0;
		DrillScore["Drill_LIFE-"..i]=0;
		DrillScore["Drill_CAL-"..i]=0;
	end;
	SetDrillScoreArray(DrillScore);
	local _DrillLifeStats={};
	SetDrillLifeStats(_DrillLifeStats);
end;

function SetDrillScore(curstage)
	local DrillScore={};
	DrillScore=GetDrillScoreArray();
	local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(GetDrillPlayer());
	DrillScore["Drill_W1-"..curstage]   =pss:GetTapNoteScores('TapNoteScore_W1');
	DrillScore["Drill_W2-"..curstage]   =pss:GetTapNoteScores('TapNoteScore_W2');
	DrillScore["Drill_W3-"..curstage]   =pss:GetTapNoteScores('TapNoteScore_W3');
	DrillScore["Drill_W4-"..curstage]   =pss:GetTapNoteScores('TapNoteScore_W4');
	DrillScore["Drill_W5-"..curstage]   =pss:GetTapNoteScores('TapNoteScore_W5');
	DrillScore["Drill_MS-"..curstage]   =pss:GetTapNoteScores('TapNoteScore_Miss');
	DrillScore["Drill_OK-"..curstage]   =pss:GetHoldNoteScores('HoldNoteScore_Held');
	DrillScore["Drill_NG-"..curstage]   =pss:GetHoldNoteScores('HoldNoteScore_LetGo');
	DrillScore["Drill_HIT-"..curstage]  =pss:GetTapNoteScores('TapNoteScore_HitMine');
	DrillScore["Drill_COMBO-"..curstage]=pss:MaxCombo();
	DrillScore["Drill_DP-"..curstage]   =pss:GetPercentDancePoints();
	DrillScore["Drill_LIFE-"..curstage] =SCREENMAN:GetTopScreen():GetLifeMeter(GetDrillPlayer()):GetLife();
	if getenv("cal1") or getenv("cal2") then
		DrillScore["Drill_CAL-"..curstage] = (GetDrillPlayer()==PLAYER_1) and getenv("cal1") or getenv("cal2");
	else
		DrillScore["Drill_CAL-"..curstage]=0;
	end;
	SetDrillScoreArray(DrillScore);
end;

-- [ja] クリア判別とデータ保存 
function InitDrillResult()
	--local drInfo=getenv("drInfo");
	--local lvInfo=getenv("lvInfo");
	--local lvScore=getenv("lvScore");
	SetSelDrillResult(0);
	local sys_sellevel=GetSelDrillLevel();
	local DrillScore=GetDrillScoreArray();
	DrillScore["Drill_DP"]=0
	for i=1,GetDrillMaxStage() do
		DrillScore["Drill_W1"]   =DrillScore["Drill_W1"]+DrillScore["Drill_W1-"..i];
		DrillScore["Drill_W2"]   =DrillScore["Drill_W2"]+DrillScore["Drill_W2-"..i];
		DrillScore["Drill_W3"]   =DrillScore["Drill_W3"]+DrillScore["Drill_W3-"..i];
		DrillScore["Drill_W4"]   =DrillScore["Drill_W4"]+DrillScore["Drill_W4-"..i];
		DrillScore["Drill_W5"]   =DrillScore["Drill_W5"]+DrillScore["Drill_W5-"..i];
		DrillScore["Drill_MS"]   =DrillScore["Drill_MS"]+DrillScore["Drill_MS-"..i];
		DrillScore["Drill_OK"]   =DrillScore["Drill_OK"]+DrillScore["Drill_OK-"..i];
		DrillScore["Drill_NG"]   =DrillScore["Drill_NG"]+DrillScore["Drill_NG-"..i];
		DrillScore["Drill_HIT"]  =DrillScore["Drill_HIT"]+DrillScore["Drill_HIT-"..i];
		DrillScore["Drill_COMBO"]=DrillScore["Drill_COMBO"]+DrillScore["Drill_COMBO-"..i];
		DrillScore["Drill_DP"]   =DrillScore["Drill_DP"]+DrillScore["Drill_DP-"..i];
		DrillScore["Drill_LIFE"] =DrillScore["Drill_LIFE"]+DrillScore["Drill_LIFE-"..i];
		DrillScore["Drill_CAL"] =DrillScore["Drill_CAL"]+DrillScore["Drill_CAL-"..i];
	end;
	DrillScore["Drill_DP"]=DrillScore["Drill_DP"]/GetDrillMaxStage();
	DrillScore["Drill_LIFE"]=DrillScore["Drill_LIFE"]/GetDrillMaxStage();
	SetDrillScoreArray(DrillScore);
	if tonumber(string.format("%1.2f",DrillScore["Drill_DP"]*100))<tonumber(GetDRInfo("Border")) then
		SetDrillFailed(true);
	end;
	SetLVScore(""..GetSelDrillLevel().."-PlayCnt",GetLVScore(""..GetSelDrillLevel().."-PlayCnt")+1);
	if not GetDrillFailed() then
		SetLVScore(""..GetSelDrillLevel().."-ClearCnt",GetLVScore(""..GetSelDrillLevel().."-ClearCnt")+1);
	end;
	local tmp=split("/",GetDRInfo("File"));
	local drpMain=GetTextBlock(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo("File").."/Level"..GetSelDrillLevel()..".sav","main");
	local drpClear=GetCRSPrm(drpMain,"Clear");
	local drpDP=GetCRSPrm(drpMain,"DancePoints");
	if #drpMain==0 or (((drpClear=="0" and not GetDrillFailed()) or DrillScore["Drill_DP"]>tonumber(drpDP))
		and not (drpClear~="0" and GetDrillFailed())) then
		local saveText="";
		saveText=saveText.."[Main]\n";
		saveText=saveText.."#Name:"..GetLVInfo(""..GetSelDrillLevel().."-Name")..";\n";
		--saveText=saveText.."#Clear:"..(getenv("DrillFailed") and 0 or ((math.floor(DrillScore["Drill_DP"]*100)+DrillScore["Drill_COMBO"])*2))..";\n";
		saveText=saveText.."#Clear:"..(GetDrillFailed() and 0 or 1)..";\n";
		saveText=saveText.."#NoteScore:"..DrillScore["Drill_W1"]..":"
			..DrillScore["Drill_W2"]..":"..DrillScore["Drill_W3"]..":"
			..DrillScore["Drill_W4"]..":"..DrillScore["Drill_W5"]..":"
			..DrillScore["Drill_MS"]..":"..DrillScore["Drill_OK"]..":"
			..DrillScore["Drill_NG"]..":"..DrillScore["Drill_HIT"]..";\n";
		saveText=saveText.."#Combo:"..DrillScore["Drill_COMBO"]..";\n";
		saveText=saveText.."#DancePoints:"..DrillScore["Drill_DP"]..";\n";
		saveText=saveText.."#Life:"..DrillScore["Drill_LIFE"]..";\n";
		saveText=saveText.."#Count:"..GetLVScore(""..GetSelDrillLevel().."-PlayCnt")..":"
			..GetLVScore(""..GetSelDrillLevel().."-ClearCnt")..";\n";
		for i=1,GetDrillMaxStage() do
			saveText=saveText.."\n[Stage"..i.."]\n";
			saveText=saveText.."#NoteScore:"..DrillScore["Drill_W1-"..i]..":"
				..DrillScore["Drill_W2-"..i]..":"..DrillScore["Drill_W3-"..i]..":"
				..DrillScore["Drill_W4-"..i]..":"..DrillScore["Drill_W5-"..i]..":"
				..DrillScore["Drill_MS-"..i]..":"..DrillScore["Drill_OK-"..i]..":"
				..DrillScore["Drill_NG-"..i]..":"..DrillScore["Drill_HIT-"..i]..";\n";
			saveText=saveText.."#Combo:"..DrillScore["Drill_COMBO-"..i]..";\n";
			saveText=saveText.."#DancePoints:"..DrillScore["Drill_DP-"..i]..";\n";
			saveText=saveText.."#Life:"..DrillScore["Drill_LIFE-"..i]..";\n";
		end;
		local f=SaveFile(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo("File").."/Level"..GetSelDrillLevel()..".sav");
		f:Write(saveText);
		CloseFile(f);
	else
	-- [ja] スコアの更新がなくてもプレイ回数の更新が必要 
	-- [ja] カロリーは保存対象外 
		local saveText="";
		local tmp_drpMain=GetTextBlock(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo("File").."/Level"..GetSelDrillLevel()..".sav","main");
		saveText=saveText.."[Main]\n";
		saveText=saveText.."#Name:"..GetCRSPrm(tmp_drpMain,"name")..";\n";
		saveText=saveText.."#Clear:"..GetCRSPrm(tmp_drpMain,"clear")..";\n";
		saveText=saveText.."#NoteScore:"..GetCRSPrm(tmp_drpMain,"notescore")..";\n";
		saveText=saveText.."#Combo:"..GetCRSPrm(tmp_drpMain,"combo")..";\n";
		saveText=saveText.."#DancePoints:"..GetCRSPrm(tmp_drpMain,"dancepoints")..";\n";
		saveText=saveText.."#Life:"..GetCRSPrm(tmp_drpMain,"life")..";\n";
		saveText=saveText.."#Count:"..GetLVScore(""..GetSelDrillLevel().."-PlayCnt")..":"
			..GetLVScore(""..GetSelDrillLevel().."-ClearCnt")..";\n";
		for i=1,GetDrillMaxStage() do
			local tmp_drpSection=GetTextBlock(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo("File").."/Level"..GetSelDrillLevel()..".sav","stage"..i);
			saveText=saveText.."\n[Stage"..i.."]\n";
			saveText=saveText.."#NoteScore:"..GetCRSPrm(tmp_drpSection,"notescore")..";\n";
			saveText=saveText.."#Combo:"..GetCRSPrm(tmp_drpSection,"combo")..";\n";
			saveText=saveText.."#DancePoints:"..GetCRSPrm(tmp_drpSection,"dancepoints")..";\n";
			saveText=saveText.."#Life:"..GetCRSPrm(tmp_drpSection,"life")..";\n";
		end;
		local f=SaveFile(GetDrillPlayerProfileDir().."Drills/"..GetDRInfo("File").."/Level"..GetSelDrillLevel()..".sav");
		f:Write(saveText);
		CloseFile(f);
	end;
end;

-- [ja] プロファイルの保存形式 
--[[
+00000000
++Drills
+++Category1
+++-Level1.sav
+++-Level2.sav
+++Category2
+++-Level1.sav
+++-Level2.sav

*Level1.sav
[Main]
#Name:Level1;
#Clear:0; ←0 : failed, (DP(%)の整数部+Combo)*2 : cleared
#NoteScore:W1:W2:W3....;
#Combo:XXX;
#DancePoints:XXX;
#Life:XXX;
[Stage1]
#NoteScore:W1:W2:W3....;
#Combo:XXX...;
#DancePoints:XXX...;
#Life:XXX...;
]]--

---------------------------------------------------------------------------------------------------

-- [ja] 各判定数からグレードを計算（微妙に誤差あるけど実用レベル） 
function GradeChkCore(maxscore,w1,w2,w3,w4,w5,ms,ok,hit)
	local curscore=w1*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW1"))
		+w2*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW2"))
		+w3*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW3"))
		+w4*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW4"))
		+w5*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW5"))
		+ms*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightMiss"))
		+ok*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightHeld"))
		+hit*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightHitMine"));
	return 1.0*curscore/math.max(maxscore,1);
end;

-- [ja] stepsから各値を取得する場合 
function GradeChk(st,w1,w2,w3,w4,w5,ms,ok,hit)
	local maxscore=st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_TapsAndHolds')*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW1"))
		+st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_Holds')*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightHeld"))
		+st:GetRadarValues(GAMESTATE:GetMasterPlayerNumber()):GetValue('RadarCategory_Rolls')*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightHeld"));
	return GradeChkCore(maxscore,w1,w2,w3,w4,w5,ms,ok,hit);
end;

-- [ja] すでに総譜面数とロングノート数が取得済みの場合  
function GradeChkSetMax(stepcnt,holdcnt,w1,w2,w3,w4,w5,ms,ok,hit)
	local maxscore=stepcnt*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightW1"))
		+holdcnt*tonumber(THEME:GetMetric("ScoreKeeperNormal","GradeWeightHeld"));
	return GradeChkCore(maxscore,w1,w2,w3,w4,w5,ms,ok,hit);
end;

function DrillOptionsReset_inTitle()
	if GetUserPref_Theme("DrillEventMode") or GetUserPref_Theme("DrillEventMode")=="" then
		-- [ja] ドリルがうまく初期化されなかった 
		KillDrill();
	end;
	if getenv("PlayModeCourse") then
		setenv("PlayModeCourse",nil);
		THEME:ReloadMetrics();
	else
		THEME:ReloadMetrics();
	end;
	setenv("PlayModeDrill",nil);
	SetUserPref_Theme("UserLyricEgg", "false");
	SetUserPref_Theme("UserwaieiPlayerOptionsP1", "");
	SetUserPref_Theme("UserwaieiPlayerOptionsP2", "");
end;
