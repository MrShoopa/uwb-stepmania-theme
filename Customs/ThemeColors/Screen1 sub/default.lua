local sys_lock=true;
--local key_back=false;

local tc_dir=THEME:GetCurrentThemeDirectory().."ThemeColors/";
local tc_list={};
tc_list[1]={
	id="A1-BlueIce";	-- [ja] ソート用、デフォルトカラーは必ず優先されるようにする 
	dir="BlueIce";
	name="BlueIce";
	mode=2;
	color=2;
};
tc_list[2]={
	id="B1-Blue";
	name="Blue";
	dir="_blue";
	mode=1;
	color=1;
};
tc_list[3]={
	id="B2-Black";
	name="Black";
	dir="_bk";
	mode=1;
	color=1;
};
local tc_num=3;
local tc_sel=1;
local dirlist=FILEMAN:GetDirListing(tc_dir,true,false);
for dl=1,#dirlist do
	local ldirlist=string.lower(dirlist[dl]);
	if ldirlist~="blueice" and "waiei" then
		if FILEMAN:DoesFileExist(tc_dir..dirlist[dl].."/ThemeColor.ini") then
			tc_num=tc_num+1;
			tc_list[tc_num]={
				id="A2-"..dirlist[dl];
				name=dirlist[dl];
				dir=dirlist[dl];
				mode=2;
				color=2;
			};
		end;
	end;
end;
dirlist=FILEMAN:GetDirListing(tc_dir.."waiei/ThemeColors/",false,false);
for dl=1,#dirlist do
	local ldirlist=string.lower(dirlist[dl]);
	if ldirlist~="blue.cfg" and ldirlist~="black.cfg" then
		local d="_blue";
		local f=OpenFile(THEME:GetCurrentThemeDirectory().."ThemeColors/waiei/ThemeColors/"..dirlist[dl]);
		d=f:GetLine();
		CloseFile(f);
		tc_num=tc_num+1;
		tc_list[tc_num]={
			id="B3-"..dirlist[dl];
			name=split(".cfg",dirlist[dl])[1];
			dir=d;
			mode=1;
			color=1;
		};
	end;
end;


table.sort(tc_list,
	function(a,b)
		return (a.id < b.id)
	end);
for i=1,#tc_list do
	if TC_GetColorName()==tc_list[i].name then
		tc_sel=i;
	end;
end;

local t=Def.ActorFrame{};

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		local params={
			sel=tc_sel;
			max=tc_num;
			dir=tc_list[tc_sel].dir;
			id=tc_list[tc_sel].id;
			name=tc_list[tc_sel].name;
			mode=tc_list[tc_sel].mode;
			color=tc_list[tc_sel].color;
		};
		MESSAGEMAN:Broadcast("Set",params);
		self:sleep(EXF_BEGIN_WAIT());
		self:queuecommand("UnLockKey");
	end;
	UnLockKeyCommand=function(self)
		sys_lock=false;
	end;
	KeyDownMessageCommand=function(self,params)
		if not sys_lock then
			if C_GetKey(PLAYER_1,"Start") or C_GetKey(PLAYER_2,"Start") then
				sys_lock=true;
				MESSAGEMAN:Broadcast("Start");
			elseif C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_1,"Up")
				or C_GetKey(PLAYER_2,"Left") or C_GetKey(PLAYER_2,"Up") then
				tc_sel=tc_sel-1;
				if tc_sel<1 then
					tc_sel=tc_num;
				end;
				local params={
					sel=tc_sel;
					max=tc_num;
					id=tc_list[tc_sel].id;
					dir=tc_list[tc_sel].dir;
					name=tc_list[tc_sel].name;
					mode=tc_list[tc_sel].mode;
					color=tc_list[tc_sel].color;
				};
				MESSAGEMAN:Broadcast("Set",params);
				self:queuecommand("SoundPlay");
			elseif C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_1,"Down")
				or C_GetKey(PLAYER_2,"Right") or C_GetKey(PLAYER_2,"Down") then
				tc_sel=tc_sel+1;
				if tc_sel>tc_num then
					tc_sel=1;
				end;
				local params={
					sel=tc_sel;
					max=tc_num;
					id=tc_list[tc_sel].id;
					dir=tc_list[tc_sel].dir;
					name=tc_list[tc_sel].name;
					mode=tc_list[tc_sel].mode;
					color=tc_list[tc_sel].color;
				};
				MESSAGEMAN:Broadcast("Set",params);
				self:queuecommand("SoundPlay");
			elseif C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
				sys_lock=true;
				C_Cancel('ScreenTitleMenu');
			end;
		end;
	end;
	--　[ja] ScreenSelectMasterなのでバック処理は不要
	StartMessageCommand=function(self)
		-- [ja] テーマ情報の設定 
		-- [ja] サブテーマカラーは後で実装
		TC_SetThemeStats(tc_list[tc_sel].mode,tc_list[tc_sel].name,'main',tc_list[tc_sel].color);
		self:sleep(0.4);
		self:queuecommand("NextScreen");
	end;
	NextScreenCommand=function(self)
		if GetSMVersion()>=40 then
			THEME:SetTheme(THEME:GetCurThemeName());	-- [ja] 意図的にテーマを再読み込みする 
		end;
		SCREENMAN:SetNewScreen("ScreenChangedThemeColors");
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
		StartMessageCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
		SoundPlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
};

return t;