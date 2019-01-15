--[[
    Comment Language : Ja
    waiei2 以降に追加した関数
--]]

-- ヘッダーのサイズ
_HS = 0;
_HS2 = _HS/2;

-- ぼかしサイズ
local BULR_SIZE = 20;
-- 設定ファイル
local SETTING_FILE = 'waieiSettings.ini';

-- 画面切り替え時間定数
local SEC_SCREEN_IN = 0.4;
local SEC_SCREEN_OUT = 0.4;

--[[
    ぼかしサイズを取得
--]]
function GetwaieiBulrSize()
	return BULR_SIZE;
end;

--[[
    画面切り替え時間を取得（IN）
--]]
function GetwaieiScreenInSec()
    return SEC_SCREEN_IN;
end;

--[[
    画面切り替え時間を取得（OUT）
--]]
function GetwaieiScreenOutSec()
    return SEC_SCREEN_OUT;
end;

--[[
    バナー画像に最もふさわしいファイルパスを取得
    @song
--]]
function GetMainBannerPath( song )
	local ret = "";
	if song:HasBanner() and not song:HasPreviewVid() then
		return song:GetBannerPath();
	end;
    if song:HasPreviewVid() then
		return song:GetPreviewVidPath();
	end;
    if song:HasDisc() then
		return song:GetDiscPath();
	end;
	return "";
end;

--[[
    専用カラーを取得
    @name
        Text : 文字用の青
        Dark : 暗めの青
        Light : 明るめの青
        Red : 赤
        WheelDefault : ホイールのデフォルトカラー
        その他 : 白
--]]
function waieiColor( name )
	if name=="Text" then
		return Color("Blue");
	end;
    if name=="Dark" then
		return BoostColor( Color("Blue"), 0.9);
	end;
    if name=="Light" then
		return BoostColor( Color("Blue"), 1.2);
	end;
    if name=="Red" then
		return BoostColor( Color("Red"), 0.9);
	end;
    if name=="WheelDefault" then
		return color("0.5,0.75,1.0,1.0");
	end;
	return Color("White");
end;

--[[
    Songが画像を持っているか確認
    @song
    @mode
        jacket : ジャケット
        cd : CD
        disc : ディスクイメージ
        その他 ： バナー
--]]
local function wheelHasG( song, mode )
	if mode=='jacket' then
		return song:HasJacket();
	end;
    if mode=='cd' then
		return song:HasCDImage();
	end;
    if mode=='disc' then
		return song:HasDisc();
	end;
	return song:HasBanner();
end;

--[[
    Songが持っている画像を取得
    @song
    @mode
        jacket : ジャケット
        cd : CD
        disc : ディスクイメージ
        その他 ： バナー
--]]
local function wheelGetG( song, mode )
	if mode=='jacket' then
		return song:GetJacketPath();
	end;
    if mode=='cd' then
		return song:GetCDImagePath();
	end;
    if mode=='disc' then
		return song:GetDiscPath();
	end;
    return song:GetBannerPath();
end;

--[[
    現在のホイールモードを取得
    オプションの設定値からプログラム側で使用する文字列に変換する
--]]
function getWheelMode(self)
	local wheelmode="JBN";
	if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
		wheelmode = "JBN"
	elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
		wheelmode = "JBG"
	elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
		wheelmode = "BNJ"
	elseif GetUserPref_Theme("UserWheelMode") == 'BG->Jacket' then
		wheelmode = "BGJ"
	end;
	return wheelmode;
end;

