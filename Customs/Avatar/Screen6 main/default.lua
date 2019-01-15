--[[
	アバター設定
	６：アバター名前変更（描画）
--]]

local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

local av=c_getenvg('av');
local av_file=c_getenvg('av_file');
local av_name=c_getenvg('av_name');
local char=c_getenvg('char');
local sel_char=1;
local showname='';
t[#t+1]=Def.ActorFrame{
	ReadyMessageCommand=function(self,params)
		if params.sel then
			sel_char=params.sel;
		end;
		self:queuecommand('Changed');
	end;
	SetNameMessageCommand=function(self,params)
		if params.name then
			av_name=params.name;
		end;
		if params.show then
			showname=params.show;
		end;
		self:queuecommand('Changed');
	end;
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-300);
			self:y(-180);
			self:horizalign(left);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(1.5);
			self:settext(C_GetLang('Name','Header'));
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-300);
			self:y(-150);
			self:horizalign(left);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext(C_GetLang('Name','Notice'));
		end;
	};
	LoadActor(THEME:GetPathG('_Avatar','graphics/hq'),1,av,AVATAR_NORMAL)..{
		InitCommand=function(self)
			self:y(-90);
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-40);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext(C_GetLang('Name','Help'));
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.8);
			self:settext("");
		end;
		ChangedCommand=function(self)
			self:settext(av_name);
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,20,20;diffuseshift);
		ChangedCommand=function(self)
			if (sel_char-1)<#char-2 then
				self:x(-140+((sel_char-1)%14)*20);
				self:zoomto(20,20);
			else
				self:x(-80+((sel_char-1)%14)*140);
				self:zoomto(140,20);
			end;
			self:y(40+math.floor((sel_char-1)/14)*20);
		end;
	};
};
for c=1,#char do
	local _c=c-1;
	t[#t+1]=Def.ActorFrame{
		LoadFont('Common Normal')..{
			InitCommand=function(self)
				if c<#char-2 then
					self:x(-140+(_c%14)*20);
				else
					self:x(-80+(_c%14)*140);
				end;
				self:y(40+math.floor(_c/14)*20);
				self:diffuse(Color('White'));
				self:strokecolor(Color('Outline'));
				self:zoom(0.66);
				self:settext(char[c]);
			end;
		};
	};
end;

t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','in'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};
t.InitCommand=function(self)
	self:Center();
end;

return t;