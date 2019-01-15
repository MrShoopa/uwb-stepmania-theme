local scale = GetwaieiBulrSize();
local function GetSongBG(song)
	if song and song:HasBackground() then
		g=song:GetBackgroundPath()
	else
		g=THEME:GetPathG('common','fallback background');
	end;
	return g;
end

return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(
			horizalign,left;
			vertalign,top;
			zoomto,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale;
			diffuse,0,0,0,1
		);
	};
	Def.Sprite{
		InitCommand=function(self)
			self:LoadBackground(GetSongBG(_SONG2()));
			self:scaletofit(0,0,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale);
		end;
	};
	Def.Quad{
		InitCommand=cmd(
			horizalign,left;
			vertalign,top;
			zoomto,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale;
			diffuse,0,0,0,1.0-PREFSMAN:GetPreference('BGBrightness')
		);
	};
  OffCommand=cmd(playcommand,"Init");
};