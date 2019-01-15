
--[[
グループ選択画面で上下ボタンを押すとソート方法を変更する
--]]
grSortMode={"group","title","artist","maxbpm","minbpm","songlen",
			"difbeg","difbas","difdif","difexp","difcha","difall"};
--grSys["XXX"]にシステム的な情報を入れておく（ソートモードの番号等）
--grGroup["XXX"]にグループソート用のデータを入れておく
--grTitle["XXX"]にタイトルソート用のデータを入れておく
--grBpm["XXX"]にBPMソート用のデータを入れておく
--grData["XXX"]：ソートモードに応じて上記の変数を代入し、実際のグループ選択画面ではこの変数を使用する 

function GetGroupStats()
	if not getenv("grData") then
		-- [ja] 最後にプレイした曲を取得（初回はそこに移動） 
		local prf=PROFILEMAN:GetProfile(GAMESTATE:GetMasterPlayerNumber());
		local last_group="";
		if prf:GetLastPlayedSong() then
			last_group=prf:GetLastPlayedSong():GetGroupName();
		end;
		local last_chk=false;	-- [ja] 最後にプレイしたフォルダの曲数が1以上か 
		local grTitle={};
		local grArtist={};
		local grGroup={};
		local grMaxBpm={};
		local grMinBpm={};
		local grSongLen={};
		local grDifAll={};
		local grDifCha={};
		local grDifExp={};
		local grDifDif={};
		local grDifBas={};
		local grDifBeg={};
		local grData={};
		local grSys={};
		local sgSys={};
		grSys["Name-group"]="GROUP";
		grSys["Name-title"]="TITLE";
		grSys["Name-artist"]="ARTIST";
		grSys["Name-maxbpm"]="MAX BPM";
		grSys["Name-minbpm"]="MIN BPM";
		grSys["Name-songlen"]="SongLength";
		grSys["Name-difall"]="Meter (ALL)";
		grSys["Name-difcha"]="Meter ("..string.upper(_DifficultyNAME(Difficulty[5]))..")";
		grSys["Name-difexp"]="Meter ("..string.upper(_DifficultyNAME(Difficulty[4]))..")";
		grSys["Name-difdif"]="Meter ("..string.upper(_DifficultyNAME(Difficulty[3]))..")";
		grSys["Name-difbas"]="Meter ("..string.upper(_DifficultyNAME(Difficulty[2]))..")";
		grSys["Name-difbeg"]="Meter ("..string.upper(_DifficultyNAME(Difficulty[1]))..")";
		grSys["Color-group"]=Color("Blue");	--[ja] ホイール背景カラー
		grSys["Color-title"]=Color("Purple");	--[ja] ホイール背景カラー 
		grSys["Color-artist"]=Color("Orange");	--[ja] ホイール背景カラー 
		grSys["Color-maxbpm"]=Color("Red");	--[ja] ホイール背景カラー 
		grSys["Color-minbpm"]=Color("Green");	--[ja] ホイール背景カラー 
		grSys["Color-songlen"]=Color("White");	--[ja] ホイール背景カラー 
		grSys["Color-difall"]=Color("White");	--[ja] ホイール背景カラー 
		grSys["Color-difcha"]=_DifficultyCOLOR(Difficulty[5]);	--[ja] ホイール背景カラー 
		grSys["Color-difexp"]=_DifficultyCOLOR(Difficulty[4]);	--[ja] ホイール背景カラー 
		grSys["Color-difdif"]=_DifficultyCOLOR(Difficulty[3]);	--[ja] ホイール背景カラー 
		grSys["Color-difbas"]=_DifficultyCOLOR(Difficulty[2]);	--[ja] ホイール背景カラー 
		grSys["Color-difbeg"]=_DifficultyCOLOR(Difficulty[1]);	--[ja] ホイール背景カラー 
		for i=1,#grSortMode do
			grSys["Select_Now-"..grSortMode[i]]=1;	--[ja] 最後にプレイした曲のあるフォルダに設定する 
		end;
		local a_list={"a","b","c","d","e","f","g","h","i","j","k","l","m","n",
					  "o","p","q","r","s","t","u","v","w","x","y","z"};
		local cnt_title={};
		local cnt_artist={};
		local cnt_maxbpm={};
		local cnt_minbpm={};
		local cnt_songlen={};
		local cnt_difall={};
		local cnt_difcha={};
		local cnt_difexp={};
		local cnt_difdif={};
		local cnt_difbas={};
		local cnt_difbeg={};
		local cnt_group={};
		local meter_type=GetUserPref_Theme("UserMeterType");
		local groups=SONGMAN:GetSongGroupNames();
		--[ja] ABC順に並び替え 
		table.sort(groups,
			function(a,b)
				return (string.upper(a) < string.upper(b))
			end);
		
		--[ja] グループの情報をあらかじめ取得しておく 
		for g=1,#groups do
			local _chk="";
			_chk=GetGroupParameter(groups[g],"name")
			if _chk~="" then
				grSys["Name-"..groups[g]]=_chk;
			else
				grSys["Name-"..groups[g]]=groups[g];
			end;
			_chk=string.lower(GetGroupParameter(groups[g],"metertype"));
			if _chk~="" and _chk~="ddr" then
				grSys["MeterType-"..groups[g]]=_chk;
			else
				grSys["MeterType-"..groups[g]]="ddr";
			end;
			_chk=GetGroupParameter(groups[g],"extra1list");
			if _chk~="" then
				grSys["EXFolder-"..groups[g]]=true;
			else
				grSys["EXFolder-"..groups[g]]=false;
			end;
			_chk=GetGroupParameter(groups[g],"menucolor");
			if _chk~="" then
				grSys["MenuColor-"..groups[g]]=_chk;
			else
				grSys["MenuColor-"..groups[g]]="";
			end;
		end;

		local songs=SONGMAN:GetAllSongs();
		for s=1,#songs do
			if FILEMAN:DoesFileExist(songs[s]:GetSongFilePath()) and
				(songs[s]:HasStepsType(_STEPSTYPE()) or PREFSMAN:GetPreference("AutogenSteps")) then
				--[ja] カラー 
				local _g=songs[s]:GetGroupName();
				local g_col_t=split(":",grSys["MenuColor-".._g]);
				if g_col_t[1]~="" then
					for c=1,#g_col_t do
						local g_col_fol=split("|",g_col_t[c]);
						-- [ja] このグループのデフォルトカラー 
						if c==1 then
							sgSys["Color-".._g]=Str2Color(g_col_fol[1]);
						end;
						for f=2,#g_col_fol do
							sgSys["Color-".._g.."/"..string.lower(g_col_fol[f])]=Str2Color(g_col_fol[1]);
						end;
					end;
				end;
				--[ja] タイトル/アーティストソート用 
				local ltitle=string.lower(songs[s]:GetTranslitFullTitle());
				local lartist=string.lower(songs[s]:GetTranslitArtist());
				local chk_title=false;
				local chk_artist=false;
				for a=1,#a_list do
					if string.find(ltitle,"^"..a_list[a]..".*") then
						if cnt_title[a_list[a]] then
							cnt_title[a_list[a]]=cnt_title[a_list[a]]+1;
						else
							cnt_title[a_list[a]]=1;
						end;
						chk_title=true;
					end;
					if string.find(lartist,"^"..a_list[a]..".*") then
						if cnt_artist[a_list[a]] then
							cnt_artist[a_list[a]]=cnt_artist[a_list[a]]+1;
						else
							cnt_artist[a_list[a]]=1;
						end;
						chk_artist=true;
					end;
					if chk_title and chk_artist then	--[ja]調べたい項目がすべてtrueならループを抜ける 
						break;
					end;
				end;
				if not chk_title and string.find(ltitle,"^%d.*") then
					if cnt_title["num"] then
						cnt_title["num"]=cnt_title["num"]+1;
					else
						cnt_title["num"]=1;
					end;
				elseif not chk_title then
					if cnt_title["other"] then
						cnt_title["other"]=cnt_title["other"]+1;
					else
						cnt_title["other"]=1;
					end;
				end;
				if not chk_artist and string.find(lartist,"^%d.*") then
					if cnt_artist["num"] then
						cnt_artist["num"]=cnt_artist["num"]+1;
					else
						cnt_artist["num"]=1;
					end;
				elseif not chk_artist then
					if cnt_artist["other"] then
						cnt_artist["other"]=cnt_artist["other"]+1;
					else
						cnt_artist["other"]=1;
					end;
				end;

				--[ja] BPMソート用 
				if songs[s]:IsDisplayBpmSecret() or songs[s]:IsDisplayBpmRandom() then
					if cnt_maxbpm[501] then
						cnt_maxbpm[501]=cnt_maxbpm[501]+1;
					else
						cnt_maxbpm[501]=1;
					end;
					if cnt_minbpm[501] then
						cnt_minbpm[501]=cnt_minbpm[501]+1;
					else
						cnt_minbpm[501]=1;
					end;
				else
					local bpms=songs[s]:GetDisplayBpms();
					local _bpm;
					_bpm=math.floor(math.max(math.min(bpms[2],10000),0)/20);
					if cnt_maxbpm[_bpm] then
						cnt_maxbpm[_bpm]=cnt_maxbpm[_bpm]+1;
					else
						cnt_maxbpm[_bpm]=1;
					end;
					_bpm=math.floor(math.max(math.min(bpms[1],10000),0)/20);
					if cnt_minbpm[_bpm] then
						cnt_minbpm[_bpm]=cnt_minbpm[_bpm]+1;
					else
						cnt_minbpm[_bpm]=1;
					end;
				end;

				--[ja] 曲の長さソート用 
				local len=math.floor(math.max(math.min(songs[s]:MusicLengthSeconds(),5000),0)/10);
				if cnt_songlen[len] then
					cnt_songlen[len]=cnt_songlen[len]+1;
				else
					cnt_songlen[len]=1;
				end;

				--[ja] 難易度ソート用 
				for d=1,6 do
					if songs[s]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[d]) then
						local st=songs[s]:GetOneSteps(_STEPSTYPE(),Difficulty[d]);
						local meter=((meter_type=="LV100") and GetConvertDifficulty_LV100(songs[s],st) or st:GetMeter());
						local dif=math.min(math.max(meter,1),100);
						sgSys["Dif-"..Difficulty[d].."-"..songs[s]:GetDisplayFullTitle().."-"..songs[s]:GetGroupName()]=meter;
						if cnt_difall[dif] then
							cnt_difall[dif]=cnt_difall[dif]+1;
						else
							cnt_difall[dif]=1;
						end;
						if d==1 then
							if cnt_difbeg[dif] then
								cnt_difbeg[dif]=cnt_difbeg[dif]+1;
							else
								cnt_difbeg[dif]=1;
							end;
						elseif d==2 then
							if cnt_difbas[dif] then
								cnt_difbas[dif]=cnt_difbas[dif]+1;
							else
								cnt_difbas[dif]=1;
							end;
						elseif d==3 then
							if cnt_difdif[dif] then
								cnt_difdif[dif]=cnt_difdif[dif]+1;
							else
								cnt_difdif[dif]=1;
							end;
						elseif d==4 then
							if cnt_difexp[dif] then
								cnt_difexp[dif]=cnt_difexp[dif]+1;
							else
								cnt_difexp[dif]=1;
							end;
						elseif d==5 then
							if cnt_difcha[dif] then
								cnt_difcha[dif]=cnt_difcha[dif]+1;
							else
								cnt_difcha[dif]=1;
							end;
						else
						end;
					end;
				end;

				--[ja] グループソート用 
				local lgroup=songs[s]:GetGroupName();
				if not last_chk and last_group==lgroup then
					last_chk=true;
				end;
				local chk_group=false;
				for g=1,#groups do
					if lgroup==groups[g] then
						if cnt_group[groups[g]] then
							cnt_group[groups[g]]=cnt_group[groups[g]]+1;
						else
							cnt_group[groups[g]]=1;
						end;
						chk_group=true;
					end;
					if chk_group then	--[ja]調べたい項目がすべてtrueならループを抜ける 
						break;
					end;
				end;
			end;
		end;

		local cnt=0;
		--[ja] タイトルソート用 
		cnt=0;
		for a=1,#a_list do
			if cnt_title[a_list[a]] then
				cnt=cnt+1;
				grTitle[""..cnt.."-Name"]=""..grSys["Name-title"].." - "..string.upper(a_list[a]);
				grTitle[""..cnt.."-Path"]=a_list[a];
				grTitle[""..cnt.."-Songs"]=cnt_title[a_list[a]];
				grTitle[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grTitle[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","title");
			end;
		end;
		if cnt_title["num"] then
			cnt=cnt+1;
			grTitle[""..cnt.."-Name"]=""..grSys["Name-title"].." - 0-9";
			grTitle[""..cnt.."-Path"]="num";
			grTitle[""..cnt.."-Songs"]=cnt_title["num"];
			grTitle[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
			grTitle[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","title");
		end;
		if cnt_title["other"] then
			cnt=cnt+1;
			grTitle[""..cnt.."-Name"]=""..grSys["Name-title"].." - Other";
			grTitle[""..cnt.."-Path"]="other";
			grTitle[""..cnt.."-Songs"]=cnt_title["other"];
			grTitle[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
			grTitle[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","title");
		end;
		grTitle["Max"]=cnt;

		--[ja] アーティストソート用 
		cnt=0;
		for a=1,#a_list do
			if cnt_artist[a_list[a]] then
				cnt=cnt+1;
				grArtist[""..cnt.."-Name"]=""..grSys["Name-artist"].." - "..string.upper(a_list[a]);
				grArtist[""..cnt.."-Path"]=a_list[a];
				grArtist[""..cnt.."-Songs"]=cnt_artist[a_list[a]];
				grArtist[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grArtist[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","artist");
			end;
		end;
		if cnt_artist["num"] then
			cnt=cnt+1;
			grArtist[""..cnt.."-Name"]=""..grSys["Name-artist"].." - 0-9";
			grArtist[""..cnt.."-Path"]="num";
			grArtist[""..cnt.."-Songs"]=cnt_artist["num"];
			grArtist[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
			grArtist[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","artist");
		end;
		if cnt_artist["other"] then
			cnt=cnt+1;
			grArtist[""..cnt.."-Name"]=""..grSys["Name-artist"].." - Other";
			grArtist[""..cnt.."-Path"]="other";
			grArtist[""..cnt.."-Songs"]=cnt_artist["other"];
			grArtist[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
			grArtist[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","artist");
		end;
		grArtist["Max"]=cnt;

		--[ja] MAXBPMソート用 
		cnt=0;
		for b=0,501 do
			if cnt_maxbpm[b] then
				cnt=cnt+1;
				if b<500 then
					grMaxBpm[""..cnt.."-Name"]=""..grSys["Name-maxbpm"].." - ["..(b*20).."-"..(b*20+20).."]";
				elseif b==500 then
					grMaxBpm[""..cnt.."-Name"]=""..grSys["Name-maxbpm"].." - [10000 and over]";
				else
					grMaxBpm[""..cnt.."-Name"]=""..grSys["Name-maxbpm"].." - [???]";
				end;
				grMaxBpm[""..cnt.."-Path"]=""..b;
				grMaxBpm[""..cnt.."-Songs"]=cnt_maxbpm[b];
				grMaxBpm[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grMaxBpm[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","maxbpm");
			end;
		end;
		grMaxBpm["Max"]=cnt;

		--[ja] MINBPMソート用 
		cnt=0;
		for b=0,501 do
			if cnt_minbpm[b] then
				cnt=cnt+1;
				if b<500 then
					grMinBpm[""..cnt.."-Name"]=""..grSys["Name-minbpm"].." - ["..(b*20).."-"..(b*20+20).."]";
				elseif b==500 then
					grMinBpm[""..cnt.."-Name"]=""..grSys["Name-minbpm"].." - [10000 and over]";
				else
					grMinBpm[""..cnt.."-Name"]=""..grSys["Name-minbpm"].." - [???]";
				end;
				grMinBpm[""..cnt.."-Path"]=""..b;
				grMinBpm[""..cnt.."-Songs"]=cnt_minbpm[b];
				grMinBpm[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grMinBpm[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","minbpm");
			end;
		end;
		grMinBpm["Max"]=cnt;

		--[ja] 曲の長さソート用 
		cnt=0;
		for l=0,500 do
			if cnt_songlen[l] then
				cnt=cnt+1;
				if l<500 then
					grSongLen[""..cnt.."-Name"]=""..grSys["Name-songlen"].." - ["..SecondsToMMSS(l*10).."-"..SecondsToMMSS(l*10+10).."]";
				else
					grSongLen[""..cnt.."-Name"]=""..grSys["Name-songlen"].." - ["..SecondsToMMSS(5000).." Over]";
				end;
				grSongLen[""..cnt.."-Path"]=""..l;
				grSongLen[""..cnt.."-Songs"]=cnt_songlen[l];
				grSongLen[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grSongLen[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","time");
			end;
		end;
		grSongLen["Max"]=cnt;

		--[ja] 難易度ソート用 
		cnt=0;
		for d=1,100 do
			if cnt_difall[d] then
				cnt=cnt+1;
				if d<100 then
					grDifAll[""..cnt.."-Name"]=""..grSys["Name-difall"].." - ["..d.."]";
				else
					grDifAll[""..cnt.."-Name"]=""..grSys["Name-difall"].." - [100 and over]";
				end;
				grDifAll[""..cnt.."-Path"]=""..d;
				grDifAll[""..cnt.."-Songs"]=cnt_difall[d];
				grDifAll[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grDifAll[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","difficulty");
			end;
		end;
		grDifAll["Max"]=cnt;
		--Beginner
		cnt=0;
		for d=1,100 do
			if cnt_difbeg[d] then
				cnt=cnt+1;
				if d<100 then
					grDifBeg[""..cnt.."-Name"]=""..grSys["Name-difbeg"].." - ["..d.."]";
				else
					grDifBeg[""..cnt.."-Name"]=""..grSys["Name-difbeg"].." - [100 and over]";
				end;
				grDifBeg[""..cnt.."-Path"]=""..d;
				grDifBeg[""..cnt.."-Songs"]=cnt_difbeg[d];
				grDifBeg[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grDifBeg[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","difficulty");
			end;
		end;
		grDifBeg["Max"]=cnt;
		--Basic
		cnt=0;
		for d=1,100 do
			if cnt_difbas[d] then
				cnt=cnt+1;
				if d<100 then
					grDifBas[""..cnt.."-Name"]=""..grSys["Name-difbas"].." - ["..d.."]";
				else
					grDifBas[""..cnt.."-Name"]=""..grSys["Name-difbas"].." - [100 and over]";
				end;
				grDifBas[""..cnt.."-Path"]=""..d;
				grDifBas[""..cnt.."-Songs"]=cnt_difbas[d];
				grDifBas[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grDifBas[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","difficulty");
			end;
		end;
		grDifBas["Max"]=cnt;
		--Difficult
		cnt=0;
		for d=1,100 do
			if cnt_difdif[d] then
				cnt=cnt+1;
				if d<100 then
					grDifDif[""..cnt.."-Name"]=""..grSys["Name-difdif"].." - ["..d.."]";
				else
					grDifDif[""..cnt.."-Name"]=""..grSys["Name-difdif"].." - [100 and over]";
				end;
				grDifDif[""..cnt.."-Path"]=""..d;
				grDifDif[""..cnt.."-Songs"]=cnt_difdif[d];
				grDifDif[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grDifDif[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","difficulty");
			end;
		end;
		grDifDif["Max"]=cnt;
		--Expert
		cnt=0;
		for d=1,100 do
			if cnt_difexp[d] then
				cnt=cnt+1;
				if d<100 then
					grDifExp[""..cnt.."-Name"]=""..grSys["Name-difexp"].." - ["..d.."]";
				else
					grDifExp[""..cnt.."-Name"]=""..grSys["Name-difexp"].." - [100 and over]";
				end;
				grDifExp[""..cnt.."-Path"]=""..d;
				grDifExp[""..cnt.."-Songs"]=cnt_difexp[d];
				grDifExp[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grDifExp[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","difficulty");
			end;
		end;
		grDifExp["Max"]=cnt;
		--Challenge
		cnt=0;
		for d=1,100 do
			if cnt_difcha[d] then
				cnt=cnt+1;
				if d<100 then
					grDifCha[""..cnt.."-Name"]=""..grSys["Name-difcha"].." - ["..d.."]";
				else
					grDifCha[""..cnt.."-Name"]=""..grSys["Name-difcha"].." - [100 and over]";
				end;
				grDifCha[""..cnt.."-Path"]=""..d;
				grDifCha[""..cnt.."-Songs"]=cnt_difcha[d];
				grDifCha[""..cnt.."-Banner"]=THEME:GetPathG("Common fallback","banner");
				grDifCha[""..cnt.."-Jacket"]=THEME:GetPathG("_wheel/_sort/sort","difficulty");
			end;
		end;
		grDifCha["Max"]=cnt;

		--[ja] グループソート用 
		cnt=0;
		for g=1,#groups do
			if cnt_group[groups[g]] then
				if not last_chk then
					last_group=groups[g];
					last_chk=true;
				end;
				cnt=cnt+1;
				local _=GetGroupParameter(groups[g],"name")
				grGroup[""..cnt.."-Name"]=(_=="" and groups[g] or _);
				grGroup[""..cnt.."-Path"]=groups[g];
				grGroup[""..cnt.."-Songs"]=cnt_group[groups[g]];
				grGroup[""..cnt.."-Banner"]=SONGMAN:GetSongGroupBannerPath(groups[g]);
				grGroup[""..cnt.."-Jacket"]=GetGroupGPath(groups[g]);
				if last_group==groups[g] then
					grSys["Select_Now-group"]=cnt;
				end;
			end;
		end;
		grGroup["Max"]=cnt;

		--[ja]初期値
		grData=grGroup;
		grSys["Sort"]=1;
		grSys["Selected"]=grSys["Select_Now-group"];
		setenv("grTitle",grTitle);
		setenv("grArtist",grArtist);
		setenv("grMaxBpm",grMaxBpm);
		setenv("grMinBpm",grMinBpm);
		setenv("grSongLen",grSongLen);
		setenv("grDifAll",grDifAll);
		setenv("grDifBeg",grDifBeg);
		setenv("grDifBas",grDifBas);
		setenv("grDifDif",grDifDif);
		setenv("grDifExp",grDifExp);
		setenv("grDifCha",grDifCha);
		setenv("grGroup",grGroup);
		setenv("grData",grData);
		setenv("grSys",grSys);
		setenv("sgSys",sgSys);
	end;
	return last_chk;
end;

-- [ja] 現在選択している曲をグループ選択の選択位置にする 
function SetGroupState_Song(song)
	if not song then return; end;
	local grData={};
	grData=getenv("grData");
	local grSys={};
	grSys=getenv("grSys");
	local grGroup={};
	grGroup=getenv("grGroup");
	local grTitle={};
	grTitle=getenv("grTitle");
	local grArtist={};
	grArtist=getenv("grArtist");
	local grMaxBpm={};
	grMaxBpm=getenv("grMaxBpm");
	local grMinBpm={};
	grMinBpm=getenv("grMinBpm");
	local grSongLen={};
	grSongLen=getenv("grSongLen");
	local grDifAll={};
	grDifAll=getenv("grDifAll");
	local grDifBeg={};
	grDifBeg=getenv("grDifBeg");
	local grDifBas={};
	grDifBas=getenv("grDifBas");
	local grDifDif={};
	grDifDif=getenv("grDifDif");
	local grDifExp={};
	grDifExp=getenv("grDifExp");
	local grDifCha={};
	grDifCha=getenv("grDifCha");
	local _chk;
	local v;
	local a_list={"a","b","c","d","e","f","g","h","i","j","k","l","m","n",
				  "o","p","q","r","s","t","u","v","w","x","y","z"};
	-- Group
	v=song:GetGroupName();
	for i=1,grGroup["Max"] do
		if grGroup[""..i.."-Path"]==v then
			grSys["Select_Now-group"]=i;
			if grSortMode[grSys["Sort"]]=="group" then
				grSys["Selected"]=i;
			end;
		end;
	end;
	-- Title
	_chk=string.lower(song:GetTranslitFullTitle());
	if string.find(_chk,"^%d.*") then
		v="num";
	elseif not string.find(_chk,"^%d.*") and not string.find(_chk,"^%u.*")
		and not string.find(_chk,"^%l.*") then
		v="other";
	else
		for a=1,#a_list do
			if string.find(_chk,"^"..a_list[a]..".*") then
				v=a_list[a];
			end;
		end;
	end;
	if v then
		for i=1,grTitle["Max"] do
			if grTitle[""..i.."-Path"]==v then
				grSys["Select_Now-title"]=i;
				if grSortMode[grSys["Sort"]]=="title" then
					grSys["Selected"]=i;
				end;
			end;
		end;
	end;
	v=nil;
	-- Artist
	_chk=string.lower(song:GetTranslitArtist());
	if string.find(_chk,"^%d.*") then
		v="num";
	elseif not string.find(_chk,"^%d.*") and not string.find(_chk,"^%u.*")
		and not string.find(_chk,"^%l.*") then
		v="other";
	else
		for a=1,#a_list do
			if string.find(_chk,"^"..a_list[a]..".*") then
				v=a_list[a];
			end;
		end;
	end;
	if v then
		for i=1,grArtist["Max"] do
			if grArtist[""..i.."-Path"]==v then
				grSys["Select_Now-artist"]=i;
				if grSortMode[grSys["Sort"]]=="artist" then
					grSys["Selected"]=i;
				end;
			end;
		end;
	end;
	v=nil;
	local bpms=song:GetDisplayBpms();
	-- MaxBPM
	if song:IsDisplayBpmSecret() or song:IsDisplayBpmRandom() then
		v="501";
	else
		v=""..math.floor(math.max(math.min(bpms[2],10000),0)/20);
	end;
	if v then
		for i=0,grMaxBpm["Max"] do
			if grMaxBpm[""..i.."-Path"]==v then
				grSys["Select_Now-maxbpm"]=i;
				if grSortMode[grSys["Sort"]]=="maxbpm" then
					grSys["Selected"]=i;
				end;
			end;
		end;
	end;
	v=nil;
	-- MinBPM
	if song:IsDisplayBpmSecret() or song:IsDisplayBpmRandom() then
		v="501";
	else
		v=""..math.floor(math.max(math.min(bpms[1],10000),0)/20);
	end;
	if v then
		for i=0,grMinBpm["Max"] do
			if grMinBpm[""..i.."-Path"]==v then
				grSys["Select_Now-minbpm"]=i;
				if grSortMode[grSys["Sort"]]=="minbpm" then
					grSys["Selected"]=i;
				end;
			end;
		end;
	end;
	v=nil;
	-- SongLen
	v=""..math.floor(math.max(math.min(song:MusicLengthSeconds(),5000),0)/10);
	if v then
		for i=0,grSongLen["Max"] do
			if grSongLen[""..i.."-Path"]==v then
				grSys["Select_Now-songlen"]=i;
				if grSortMode[grSys["Sort"]]=="songlen" then
					grSys["Selected"]=i;
				end;
			end;
		end;
	end;
	v=nil;
	-- DifAll
	local meter_type=GetUserPref_Theme("UserMeterType");
	local dif=(GAMESTATE:GetPreferredDifficulty(GAMESTATE:GetMasterPlayerNumber()) or Difficulty[1]);
	if song:HasStepsTypeAndDifficulty(_STEPSTYPE(),dif) then
		local st=song:GetOneSteps(_STEPSTYPE(),dif);
		local meter=((meter_type=="LV100") and GetConvertDifficulty_LV100(song,st) or st:GetMeter());
		v=""..math.min(math.max(meter,1),100);
		if v then
			for i=1,grDifAll["Max"] do
				if grDifAll[""..i.."-Path"]==v then
					grSys["Select_Now-difall"]=i;
					if grSortMode[grSys["Sort"]]=="difall" then
						grSys["Selected"]=i;
					end;
				end;
			end;
		end;
	end;
	v=nil;
	-- Dif
	local _max={grDifBeg["Max"],grDifBas["Max"],grDifDif["Max"],grDifExp["Max"],grDifCha["Max"]};
	local _name={"difbeg","difbas","difdif","difexp","difcha"}
	for d=1,5 do
	if song:HasStepsTypeAndDifficulty(_STEPSTYPE(), Difficulty[d]) then
		local st=song:GetOneSteps(_STEPSTYPE(), Difficulty[d]);
		local meter=((meter_type=="LV100") and GetConvertDifficulty_LV100(song,st) or st:GetMeter());
		v=""..math.min(math.max(meter,1),100);
		if v then
			for i=1,_max[d] do
				local _v={grDifBeg[""..i.."-Path"],grDifBas[""..i.."-Path"],grDifDif[""..i.."-Path"],
						grDifExp[""..i.."-Path"],grDifCha[""..i.."-Path"]};
				if _v[d]==v then
					grSys["Select_Now-".._name[d]]=i;
					if grSortMode[grSys["Sort"]]==_name[d] then
						grSys["Selected"]=i;
					end;
				end;
			end;
		end;
	end;
	end;
	v=nil;
	setenv("grSys",grSys);
end;

function KillGroup()
	setenv("CreatedSortText",false);
	setenv("grData",nil);
end;

function GetOpenGroupFolder()
	local grData={};
	grData=getenv("grData");
	local grSys={};
	grSys=getenv("grSys");
	return grData[""..grSys["Selected"].."-Path"] or nil;
end;


function IsGroupMode()
	-- [ja] オプション設定が「Classic」だとfalse 
	return true;
end;

--[ja] フォルダ情報 
local groupInfo={};
function SetGroupInfo()
	groupInfo={};
	local groups=SONGMAN:GetSongGroupNames();
	for g=1,#groups do
		groupInfo[groups[g].."-Path"]=groups[g];
		groupInfo[groups[g].."-Name"]=groups[g];
		groupInfo[groups[g].."-Banner"]=SONGMAN:GetSongGroupBannerPath(groups[g]);
		groupInfo[groups[g].."-Jacket"]=GetGroupGPath(groups[g]);
		groupInfo[groups[g].."-Songs"]=#(SONGMAN:GetSongsInGroup(groups[g]));
		groupInfo[groups[g].."-MeterType"]="DDR";
		groupInfo[groups[g].."-MenuColor"]="";
		groupInfo[groups[g].."-EXFName"]="EXFolder";
		groupInfo[groups[g].."-EXFColor"]="1.0,0,0,1.0";
		groupInfo[groups[g].."-EXFBanner"]="";
		local ini;
		if HasGroupIni(groups[g]) then
			ini=OpenFile(GetExFolderPath(groups[g]).."group.ini");
			local tmp="";
			tmp=GetFileParameter(ini,"Name");
			if tmp~="" then groupInfo[groups[g].."-Name"]     =tmp; end;
			tmp=GetFileParameter(ini,"MeterType");
			if tmp~="" then groupInfo[groups[g].."-MeterType"]=tmp; end;
			tmp=GetFileParameter(ini,"MenuColor");
			if tmp~="" then groupInfo[groups[g].."-MenuColor"]=tmp; end;
			tmp=GetFileParameter(ini,"ExtraName");
			if tmp~="" then groupInfo[groups[g].."-EXFName"]  =tmp; end;
			tmp=GetFileParameter(ini,"ExtraColor");
			if tmp~="" then groupInfo[groups[g].."-EXFColor"] =tmp; end;
			tmp=GetFileParameter(ini,"ExtraGraphic");
			if tmp~="" then groupInfo[groups[g].."-EXFBanner"] =tmp; end;
			CloseFile(ini);
		end;
	end;
end;

function GetGroupInfo(group,prm)
	return groupInfo[group.."-"..prm];
end;