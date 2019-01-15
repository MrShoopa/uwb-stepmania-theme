return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,0;);
		OnCommand=cmd(horizalign,right;zoomto,480,0;diffusealpha,0;diffuseleftedge,0,0,0,0;
						sleep,0.5;linear,0.25;zoomto,280,16;diffusealpha,1;diffuseleftedge,0,0,0,0;);
		OffCommand=cmd(linear,0.25;zoomto,960,0;diffusealpha,0;);
	};
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,0;);
		OnCommand=cmd(horizalign,left;zoomto,480,0;diffusealpha,0;diffuserightedge,0,0,0,0;
						sleep,0.5;linear,0.25;zoomto,280,16;diffusealpha,1;diffuserightedge,0,0,0,0;);
		OffCommand=cmd(linear,0.25;zoomto,960,0;diffusealpha,0;);
	};
	LoadFont("ScreenGameplay","SongTitle") .. {
		CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			local vSong = GAMESTATE:GetCurrentSong();
			local vCourse = GAMESTATE:GetCurrentCourse();
			local sText = ""
			if vSong then
				sText = vSong:GetDisplayArtist() .. " - " .. vSong:GetDisplayFullTitle()
			end
			if vCourse then
				sText = vCourse:GetDisplayFullTitle() .. " - " .. vSong:GetDisplayFullTitle();
			end
			self:settext( sText );
			self:playcommand( "On" );
		end;
		OnCommand=cmd(zoomx,1;zoomy,0;diffusealpha,0;sleep,0.3;linear,0.2;zoomx,0.5;zoomy,0.5;diffusealpha,1;maxwidth,800;);
	};
};
