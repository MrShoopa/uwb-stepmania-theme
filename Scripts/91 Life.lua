-- [ja] EXFolder,Drill共通のライフ設定 
-- [ja] 命令規則 LifeXXX 

-- [ja] ※ __DRILL__ は91 Drill.luaが読み込まれている時だけtrueになる  

local function IsD()
	return (__DRILL__ and IsDrill());
end;
local function IsE()
	return (__EXFOLDER__ and IsEXFolder());
end;

function LifeBatteryKeepLife()
	local def=GetUserPref_Theme("UserMinCombo");
	local ret=def or 'TapNoteScore_W3';
	if IsE() then
		if GetEXFLife()=="MFC" then
			ret='TapNoteScore_W1';
		elseif GetEXFLife()=="PFC" then
			ret='TapNoteScore_W2';
		elseif GetEXFLife()=="FC" then
			ret='TapNoteScore_W3';
		else
			ret=def;
		end;
	elseif IsD() then
		if GetDrillLife()=="MFC" then
			ret='TapNoteScore_W1';
		elseif GetDrillLife()=="PFC" then
			ret='TapNoteScore_W2';
		elseif GetDrillLife()=="FC" then
			ret='TapNoteScore_W3';
		else
			ret=def;
		end;
	else
		ret=def;
	end;
	return ret;
end;

function LifeMeterDanger()
	if IsUltimateLife()
		or (IsD() and GetDrillLife()=="Ultimate") then
		return 0.33;
	else
		return 0.2
	end;
end;

function LifeMeterInit()
	local ret=0.5;
	if (IsD() and GetDrillLifeRemaining()) then
		ret=GetDrillLifeRemaining();
	else
		if IsUltimateLife()
			or (IsE() and GetEXFLife()=="Ultimate")
			or (IsD() and GetDrillLife()=="Ultimate") then
			ret=1.0;
		else
			-- Ultimateライフになっていない
			SetUltimateLife(false);
			ret=0.5;
		end;
	end;
	return ret;
end;

function LifeMeterW1()
	local ret=0.008;
	if (not GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentSong():GetDisplayMainTitle()=="_waiei How To Play_")
		and not GAMESTATE:IsCourseMode() then
		ret=0.111;
	elseif IsUltimateLife()
		or (IsE() and GetEXFLife()=="Ultimate")
		or (IsD() and GetDrillLife()=="Ultimate") then
		if IsUltimateLife() then _SYS("UltimateLifeMode") end;
		ret=0.001;
	else
		ret=0.008;
	end;
	EnableUltimate(false);
	return ret;
end;

function LifeMeterW2()
	local ret=0.008;
	if IsUltimateLife()
		or (IsE() and GetEXFLife()=="Ultimate")
		or (IsD() and GetDrillLife()=="Ultimate") then
		if PREFSMAN:GetPreference("AllowW1")~="AllowW1_Everywhere" then
			ret=0.0005;
		else
			ret=-0.015;
		end;
	else
		ret=0.008;
	end;
	return ret;
end;

function LifeMeterW3()
	local ret=0.004;
	if IsUltimateLife()
		or (IsE() and GetEXFLife()=="Ultimate")
		or (IsD() and GetDrillLife()=="Ultimate") then
		ret=-0.030;
	else
		ret=0.004;
	end;
	return ret;
end;

function LifeMeterW4()
	local ret=0.000;
	if IsUltimateLife()
		or (IsE() and GetEXFLife()=="Ultimate")
		or (IsD() and GetDrillLife()=="Ultimate") then
		ret=-0.050;
	else
		ret=0.000;
	end;
	return ret;
end;

function LifeMeterW5()
	local ret=-0.040;
	if IsE() or IsD() then
		if (IsE() and GetEXFLife()=="Hard")
			or (IsD() and GetDrillLife()=="Hard") then
			ret=-0.160;
		else
			if (IsE() and GetEXFLife()=="Ultimate")
				or (IsD() and GetDrillLife()=="Ultimate") then
				ret=-0.080;
			else
				ret=-0.040;
			end;
		end;
	else
		if IsUltimateLife() then
			ret=-0.080;
		else
			ret=-0.040;
		end;
	end;
	return ret;
end;

function LifeMeterMiss()
	local ret=-0.080;
	if (not GAMESTATE:GetCurrentSong() or GAMESTATE:GetCurrentSong():GetDisplayMainTitle()=="_waiei How To Play_")
		and not GAMESTATE:IsCourseMode() then
		ret=-0.350;
	elseif IsE() or IsD() then
		if (IsE() and GetEXFLife()=="Hard")
			or (IsD() and GetDrillLife()=="Hard") then
			ret=-0.320;
		else
			if (IsE() and GetEXFLife()=="Ultimate")
				or (IsD() and GetDrillLife()=="Ultimate") then
				ret=-0.160;
			else
				ret=-0.080;
			end;
		end;
	else
		if IsUltimateLife() then
			ret=-0.160;
		else
			ret=-0.080;
		end;
	end;
	return ret;
end;

function LifeMeterHitMine()
	local ret=-0.080;
	if IsE() or IsD() then
		if (IsE() and GetEXFLife()=="Hard")
			or (IsD() and GetDrillLife()=="Hard") then
			ret=-0.400;
		else
			if (IsE() and GetEXFLife()=="Ultimate")
				or (IsD() and GetDrillLife()=="Ultimate") then
				ret=-0.160;
			else
				ret=-0.080;
			end;
		end;
	else
		if IsUltimateLife() then
			ret=-0.160;
		else
			ret=-0.080;
		end;
	end;
	return ret;
end;

function LifeMeterHeld()
	local ret=0.008;
	if IsUltimateLife()
		or (IsE() and GetEXFLife()=="Ultimate")
		or (IsD() and GetDrillLife()=="Ultimate") then
		ret=0.001;
	else
		ret=0.008;
	end;
	return ret;
end;

function LifeMeterLetGo()
	local ret=-0.080;
	if IsE() or IsD() then
		if (IsE() and GetEXFLife()=="Hard")
			or (IsD() and GetDrillLife()=="Hard") then
			ret=-0.320;
		else
			if (IsE() and GetEXFLife()=="Ultimate")
				or (IsD() and GetDrillLife()=="Ultimate") then
				ret=-0.160;
			else
				ret=-0.080;
			end;
		end;
	else
		if IsUltimateLife() then
			ret=-0.160;
		else
			ret=-0.080;
		end;
	end;
	return ret;
end;

function LifeMeterCheckpointMiss()
	local ret=-0.002;
	return ret;
end;

function LifeMeterCheckpointHit()
	local ret=-0.002;
	if IsUltimateLife()
		or (IsE() and GetEXFLife()=="Ultimate")
		or (IsD() and GetDrillLife()=="Ultimate") then
		ret=0.000;
	else
		ret=0.002;
	end;
	return ret;
end;

local ultimate=false;
function IsUltimateLife()
	return ultimate;
end;

-- [ja] アルティメットライフの設定を変更できるかどうかのフラグ 
local canset=false;
function EnableUltimate(flag)
	canset=flag;
end;

-- [ja] 設定はScreenStageInformationで行っている 
function SetUltimateLife(flag)
	if canset then
		ultimate=flag;
	end;
end;
