local i;
local t = Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	SetMessageCommand=function(self,params)
		i=params.DrawIndex;	-- [ja] index番号の取得 
		self:stoptweening();
	end;
	LoadActor("_wheel base")..{
		InitCommand=cmd(y,20);
		SetMessageCommand=function(self,params)
			self:diffuse(BoostColor(GetFolderWheel_Color(i),1.1));
		end;
	};
	Def.Quad{
		InitCommand=function(self,params)
			self:zoomto(185,185);
			self:diffuse(0.1,0.32,0.66,1.0);
			self:y(40);
		end;
	};
	LoadActor("_wheel folder")..{
		InitCommand=cmd(y,20);
	};
	Def.Quad{
		InitCommand=function(self,params)
			self:zoomto(112,112);
			self:x(35);
			self:y(5);
			self:diffuse(Color("Black"));
			self:diffusealpha(0.2);
		--	self:blend("BlendMode_Add");
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
			self:diffuse(BoostColor(Color("Blue"),0.5));
		end;
	};
	LoadFont("Common Normal")..{
		SetMessageCommand=function(self,params)
			if GetFolderWheel_NumSongs(i)==1 then
				self:settext("Song");
			else
				self:settext("Songs");
			end;
			self:zoom(0.8);
			self:x(60);
			self:y(-72);
			self:diffuse(Color("White"));
			self:strokecolor(0,0,0,0.1);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:zoom(1.1);
			self:x(25);
			self:y(-75);
			self:diffusealpha(1);
		end;
		SetMessageCommand=function(self,params)
			self:horizalign(right);
			self:strokecolor(0,0,0,0.1);
			self:diffuse(BoostColor(Color("Blue"),1.5));
			self:settext(GetFolderWheel_NumSongs(i));
		end;
	};
};
return t;