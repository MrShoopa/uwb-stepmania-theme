--[[
	アバター設定
	３：割り当て・編集（描画）
--]]

local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

local menu={};
local av_file=c_getenvg('av_file');
local profile={};
local sel_profile=1;

t[#t+1]=Def.ActorFrame{
	SetMenuMessageCommand=function(self,params)
		if params.menu then
			menu=params.menu;
		end;
		if params.profile then
			profile=params.profile;
		end;
		MESSAGEMAN:Broadcast("SelChanged",{index=1});
		MESSAGEMAN:Broadcast("ProChanged",{index=1});
	end;
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-300);
			self:y(-180);
			self:horizalign(left);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(1.5);
			self:settext(C_GetLang('Set','Header'));
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
			self:settext(C_GetLang('Set','Notice'));
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:x(-60);
			self:y(-70);
			self:zoomto(200,60);
			self:fadeleft(1);
			self:faderight(1);
			self:diffuse(Color('Blue'));
			self:blend('BlendMode_Add');
		end;
		SelChangedMessageCommand=function(self,params)
			self:y((params.index-2)*70+15);
		end;
	};
};

for i=0,2 do
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(y,(i-1)*70);
	SelChangedMessageCommand=function(self,params)
		if params.index==(i+1) then
			self:diffusealpha(1);
		else
			self:diffusealpha(0.5);
		end;
	end;
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:diffuse(Color('White'));
			self:strokecolor(Color('Black'));
			self:maxwidth(260);
			self:x(-60);
			if i<1 then
				self:y(15);
			else
				self:y(0);
			end;
			self:settext("");
		end;
		SelChangedMessageCommand=function(self,params)
			self:settext(menu[i+1]);
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:diffuse(BoostColor(Color('Blue'),1.3));
			self:strokecolor(Color('Black'));
			self:maxwidth(240);
			self:x(-60);
			self:y(30);
			if i<1 then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;
		ProChangedMessageCommand=function(self,params)
			if #profile>0 then
				self:settext(profile[params.index]);
			else
				self:settext("");
			end;
		end;
		SelChangedMessageCommand=function(self,params)
			if i>0 and params.index==(i+1) then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:strokecolor(Color('Black'));
			self:maxwidth(260);
			self:x(-190);
			self:y(30);
			if i<1 then
				self:visible(false);
				self:settext("");
			else
				self:visible(true);
				self:settext("&MenuLeft;");
			end;
		end;
		SelChangedMessageCommand=function(self,params)
			if i>0 and params.index==(i+1) then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:strokecolor(Color('Black'));
			self:maxwidth(260);
			self:x(70);
			self:y(30);
			if i<1 then
				self:visible(false);
				self:settext("");
			else
				self:visible(true);
				self:settext("&MenuRight;");
			end;
		end;
		SelChangedMessageCommand=function(self,params)
			if i>0 and params.index==(i+1) then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
};
end;

t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG('_Avatar','graphics/hq'),1,GetAvatar(av_file),AVATAR_NORMAL)..{
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
			self:settext(C_GetLang('Set','Help'));
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