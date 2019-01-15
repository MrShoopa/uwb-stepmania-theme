--[ja] ボスフォルダ関係の命令 
--[[
	EXF_ScreenTitleMenu_background();
	EXF_ScreenSelectMusic_decorations();
	EXF_ScreenStageInformation_underlay();
	EXF_ScreenGameplay();
	EXF_ScreenEvaluation();
--]]

__EXFBASE__=true;

-- [ja] キー操作
local function _GAME()
	return string.lower(GAMESTATE:GetCurrentGame():GetName());
end
function EXFolderIntroCode()
	if _GAME()~="pump" then
		return "Start,Back,Back,Left,Left2=Left,Right,Right2=Right,Up,Up2=Up,Down,Down2=Down,EffectUp,EffectDown";
	else
		return "Start,Back,Back,Center=Start,Left,Left3=Left,Right,Right3=Right,Up,Up3=Up,Down,Down3=Down,EffectUp,EffectDown";
	end;
end;
function SelectExMusicCode()
	if _GAME()~="pump" then
		return "Start,Back,BackRelease,Left,Left2=Left,Right,Right2=Right,Up,Up2=Up,Down,Down2=Down";
	else
		return "Start,Back,BackRelease,Center=Start,Left,Left3=Left,Right,Right3=Right,Up,Up3=Up,Down,Down3=Down";
	end;
end;
function DialogCode()
	if _GAME()~="pump" then
		return "Start,Back,Left,Left2=Left,Right,Right2=Right";
	else
		return "Start,Back,Left,Left3=Left,Left4=Left,Right,Right3=Right,Right4=Right,Center=Start";
	end;
end;

-- [ja] EXFolderに移ってから操作可能になるまでの時間 
function EXF_BEGIN_WAIT()
	return 0.5;
end;

function EXF_ScreenTitleMenu()
	return Def.Actor{
		InitCommand=cmd(visible,false);
		OnCommand=function(self)
			EXF_ScreenTitleMenu_On();
		end;
	};
end;

local EXFList_Chk={};	-- [ja] Extra1Listが存在するか記録しておく 
function EXF_ScreenTitleMenu_On()
	-- [ja] ExFolderの設定が残っている場合削除 
	if IsEXFolder() then
		KillEXFolder();
	end;
end;

function EXF_ScreenSelectMusic()
	return Def.Actor{
		InitCommand=function(self)
			local groups=SONGMAN:GetSongGroupNames();
			for g=1,#groups do
				if HasGroupIni(groups[g]) then
					if GetGroupParameter(groups[g],"extra1list")~="" then
						EXFList_Chk[groups[g]]=true;
					else
						EXFList_Chk[groups[g]]=false;
					end;
				end;
			end;
			setenv("EXFList_Chk",EXFList_Chk);
		end;
		BeginCommand=function(self)
			EXF_ScreenSelectMusic_Begin();
		end;
	};
end;

function EXF_ScreenSelectMusic_Begin()
	if not GAMESTATE:IsCourseMode() then
		if GAMESTATE:GetCurrentStageIndex()<1 then
			KillEXFolder();
			SetEXFStage(0);

		-- [ja] 強制EX2専用フォルダ 
		elseif GetEXFState()=="Ex1Result"
			and GetGroupParameter(GetEXFGroupName(),"Extra2List")~="" then
			SetEXFState("Ex2SelectMusic");
			SCREENMAN:SetNewScreen("ScreenEXFolderIntro");

		elseif GetEXFState()=="Ex1GamePlay" and GetEXFType()=="Folder" then
			SetEXFState("Ex1SelectMusic");
			SCREENMAN:SetNewScreen("ScreenSelectExMusic");

		elseif GetEXFState()=="Ex2GamePlay" and GetEXFType()=="Folder" then
			SetEXFState("Ex2SelectMusic");
			SCREENMAN:SetNewScreen("ScreenSelectExMusic");

		elseif GetEXFGroupName()~="" then
			KillEXFolder();
			SetEXFStage(0);
		end;
	else
		KillEXFolder();
		SetEXFStage(0);
	end;
end;

