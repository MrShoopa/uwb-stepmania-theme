local i;
local t = Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	SetMessageCommand=function(self,params)
		i=params.DrawIndex;	-- [ja] index番号の取得 
		self:stoptweening();
	end;
	LoadActor("_folder mode under");
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
		end;
	};
	LoadActor("_folder color")..{
		SetMessageCommand=function(self,params)
			local c=GetFolderWheel_GraphicColor(i);
			self:diffuse(GetFolderWheel_Color(i));
		end;
	};
	LoadActor("_folder img over");
	LoadActor("_folder over");
	LoadFont("waiei1 Main")..{
		InitCommand=cmd(maxwidth,180/0.8;zoom,0.8;x,90;horizalign,right);
		SetMessageCommand=function(self,params)
			self:diffuse(GetFolderWheel_Color(i));
			self:y(70);
			self:settext(GetFolderWheel_Label(i));
			self:strokecolor(0,0,0,0.5);
		end;
	};
};
return t;