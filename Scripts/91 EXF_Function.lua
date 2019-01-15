__EXFOLDER__ = __EXFBASE__ and true or false;

--[ja] ボスフォルダ関係の命令 

-- [ja] bit演算用
local function bitand(a,b)
	local b_t={
		false,false,false,false,
		false,false,false,false,
		false,false,false,false,
		false,false,false,false,
		false,false,false,false,
		false,false,false,false,
		false,false,false,false,
		false,false,false,false
	};
	local ret=0;
	local i=#b_t-1;
	local tmp=b;
	while(i>=0) do
		if tmp>=2^i then
			b_t[i+1]=true;
			tmp=tmp-2^i;
		end;
		i=i-1;
	end;
	i=#b_t-1;
	tmp=a;
	while(i>=0) do
		if tmp>=2^i then
			if b_t[i+1]==true then
				ret=ret+2^i;
			end;
			tmp=tmp-2^i;
		end;
		i=i-1;
	end;
	return ret;
end;

--[ja] 平均等取得用 
grade={
	Grade_Tier01=0,
	Grade_Tier02=1,
	Grade_Tier03=2,
	Grade_Tier04=3,
	Grade_Tier05=4,
	Grade_Tier06=5,
	Grade_Tier07=6,
	Grade_Tier08=7,
	Grade_Tier09=8,
	Grade_Tier10=9,
	Grade_Tier11=10,
	Grade_Tier12=11,
	Grade_Tier13=12,
	Grade_Tier14=13,
	Grade_Tier15=14,
	Grade_Tier16=15,
	Grade_Tier17=16,
	Grade_Tier18=17,
	Grade_Tier19=18,
	Grade_Tier20=19,
	Grade_Failed=20
};
local dif_list={
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge',
	'Difficulty_Edit'
};
-- MaxStage
local function _MAXSTAGE()
	return PREFSMAN:GetPreference("SongsPerPlay");
end;

--[[
 [ja] 開始 
 ※Last系条件取得のため、必ずステージ2以降であること 
--]]
local function EnableEXFolder()
	return (not GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentStageIndex()>0);
end;
function StartEXFolder(grouop)
	if EnableEXFolder() then
		SetEXFGroupName(grouop);
		SetEXFStage(1);
		SCREENMAN:SetNewScreen("ScreenEXFolderIntro");
	end;
end;

local exf=false;
local EXFSys={};
local EXFSong={};	-- [ja] EXFTSong[1]=楽曲1フォルダ... 
local EXFStats={};	-- [ja] EXFStats[楽曲1フォルダ].song=楽曲1... 

-- [ja] 初期化 
function InitEXFolder(group,exstage)
	exf=true;
	SetEXFolderSongs(group,exstage);
	SetEXFolderLife(group,exstage);
	return;
end;

-- [ja] 終了 
function KillEXFolder()
	exf=false;
	EXFSys={};
	EXFSong={};	-- [ja] EXFTSong[1]=楽曲1フォルダ... 
	EXFStats={};	-- [ja] EXFStats[楽曲1フォルダ].song=楽曲1... 
	return;
end;

-- [ja] EXFolderかどうか 
function IsEXFolder()
	return exf;
end;

-- [ja] グループ名 
local EXFGroupName="";
function SetEXFGroupName(group)
	EXFGroupName=group;
end
function GetEXFGroupName()
	return EXFGroupName;
end;

-- [ja] 現在のEXFolderステージ数 
local EXFStage=0;
function SetEXFStage(stcnt)
	EXFStage=stcnt;
end
function GetEXFStage()
	return EXFStage;
end;

-- [ja] ライフ 
function SetEXFLife(slife)
	EXFSys["Life"]=slife;
	--setenv("EXFSys",EXFSys);
	return EXFSys["Life"];
end
function GetEXFLife()
	local life=GetEXFSongState_Life(GetEXFCurrentSong());
	if not life then
		life=EXFSys["Life"];
	end;
	return (life or SetEXFLife("Normal"));
end;

local function CnvEXFolderLife(sEXFLife)
	local lsEXFLife=string.lower(sEXFLife);
	local ret='Normal';
	if lsEXFLife=="hard" then
		ret="Hard";
	elseif lsEXFLife=="hardnorecover" then
		ret="HardNoRecover";
	elseif lsEXFLife=="norecover" then
		ret="NoRecover";
	elseif lsEXFLife=="suddendeath" then
		ret="Suddendeath";
	elseif lsEXFLife=="ultimate" then
		ret="Ultimate";
	elseif lsEXFLife=="fc" or lsEXFLife=="w3fc" then
		ret="FC";
	elseif lsEXFLife=="pfc" or lsEXFLife=="w2fc" then
		ret="PFC";
	elseif lsEXFLife=="mfc" or lsEXFLife=="w1fc" then
		ret="MFC";
	elseif string.find(lsEXFLife,"%d+") then
		ret=""..math.max(tonumber(lsEXFLife),1);
	end;
	return ret;
end;

-- [ja] EXFolderの状態 
function SetEXFState(state)
	if string.find(string.lower(state),"^ex1.*") then
		SetEXFStage(1);
	elseif string.find(string.lower(state),"^ex2.*") then
		SetEXFStage(2);
	else
		SetEXFStage(0);
	end;
	EXFSys["State"]=state;
	return EXFSys["State"];
end
function GetEXFState()
	return (EXFSys["State"] or SetEXFState(""));
end;

-- [ja] EXFolderのタイプ 
function GetEXFType()
	return (EXFSys["Type"] or "Folder");
end;

-- [ja] 曲数 
function GetEXFTotalSongs()
	return (EXFSys and EXFSys["Max"] or 0);
end;

-- [ja] 選択中楽曲番号 
function GetEXFCurrentSong()
	return (EXFSys and EXFSys["Sel"] or 0);
end;
	-- [ja] 引数は移動する量を指定（右に1つなら1、左なら-1） 
function SetEXFCurrentSongR(rsong)
	EXFSys["Sel"]=EXFSys["Sel"]+rsong;
	if EXFSys["Sel"]>EXFSys["Max"] then
		EXFSys["Sel"]=1;
	end;
	if EXFSys["Sel"]<1 then
		if EXFSys["Max"]>0 then
			while(EXFSys["Sel"]<1) do
				EXFSys["Sel"]=EXFSys["Sel"]+EXFSys["Max"];
			end;
		else
			EXFSys["Sel"]=0;
		end;
	end;
	SetEXFPlayerDifficulty(EXFSys["Sel"]);
	return EXFSys["Sel"];
