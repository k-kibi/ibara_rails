class BattleAction < ApplicationRecord
	belongs_to :battle_info, :foreign_key => [:result_no, :battle_id, :generate_no], :primary_key => [:result_no, :battle_id, :generate_no], :class_name => "BattleInfo"
	belongs_to :acter, :foreign_key => [:result_no, :battle_id, :act_id, :generate_no], :primary_key => [:result_no, :battle_id, :act_id, :generate_no], :class_name => "BattleActer"
	belongs_to :skill, :foreign_key => :skill_id, :primary_key => :skill_id,  :class_name => "SkillDatum"
	belongs_to :fuka,  :foreign_key => :fuka_id,  :primary_key => :proper_id, :class_name => "ProperName"

    scope :total, ->(params) {
        select("*").
        select("COUNT(battle_actions.id) AS act_count").
        select("COUNT(DISTINCT battle_actions.battle_id) AS page_count").
        total_acter_count(params)
    }

    scope :total_acter_count, ->(params) {
        if params["total_acter"] == "on" then
            select("COUNT(DISTINCT battle_acters.e_no, battle_acters.enemy_id) AS acter_count")
        else
            select("\"-\" AS acter_count")
        end
    }

    scope :includes_or_joins, ->(params) {
        includes(:battle_info, :skill, :fuka).
        includes(acter: [:pc_name, :world, :party, :enemy])
    }

    scope :groups, ->(params) {
        group("battle_actions.result_no").
        group_page(params).
        group_turn(params).
        group_acter(params).
        group_skill(params).
        group_fuka(params)
    }
  
    scope :group_page, ->(params) {
        if params["group_page"] == "on" then
            group("battle_actions.battle_id")
        end
    }

    scope :group_turn, ->(params) {
        if params["group_turn"] == "on" then
            group("battle_actions.turn")
        end
    }

    scope :group_acter, ->(params) {
        group_e_no(params).
        group_enemy(params)
    }
  
    scope :group_e_no, ->(params) {
        if params["group_acter"] == "on" then
            if params["acter_pc"] == "on" ||  params[:q]["acter_acter_type_eq_any"].size == 0 then
                group("battle_acters.e_no")
            end
        end
    }
 
    scope :group_enemy, ->(params) {
        if params["group_acter"] == "on" then
            if params["acter_npc"] == "on" ||  params[:q]["acter_acter_type_eq_any"].size == 0 then
                group("battle_acters.enemy_id")
            end
        end
    }

    scope :group_skill, ->(params) {
        if params["act_type_skill"] == "on" || params["act_type_normal"] == "on" || params[:q]["act_type_eq_any"].size == 0 then
            group("battle_actions.skill_id")
        end
    }

    scope :group_fuka, ->(params) {
        if params["act_type_fuka"] == "on" || !params[:q]["act_type_eq_any"]  || params[:q]["act_type_eq_any"].size == 0 then
            group("battle_actions.fuka_id")
        end
    }

    scope :having_order, ->(params) {
        if params["group_page"] == "on" then
            return
        end

        if !params[:q][:s] then
            return order("act_count desc")

        elsif params[:q][:s].include?(" ") then
            sort = params[:q][:s]
            params[:q].delete(:s)
            return order(sort)
        end
        nil
    }

end
