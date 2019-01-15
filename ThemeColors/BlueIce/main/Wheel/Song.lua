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
	LoadActor("_wheel base")..{
		InitCommand=cmd(y,20;);
		SetMessageCommand=function(self,params)
			self:diffuse(GetSongWheel_Color(i));
		end;
	};
	LoadActor("_wheel over")..{
		InitCommand=cmd(y,20;diffuseshift;
			effectcolor1,1,1,1,1;effectcolor2,1,1,1,0.5;
			effecttiming,3,1,3,1);
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
						self:LoadFromCachedBanner(g);
					else
						self:Load(g);
					end;
					self:rate(1.0);
				end;
			else
				self:Load( THEME:GetPathG("Common fallback","jacket") );
			end;
			self:scaletocover(0,0,180,180);
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
		end;
	};
	LoadActor("_wheel name")..{
		InitCommand=cmd(y,115;blend,"BlendMode_Add";);
		SetMessageCommand=function(self,params)
			self:diffuse(BoostColor(GetSongWheel_Color(i),0.5));
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(maxwidth,176;x,-88;y,115;horizalign,left);
		SetMessageCommand=function(self,params)
			self:settextf("%s",GetSongWheel_Title(i));
			self:diffuse(Color("White"));
			self:strokecolor(0,0,0,0.2);
		end;
	};
};
return t;