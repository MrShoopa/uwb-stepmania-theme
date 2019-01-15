local max=100;
return Def.Sprite {
	OnCommand=function(self)
		if _SONG() and _SONG():HasCDTitle() then
			self:LoadBackground(_SONG():GetCDTitlePath());
			self:zoom(0.75);
			local w=self:GetWidth()*0.75;
			local h=self:GetHeight()*0.75;
			local s=((w>h) and w or h);
			if s>max then
				if w>h then
					self:zoomtowidth(max);
					self:zoomtoheight(max*h/w);
				else
					self:zoomtowidth(max*w/h);
					self:zoomtoheight(max);
				end;
			end;
		--	(cmd(horizalign,left;vertalign,top;draworder,0))(self);
			self:visible(true);
		else
			self:zoom(0);
			self:visible(false);
		end;
		if TC_GetwaieiMode()==2 then
			self:horizalign(center);
			self:vertalign(middle);
			self:rotationz(-20);
		else
			self:horizalign(left);
			self:vertalign(top);
		end;
	end;
	OffCommand=cmd(linear,0.2;zoomx,0);
	CurrentSongChangedMessageCommand=cmd(playcommand,"On");
};