function EXF_ScreenStageInformation()
	return Def.Actor{
		InitCommand=function(self)
			EXF_ScreenStageInformation_Init();
		end;
	};
end;
function EXF_ScreenStageInformation_Init()
	if GAMESTATE:IsAnExtraStage()
		and not IsEXFolder() then
		if GAMESTATE:GetPreferredSongGroup() == "---Group All---" then
			local song = GAMESTATE:GetCurrentSong()
			GAMESTATE:SetPreferredSongGroup( song:GetGroupName() )
		end

		local bExtra2 = GAMESTATE:IsExtraStage2()
		local style = GAMESTATE:GetCurrentStyle()
		local song, steps = SONGMAN:GetExtraStageInfo( bExtra2, style )
		local po, so;
		local f=OpenFile("/Songs/"..GetActiveGroupName().."/extra"..(bExtra2 and "2" or "1")..".crs");
		if not f then
			f=OpenFile("/AdditionalSongs/"..GetActiveGroupName().."/extra"..(bExtra2 and "2" or "1")..".crs");
		end;
		if f then
			local opt=split(":",GetFileParameter(f,"song"))[3];
			local opt=string.lower(opt);
			local life=GetFileParameter(f,"lives");
			local lf=0;
			local exll="Normal";
			if bExtra2 then
				if life=="" or life=="1" then
					life="1 life";
					lf=1;
				else
					lf=tonumber(life);
					life=""..life.." lives";
				end;
			else
				if life=="" then
					life="4 lives";
					lf=4;
				elseif life=="1" then
					life="1 life";
					lf=1;
				else
					lf=tonumber(life);
					life=""..life.." lives";
				end;
			end;
			if string.find(opt,"battery",0,true) then
				so="faildefault,battery,"..life.."";
			elseif string.find(opt,"norecover",0,true) then
				so="bar,failimmediate,norecover";
				exll="NoRecover";
			elseif string.find(opt,"suddendeath",0,true) then
				so="bar,failimmediate,suddendeath";
				exll="Suddendeath";
			else
				so="bar,failimmediate,normal-drain";
			end;
			opt=string.gsub(opt,",",", ");
			CloseFile(f);
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				local ps = GAMESTATE:GetPlayerState(pn);
				local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred")..", "..opt;
				ps:SetPlayerOptions("ModsLevel_Preferred", modstr);
				ps:SetPlayerOptions('ModsLevel_Song', modstr);
			end;
			GAMESTATE:SetSongOptions( "ModsLevel_Stage", so );
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			if GetSMVersion()>30 then
				-- [ja] b4のライフはバグでうまく設定されない 
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
						if exll=="NoRecover" then
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
			end;
			so=nil;
		else
			if bExtra2 then
				po = THEME:GetMetric("SongManager","OMESPlayerModifiers");
				so = THEME:GetMetric("SongManager","OMESStageModifiers");
			else
				po = THEME:GetMetric("SongManager","ExtraStagePlayerModifiers");
				so = THEME:GetMetric("SongManager","ExtraStageStageModifiers");
			end;
		end;
		
		if po or so then
			local difficulty = steps:GetDifficulty()
			local Reverse = PlayerNumber:Reverse()

			GAMESTATE:SetCurrentSong( song )
			GAMESTATE:SetPreferredSong( song )

			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				GAMESTATE:SetCurrentSteps( pn, steps )
				GAMESTATE:GetPlayerState(pn):SetPlayerOptions( "ModsLevel_Stage", po )
				GAMESTATE:SetPreferredDifficulty( pn, difficulty )
				MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
			end
			GAMESTATE:SetSongOptions( "ModsLevel_Stage", so )
			MESSAGEMAN:Broadcast( "SongOptionsChanged" )
		end;
	elseif GetEXFState()=="Ex1GamePlay" or GetEXFState()=="Ex2GamePlay" then
		if GetSMVersion()<=30 then
			-- [ja] 強制的に現在の設定を反映させることでEXステージでもプレイヤーオプションが初期化されない 
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				local ps = GAMESTATE:GetPlayerState(pn);
				local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Stage");
				ps:SetPlayerOptions("ModsLevel_Stage", modstr);
				MESSAGEMAN:Broadcast( "PlayerOptionsChanged", {PlayerNumber = pn} )
			end;
		end;
		EXFolderLifeSetting();
	end;
