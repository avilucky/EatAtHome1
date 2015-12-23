require 'spec_helper'
require 'rails_helper'
require 'states'
def test_hash
    hash = {}
    for key in [:first_name, :last_name, :email, :password, :address_one, 
    :address_two, :apt_num, :city, :state, :zip] do
        hash[key] = 'a'
    end
    hash[:last_name] = 'b'
    hash[:password] = 'c'
    hash[:id] = 101
    hash[:email] = "test@email.com"
    hash[:zip] = '50325'
    return hash
end

def get_test_user
    u = User.new(test_hash)
    return u
end
def unverified_user
    u = get_test_user
    u.verification_code = "testvercode"
    return u
end

describe SessionsController do
    describe "validate signup params" do
        it 'should return an error message for mismatched passwords' do
            hash = test_hash
            hash[:password] = "a"
            hash[:password_confirm] = "b"
            ans = SessionsController.validate_signup_params(hash)
            expect(ans!=nil).to be_truthy
            expect(ans.include?("passwords")).to be_truthy
        end
        it 'should validate with a valid hash' do
            hash = test_hash
            hash[:password_confirm] = 'c'
            expect(SessionsController.validate_signup_params(hash)).to eq(nil)
        end
    end
    describe "login" do
        
        it "should select the login form for rendering on invalid email" do
            allow(User).to receive(:find_by_email).and_return(nil)
            post :login, {:sessions => {:email => "", :password => ""}}
            expect(response).to redirect_to(login_form_path)
        end
        it "should redirect to the home page when a user has not verified their address" do
            allow(User).to receive(:find_by_email).and_return(unverified_user)
            post :login, {:sessions => {:email => "", :password => unverified_user.password}}
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq("Your email address has not been confirmed. Please follow the instructions in the welcome email you received to activate your account.")
        end
        it "should select the home page for rendering on valid" do
            expect(User).to receive(:find_by_email).and_return(test_user)
            post :login, {:sessions => {:email => "", :password => "c"}}
            expect(response).to redirect_to(root_path)
        end
        it "should select the login form for rendering on invalid password" do
            expect(User).to receive(:find_by_email).and_return(test_user)
            post :login, {:sessions => {:email => "", :password => ""}}
            expect(response).to redirect_to(login_form_path)
        end
        it "should add the correct user to the session variable" do
            allow(User).to receive(:find_by_email).and_return(test_user)
            post :login, {:sessions => {:email => "", :password => test_user.password}}
            expect(response).to redirect_to(root_path)
            expect(session[:user_id]).to eq(101)
        end
    end
    describe "logout" do
        it "should redirect to the home page" do 
            post :destroy, {}
            expect(response).to redirect_to(root_path)
        end
        it "should clear the session user id" do
            session[:user_id] = 1
            post :destroy, {}
            expect(!session.has_key?(:user_id)).to be_truthy
        end
    end
    describe "signup confirm" do
        before(:each) do
            @unverified = unverified_user
            @unverified.save(:validate => false)
        end
        it "should clear user verification code" do
            get :signup_confirm, {:id => @unverified.verification_code}
            expect(User.find_by_verification_code(@unverified.verification_code)).to eq(nil)
        end
        it "should redirect to the home page" do
            get :signup_confirm, {:id => @unverified.verification_code}
            expect(response).to redirect_to(root_path)
        end
        it "should return an error with a bad verification code" do
            get :signup_confirm, {:id => "fake code"}
            expect(flash[:notice]).to eq("Unknown user verification code. Please confirm that you have visited the URL sent in your welcome email")
        end
    end
    describe "signup" do
        before(:each) do
            allow(UserMailer).to receive(:send_welcome).and_return(nil)
        end
        it "should redirect to the form path on error" do
            allow(SessionsController).to receive(:validate_signup_params).and_return("error message")
            post :signup, {:sessions => {:email => ""}}
            expect(response).to redirect_to(signup_form_path)
        end
        it "should return an error on failure" do
            allow(SessionsController).to receive(:validate_signup_params).and_return("error message")
            post :signup, {:sessions => {:email => ""}}
            expect(flash[:notice]).to eq("error message")
        end
        it "should create a new user with the given parameters" do
            allow(SessionsController).to receive(:validate_signup_params).and_return(nil)
            hash = test_hash
            hash[:password_confirm] = 'c'
            post :signup, {:sessions => hash}
            expect(User.find_by_email("test@email.com")!=nil).to be_truthy
        end
        it "should return errors when saving fails" do 
            allow(SessionsController).to receive(:validate_signup_params).and_return(nil)
            hash = test_hash
            hash.delete(:email)
            hash[:password_confirm] = 'c'
            post :signup, {:sessions => hash}
            expect(assigns(:errors).length).to eq(2)
        end
        it "should redirect to the home page on success" do
            allow(SessionsController).to receive(:validate_signup_params).and_return(nil)
            hash = test_hash
            hash[:password_confirm] = 'c'
            post :signup, {:sessions => hash}
            expect(response).to redirect_to(root_path)
        end
    end
    describe "signup form" do
        it "assigns a list of states to the states variable" do
            get :signup_form
            expect(assigns(:states)).to eq StatesHelper.states
        end
        it "assigns the empty hash to defaults whenever they are not set" do
            get :signup_form
            expect(assigns(:defaults)).to eq({})
        end
    end
    describe "login form" do
        it "redirects home if logged in" do
            get_test_user.save(:validate => false)
            session[:user_id] = 101
            get :login_form
            expect(response).to redirect_to(root_path)
        end
        it "renders login form" do
            get :login_form
            expect(response.status).to eq(200)
        end
    end
   
end