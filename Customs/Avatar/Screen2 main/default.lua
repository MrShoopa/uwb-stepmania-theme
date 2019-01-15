--[[
	アバター設定
	２：アバター選択（描画）
--]]

local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

local avaFile=c_getenvg('file');
local avaName=c_getenvg('name');
local avaCnt= c_getenvg('cnt');
local SCROLL=math.max(180/avaCnt,20);
local sel_avatar=1;
t[#t+1]=Def.ActorFrame{
	AvatarChangedMessageCommand=function(self,params)
		if params.sel then
			sel_avatar=params.sel;
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
			self:settext(C_GetLang('Main','Select'));
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:diffuse(Color('White'));
			self:strokecolor(Color('Black'));
			self:maxwidth(200);
			self:x(-40);
			self:settext(avaName[sel_avatar]);
		end;
		ChangedCommand=function(self,params)
			self:settext(avaName[sel_avatar]);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(22,182);
			self:vertalign(middle);
			self:diffuse(0,0,0,0.5);
			self:x(-170);
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(20,SCROLL);
			self:vertalign(middle);
			self:diffuseshift();
			self:x(-170);
		end;
		ChangedCommand=function(self)
			if avaCnt>1 then
				self:y(((sel_avatar-1)*(180-SCROLL)/(avaCnt-1))-90+SCROLL/2);
			else
				self:visible(false);
			end;
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:zoom(0.8);
			self:vertalign(bottom);
			self:x(-170);
			self:y(-100);
			if avaCnt<=1 then
				self:diffusealpha(0.5);
			end;
			self:settext('&MenuUp;');
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:zoom(0.8);
			self:vertalign(top);
			self:x(-170);
			self:y(100);
			if avaCnt<=1 then
				self:diffusealpha(0.5);
			end;
			self:settext('&MenuDown;');
		end;
	};
	LoadActor(THEME:GetPathG('_Avatar','graphics/hq'),1,GetAvatar(avaFile[sel_avatar]),AVATAR_NORMAL)..{
		InitCommand=function(self)
			self:x(150);
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-40);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext(C_GetLang('Main','SelAvatarHelp'));
		end;
	};
};

t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','in'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};
t.InitCommand=function(self)
	self:Center();
end;

return t;