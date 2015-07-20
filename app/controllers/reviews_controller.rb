class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_movie
  before_action :authenticate_user!

  def new
    @review = Review.new
  end

  def edit
    if @review.user != current_user
      redirect_to root_path, notice: "This is not your review to edit"
    end
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.movie_id = @movie.id

    if @review.save
      redirect_to @movie
    else
      render 'new'
    end
  end

  def update
    if @review.update(review_params) && @review.user == current_user
      redirect_to @review, notice: "Review was successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    if @review.user == current_user
      @review.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
