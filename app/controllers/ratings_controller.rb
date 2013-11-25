class RatingsController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index]

  def index
    @ratings = Rating.all

    Rails.cache.write("beer top 3", Beer.top(3), expires_in: 10.minutes) unless Rails.cache.exist? "beer top 3"
    @top_beers = Rails.cache.read "beer top 3"

    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: 10.minutes) unless Rails.cache.exist? "brewery top 3"
    @top_breweries = Rails.cache.read "brewery top 3"

    Rails.cache.write("style top 3", Style.top(3), expires_in: 10.minutes) unless Rails.cache.exist? "style top 3"
    @top_styles = Rails.cache.read "style top 3"

    Rails.cache.write("user most active top 3", User.most_active(3), expires_in: 10.minutes) unless Rails.cache.exist? "user most active top 3"
    @most_active_users = Rails.cache.read "user most active top 3"

    Rails.cache.write("recent ratings 5", Rating.recent(5), expires_in: 10.minutes) unless Rails.cache.exist? "recent ratings 5"
    @recent_ratings = Rails.cache.read "recent ratings 5"
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new rating_params

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if currently_signed_in? rating.user
    redirect_to :back
  end

  private

    def rating_params
      params.require(:rating).permit(:score, :beer_id)
    end
end