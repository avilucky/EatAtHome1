class FoodReviewsController < ApplicationController
  
  before_action :set_food_review, only: [:show, :edit, :update, :destroy]
  before_action :set_food_item

  # GET /food_reviews
  # GET /food_reviews.json
  def index
    @food_reviews=FoodReview.where(food_item_id: @food_item.id)
  end

  # GET /food_reviews/new
  def new
    @food_review = FoodReview.new
  end

  # GET /food_reviews/1/edit
  def edit
  end

  # POST /food_reviews
  # POST /food_reviews.json
  def create
    @food_review = FoodReview.new(food_review_params)
    @user=get_current_user
    @food_review.user_id = @user.id
    @food_review.food_item_id = @food_item.id

    respond_to do |format|
      if @food_review.save
        format.html { redirect_to @food_item, notice: 'Food review was successfully created.' }
        format.json { render :show, status: :created, location: @food_review }
      else
        format.html { render :new }
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /food_reviews/1
  # PATCH/PUT /food_reviews/1.json
  def update
    respond_to do |format|
      if @food_review.update(food_review_params)
        format.html { redirect_to food_item_food_reviews_path(@food_item), notice: 'Food review was successfully updated.' }
        format.json { render :show, status: :ok, location: @food_review }
      else
        format.html { render :edit }
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_reviews/1
  # DELETE /food_reviews/1.json
  def destroy
    @food_review.destroy
    respond_to do |format|
      format.html { redirect_to food_item_food_reviews_path(@food_item), notice: 'Food review was successfully destroyed.' }
      format.json { head :no_content}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food_review
      @food_review = FoodReview.find(params[:id])
    end
    
    def set_food_item
      @food_item = FoodItem.find(params[:food_item_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_review_params
      params.require(:food_review).permit(:rating, :comment)
    end
end