--[[
    ホイールモードに合った楽曲の画像を取得
    @song
    @wheelmode
        JBN : Jacket -> Banner -> BG
        JBG : Jacket -> BG -> Banner
        BNJ : BG -> Banner -> Jacket
        BGJ : Banner -> BG -> Jacket
        ただし、JacketはテーマカラーによってCD画像が優先される
--]]
function GetBannerStat(song, wheelmode)
    -- テーマカラーのジャケット画像に対応する形式を取得
	local mode = split(',', TC_GetMetric('Wheel', 'Mode'));
	local mode1 = mode[1] or 'jacket';
	local mode2 = mode[2] or 'cd';
	local tmp = {};
	local fall_bg = THEME:GetPathG("Common fallback", "jacket");
	local fall_bn = THEME:GetPathG("Common fallback", "banner");
	local g = fall_bg;
	tmp[2] = -1;
    
    -- MP3に埋め込まれているジャケット画像を取得しないようにするためそれらの画像がステマニに認識されていないかチェック
	local mode1_tag_graphic = false;
	local mode2_tag_graphic = false;

	if wheelHasG(song, mode1) and (
        -- MP3に埋め込まれているジャケット画像
        string.find(wheelGetG(song, mode1), 'AlbumArtSmall', 0, true)
        or string.find(wheelGetG(song, mode1), 'Folder', 0, true)
    ) then
        -- 認識されてしまっている
		mode1_tag_graphic=true;
        
	end;

	if wheelHasG(song, mode2) and (
        -- MP3に埋め込まれているジャケット画像
        string.find(wheelGetG(song, mode2), 'AlbumArtSmall', 0, true)
        or string.find(wheelGetG(song,mode2), 'Folder', 0, true)
    ) then
        -- 認識されてしまっている
		mode2_tag_graphic=true;
        
	end;

    -- MP3ジャケット画像が認識されている場合は無視する
	if wheelmode == "JBN" then
		if wheelHasG(song, mode1) and wheelGetG(song, mode1) ~= song:GetCDTitlePath() and not mode1_tag_graphic then
			g = wheelGetG(song, mode1);
			tmp[2] = 3;
		elseif wheelHasG(song, mode2) and wheelGetG(song, mode2) ~= song:GetCDTitlePath() and not mode2_tag_graphic then
			g = wheelGetG(song, mode2);
			tmp[2] = 3;
		elseif song:HasBanner() then
			g = song:GetBannerPath();
			tmp[2] = 1;
		elseif song:HasBackground() then
			g = song:GetBackgroundPath();
			tmp[2] = 2;
		else
			g = fall_bg;
			tmp[2] = -1;
		end;
	elseif wheelmode == "JBG" then
		if wheelHasG(song, mode1) and wheelGetG(song, mode1) ~= song:GetCDTitlePath() and not mode1_tag_graphic then
			g = wheelGetG(song, mode1);
			tmp[2] = 3;
		elseif wheelHasG(song, mode2) and wheelGetG(song, mode2) ~= song:GetCDTitlePath() and not mode2_tag_graphic then
			g = wheelGetG(song, mode2);
			tmp[2] = 3;
		elseif song:HasBackground() then
			g = song:GetBackgroundPath();
			tmp[2] = 2;
		elseif song:HasBanner() then
			g = song:GetBannerPath();
			tmp[2] = 1;
		else
			g = fall_bg;
			tmp[2] = -1;
		end;
	elseif wheelmode == "BNJ" then
		if song:HasBanner() then
			g = song:GetBannerPath();
			tmp[2] = 1;
		elseif wheelHasG(song, mode1) and wheelGetG(song, mode1) ~= song:GetCDTitlePath() and not mode1_tag_graphic then
			g = wheelGetG(song, mode1);
			tmp[2] = 3;
		elseif wheelHasG(song, mode2) and wheelGetG(song, mode2) ~= song:GetCDTitlePath() and not mode2_tag_graphic then
			g = wheelGetG(song, mode2);
			tmp[2] = 3;
		elseif song:HasBackground() then
			g = song:GetBackgroundPath();
			tmp[2] = 2;
		else
			g = fall_bn;
			tmp[2]=-1;
		end;
	elseif wheelmode == "BGJ" then
		if song:HasBackground() then
			g = song:GetBackgroundPath();
			tmp[2] = 2;
		elseif wheelHasG(song, mode1) and wheelGetG(song, mode1) ~= song:GetCDTitlePath() and not mode1_tag_graphic then
			g = wheelGetG(song, mode1);
			tmp[2] = 3;
		elseif wheelHasG(song, mode2) and wheelGetG(song, mode2) ~= song:GetCDTitlePath() and not mode2_tag_graphic then
			g = wheelGetG(song, mode2);
			tmp[2] = 3;
		elseif song:HasBanner() then
			g = song:GetBannerPath();
			tmp[2] = 1;
		else
			g = fall_bg;
			tmp[2] = -1;
		end;
	end;
	tmp[1] = g;
	return tmp;
end;

--[[
    セレクトスタイルの初期選択
--]]
function GameStyleDefaultChoice()
	if GAMESTATE:GetCurrentGame():GetName() == "dance" and GAMESTATE:GetNumPlayersEnabled() >= 2 then
		return "Versus";
	else
		return "Single";
	end;
end;

--[[
    待ち時間らしいけど使ってないぞこれ…
    @song
--]]
function GetGameWaitTime(song)
	return math.max( song:GetFirstSecond() - 3.0, 0.0)
end;

--[[
    判定数からダンスポイントを取得
    @w1 W1の判定数
    @w2 W2の判定数
    @w3 W3の判定数
    @ok OKの判定数
    @total_tap 合計タップ数
    @total_hold 合計ロングノート数
--]]
function CalcDancePoints(w1, w2, w3, ok, total_tap, total_hold)
	return (w1 * 3 + w2 * 2 + w3 + ok * 3) / ((total_tap + total_hold) * 3);
end;

--[[
    プレイヤーのProfile設定保存ディレクトリパスを取得
    @pn プレイヤー
--]]
function GetPlayerSaveProfileDir(pn)
	return (pn == PLAYER_1) and PROFILEMAN:GetProfileDir('ProfileSlot_Player1') or PROFILEMAN:GetProfileDir('ProfileSlot_Player2');
end;

--[[
    プレイヤーのProfile設定保存ファイルパスを取得
    @pn プレイヤー
--]]
function GetPlayerSaveProfileFile(pn)
	local dir = GetPlayerSaveProfileDir(pn);
	if dir ~= '' and FILEMAN:DoesFileExist(dir..SETTING_FILE) then
		return dir..SETTING_FILE;
	end;
	return false;   -- 処理を続けてはいけないのでfalseを返す
end;

--[[
    指定したファイルが動画ファイルなら true
    @filename   ファイル名
--]]
function checkMovieFile(filename)
	local low_filename = string.lower(filename);
	return (string.find(low_filename, "^.+%.avi$")
		or string.find(low_filename, "^.+%.mpg$")
		or string.find(low_filename, "^.+%.mpeg$")
		or string.find(low_filename, "^.+%.flv$")
		or string.find(low_filename, "^.+%.mp4$"));
end;
