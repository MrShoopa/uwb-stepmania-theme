--[[
	アバター設定
	６：アバター名前変更（処理）
--]]

local sys_lock=true;
local t=Def.ActorFrame{};

local av=c_getenvg('av');
local av_file=c_getenvg('av_file');
local av_name=c_getenvg('av_name');
local char=c_getenvg('char');
local sel_char=1;
if av_name=='' then
	av_name='New Avatar';
end;
local showname="";
for i=1,string.len(av_name) do
	local sub=string.sub(av_name,i,i);
	for c=1,#char do
		if sub==char[c] then
			showname=showname..char[c];
			break;
		end;
	end;
end;
if av_name~=showname then
	av_name=showname;
end;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("Ready",{sel=sel_char});
		MESSAGEMAN:Broadcast("SetName",{name=av_name,show=showname});
		self:sleep(EXF_BEGIN_WAIT());
		self:queuecommand("UnLockKey");
	end;
	UnLockKeyCommand=function(self)
		sys_lock=false;
	end;
	KeyDownMessageCommand=function(self,params)
		if not sys_lock then
			if C_GetKey(PLAYER_1,"Start") or C_GetKey(PLAYER_2,"Start") then
				if sel_char<#char-1 then
					av_name=av_name..char[sel_char];
					MESSAGEMAN:Broadcast("SetName",{name=av_name});
				elseif sel_char==#char-1 then
					sys_lock=true;
					self:queuecommand("NextScreen1");
				elseif sel_char==#char then
					sys_lock=true;
					self:queuecommand("BackScreen1");
				end;
				self:queuecommand("Start");
			elseif C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
				if string.len(av_name)>0 then
					av_name=string.sub(av_name,1,string.len(av_name)-1);
				end;
				MESSAGEMAN:Broadcast("SetName",{name=av_name});
				self:queuecommand("CancelPlay");
			end;
			if C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_2,"Left") then
				sel_char=((sel_char-1)-1+#char)%#char+1;
				MESSAGEMAN:Broadcast("Ready",{sel=sel_char});
				self:queuecommand("Sound2Play");
			end;
			if C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_2,"Right") then
				sel_char=((sel_char-1)+1)%#char+1;
				MESSAGEMAN:Broadcast("Ready",{sel=sel_char});
				self:queuecommand("Sound2Play");
			end;
			if C_GetKey(PLAYER_1,"Up") or C_GetKey(PLAYER_2,"Up") then
				if sel_char>=(#char) then
					sel_char=#char-8;
				elseif sel_char==(#char-1) then
					sel_char=#char-15;
				elseif sel_char<=7 then
					sel_char=#char-1;
				elseif sel_char<=14 then
					sel_char=#char;
				else
					sel_char=((sel_char-1)-14+#char)%#char+1;
				end;
				MESSAGEMAN:Broadcast("Ready",{sel=sel_char});
				self:queuecommand("Sound2Play");
			end;
			if C_GetKey(PLAYER_1,"Down") or C_GetKey(PLAYER_2,"Down") then
				if sel_char>=#char then
					sel_char=8;
				elseif sel_char>=#char-1 then
					sel_char=1;
				elseif sel_char>=#char-8 then
					sel_char=#char;
				elseif sel_char>=#char-15 then
					sel_char=#char-1;
				else
					sel_char=((sel_char-1)+14)%#char+1;
				end;
				MESSAGEMAN:Broadcast("Ready",{sel=sel_char});
				self:queuecommand("Sound2Play");
			end;
		end;
	end;
	BackScreen1Command=function(self)
		self:sleep(0.5);
		self:queuecommand("BackScreen2");
	end;
	BackScreen2Command=function(self)
		C_SetScreenNumber(1);
	end;
	NextScreen1Command=function(self)
		local savename=av_name;
		-- [ja] '新しく保存する'からきているため新規で保存
		SaveAvatar(av,savename,av_name,false);
		self:sleep(0.5);
		self:queuecommand("NextScreen2");
	end;
	NextScreen2Command=function(self)
		C_SetScreenNumber(1);
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
		OnCommand=cmd(playcommand,'Start');
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