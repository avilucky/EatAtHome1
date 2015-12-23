require 'spec_helper'
require 'rails_helper'

describe UserMailer do
    before :each do 
        Mail.defaults do
            delivery_method :test
        end
    end
    describe "send welcome mail" do
        it 'should call deliver' do
            expect(Mail).to receive(:deliver)
            UserMailer.send_welcome(nil, nil)
        end
        it 'should call configure' do 
            expect(UserMailer).to receive(:configure)

            allow(Mail).to receive(:deliver)
            UserMailer.send_welcome(nil, nil)
        end
        it 'should send mail to given address' do
            allow(UserMailer).to receive(:configure)
            u = User.new({:email => "test@test.com", :first_name => "test"})
            UserMailer.send_welcome(u, "test url")
            expect(Mail::TestMailer.deliveries.length).to eq(1)
            expect(Mail::TestMailer.deliveries.first.to).to eq(["test@test.com"])
        end
    end
    
    
    describe "send accept/reject order_detail mail" do
        it 'should call deliver' do
            expect(Mail).to receive(:deliver)
            UserMailer.send_order_details(nil, nil)
        end
        it 'should call configure' do 
            expect(UserMailer).to receive(:configure)

            allow(Mail).to receive(:deliver)
            UserMailer.send_order_details(nil, nil)
        end
        it 'should send mail to given address' do
            allow(UserMailer).to receive(:configure)
            u = User.new({:email => "test@test.com", :first_name => "test"})
            f = u.food_items.build({:name => "test"})
            UserMailer.send_order_details(f, "test url")
            expect(Mail::TestMailer.deliveries.length).to eq(1)
            expect(Mail::TestMailer.deliveries.first.to).to eq(["test@test.com"])
        end
    end
    
    
    describe "send password reset email" do
        it 'should call deliver' do
            expect(Mail).to receive(:deliver)
            UserMailer.password_reset(nil, nil)
        end
        
        it 'should call configure' do 
            expect(UserMailer).to receive(:configure)
            allow(Mail).to receive(:deliver)
            UserMailer.password_reset(nil, nil)
        end
        
        it 'should send mail to given address' do
            allow(UserMailer).to receive(:configure)
            u = User.new({:email => "test@test.com", :first_name => "test"})
            UserMailer.password_reset(u, 'test_url')
            expect(Mail::TestMailer.deliveries.length).to eq(1)
            expect(Mail::TestMailer.deliveries.first.to).to eq(["test@test.com"])
        end
    end
end