InitDrillResult();

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
			if params.Name=="Back" or params.Name=="Start" then
				sys_key=false;
				MESSAGEMAN:Broadcast("Off");
			elseif params.Name == 'Left' then
				SetSelDrillResultR(-1);
				local tbl={Scroll="Left"};
				MESSAGEMAN:Broadcast("Set",tbl);
			elseif params.Name == 'Right' then
				SetSelDrillResultR(1);
				local tbl={Scroll="Right"};
				MESSAGEMAN:Broadcast("Set",tbl);
			elseif params.Name=="Select" then
			end;
		end;
	end;
	OffMessageCommand=function(self)
		sys_key=false;
		--[[
			ここで画面切り替え時の処理 
		--]]
		self:sleep(1.0);
		self:queuecommand("NextScreen");
	end;
	NextScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenProfileSave");
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