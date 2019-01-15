return Def.ActorFrame{
	Def.BPMDisplay {
		File=THEME:GetPathF("BPMDisplay", "bpm");
		Name="BPMDisplay";
		SetMessageCommand=function(self)
			if GetEXFCurrentSong_ShowBPMTime() then
				self:visible(true);
				self:SetFromGameState();
			else
				self:visible(false);
			end;
		end;
		OnCommand=function(self)
			if GetEXFCurrentSong_ShowBPMTime() then
				self:visible(true);
				self:SetFromGameState();
			else
				self:visible(false);
			end;
			(cmd(horizalign,left;vertalign,bottom;strokecolor,Color("Black");
				zoomx,1;zoomy,0;linear,0.2;zoomy,1;))(self);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
	LoadFont("BPMDisplay", "bpm")..{
		Text="???";
		SetMessageCommand=function(self)
			if GetEXFCurrentSong_ShowBPMTime() then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;
		OnCommand=function(self)
			if GetEXFCurrentSong_ShowBPMTime() then
				self:visible(false);
			else
				self:visible(true);
			end;
			(cmd(horizalign,left;vertalign,bottom;strokecolor,Color("Black");
				zoomx,1;zoomy,0;linear,0.2;zoomy,1;))(self);
		end;
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
	};
};