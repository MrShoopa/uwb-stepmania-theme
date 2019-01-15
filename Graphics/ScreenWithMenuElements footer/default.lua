local t = Def.ActorFrame {
	Def.Quad{
		InitCommand=function(self)
			(cmd(vertalign,bottom;zoomto,SCREEN_WIDTH+1,31;))(self);
			if TC_GetwaieiMode()==2 then
				(cmd(diffuse,0,0.2,0.4,0.7;fadeleft,0.3))(self);
			else
				(cmd(diffuse,0,0,0,0.7;))(self);
			end;
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH+1,1;vertalign,bottom;y,-30;
			diffuse,Color("Blue");blend,"BlendMode_Add";fadeleft,0.3;);
	};
};

return t