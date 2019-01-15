--[[
	アバター設定
	３：割り当て・編集（処理）
--]]

local sys_lock=true;
local t=Def.ActorFrame{};

local av=c_getenvg('av');
local av_file=c_getenvg('av_file');
local sel_menu=0;
local profile={};
local sel_profile=1;

local pro_id=PROFILEMAN:GetLocalProfileIDs();

local menu={
	C_GetLang('Set','Edit'),
	C_GetLang('Set','SetProfile'),
	C_GetLang('Set','ReleaseAvatar')
};
for p=1,#pro_id do
	local pro=PROFILEMAN:GetLocalProfile(pro_id[p]);
	profile[#profile+1]=pro:GetDisplayName();
end;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("SetMenu",{menu=menu,profile=profile});
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
				self:queuecommand("Start");
				self:queuecommand("NextScreen1");
			elseif sel_menu>=1 and 
				(C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_2,"Left")) then
				sel_profile=((sel_profile-1)-1+#profile)%#profile+1;
				MESSAGEMAN:Broadcast("ProChanged",{index=sel_profile});
				self:queuecommand("Sound2Play");
			elseif sel_menu>=1 and 
				(C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_2,"Right")) then
				sel_profile=((sel_profile-1)+1)%#profile+1;
				MESSAGEMAN:Broadcast("ProChanged",{index=sel_profile});
				self:queuecommand("Sound2Play");
			elseif C_GetKey(PLAYER_1,"Up") or C_GetKey(PLAYER_2,"Up") then
				if #profile>0 then
					sel_menu=(sel_menu-1+#menu)%#menu;
					MESSAGEMAN:Broadcast("SelChanged",{index=sel_menu+1});
				end;
				self:queuecommand("Sound1Play");
			elseif C_GetKey(PLAYER_1,"Down") or C_GetKey(PLAYER_2,"Down") then
				if #profile>0 then
					sel_menu=(sel_menu+1)%#menu;
					MESSAGEMAN:Broadcast("SelChanged",{index=sel_menu+1});
				end;
				MESSAGEMAN:Broadcast("SelChanged",{index=sel_menu+1});
				self:queuecommand("Sound1Play");
			elseif C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
				sys_lock=true;
				self:queuecommand("CancelPlay");
				self:queuecommand("BackScreen1");
			end;
		end;
	end;
	BackScreen1Command=function(self)
		self:sleep(0.5);
		self:queuecommand("BackScreen2");
	end;
	BackScreen2Command=function(self)
		C_SetPrevScreen();
	end;
	NextScreen1Command=function(self)
		if sel_menu==0 then
			c_setenvg('av',av);
			c_setenvg('av_file',av_file);
			self:sleep(0.5);
			self:queuecommand("NextScreen2");
		elseif (sel_menu==1 or sel_menu==2) and #pro_id>0 then
			-- [ja] 何故かsProfileIDからディレクトリをとる関数がない 
			local dir='Save/LocalProfiles/'..pro_id[sel_profile]..'/';
			local file=GetFileNameFormPath(av_file);
			-- [ja] ToDo: このままだとアバター情報以外消えるので要対応 
			if sel_menu==1 then
				SaveINIOneLine(dir..'waieiSettings.ini','Main','Avatar',file[1]..'.ini');
			else
				SaveINIOneLine(dir..'waieiSettings.ini','Main','Avatar','');
			end;
			self:sleep(0.5);
			self:queuecommand("BackScreen2");
		else
			self:sleep(0.5);
			self:queuecommand("BackScreen2");
		end;
	end;
	NextScreen2Command=function(self)
		C_SetNextScreen();
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
		StartMessageCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
		Sound1PlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("Common","value")) .. {
		Sound2PlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("Common","Cancel")) .. {
		CancelPlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
		BackScreen1Command=cmd(linear,0.4;diffusealpha,1);
		NextScreen1Command=cmd(playcommand,'BackScreen1');
	};
};

return t;