-- [ja] CustomScore_SM5b2(プレイヤー,モード,steps,現在のステップ数,最後の判定) 
-- [ja] 現在のバージョンだとこれが通常使うFunction↓
function CustomScore_SM5b2(params,scoremode,steps,cur)
	local pn=params.Player;
	local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	if (GAMESTATE:GetPlayerState(pn):GetPlayerController()~='PlayerController_Autoplay') then
		local ret=0;
		local rv=steps:GetRadarValues(pn);
		local maxsteps=math.max(rv:GetValue('RadarCategory_TapsAndHolds')
			+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls'),1);
		if scoremode=="DDR A" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local w4=pss:GetTapNoteScores('TapNoteScore_W4');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				w4=w4+1;
			elseif params.TapNoteScore=='TapNoteScore_W5' then
			end;
			ret=(math.round((w1 + w2 + w3*0.6 + w4*0.2 + hd) *100000/maxsteps-(w2 + w3 + w4))*10);
			pss:SetScore(ret);
		elseif scoremode=="SuperNOVA2" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
			elseif params.TapNoteScore=='TapNoteScore_W5' then
			end;
			ret=(math.round((w1 + w2 + w3/2 + hd) *100000/maxsteps-(w2 + w3))*10);
			pss:SetScore(ret);
		elseif scoremode=="3.9" or scoremode=="Hybrid" then
			local maxscore;
			if scoremode=="3.9" then
				maxscore=math.max(math.min(steps:GetMeter(),10),1)*10000000;
			else
				maxscore=100000000;
			end;
			if _SONG():IsMarathon() then
				maxscore=maxscore*3;
			elseif _SONG():IsLong() then
				maxscore=maxscore*2;
			end;
			local resolution=(((maxsteps+1)*maxsteps)/2)
			local onescore=math.floor(maxscore/resolution);
			local lastscore=((cur==maxsteps) and maxscore-(onescore*resolution) or 0);
			local curscore=pss:GetScore();
			local addscore=0;
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				addscore=onescore*cur+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				addscore=onescore*cur+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				addscore=math.floor(onescore*cur*0.9)+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				addscore=math.floor(onescore*cur*0.5)+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
			elseif params.TapNoteScore=='TapNoteScore_W5' then
			end;
			ret=pss:GetScore()+addscore;
			pss:SetScore(ret);
		else
			-- [ja] DancePoints/カスタムスコアを使用しない 
		end;
	else
		pss:SetScore(0);
	end;
	return;
end;

----------

-- [ja] CustomScore_SM5b1(プレイヤー,モード,steps,現在のステップ数,最後の判定) 
function CustomScore_SM5b1(params,scoremode,steps,cur)
	local pn=params.Player;
	local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	if (GAMESTATE:GetPlayerState(pn):GetPlayerController()~='PlayerController_Autoplay') then
		local ret=0;
		local rv=steps:GetRadarValues(pn);
		local maxsteps=math.max(rv:GetValue('RadarCategory_TapsAndHolds')
			+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls'),1);
		if scoremode=="DDR A" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local w4=pss:GetTapNoteScores('TapNoteScore_W4');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			local minus=0;	-- [ja] b1では強制でデフォルトスコア計算の値が加算されるのでマイナスする 
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
				minus=4;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
				minus=3;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				w4=w4+1;
				minus=2;
			elseif params.TapNoteScore=='TapNoteScore_W5' then
				minus=1;
			end;
			ret=(math.round((w1 + w2 + w3*0.6 + w4*0.2 + hd) *100000/maxsteps-(w2 + w3 + w4))*10)-minus;
			pss:SetScore(ret);
		elseif scoremode=="SuperNOVA2" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			local minus=0;	-- [ja] b1では強制でデフォルトスコア計算の値が加算されるのでマイナスする 
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
				minus=4;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
				minus=3;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				minus=2;
			elseif params.TapNoteScore=='TapNoteScore_W5' then
				minus=1;
			end;
			ret=(math.round((w1 + w2 + w3/2 + hd) *100000/maxsteps-(w2 + w3))*10)-minus;
			pss:SetScore(ret);
		elseif scoremode=="3.9" or scoremode=="Hybrid" then
			local maxscore;
			if scoremode=="3.9" then
				maxscore=math.max(math.min(steps:GetMeter(),10),1)*10000000;
			else
				maxscore=100000000;
			end;
			if _SONG():IsMarathon() then
				maxscore=maxscore*3;
			elseif _SONG():IsLong() then
				maxscore=maxscore*2;
			end;
			local resolution=(((maxsteps+1)*maxsteps)/2)
			local onescore=math.floor(maxscore/resolution);
			local lastscore=((cur==maxsteps) and maxscore-(onescore*resolution) or 0);
			local curscore=pss:GetScore();
			local addscore=0;
			local minus=0;	-- [ja] b1では強制でデフォルトスコア計算の値が加算されるのでマイナスする 
			if params.HoldNoteScore=='HoldNoteScore_Held' then
				addscore=onescore*cur+lastscore;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				addscore=onescore*cur+lastscore;
				minus=5;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				addscore=math.floor(onescore*cur*0.9)+lastscore;
				minus=4;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				addscore=math.floor(onescore*cur*0.5)+lastscore;
				minus=3;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				minus=2;
			elseif params.TapNoteScore=='TapNoteScore_W5' then
				minus=1;
			end;
			ret=pss:GetScore()+addscore-minus;
			pss:SetScore(ret);
		else
			-- [ja] カスタムスコアを使用しない 
		end;
	else
		pss:SetScore(0);
	end;
	return;
end;


----------

local CustomScore_SM5a2_Score={0,0};
function CustomScore_SM5a2_Init()
	CustomScore_SM5a2_Score[1]=0;
	CustomScore_SM5a2_Score[2]=0;
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		CustomScore_SM5a2_Set(PLAYER_1,0);
	end;
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		CustomScore_SM5a2_Set(PLAYER_2,0);
	end;
end;
function CustomScore_SM5a2_Set(pn,var)
	CustomScore_SM5a2_Score[(pn==PLAYER_1) and 1 or 2]=var;
end;
function CustomScore_SM5a2_Get(pn)
	return CustomScore_SM5a2_Score[(pn==PLAYER_1) and 1 or 2];
end;
function CustomScore_SM5a2_Out()
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):SetScore(CustomScore_SM5a2_Score[1]);
	end;
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):SetScore(CustomScore_SM5a2_Score[2]);
	end;
