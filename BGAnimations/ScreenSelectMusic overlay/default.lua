local t=Def.ActorFrame{};
if not IsDrill() then

local sys_lock=false;
local play_sound=false;

t[#t+1] = Def.ActorFrame {
	CurrentSongChangedMessageCommand=function(self)
		-- [ja] セクションがないので定期的に最後に選択した曲のグループ名を記録する必要あり 
		if _SONG2() and not IsEXFolder() then
			SetEXFGroupName(GetActiveGroupName());
		end;
	end;
	CodeMessageCommand = function(self, params)
		if not sys_lock then
			if params.Name=="ExFolder" and IsChallEXFolder_NowOpen() and _SONG() then
				sys_lock=true;
				SCREENMAN:GetTopScreen():lockinput(1.55);
				MESSAGEMAN:Broadcast("GoToEXF");
				self:sleep(1.5);
				self:queuecommand('EXFScreenActive');
			end;
			if IsGroupMode() and params.Name=="CloseFolder" then
			--	self:queuecommand("GroupScreen");
			end;
			if params.Name=="Start" then
				if wh_GetCurrentLabel()=="EXFolder" then
					sys_lock=true;
					SCREENMAN:GetTopScreen():lockinput(1.55);
					-- [ja] イベントモードオフの場合、EX該当曲が強制的に表示されるのでフォルダ名の記録が必要 
					--if grSortMode[grSys["Sort"]]=="group" then
					--end;
					MESSAGEMAN:Broadcast("GoToEXF");
					self:sleep(1.5);
					self:queuecommand('EXFScreenLast');
				elseif IsGroupMode() and getenv("WheelName")=="Return" and not _SONG2() then
		--			self:queuecommand("GroupScreen");
				end;
			end;
		end;
	end;
	EXFScreenActiveCommand=function(self,params)
		StartEXFolder(GetActiveGroupName());
	end;
	EXFScreenLastCommand=function(self,params)
		StartEXFolder(GetEXFLastPlayedGroup());
	end;
	GroupScreenCommand=function(self)
		SetGroupState_Song(_SONG());
		SCREENMAN:AddNewScreenToTop("ScreenSelectGroup");
	end;
	LoadActor(THEME:GetPathG("_Loading/loading","out"));

-- Sounds
	LoadActor(THEME:GetPathS("_switch","up")) .. {
		SelectMenuOpenedMessageCommand=cmd(stop;play);
	};
	LoadActor(THEME:GetPathS("_switch","down")) .. {
		SelectMenuClosedMessageCommand=cmd(stop;play);
	};
	LoadActor(THEME:GetPathS("Common","Start")) .. {
		CodeMessageCommand = function(self, params)
			if not play_sound and ((params.Name=="ExFolder" and IsChallEXFolder_NowOpen() and _SONG())
				or (wh_GetCurrentLabel()=="EXFolder" and params.Name=="Start")) then
				self:stop();
				self:play();
				play_sound=true;
			end;
		end;
	};
};

--[=[
setenv("setExFolder",false);
local function update(self)
	if GAMESTATE:GetSortOrder()~='SortOrder_Preferred' then
		if GAMESTATE:GetSortOrder()=='SortOrder_Title' then
			grSys["Sort"]=2;
			local grTitle=getenv("grTitle");
			local _chk;
			local v;
			local a_list={"a","b","c","d","e","f","g","h","i","j","k","l","m","n",
					  "o","p","q","r","s","t","u","v","w","x","y","z"};
			_chk=string.lower(GAMESTATE:GetExpandedSectionName());
			if string.find(_chk,"^%d.*") then
				v="num";
			elseif not string.find(_chk,"^%d.*") and not string.find(_chk,"^%u.*")
				and not string.find(_chk,"^%l.*") then
				v="other";
			else
				for a=1,#a_list do
					if string.find(_chk,"^"..a_list[a]..".*") then
						v=a_list[a];
					end;
				end;
			end;
			if v then
				for i=1,grTitle["Max"] do
					if grTitle[""..i.."-Path"]==v then
						grSys["Select_Now-title"]=i;
						if grSortMode[grSys["Sort"]]=="title" then
							grSys["Selected"]=i;
						end;
					end;
				end;
			end;
			grData=grTitle;
			setenv("grData",grTitle);
			setenv("grSys",grSys);
		end;
		GAMESTATE:ApplyGameCommand("sort,Preferred",GAMESTATE:GetMasterPlayerNumber());
		setenv("grSys_reload",true);
	end;
	if getenv("grSys_reload") then
		setenv("grSys_reload",false);
		setenv("CreatedSortText",false);
		SCREENMAN:SetNewScreen("ScreenSelectMusic");
	end;
	if getenv("callExFolder") and not getenv("setExFolder") then
		setenv("setExFolder",true);
		setenv("ExFolderFlag","Ex1SelectMusic");
		self:queuecommand("Off");
	end;
end;
t.InitCommand=cmd(SetUpdateFunction,update);
--]=]

end;

-- [ja] アバターは最前面表示
t[#t+1]= LoadActor(THEME:GetPathG('_Avatar','graphics/show'),30,false,0.375)..{
	InitCommand=function(self)
	--[[
		if TC_GetwaieiMode()==2 then
			if SCREEN_WIDTH/SCREEN_HEIGHT<1.6 then
				self:y(160);
			else
				self:y(90);
			end;
		else
			if SCREEN_WIDTH/SCREEN_HEIGHT<1.6 then
				self:y(80);
			else
				self:y(90);
			end;
		end;
	--]]
		self:y(SCREEN_HEIGHT-35);
	end;
};

-- [ja] 決定後のエフェクト
t[#t+1] = LoadActor(THEME:GetPathB('_ScreenSelectMusic','overlay_offcommand/waiei'..TC_GetwaieiMode()));


return t;