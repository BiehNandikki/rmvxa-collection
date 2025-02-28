#==============================================================================
# 
# �� YSA Battle Add-On: Party's Combo Counter
# -- Last Updated: 2011.12.26
# -- Level: Easy
# -- Requires: none
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YSA-PartyComboCounter"] = true

#==============================================================================
# �� Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.26 - Fixed counter when turn ends.
# 2011.12.18 - Updated Highest Combo Variables.
# 2011.12.16 - Started Script and Finished.
# 
#==============================================================================
# �� Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script will make a combo counter for party, which will show Number of Hits,
# Damage and Congratulation Words.
# 
#==============================================================================
# �� Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below �� Materials/�f�� but above �� Main. Remember to save.
# 
#==============================================================================
# �� Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YSA
  module COMBO
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Congratulation Words -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # When you reach a number of combo counts, there will have a congratulation
    # words like Great, Awesome, ... be shown under combo counter.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    CONGRAT_WORDS = { # Do not delete this,
      # ComboCounts       =>       "WORDS",
            3             =>        "Cool!",
            5             =>        "Great!",
            7             =>        "Awesome!",
            9             =>        "GODLIKE!!!",
    } # Do not delete this,
    CONGRAT_FONT = "VL Gothic"    
    CONGRAT_COLOR = [255,255,160] #[R,G,B]
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Mechanical Config -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # About when will stop combo counting.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    # When combo counter is being counting, if next damaged action is enemy's,
    # the combo counter will be stopped and start from zero.
    CANCEL_COMBO_WHEN_ENEMY_HIT = true
    
    # When combo counter is being counting, if next actor's attack is missed, 
    # cancel combo counting.
    CANCEL_COMBO_IF_MISS = true
    
    # When turn ends, Combo Counter will recount from zero (0).
    RECOUNT_WHEN_TURN_END = true
    
    # Variables contain Highest Combo Count and Highest Combo Damage
    VAR_COMBO_COUNT = 10
    VAR_COMBO_DAMAGE = 11
    RESET_EACH_BATTLE = false
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Visual Config -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # About when will stop combo counting.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    # FONT
    FONT_NAME = "VL Gothic"
    FONT_SIZE = 28
    
    # POSITION
    COMBO_COUNT_SENTENCE = "%d Hits!"
    COMBO_DAMAGE_SENTENCE = "%d Damage"
    
  end
end

#==============================================================================
# �� Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# �� Sprite_Combo_Count
#==============================================================================

class Sprite_Combo_Count < Sprite_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :count
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.opacity = 0
    self.x = Graphics.width - Graphics.width / 4
    self.y = 0
    @count = false
    @number = 0
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless SceneManager.scene_is?(Scene_Battle)
    if @count == true && SceneManager.scene.combo_count != nil
      self.zoom_x = self.zoom_y = 1.5 if @number != SceneManager.scene.combo_count
      refresh if @number != SceneManager.scene.combo_count      
      self.opacity = 120 if self.opacity < 120
      self.opacity += 10 if self.opacity < 255      
      self.zoom_x -= 0.1 if self.zoom_x > 1.0
      self.zoom_y -= 0.1 if self.zoom_y > 1.0
      self.y = 0 if self.y != 0
    end
    @count = false if @count == true && SceneManager.scene.combo_count == nil
    if @count == false && (self.bitmap != nil || (self.bitmap != nil && self.bitmap.disposed?))
      self.y -= [1, self.y + 24].min
      self.opacity -= 11
    end
    self.bitmap.dispose if self.opacity == 0 && self.bitmap != nil && !self.bitmap.disposed?
    @number = 0 if self.opacity == 0
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    @number = SceneManager.scene.combo_count
    bitmap = Bitmap.new(Graphics.width / 4, 26)
    bitmap.font.name = YSA::COMBO::FONT_NAME
    bitmap.font.size = YSA::COMBO::FONT_SIZE
    bitmap.font.bold = true
    bitmap.font.out_color.set(0, 0, 0, 255)
    bitmap.font.color.set(255, 255, 255)
    text = sprintf(YSA::COMBO::COMBO_COUNT_SENTENCE, @number)
    bitmap.draw_text(0, 0, Graphics.width / 4, 26, text, 2)
    self.bitmap.dispose if self.bitmap != nil
    self.bitmap = bitmap
  end
  
