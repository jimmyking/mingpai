Mingpai::Admin.controllers :order_groups do

  get :brush do
    @group_result = ActiveRecord::Base.connection.
      execute("SELECT count(*) as num,t2.`name`,t2.`id` FROM `orders` t1,`departments` t2 where t1.`department_id`=t2.`id` AND t1.`order_status_id`=2 AND t1.`type_id` = 2  GROUP BY department_id")
    render 'order_groups/brush'
  end
  
  get :brush_department, :with => :department_id do
    @orders = Order.where("order_status_id = ? and department_id = ? and type_id = ? ",2,params[:department_id],2)
    @department = Department.find(params[:department_id])
    render 'order_groups/brush_department'
  end
  
  post :brush_distribution do
    department_id = params[:department_id]
    order_ids = params[:order_ids]
    order_id_array = order_ids.split(",")
    group_date = params[:group_date]
    
    @group = OrderGroup.new(:name => group_date,:department_id => department_id, :type_id => 2)
    
    if @group.save
      Order.find(order_id_array).each do |o|
        o.update_attributes({"order_group_id" => @group.id,"order_status_id" => 3})
      end
      flash[:success] = "分组成功"
      redirect url(:order_groups,:brush)
    else
      flash[:error] = "分组失败"
      redirect url(:order_groups,:brush_department,:department_id => department_id)
    end
    
  end
  
  get :brush_group do
    @grops = OrderGroup.where("type_id = ? ",2)
    render 'order_groups/brush_group'
  end
  
=begin

  get :index do
    @title = "Order_groups"
    @order_groups = OrderGroup.all
    render 'order_groups/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'order_group')
    @order_group = OrderGroup.new
    render 'order_groups/new'
  end

  post :create do
    @order_group = OrderGroup.new(params[:order_group])
    if @order_group.save
      @title = pat(:create_title, :model => "order_group #{@order_group.id}")
      flash[:success] = pat(:create_success, :model => 'OrderGroup')
      params[:save_and_continue] ? redirect(url(:order_groups, :index)) : redirect(url(:order_groups, :edit, :id => @order_group.id))
    else
      @title = pat(:create_title, :model => 'order_group')
      flash.now[:error] = pat(:create_error, :model => 'order_group')
      render 'order_groups/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "order_group #{params[:id]}")
    @order_group = OrderGroup.find(params[:id])
    if @order_group
      render 'order_groups/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'order_group', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "order_group #{params[:id]}")
    @order_group = OrderGroup.find(params[:id])
    if @order_group
      if @order_group.update_attributes(params[:order_group])
        flash[:success] = pat(:update_success, :model => 'Order_group', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:order_groups, :index)) :
          redirect(url(:order_groups, :edit, :id => @order_group.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'order_group')
        render 'order_groups/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'order_group', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Order_groups"
    order_group = OrderGroup.find(params[:id])
    if order_group
      if order_group.destroy
        flash[:success] = pat(:delete_success, :model => 'Order_group', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'order_group')
      end
      redirect url(:order_groups, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'order_group', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Order_groups"
    unless params[:order_group_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'order_group')
      redirect(url(:order_groups, :index))
    end
    ids = params[:order_group_ids].split(',').map(&:strip)
    order_groups = OrderGroup.find(ids)
    
    if OrderGroup.destroy order_groups
    
      flash[:success] = pat(:destroy_many_success, :model => 'Order_groups', :ids => "#{ids.to_sentence}")
    end
    redirect url(:order_groups, :index)
  end
=end
end