Mingpai::Admin.controllers :orders do
  get :index do
    empty_type = Type.new({:name => ""})
    @types = Type.where("id != 1").to_a.insert 0, empty_type
    
    empty_department = Department.new({:name => ""})
    @departments = Department.all.to_a.insert 0, empty_department
    
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
    @types = Type.where("id != 1")
    @order = Order.new
    render 'orders/new'
  end

  post :create do
    @order = Order.new(params[:order])
    if @order.save
      @title = pat(:create_title, :model => "order #{@order.id}")
      flash[:success] = pat(:create_success, :model => 'Order')
      params[:save_and_continue] ? redirect(url(:orders, :index)) : redirect(url(:orders, :edit, :id => @order.id))
    else
      @title = pat(:create_title, :model => 'order')
      @types = Type.where("id != 1")
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
    @types = Type.where("id != 1")
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
    @types = Type.where("id != 1").to_a.insert 0, empty_type
    
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
      flash[:success] = "审核成功"
      redirect url(:orders, :new_orders)
    else
      flash[:error] = "审核失败"
      redirect url(:orders, :new_orders)
    end
  end

  put :to_issue do
    order = Order.find(params[:model_id])
    order.issue_type = IssueType.find(params[:issus_type])
    order.issue_memo = params[:issus_memo]
    if order.save
      flash[:success] = "成功"
      redirect url(:orders, :new_orders)
    else
      flash[:error] = "失败"
      redirect url(:orders, :new_orders)
    end
  end

  get :distribution do
    @orders = Order.audited
    render 'orders/distribution'
  end
  
  put :distribed do
    puts params[:menu_ids]
    puts params[:group_date]
    @orders = Order.audited
    render 'orders/distribution'
  end
end
