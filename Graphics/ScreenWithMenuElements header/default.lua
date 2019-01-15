local t = Def.ActorFrame {};

t[#t+1]=Def.Quad{
	InitCommand=function(self)
		(cmd(vertalign,top;zoomto,SCREEN_WIDTH+1,43;))(self);
		if TC_GetwaieiMode()==2 then
			(cmd(diffuse,0,0.2,0.4,0.7;faderight,0.5))(self);
		else
			(cmd(diffuse,0,0,0,0.7;))(self);
		end;
	end;
};
t[#t+1]=Def.Quad{
	InitCommand=cmd(zoomto,SCREEN_WIDTH+1,1;vertalign,top;y,42;
		diffuse,Color("Blue");blend,"BlendMode_Add";faderight,0.3;);
};
t[#t+1] = LoadFont("Common Normal") .. {
	Name="HeaderText";
	Text=Screen.String("HeaderText");
	InitCommand=function(self)
		(cmd(x,-SCREEN_CENTER_X+10;y,22;zoom,1;horizalign,left;
			shadowlength,2;maxwidth,300))(self);
		local pos=1;
		local attr={ Length = 3; Diffuse = color("#30c0ff"); };
		self:AddAttribute(pos,attr);
	end;
	OnCommand=cmd(skewx,-0.125;diffusebottomedge,color("0.875,0.875,0.875"));
	UpdateScreenHeaderMessageCommand=function(self,param)
		self:settext(param.Header);
	end;
};
if GetThemeVersionInformation("Dev")~="" then
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X-(PREFSMAN:GetPreference("ShowStats") and 80 or 0));
			self:y(SCREEN_TOP);
			self:zoom(0.75);
		end;
		LoadActor("header_logo") .. {
			InitCommand=cmd(horizalign,right;vertalign,top;);
		};
		LoadFont("Common Normal") .. {
			InitCommand=cmd(vertalign,top;
				x,-70;y,60;zoom,0.55;strokecolor,Color("Outline");
				settext,string.format("%1.3f",GetThemeVersionInformation("Version"))
				..GetThemeVersionInformation("Dev").."-"
				..GetThemeVersionInformation("Date"));
		};
	};
end;


return t