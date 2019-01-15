local index=...;
local i;
local t = Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	SetMessageCommand=function(self,params)
		i=index or params.DrawIndex;	-- [ja] index番号の取得 
		self:stoptweening();
	--[[
		楽曲の情報が入ったテーブル変数を取得します。
		これにより、以下の情報を取得することができます。
		GetSongWheel_Index(i)		ホイールの位置（中央が0）
		GetSongWheel_Song(i)		Song型
		GetSongWheel_Title(i)		曲名
		GetSongWheel_SubTitle(i)		サブタイトル
		GetSongWheel_Artist(i)		アーティスト名
		GetSongWheel_Graphic(i)		画像パス
		GetSongWheel_Color(i)		曲色
		GetSongWheel_MeterType(i)	難易度スケール（DDR / DDR X / ITG）
	--]]
	end;
	LoadActor(THEME:GetPathG('_objects/_circle', 'glow100px'))..{
		InitCommand = function(self)
			self:x(0);
			self:y(0);
			self:zoomto(270,270);
			self:effectclock('bgm');
			self:diffuseshift();
		end;
		SetMessageCommand = function(self, params)
			if i==6 then
				local c = GetSongWheel_Color(i);
				self:effectcolor1(c[1], c[2], c[3], 0.75);
				self:effectcolor2(c[1], c[2], c[3], 0.5);
			else
				self:effectcolor1(1, 1, 1, 0);
				self:effectcolor2(1, 1, 1, 0);
			end;
		end;
	};
	ActorWheel() {	-- [ja] ホイール画像呼び出し用の関数です 
		--[ja] ジャケット表示
		SetMessageCommand=function(self,params)
			self:stoptweening();
			local song = GetSongWheel_Song(i);
			local g=GetSongWheel_Graphic(i);
			if song then
				if GetSongWheel_Index(i)==0 then
					self:visible(true);
					self:Load(g);
					self:stoptweening();
					self:rate(0.3);
					self:position(0);
					self:diffuseupperleft(1,1,1,1);
				else
					if g==song:GetBannerPath() then
						if self:LoadFromCachedBanner(g) then
							self:LoadFromCachedBanner(g);
						else
							self:Load(g);
						end;
					else
						self:Load(g);
					end;
					self:rate(1.0);
				end;
			else
				self:Load( THEME:GetPathG("Common fallback","jacket") );
			end;
			if song and g==song:GetCDImagePath() then
				self:scaletocover(0,0,192,192);
			else
				self:scaletocover(0,0,172,172);
			end;
			self:x(0);
			self:y(0);
			local w=self:GetWidth();
			local h=self:GetHeight();
			if w>h then
				local cr=(w-h)/w/2;
				self:cropleft(cr);
				self:cropright(cr);
			else
				self:cropleft(0);
				self:cropright(0);
			end;
			self:shadowlengthx(0);
			self:shadowlengthy(2);
		end;
	};
};
return t;