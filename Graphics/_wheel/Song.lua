--[ja] ファイルから読み取る情報。何度も呼ぶと重いのでローカル変数で作っておく 
local c=Color("Black");
local g="";
local folder="";
local wheelmode=GetWheelMode();
local title={};
local artist="";

local t = Def.ActorFrame{};
if not GAMESTATE:IsCourseMode() then
	t[#t+1]=Def.ActorFrame{
		SetCommand=function(self,params)
			if params.Song then
				local song=params.Song;
				folder=song:GetSongDir();
				title=SplitTitle(song:GetDisplayMainTitle());
				if title[2]=="" then
					title[2]=song:GetDisplaySubTitle();
				end;
				artist=song:GetDisplayArtist();
				local n_group=""..song:GetGroupName();
				local n_song=string.lower(GetSong2Folder(song));
				local metertype=GetSongs_str(n_group.."/"..n_song,'metertype');
				local menucolor=GetSongs_str(n_group.."/"..n_song,'color');
				if not menucolor then
					if IsBossColor(song,metertype) then
						c=Color("Red");
					else
						c=waieiColor("WheelDefault");
					end;
				else
					c=menucolor;
				end;

				local fall_bg=THEME:GetPathG("Common fallback","background");
				local fall_bn=THEME:GetPathG("Common fallback","banner");

				local tmp={};
				tmp=GetBannerStat(song,wheelmode);
				g=tmp[1];
				ty=tmp[2];
				if params.HasFocus then
					local SongInf={};
					SongInf["Title"]=title[1];
					SongInf["SubTitle"]=title[2];
					SongInf["Artist"]=artist;
					setenv("SongInf",SongInf);
				end;
				local tc_paramas={};
				tc_paramas["Index"]=params.DrawIndex-math.round(tonumber(THEME:GetMetric("MusicWheel","NumWheelItems"))/2);
				tc_paramas["Song"]=song;
				tc_paramas["Title"]=title[1];
				tc_paramas["SubTitle"]=title[2];
				tc_paramas["Artist"]=artist;
				tc_paramas["MeterType"]=metertype;
				tc_paramas["Color"]=c;
				tc_paramas["Graphic"]=g;
				TC_SetWheelSong(params,tc_paramas);
			end;
		end;
		LoadActor(TC_GetPath("Wheel","Song"),nil);
	};
end;
return t;