end

#==============================================================================
# �� Sprite_Combo_Damage
#==============================================================================

class Sprite_Combo_Damage < Sprite_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :count
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.opacity = 0
    self.x = Graphics.width - Graphics.width / 4
    self.y = 26
    @count = false
    @number = 0
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless SceneManager.scene_is?(Scene_Battle)
    if @count == true && SceneManager.scene.combo_damage != nil
      refresh if @number != SceneManager.scene.combo_damage      
      self.opacity = 120 if self.opacity < 120
      self.opacity += 10 if self.opacity < 255      
    end
    @count = false if @count == true && SceneManager.scene.combo_damage == nil
    if @count == false && (self.bitmap != nil || (self.bitmap != nil && self.bitmap.disposed?))
      self.opacity -= 11
    end
    self.bitmap.dispose if self.opacity == 0 && self.bitmap != nil && !self.bitmap.disposed?
    @number = 0 if self.opacity == 0
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    @number += [SceneManager.scene.combo_damage - @number, (12 + rand(20)) * ((SceneManager.scene.combo_damage - @number) / 1000 + 1)].min
    bitmap = Bitmap.new(Graphics.width / 4, 26)
    bitmap.font.name = YSA::COMBO::FONT_NAME
    bitmap.font.size = YSA::COMBO::FONT_SIZE
    bitmap.font.bold = true
    bitmap.font.out_color.set(0, 0, 0, 255)
    bitmap.font.color.set(255, 255, 255)
    text = sprintf(YSA::COMBO::COMBO_DAMAGE_SENTENCE, @number)
    bitmap.draw_text(0, 0, Graphics.width / 4, 26, text, 2)
    self.bitmap.dispose if self.bitmap != nil
    self.bitmap = bitmap
  end
  
end

#==============================================================================
# �� Sprite_Combo_Congrat
#==============================================================================

class Sprite_Combo_Congrat < Sprite_Base

  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.opacity = 0
    self.x = Graphics.width - Graphics.width / 4
    self.y = 52
    @number = 0
    @count = false
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless SceneManager.scene_is?(Scene_Battle)
    @count = SceneManager.scene.sprite_combo_count.count
    if @count == true && SceneManager.scene.combo_count != nil
      refresh if @number != SceneManager.scene.combo_count
      self.opacity = 120 if self.opacity < 120
      self.opacity += 10 if self.opacity < 255      
      self.zoom_x -= 0.1 if self.zoom_x > 1.0
      self.zoom_y -= 0.1 if self.zoom_y > 1.0
    end
    @count = false if @count == true && SceneManager.scene.combo_count == nil
    if @count == false && (self.bitmap != nil || (self.bitmap != nil && self.bitmap.disposed?))
      self.opacity -= 14
    end
    self.bitmap.dispose if self.opacity == 0 && self.bitmap != nil && !self.bitmap.disposed?
    @number = 0 if self.opacity == 0
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    @number = SceneManager.scene.combo_count
    if YSA::COMBO::CONGRAT_WORDS[@number] != nil
      self.zoom_x = self.zoom_y = 2.0
      bitmap = Bitmap.new(Graphics.width / 4, 36)
      bitmap.font.name = YSA::COMBO::CONGRAT_FONT
      bitmap.font.size = 36
      bitmap.font.bold = true
      bitmap.font.out_color.set(0, 0, 0, 255)
      color = YSA::COMBO::CONGRAT_COLOR
      bitmap.font.color.set(color[0], color[1], color[2])
      text = YSA::COMBO::CONGRAT_WORDS[@number]
      bitmap.draw_text(0, 0, Graphics.width / 4, 36, text, 2)
      self.bitmap.dispose if self.bitmap != nil
      self.bitmap = bitmap
    end
  end
  
end