end;
	-- [ja] 引数は絶対値を指定 
function SetEXFCurrentSongA(asong)
	if not EXFSys["Max"] then return 0; end;
	EXFSys["Sel"]=asong;
	if EXFSys["Sel"]>EXFSys["Max"] then
		EXFSys["Sel"]=1;
	end;
	if EXFSys["Sel"]<1 then
		if EXFSys["Max"]>0 then
			while(EXFSys["Sel"]<1) do
				EXFSys["Sel"]=EXFSys["Sel"]+EXFSys["Max"];
			end;
		else
			EXFSys["Sel"]=0;
		end;
	end;
	SetEXFPlayerDifficulty(EXFSys["Sel"]);
	return EXFSys["Sel"];
end;

-- [ja] acnt番の曲番号 
function GetEXFSongA(acnt)
	if EXFSys["Max"]>0 then
		local chk=acnt%EXFSys["Max"];
		while chk<=0 do
			chk=chk+EXFSys["Max"];
		end;
		return chk;
	end;
	return 0;
end;

-- [ja] 選択中楽曲番号からrcntずらした曲番号 
function GetEXFSongR(rcnt)
	if EXFSys["Max"]>0 then
		local chk=(EXFSys["Sel"]+rcnt)%EXFSys["Max"];
		while chk<=0 do
			chk=chk+EXFSys["Max"];
		end;
		return chk;
	end;
	return 0;
end;

-- [ja] BPM/Timeを表示するかどうか（Hidden表示を含めて確認） 
function GetEXFCurrentSong_ShowBPMTime()
	return not (IsEXFolder() and bitand(GetEXFSongState_Hidden(GetEXFCurrentSong()),2)==2);
end;

-- [ja] レーダー、譜面詳細を表示するかどうか（Hidden表示を含めて確認） 
function GetEXFCurrentSong_ShowStepInfo()
	return not (IsEXFolder() and bitand(GetEXFSongState_Hidden(GetEXFCurrentSong()),1)==1);
end;

-- [ja] ハイスコアを表示するかどうか（Hidden表示を含めて確認） 
function GetEXFCurrentSong_ShowHiScore()
	return not (IsEXFolder() and bitand(GetEXFSongState_Hidden(GetEXFCurrentSong()),4)==4);
end;

-- [ja] 楽曲の情報 
function GetEXFSongState(num,val)
	return EXFStats[EXFSong[num].."-"..val];
end;
function GetEXFSongState_Song(num)
	return GetEXFSongState(num,"Song");
end;
function GetEXFSongState_Random(num)
	return GetEXFSongState(num,"Random");
end;
function GetEXFSongState_Title(num)
	return GetEXFSongState(num,"Title");
end;
function GetEXFSongState_SubTitle(num)
	return GetEXFSongState(num,"SubTitle");
end;
function GetEXFSongState_Artist(num)
	return GetEXFSongState(num,"Artist");
end;
function GetEXFSongState_Difficulty(num)
	return GetEXFSongState(num,"Difficulty");
end;
function GetEXFSongState_Banner(num)
	return GetEXFSongState(num,"Banner");
end;
function GetEXFSongState_Jacket(num)
	return GetEXFSongState(num,"Jacket");
end;
function GetEXFSongState_Hidden(num)
	return GetEXFSongState(num,"Hidden");
end;
function GetEXFSongState_Color(num)
	return GetEXFSongState(num,"Color");
end;
function GetEXFSongState_Life(num)
	return GetEXFSongState(num,"Life");
end;

-- [ja] 難易度を設定 
function SetEXFPlayerDifficulty(num)
	for p=1,2 do
		local pn=((p==1) and PLAYER_1 or PLAYER_2);
		if GAMESTATE:IsPlayerEnabled(pn) then
			if EXFSys["Old-Difficulty-P"..p]~=EXFSys["Difficulty-P"..p] then
				EXFSys["Difficulty-P"..p]=EXFSys["Old-Difficulty-P"..p];
			end;
			local dif_list=GetEXFSongState_Difficulty(num);
			if not dif_list[EXFSys["Difficulty-P"..p]] then
				if EXFSys["Difficulty-P"..p]>=3 then
					-- [ja] 上位難易度からチェック 
					local chk=false;
					for d=1,5 do
						if dif_list[6-d] then
							chk=true;
							EXFSys["Difficulty-P"..p]=6-d;
							break;
						end;
					end;
					if not chk then
						EXFSys["Difficulty-P"..p]=6;
					end;
				else
					-- [ja] 下位難易度からチェック 
					local chk=false;
					for d=1,5 do
						if dif_list[d] then
							chk=true;
							EXFSys["Difficulty-P"..p]=d;
							break;
						end;
					end;
					if not chk then
						EXFSys["Difficulty-P"..p]=6;
					end;
				end;
			end;
		end;
	end;
end;
function GetEXFPlayerDifficulty(pn)
	return ((pn==PLAYER_1) and Difficulty[EXFSys["Difficulty-P1"]] or Difficulty[EXFSys["Difficulty-P2"]]);
end;
function ChangeEXFDifficulty(num,pn,rchange)
	local p=(pn==PLAYER_1) and 1 or 2;
	if EXFSys["Difficulty-P"..p]+rchange<1 or EXFSys["Difficulty-P"..p]+rchange>6 then
		return false;
	else
		local dif_list=GetEXFSongState_Difficulty(num);
		if dif_list[EXFSys["Difficulty-P"..p]+rchange] then
			EXFSys["Difficulty-P"..p]=EXFSys["Difficulty-P"..p]+rchange;
			EXFSys["Old-Difficulty-P"..p]=EXFSys["Difficulty-P"..p];
			return true;
		else
			return false;
		end;
	end;
end;

function SetEXFPlayerSteps(song)
	for p=1,2 do
		local pn=(p==1) and PLAYER_1 or PLAYER_2;
		if GAMESTATE:IsPlayerEnabled(pn) and song then
			GAMESTATE:SetCurrentSong(song);
			local st=song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),GetEXFPlayerDifficulty(pn));
			GAMESTATE:SetCurrentSteps(pn,st);
		end;
	end;
end;

