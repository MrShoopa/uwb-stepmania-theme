--[[
	ScreenGameplayで呼び出し
	BGを取得して表示する
--]]
local song = ...;	-- [ja] song型
local bgAlpha = PREFSMAN:GetPreference("BGBrightness");
local songBgLayer = 99999;
local t=Def.ActorFrame{};

local function GetSongBG(song)
	if song and song:HasBackground() then
		g=song:GetBackgroundPath()
	else
		g=THEME:GetPathG('common','fallback background');
	end;
	return g;
end

local function in_table(v,tbl)
	for i=1,#tbl do
		if v == tbl[i] then
			return true;
		end;
	end;
	return false;
end;

local function ChangeBGAMes(self,params,filename,cnt)
	if params.filename == filename then
		self:finishtweening();
		--[[
		-- [ja] 再生処理を入れるとTabキー押したときに本来の背景も高速再生されてしまうけど
		--      本来の背景が再生されていたらこちらは意図的に再生処理行わなくても大丈夫っぽい
		if params.movie then
			if params.loop ~= 0 then
				self:loop(true);
			else
				self:loop(false);
			end;
			if params.start ~= '0' then
				self:position(-99999999);
			end;
			self:rate(params.rate/cnt);
			self:play();
		end;
		--]]
		-- [ja] フェードあり
		if params.fade ~= '0' then
			-- [ja] 前の画像より新しい画像のほうが手前にある場合、新しい画像を徐々に表示
			if params.layer>params.oldLayer then
				self:diffusealpha(0);
				self:linear(1);
			end;
		end;
		self:diffusealpha(1);
	elseif params.old == filename then
		self:finishtweening();
		-- [ja] フェードあり
		if params.fade ~= '0' then
			-- [ja] 前の画像より新しい画像のほうが奥にある場合、古い画像を徐々に消す
			if params.layer<params.oldLayer then
				self:diffusealpha(1);
				self:linear(1);
			-- [ja] 前の画像より新しい画像のほうが手前にある場合、1秒後に古い画像を消す
			elseif params.layer>params.oldLayer then
				self:diffusealpha(1);
				self:sleep(1);
			end;
		end;
		self:diffusealpha(0);
	else
		self:finishtweening();
		self:diffusealpha(0);
		--[[
		self:finishtweening();
		if params.fade ~= '0' then
			self:diffusealpha(1);
			self:linear(1);
		end;
		--]]
		--[[
		if params.movie then
			self:pause(0);
		end;
		--]]
	end;
end;

if song then

local bgchange = GetSMParameter(song,'bgchanges');

