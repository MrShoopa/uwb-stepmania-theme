--[[ [ja]
	id			識別ID
	pn			プレイヤー
	chara		キャラクター
	charaStyle	鏡面反射あり
	charaAnime	アニメーションの設定（nil=設定、ID=指定IDのアニメーションを呼び出し）
--]]
local id,pn,chara,charaStyle,charaAnime=...;

-- [ja] 鏡面反射用キャラクターとアニメーションを合わせるための処理 
local CharaAnimeList=(getenv("CharaAnimeList")) or {};
local function SetCharacterAnimationList(charaId,animeList)
	CharaAnimeList[charaId]={};
	for i=1,#animeList do
		CharaAnimeList[charaId][i]=animeList[i];
	end;
	setenv("CharaAnimeList",CharaAnimeList);
end;
local function GetCharacterAnimationList(charaId)
	return getenv("CharaAnimeList")[charaId];
end;

if pn~=PLAYER_1 and pn~=PLAYER_2 then
	pn='0';	-- [ja] マスター
end;

local t=Def.ActorFrame{InitCommand=cmd(SortByDrawOrder,true)};
local chCommand='';

local zbias = 2.0;
local function CharacterZConfig(self)
	self:backfacecull(false);
	self:zbias(zbias);
end;

if chara then
	local BASE_BPM=120.0;
	local BASE_ZOOM=14;
	
	-- [ja] 停止場所を取得
	local step;
	if pn~='0' then
		step=GAMESTATE:GetCurrentSteps(pn);
	end;
	local stTiming;
	local stStops;
	local stStopPos={};
	local stStopLen={};
	local stStopCnt=1;
	local stDelays;
	local stDelayPos={};
	local stDelayLen={};
	local stDelayCnt=1;
	if step then
		stTiming = step:GetTimingData();
		stStops=stTiming:GetStops();
		stDelays=stTiming:GetDelays();
		for tm=1,#stStops do
			stStopPos[tm]=tonumber(split("=",stStops[tm])[1]);
			stStopLen[tm]=tonumber(split("=",stStops[tm])[2]);
		end;
		for tm=1,#stDelays do
			stDelayPos[tm]=tonumber(split("=",stDelays[tm])[1]);
			stDelayLen[tm]=tonumber(split("=",stDelays[tm])[2]);
		end;
	end;
	
	local flAnime = 0;	-- [ja] 現在のアニメーション（0=Ready,1=HereWeGo,2～=ダンス）

	-- [ja] キャラクターファイル・アニメーション取得
	local f=GetTextBlock(chara:GetCharacterDir()..'/character.ini','character');
	chCommand=GetBlockPrm(f,'initcommand');
	local chModel = chara:GetModelPath();
	local chAnimeCnt = 2;	-- [ja] ダンサーアニメーションの数
	local chAnime = {};
	if charaAnime==nil then
		chAnime[#chAnime+1] = chara:GetRestAnimationPath();
		chAnime[#chAnime+1] = chara:GetWarmUpAnimationPath();
		for i=1,chAnimeCnt do
			chAnime[#chAnime+1] = chara:GetDanceAnimationPath();
		end;
		SetCharacterAnimationList(id,chAnime);
	else
		chAnime=GetCharacterAnimationList(charaAnime);
	end;
	
	local chRate = 1.0;		-- [ja] キャラクター動作スピード
	local curAnime = 0;		-- [ja] 現在のアニメーション番号
	local curLine = 0;
	local curLineOld = 0;
	local chAnimeActor = {};
	t[#t+1]=Def.ActorFrame{
		FOV=60;
		InitCommand=function(self)
			self:rotationy(180);
			if charaStyle then
				self:basezoomy(-1);
			end;
			MESSAGEMAN:Broadcast('Ch',{id=id});
			self:zoom(self:GetZoom()*BASE_ZOOM);
		end;
		ChMessageCommand=function(self,params)
			if params.id == id then
				if chCommand~='' then
					(loadstring("return cmd("..chCommand..");")())(self);
				end;
			end;
		end;
		-- Ready
		Def.Model{
			Meshes=chModel,
			Materials=chModel,
			Bones=chAnime[1],
			InitCommand=function(self)
				self:diffusecolor(color("#1a1a1a"));
				CharacterZConfig(self);
			end;
			ChChangeBPMMessageCommand=function(self,params)
				if params.id == id then
					self:rate(params.rate);
				end;
			end;
			ChReadyMessageCommand=function(self,params)
				if params.id == id then
					self:visible(false);
				end;
			end;
		};
		-- Here we go
		Def.Model{
			Meshes=chModel,
			Materials=chModel,
			Bones=chAnime[2],
			InitCommand=function(self)
				self:visible(false);
				self:diffusecolor(color("#1a1a1a"));
				CharacterZConfig(self);
			end;
			ChChangeBPMMessageCommand=function(self,params)
				if params.id == id then
					self:rate(params.rate);
				end;
			end;
			ChReadyMessageCommand=function(self,params)
				if params.id == id then
					self:visible(true);
				end;
			end;
			ChGoMessageCommand=function(self,params)
				if params.id == id then
					self:linear(1.0);
					self:diffusecolor(1.0,1.0,1.0,1.0);
				end;
			end;
			ChChangeAnimeMessageCommand=function(self,params)
				if params.id == id then
					self:visible(false);
				end;
			end;
		};
		-- Animation1
		Def.Model{
			Meshes=chModel,
			Materials=chModel,
			Bones=chAnime[3],
			InitCommand=function(self)
				self:visible(false);
				CharacterZConfig(self);
			end;
			ChChangeBPMMessageCommand=function(self,params)
				if params.id == id then
					self:rate(params.rate);
				end;
			end;
			ChChangeAnimeMessageCommand=function(self,params)
				if params.id == id then
					self:visible(params.Anime==0);
				end;
			end;
		};
		-- Animation2
		Def.Model{
			Meshes=chModel,
			Materials=chModel,
			Bones=chAnime[4],
			InitCommand=function(self)
				self:visible(false);
				CharacterZConfig(self);
			end;
			ChChangeBPMMessageCommand=function(self,params)
				if params.id == id then
					self:rate(params.rate);
				end;
			end;
			ChChangeAnimeMessageCommand=function(self,params)
				if params.id == id then
					self:visible(params.Anime==1);
				end;
			end;
		};
	};

	local dtOld=0;
	local dt=0;
	local wait=1.0/60;
	local sgStart = _SONG2():GetFirstBeat();
	local sgBpm=0.0;
	local sgBpmOld=0.0;
	local sgCurrent;
	local sgCurrentOld;
	local function update(self,delta)
		dt=dt+delta;
		if dt-dtOld>wait then
			dtOld=dt;
			local sgPos=GAMESTATE:GetSongPosition();

			if stTiming then
				local sec =GAMESTATE:GetSongPosition():GetMusicSeconds();
				local beat=stTiming:GetBeatFromElapsedTime(sec);
				sgBpm=stTiming:GetBPMAtBeat(beat);
				if stStopCnt<=#stStops 
					and beat>=stStopPos[stStopCnt] then
					if sec<=stTiming:GetElapsedTimeFromBeat(stStopPos[stStopCnt])+stStopLen[stStopCnt] then
						sgBpm=0.0;
					else
						stStopCnt=stStopCnt+1;
					end;
				end;
				if stDelayCnt<=#stDelays
					and beat>=stDelayPos[stDelayCnt] then
					if sec<=stTiming:GetElapsedTimeFromBeat(stDelayPos[stDelayCnt])+stDelayLen[stDelayCnt] then
						sgBpm=0.0;
					else
						stDelayCnt=stDelayCnt+1;
					end;
				end;
			else
				sgBpm=(sgPos:GetCurBPS())*60;
				if sgPos:GetDelay() or sgPos:GetFreeze() then
					sgBpm=0.0;
				else
					sgBpm=(sgPos:GetCurBPS())*60;
				end;
			end;

			-- [ja] Ready
			if flAnime==0 and sgPos:GetSongBeat()+12>sgStart then
				flAnime=1;
				MESSAGEMAN:Broadcast("ChReady",{id=id});
			end;
			-- [ja] Here we go
			if flAnime==1 and sgPos:GetSongBeat()+8>sgStart then
				flAnime=2;
				MESSAGEMAN:Broadcast("ChGo",{id=id});
			end;
			-- [ja] アニメーション開始
			if flAnime==2 and sgPos:GetSongBeat()>sgStart then
				curAnime = math.floor(math.random(1)+0.99);
				flAnime=3;
				if charaAnime~=nil then
					MESSAGEMAN:Broadcast("ChChangeAnime",{id=charaAnime,Anime=curAnime});
				end;
				MESSAGEMAN:Broadcast("ChChangeAnime",{id=id,Anime=curAnime});
			end;
			
			-- [ja] 一定小節ごとにアニメーションの変更
			sgCurrent=math.floor((sgPos:GetSongBeat())/32);
			if flAnime==3 and sgCurrent ~= sgCurrentOld then
				curAnime = math.floor(math.random(2)+0.99)-1;
				if charaAnime~=nil then
					MESSAGEMAN:Broadcast("ChChangeAnime",{id=charaAnime,Anime=curAnime});
				end;
				MESSAGEMAN:Broadcast("ChChangeAnime",{id=id,Anime=curAnime});
				sgCurrentOld=sgCurrent;
			end;

			-- [ja] BPM変化によるアニメーション速度の変更
			if sgBpm ~= sgBpmOld then
				MESSAGEMAN:Broadcast("ChChangeBPM",{id=id,rate=sgBpm/BASE_BPM});
				sgBpmOld = sgBpm;
			end;

		end;
	end;
	t.InitCommand=function(self)
		self:SetUpdateFunction(update);
	end;

end;

return t;