-- [ja] 曲情報の読み取り 
function SetEXFolderSongs(group,exstage)
	--[[
		sEXFXXX	テキストデータ
		lsEXFXXX	テキストデータ（小文字）
		EXFXXX	必要データ
	--]]
	local expath=GetExFolderPath(group);
	local sEXFList=split(":",GetGroupParameter(group,"Extra"..exstage.."List"));
	local sEXFSongs=split(":",GetGroupParameter(group,"Extra"..exstage.."Songs"));
	local lsEXFSongs=split(":",string.lower(GetGroupParameter(group,"Extra"..exstage.."Songs")));
	EXFSys={};	-- [ja] EXFolderの情報全般 
	local c=0;	-- [ja] 楽曲カウント 
	EXFSong={};	-- [ja] EXFTSong[1]=楽曲1フォルダ... 
	EXFStats={};	-- [ja] EXFStats[楽曲1フォルダ].song=楽曲1... 
	local sdif_list={};
		sdif_list[0]='$';
		sdif_list[1]='%-beginner$';
		sdif_list[2]='%-easy$';
		sdif_list[3]='%-medium$';
		sdif_list[4]='%-hard$';
		sdif_list[5]='%-challenge$';
		sdif_list[6]='%-edit$';
	for i=1,#sEXFList do
		local foldername=sEXFList[i];
		if foldername=='' then break; end;
		local song=EXF_GetFolder2Song(group,foldername);
		if song then
			EXFSong[c+1]=foldername;
			-- [ja] 選択できる難易度を検証 
			local dif_chk={true,true,true,true,true,true};
			local dif_chk_all=false;	-- [ja] dif_chkが一つでもtrueならtrueを代入 
			-- [ja] まず、譜面が存在するのかをチェック 
			for d=1,6 do
				if not song:HasStepsTypeAndDifficulty(GAMESTATE:GetCurrentStyle():GetStepsType(),Difficulty[d]) then
					dif_chk[d]=false;
				else
					dif_chk_all=true;
				end;
			end;
			-- [ja] 条件チェック 
			if #sEXFSongs>=1 and sEXFSongs[1]~='' then
				if dif_chk_all then
					for j=1,#lsEXFSongs do
						if string.find(lsEXFSongs[j],""..foldername.."|",1,true) then
							local lsEXFSong_Prm=split("|",lsEXFSongs[j]);
							for k=1,#lsEXFSong_Prm do
								if not dif_chk_all then
									break;
								end;
								local lsEXFSong_Prm2=split(">",lsEXFSong_Prm[k]);
								--[[
									lsEXFSong_Prm2 : 条件>数値（文字列）>+ を > で区切ったもの 
								--]]
								if #lsEXFSong_Prm2==3 then
									local chk_mode="???";
									if string.find(lsEXFSong_Prm2[1],"^last.*") then
										chk_mode="last";
									elseif string.find(lsEXFSong_Prm2[1],"^max.*") then
										chk_mode="max";
									elseif string.find(lsEXFSong_Prm2[1],"^min.*") then
										chk_mode="min";
									elseif string.find(lsEXFSong_Prm2[1],"^played.*") then
										chk_mode="played";
									elseif string.find(lsEXFSong_Prm2[1],"^avg.*") then
										chk_mode="avg";
									end;
									for d=0,6 do
										if not dif_chk_all then
											break;
										end;
										local ret=-9999999999;
										local chk_mode_str=false;	-- [ja] チェック対象が文字列の場合true（LastSong等） 
										if string.find(lsEXFSong_Prm2[1],"^.*grade"..sdif_list[d]) then
											ret=GetStageState("grade", chk_mode, lsEXFSong_Prm2[3]);
										elseif string.find(lsEXFSong_Prm2[1],"^.*pdp"..sdif_list[d]) 
											or string.find(lsEXFSong_Prm2[1],"^.*perdancepoints"..sdif_list[d]) then	--[ja] DPより先にPDPを書いておかないと条件を満たしてしまう 
											ret=GetStageState("pdp", chk_mode, lsEXFSong_Prm2[3])*100;
										elseif string.find(lsEXFSong_Prm2[1],"^.*dp"..sdif_list[d]) 
											or string.find(lsEXFSong_Prm2[1],"^.*dancepoints"..sdif_list[d]) then
											ret=GetStageState("dp", chk_mode, lsEXFSong_Prm2[3]);
										elseif string.find(lsEXFSong_Prm2[1],"^.*combo"..sdif_list[d]) 
											or string.find(lsEXFSong_Prm2[1],"^.*maxcombo"..sdif_list[d]) then
											ret=GetStageState("combo", chk_mode, lsEXFSong_Prm2[3]);
										elseif string.find(lsEXFSong_Prm2[1],"^.*meter"..sdif_list[d]) then
											ret=GetStageState("meter", chk_mode, lsEXFSong_Prm2[3]);
										elseif string.find(lsEXFSong_Prm2[1],"^.*song"..sdif_list[d]) then
											ret=GetStageState("song", lsEXFSong_Prm2[2], lsEXFSong_Prm2[3]);
											chk_mode_str=true;
										else
											ret=-9999999999;
										end;
										if ret>-9999999999 then
											if lsEXFSong_Prm2[3]=="+" or lsEXFSong_Prm2[3]=="over" then
												if chk_mode_str then
													if (chk_mode=="played" and ret==0) or (chk_mode=="last" and ret<_MAXSTAGE()) then
														if d==0 then
															dif_chk={false,false,false,false,false,false};
															dif_chk_all=false;
														else
															dif_chk[d]=false;
														end;
													end;
												else
													if ret<tonumber(lsEXFSong_Prm2[2]) then
														if d==0 then
															dif_chk={false,false,false,false,false,false};
															dif_chk_all=false;
														else
															dif_chk[d]=false;
														end;
													end;
												end;
											elseif lsEXFSong_Prm2[3]=="-" or lsEXFSong_Prm2[3]=="under" then
												if chk_mode_str then
													if (chk_mode=="played" and ret>0) or (chk_mode=="last" and ret==_MAXSTAGE()) then
														if d==0 then
															dif_chk={false,false,false,false,false,false};
															dif_chk_all=false;
														else
															dif_chk[d]=false;
														end;
													end;
												else
													if ret>tonumber(lsEXFSong_Prm2[2]) then
														if d==0 then
															dif_chk={false,false,false,false,false,false};
															dif_chk_all=false;
														else
															dif_chk[d]=false;
														end;
													end;
												end;
											end;
										end;
									end;--[[ [ja] 難易度別チェックループ --]]
								end;
								-- [ja] まだ選択可能な難易度が残っているかチェック 
								if not dif_chk[1] and not dif_chk[2] and dif_chk[3]
									and not dif_chk[4] and not dif_chk[5] and dif_chk[6] then
									dif_chk_all=false;
								end;
							end;--[[ [ja] 条件を一つずつチェックのループ --]]
							break;
						end;
					end;--[[ [ja] 対象楽曲かの確認ループ --]]
				end;
				-- [ja] 条件を確認したのでもう一回チェック 
				dif_chk_all=false;
				for d=1,6 do
					if dif_chk[d] then
						dif_chk_all=true;
					end;
				end;
			end;
			if dif_chk_all then
				c=c+1;
				-- [ja] 選択できる難易度が存在するので登録 
				song=EXF_GetFolder2Song(group,EXFSong[c]);
				EXFStats[EXFSong[c].."-Song"]=song;
				EXFStats[EXFSong[c].."-Title"]=song:GetDisplayMainTitle();
				EXFStats[EXFSong[c].."-SubTitle"]=song:GetDisplaySubTitle();
				EXFStats[EXFSong[c].."-Artist"]=song:GetDisplayArtist();
				EXFStats[EXFSong[c].."-Banner"]=(song:HasBanner()) and song:GetBannerPath() or THEME:GetPathG("Common","fallback banner");
				EXFStats[EXFSong[c].."-Jacket"]=(song:HasJacket()) and song:GetJacketPath() or
					(song:HasBackground() and song:GetBackgroundPath() or THEME:GetPathG("Common","fallback jacket"));
				EXFStats[EXFSong[c].."-Random"]="";	-- [ja] 中身がある場合はランダム 
				EXFStats[EXFSong[c].."-Color"]=nil;
				EXFStats[EXFSong[c].."-Life"]=nil;
				EXFStats[EXFSong[c].."-Hidden"]=2;
				EXFStats[EXFSong[c].."-Difficulty"]=dif_chk;
				-- [ja] ここからExtraXSongsに記述されている内容を読み取る 
				if #sEXFSongs>=1 and sEXFSongs[1]~='' then
					for j=1,#lsEXFSongs do
						if string.find(sEXFSongs[j],""..foldername.."|",1,true) then
							local sEXFSong_Prm=split("|",sEXFSongs[j]);
							local lsEXFSong_Prm=split("|",lsEXFSongs[j]);
							for k=1,#lsEXFSong_Prm do
								local sEXFSong_Prm2=split(">",sEXFSong_Prm[k]);
								local lsEXFSong_Prm2=split(">",lsEXFSong_Prm[k]);
								if #lsEXFSong_Prm2>=2 then
									--[[
										lsEXFSong_Prm2 : 定義>パラメータ を > で区切ったもの 
									--]]
									if lsEXFSong_Prm2[1]=="title" then
										EXFStats[EXFSong[c].."-Title"]=sEXFSong_Prm2[2];
										EXFStats[EXFSong[c].."-SubTitle"]="";
									elseif lsEXFSong_Prm2[1]=="subtitle" then
										EXFStats[EXFSong[c].."-SubTitle"]=sEXFSong_Prm2[2];
									elseif lsEXFSong_Prm2[1]=="artist" then
										EXFStats[EXFSong[c].."-Artist"]=sEXFSong_Prm2[2];
									elseif lsEXFSong_Prm2[1]=="jacket" then
										if FILEMAN:DoesFileExist(expath..""..sEXFSong_Prm2[2]) then
											EXFStats[EXFSong[c].."-Jacket"]=expath..""..sEXFSong_Prm2[2];
										end;
									elseif lsEXFSong_Prm2[1]=="banner" then
										if FILEMAN:DoesFileExist(expath..""..sEXFSong_Prm2[2]) then
											EXFStats[EXFSong[c].."-Banner"]=expath..""..sEXFSong_Prm2[2];
										end;
									elseif lsEXFSong_Prm2[1]=="color" then
										EXFStats[EXFSong[c].."-Color"]=color(sEXFSong_Prm2[2]);
									elseif lsEXFSong_Prm2[1]=="life" then
										EXFStats[EXFSong[c].."-Life"]=CnvEXFolderLife(sEXFSong_Prm2[2]);
									elseif lsEXFSong_Prm2[1]=="hidden" then
										if lsEXFSong_Prm2[2]=="1" then
											EXFStats[EXFSong[c].."-Hidden"]=1;	-- [ja] 難易度表記 
										elseif lsEXFSong_Prm2[2]=="2" then
											EXFStats[EXFSong[c].."-Hidden"]=2;	-- [ja] 譜面情報 
										elseif lsEXFSong_Prm2[2]=="3" then
											EXFStats[EXFSong[c].."-Hidden"]=3;
										elseif lsEXFSong_Prm2[2]=="4" then
											EXFStats[EXFSong[c].."-Hidden"]=4;	-- [ja] スコアデータ 
										elseif lsEXFSong_Prm2[2]=="5" then
											EXFStats[EXFSong[c].."-Hidden"]=5;
										elseif lsEXFSong_Prm2[2]=="6" or lsEXFSong_Prm2[2]=="true" then
											EXFStats[EXFSong[c].."-Hidden"]=6;
										elseif lsEXFSong_Prm2[2]=="7" or lsEXFSong_Prm2[2]=="all" then
											EXFStats[EXFSong[c].."-Hidden"]=7;
										else
											EXFStats[EXFSong[c].."-Hidden"]=0;
										end;
									elseif lsEXFSong_Prm2[1]=="random" then
										local rnd_base=math.round(GetStageState("PDP", "Last", "+")*10000);
										EXFStats[EXFSong[c].."-Random"]=sEXFSong_Prm2[(rnd_base%(#sEXFSong_Prm2-1))+2];
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	local lsEXFType=string.lower(GetGroupParameter(group,"Extra"..exstage.."Type"));
	EXFSys["Sel"]=1;
	EXFSys["Max"]=c;
	EXFSys["Group"]=group;
	if lsEXFType=="song" then
		EXFSys["Type"]="Song";
	else	-- [ja] 定義なしの場合もFolder
		EXFSys["Type"]="Folder";
	end;
	EXFSys["Difficulty-P1"]=4;	-- Difficulty_Hard
	EXFSys["Difficulty-P2"]=4;
	EXFSys["Old-Difficulty-P1"]=4;
	EXFSys["Old-Difficulty-P2"]=4;
	local lsEXFDif=string.lower(GetGroupParameter(group,"Extra"..exstage.."Difficulty"));
	local dEXFDif="";
	if GetSMVersion()>30 then
		dEXFDif=OldStyleStringToDifficulty(lsEXFDif~="" and lsEXFDif or 'maniac');
	else
		if lsEXFDif=="beginner" then
			lsEXFDif="Difficulty_Beginner";
		elseif lsEXFDif~="basic" or lsEXFDif~="light" or lsEXFDif~="easy" then
			lsEXFDif="Difficulty_Easy";
		elseif lsEXFDif~="another" or lsEXFDif~="trick" or lsEXFDif~="standard" or lsEXFDif~="medium" then
			lsEXFDif="Difficulty_Medium";
		elseif lsEXFDif~="oni" or lsEXFDif~="smaniac" or lsEXFDif~="challenge" then
			lsEXFDif="Difficulty_Challenge";
		else
			lsEXFDif="Difficulty_Hard";
		end;
	end;
		
	for d=1,6 do
		if Difficulty[d]==dEXFDif then
			EXFSys["Difficulty-P1"]=d;
			EXFSys["Difficulty-P2"]=d;
			EXFSys["Old-Difficulty-P1"]=d;
			EXFSys["Old-Difficulty-P2"]=d;
		end;
	end;
end;

function SetEXFolderLife(group,exstage)
	local expath=GetExFolderPath(group);
	local sEXFLife=GetGroupParameter(group,"Extra"..exstage.."LifeLevel");
	SetEXFLife(CnvEXFolderLife(sEXFLife));
end;

--[ja] 現在開いているグループフォルダ名を取得 
function GetActiveGroupName()
	local group="";
	local song=GAMESTATE:GetCurrentSong();
	if song then
		group=song:GetGroupName();
		--[[
	elseif GetOpenGroupFolder() then
		group=GetOpenGroupFolder();
		--]]
	else
		-- [ja] SONG情報がない（初期値？） 
		local prf=PROFILEMAN:GetProfile(GAMESTATE:GetMasterPlayerNumber());
		if prf:GetLastPlayedSong() then
			group=prf:GetLastPlayedSong():GetGroupName();
		else
			group=SONGMAN:GetSongGroupNames()[1];
		end;
	end;
	return group;
end;

--[ja] フォルダパス(グループ名) 
function GetExFolderPath(group)
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini") then
		return "/Songs/"..group.."/";
	elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		return "/AdditionalSongs/"..group.."/";
	else
		return false;
	end;
end;

--[ja] group.iniを持っているか(グループ名) 
function HasGroupIni(group)
	local ret=false;
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini") 
		or FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		ret=true;
	else
		ret=false;
	end;
	return ret;
end;

--[==[
-- [ja] EXFolderに移動できる条件がそろっているか 
function ISChallEXFolder()
-- [ja] いいか、このコメントは有効にすると死んでしまう危険なスクリプトだ。 
-- 　　 絶対に触るんじゃないぞ…！テスト用に作った、
-- 　　 無条件でEXFolderが選択できるようになるとかそんなんじゃないからな…！
--[[
if true then
	return true;
end;
--]]
	if GAMESTATE:GetCurrentSong() then
		local EXF_EXFolder=getenv("EXF_EXFolder");
		if EXF_EXFolder[GetActiveGroupName()]
			and GAMESTATE:GetCurrentStageIndex()>=_MAXSTAGE() then
			local best_grade=GetStageState("Grade","Last","-");
			if best_grade<=2 then
				return true;
			else
				return false;
			end;
		else
			return false;
		end;
	end;
	return false
end;

function IsChallEXFolder()
	return ISChallEXFolder();
end;
--]==]

--[ja] 最後にプレイしたグループ 
local last_group="";
function SetEXFLastPlayedGroup()
  last_group='';
  local ss=STATSMAN:GetPlayedStageStats(1);
  if ss then
    local song=ss:GetPlayedSongs();
    if song then
      last_group=song[1]:GetGroupName();
    end;
  end;
end;
function GetEXFLastPlayedGroup()
  return last_group;
end;

-- [ja] 前ステージのグループフォルダでEXFolderに移動できる条件がそろっているか 
function IsChallEXFolder_LastGroup()
	local EXF_EXFolder=getenv("EXFList_Chk");
	if GAMESTATE:GetCurrentStageIndex()>=_MAXSTAGE() then
		if GetEXFLastPlayedGroup() then
		  if GetGroups(GetEXFLastPlayedGroup(),'exf') then
			local best_grade=GetStageState("Grade","Last","-");
			if best_grade<=2 then
			  return true;
			end;
		  end;
		end;
	end;
	return false;
end;

-- [ja] 現在開いているグループはEXFolderに移動できる条件がそろっているか 
function ISChallEXFolder_NowOpen()
	if GetGroups(GetActiveGroupName(),'exf')
		and GAMESTATE:GetCurrentStageIndex()>=_MAXSTAGE() then
		local best_grade=GetStageState("Grade","Last","-");
		if best_grade<=2 then
			return true;
		else
			return false;
		end;
	else
		return false;
	end;
end;

function IsChallEXFolder_NowOpen()
	return ISChallEXFolder_NowOpen();
end;

function IsChallEXFolder_Group(group)
	if GetGroups(group,'exf')
		and GAMESTATE:GetCurrentStageIndex()>=_MAXSTAGE() then
		local best_grade=GetStageState("Grade","Last","-");
		if best_grade<=2 then
			return true;
		else
			return false;
		end;
	else
		return false;
	end;
end;

-- [ja] EXFolderのライフ設定 
function EXFolderLifeSetting()
	if IsEXFolder() then
		local so;
		local exll;
		exll=GetEXFLife();
		if not GAMESTATE:IsEventMode() then
			local lf=0;
			if exll~="Normal" and exll~="Hard" and exll~="HardNoRecover" 
				and exll~="Ultimate" 
				and exll~="NoRecover" and exll~="Suddendeath" then
				if exll=="MFC" or exll=="PFC" or exll=="1" then
					life="1 life";
					lf=1;
				else
					lf=tonumber(exll);
					life=exll.." lives";
				end;
				so="faildefault,battery,"..life.."";
			elseif exll=="HardNoRecover" then
				so="bar,failimmediate,norecover";
			elseif exll=="NoRecover" then
				so="bar,failimmediate,norecover";
			elseif exll=="Suddendeath" then
				so="bar,failimmediate,suddendeath";
			else
				so="bar,failimmediate,normal-drain";
			end;
			opt=so;
			if GetSMVersion()>30 then
				-- [ja] b4のライフはバグでうまく設定されない 
				-- [ja] 150301 : CS8.5を参考に作り直し 
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					local ps=GAMESTATE:GetPlayerState(pn);
					local po;
					if lf>0 then
						po=ps:GetPlayerOptions('ModsLevel_Stage');
						po:LifeSetting('LifeType_Battery');
						po:BatteryLives(lf);
						po=ps:GetPlayerOptions('ModsLevel_Preferred');
						po:LifeSetting('LifeType_Battery');
						po:BatteryLives(lf);
					else
						if exll=="HardNoRecover" then
							po=ps:GetPlayerOptions('ModsLevel_Stage');
							po:DrainSetting('DrainType_NoRecover');
							po=ps:GetPlayerOptions('ModsLevel_Preferred');
							po:DrainSetting('DrainType_NoRecover');
						elseif exll=="NoRecover" then
							po=ps:GetPlayerOptions('ModsLevel_Stage');
							po:DrainSetting('DrainType_NoRecover');
							po=ps:GetPlayerOptions('ModsLevel_Preferred');
							po:DrainSetting('DrainType_NoRecover');
						elseif exll=="Suddendeath" then
							po=ps:GetPlayerOptions('ModsLevel_Stage');
							po:DrainSetting('DrainType_SuddenDeath');
							po=ps:GetPlayerOptions('ModsLevel_Preferred');
							po:DrainSetting('DrainType_SuddenDeath');
						else
							po=ps:GetPlayerOptions('ModsLevel_Stage');
							po:DrainSetting('DrainType_Normal');
							po=ps:GetPlayerOptions('ModsLevel_Preferred');
							po:DrainSetting('DrainType_Normal');
						end;
					end;
					MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} );
				end;
			else
				for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
					local ps = GAMESTATE:GetPlayerState(pn);
					local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..opt;
					ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
					ps:SetPlayerOptions('ModsLevel_Song', modstr);
				end;
				GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			end;
		elseif GetSMVersion()>30 then
		-- [ja] Beta4以降のイベントモードはこっち 
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				if GAMESTATE:IsPlayerEnabled(pn) then
					local ps=GAMESTATE:GetPlayerState(pn);
					if ps then
						local po=ps:GetPlayerOptions('ModsLevel_Preferred');
						po:FailSetting('FailType_Immediate');
						if exll~="Normal" and exll~="Hard" and exll~="HardNoRecover" 
							and exll~="Ultimate" 
							and exll~="NoRecover" and exll~="Suddendeath" then
							po:LifeSetting('LifeType_Battery');
							if exll=="MFC" or exll=="PFC" or exll=="1" then
								po:BatteryLives(1);
							else
								po:BatteryLives(tonumber(exll));
							end;
						elseif exll=="HardNoRecover" then
							po:LifeSetting('LifeType_Bar');
							po:DrainSetting('DrainType_NoRecover');
						elseif exll=="NoRecover" then
							po:LifeSetting('LifeType_Bar');
							po:DrainSetting('DrainType_NoRecover');
						elseif exll=="Suddendeath" then
							po:LifeSetting('LifeType_Bar');
							po:DrainSetting('DrainType_SuddenDeath');
						else
							po:LifeSetting('LifeType_Bar');
							po:DrainSetting('DrainType_Normal');
						end;
					end;
				end;
			end;
		else
		-- [ja] Beta3以前、EVENT Modeはこっち 
			GAMESTATE:ApplyGameCommand("mod,failarcade");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			if exll~="Normal" and exll~="Hard" and exll~="HardNoRecover" 
				and exll~="Ultimate" 
				and exll~="NoRecover" and exll~="Suddendeath" then
				GAMESTATE:ApplyGameCommand( "mod,battery");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				if exll=="MFC" or exll=="PFC" or exll=="1" then
					GAMESTATE:ApplyGameCommand( "mod,1lives");
					MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				else
					GAMESTATE:ApplyGameCommand( "mod,"..exll.."lives");
					MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				end;
			elseif exll=="HardNoRecover" then
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,norecover");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				SetEXFLife("Hard");
			elseif exll=="NoRecover" then
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,norecover");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				SetEXFLife("Normal");
			elseif exll=="Suddendeath" then
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,suddendeath");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			else
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,normal-drain");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			end;
		end;
	end;
end;

-- [ja] 現在のEXステージ数を返す（EXFolderモード専用） 
function ChkEXFStage()
	local exstage=0;
	if IsEXFolder() then
		-- [ja] Ex2選曲 
		if GetEXFState()=="Ex1Result" then
			exstage=2;
		-- [ja] Ex2ゲーム中からバック 
		elseif GetEXFState()=="Ex2GamePlay" and GetEXFType()=="Folder" then
			exstage=2;
		-- [ja] Ex2選曲中から多重読み込み 
		elseif GetEXFState()=="Ex2SelectMusic" then
			exstage=2;
		-- [ja] Ex1ゲーム中からバック 
		elseif GetEXFState()=="Ex1GamePlay" and GetEXFType()=="Folder" then
			exstage=1;
		-- [ja] Ex1選曲中から多重読み込み 
		elseif GetEXFState()=="Ex1SelectMusic" then
			exstage=1;
		-- [ja] その他 
		else
			if GAMESTATE:IsExtraStage2() then
				exstage=2;
			else
				exstage=1;
			end;
		end;
--[[
	else
		if GAMESTATE:IsExtraStage2() then
			exstage=2;
		else
			exstage=1;
		end;
--]]
	end;
	SetEXFStage(exstage);
	return exstage;
end;

--[ja] 平均ステータス 第2パラメータは取得する内容（平均/MAX/MIN/ラスト） 第3パラメータは以上/以下（and over/and under） 
--[[
	例：過去[MAXSTAGE]ステージの平均ダンスポイント（％）を求め、1P、2Pの高いほうを返す
	ret = GetStageState("pdp", "AVG", "+")

	例：過去[MAXSTAGE]ステージの最高コンボ数を求め、1P、2Pの低いほうを返す
	ret = GetStageState("Combo", "MAX", "-")

	例：最終ステージのグレードを求め、1P、2Pの低い（※グレードは低いほうが上位）ほうを返す
	ret = GetStageState("Grade", "Last", "-")
--]]
function GetStageState(prm,mode,overunder)
	--[ja] STAGE 1の時は取得不可能 
	if GAMESTATE:GetCurrentStageIndex()<1 then return 0 end;
	local chk_stat={0,0,"",""};	--[ja] 第二パラメータが数値の場合 
	local sprm=string.lower(prm);
	local smode=string.lower(mode);
	local chk_loop=((smode=="last") and 1 or _MAXSTAGE());
	if sprm=="grade" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local pss_grade=ss:GetPlayerStageStats(pn):GetGrade();
					local chk_var=grade[pss_grade];
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="dancepoints" or sprm=="dp" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):GetActualDancePoints();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="perdancepoints" or sprm=="pdp" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):GetPercentDancePoints();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="combo" or sprm=="maxcombo" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):MaxCombo();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="meter" then
	--[ja] Meterは#METERTYPEの値によって変わるのであまり使わないほうがいいかも 
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local steps=ss:GetPlayerStageStats(pn):GetPlayedSteps();
					local chk_var=steps[#steps]:GetMeter();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="combo" or sprm=="maxcombo" then
		for p=1,2 do
			local pn=((p==1) and PLAYER_1 or PLAYER_2);
			for i=1,chk_loop do
			local ss=STATSMAN:GetPlayedStageStats(i);
				if GAMESTATE:IsPlayerEnabled(pn) then
					local chk_var=ss:GetPlayerStageStats(pn):MaxCombo();
					if i==1 then
						chk_stat[p]=chk_var
					elseif smode=="max" then
						if chk_var>chk_stat[p] then chk_stat[p]=chk_var end;
					elseif smode=="min" then
						if chk_var<chk_stat[p] then chk_stat[p]=chk_var end;
					else
						chk_stat[p]=chk_stat[p]+chk_var;
					end;
				end;
			end;
			if smode=="avg" then chk_stat[p]=chk_stat[p]/chk_loop end;
		end;
	elseif sprm=="song" then
	-- [ja] Last か Playのみ使用可能（未指定・不正の場合Play） 
	-- [ja] ステージ数 or 0を返す 
		local songs=STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
		for i=#songs-_MAXSTAGE()+1,#songs do
			local ssong=string.lower(songs[i]:GetSongDir());
			if string.find(ssong,smode,0,true) then
				return i-(#songs-_MAXSTAGE());
			end;
		end;
		return 0;
	end;
	if not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		return chk_stat[1];
	elseif not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		return chk_stat[2];
	elseif string.lower(overunder)=="over" or overunder=="+" then
		return ((chk_stat[1]>=chk_stat[2]) and chk_stat[1] or chk_stat[2]);
	elseif string.lower(overunder)=="under" or overunder=="-" then
		return ((chk_stat[1]<=chk_stat[2]) and chk_stat[1] or chk_stat[2]);
	else
		return (chk_stat[1]+chk_stat[2])/2;
	end;
end;

-- [ja] group.iniから任意の値を取得 (グループ名,パラメータ名) 
function GetGroupParameter(group,prm)
	local gpath=GetGroupParameter_Path(group);
	if gpath~="" then
		local f=RageFileUtil.CreateRageFile();
		f:Open(gpath,1);
		local tmp=GetSMParameter_f(f,prm);
		f:Close();
		f:destroy();
		return tmp;
	else
		return "";
	end;
end;
-- [ja] group.iniのパスを取得 
function GetGroupParameter_Path(group)
	local gpath;
	if FILEMAN:DoesFileExist("/Songs/"..group.."/group.ini")  then
		gpath="/Songs/"..group.."/group.ini";
	elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/group.ini") then
		gpath="/AdditionalSongs/"..group.."/group.ini";
	else
		return "";
	end;
	return gpath;
end;

-- [ja] MenuColorのような楽曲単位で指定できるパラメータの取得 
function GetGroupParameterEx(song,prm)
	if not song then
		return '';
	end;
	local data = GetGroupParameter(song:GetGroupName(),prm);
	if data == '' then
		return '';
	end;
	-- [ja] この時点で #XXX:YYY;
	local ret = '';
	local folder = string.lower(GetSong2Folder(song));
	local spl_data = split(':', data);
	local def = '';
	for i=1, #spl_data do
		local spl_spl_data = split('|', spl_data[i]);
		if i==1 then
			-- [ja] デフォルト定義
			def = spl_spl_data[1];
		end;
		if #spl_data > 1 then
			-- [ja] フォルダ指定あり
			for j=2, #spl_spl_data do
				if folder == string.lower(spl_spl_data[j]) then
					-- [ja] チェック対象フォルダが見つかった
					ret = spl_spl_data[1];
					break;
				end;
			end;
		end;
	end;
	if ret == '' then
		-- [ja] 定義がない場合はデフォルトを返却
		ret = def;
	end;
	return ret;
end;

function IsPopupExDialog()
	local angou={};
	angou["20"]=" "; angou["21"]="!"; angou["22"]="\"";angou["23"]="#"; angou["24"]="$"; angou["25"]="%"; angou["26"]="&"; angou["27"]="\'";
	angou["28"]="("; angou["29"]=")"; angou["2A"]="*"; angou["2B"]="+"; angou["2C"]=","; angou["2D"]="-"; angou["2E"]="."; angou["2F"]="/";
	angou["30"]="0"; angou["31"]="1"; angou["32"]="2"; angou["33"]="3"; angou["34"]="4"; angou["35"]="5"; angou["36"]="6"; angou["37"]="7";
	angou["38"]="8"; angou["39"]="9"; angou["3A"]=":"; angou["3B"]=";"; angou["3C"]="<"; angou["3D"]="="; angou["3E"]=">"; angou["3F"]="?";
	angou["40"]="@"; angou["41"]="A"; angou["42"]="B"; angou["43"]="C"; angou["44"]="D"; angou["45"]="E"; angou["46"]="F"; angou["47"]="G";
	angou["48"]="H"; angou["49"]="I"; angou["4A"]="J"; angou["4B"]="K"; angou["4C"]="L"; angou["4D"]="M"; angou["4E"]="N"; angou["4F"]="O";
	angou["50"]="P"; angou["51"]="Q"; angou["52"]="R"; angou["53"]="S"; angou["54"]="T"; angou["55"]="U"; angou["56"]="V"; angou["57"]="W";
	angou["58"]="X"; angou["59"]="Y"; angou["5A"]="Z"; angou["5B"]="["; angou["5C"]="\\";angou["5D"]="]"; angou["5E"]="^"; angou["5F"]="_";
	angou["60"]="`"; angou["61"]="a"; angou["62"]="b"; angou["63"]="c"; angou["64"]="d"; angou["65"]="e"; angou["66"]="f"; angou["67"]="g";
	angou["68"]="h"; angou["69"]="i"; angou["6A"]="j"; angou["6B"]="k"; angou["6C"]="l"; angou["6D"]="m"; angou["6E"]="n"; angou["6F"]="o";
	angou["70"]="p"; angou["71"]="q"; angou["72"]="r"; angou["73"]="s"; angou["74"]="t"; angou["75"]="u"; angou["76"]="v"; angou["77"]="w";
	angou["78"]="x"; angou["79"]="y"; angou["7A"]="z"; angou["7B"]="{"; angou["7C"]="|"; angou["7D"]="}"; angou["7E"]="~"; angou["7F"]="waiei";
	local EXF_Dialog={};
	setenv("EXF_Dialog",nil);
	ChkEXFStage();
	local ret=false;
	local exstage=GetEXFStage();
	local group=GetEXFGroupName();
	local dialog=GetGroupParameter(group,"Extra"..exstage.."Dialog");
	if group~="" and dialog~="" then
		ret=true;
		local dialog_list=split(":",dialog);
		for d=1,#dialog_list do
			local prm=split("|",dialog_list[d]);
			local lprm=split("|",string.lower(dialog_list[d]));
			prm[1]=string.gsub(prm[1],"\\\\","|");
			prm[1]=string.gsub(prm[1],"\\n","\n");
			prm[1]=string.gsub(prm[1],"|","\\");
			for a=0x20,0x7F do
				local x=string.upper(string.format("%02x",a));
				prm[1]=string.gsub(prm[1],"%["..x.."%]",angou[""..x]);
			end;
			EXF_Dialog["Text"]=prm[1];
			local urlT=nil;
			local urlA=nil;
			if #prm>2 then
				for i=2,#prm do
					local prm2=split(">",prm[i]);
					local lprm2=split(">",string.lower(prm[i]));
					if #prm2>1 then
						if lprm2[1]=="type" then
							if lprm2[2]=="select" then
								EXF_Dialog["Type"]="Select";
							else
								EXF_Dialog["Type"]="Normal";
							end;
						elseif lprm2[1]=="urltype" then
							urlT=prm2[2];
						elseif lprm2[1]=="urladdress" then
							urlA=prm2[2];
						elseif #prm2>2 then
							-- [ja] 条件付き 
							local chkN={};
							local chkS="";
							local ss=STATSMAN:GetCurStageStats();
							local pss={nil,nil};
							if ss then
								pss[1]=ss:GetPlayerStageStats(EXF_GetSidePlayer(PLAYER_1));
								pss[2]=ss:GetPlayerStageStats(EXF_GetSidePlayer(PLAYER_2));
								if pss[1] then
									if lprm2[1]=="pdp" or lprm2[1]=="perdancepoints" then	-- [ja] ダンスポイント（%） 
										chkN[1]=pss[1]:GetPercentDancePoints()*100;
										chkN[2]=pss[2]:GetPercentDancePoints()*100;
									elseif lprm2[1]=="dp" or lprm2[1]=="dancepoints" then	-- [ja] ダンスポイント（数値） 
										chkN[1]=pss[1]:GetPossibleDancePoints();
										chkN[2]=pss[2]:GetPossibleDancePoints();
									elseif lprm2[1]=="combo" or lprm2[1]=="maxcombo" then	-- [ja] MAXコンボ  
										chkN[1]=pss[1]:MaxCombo();
										chkN[2]=pss[2]:MaxCombo();
									elseif lprm2[1]=="meter" then	-- [ja] 難易度 
										local st={nil,nil};
										st[1]=GAMESTATE:GetCurrentSteps(EXF_GetSidePlayer(PLAYER_1));
										st[2]=GAMESTATE:GetCurrentSteps(EXF_GetSidePlayer(PLAYER_2));
										if st[1] then
											chkN[1]=st[1]:GetMeter();
											chkN[2]=st[2]:GetMeter();
										end;
									elseif lprm2[1]=="grade" then	-- [ja] グレード 
										chkN[1]=grade[pss[1]:GetGrade()];
										chkN[2]=grade[pss[2]:GetGrade()];
									elseif lprm2[1]=="song" then	-- [ja] 曲（フォルダ名 ） 
										local song=GAMESTATE:GetCurrentSong();
										if song then
											chkS=EXF_GetSong2Folder(song);
										end;
									end;
									if lprm2[1]=="song" then
										-- [ja] 指定楽曲を 
										if prm2[3]=="+" or prm2[3]=="over" then
											-- [ja] プレイしたか 
											if chkS==prm2[2] then
												ret=true;
											else
												ret=false;
											end;
										else
											-- [ja] プレイしていないか 
											if chkS~=prm2[2] then
												ret=true;
											else
												ret=false;
											end;
										end;
									else
										-- [ja] 指定項目が 
										if prm2[3]=="+" or prm2[3]=="over" then
											-- [ja] ある数値以上か 
											local chk=(chkN[1]>=chkN[2]) and chkN[1] or chkN[2];
											if chk>=tonumber(prm2[2]) then
												ret=true;
											else
												ret=false;
											end;
										else
											-- [ja] ある数値以下か 
											local chk=(chkN[1]<=chkN[2]) and chkN[1] or chkN[2];
											if chk<=tonumber(prm2[2]) then
												ret=true;
											else
												ret=false;
											end;
										end;
									end;
								end;
							end;
						end;
					end;
					if not ret then
						-- [ja] 一つでも条件を満たしていなければアウト 
						break;
					end;
				end;
			end;
			if ret then
				if urlA then
					for a=0x20,0x7F do
						local x=string.upper(string.format("%02x",a));
						urlA=string.gsub(urlA,"%["..x.."%]",angou[""..x]);
					end;
					if not urlT then
						urlT="http";
					end;
					EXF_Dialog["Url"]=urlT.."://"..urlA;
				end;
				setenv("EXF_Dialog",EXF_Dialog);
				break;
			else
				EXF_Dialog={};
				setenv("EXF_Dialog",nil);
			end;
		end;
	end;
	return ret;
end;


-- [ja] 左側1P、右側2Pとする処理の場合そのプレイヤーが存在するかどうか 
-- [ja] もし存在しない場合は反対側のプレイヤーを返す 
function EXF_GetSidePlayer(player)
	if player==PLAYER_1 then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
			return PLAYER_1;
		else
			return PLAYER_2;
		end;
	else
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
			return PLAYER_2;
		else
			return PLAYER_1;
		end;
	end;
	return PLAYER_1;
end;

--[ja] song型からフォルダ名を返す  
function EXF_GetSong2Folder(song)
	if song then
		local _t=split("/",song:GetSongDir())
		return _t[#_t-1];
	end;
	return "";
end;
--[ja] フォルダ名からSong型を返す 
function EXF_GetFolder2Song(group,folder)
	local gsongs=SONGMAN:GetSongsInGroup(group);
	for i=1,#gsongs do
		if string.find(string.lower(gsongs[i]:GetSongDir()),"/"..string.lower(folder).."/",0,true) then
			return gsongs[i];
		end;
	end;
	return false;
end;