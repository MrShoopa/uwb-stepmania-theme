local i;
local t = Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	InitCommand=cmd(zoom,0.75;y,-18);
	SetMessageCommand=function(self,params)
		i=params.DrawIndex;	-- [ja] index番号の取得 
		self:stoptweening();
	end;
	LoadActor("_wheel base")..{
		InitCommand=cmd(y,20);
		SetMessageCommand=function(self,params)
			self:diffuse(GetFolderWheel_Color(i));
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(185,185);
			self:y(40);
		end;
		SetMessageCommand=function(self,params)
			self:diffuse(BoostColor(GetFolderWheel_Color(i),0.8));
		end;
	};
	LoadActor("_wheel ex")..{
		InitCommand=cmd(y,20);
	};
	Def.Quad{
		InitCommand=function(self,params)
			self:zoomto(112,112);
			self:x(35);
			self:y(5);
			self:diffuse(Color("Black"));
			self:diffusealpha(0.2);
		end;
	};
	ActorWheel() {
		--[ja] ジャケット表示
		SetMessageCommand=function(self,params)
			local gra=GetFolderWheel_Graphic(i);
			self:Load(gra);
			self:scaletocover(0,0,110,110);
			self:x(35);
			self:y(5);
			self:diffuse(GetFolderWheel_GraphicColor(i));	-- [ja] 基本的に1,1,1,1だが、難易度ソート時に色がつく 
			local w=self:GetWidth();
			local h=self:GetHeight();
			if w>h then
				local cr=(w-h)/w/2;
				self:cropleft(cr);
				self:cropright(cr);
			else
				self:cropleft(0);
				self:cropright(0);
			end;
		end;
	};
	LoadActor("_wheel name")..{
		InitCommand=cmd(y,-75;);
		SetMessageCommand=function(self,params)
			self:diffuse(BoostColor(GetFolderWheel_Color(i),0.5));
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:zoom(1.1);
			self:horizalign(left);
			self:x(-88);
			self:y(-75);
			self:maxwidth(176/1.1);
			self:diffusealpha(1);
		end;
		SetMessageCommand=function(self,params)
			self:diffuse(GetFolderWheel_Color(i));
			self:strokecolor(BoostColor(GetFolderWheel_Color(i),0.25));
			self:settext(GetFolderWheel_GroupName(i));
		end;
	};
};
return t;