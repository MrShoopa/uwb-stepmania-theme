--[[
  [ja] ぼかしフィルター
    file : ファイル
    scale : ぼかしの強さ
    already : すでに縮小済み
    excmd : コマンド（Blurメッセージ）
--]]
local file,scale,already,excmd=...;
local rander = string.lower(split(',',PREFSMAN:GetPreference('VideoRenderers'))[1]);
local tex="Tex"..math.random(10000000);
local t=Def.ActorFrame{};
if not excmd or excmd=="" then
    excmd=function(self)end;
end;

if rander=='opengl' then
	t[#t+1]= Def.ActorFrameTexture{
		Name = tex;
		InitCommand=function(self)
			self:SetTextureName( tex );
			self:SetWidth(SCREEN_WIDTH/scale);
			self:SetHeight(SCREEN_HEIGHT/scale);
			self:EnableAlphaBuffer(true);
			self:Create();
		end;
		OnCommand=function(self)
			self:Draw();
			self:visible(true);
		end;
    LoadActor(file)..{
      InitCommand=function(self)
        if not already then
          self:zoom(1.0/scale);
        end;
      end;
    };
	};
	t[#t+1]=Def.ActorFrame{
		Def.Sprite{
			Texture = tex;
			InitCommand=cmd(FullScreen);
      BlurMessageCommand=excmd;
		};
	};
else
	t[#t+1]=Def.ActorFrame{
		Def.Quad{
      InitCommand=function(self)
        self:horizalign(left);
        self:vertalign(top);
        if not already then
          self:FullScreen();
        else
          self:zoomto(SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale);
        end;
        self:diffuse(0.6,0.6,0.8,0.5);
      end;
      BlurMessageCommand=excmd;
		};
			InitCommand=cmd(zoom,scale);
	};
end;

return t;