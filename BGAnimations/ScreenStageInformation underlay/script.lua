if song then
	-- [ja] こっそりBGA to Lua 
	BGAtoLUA(song);
	-- [ja] こっそりコンフィグ設定登録
	SetwaieiInfo("BGScale",GetUserPref_Theme("UserBGScale"));
	SetwaieiInfo("Haishin",GetUserPref_Theme("UserHaishin"));
	SetwaieiInfo("BGRatio","");
	--[ja] 動画の切り替え時と最初のステップの時間差が1秒未満の場合余白を設定 
	--     何故か3.9と比較してちょっと遅めに再生されるので0.1秒早めに再生することでゴリ押し回避 
	--     B2bで直るので↑の0.1秒部分は削除 
	--     -10000.0とか設定されてると落ちるんで-4.0まで 
	var=GetSMParameter(song,"bgchanges");
	local prm;
	local min_offset=TC_GetMetric('Wait','GameplayIn');
	local min_sec=min_offset;
	if var~="" then
		local setoffset=false;
		local file_offset=0.0;
		prm=split(",",var);
		for i=1,#prm do
			if string.find(prm[i],".avi",0,true) or string.find(prm[i],".mpg",0,true)
				or string.find(prm[i],".mpeg",0,true) or string.find(prm[i],".flv",0,true)
				or string.find(prm[i],".mp4",0,true) then
				file_offset=tonumber(split("=",prm[i])[1]);
				setoffset=true;
				break;
			end;
		end;
		if setoffset then
			local movie_start=PlayerBeat2Sec(GetSidePlayer(PLAYER_1),file_offset);
			local movie_offset=0;
			if movie_start<0 then
				movie_offset=-movie_start+0.1;	-- [ja] 完全に同じタイミングにするとフェード処理がされないので0.1秒多めにとる 
			else
				movie_offset=0;
			end;
			if movie_offset>min_offset then
				-- movie_start=movie_offset-0.1;
				min_sec=math.min(movie_offset,10.0);
			else
				min_sec=min_offset;
			end;
		end;
	end;
	var=GetSMParameter(song,"fgchanges");
	if var~="" then
		local setoffset=false;
		local file_offset=0.0;
		prm=split(",",var);
		for i=1,#prm do
			if string.find(prm[i],".avi",0,true) or string.find(prm[i],".mpg",0,true)
				or string.find(prm[i],".mpeg",0,true) or string.find(prm[i],".flv",0,true)
				or string.find(prm[i],".mp4",0,true) then
				file_offset=tonumber(split("=",prm[i])[1]);
				setoffset=true;
				break;
			end;
		end;
		if setoffset then
			local movie_start=PlayerBeat2Sec(GetSidePlayer(PLAYER_1),file_offset);
			local movie_offset=0;
			if movie_start<0 then
				movie_offset=-movie_start+0.1;	-- [ja] 完全に同じタイミングにするとフェード処理がされないので0.1秒多めにとる 
			else
				movie_offset=0;
			end;
			if movie_offset>min_offset then
				-- movie_start=movie_offset-0.1;
				min_sec=math.min(movie_offset,10.0);
			else
				min_sec=min_offset;
			end;
		end;
	end;
	SetwaieiInfo("BGStart",math.max(min_sec,min_offset));
end;
return Def.Actor{};