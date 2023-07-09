class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top about use]
  def top; end

  def about; end

  def use; end
end