end;

local failed_chk=false;
function EXF_ScreenGameplay()
	local function updateEXFGame(self,dt)
		if IsEXFolder() then
			local live={GAMESTATE:IsPlayerEnabled(PLAYER_1),
						GAMESTATE:IsPlayerEnabled(PLAYER_2)};
			for p=1,2 do
				if live[p] then
					local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats('PlayerNumber_P'..p);
					if pss then
						live[p]=(pss:GetCurrentLife()>0);
					end;
				end;
			end;
			if not failed_chk and not live[1] and not live[2] then
				failed_chk=true;
				local BGorBS=false;
				for p=1,2 do
					if not BGorBS and GAMESTATE:IsPlayerEnabled('PlayerNumber_P'..p) then
						local dif=GAMESTATE:GetCurrentSteps('PlayerNumber_P'..p):GetDifficulty();
						if dif==Difficulty[1] or dif==Difficulty[2] then
							BGorBS=true;
						end;
					end;
				end;
				if BGorBS then
					SCREENMAN:GetTopScreen():PostScreenMessage('SM_Pause', 0.5);
					SCREENMAN:GetTopScreen():PostScreenMessage('SM_BeginFailed', 0.5);
				end;
			end;
		end;
	end;
	return Def.ActorFrame{
		InitCommand=cmd(SetUpdateFunction,updateEXFGame);
		OnCommand=function(self)
			EXF_ScreenGameplay_On();
		end;
		OffCommand=function(self)
			EXF_ScreenGameplay_Off();
		end;
	};
end;

function EXF_ScreenGameplay_On()
	failed_chk=false;
	if GetEXFState()=="Ex1GamePlay" then
		SetEXFStage(1);
	elseif GetEXFState()=="Ex2GamePlay" then
		SetEXFStage(2);
	else
		SetEXFStage(0);
	end;
end;

function EXF_ScreenGameplay_Off()
	if GetEXFGroupName()~="" then
		SetEXFLife("Normal");
	end;
end;

function EXF_ScreenEvaluation()
	return Def.Actor{
		OffCommand=function(self)
			EXF_ScreenEvaluation_Off();
		end;
	};
end;

function EXF_ScreenEvaluation_Off()
	if IsEXFolder() then
		local chk_grade=false;
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
			local player_grade=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetGrade();
			if player_grade=="Grade_Tier01" or player_grade=="Grade_Tier02"
				or player_grade=="Grade_Tier03" then
				chk_grade=true;
			end;
		end;
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
			local player_grade=STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetGrade();
			if player_grade=="Grade_Tier01" or player_grade=="Grade_Tier02"
				or player_grade=="Grade_Tier03" then
				chk_grade=true;
			end;
		end;

		if GetEXFState()=="Ex1GamePlay" and chk_grade then
			if GetSMVersion()>30 then
			-- [ja] Beta4以降はこっち 
				for p=1,2 do
					local pn=(p==1) and PLAYER_1 or PLAYER_2;
					if GAMESTATE:IsPlayerEnabled(pn) then
						local ps=GAMESTATE:GetPlayerState(pn);
						if ps then
							local po=ps:GetPlayerOptions('ModsLevel_Preferred');
							po:BatteryLives(4);
							po:LifeSetting('LifeType_Bar');
							po:DrainSetting('DrainType_Normal');
						end;
					end;
				end;
			else
				GAMESTATE:ApplyGameCommand( "mod,4 lives");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,normal-drain");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			end;
			SetEXFState("Ex1Result");
			--setenv("ExGroupName",GetActiveGroupName());
		elseif GetEXFState()=="Ex2GamePlay" or GetEXFState()=="Ex1GamePlay" then
			if GetSMVersion()>30 then
			-- [ja] Beta4以降はこっち 
				for p=1,2 do
					local pn=(p==1) and PLAYER_1 or PLAYER_2;
					if GAMESTATE:IsPlayerEnabled(pn) then
						local ps=GAMESTATE:GetPlayerState(pn);
						if ps then
							local po=ps:GetPlayerOptions('ModsLevel_Preferred');
							po:BatteryLives(4);
							po:LifeSetting('LifeType_Bar');
							po:DrainSetting('DrainType_Normal');
						end;
					end;
				end;
			else
				GAMESTATE:ApplyGameCommand( "mod,4 lives");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,bar");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
				GAMESTATE:ApplyGameCommand( "mod,normal-drain");
				MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			end;
			KillEXFolder();
		else
		--[ja] ExFolder以外の場合、意図的にバッテリーライフにしている可能性があるので初期化しない 
		--[[
			GAMESTATE:ApplyGameCommand( "mod,bar");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
			GAMESTATE:ApplyGameCommand( "mod,normal-drain");
			MESSAGEMAN:Broadcast( "SongOptionsChanged" );
		--]]
			KillEXFolder();
		end;
	end;
