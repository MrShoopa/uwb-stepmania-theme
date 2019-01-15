return LoadFont("BPMDisplay bpm") .. {
	OnCommand=function(self)
		self:horizalign((TC_GetwaieiMode()==2) and right or center);
		self:vertalign(bottom);
		self:strokecolor(Color("Black"));
		self:queuecommand("Set");
		self:zoomx(((TC_GetwaieiMode()==2) and 1 or 0.8));
		self:zoomy(0);
		self:linear(0.2);
		self:zoomy(((TC_GetwaieiMode()==2) and 1 or 0.8));
	end;
	SetCommand=function(self)
		if GetEXFCurrentSong_ShowBPMTime() then
			local curSelection = nil;
			local length = 0.0;
			local f=0;
			if GAMESTATE:IsCourseMode() then
				curSelection = GAMESTATE:GetCurrentCourse();
				if curSelection then
					local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
					if trail then
						length = TrailUtil.GetTotalSeconds(trail);
					else
						length = 0.0;
					end;
				else
					length = 0.0;
				end;
			else
				curSelection = _SONG();
				if curSelection then
					length = curSelection:MusicLengthSeconds();
				else
					length = 0.0;
				end;
			end;
			self:settext( SecondsToMSS(length) );
		else
			self:settext("?:??");
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
};