if bgchange=='' then
	-- [ja] 背景変化なし
	t[#t+1] = LoadActor(THEME:GetPathG('_Song','bg'));
else
	-- [ja] 背景変化あり
	local bgList = split(',',bgchange);	-- [ja] , で区切ってBG単位に分ける
	local bgName = {};		-- [ja] 背景一覧（ファイル名単位で管理）
	local bgDetail = {};	-- [ja] BGAの詳細
	local out='';
	local songdir = song:GetSongDir();
	local songbg = GetSongBG(song);

	-- [ja] BGCHANGESの詳細を取得
	--local b='';
	for i=1,#bgList do
		bgList[i] = string.gsub(bgList[i],'%s*$','');	-- [ja] 後ろのスペース削除
		local bgParams = split('=',bgList[i]);			-- [ja] = で区切ってパラメータ単位に分ける
		local detail={};
		local filename  = bgParams[2];		-- [ja] ファイル名
		detail.position = 1.0*bgParams[1];	-- [ja] 再生位置
		detail.rate     = 1.0*bgParams[3];	-- [ja] 再生速度
		detail.fade     = bgParams[4];		-- [ja] フェード切り替え
		detail.loop     = bgParams[5];		-- [ja] ループ再生
		detail.start    = bgParams[6];		-- [ja] 最初から再生
		detail.layer    = i;				-- [ja] 読み込んだ時のiの値（iが大きいほど手前のレイヤーとなる）
		if filename == '-nosongbg-' or string.lower(filename) == 'songbackground' then
			-- [ja] 曲の背景
			detail.filename = songbg;
		else
			-- [ja] それ以外
			if FILEMAN:DoesFileExist(songdir..filename) then
				detail.filename = songdir..filename;
			else
				detail.filename = THEME:GetPathG('','_blank');
			end;
		end;
		detail.movie  = checkMovieFile(detail.filename);					-- [ja] 動画ファイルかどうか
		bgDetail[#bgDetail+1] = detail;
		-- [ja] 同じファイルは一つだけLoadActorすること 
		if not in_table(detail.filename,bgName) then
			if filename==songbg then
				songBgLayer = i;
			end;
			bgName[#bgName+1] = detail.filename;
		end;
		--b=b..i..' : '..filename..'\n';
	end;
	--_SYS(b)
	
	local bga = Def.ActorFrame{};
	for i=1,#bgName do
		local name = split('/',bgName[i]);
		if string.find(name[#name],"^.+%..+$") then	-- [ja] 拡張子があればtrue 
			if bgName[i]==songbg then
				-- [ja] SongBGの場合だけ高品質画像として読み込む
				bga[#bga+1] = Def.Sprite{
					InitCommand=function(self)
						self:LoadBackground(bgName[i]);
						self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
						self:diffusealpha((bgName[i]==songbg) and 1 or 0);
						if checkMovieFile(bgName[i]) then
							self:pause(0);
							self:position(-99999999);
						end;
					end;
					ChangeBGAMessageCommand = function(self,params)
						ChangeBGAMes(self,params,bgName[i],cnt);
					end;
				}
			else
				bga[#bga+1] = LoadActor(bgName[i])..{
					InitCommand=function(self)
						self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
						self:diffusealpha((bgName[i]==songbg) and 1 or 0);
						if checkMovieFile(bgName[i]) then
							self:pause(0);
							self:position(-99999999);
						end;
					end;
					ChangeBGAMessageCommand = function(self,params)
						ChangeBGAMes(self,params,bgName[i],cnt);
					end;
				}
			end;
		else
			bga[#bga+1] = LoadActor(bgName[i])..{
				InitCommand=function(self)
					local name = split('/',bgName[i]);
					self:zoom(1);
					self:halign(SCREEN_CENTER_X);
					self:valign(SCREEN_CENTER_Y);
					self:diffusealpha((bgName[i]==songbg) and 1 or 0);
				end;
				ChangeBGAMessageCommand = function(self,params)
					ChangeBGAMes(self,params,bgName[i],cnt);
				end;
			}
		end;
	end;
	t[#t+1] = bga;
--	t[#t+1] = Def.Quad{
--		InitCommand=cmd(diffuse,Color('Black');zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,1-bgAlpha);
--	};
	
	local fps = 60;
	local bgaNum = 1;
	local sec={frame=1.0/fps,total=0,now=0};
	local function update(self,dt)
		sec.total=sec.total+dt;
		if sec.total>=sec.now+sec.frame then
			sec.now = sec.now+sec.frame;
			for i=bgaNum,#bgDetail do
				if GAMESTATE:GetSongBeat() >= bgDetail[i].position then
					MESSAGEMAN:Broadcast('ChangeBGA',{
						filename = bgDetail[i].filename,
						rate     = bgDetail[i].rate,
						fade     = bgDetail[i].fade,
						loop     = bgDetail[i].loop,
						start    = bgDetail[i].start,
						movie    = bgDetail[i].movie,
						folder   = bgDetail[i].folder,
						layer    = bgDetail[i].layer,
						old      = (i>1) and bgDetail[i-1].filename or songbg,
						oldLayer = (i>1) and bgDetail[i-1].layer or songBgLayer
					});
					bgaNum=bgaNum+1;
				else
					break;
				end;
			end;
			
		end;
	end;
	t.InitCommand = function(self)
		self:SetUpdateFunction(update);
	end;
end;

end;
return t;
