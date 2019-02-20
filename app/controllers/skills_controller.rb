class SkillsController < ApplicationController
  include MyUtility
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  # GET /skills
  def index
    placeholder_set
    param_set
    @count	= Skill.notnil().includes(:pc_name, :world, [skill: :timing], [skill_mastery: [:requirement_1, :requirement_2]]).search(params[:q]).result.count()
    @search	= Skill.notnil().includes(:pc_name, :world, [skill: :timing], [skill_mastery: [:requirement_1, :requirement_2]]).page(params[:page]).search(params[:q])
    @search.sorts = "id asc" if @search.sorts.empty?
    @skills	= @search.result.per(50)
  end

  def param_set
    @form_params = {}

    @latest_result = Name.maximum("result_no")

    params_clean(params)
    if !params["is_form"] then
        params["result_no_form"] ||= sprintf("%d",@latest_result)
    end

    params_to_form(params, @form_params, column_name: "pc_name_name", params_name: "pc_name_form", type: "text")
    params_to_form(params, @form_params, column_name: "result_no", params_name: "result_no_form", type: "number")
    params_to_form(params, @form_params, column_name: "generate_no", params_name: "generate_no_form", type: "number")
    params_to_form(params, @form_params, column_name: "e_no", params_name: "e_no_form", type: "number")
    params_to_form(params, @form_params, column_name: "name", params_name: "name_form", type: "text")
    params_to_form(params, @form_params, column_name: "skill_id", params_name: "skill_id_form", type: "number")
    params_to_form(params, @form_params, column_name: "lv", params_name: "lv_form", type: "number")

    checkbox_params_set_query_any(params, @form_params, query_name: "world_world_eq_any",
                             checkboxes: [{params_name: "is_ibaracity", value: 0, first_checked: true},
                                          {params_name: "is_ansinity" , value: 1, first_checked: true}])

    params_to_form(params, @form_params, column_name: "skill_name", params_name: "skill_form", type: "text")
    params_to_form(params, @form_params, column_name: "skill_ep", params_name: "ep_form", type: "number")
    params_to_form(params, @form_params, column_name: "skill_sp", params_name: "sp_form", type: "number")
    params_to_form(params, @form_params, column_name: "skill_text", params_name: "text_form", type: "text")

    params_to_form(params, @form_params, column_name: "skill_timing_name", params_name: "timing_form", type: "text")

    params_to_form(params, @form_params, column_name: "skill_mastery_requirement_1_name_or_skill_mastery_requirement_2_name", params_name: "requirement_form", type: "text")
    params_to_form(params, @form_params, column_name: "skill_mastery_requirement_1_lv_or_requirement_2_lv", params_name: "requirement_lv_form", type: "number")
    params_to_form(params, @form_params, column_name: "skill_mastery_requirement_1_name", params_name: "requirement_1_form", type: "text")
    params_to_form(params, @form_params, column_name: "skill_mastery_requirement_1_lv", params_name: "requirement_1_lv_form", type: "number")
    params_to_form(params, @form_params, column_name: "skill_mastery_requirement_2_name", params_name: "requirement_2_form", type: "text")
    params_to_form(params, @form_params, column_name: "skill_mastery_requirement_2_lv", params_name: "requirement_2_lv_form", type: "number")

    checkbox_params_set_query_any(params, @form_params, query_name: "skill_type_id_eq_any",
                             checkboxes: [{params_name: "type_active",   value: 0, first_checked: true},
                                          {params_name: "type_passive" , value: 1, first_checked: true}])

    checkbox_params_set_query_any(params, @form_params, query_name: "skill_element_id_eq_any",
                             checkboxes: [{params_name: "element_none",   value: 0},
                                          {params_name: "element_fire",   value: 1},
                                          {params_name: "element_water",  value: 2},
                                          {params_name: "element_wind",   value: 3},
                                          {params_name: "element_ground", value: 4},
                                          {params_name: "element_light",  value: 5},
                                          {params_name: "element_dark",   value: 6}])

    toggle_params_to_variable(params, @form_params, params_name: "show_world")
    toggle_params_to_variable(params, @form_params, params_name: "show_skill")
    toggle_params_to_variable(params, @form_params, params_name: "show_skill_name")
    toggle_params_to_variable(params, @form_params, params_name: "show_skill_text")
    toggle_params_to_variable(params, @form_params, params_name: "show_skill_mastery")
  end
  # GET /skills/1
  #def show
  #end

  # GET /skills/new
  #def new
  #  @skill = Skill.new
  #end

  # GET /skills/1/edit
  #def edit
  #end

  # POST /skills
  #def create
  #  @skill = Skill.new(skill_params)

  #  if @skill.save
  #    redirect_to @skill, notice: "Skill was successfully created."
  #  else
  #    render action: "new"
  #  end
  #end

  # PATCH/PUT /skills/1
  #def update
  #  if @skill.update(skill_params)
  #    redirect_to @skill, notice: "Skill was successfully updated."
  #  else
  #    render action: "edit"
  #  end
  #end

  # DELETE /skills/1
  #def destroy
  #  @skill.destroy
  #  redirect_to skills_url, notice: "Skill was successfully destroyed."
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def skill_params
      params.require(:skill).permit(:result_no, :generate_no, :e_no, :name, :skill_id, :lv)
    end
end