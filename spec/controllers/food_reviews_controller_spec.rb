require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe FoodReviewsController, type: :controller do
  
  before :each do
    
    @user = User.new({:id => 1})
        @user.save(:validate => false)
        session[:user_id] = 1
        @food_item = FoodItem.new({:id => 1, :user_id => 1})
        @food_item.save(:validate => false)
  end

  # This should return the minimal set of attributes required to create a valid
  # FoodReview. As you add validations to FoodReview, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    hash = {}
    hash[:rating]=5
    hash[:comment]='a'
    hash[:food_item_id]=1 
    hash[:user_id]=1
    return hash
  }

  let(:invalid_attributes) {
    hash = {}
    hash[:rating]=-1
    hash[:comment]='a'
    hash[:food_item_id]=1
    hash[:user_id]=1
    return hash
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FoodReviewsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all food_reviews as @food_reviews" do
      food_review = FoodReview.create! valid_attributes
      get :index, {:food_item_id=>1}
      expect(assigns(:food_reviews)).to eq([food_review])
    end
  end

  describe "GET #new" do
    it "assigns a new food_review as @food_review" do
      get :new, {:food_item_id=>1}, valid_session
      expect(assigns(:food_review)).to be_a_new(FoodReview)
    end
  end

  describe "GET #edit" do
    it "assigns the requested food_review as @food_review" do
      food_review = FoodReview.create! valid_attributes
      get :edit, {:food_item_id=>1, :id => food_review.to_param}, valid_session
      expect(assigns(:food_review)).to eq(food_review)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new FoodReview" do
        expect {
          post :create, {:food_item_id=>1, :food_review => valid_attributes}, valid_session
        }.to change(FoodReview, :count).by(1)
      end

      it "assigns a newly created food_review as @food_review" do
        post :create, {:food_item_id=>1, :food_review => valid_attributes}, valid_session
        expect(assigns(:food_review)).to be_a(FoodReview)
        expect(assigns(:food_review)).to be_persisted
      end

      it "redirects to the food item page" do
        post :create, {:food_item_id=>1, :food_review => valid_attributes}, valid_session
        expect(response).to redirect_to(@food_item)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved food_review as @food_review" do
        post :create, {:food_item_id=>1, :food_review => invalid_attributes}, valid_session
        expect(assigns(:food_review)).to be_a_new(FoodReview)
      end

      it "re-renders the 'new' template" do
        post :create, {:food_item_id=>1, :food_review => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
           hash = {}
           hash[:rating]=3
           hash[:comment]='b'
           hash[:food_item_id]=1 
           hash[:user_id]=1
           return hash
      }

      it "assigns the requested food_review as @food_review" do
        food_review = FoodReview.create! valid_attributes
        put :update, {:food_item_id=>1, :id => food_review.to_param, :food_review => new_attributes}, valid_session
        expect(assigns(:food_review)).to eq(food_review)
      end

      it "redirects to the food item page" do
        food_review = FoodReview.create! valid_attributes
        put :update, {:food_item_id=>1, :id => food_review.to_param, :food_review => new_attributes}, valid_session
        expect(response).to redirect_to("/food_items/1/food_reviews")
      end
    end

    context "with invalid params" do
      
      let(:new_attributes) {
           hash = {}
           hash[:rating]=-1
           hash[:comment]='b'
           hash[:food_item_id]=1 
           hash[:user_id]=1
           return hash
      }

      it "assigns the food_review as @food_review" do
        food_review = FoodReview.create! valid_attributes
        put :update, {:food_item_id=>1, :id => food_review.to_param, :food_review => new_attributes}, valid_session
        expect(assigns(:food_review)).to eq(food_review)
      end

      it "re-renders the 'edit' template" do
        food_review = FoodReview.create! valid_attributes
        put :update, {:food_item_id=>1, :id => food_review.to_param, :food_review => new_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested food_review" do
      food_review = FoodReview.create! valid_attributes
      expect {
        delete :destroy, {:food_item_id=>1, :id => food_review.to_param}, valid_session
      }.to change(FoodReview, :count).by(-1)
    end

    it "redirects to the food_reviews list" do
      food_review = FoodReview.create! valid_attributes
      delete :destroy, {:food_item_id=>1, :id => food_review.to_param}, valid_session
      expect(response).to redirect_to("/food_items/1/food_reviews")
    end
  end

end
