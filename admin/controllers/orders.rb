Mingpai::Admin.controllers :orders do
  get :index do
    empty_type = Type.new({:name => ""})
    @types = Type.all.to_a.insert 0, empty_type

    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department

    @issue_types = IssueType.all
    if params[:q]
    else
      params[:q]={}
    end
    params[:q][:order_status_id_eq] = 1

    @orders = Order.search(params[:q]).result
    render 'orders/index'
  end


  get :new do
    @title = pat(:new_title, :model => 'order')
    @departments = Game.first.departments
    @types = Type.all
    @order = Order.new
    render 'orders/new'
  end

  post :create do
    @order = Order.new(params[:order])
    if @order.save
      OrderProcess.create({"order_id" => @order.id, "operator_id" => current_account.id, "remark" => "新增订单"})
      @title = pat(:create_title, :model => "order #{@order.id}")
      flash[:success] = pat(:create_success, :model => 'Order')
      params[:save_and_continue] ? redirect(url(:orders, :index)) : redirect(url(:orders, :edit, :id => @order.id))
    else
      @title = pat(:create_title, :model => 'order')
      @types = Type.all
      flash.now[:error] = pat(:create_error, :model => 'order')
      render 'orders/new'
    end
  end

  get :view, :with => :id do

    @order = Order.find(params[:id])

    if @order
      render 'orders/view'
    else
      flash[:warning] = pat(:create_error, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "order #{params[:id]}")
    @order = Order.find(params[:id])
    @departments = Game.first.departments
    @types = Type.all
    if @order
      render 'orders/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "order #{params[:id]}")
    @order = Order.find(params[:id])
    if @order
      if @order.update_attributes(params[:order])
        OrderProcess.create({"order_id" => @order.id, "operator_id" => current_account.id, "remark" => "修改订单"})
        flash[:success] = pat(:update_success, :model => 'Order', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:orders, :index)) :
          redirect(url(:orders, :edit, :id => @order.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'order')
        render 'orders/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Orders"
    order = Order.find(params[:id])
    if order
      if order.destroy
        flash[:success] = pat(:delete_success, :model => 'Order', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'order')
      end
      redirect url(:orders, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end
  
  
  
  

  delete :destroy_many do
    @title = "Orders"
    unless params[:order_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'order')
      redirect(url(:orders, :index))
    end
    ids = params[:order_ids].split(',').map(&:strip)
    orders = Order.find(ids)

    if Order.destroy orders

      flash[:success] = pat(:destroy_many_success, :model => 'Orders', :ids => "#{ids.to_sentence}")
    end
    redirect url(:orders, :index)
  end

  get :new_orders do
    empty_type = Type.new({:name => ""})
    @types = Type.all.to_a.insert 0, empty_type

    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department

    if params[:q]
    else
      params[:q]={}
    end
    params[:q][:order_status_id_eq] = 1

    @orders = Order.search(params[:q]).result
    @issue_types = IssueType.all
    render 'orders/audit'
  end

  put :audit, :with => :id do
    order = Order.find(params[:id])
    order.status = Status.find(2)
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "审核订单"})
      flash[:success] = "审核成功"
      redirect request.referer
    else
      flash[:error] = "审核失败"
      redirect request.referer
    end
  end

  put :to_issue do
    order = Order.find(params[:model_id])
    order.issue_type = IssueType.find(params[:issus_type])
    order.issue_memo = params[:issus_memo]
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "修改订单为异常订单 备注：#{order.issue_memo}"})
      flash[:success] = "成功"
      redirect request.referer
    else
      flash[:error] = "失败"
      redirect request.referer
    end
  end

  put :un_issue, :with => :id do
    order = Order.find(params[:id])
    order.issue_type = nil
    order.issue_memo = nil
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "解除异常订单"})
      flash[:success] = "成功"
      redirect url(:orders, :issue_orders)
    else
      flash[:error] = "失败"
      redirect url(:orders, :issue_orders)
    end
  end

  get :issue_orders do
    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department
    if params[:q]
    else
      params[:q]={}
    end
    params[:q][:issue_type_id_present] = 1
    @orders = Order.search(params[:q]).result
    render 'orders/issue_orders'
  end

  post :add_process do
    @process = OrderProcess.new(params[:order_process])
    @process.operator = current_account
    if @process.save
      redirect request.referer
    end
  end

  get :grouped_orders do
    empty_type = Type.new({:name => ""})
    @types = Type.all.to_a.insert 0, empty_type

    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department

    if params[:q]
    else
      params[:q]={}
    end
    params[:q][:order_status_id_eq] = 5

    @orders = Order.search(params[:q]).result

    department_ing = OrderGroup.where("status_id in (3,4) and type_id = 1")
    @dept_array = department_ing.map{|d| ["#{d.name}#{d.department.name}#{d.no}团",d.id]}
    render 'orders/grouped_orders'
  end
  
  delete :invalid do
    @title = "Orders"
    order = Order.find(params[:model_id])
    memo = params[:delete_memo]
    order.status = Status.find(7)
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "订单删除 原因:#{memo}"})
      flash[:success] = "成功"
    else
      flash[:error] = "失败"
    end
    redirect request.referer
  end
  
  
  get :invalid_orders do
    empty_type = Type.new({:name => ""})
    @types = Type.all.to_a.insert 0, empty_type

    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department

    if params[:q]
    else
      params[:q]={}
    end
    params[:q][:order_status_id_eq] = 7

    @orders = Order.search(params[:q]).result
    @issue_types = IssueType.all
    render 'orders/invalid'
  end
  
  put :un_invalid, :with => :id do
    order = Order.find(params[:id])
    order.status = Status.find(1)
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "还原订单"})
      flash[:success] = "成功"
    else
      flash[:error] = "失败"
    end
    redirect url(:orders, :invalid_orders)
  end

  put :over, :with => :id do
    order = Order.find(params[:id])
    order.status = Status.find(6)
    if order.save
      OrderProcess.create({"order_id" => order.id, "operator_id" => current_account.id, "remark" => "订单已完成"})
      flash[:success] = "成功"
    else
      flash[:error] = "失败"
    end
    redirect url(:orders, :grouped_orders)
  end


  get :search do
    empty_type = Type.new({:name => ""})
    @types = Type.all.to_a.insert 0, empty_type

    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department

    empty_status = Status.new({:name => ""})
    @statuses = Status.all.to_a.insert 0,empty_status
    if params[:q]
    else
      params[:q]={}
    end

    @orders = Order.search(params[:q]).result

    department_ing = OrderGroup.where("status_id in (3,4) and type_id = 1")
    @dept_array = department_ing.map{|d| ["#{d.name}#{d.department.name}#{d.no}团",d.id]}
    render 'orders/search'
  end


end
