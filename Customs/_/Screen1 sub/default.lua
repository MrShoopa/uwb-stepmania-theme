--[[
	プラグイン起動
--]]

local sys_lock=true;
local t=Def.ActorFrame{};

local cusPath={};
local cusName={};
local cusCnt=0;
-- [ja] プラグイン一覧取得 
local cuslist=FILEMAN:GetDirListing(C_GetCustomDir(),true,false);
for c=1,#cuslist do
	if cuslist[c]~='_' then
		local lcuslist=string.lower(cuslist[c]);
		if FILEMAN:DoesFileExist(C_GetCustomDir()..cuslist[c]..'/custom.ini') then
			cusCnt=cusCnt+1;
			cusPath[cusCnt]=cuslist[c];
			cusName[cusCnt]=C_SetIniPrm(cuslist[c],'main','title');
		end;
	end;
end;

local sel_custom=1;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("CustomInit",{path=cusPath,name=cusName,cnt=cusCnt,sel=sel_custom});
		self:sleep(EXF_BEGIN_WAIT());
		self:queuecommand("UnLockKey");
	end;
	UnLockKeyCommand=function(self)
		sys_lock=false;
	end;
	KeyDownMessageCommand=function(self,params)
		if not sys_lock then
			if cusCnt>0 then
				if C_GetKey(PLAYER_1,"Start") or C_GetKey(PLAYER_2,"Start") then
					sys_lock=true;
					self:queuecommand("Start");
					self:queuecommand("NextScreen1");
				elseif C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_2,"Left") then
				elseif C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_2,"Right") then
				elseif C_GetKey(PLAYER_1,"Up") or C_GetKey(PLAYER_2,"Up") then
					sel_custom=((sel_custom-1)-1+cusCnt)%cusCnt+1;
					MESSAGEMAN:Broadcast("CustomChanged",{sel=sel_custom});
					self:queuecommand("Sound1Play");
				elseif C_GetKey(PLAYER_1,"Down") or C_GetKey(PLAYER_2,"Down") then
					sel_custom=((sel_custom-1)+1)%cusCnt+1;
					MESSAGEMAN:Broadcast("CustomChanged",{sel=sel_custom});
					self:queuecommand("Sound1Play");
				elseif C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
					sys_lock=true;
					self:queuecommand("CancelPlay");
					self:queuecommand("BackScreen1");
				end;
			else
				if C_GetKey(PLAYER_1,"Start") or C_GetKey(PLAYER_2,"Start")
					or C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
					sys_lock=true;
					self:queuecommand("CancelPlay");
					self:queuecommand("BackScreen1");
				end;
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
		self:sleep(0.5);
		self:queuecommand("NextScreen2");
	end;
	NextScreen2Command=function(self)
		C_Init(cusPath[sel_custom]);
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