class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingAPI.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, :notice => "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
    @place = BeermappingAPI.place_by(params[:id])
    @scores = BeermappingAPI.scores_by(params[:id])
  end
end