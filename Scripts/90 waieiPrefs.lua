-- [ja] 旧バージョンではDataフォルダに保存していたが公式曰く非推奨 
local function localGetSMVersion()
	local v=string.lower(ProductVersion())
	if string.find(v,"5.1",0,true) then
		return 51000;
	elseif string.find(v,"v5.0 beta 1",0,true) then
		return 10;
	elseif string.find(v,"v5.0 beta",0,true) then
		return 20;
	elseif string.find(v,"v5.0 alpha 1",0,true) then
		return 1;
	elseif string.find(v,"v5.0 alpha 2",0,true) then
		return 2;
	elseif string.find(v,"v5.0 alpha 3",0,true) then
		return 3;
	elseif string.find(v,"v5.0 preview",0,true) then
		return 0;
	end;
	return 20;
end;

local PrefOldPath = "Data/UserPrefs/waiei2/";
local PrefPath = "Save/UserPrefs/waiei2/";
local PrefPathF = (localGetSMVersion()>=20) and "Save/UserPrefs/_fallback/" or "Data/UserPrefs/_fallback/";

--[[ begin internal stuff; no need to edit below this line. ]]

-- Local internal function to write envs. ___Not for themer use.___
local function WriteEnv(envName,envValue)
	return setenv(envName,envValue)
end

local cfg={};
function ReadPrefFromFile_Theme(name)
--[[
	local f = RageFileUtil.CreateRageFile()
	local fullFilename = PrefPath..name..".cfg"
	local fullOldFilename = PrefOldPath..name..".cfg"
	local option

	if f:Open(fullFilename,1) then
		option = tostring( f:Read() )
		WriteEnv(name,option)
		f:destroy()
		return option
	elseif f:Open(fullOldFilename,1) then
		option = tostring( f:Read() )
		WriteEnv(name,option)
		f:destroy()
		return option
	else
		local fError = f:GetError()
		Trace( "[FileUtils] Error reading ".. fullFilename ..": ".. fError )
		f:ClearError()
		f:destroy()
		return nil
	end
--]]
	if not cfg or not cfg['LoadFlag'] then
		waieiLoadPref();
	end;
	local section_name='main';
	local split_name=split('%[',name);
	if #split_name>1 then
		local tmp=split('%]',(split_name[2]));
		section_name=tmp[1];
		name=split_name[1];
	end;
	local ret='';
	if cfg[section_name] and cfg[section_name][name] then
		ret = cfg[section_name][name];
	end;
	return ret;
end

function WritePrefToFile_Theme(name,value)
	local f = RageFileUtil.CreateRageFile()
	local fullFilename = PrefPath..name..".cfg"
	if not cfg or not cfg['LoadFlag'] then
		waieiLoadPref();
	end;

	local section_name='main';
	local split_name=split('%[',name);
	if #split_name>1 then
		local tmp=split('%]',(split_name[2]));
		section_name=tmp[1];
		name=split_name[1];
	end;
	if f:Open(fullFilename, 2) then
		f:Write( tostring(value) )
		WriteEnv(name,value)
		if not cfg[section_name] then
			cfg[section_name]={};
		end;
		cfg[section_name][name]=tostring(value);
	else
		local fError = f:GetError()
		Trace( "[FileUtils] Error writing to ".. fullFilename ..": ".. fError )
		f:ClearError()
		f:destroy()
		return false
	end

	f:destroy()
	waieiSavePref();
	return true
end

function WritePrefToFile_fallback(name,value)
	local f = RageFileUtil.CreateRageFile()
	local fullFilename = PrefPathF..name..".cfg"

	if f:Open(fullFilename, 2) then
		f:Write( tostring(value) )
		WriteEnv(name,value)
	else
		local fError = f:GetError()
		Trace( "[FileUtils] Error writing to ".. fullFilename ..": ".. fError )
		f:ClearError()
		f:destroy()
		return false
	end

	f:destroy()
	return true
end

