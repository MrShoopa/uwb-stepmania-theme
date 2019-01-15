local i;
local t = Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	SetMessageCommand=function(self,params)
		i=params.DrawIndex;	-- [ja] index番号の取得 
		self:stoptweening();
	end;
	LoadActor("_folder open under");
	ActorWheel() {
		--[ja] ジャケット表示
		SetMessageCommand=function(self,params)
			local gra=GetFolderWheel_Graphic(i);
			self:Load(gra);
			self:scaletofit(0,0,188,188);
			self:x(0);
			self:y(0);
			self:diffuse(GetFolderWheel_GraphicColor(i));	-- [ja] 基本的に1,1,1,1だが、難易度ソート時に色がつく 
			self:diffuseupperleft(1,1,1,0);
			--[[
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
			--]]
		end;
	};
	LoadActor("_folder color")..{
		SetMessageCommand=function(self,params)
			self:diffuse(BoostColor(GetFolderWheel_Color(i),0.5));
		end;
	};
	LoadActor("_folder img over");
	LoadActor("_folder over");
	LoadFont("waiei1 Main")..{
		SetMessageCommand=function(self,params)
			if GetFolderWheel_NumSongs(i)==1 then
				self:settext("Song");
			else
				self:settext("Songs");
			end;
			self:zoom(0.55);
			self:x(68);
			self:y(-73);
			self:diffuse(Color("White"));
			self:strokecolor(0,0,0,0.1);
		end;
	};
	LoadFont("waiei1 Main")..{
		InitCommand=function(self)
			self:zoom(0.75);
			self:x(45);
			self:y(-75);
			self:horizalign(right);
			self:diffusealpha(1);
		end;
		SetMessageCommand=function(self,params)
			self:strokecolor(0,0,0,0.1);
			self:diffuse(BoostColor(Color("Blue"),1.5));
			self:settext(GetFolderWheel_NumSongs(i));
		end;
	};
	LoadFont("waiei1 Main")..{
		InitCommand=cmd(maxwidth,180/0.8;zoom,0.8;x,90;horizalign,right);
		SetMessageCommand=function(self,params)
			self:diffuse(GetFolderWheel_Color(i));
			self:y(70);
			self:settext(GetFolderWheel_GroupName(i));
			self:strokecolor(0,0,0,0.5);
		end;
	};
};
return t;