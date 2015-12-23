class OrdersController < ApplicationController
    
  
  before_filter :set_current_user
  before_filter :assert_login, :only => [:order, :show]

  def order_params
    params.require(:order).permit(:food_item_portion, :quantity)
  end
  
  def show
    @order= Order.find(params[:id])
  end

  def order
    @food_item_portion = FoodItemPortion.find(order_params[:food_item_portion])
    @food_item = @food_item_portion.food_item
    @user = get_current_user
    if !@food_item.availability or !@user.availability
      flash[:notice] = "Sorry, this item is current unavailable"
      redirect_to root_path
      return
    end
    @order = @food_item_portion.orders.build(:customer_id => @user.id, :seller_id => @food_item.user.id, :price_per_portion => @food_item_portion.price, :quantity => order_params[:quantity], :status => "pending")
    if not @order.save
        @errors = @order.errors.full_messages
        @qty = order_params[:quantity]
        render :template=> "food_items/show", :locals => { :id => @food_item.id }
        return
    end
    flash[:notice] = "Order placed successfully"
    url = request.base_url+"/orders/"+@order.id.to_s
    UserMailer.send_order_details(@food_item, url)
    render 'show', :id => @order.id
    return 
  end
  
  def change_status
    @order = Order.find(params[:id])
      if(@order.status == "pending")
        if("accepted" == params[:status])
          @order.update_attributes(:status => params[:status], :accepted_time => Time.now)
        else
          @order.update_attributes(:status => params[:status])
        end
        flash[:notice] = "Order "+@order.status.to_s+"."
      else
        flash[:notice] = "Order not in pending state."
      end
      redirect_to order_path(@order)
  end
  
end