--[[ end internal functions; still don't edit below this line ]]

-- [ja] ファイルからの読み取り
local loadflag=false;
local cfgfile='./Save/waiei/Settings.ini';
function waieiLoadPref()
	if FILEMAN:DoesFileExist(cfgfile) then
		local f=OpenFile(cfgfile);
		local l;
		local section='';
		while true do
			l=f:GetLine();
			if f:AtEOF() then
				break;
			-- [ja] BOM考慮して .* を頭につける 
			elseif string.find(l,"^.*%[.*%].*$") then
				local sec=split('%[',l)[2];
				section=string.lower(split('%]',sec)[1]);
				cfg[section]={};
			elseif (string.find(l,"^.*#.*") or string.find(l,"^%/%/.*")) then
				-- [ja] コメントなので無視 
			elseif string.find(l,"^.*=.*$") then
				local prm=split(';',l)[1];
				prms=split('=',prm);
				cfg[section][prms[1]]=prms[2];
			end;
		end;
		CloseFile(f);
		cfg['LoadFlag']=true;
	end;
end;
function waieiSavePref()
	if not cfg or not cfg['LoadFlag'] then
		waieiLoadPref();
	end;
	local f=SaveFile(cfgfile);
	local save='';
	for key, val in pairs(cfg) do
		if key~='LoadFlag' then
			save=save..'['..key..']\r\n';
			for k, v in pairs(val) do
				save=save..k..'='..(v or '')..'\r\n';
			end;
			save=save..'\r\n';
		end;
	end;
--[[
	table.sort(cfg['main'],
		function(a,b)
			return (string.upper(a) < string.upper(b))
		end);
	for k, v in pairs(cfg['main']) do
		save=save..k..'='..(v or '')..'\r\n';
	end;
--]]
	f:Write(save);
	CloseFile(f);
	waieiLoadPref();
end;

function GetUserPref_Theme(name)
	return ReadPrefFromFile_Theme(name)
end

function SetUserPref_Theme(name,value)
	return WritePrefToFile_Theme(name,value)
end

function SetUserPref_fallback(name,value)
	return WritePrefToFile_fallback(name,value)
end

local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

-- Example usage of new system (not really implemented yet)
function InitUserPrefs()
	local Prefs =
	{
--		AutoSetStyle = 'Off',
		NotePosition = 'Normal',
		FlashyCombos = 'On',
		ComboUnderField = 'True',
	}
	for k, v in pairs(Prefs) do
		-- kind of xxx
		-- local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		if GetUserPref(k) == nil then
			SetUserPref_fallback(k, v)
		end
	end
end

InitUserPrefs();


function InitUserPrefs_Theme()
	local Prefs = {
		DF_AutoSetStyle = 'On',
		DF_ComboUnderField = 'True',
		DF_FlashyCombos = 'On',
		UserScreenFilterP1 = 'Off',
		UserScreenFilterP2 = 'Off',
		UserLightEffect = 'Auto',
		UserBGScale = 'Fit',
		UserBGAtoLua = 'Auto',
		UserHoldJudgmentType = 'DDR',
		UserDifficultyName = 'StepMania',
		UserDifficultyColor = 'StepMania',
		UserJudgementLabel = 'StepMania',
		UserMeterType = 'Default',
		UserMineHitMiss = 'Off',
		UserHaishin = 'Off',
		UserScoreMode = 'Default',
		UserSpeedAssistP1 = 'Off',
		UserSpeedAssistP2 = 'Off',
		UserTargetP1 = 'Off',
		UserTargetP2 = 'Off',
		UserwaieiPlayerOptionsP1 = '',
		UserwaieiPlayerOptionsP2 = '',
		UserColor = 'Blue',
		UserColorPath = '',
		UserLife = 'Default',
		UserUserHiScoreType = 'Score',
		UserCustomScore = 'Off',
		UserMinCombo = 'TapNoteScore_W3',
		UserHideNotes = 'Auto',
		UserWheelMode = 'Jacket->BG',
		UserWheelText = 'Default',
		UserShowCaloriesP1 = 'Off',
		UserShowCaloriesP2 = 'Off',
		UserHoldCheckPoints = 'Off',
		UserComboBreakOnNG = 'Off',
		UserResultBGM = 'On',
		UserShowRadarValue = 'All',
		UserRadarOverLimit = 'On',
		UserActiveGroupOnly = 'On',
		UserJumpCombo = 'Any',
		UserRollCombo = 'Off',
		UserStage = 'Off',
		UserAnimationFPS = '60',
		UserCSRival = 'Off',
		ThemeColor = '2|BlueIce|Main|2'
	}
	local default='[Main]\r\n';
	for k, v in pairs(Prefs) do
		-- kind of xxx
		-- local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		default=default..k..'='..v..'\r\n';
		if GetUserPref_Theme(k) == nil then
			SetUserPref_Theme(k, v)
		end
	end
	local f=SaveFile(cfgfile);
	f:Write(default);
	CloseFile(f);
end

InitUserPrefs_Theme();

-- [ja] 追加部分

function UserLightEffect()
	local t = {
		Name = "UserLightEffect",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Never','Auto','Always' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserLightEffect") ~= nil then
				if (GetUserPref_Theme("UserLightEffect")=='Auto') then
					list[2] = true
				elseif (GetUserPref_Theme("UserLightEffect")=='Always') then
					list[3] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserLightEffect", 'Auto');
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val;
			if list[1] then val='Never'; elseif list[2] then val='Auto'; else val='Always'; end;
			SetUserPref_Theme("UserLightEffect", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserHoldJudgmentType()
	local t = {
		Name = "UserHoldJudgmentType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserHoldJudgmentType") ~= nil then
				if (GetUserPref_Theme("UserHoldJudgmentType")=='DDR') then
					list[2] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserHoldJudgmentType", 'StepMania');
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val = list[2] and 'DDR' or 'StepMania';
			SetUserPref_Theme("UserHoldJudgmentType", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserHoldCheckPoints()
	local t = {
		Name = "UserHoldCheckPoints",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserHoldCheckPoints") ~= nil then
				if (GetUserPref_Theme("UserHoldCheckPoints")=='On') then
					list[2] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserHoldCheckPoints", 'Off');
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val = list[2] and 'On' or 'Off';
			SetUserPref_Theme("UserHoldCheckPoints", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserBGAtoLua()
	local t = {
		Name = "UserBGAtoLua",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Never','Auto','Always' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserBGAtoLua") ~= nil then
				if (GetUserPref_Theme("UserBGAtoLua")=='Auto') then
					list[2] = true
				elseif (GetUserPref_Theme("UserBGAtoLua")=='Always') then
					list[3] = true
				else
					list[1] = true
				end
			else
				SetUserPref_Theme("UserBGAtoLua", 'Auto');
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val;
			if list[1] then val='Never'; elseif list[2] then val='Auto'; else val='Always'; end;
			SetUserPref_Theme("UserBGAtoLua", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserScreenFilter()
	local t = {
		Name = "UserScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','25%','50%','75%','100%' },
		LoadSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			if GetUserPref_Theme("UserScreenFilter" .. nm) ~= nil then
				local bShow=GetUserPref_Theme("UserScreenFilter" .. nm);
				if bShow == '100%' then
					list[5] = true
				elseif bShow == '25%' then
					list[2] = true
				elseif bShow == '50%' then
					list[3] = true
				elseif bShow == '75%' then
					list[4] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			local bSave;
			if list[1] then
				bSave='Off';
			elseif list[2] then
				bSave='25%';
			elseif list[3] then
				bSave='50%';
			elseif list[4] then
				bSave='75%';
			elseif list[5] then
				bSave='100%';
			end;
			SetUserPref_Theme("UserScreenFilter" .. nm, bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserBGScale()
	local t = {
		Name = "UserBGScale",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Fit','Cover' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserBGScale") ~= nil then
				if GetUserPref_Theme("UserBGScale") == 'Fit' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Fit';
			else
				bSave='Cover';
			end;
			SetUserPref_Theme("UserBGScale", bSave);
			SetBGScale();
		end
	}
	setmetatable(t, t)
	return t
end

function UserDifficultyName()
	local t = {
		Name = "UserDifficultyName",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR','DDR EXTREME','DDR SuperNOVA' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserDifficultyName") ~= nil then
				if GetUserPref_Theme("UserDifficultyName") == 'DDR' then
					list[2] = true
				elseif GetUserPref_Theme("UserDifficultyName") == 'DDR EXTREME' then
					list[3] = true
				elseif GetUserPref_Theme("UserDifficultyName") == 'DDR SuperNOVA' then
					list[4] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			elseif list[3] then
				bSave='DDR EXTREME';
			elseif list[4] then
				bSave='DDR SuperNOVA';
			else
				bSave='StepMania';
			end;
			SetUserPref_Theme("UserDifficultyName", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserDifficultyColor()
	local t = {
		Name = "UserDifficultyColor",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserDifficultyColor") ~= nil then
				if GetUserPref_Theme("UserDifficultyColor") == 'DDR' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			else
				bSave='StepMania';
			end;
			SetUserPref_Theme("UserDifficultyColor", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserJudgementLabel()
	local t = {
		Name = "UserJudgementLabel",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'StepMania','DDR','DDR SuperNOVA' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserJudgementLabel") ~= nil then
				if GetUserPref_Theme("UserJudgementLabel") == 'DDR' then
					list[2] = true
				elseif GetUserPref_Theme("UserJudgementLabel") == 'DDR SuperNOVA' then
					list[3] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR';
			elseif list[3] then
				bSave='DDR SuperNOVA';
			else
				bSave='StepMania';
			end;
			SetUserPref_Theme("UserJudgementLabel", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserMeterType()
	local t = {
		Name = "UserMeterType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		--[[Choices = { 'Default','DDR (MAX12)','DDR (MAX10)','DDR X','LV100','LV20' },--]]
		Choices = { 'Default','DDR X','LV100' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserMeterType") ~= nil then
				if GetUserPref_Theme("UserMeterType") == 'LV100' then
					list[3] = true
				--[[
				if GetUserPref_Theme("UserMeterType") == 'DDR' then
					list[2] = true
				elseif GetUserPref_Theme("UserMeterType") == 'DDR MAX10' then
					list[3] = true
				--]]
				elseif GetUserPref_Theme("UserMeterType") == 'DDR X' then
					list[2] = true
				--[[
				elseif GetUserPref_Theme("UserMeterType") == 'LV100' then
					list[5] = true
				elseif GetUserPref_Theme("UserMeterType") == 'LV20' then
					list[6] = true
				--]]
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[3] then
				bSave='LV100';
			--[[
			elseif list[3] then
				bSave='DDR MAX10';
			--]]
			elseif list[2] then
				bSave='DDR X';
			--[[
			elseif list[5] then
				bSave='LV100';
			elseif list[6] then
				bSave='LV20';
			--]]
			else
				bSave='Default';
			end;
			if GetUserPref_Theme("UserMeterType")~=bSave then
				ReloadSongFlag();
			end;
			SetUserPref_Theme("UserMeterType", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserMineHitMiss()
	local t = {
		Name = "UserMineHitMiss",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserMineHitMiss") ~= nil then
				if GetUserPref_Theme("UserMineHitMiss") == 'false' or GetUserPref_Theme("UserMineHitMiss") == 'Off' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserMineHitMiss", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserHaishin()
	local t = {
		Name = "UserHaishin",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserHaishin") ~= nil then
				if GetUserPref_Theme("UserHaishin") == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserHaishin", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserScoreMode()
	local t = {
		Name = "UserScoreMode",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Default(9digits)','SN2(7digits)','SN2(AutoConvert)','DancePoints' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserScoreMode") ~= nil then
				if GetUserPref_Theme("UserScoreMode") == 'DDR SuperNOVA2' then
					list[2] = true
				elseif GetUserPref_Theme("UserScoreMode") == 'SN2_AC' then
					list[3] = true
				elseif GetUserPref_Theme("UserScoreMode") == 'DancePoints' then
					list[4] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='DDR SuperNOVA2';
			elseif list[3] then
				bSave='SN2_AC';
			elseif list[4] then
				bSave='DancePoints';
			else
				bSave='Default';
			end;
			SetUserPref_Theme("UserScoreMode", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserSpeedAssist()
	local t = {
		Name = "UserSpeedAssist",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			if GetUserPref_Theme("UserSpeedAssist" .. nm) ~= nil then
				if GetUserPref_Theme("UserSpeedAssist" .. nm) == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserSpeedAssist" .. nm, bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserShowCalories()
	local t = {
		Name = "UserShowCalories",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			if GetUserPref_Theme("UserShowCalories" .. nm) ~= nil then
				if GetUserPref_Theme("UserShowCalories" .. nm) == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserShowCalories" .. nm, bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserTarget()
	local t = {
		Name = "UserTarget",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			if GetUserPref_Theme("UserTarget" .. nm) ~= nil then
				if GetUserPref_Theme("UserTarget" .. nm) == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if PROFILEMAN:GetNumLocalProfiles()>0
				and (PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName() ~= PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName()) then
				for i=1,PROFILEMAN:GetNumLocalProfiles() do
					if PROFILEMAN:GetProfile(pn):GetDisplayName()==PROFILEMAN:GetLocalProfileFromIndex(i-1):GetDisplayName() then
						nm="["..PROFILEMAN:GetLocalProfileIDFromIndex(i-1).."]";
						break
					end;
				end;
			end;
			local bSave;
			if list[2] then
				bSave='On';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserTarget" .. nm, bSave);
		end;
	}
	setmetatable(t, t)
	return t
end

function UserwaieiPlayerOptions()
	local t = {
		Name = "UserwaieiPlayerOptions",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'PIU Reverse','3.9 Mini' },
		LoadSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			if GetUserPref_Theme("UserwaieiPlayerOptions" .. nm) ~= nil then
				local prm=split(",",GetUserPref_Theme("UserwaieiPlayerOptions" .. nm))
				for i=1,#prm do
					if prm[i]=="PIU Reverse" then
						list[1]=true;
					elseif prm[i]=="3.9 Mini" then
						list[2]=true;
					end;
				end;
			end
		end,
		SaveSelections = function(self, list, pn)
			local nm=ToEnumShortString(pn);
			local strSave="";
			for i=1,2 do
				if list[i] then
					if strSave~="" then
						strSave=strSave..","
					end;
					if i==1 then
						strSave=strSave.."PIU Reverse";
					elseif i==2 then
						strSave=strSave.."3.9 Mini";
					end;
				end;
			end;
			SetUserPref_Theme("UserwaieiPlayerOptions" .. nm, strSave);
		end;
	}
	setmetatable(t, t)
	return t
end
function GetwaieiPlayerOptions(pn,option)
	local nm=ToEnumShortString(pn);
	local ret=false;
	if GetUserPref_Theme("UserwaieiPlayerOptions" .. nm) ~= nil then
		local prm=split(",",GetUserPref_Theme("UserwaieiPlayerOptions" .. nm))
		for i=1,#prm do
			if string.lower(prm[i])==string.lower(option) then
				ret=true;
			end;
		end;
	end;
	return ret;
end;

function UserColor()
	local t = {
		Name = "UserColor",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Blue','Black','Ice' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserColor") ~= nil then
				if GetUserPref_Theme("UserColor") == 'Blue' then
					list[1] = true
				elseif GetUserPref_Theme("UserColor") == 'Ice' then
					list[3] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Blue';
			elseif list[3] then
				bSave='Ice';
			else
				bSave='Black';
			end;
			SetUserPref_Theme("UserColor", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserLife()
	local t = {
		Name = "UserLife",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Default','Beta' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserLife") ~= nil then
				if GetUserPref_Theme("UserLife") == 'Beta' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[2] then
				bSave='Beta';
			else
				bSave='Default';
			end;
			SetUserPref_Theme("UserLife", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserCustomScore()
	local t = {
		Name = "UserCustomScore",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','3.9',"Hybrid","SuperNOVA2","DDR A","DancePoints" },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserCustomScore") ~= nil then
				if GetUserPref_Theme("UserCustomScore") == '3.9' then
					list[2] = true
				elseif GetUserPref_Theme("UserCustomScore") == 'Hybrid' then
					list[3] = true
				elseif GetUserPref_Theme("UserCustomScore") == 'SuperNOVA2' then
					list[4] = true
				elseif GetUserPref_Theme("UserCustomScore") == 'DDR A' then
					list[5] = true
				elseif GetUserPref_Theme("UserCustomScore") == 'DancePoints' then
					list[6] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local bSaveF;
			local bSaveT;
			if list[2] then
				bSave='3.9';
			elseif list[3] then
				bSave='Hybrid';
			elseif list[4] then
				bSave='SuperNOVA2';
			elseif list[5] then
				bSave='DDR A';
			elseif list[6] then
				bSave='DancePoints';
			else
				bSave='Off';
			end;
			SetUserPref_Theme("UserCustomScore", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserMinCombo()
	local t = {
		Name = "UserMinCombo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'W1','W2',"W3 (Default)","W4" },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserMinCombo") ~= nil then
				if GetUserPref_Theme("UserMinCombo") == 'TapNoteScore_W1' then
					list[1] = true
				elseif GetUserPref_Theme("UserMinCombo") == 'TapNoteScore_W2' then
					list[2] = true
				elseif GetUserPref_Theme("UserMinCombo") == 'TapNoteScore_W4' then
					list[4] = true
				else
					list[3] = true
				end;
			else
				list[3] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[1] then
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W1');
			elseif list[2] then
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W2');
			elseif list[4] then
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W4');
			else
				SetUserPref_Theme("UserMinCombo", 'TapNoteScore_W3');
			end;
		end
	}
	setmetatable(t, t)
	return t
end

function UserHideNotes()
	local t = {
		Name = "UserHideNotes",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Auto','W1','W2',"W3","W4" },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserHideNotes") ~= nil then
				if GetUserPref_Theme("UserHideNotes") == 'TapNoteScore_W1' then
					list[2] = true
				elseif GetUserPref_Theme("UserHideNotes") == 'TapNoteScore_W2' then
					list[3] = true
				elseif GetUserPref_Theme("UserHideNotes") == 'TapNoteScore_W3' then
					list[4] = true
				elseif GetUserPref_Theme("UserHideNotes") == 'TapNoteScore_W4' then
					list[5] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[2] then
				SetUserPref_Theme("UserHideNotes", 'TapNoteScore_W1');
				PREFSMAN:SetPreference("MinTNSToHideNotes",'W1');
			elseif list[3] then
				SetUserPref_Theme("UserHideNotes", 'TapNoteScore_W2');
				PREFSMAN:SetPreference("MinTNSToHideNotes",'W2');
			elseif list[4] then
				SetUserPref_Theme("UserHideNotes", 'TapNoteScore_W3');
				PREFSMAN:SetPreference("MinTNSToHideNotes",'W3');
			elseif list[5] then
				SetUserPref_Theme("UserHideNotes", 'TapNoteScore_W4');
				PREFSMAN:SetPreference("MinTNSToHideNotes",'W4');
			else
				SetUserPref_Theme("UserHideNotes", 'Auto');
				PREFSMAN:SetPreference("MinTNSToHideNotes",ToEnumShortString(GetUserPref_Theme("UserMinCombo") or "TapNoteScore_W3"));
			end;
		end
	}
	setmetatable(t, t)
	return t
end

function UserWheelMode()
	local t = {
		Name = "UserWheelMode",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Jacket->Banner','Jacket->BG','Banner->Jacket','BG->Jacket' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserWheelMode") ~= nil then
				if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
					list[1] = true
				elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
					list[2] = true
				elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
					list[3] = true
				elseif GetUserPref_Theme("UserWheelMode") == 'BG->Jacket' then
					list[4] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[1] then
				SetUserPref_Theme("UserWheelMode", 'Jacket->Banner');
			elseif list[2] then
				SetUserPref_Theme("UserWheelMode", 'Jacket->BG');
			elseif list[3] then
				SetUserPref_Theme("UserWheelMode", 'Banner->Jacket');
			elseif list[4] then
				SetUserPref_Theme("UserWheelMode", 'BG->Jacket');
			else
				SetUserPref_Theme("UserWheelMode", 'Jacket->Banner');
			end;
			SetWheelMode();
		end
	}
	setmetatable(t, t)
	return t
end

function UserWheelText()
	local t = {
		Name = "UserWheelText",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'None','Default','All' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserWheelText") ~= nil then
				if GetUserPref_Theme("UserWheelText") == 'None' then
					list[1] = true
				elseif GetUserPref_Theme("UserWheelText") == 'All' then
					list[3] = true
				else
					list[2] = true
				end;
			else
				list[2] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			if list[1] then
				SetUserPref_Theme("UserWheelText", 'None');
			elseif list[3] then
				SetUserPref_Theme("UserWheelText", 'All');
			else
				SetUserPref_Theme("UserWheelText", 'Default');
			end;
		end
	}
	setmetatable(t, t)
	return t
end

--[[ end option rows ]]
-- [ja] _fallbackテーマに項目だけ残っていて設定が反映さえていないもの 

function NotePosition()
	local t = {
		Name = "NotePosition",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Normal','Lower' },
		LoadSelections = function(self, list, pn)
			if GetUserPref("NotePosition") ~= nil then
				if GetUserPref("NotePosition") == 'Normal' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Normal';
			else
				bSave='Lower';
			end;
			SetUserPref_fallback("NotePosition", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

-- [ja] ｆデフォルトテーマに存在するオプション（仕様変更で消える可能性あるのでこっちに移動） 
function DF_AutoSetStyle()
	local t = {
		Name = "DF_AutoSetStyle",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("DF_AutoSetStyle") ~= nil then
				if GetUserPref_Theme("DF_AutoSetStyle") == 'Off' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("DF_AutoSetStyle", bSave);
			THEME:ReloadMetrics();
		end
	}
	setmetatable(t, t)
	return t
end

function DF_ComboUnderField()
	local t = {
		Name = "DF_ComboUnderField",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("DF_ComboUnderField") ~= nil then
				if GetUserPref_Theme("DF_ComboUnderField") == tostring(false) 
					or GetUserPref_Theme("DF_ComboUnderField")=="Off" then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave="Off";
			else
				bSave="On";
			end;
			SetUserPref_Theme("DF_ComboUnderField", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function DF_FlashyCombos()
	local t = {
		Name = "DF_FlashyCombos",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("DF_FlashyCombos") ~= nil then
				if GetUserPref_Theme("DF_FlashyCombos") == 'Off' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("DF_FlashyCombos", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserComboBreakOnNG()
	local t = {
		Name = "UserComboBreakOnNG",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserComboBreakOnNG") ~= nil then
				if GetUserPref_Theme("UserComboBreakOnNG") == 'Off' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserComboBreakOnNG", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserResultBGM()
	local t = {
		Name = "UserResultBGM",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserResultBGM") ~= nil then
				if GetUserPref_Theme("UserResultBGM") == 'Off' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserResultBGM", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserShowRadarValue()
	local t = {
		Name = "UserShowRadarValue",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','All','Pad','Key' },
		LoadSelections = function(self, list, pn)
			local val=GetUserPref_Theme("UserShowRadarValue");
			if val ~= nil then
				if val == 'Off' then
					list[1] = true
				elseif val == 'Pad' then
					list[3] = true
				elseif val == 'Key' then
					list[4] = true
				else
					list[2] = true
				end;
			else
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			elseif list[3] then
				bSave='Pad';
			elseif list[4] then
				bSave='Key';
			else
				bSave='All';
			end;
			SetUserPref_Theme("UserShowRadarValue", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserRadarOverLimit()
	local t = {
		Name = "UserRadarOverLimit",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			local val=GetUserPref_Theme("UserRadarOverLimit");
			if val ~= nil then
				if val == 'Off' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserRadarOverLimit", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserJumpCombo()
	local t = {
		Name = "UserJumpCombo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { '1','Any' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserJumpCombo") ~= nil then
				if GetUserPref_Theme("UserJumpCombo") == '1' then
					list[1] = true
				else
					list[2] = true
				end;
			else
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='1';
			else
				bSave='Any';
			end;
			SetUserPref_Theme("UserJumpCombo", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserRollCombo()
	local t = {
		Name = "UserRollCombo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserRollCombo") ~= nil then
				if GetUserPref_Theme("UserRollCombo") == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserRollCombo", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserStage()
	local t = {
		Name = "UserStage",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserStage") ~= nil then
				if GetUserPref_Theme("UserStage") == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserStage", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

function UserHiScoreType()
	local t = {
		Name = "UserHiScoreType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Score','DancePoints' },
		LoadSelections = function(self, list, pn)
			if PREFSMAN:GetPreference("PercentageScoring") ~= nil then
				if tobool(PREFSMAN:GetPreference("PercentageScoring")) then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				PREFSMAN:SetPreference("PercentageScoring",false);
			else
				PREFSMAN:SetPreference("PercentageScoring",true);
			end;
		end
	}
	setmetatable(t, t)
	return t
end

function UserCSRival()
	local t = {
		Name = "UserCSRival",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPref_Theme("UserCSRival") ~= nil then
				if GetUserPref_Theme("UserCSRival") == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off';
			else
				bSave='On';
			end;
			SetUserPref_Theme("UserCSRival", bSave);
		end
	}
	setmetatable(t, t)
	return t
end

-- --------------------------------------------------------------------------------

function SetWheelMode()
	local wheelmode="";
	if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
		wheelmode = "JBN"
	elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
		wheelmode = "JBG"
	elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
		wheelmode = "BNJ"
	elseif GetUserPref_Theme("UserWheelMode") == 'BG->Jacket' then
		wheelmode = "BGJ"
	else
		wheelmode = "JBN"
	end;
	setenv("WheelMode",wheelmode)
	return wheelmode;
end;

function GetWheelMode()
	return getenv("WheelMode") or SetWheelMode();
end;

function SetBGScale()
	local bgs=GetUserPref_Theme("UserBGScale") or 'Fit';
	setenv("BGScale",bgs)
	return bgs;
end;

function GetBGScale()
	return getenv("BGScale") or SetBGScale();
end;

function GetOptionDifficultyList()
	local ret={""};
	local song=GAMESTATE:GetCurrentSong();
	if song then
		local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
		local steps=song:GetAllSteps();
		local difname=GetUserPref_Theme("UserDifficultyName");
		local meter_type=GetUserPref_Theme("UserMeterType");
		local l=1;
		local sg_metertype=GetNoLoadSongPrm(song,'metertype');
		for d=1,5 do
			local step=song:GetOneSteps(stt,Difficulty[d]);
			if step then
				local meter=1;
				if meter_type=="LV100" then
					meter=GetConvertDifficulty_LV100(song,step);
				elseif meter_type=="DDR X" then
					meter=GetConvertDifficulty_DDRX(song,step,sg_metertype);
				else
					meter=step:GetMeter();
				end;
				ret[l]=_DifficultyNAME2(difname,Difficulty[d]).." "..meter;
				l=l+1;
			end;
		end;
		for i=1,#steps do
			if steps[i]:GetStepsType()==stt and steps[i]:GetDifficulty()=='Difficulty_Edit' then
				local meter=1;
				if meter_type=="LV100" then
					meter=GetConvertDifficulty_LV100(song,steps[i]);
				elseif meter_type=="DDR X" then
					meter=GetConvertDifficulty_DDRX(song,steps[i],sg_metertype);
				else
					meter=steps[i]:GetMeter();
				end;
				local name=steps[i]:GetDescription();
				if name=="" then name="Edit" end;
				ret[l]=name.." "..meter;
				l=l+1;
			end;
		end;
	end;
	return ret;
end;

function UserPlayDifficulty()
	local t = {
		Name = "UserPlayDifficulty",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = GetOptionDifficultyList(),
		LoadSelections = function(self, list, pn)
			local dl=GetOptionDifficultyList();
			local difname=GetUserPref_Theme("UserDifficultyName");
			local step=GAMESTATE:GetCurrentSteps(pn);
			local curDif=_DifficultyNAME2(difname,step:GetDifficulty());
			list[1]=true;
			if step:GetDifficulty()~='Difficulty_Edit' then
				for l=1,#dl do
					if string.find(dl[l],"^"..curDif.."%s%d+$") then
						list[1]=false;
						list[l]=true;
						break;
					end;
				end;
			else
				for l=1,#dl do
					-- [ja] 正規表現の特殊文字が名前に使えるため正規表現検索を無効 
					local find=string.find(dl[l],""..step:GetDescription(),0,true);
					if (find and find==1) or
						(step:GetDescription()=="" and string.find(dl[l],"^Edit%s%d+$")) then
						list[1]=false;
						list[l]=true;
						break;
					end;
				end;
			end;
		end,
		SaveSelections = function(self, list, pn)
			local l=1;
			for i=1,#list do
				if list[i] then
					l=i;
					break;
				end;
			end;
			local dl=GetOptionDifficultyList();
			local curDif='Difficulty_Edit';
			local difname=GetUserPref_Theme("UserDifficultyName");
			for d=1,6 do
				if string.find(dl[l],"^".._DifficultyNAME2(difname,Difficulty[d]).."%s%d+$") then
					curDif=Difficulty[d];
					break;
				end;
			end;
			local song=GAMESTATE:GetCurrentSong();
			local stt=GAMESTATE:GetCurrentStyle():GetStepsType();
			if curDif~='Difficulty_Edit' then
				local step=song:GetOneSteps(stt,curDif);
				GAMESTATE:SetCurrentSteps(pn,step);
			else
				local steps=song:GetAllSteps();
				for i=1,#steps do
					if steps[i]:GetDifficulty()=='Difficulty_Edit' then
						local desc=steps[i]:GetDescription();
						if desc=="" then desc="Edit"; end;
						local find=string.find(dl[l],""..desc,0,true);
						if (find and find==1) then
							GAMESTATE:SetCurrentSteps(pn,steps[i]);
							break;
						end;
					end;
				end;
			end;
			GAMESTATE:SetPreferredDifficulty(pn,curDif);
		end
	}
	setmetatable(t, t)
	return t
end

------------------------------------------------------------------------------------- OptionsList

function List_PlayerOptions()
	local ret="";
	if IsEXFolder() then
		ret="1,"..(GetSMVersion()>=90 and "NN" or "8")..",14,2,3A,3B,YA,4,5,6,R,7,9,10,11,12,13,SF,SA,17,18,ST,SC";
	elseif IsDrill() then
		ret="1,"..(GetSMVersion()>=90 and "NN" or "8")..",14,2,4,5,7,SF,17,18,ST,SC";
	else
		if GAMESTATE:IsCourseMode() then
			ret="1,"..(GetSMVersion()>=90 and "NN" or "8")..",14,2,3A,3B,YA,4,5,6,R,7,9,10,11,12,13,16,SF,SA,17,18,ST,SC";
		else
			ret="1,"..(GetSMVersion()>=90 and "NN" or "8")..",14,2,3A,3B,YA,4,5,6,R,7,9,10,11,12,13,DF,SF,SA,17,18,ST,SC";
		end;
	end;
	return ret;
end;

function List_SongOptions()
	local ret="";
	if not GAMESTATE:IsAnExtraStage() and not IsEXFolder() then
		ret="1,2,3,4,5,6,7,8,9,10";
	else
		ret="5,6,7,8,9,10";
	end;
	return ret;
end;

function List_DrillOptions()
	local ret="";
	ret=""..(GetSMVersion()>=90 and "NN" or "8")..",SF,17,18,ST,SC";
	return ret;
end;