end;
-- [ja] CustomScore_SM5a2(プレイヤー,モード,steps,現在のステップ数,最後の判定) 
function CustomScore_SM5a2(params,scoremode,steps,cur)
	local pn=params.Player;
	local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	if (GAMESTATE:GetPlayerState(pn):GetPlayerController()~='PlayerController_Autoplay') then
		local ret=0;
		local rv=steps:GetRadarValues(pn);
		local maxsteps=math.max(rv:GetValue('RadarCategory_TapsAndHolds')
			+rv:GetValue('RadarCategory_Holds')+rv:GetValue('RadarCategory_Rolls'),1);
		if scoremode=="DDR A" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local w4=pss:GetTapNoteScores('TapNoteScore_W4');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			if params.HoldNoteScore=='HoldNoteScore_LetGo' then
			elseif params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
			elseif params.TapNoteScore=='TapNoteScore_W4' then
				w4=w4+1;
			end;
			ret=(math.round((w1 + w2 + w3*0.6 + w4*0.2 + hd) *100000/maxsteps-(w2 + w3 + w4))*10);
			CustomScore_SM5a2_Set(pn,ret);
		elseif scoremode=="SuperNOVA2" then
			local w1=pss:GetTapNoteScores('TapNoteScore_W1');
			local w2=pss:GetTapNoteScores('TapNoteScore_W2');
			local w3=pss:GetTapNoteScores('TapNoteScore_W3');
			local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');
			if params.HoldNoteScore=='HoldNoteScore_LetGo' then
			elseif params.HoldNoteScore=='HoldNoteScore_Held' then
				hd=hd+1;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				w1=w1+1;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				w2=w2+1;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				w3=w3+1;
			end;
			ret=(math.round((w1 + w2 + w3/2 + hd) *100000/maxsteps-(w2 + w3))*10);
			CustomScore_SM5a2_Set(pn,ret);
		elseif scoremode=="3.9" or scoremode=="Hybrid" then
			local maxscore;
			if scoremode=="3.9" then
				maxscore=math.max(math.min(steps:GetMeter(),10),1)*10000000;
			else
				maxscore=100000000;
			end;
			if _SONG():IsMarathon() then
				maxscore=maxscore*3;
			elseif _SONG():IsLong() then
				maxscore=maxscore*2;
			end;
			local resolution=(((maxsteps+1)*maxsteps)/2)
			local onescore=math.floor(maxscore/resolution);
			local lastscore=((cur==maxsteps) and maxscore-(onescore*resolution) or 0);
			local curscore=CustomScore_SM5a2_Get(pn);
			local addscore=0;
			if params.HoldNoteScore=='HoldNoteScore_LetGo' then
			elseif params.HoldNoteScore=='HoldNoteScore_Held' then
				addscore=onescore*cur+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W1' then
				addscore=onescore*cur+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W2' then
				addscore=math.floor(onescore*cur*0.9)+lastscore;
			elseif params.TapNoteScore=='TapNoteScore_W3' then
				addscore=math.floor(onescore*cur*0.5)+lastscore;
			end;
			ret=CustomScore_SM5a2_Get(pn)+addscore;
			CustomScore_SM5a2_Set(pn,ret);
		else
			-- [ja] カスタムスコアを使用しない 
		end;
	else
	--	CustomScore_SM5a2_Set(pn,0);
	end;
	return;
end;

-- [ja] SM5本体のバージョンを取得してスコア計算方法を取得する (100 StepMania.luaが必要)
function GetCustomScoreMode()
	local customscore="";
	if GetSMVersion()<=1 then
		customscore="old";
	elseif GetSMVersion()==10 then
		customscore="5b1";
	elseif GetSMVersion()==2 or GetSMVersion()==3 then
		customscore="non";
	else
		customscore="5b2";
	end;
	return customscore;
end;