end;

function EXF_ScreenEvaluation_Background(act,flag)
	return EXF_Evaluation_Background(act,flag,0.3);
end;
function EXF_Evaluation_Background(act,flag,dark)
	local t = Def.ActorFrame {};
	if not GAMESTATE:IsCourseMode() then
		local group=GAMESTATE:GetCurrentSong():GetGroupName();
		local stage=""..GetEXFStage();
		local resultbackground=GetGroupParameter(group,"extra"..stage.."resultbackground");
		if stage=="0" or
			(stage=="1" and resultbackground=="") or
			(stage=="2" and resultbackground=="") then
			local bg=GetGroupParameter(group,"earnedextrabackground");
			if GAMESTATE:HasEarnedExtraStage() and bg~="" then
				local fn=split("%.",bg);
				if bg~="" and FILEMAN:DoesFileExist("/Songs/"..group.."/"..bg)  then
					t[#t+1] = Def.ActorFrame{
						InitCommand=function(self)
							if string.lower(fn[#fn])~="lua" then self:Center(); end;
						end;
						LoadActor("/Songs/"..group.."/"..bg);
					};
				elseif bg~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/"..bg) then
					t[#t+1] = Def.ActorFrame{
						InitCommand=function(self)
							if string.lower(fn[#fn])~="lua" then self:Center(); end;
						end;
						LoadActor("/AdditionalSongs/"..group.."/"..bg);
					};
				end;
				t[#t+1] = Def.Quad{
					InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
					OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,dark);
				};
			else
				if flag then
					t[#t+1]=act;
				else
					t[#t+1] = Def.ActorFrame{
						LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"));
					};
				end;
			end;
		elseif (stage=="1" and resultbackground=="*") or
			(stage=="2" and resultbackground=="*") then
			t[#t+1] = Def.ActorFrame{
				LoadActor(THEME:GetPathB("ScreenSelectExMusic","background"));
			};
			t[#t+1] = Def.Quad{
				InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
				OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,dark);
			};
		else
			local bg=resultbackground;
			local fn=split("%.",bg);
			if bg~="" and FILEMAN:DoesFileExist("/Songs/"..group.."/"..bg)  then
				t[#t+1] = Def.ActorFrame{
					InitCommand=function(self)
						if string.lower(fn[#fn])~="lua" then self:Center(); end;
					end;
					LoadActor("/Songs/"..group.."/"..bg);
				};
			elseif bg~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/"..bg) then
				t[#t+1] = Def.ActorFrame{
					InitCommand=function(self)
						if string.lower(fn[#fn])~="lua" then self:Center(); end;
					end;
					LoadActor("/AdditionalSongs/"..group.."/"..bg);
				};
			end;
			t[#t+1] = Def.Quad{
				InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
				OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,dark);
			};
		end;
	else
		if flag then
			t[#t+1]=act;
		else
			t[#t+1] = Def.ActorFrame{
				LoadActor(THEME:GetPathB("ScreenSelectExMusic","background"));
			};
		end;
	end;
	return t;
end;

-- [ja] EXF_LifeMeterXX は Drillモード実装のため 91 Life.lua に移動 
