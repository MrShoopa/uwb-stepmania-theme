--[[
    全体に影響の出る処理
--]]
local function GetSongBanner(s)
	if s then
		local path = s:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner");
end;

local tUpdate=Def.ActorFrame{};
local cur_song = nil;
local cur_position = nil;
local f_ready = false;
local f_go = false;
local c_beat = 0.0;
local function ChkSong()
	if (not cur_song) or (cur_song ~= _SONG2()) then
        -- 楽曲が変わった
		if GAMESTATE:IsCourseMode() then
			GAMESTATE:ClearStageModifiersIllegalForCourse();
		end;
		cur_song = _SONG2();
        f_ready = false;
        f_go = false;
		if cur_song then
			start_beat = cur_song:GetFirstBeat();
			path_banner = GetSongBanner(cur_song);
            cur_position = GAMESTATE:GetSongPosition();
		end;
        MESSAGEMAN:Broadcast('ChangedGameplaySong', {
                Song  = cur_song,
				Start = start_beat,
				Path  = path_banner,
                Beat  = cur_position:GetSongBeat()
        });
        return false;
    elseif cur_song then
        local cur_beat = cur_position:GetSongBeat();
        if not f_go and (start_beat-cur_beat)<8 then
            f_go = true;
            MESSAGEMAN:Broadcast('HereWeGo');
        elseif not f_ready and (start_beat-cur_beat)<12 then
            f_ready = true;
            MESSAGEMAN:Broadcast('Ready');
        end;
        return cur_beat;
    end;
end;

local wait = 1.0/(tonumber(GetUserPref_Theme("UserAnimationFPS")) or 60);
local cur_time=0;
local old_time=0;
local function update(self ,delta)
    cur_time = cur_time + delta;
    if cur_time - old_time > wait then
        local beat = ChkSong();
        local sec  = cur_position:GetMusicSeconds();
        MESSAGEMAN:Broadcast('GameplayTimer', {
            Song   = cur_song,
            Sec    = sec,
            Beat   = beat or 0.0,
            BeatP1 = GAMESTATE:IsPlayerEnabled(PLAYER_1) and GetPlayerSongBeat2(PLAYER_1,sec) or 0,
            BeatP2 = GAMESTATE:IsPlayerEnabled(PLAYER_2) and GetPlayerSongBeat2(PLAYER_2,sec) or 0
        });
        old_time = old_time + wait;
    end;
end;
tUpdate.InitCommand=cmd(SetUpdateFunction,update);

return tUpdate;
