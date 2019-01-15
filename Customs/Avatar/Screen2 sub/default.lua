--[[
	アバター設定
	２：アバター選択（処理）
--]]

local sys_lock=true;
local t=Def.ActorFrame{};

local avaFile=c_getenvg('file');
local avaName=c_getenvg('name');
local avaCnt =c_getenvg('cnt' );
local sel_avatar=1;
local face=AVATAR_NORMAL;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
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
			elseif C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_2,"Left") then
				face=(face-1+3)%3;
				MESSAGEMAN:Broadcast("AvatarChanged",{id=1,t=face});
				self:queuecommand("Sound2Play");
			elseif C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_2,"Right") then
				face=(face+1)%3;
				MESSAGEMAN:Broadcast("AvatarChanged",{id=1,t=face});
				self:queuecommand("Sound2Play");
			elseif C_GetKey(PLAYER_1,"Up") or C_GetKey(PLAYER_2,"Up") then
				sel_avatar=((sel_avatar-1)-1+avaCnt)%avaCnt+1;
				MESSAGEMAN:Broadcast("AvatarChanged",{id=1,av=GetAvatar(avaFile[sel_avatar]),t=face,sel=sel_avatar});
				self:queuecommand("Sound1Play");
			elseif C_GetKey(PLAYER_1,"Down") or C_GetKey(PLAYER_2,"Down") then
				sel_avatar=((sel_avatar-1)+1)%avaCnt+1;
				MESSAGEMAN:Broadcast("AvatarChanged",{id=1,av=GetAvatar(avaFile[sel_avatar]),t=face,sel=sel_avatar});
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
		C_End('ScreenTitleMenu');
	end;
	NextScreen1Command=function(self)
		if sel_avatar==1 then	--[ja] 新規作成 
			c_setenvg('av',GetDefaultAvatar());
		else
			c_setenvg('av',GetAvatar(avaFile[sel_avatar]));
		end;
		c_setenvg('av_file',avaFile[sel_avatar]);
		self:sleep(0.5);
		self:queuecommand("NextScreen2");
	end;
	NextScreen2Command=function(self)
		if sel_avatar==1 then
			C_SetScreenNumber(4);
		else
			C_SetNextScreen();
		end;
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