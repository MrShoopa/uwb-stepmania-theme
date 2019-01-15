--[[
	アバター設定
	４：エディット（描画）
--]]

local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

local part={
	C_GetLang('Parts','Style'),
	'*'..C_GetLang('Parts','BackHair'),
	C_GetLang('Parts','Face'),
	C_GetLang('Parts','Eye1'),
	C_GetLang('Parts','Eye2'),
	C_GetLang('Parts','Mouth'),
	'*'..C_GetLang('Parts','MainHair'),
	'*'..C_GetLang('Parts','SideHair'),
	'*'..C_GetLang('Parts','FlontHair'),
	'*'..C_GetLang('Parts','AccentHair'),
	C_GetLang('Parts','Brow'),
	'*'..C_GetLang('Parts','Accessory1'),
	'*'..C_GetLang('Parts','Accessory2'),
	C_GetLang('Parts','Save')
};
local expression={
	C_GetLang('Style','Normal'),
	C_GetLang('Style','Win'),
	C_GetLang('Style','Lose')
};
local av_default={};
t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG('_Avatar','graphics/hq'),1,c_getenvg('av'),c_getenvg('select_style'))..{
		InitCommand=function(self)
			self:x(160);
			self:zoom(1.8);
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-300);
			self:y(-180);
			self:horizalign(left);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(1.5);
			self:playcommand('Set');
		end;
		SetMessageCommand=function(self,params)
			local num=(params and (params.Style or 0) or 0);
			self:settext(C_GetLang('Parts','Style')..' - '..expression[num+1]);
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
			self:settext(C_GetLang('Parts','Notice'));
		end;
	};
};
local BASE_Y=-120;

t[#t+1]=Def.ActorFrame{
	InitCommand=function(self)
		self:playcommand('Set');
	end;
	Def.Quad{
		InitCommand=cmd(zoomto,320,22;faderight,1;horizalign,left;
			diffuse,Color('Blue');blend,'BlendMode_Add');
		SetMessageCommand=function(self,params)
			local num=(params and (params.Part or 1) or 1);
			self:x(-270);
			self:y(BASE_Y+num*20);
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-260);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext('&MENULEFT;');
		end;
		SetMessageCommand=function(self,params)
			local num=(params and (params.Part or 1) or 1);
			self:y(BASE_Y+num*20);
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-60);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext('&MENURIGHT;');
		end;
		SetMessageCommand=function(self,params)
			local num=(params and (params.Part or 1) or 1);
			self:y(BASE_Y+num*20);
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-40);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext(C_GetLang('Main','ChangeColor'));
		end;
	};
};
for p=1,#part do
	t[#t+1]=Def.ActorFrame{
		LoadFont('Common Normal')..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(-240);
				self:y(BASE_Y+p*20);
				self:diffuse(Color('White'));
				self:strokecolor(Color('Outline'));
				self:zoom(0.8);
				self:playcommand('Set');
			end;
			SetMessageCommand=function(self,params)
				if part[p]==C_GetLang('Parts','Save') then
					if params then
						if params.Save==1 then
							self:settext(C_GetLang('Parts','NewSave'));
						elseif params.Save==2 then
							self:settext(C_GetLang('Parts','Exit'));
						else
							self:settext(C_GetLang('Parts','Save'));
						end;
					else
						self:settext(C_GetLang('Parts','Save'));
					end;
				else
					self:settext(part[p]);
				end;
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