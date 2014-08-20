Mingpai::Admin.controllers :order_groups do

  #服务器 订单 归类列表
  get :brush do
    @group_result = ActiveRecord::Base.connection.
      execute("SELECT count(*) as num,t2.`name`,t2.`id` FROM `orders` t1,`departments` t2 where t1.`department_id`=t2.`id` AND t1.`order_status_id`=2 AND t1.`type_id` = 1  GROUP BY department_id")
    render 'order_groups/brush'
  end
  
  #订单列表
  get :brush_department, :with => :department_id do
    @orders = Order.where("order_status_id = ? and department_id = ? and type_id = ? ",2,params[:department_id],1)
    @department = Department.find(params[:department_id])
    department_ing = OrderGroup.where("status_id in (3,4) and department_id = ? and type_id = 1",params[:department_id])
    @dept_array = department_ing.map{|d| ["#{d.name}#{d.department.name}#{d.no}团",d.id]}
    render 'order_groups/brush_department'
  end
  
  #订单分组
  post :brush_distribution do
    department_id = params[:department_id]
    order_ids = params[:order_ids]
    order_id_array = order_ids.split(",")
    group_date = params[:group_date]
    
    @group = OrderGroup.new(:name => group_date,:department_id => department_id, :type_id => 1)
    
    if @group.save
      OrderGroupProcess.create({"group_id" => @group.id, "operator_id" => current_account.id, "remark" => "创建了新的团队"})
      Order.find(order_id_array).each do |o|
        o.update_attributes({"order_group_id" => @group.id,"order_status_id" => 3})
        OrderProcess.create({"order_id" => o.id, "operator_id" => current_account.id, "remark" => "将订单分入#{@group.name}#{@group.department.name}#{@group.no}团"})
      end
      flash[:success] = "分组成功"
    else
      flash[:error] = "分组失败"
      
    end
    redirect url(:order_groups,:brush_department,:department_id => department_id)
    
  end
  
  post :goto_group do
    order_group = OrderGroup.find(params[:group_id])
    order = Order.find(params[:order_id])
    
    order.status = order_group.status
    order.order_group = order_group
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "将订单分入#{order_group.name}#{order_group.department.name}#{order_group.no}团"})
      
      flash[:success] = "分组成功"
    else
      flash[:error] = "分组失败"
    end
    redirect url(:order_groups,:brush_department,:department_id => params[:group_id])
  end
  
  #团队列表
  get :brush_group do
    @groups = OrderGroup.where("type_id = ? and status_id in (3,4)",1)
    
    @groups.each do |g|
      if g.now_level
        g.progress= g.now_level.to_f/g.orders.maximum('end_level')*100
      else
        g.progress= 0
      end
    end
    
    render 'order_groups/brush_group'
  end
  
  #团队详情
  get :brush_group_view, :with => :id do
    @group = OrderGroup.find(params[:id])
    @orders = @group.orders

    @type = @group.type

    start_level = @orders.minimum('now_level')
    end_level = @orders.maximum('end_level')
    level_range = start_level...end_level
    @selectable_level = []
    level_range.to_a.each do |i|
      @selectable_level.push [i,i]
    end

    render 'order_groups/brush_group_view'
  end
  
  put :update_level, :with => :id do
    group = OrderGroup.find(params[:id])
    group.now_level = params[:level].to_i
    if group.save
      OrderGroupProcess.create({"group_id" => group.id, "operator_id" => current_account.id, "remark" => "更新团队等级至#{group.now_level}"})
      
      group.orders.each do |o|
        if o.now_level < params[:level].to_i
          o.now_level = params[:level].to_i
          o.save
          OrderProcess.create({"order_id" => o.id, "operator_id" => current_account.id, "remark" => "将订单等级更新为#{o.now_level}"})
          
        end
      end
      flash[:success] = "分组成功"
    else
      flash[:error] = "更新成功"
    end
    redirect url(:order_groups, :brush_group_view, :id => params[:id])
  end

  put :update_step, :with => :id do
    group = OrderGroup.find(params[:id])
    task = OrderGroupTask.new(:group_id => params[:id],
                              :step_id  => params[:step_id],
                              :oper_id => current_account.id)
    step = Step.find(params[:step_id])
                                                        
    if task.save
      group.orders.each do |o|
        ot = OrderTask.new(:group_id => params[:id],
                                     :order_id => o.id,
                                     :step_id  => params[:step_id],
                                     :oper_id => current_account.id)
        ot.save
        OrderProcess.create({"order_id" => o.id, "operator_id" => current_account.id, "remark" => "完成#{step.name}"})
        
      end
      flash[:success] = "成功"
    else
      flash[:error] = "更新成功"
    end
    redirect url(:order_groups, :brush_group_view, :id => params[:id])
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  put :update_status, :with => :id do
    group = OrderGroup.find(params[:id])
    status = Status.find(params[:status_id])
    group.status = status
    if group.status == 4
      group.now_level = 0
    end
    if group.save
      OrderGroupProcess.create({"group_id" => group.id, "operator_id" => current_account.id, "remark" => "更新团队状态为#{status.name}"})
      
      group.orders.each do |o|
        o.status=Status.find(params[:status_id])
        o.save
        OrderProcess.create({"order_id" => o.id, "operator_id" => current_account.id, "remark" => "更新订单状态为#{status.name}"})
        
      end
    end
    redirect url(:order_groups, :brush_group)
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
