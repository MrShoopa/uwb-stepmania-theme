local function GetSongBG(song)
	if song and song:HasBackground() then
		g=song:GetBackgroundPath()
	else
		g=THEME:GetPathG('common','fallback background');
	end;
	return g;
end

local t = Def.ActorFrame{
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(Color('Black'));
			self:zoomto(SCREEN_WIDTH+2,SCREEN_HEIGHT+2);
		end;
	};
	Def.Sprite {
		InitCommand=function(self)
			local g=GetSongBG(_SONG2());
			self:LoadBackground(g);
			self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
		end;
	};
  OffCommand=cmd(playcommand,"Init");
};

return t;
