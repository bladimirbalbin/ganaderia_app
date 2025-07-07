class MembershipPlansController < ApplicationController
  def index
    @plans = MembershipPlan.all
  end

  def show
    
  end

  def new
  end

  def edit
  end
end
