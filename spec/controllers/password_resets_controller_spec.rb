require 'rails_helper'
require 'spec_helper'
RSpec.describe PasswordResetsController, type: :controller do
    
    before :each do 
        Mail.defaults do
            delivery_method :test
        end
    end
    
    describe "GET new" do
        it "renders the new template" do
            get :new
            expect(response).to render_template('new')
        end
    end
    
    describe "POST create" do
        context "with a valid user and email" do
            let(:user){create(:user)}
            it "finds the user" do
                expect(User).to receive(:find_by).with(email: user.email).and_return(user)
                post :create, email: user.email
            end
            it "generate a new password reset token" do 
                expect{post :create, email: user.email; user.reload}.to change(user, :password_reset_token)
            end
            it 'should call mailer' do
                expect{post :create, email: user.email}.to change(Mail::TestMailer.deliveries, :size).by(0)
            end
            it 'returns an error with an unverified user' do
                user.verification_code = "test"
                user.save(:validate => false)
                post :create, email: user.email
                expect(flash[:notice]).to eq("You have not yet confirmed your account. Please do so before resetting your password.")
            end
            it "sets the flash success message" do
                post :create, email: user.email
                expect(flash[:notice]).to match(/check your email/)
            end
        end
        
        context "with no user found" do
            it "renders the new page" do
                post :create, email: 'none@found.com'
                expect(response).to render_template('new')
            end
        
            it "sets the flash message" do
                post :create, email: 'none@found,com'
                expect(flash[:notice]).to match(/not found/)
            end
        end
    end
    
    describe "Get edit " do
        context "with a valid password_reset_token" do
            let(:user){create(:user)}
            before {user.generate_password_reset_token!}
            
            it "renders the edit template" do
                get :edit, id: user.password_reset_token
                expect(response).to render_template('edit')
            end
            
            it "assigns a @user " do
                get :edit, id: user.password_reset_token
                expect(assigns(:user)).to eq(user)
            end
        end
        
        context "with non password_reset_token" do
            it "renders the 302 page" do
                get :edit, id: 'nonfound'
                expect(response).to redirect_to(root_path)
            end
        end
    end
    
    describe "PATCH update" do
        context "with no token found" do
            it "render the edit page" do
                patch :update, id: 'notfound', user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                expect(response).to redirect_to(root_path)
            end
            
            it "sets the flash message" do
                patch :update, id: 'notfound', user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                expect(flash[:notice]).to match(/not found/)
            end
        end
        
        context "with a valid token" do
            let(:user){create(:user)}
            before {user.generate_password_reset_token!}
            
            it "updates the user password" do 
                digest = user.password_digest
                patch :update, id: user.password_reset_token, user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                user.reload
                expect(user.password_digest).to_not eq(digest)
            end
            
            it "clears the password_reset_token" do
                patch :update, id: user.password_reset_token, user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                user.reload
                expect(user.password_reset_token).to be_blank
            end
            
            it "sets the session[:user_id] to the user id" do
                patch :update, id: user.password_reset_token, user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                expect(session[:user_id]).to eq(user.id)
            end
            
            it "sets the flash[:notice] message" do
                patch :update, id: user.password_reset_token, user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                expect(flash[:notice]).to match(/Password updated/)
            end
            
            it "redirect to the home page" do
                patch :update, id: user.password_reset_token, user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
                expect(response).to redirect_to(root_path)
            end
        end
    end        

end