#==============================================================================
# �� Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: execute_damage
  #--------------------------------------------------------------------------
  alias combo_execute_damage execute_damage
  def execute_damage(user)
    combo_execute_damage(user)
    if user.actor?
      SceneManager.scene.combo_count = 0 if SceneManager.scene.combo_count == nil
      SceneManager.scene.combo_damage = 0 if SceneManager.scene.combo_damage == nil
      SceneManager.scene.sprite_combo_count.count = true
      SceneManager.scene.sprite_combo_damage.count = true
      SceneManager.scene.combo_count += 1
      SceneManager.scene.combo_damage += @result.hp_damage
      $game_variables[YSA::COMBO::VAR_COMBO_COUNT] = SceneManager.scene.combo_count if $game_variables[YSA::COMBO::VAR_COMBO_COUNT] < SceneManager.scene.combo_count
      $game_variables[YSA::COMBO::VAR_COMBO_DAMAGE] = SceneManager.scene.combo_damage if $game_variables[YSA::COMBO::VAR_COMBO_DAMAGE] < SceneManager.scene.combo_damage
    end
    SceneManager.scene.combo_count = nil if user.enemy? && YSA::COMBO::CANCEL_COMBO_WHEN_ENEMY_HIT
    SceneManager.scene.combo_damage = nil if user.enemy? && YSA::COMBO::CANCEL_COMBO_WHEN_ENEMY_HIT
  end
  
  #--------------------------------------------------------------------------
  # alias method: item_apply
  #--------------------------------------------------------------------------
  alias combo_item_apply item_apply
  def item_apply(user, item)
    combo_item_apply(user, item)
    SceneManager.scene.combo_count = nil if item.damage.none?
    SceneManager.scene.combo_damage = nil if item.damage.none?
    SceneManager.scene.combo_count = nil if user.actor? && @result.missed && YSA::COMBO::CANCEL_COMBO_IF_MISS
    SceneManager.scene.combo_damage = nil if user.actor? && @result.missed && YSA::COMBO::CANCEL_COMBO_IF_MISS
  end
  
end

#==============================================================================
# �� Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :viewportCombo

  #--------------------------------------------------------------------------
  # alias method: create_viewports
  #--------------------------------------------------------------------------
  alias combo_viewport_create_viewports create_viewports
  def create_viewports
    combo_viewport_create_viewports
    @viewportCombo = Viewport.new
    @viewportCombo.z = 250
  end
  
end

#==============================================================================
# �� Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :combo_count
  attr_accessor :combo_damage
  attr_accessor :sprite_combo_count
  attr_accessor :sprite_combo_damage
  attr_accessor :spriteset
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias combo_create_all_windows create_all_windows
  def create_all_windows
    combo_create_all_windows
    @sprite_combo_count = Sprite_Combo_Count.new(SceneManager.scene.spriteset.viewportCombo)
    @combo_count = nil
    @sprite_combo_damage = Sprite_Combo_Damage.new(SceneManager.scene.spriteset.viewportCombo)
    @combo_damage = nil
    @sprite_combo_congrat = Sprite_Combo_Congrat.new(SceneManager.scene.spriteset.viewportCombo)
    if YSA::COMBO::RESET_EACH_BATTLE
      $game_variables[YSA::COMBO::VAR_COMBO_COUNT] = 0
      $game_variables[YSA::COMBO::VAR_COMBO_DAMAGE] = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose_spriteset
  #--------------------------------------------------------------------------
  alias combo_dispose_spriteset dispose_spriteset
  def dispose_spriteset
    combo_dispose_spriteset
    @combo_count = nil
    @combo_damage = nil
    @sprite_combo_count.dispose
    @sprite_combo_damage.dispose
    @sprite_combo_congrat.dispose
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias combo_update_basic update_basic
  def update_basic
    combo_update_basic
    @sprite_combo_count.update if @sprite_combo_count != nil
    @sprite_combo_damage.update if @sprite_combo_damage != nil
    @sprite_combo_congrat.update if @sprite_combo_congrat != nil
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  alias combo_counter_turn_end turn_end
  def turn_end
    combo_counter_turn_end
    if YSA::COMBO::RECOUNT_WHEN_TURN_END
      @combo_count = nil if @combo_count != nil
      @combo_damage = nil if @combo_damage != nil
    end
  end
  
end

#==============================================================================
# 
# �� End of File
# 
#==============================================================================