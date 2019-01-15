-- [ja] 初期設定 
local tc={};
tc["Load"]=false;
-- [ja] （テーマ変更時用）テーマ情報の記録と読み取り 
function TC_SetThemeStats(mode,name,subcolor,pcolor)
	tc["Mode"]=mode;
	tc["Name"]=name;
	tc["SubColor"]=subcolor;
	tc["PlayerColor"]=pcolor;
	SetUserPref_Theme("ThemeColor",tc["Mode"].."|"..tc["Name"].."|"..tc["SubColor"].."|"..tc["PlayerColor"]);
end;
function TC_GetThemeStats()
	return tc;
end;
function TC_Default()
	return 'BlueIce';
end;
function TC_GetLoadTheme()
	return tc["Load"];
end;
function TC_ReloadTheme()
	TC_SetwaieiMode(tc["Mode"]);
	TC_SetPlayerColorMode(tc["PlayerColor"]);
	TC_Init(tc["Name"],tc["SubColor"]);
end;
local TC_retScreen="";
function TC_LoadChk(screenname)
	-- [ja] waiei2テーマ適応(Ctrl+F2を押すなどして内部変数が初期化されたも時用) 
	if not TC_GetLoadTheme() then
		if screenname then
			TC_retScreen=screenname;
		end;
		local t_tc=GetUserPref_Theme("ThemeColor");
		if not t_tc then
			t_tc="2|"..TC_Default().."|main|2";
		end;
		s_tc=split("|",t_tc);
		if(#s_tc==3) then
			TC_SetThemeStats(tonumber(s_tc[1]),s_tc[2],'main',tonumber(s_tc[3])); 
		elseif(#s_tc==4) then
			TC_SetThemeStats(tonumber(s_tc[1]),s_tc[2],s_tc[3],tonumber(s_tc[4])); 
		else
			TC_SetThemeStats(2,TC_Default(),'main',2); 
		end;
		SCREENMAN:SetNewScreen("ScreenChangedThemeColors");
	end;
	--
end;
function TC_ReturnScreen()
	local ret=TC_retScreen;
	TC_retScreen="";
	if ret and ret~="" then
		SCREENMAN:SetNewScreen(ret);
	else
		SCREENMAN:SetNewScreen("ScreenInit");
	end;
end;

-- [ja] 1モードか2モードか 
function TC_SetwaieiMode(mode)
	if mode then
		setenv("TC_Mode",mode);
	else
		setenv("TC_Mode",2);
	end;
	return getenv("TC_Mode");
end;

function TC_GetwaieiMode()
	return getenv("TC_Mode") or TC_SetwaieiMode(nil);
end;

local TC_ColorName="";
function TC_GetColorName()
	return TC_ColorName;
end;

local TC_SubColor="";
function TC_GetSubColor()
	return (TC_GetwaieiMode()==2) and TC_SubColor or 'main';
end;

function TC_SetPlayerColorMode(mode)
	if mode then
		setenv("TC_PlayerColor",mode);
	else
		setenv("TC_PlayerColor",2);
	end;
	return getenv("TC_PlayerColor");
end;

function TC_GetPlayerColorMode()
	return getenv("TC_PlayerColor") or TC_SetPlayerColorMode(nil);
end;

-- [ja] ブロックの内容を取得する 
-- [ja] ここでいうブロック＝INIのセクションに相当 
--[=[
	[b_name]
	#XXX1:YYY1; ┐
	#XXX2:YYY2; ├この部分
	#XXX3:YYY3; ┘
	
	[hogehoge]
	XXX1:YYY1;
--]=]
local function TC_GetTextBlock(filePath,ub_name)
	if not FILEMAN:DoesFileExist(filePath) then
		return "";
	end;
	local b_name=string.lower(ub_name);
	local f=RageFileUtil.CreateRageFile();
	f:Open(filePath,1);

	local ret={};
	local loadblock=false;
	local l;
	local l_cnt=0;
	while true do
		l=f:GetLine();
		local ll=string.lower(l);
		if (loadblock and string.find(ll,".*%[.+%]$"))
			or f:AtEOF() then
			break;
		elseif not loadblock and string.find(ll,".*%["..b_name.."%]$") then
			loadblock=true;
		elseif loadblock and ll~="" and not string.find(ll,"^%s+$")
			and not string.find(ll,"^//.*") then
			--[[
			if ret~="" then
				ret=ret.."\n";
			end;
			--]]
			l=string.gsub(l,"^%s",""); --[ja] 先頭の空白を削除 
			l=string.gsub(l,"%s$",""); --[ja] 終端の空白を削除 
		--	ret=ret..l;
			l_cnt=l_cnt+1;
			ret[l_cnt]=l
		end;
	end;

	f:Close();
	f:destroy();
	return ret;
end;

-- [ja] INI書式のub_name=YYY;の内容を取得する 
local function TC_GetBlockPrm(bStr,ub_name)
	if #bStr<1 then
		return "";
	end;
--	_SYS(blockStr)
--	local bStr=split(";",blockStr);
	local b_name=string.lower(ub_name);
	local ret="";
	for i=1,#bStr do
		if string.find(string.lower(bStr[i]),"^"..b_name.."=.*") then
			ret=""..split("=",bStr[i])[2];
			ret=split(";",ret)[1];
			break;
		end;
	end;
	return ret;
end;
-- [ja] INI書式のub_name=YYY;ZZZ;AAA;...の内容を取得する 
local function TC_GetBlockPrm_Command(bStr,ub_name)
	if #bStr<1 then
		return "";
	end;
	local b_name=string.lower(ub_name);
	local ret="";
	for i=1,#bStr do
		if string.find(string.lower(bStr[i]),"^"..b_name.."=.*") then
			ret=""..split("=",bStr[i])[2];
			break;
		end;
	end;
	return ret;
end;

local TC_Path={};
local TC_Color={};
local TC_Metric={};
local TC_Other={};
local function TC_Loadwaiei2Color(pFolder,pFile,themedir)
	for i=1,#pFile do
		if FileExist(themedir..pFolder[i].."/"..pFile[i]) then
			TC_Path[""..pFolder[i].." "..pFile[i]]=themedir..pFolder[i].."/"..pFile[i];
		end;
	end;
	local for_name={'Fallback','Group','Title','Artist','BPM','MAXBPM','MINBPM','Time','Difficulty'};
	for i=1,#for_name do
		if FileExist(themedir.."Wheel/Sort Jackets/sort "..string.lower(for_name[i])) then
			TC_Path["SortJacket "..for_name[i]]  =GetFileExist(themedir.."Wheel/Sort Jackets/sort "..string.lower(for_name[i]));
		end;
	end;
	
	local block="";
	local prm="";
	local metricFile=themedir.."/ThemeColor.ini";
	if FILEMAN:DoesFileExist(metricFile) then
		block=TC_GetTextBlock(metricFile,"main");	------------------------- [main]
		prm=TC_GetBlockPrm(block,"combonumberx");
		if prm~="" then TC_Metric["ComboNumber-PosX"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"combonumbery");
		if prm~="" then TC_Metric["ComboNumber-PosY"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"combolabelx");
		if prm~="" then TC_Metric["ComboLabel-PosX"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"combolabely");
		if prm~="" then TC_Metric["ComboLabel-PosY"]=tonumber(prm); end;

		block=TC_GetTextBlock(metricFile,"custommenu");	------------------------- [Title]
		prm=TC_GetBlockPrm(block,"folder");
		if prm~="" then TC_Other["CustomMenu-Folder"]='_,'..prm; end;
	end;
	metricFile=themedir.."/Wheel/ThemeColor.ini";
	if FILEMAN:DoesFileExist(metricFile) then
		block=TC_GetTextBlock(metricFile,"main");	------------------------- [main]
		prm=TC_GetBlockPrm(block,"mode");
		if prm~="" then TC_Metric["Wheel-Mode"]=string.lower(prm); end;
		prm=TC_GetBlockPrm(block,"positionx");
		if prm~="" then TC_Metric["Wheel-PosX"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"positiony");
		if prm~="" then TC_Metric["Wheel-PosY"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"positionz");
		if prm~="" then TC_Metric["Wheel-PosZ"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"zoomx");
		if prm~="" then TC_Metric["Wheel-ZoomX"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"zoomy");
		if prm~="" then TC_Metric["Wheel-ZoomY"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"zoomz");
		if prm~="" then TC_Metric["Wheel-ZoomZ"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"songcountx");
		if prm~="" then TC_Metric["Wheel-SongCountX"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"songcounty");
		if prm~="" then TC_Metric["Wheel-SongCountY"]=tonumber(prm); end;
		prm=TC_GetBlockPrm_Command(block,"songcountcommand");
		if prm~="" then TC_Metric["Wheel-SongCountCommand"]=prm; end;
		prm=TC_GetBlockPrm_Command(block,"oncommand");
		if prm~="" then TC_Metric["Wheel-OnCommand"]=prm; end;

		block=TC_GetTextBlock(metricFile,"scrollbar");	------------------------- [scrollbar]
		prm=TC_GetBlockPrm(block,"size");
		if prm~="" then TC_Metric["Wheel-ScrollBarSize"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"positionx");
		if prm~="" then TC_Metric["Wheel-ScrollBarPosX"]=tonumber(prm); end;
		prm=TC_GetBlockPrm(block,"positiony");
		if prm~="" then TC_Metric["Wheel-ScrollBarPosY"]=tonumber(prm); end;
	end;
end;

-- [ja] 必要な設定を行う 
function TC_Init(colorname,subcolor)
	TC_ColorName=colorname;
	TC_SubColor=subcolor or 'main';
	TC_Path={};
	TC_Color={};
	TC_Metric={};
	TC_Other={};
	--[[
	[ja] 2と1で同名テーマカラーがあると困るのでカラーモードも手動設定すること 
	if FILEMAN:DoesFileExist("/"..THEME:GetCurrentThemeDirectory()..waieiDir().."ThemeColors/"..colorname.."/ThemeColor.ini") then
		TC_SetwaieiMode(2);
	else
		TC_SetwaieiMode(1);
	end;
	--]]
	if TC_GetwaieiMode()==2 then
		TC_Path["Base"]="/"..THEME:GetCurrentThemeDirectory()..waieiDir().."ThemeColors/";
		local pFolder={};
		local pFile={};
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="highlight";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="group underlay";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="Song";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="Return";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="EXFolder";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="SectionCollapsed";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="SectionExpanded";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="Mode";
		pFolder[#pFolder+1]="ScreenWithMenuElements";	pFile[#pFile+1]="background";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="frame";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="over";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="long_marathon";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="split";
		pFolder[#pFolder+1]="GrooveRadar";	pFile[#pFile+1]="grooveradar";
		pFolder[#pFolder+1]="GrooveRadar";	pFile[#pFile+1]="autogen";
		pFolder[#pFolder+1]="ScreenGameplay";	pFile[#pFile+1]="ScoreFrame";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="DDR";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="SuperNOVA";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="StepMania";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="Hold";
		
		TC_Other['CustomMenu-Folder']='_';

		TC_Color["Wheel Return"]  =BoostColor(Color("White"),1.0);
		TC_Color["Wheel EXFolder"]=BoostColor(Color("Red"),1.1);
		TC_Color["Wheel Mode"]    =Color("Blue");

		TC_Metric["Wait-StageInformation"]=0.8;
		TC_Metric["Wait-GameplayIn"]=0.5;
		TC_Metric["Wait-GameplayOut"]=3.5;

		-- [ja] まずデフォルト定義 
		TC_Loadwaiei2Color(pFolder,pFile,TC_Path["Base"]..TC_Default().."/main/");
		
		-- [ja] 指定テーマカラーを定義 
		TC_Loadwaiei2Color(pFolder,pFile,TC_Path["Base"]..colorname.."/main/");
		
		-- [ja] サブテーマカラーを定義 
		if string.lower(TC_SubColor)~='main' then
			local dir=TC_Path["Base"]..colorname.."/"..TC_SubColor.."/";
			if FILEMAN:DoesFileExist(dir.."/ThemeColor.ini") then
				TC_Loadwaiei2Color(pFolder,pFile,dir);
			else
				TC_SubColor='main';
			end;
		end;
	else
		TC_Path["Base"]="/"..THEME:GetCurrentThemeDirectory()..waieiDir().."ThemeColors/";
		local pFolder={};
		local pFile={};
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="highlight";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="group underlay";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="Song";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="Return";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="EXFolder";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="SectionCollapsed";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="SectionExpanded";
		pFolder[#pFolder+1]="Wheel";	pFile[#pFile+1]="Mode";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="frame";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="over";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="long_marathon";
		pFolder[#pFolder+1]="BannerFrame";	pFile[#pFile+1]="split";
		pFolder[#pFolder+1]="Pane";	pFile[#pFile+1]="player";
		pFolder[#pFolder+1]="Pane";		pFile[#pFile+1]="bottom";
		pFolder[#pFolder+1]="Pane";		pFile[#pFile+1]="color";
		pFolder[#pFolder+1]="Pane";		pFile[#pFile+1]="side";
		pFolder[#pFolder+1]="GameFrame";	pFile[#pFile+1]="difficulty";
		pFolder[#pFolder+1]="GameFrame";	pFile[#pFile+1]="light";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="life left";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="life right";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="life center";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="life border";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="life into";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="light left";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="light right";
		pFolder[#pFolder+1]="Life";		pFile[#pFile+1]="light center";
		pFolder[#pFolder+1]="GameReady";	pFile[#pFile+1]="Background";
		pFolder[#pFolder+1]="GameReady";	pFile[#pFile+1]="Banner";
		pFolder[#pFolder+1]="GameReady";	pFile[#pFile+1]="Light L";
		pFolder[#pFolder+1]="GameReady";	pFile[#pFile+1]="Light R";
		pFolder[#pFolder+1]="GameReady";	pFile[#pFile+1]="Text Ready";
		pFolder[#pFolder+1]="GameReady";	pFile[#pFile+1]="Text Go";
		pFolder[#pFolder+1]="GrooveRadar";	pFile[#pFile+1]="overlay";
		pFolder[#pFolder+1]="GrooveRadar";	pFile[#pFile+1]="underlay";
		pFolder[#pFolder+1]="GrooveRadar";	pFile[#pFile+1]="autogen";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="DDR";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="SuperNOVA";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="StepMania";
		pFolder[#pFolder+1]="Judgment";		pFile[#pFile+1]="Hold";
		TC_Metric["ComboLabel-PosX"]=7;
		TC_Metric["ComboLabel-PosY"]=20;
		TC_Metric["ComboNumber-PosX"]=1;
		TC_Metric["ComboNumber-PosY"]=20;
		TC_Metric["Wheel-Mode"]='jacket';
		TC_Metric["Wheel-PosX"]=0;
		TC_Metric["Wheel-PosY"]=-40;
		TC_Metric["Wheel-PosZ"]=0;
		TC_Metric["Wheel-ZoomX"]=1.0;
		TC_Metric["Wheel-ZoomY"]=1.0;
		TC_Metric["Wheel-ZoomZ"]=1.0;
		TC_Metric["Wheel-SongCountX"]=45;
		TC_Metric["Wheel-SongCountY"]=-75;
		TC_Metric["Wheel-SongCountCommand"]='horizalign,right;zoom,0.75;strokecolor,0,0,0,0.1;diffuse,BoostColor(Color("Blue"),1.5);';
		TC_Metric["Wait-StageInformation"]=0.0;
		TC_Metric["Wait-GameplayIn"]=0.5;
		TC_Metric["Wait-GameplayOut"]=3.5;
		
		TC_Other['CustomMenu-Folder']='_,ThemeColors,Avatar';
		
		-- [ja] まずデフォルト定義 
		TC_Path["Color"]=TC_Path["Base"].."waiei/";
		TC_Path["Dir"]="_blue/";	-- [ja] cfgで定義されているディレクトリ名 
		for i=1,#pFile do
			TC_Path[""..pFolder[i].." "..pFile[i]]=TC_Path["Color"].."waiei/"..pFolder[i].."/"..pFile[i];
		end;
		local for_name={'Fallback','Group','Title','Artist','BPM','MAXBPM','MINBPM','Time','Difficulty'};
		for i=1,#for_name do
			TC_Path["SortJacket "..for_name[i]]  =GetFileExist(TC_Path["Color"].."waiei/Wheel/Sort Jackets/sort "..string.lower(for_name[i]));
		end;
		TC_Path["ScreenWithMenuElements background"]=TC_Path["Color"].."BGAnimations/ScreenWithMenuElements background/"..TC_Path["Dir"].."bg";
		TC_Path["ScreenWithMenuElements result"]    =TC_Path["Color"].."BGAnimations/ScreenWithMenuElements background/"..TC_Path["Dir"].."_bg top";
		TC_Path["ScreenSelectEXMusic background"]   =TC_Path["Color"].."BGAnimations/EXFolder background/"..TC_Path["Dir"].."bg";
		TC_Path["ScreenGameplay Frame1-Top"]        =TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar under1";
		TC_Path["ScreenGameplay Frame1-Bottom"]     =TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar bottom";
		TC_Path["ScreenGameplay Frame2-Top"]        =TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar under2";
		TC_Path["ScreenGameplay Frame2-Bottom"]     =TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar under3";
		TC_Path["ScreenGameplay Frame-Light"]       =TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar underL";
		TC_Path["ScreenGameplay Frame-SideLight"]   =TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar Effect";
		TC_Path["ScreenGameplay ScoreFrame"]        =TC_Path["Color"].."Graphics/_ScreenGameplay ScoreFrame/"..TC_Path["Dir"].."ScoreFrame";
		
		local f=OpenFile(TC_Path["Color"].."Graphics/"..TC_Path["Dir"].."Theme Colors.ini");
		TC_Color["Life Normal"]=Str2Color(GetFileParameter(f,"LifeNormal"));
		TC_Color["Life Hot"]   =Str2Color(GetFileParameter(f,"LifeHot"));
		TC_Color["Life Danger"]=Str2Color(GetFileParameter(f,"LifeDanger"));
		TC_Color["Life Bar"]   =Str2Color(GetFileParameter(f,"LifeBar"));
		CloseFile(f);
		TC_Color["Wheel Return"]  =Color("Blue");
		TC_Color["Wheel EXFolder"]=Color("Red");
		TC_Color["Wheel Mode"]=Color("Orange");
		
		-- [ja] 指定テーマカラーを定義 
		if FILEMAN:DoesFileExist(TC_Path["Color"].."ThemeColors/"..colorname..".cfg") then
			local f=OpenFile(TC_Path["Color"].."ThemeColors/"..colorname..".cfg");
			TC_Path["Dir"]=""..f:GetLine().."/";	-- [ja] cfgで定義されているディレクトリ名
			CloseFile(f);
			for i=1,#pFile do
				if FileExist(TC_Path["Color"].."waiei/"..pFolder[i].."/"..pFile[i]) then
					TC_Path[""..pFolder[i].." "..pFile[i]]=TC_Path["Color"].."waiei/"..pFolder[i].."/"..pFile[i];
				end;
			end;
			local _tmpPath="";
			_tmpPath=TC_Path["Color"].."BGAnimations/ScreenWithMenuElements background/"..TC_Path["Dir"].."bg";
			if FileExist(_tmpPath) then
				TC_Path["ScreenWithMenuElements background"]=_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."BGAnimations/ScreenWithMenuElements background/"..TC_Path["Dir"].."_bg top";
			if FileExist(_tmpPath) then
				TC_Path["ScreenWithMenuElements result"]    =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."BGAnimations/EXFolder background/"..TC_Path["Dir"].."bg";
			if FileExist(_tmpPath) then
				TC_Path["ScreenSelectEXMusic background"]   =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar under1";
			if FileExist(_tmpPath) then
				TC_Path["ScreenGameplay Frame1-Top"]        =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar bottom";
			if FileExist(_tmpPath) then
				TC_Path["ScreenGameplay Frame1-Bottom"]     =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar under2";
			if FileExist(_tmpPath) then
				TC_Path["ScreenGameplay Frame2-Top"]        =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar under3";
			if FileExist(_tmpPath) then
				TC_Path["ScreenGameplay Frame2-Bottom"]     =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."Graphics/_LifeMeterBar/"..TC_Path["Dir"].."LifeMeterBar underL";
			if FileExist(_tmpPath) then
				TC_Path["ScreenGameplay Frame-Light"]       =_tmpPath;
			end;
			_tmpPath=TC_Path["Color"].."Graphics/_ScreenGameplay ScoreFrame/"..TC_Path["Dir"].."ScoreFrame";
			if FileExist(_tmpPath) then
				TC_Path["ScreenGameplay ScoreFrame"]        =_tmpPath;
			end;
		
			local f=OpenFile(TC_Path["Color"].."Graphics/"..TC_Path["Dir"].."Theme Colors.ini");
			if GetFileParameter(f,"LifeNormal")~="" then TC_Color["Life Normal"]=Str2Color(GetFileParameter(f,"LifeNormal")); end;
			if GetFileParameter(f,"LifeHot")~="" then    TC_Color["Life Hot"]   =Str2Color(GetFileParameter(f,"LifeHot"));    end;
			if GetFileParameter(f,"LifeDanger")~="" then TC_Color["Life Danger"]=Str2Color(GetFileParameter(f,"LifeDanger")); end;
			if GetFileParameter(f,"LifeBar")~="" then    TC_Color["Life Bar"]   =Str2Color(GetFileParameter(f,"LifeBar"));    end;
			CloseFile(f);
		end;
	end;
	local spl_custom=split(',',TC_Other['CustomMenu-Folder']);
	local txt_custom=C_SetIniPrm('_','main','title');
	for c=2,#spl_custom do
		txt_custom=txt_custom..','..C_SetIniPrm(spl_custom[c],'main','title');
	end;
	TC_Other['CustomMenu-Title']=txt_custom;
	tc["Load"]=true;
--	setenv("TC_Path",TC_Path);
--	setenv("TC_Color",TC_Color);
--	setenv("TC_Metric",TC_Metric);
end;

function TC_GetPath(dir,file)
	if TC_Path then
		return TC_Path[""..dir.." "..file];
	end;
	return nil;
end;

function TC_GetColor(name)
	if TC_Color then
		return TC_Color[""..name];
	end;
	return Color("White");
end;

-- Metric 
function TC_GetMetric(sec,name)
	if TC_Metric and TC_Metric[sec.."-"..name] then
		return TC_Metric[sec.."-"..name];
	end;
	return "";
end;

-- [ja] 実行可能なコマンドの状態 
function TC_GetCommand(sec,name)
	if TC_Metric and TC_Metric[sec.."-"..name] then
	--local _cmd=TC_Metric[sec..'-'..name];
	--return "return function(self) self:Center() end'";
		return loadstring("return cmd("..TC_Metric[sec..'-'..name]..");")();
	end;
	return loadstring("return cmd(addx,0);")();
end;

-- [ja] CustomPlugins等の定義 
function TC_GetOther(sec,name)
	if TC_Other and TC_Other[sec.."-"..name] then
		return TC_Other[sec.."-"..name];
	end;
	return "";
end;

function TC_Wheel_SongCountCommand(self)
	loadstring("return cmd("..TC_Metric["Wheel-SongCountCommand"]..")")()(self);
end;

function TC_ScoreCommand(self)
	if TC_GetwaieiMode()==1 then
		self:shadowlength(1);
		self:strokecolor(Color("Outline"));
		self:addy(4);
		self:zoom(0.8);
	else
	end;
	return self;
end;



-- [ja] ホイールの情報取得用 
local wsongs={};
function TC_SetWheelSong(params,tc_paramas)
	for i=1,tonumber(THEME:GetMetric("MusicWheel","NumWheelItems")) do
		if type(params)=="table" then
			wsongs[params.DrawIndex]=tc_paramas;
		else
			wsongs[params]=tc_paramas;
		end;
	end;
end;
function TC_GetWheelSong(index)
	if index then
		return wsongs[index];
	end;
	return nil;
end;
function TC_SetWheelFolder(params,tc_paramas)
	TC_SetWheelSong(params,tc_paramas);
end;
function TC_GetWheelReturn(index)
	return TC_GetWheelSong(index);
end;
function TC_GetWheelEXFolder(index)
	return TC_GetWheelSong(index);
end;
function TC_GetWheel(index,prm)
	if index and wsongs[index] then
		local tc_paramas=wsongs[index];
		if tc_paramas[prm] then
			return tc_paramas[prm];
		else
			return nil;
		end;
	end;
	return nil;
end;
--song
function GetSongWheel_Index(index)
	return TC_GetWheel(index,"Index");
end;
function GetSongWheel_Song(index)
	return TC_GetWheel(index,"Song");
end;
function GetSongWheel_Title(index)
	return TC_GetWheel(index,"Title") or "";
end;
function GetSongWheel_SubTitle(index)
	return TC_GetWheel(index,"SubTitle") or "";
end;
function GetSongWheel_Artist(index)
	return TC_GetWheel(index,"Artist") or "";
end;
function GetSongWheel_Graphic(index)
	return TC_GetWheel(index,"Graphic") or THEME:GetPathG("Common fallback","jacket");
end;
function GetSongWheel_Color(index)
	return TC_GetWheel(index,"Color") or waieiColor("WheelDefault");
end;
function GetSongWheel_MeterType(index)
	return TC_GetWheel(index,"MeterType") or "ddr";
end;
--folder
function GetFolderWheel_Index(index)
	return TC_GetWheel(index,"Index");
end;
function GetFolderWheel_Label(index)
	return TC_GetWheel(index,"Label") or "";
end;
function GetFolderWheel_Color(index)
	return TC_GetWheel(index,"Color") or waieiColor("WheelDefault");
end;
function GetFolderWheel_Graphic(index)
	return TC_GetWheel(index,"Graphic") or THEME:GetPathG("Common fallback","jacket");
end;
function GetFolderWheel_GraphicColor(index)
	return TC_GetWheel(index,"GraphicColor") or Color("White");
end;
function GetFolderWheel_NumSongs(index)
	return TC_GetWheel(index,"NumSongs") or 0;
end;
function GetFolderWheel_GroupName(index)
	return TC_GetWheel(index,"GroupName") or "";
end;

function ActorWheel()
	if IsEXFolder() then
		return Def.Sprite;
	else
		return Def.Banner;
	end;
end;
