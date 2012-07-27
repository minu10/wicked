module Wicked::Controller::Concerns::Steps
  extend ActiveSupport::Concern

  def jump_to(goto_step)
    @skip_to = goto_step
  end

  def skip_step
    @skip_to = @next_step
  end

  def step
    @step
  end

  # will return true if step passed in is the currently rendered step
  def current_step?(step_name)
    return false if step_name.nil? || step.nil?
    step == step_name
  end

  # will return true if the step passed in has already been executed by the wizard
  def past_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) > steps.index(step_name)
  end

  # will return true if the step passed in has already been executed by the wizard
  def future_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) < steps.index(step_name)
  end

  # will return true if the last step is the step passed in
  def previous_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) - 1  == steps.index(step_name)
  end

  # will return true if the next step is the step passed in
  def next_step?(step_name)
    return false if steps.index(step).nil? || steps.index(step_name).nil?
    steps.index(step) + 1  == steps.index(step_name)
  end

  module ClassMethods
    def steps=(steps)
      @wizard_steps = steps
    end

    def steps(*steps_to_set)
      @wizard_steps = steps_to_set unless steps_to_set.blank?
      @wizard_steps
    end
  end

  def steps
    self.class.steps
  end
  alias :wizard_steps :steps
  alias :steps_list   :steps

  def previous_step(current_step = nil)
    return @previous_step if current_step == nil
    index =  steps.index(current_step)
    step  =  steps.at(index - 1) if index.present? && index != 0
    step ||= steps.first
    step
  end


  def next_step(current_step = nil)
    return @next_step if current_step == nil
    index = steps.index(current_step)
    step  = steps.at(index + 1) if index.present?
    step  ||= :finish
    step
  end


end
