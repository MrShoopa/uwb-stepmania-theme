InitDrillLevel();

-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_key=false;

local t=Def.ActorFrame{};
-- [ja] サウンドとキー操作　
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		if GAMESTATE:GetNumPlayersEnabled()>1 then
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		end;
		SOUND:PlayAnnouncer("-waiei ScreenSelectDrillDifficulty intro");
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
			elseif params.Name == 'Left' and CntLVInfo()>0 then
				SetSelDrillLevelR(-1);
				local tbl={Scroll="Left"};
				MESSAGEMAN:Broadcast("Set",tbl);
			elseif params.Name == 'Right' and CntLVInfo()>0 then
				SetSelDrillLevelR(1);
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
		local tmp=split(":",GetLVInfo(""..GetSelDrillLevel().."-Song")[1]);
		tmp[1]=string.gsub(tmp[1],"\\","/");
		local path=split("/",tmp[1]);
		if #path<2 then
			self:queuecommand("ReStartScreen");
		else
			-- [ja] ここで選択したカテゴリーのドリルレベルを読み込み 
			InitDrillLife();
			SetDrillStage(1);
			SetDrillMaxStage(#GetLVInfo(""..GetSelDrillLevel().."-Song"));
			SetDrillState("SetStage1");
			SetDrillRealTimeOpt((GetDRInfo("ROpt")=="true") and true or false);
			InitDrillScore(GetDrillMaxStage());
			SOUND:PlayAnnouncer("-waiei ScreenSelectDrillDifficulty comment");
			self:sleep(1.0);
			self:queuecommand("NextScreen");
		end;
	end;
	ReStartScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectDrillDifficulty");
	end;
	NextScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectMusic");
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

return t;