--[[
	アバター設定
	５：カラー設定（描画）
--]]

local t=Def.ActorFrame{
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','background'))..{
		InitCommand=cmd(x,-SCREEN_CENTER_X;y,-SCREEN_CENTER_Y);
	};
};

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
			self:settext(C_GetLang('Color','Header'));
		end;
	};
};

for y=1,3 do
	local set_chk=0;
	t[#t+1]=Def.Quad{
		InitCommand=function(self)
			(cmd(zoomto,22,22;x,-854/4-1;y,y*22;horizalign,left;
				diffuse,0,0,0,0.5;))(self)
			self:playcommand('Set');
		end;
		SetMessageCommand=function(self,params)
			local col=(params and (params.Col or 1) or 1);
			local rgb=(params and (params.RGB and (params.RGB[y] or 0) or 0) or 0);
			self:diffusealpha((y==col) and 0.5 or 0.2);
			self:x(rgb*22-854/4-1);
		end;
	};
	for x=0,10 do
		t[#t+1]=Def.Quad{
			InitCommand=function(self)
				(cmd(zoomto,20,20;x,x*22-854/4;y,y*22;horizalign,left;
					diffuse,(y==1) and x*0.1 or 0,(y==2) and x*0.1 or 0,(y==3) and x*0.1 or 0,1.0;))(self)
				self:playcommand('Set');
			end;
			SetMessageCommand=function(self,params)
				local col=(params and (params.Col or 1) or 1);
				self:diffusealpha((y==col) and 1.0 or 0.2);
			end;
		};
	end;
	t[#t+1]=Def.Quad{
		InitCommand=function(self)
			(cmd(zoomto,20,20;x,-854/4;y,y*22;horizalign,left;
				diffuseshift;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0;))(self)
			self:playcommand('Set');
		end;
		SetMessageCommand=function(self,params)
			local col=(params and (params.Col or 1) or 1);
			local rgb=(params and (params.RGB and (params.RGB[y] or 0) or 0) or 0);
			self:diffusealpha((y==col) and 1.0 or 0.2);
			self:x(rgb*22-854/4);
		end;
	};
	t[#t+1]=LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-854/4-20);
			self:y(y*22);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext('&MENULEFT;');
			self:playcommand('Set');
		end;
		SetMessageCommand=function(self,params)
			local col=(params and (params.Col or 1) or 1);
			self:diffusealpha((y==col) and 1.0 or 0.2);
		end;
	};
	t[#t+1]=LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-854/4+240+20);
			self:y(y*22);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext('&MENURIGHT;');
			self:playcommand('Set');
		end;
		SetMessageCommand=function(self,params)
			local col=(params and (params.Col or 1) or 1);
			self:diffusealpha((y==col) and 1.0 or 0.2);
		end;
	};
end;
t[#t+1]=Def.ActorFrame{
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:x(-854/4+120);
			self:y(88);
			self:zoom(0.75);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:playcommand('Set');
		end;
		SetMessageCommand=function(self,params)
			local col=(params and (params.Col or 1) or 1);
			local hair=params and params.Hair_Col;
			local style=params and params.Style_Col;
			self:diffusealpha((col==4) and 1.0 or 0.2);
			if hair then
				self:settext(C_GetLang('Color','Hair'));
			elseif style then
				self:settext(C_GetLang('Color','Style'));
			else
				self:settext('');
			end;
		end;
	};
	LoadFont('Common Normal')..{
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-40);
			self:diffuse(Color('White'));
			self:strokecolor(Color('Outline'));
			self:zoom(0.66);
			self:settext(C_GetLang('Color','Help'));
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