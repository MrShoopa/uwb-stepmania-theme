InitDrillCategory();

-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_key=false;

local t=Def.ActorFrame{};
-- [ja] サウンドとキー操作　
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		if GAMESTATE:GetNumPlayersEnabled()>1 then
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		end;
		SOUND:PlayAnnouncer("-waiei ScreenSelectDrillCategory intro");
		self:sleep(0.5);
		self:queuecommand("KeyUnLock");
	end;
	KeyUnLockCommand=function(self)
		sys_key=true;
	end;
	CodeCommand=function(self,params)
		if sys_key and GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
			local p=(params.PlayerNumber==PLAYER_1) and 1 or 2;
			if params.Name == 'BackD' then
				key_back=true;
				self:playcommand("Back");
			elseif params.Name=="BackU" then
				key_back=false;
				self:playcommand("Back");
			elseif params.Name=="Start" then
				sys_key=false;
				MESSAGEMAN:Broadcast("Off");
			elseif params.Name == 'Left' and CntDRFile()>0 then
				SetSelDrillCategoryR(-1);
				local tbl={Scroll="Left"};
				MESSAGEMAN:Broadcast("Set",tbl);
			elseif params.Name == 'Right' and CntDRFile()>0 then
				SetSelDrillCategoryR(1);
				local tbl={Scroll="Right"};
				MESSAGEMAN:Broadcast("Set",tbl);
			elseif params.Name=="Select" then
				setenv("DrillOptions_Return","ScreenSelectDrillCategory");
				SCREENMAN:AddNewScreenToTop("ScreenDrillOptions");
			end;
		end;
	end;
	BackCommand=function(self)
		self:finishtweening();
		if key_back then
			self:sleep(0.5);
			self:queuecommand("Cancel");
		end;
	end;
	CancelCommand=function(self)
		if sys_key then
			sys_key=false;
			self:finishtweening();
			SCREENMAN:GetTopScreen():Cancel();
		end;
	end;
	OffMessageCommand=function(self)
		sys_key=false;
		if CntDRFile()<1 then
			KillDrill();
			SCREENMAN:GetTopScreen():Cancel();
		else
			-- [ja] ここで選択したカテゴリーのドリルレベルを読み込み 
			ReadDrillData();
			SOUND:PlayAnnouncer("-waiei ScreenSelectDrillCategory comment");
			if GetDRInfo("Level")<1 then
				self:sleep(1.0);
				self:queuecommand("ReStartScreen");
			else
				SetSelDrillLevel(1);
				self:sleep(1.0);
				self:queuecommand("NextScreen");
			end;
		end;
	end;
	ReStartScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectDrillCategory");
	end;
	NextScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
		OffMessageCommand=function(self,params)
			self:queuecommand("Play");
		end;
		PlayCommand=function(self)
			self:stop();
			self:play();					
		end;
	};
	LoadActor(THEME:GetPathS("Common","value")) .. {
		PlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
		SetMessageCommand=function(self,params)
			if params then
				if params.Scroll=="Left" or params.Scroll=="Right" then
					self:queuecommand("Play");
				end;
			end;
		end;
		PlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
};

