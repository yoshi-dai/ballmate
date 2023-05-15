class MatchingsController < ApplicationController
  def index
    @matchings = Matching.all
  end

  def show
    @matching = Matching.find(params[:id])
  end
end
