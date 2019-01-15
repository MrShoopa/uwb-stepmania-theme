--[[
	プラグイン起動（描画）
--]]

local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

local cusPath={};
local cusName={};
local cusCnt= 0;
local SCROLL=math.max(180/1,20);
local sel_custom=0;
t[#t+1]=Def.ActorFrame{
	CustomInitMessageCommand=function(self,params)
		cusPath=params.path;
		cusName=params.name;
		cusCnt =params.cnt;
		sel_custom=params.sel;
		SCROLL=math.max(180/cusCnt,20);
		self:queuecommand('Changed');
	end;
	CustomChangedMessageCommand=function(self,params)
		sel_custom=params.sel;
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
			self:settext('');
		end;
		ChangedCommand=function(self,params)
			if #cusName>0 then
				self:settext(cusName[sel_custom]);
			else
				self:settext('ない');
			end;
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
			self:zoomto(20,0);
			self:vertalign(middle);
			self:diffuseshift();
			self:x(-170);
		end;
		ChangedCommand=function(self)
			if cusCnt>1 then
				self:zoomto(20,SCROLL);
				self:y(((sel_custom-1)*(180-SCROLL)/(cusCnt-1))-90+SCROLL/2);
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
			self:settext('&MenuUp;');
		end;
		ChangedCommand=function(self)
			if cusCnt<=1 then
				self:diffusealpha(0.5);
			else
				self:diffusealpha(1.0);
			end;
		end;
	};
	LoadFont('common normal')..{
		InitCommand=function(self)
			self:zoom(0.8);
			self:vertalign(top);
			self:x(-170);
			self:y(100);
			self:settext('&MenuDown;');
		end;
		ChangedCommand=function(self)
			if cusCnt<=1 then
				self:diffusealpha(0.5);
			else
				self:diffusealpha(1.0);
			end;
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-40);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext(C_GetLang('Main','SelCustomHelp'));
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