--[===[
-- [ja] 情報読み込み 
local drFile={};
local drInfo={};
drFile=getenv("drFile");
drInfo=getenv("drInfo");

-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_key=false;
-- [ja] キャンセルボタンを押し続けているか確認用変数 
local sys_backcnt=0;
-- [ja] 決定ボタンを押してからの時間確認用変数 
local sys_startcnt=0;
-- [ja] 現在選択中の番号（1～数） 
local sys_seldrill;
	if getenv("sys_seldrill") then
		sys_seldrill=getenv("sys_seldrill");
	else
		sys_seldrill=1;
	end;
	setenv("sys_seldrill",sys_seldrill);

setenv("sys_selected",false); -- [ja] 決定ボタン押下時 
setenv("sys_move","nil");
local sys_offcommand=false;	-- [ja] OffCommand実行時にtrue

local snd_cancel=false;
local snd_start=false;
local snd_chgdrill=false

local t=Def.ActorFrame{};
-- [ja] サウンドとキー操作　
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		if GAMESTATE:GetNumPlayersEnabled()>1 then
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		end;
		SOUND:PlayAnnouncer("-waiei ScreenSelectDrillCategory intro");
		self:sleep(EXF_BEGIN_WAIT()+0.5);
		self:queuecommand("KeyUnLock");
	end;
	KeyUnLockCommand=function(self)
		sys_key=true;
	end;
	CodeCommand=function(self,params)
		if sys_key and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
			local p=(params.PlayerNumber==PLAYER_1) and 1 or 2;
			setenv("sys_move","nil");
			if params.Name == 'BackD' then
				if sys_startcnt==0 and sys_backcnt==0 then
					sys_backcnt=20;
				end;
			elseif params.Name=="BackU" and sys_backcnt>0 then
				sys_backcnt=0;
			elseif params.Name=="Start" and not sys_offcommand then
				setenv("sys_selected",true);
				snd_start=true;
			elseif params.Name == 'Left' and sys_startcnt==0 then
				sys_seldrill=sys_seldrill-1;
				if sys_seldrill<1 then
					sys_seldrill=#drFile;
				end;
				setenv("sys_seldrill",sys_seldrill);
				if #drFile>0 then
					snd_chgdrill=true;
					setenv("sys_move","right");
				end;
			elseif params.Name == 'Right' and sys_startcnt==0 then
				sys_seldrill=sys_seldrill+1;
				if sys_seldrill>#drFile then
					sys_seldrill=1;
				end;
				if #drFile>0 then
					snd_chgdrill=true;
					setenv("sys_move","left");
				end;
				setenv("sys_seldrill",sys_seldrill);
			elseif params.Name=="Select" and not sys_offcommand then
				setenv("DrillOptions_Return","ScreenSelectDrillCategory");
				SCREENMAN:AddNewScreenToTop("ScreenDrillOptions");
			end;
		end;
	end;
	OffCommand=function(self)
		sys_key=false;
		if #drFile<1 then
			KillDrill();
			SCREENMAN:GetTopScreen():Cancel();
		else
		--[[
			ここでドリルデータの読み込み 
		--]]
			ReadDrillData(drFile[sys_seldrill],drInfo);
			drInfo=getenv("drInfo");
			SOUND:PlayAnnouncer("-waiei ScreenSelectDrillCategory comment");
			if drInfo["Level"]<1 then
				self:sleep(1.0);
				self:queuecommand("ReStartScreen");
			else
				self:sleep(1.0);
				self:queuecommand("NextScreen");
			end;
		end;
	end;
	NextScreenCommand=function(self)
		setenv("sys_seldrill",sys_seldrill);
		SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
	end;
	ReStartScreenCommand=function(self)
		setenv("sys_sellevel",1);
		SCREENMAN:SetNewScreen("ScreenSelectDrillCategory");
	end;
	Def.Actor{
		SetCommand=function(self)
			setenv("sys_sellevel",1);
		end;
	};
};
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X+_HS2);
		self:y(SCREEN_CENTER_Y);
		self:diffuse(Color("White"));
		self:strokecolor(waieiColor("Text"));
		self:settext("");
	end;
	OnCommand=function(self)
		if #drFile>0 then
			self:settext("");
		else
			self:settext(THEME:GetString("ScreenSelectDrillCategory","Missing"));
		end;
	end;
};
-- [ja] 決定 
t[#t+1] = LoadActor(THEME:GetPathS("Common","start")) .. {
	Name="SND_START";
	PlayCommand=function(self)
		self:stop();
		self:play();
		snd_start=false;					
	end;
};
t[#t+1] = LoadActor(THEME:GetPathS("Common","value")) .. {
	Name="SND_CHGDIF";
	PlayCommand=function(self)
		self:stop();
		self:play();
		snd_chgdif=false;
	end;
};
t[#t+1] = LoadActor(THEME:GetPathS("Common","Cancel")) .. {
	Name="SND_CANCEL";
	PlayCommand=function(self)
		self:stop();
		--self:play();
		snd_cancel=false;
		KillDrill();
		SCREENMAN:GetTopScreen():Cancel();
	end;
};
t[#t+1] = LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
	Name="SND_CHGSONG";
	PlayCommand=function(self)
		self:stop();
		self:play();
		snd_chgdrill=false;
	end;
};

local oTime=0;
local nTime=oTime;
local m=PREFSMAN:GetPreference("MenuTimer");
local mTimer=tonumber(THEME:GetMetric("ScreenSelectDrillCategory","TimerSeconds"));
local wait=1.0/60;
local function update(self,dt)
	nTime=nTime+dt;
	if m and (mTimer-nTime)<=0 and not sys_offcommand then
		snd_start=true;
		setenv("sys_selected",true);
	end;
	-- [ja] 1回分の処理 
	if nTime-oTime>wait then
		if sys_backcnt>0 then
			sys_backcnt=sys_backcnt-1;
			if sys_backcnt<=0 then
				snd_cancel=true;
			end;
		end;
		if getenv("sys_selected") and not sys_offcommand then
			sys_offcommand=true;
			self:queuecommand("Off");
		end;
		oTime=oTime+wait;
		if snd_cancel then
			local c_snd=self:GetChild("SND_CANCEL");
			c_snd:queuecommand("Play");
		end;
		if snd_start then
			local c_snd=self:GetChild("SND_START");
			c_snd:queuecommand("Play");
		end;
		if snd_chgdrill then
			local c_snd=self:GetChild("SND_CHGSONG");
			c_snd:queuecommand("Play");
			self:queuecommand("Set");
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update);

--]===]

return t;