local maxw,align=...;
local s=_SONG2();
local t = Def.ActorFrame{
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(align);
			title=GetSplitTitle(s);
			self:x(0);
			if title[2]~="" then
				self:y(-24);
			else
				self:y(-17);
			end;
			self:maxwidth(maxw/1.2);
			self:zoom(1.2);
			self:settextf("%s",title[1]);
			self:strokecolor(0,0,0,0.5);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(align);
			self:x(0);
			self:y(0);
			self:maxwidth(maxw/0.9);
			self:zoom(0.9);
			self:settextf("%s",title[2]);
			self:strokecolor(0,0,0,0.5);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:horizalign(align);
			self:x(0);
			if title[2]~="" then
				self:y(28);
			else
				self:y(19);
			end;
			self:maxwidth(maxw);
			self:settextf("%s",s:GetDisplayArtist());
			self:strokecolor(0,0,0,0.5);
		end;
	};
};

return t;
