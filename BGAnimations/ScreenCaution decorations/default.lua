return Def.ActorFrame{
	FOV=60;
	Def.Quad{
		InitCommand=function(self)
			self:Center();
			self:diffuse(0,0,0,0.5);
			self:zoomto(SCREEN_WIDTH+2,240);
		end;
		OnCommand=function(self)
			self:zoomtoheight(0);
			self:diffusealpha(0);
			self:linear(0.3);
			self:zoomtoheight(240);
			self:diffusealpha(0.5);
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=function(self)
			self:settext(THEME:GetString("ScreenCaution","Caution"));
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP+170);
			self:zoom(2.0);
			self:diffuse(Color("Red"));
			self:strokecolor(Color("Outline"));
		end;
		OnCommand=function(self)
			self:diffusealpha(0.5);
			self:linear(0.05);
			self:diffusealpha(1);
			self:linear(0.05);
			self:diffusealpha(0.5);
			self:linear(0.05);
			self:diffusealpha(1);
			self:linear(0.05);
			self:diffusealpha(0.5);
			self:linear(0.05);
			self:diffusealpha(1);
			self:linear(0.5);
			self:diffuse(BoostColor(Color("Blue"),1.5));
			self:queuecommand('InitSong');
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=function(self)
			local text=THEME:GetString("ScreenCaution","CautionText");
			text=string.gsub(text,"PC、","PC、 ");
			text=string.gsub(text,"ラリーに","ラリーに ");
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+30);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Outline"));
			self:settext(text);
			self:wrapwidthpixels(640);
		end;
		OnCommand=function(self)
			self:rotationx(-45);
			self:rotationy(-45);
			self:zoom(2);
			self:diffusealpha(0);
			self:linear(0.3);
			self:diffusealpha(1);
			self:rotationx(0);
			self:rotationy(0);
			self:zoom(1);
		end;
	};
};