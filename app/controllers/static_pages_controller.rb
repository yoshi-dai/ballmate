class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top privacypolicy]
  def top; end
  
  def privacypolicy; end
end
