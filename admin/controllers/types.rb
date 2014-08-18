Mingpai::Admin.controllers :types do
  get :index do
    @title = "Types"
    @types = Type.all
    render 'types/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'type')
    @type = Type.new
    @all_colors = [['red',1],['green',2],['blue',3],['yellow',4]]
    render 'types/new'
  end

  post :create do
    @type = Type.new(params[:type])
    if @type.save
      @title = pat(:create_title, :model => "type #{@type.id}")
      flash[:success] = pat(:create_success, :model => 'Type')
      params[:save_and_continue] ? redirect(url(:types, :index)) : redirect(url(:types, :edit, :id => @type.id))
    else
      @title = pat(:create_title, :model => 'type')
      flash.now[:error] = pat(:create_error, :model => 'type')
      render 'types/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "type #{params[:id]}")
    @type = Type.find(params[:id])
    if @type
      @all_colors = [['red',1],['green',2],['blue',3],['yellow',4]]
      render 'types/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'type', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "type #{params[:id]}")
    @type = Type.find(params[:id])
    if @type
      if @type.update_attributes(params[:type])
        flash[:success] = pat(:update_success, :model => 'Type', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:types, :index)) :
          redirect(url(:types, :edit, :id => @type.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'type')
        render 'types/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Types"
    type = Type.find(params[:id])
    if type
      order_count = Order.where("type_id = ?",params[:id]).count
      if order_count == 0
        if type.destroy
          flash[:success] = pat(:delete_success, :model => 'Type', :id => "#{params[:id]}")
        else
          flash[:error] = pat(:delete_error, :model => 'type')
        end
      else
        flash[:error] = "已存在有对应类型的订单，无法删除"
      end
      
      redirect url(:types, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Types"
    unless params[:type_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'type')
      redirect(url(:types, :index))
    end
    ids = params[:type_ids].split(',').map(&:strip)
    types = Type.find(ids)
    
    if Type.destroy types
    
      flash[:success] = pat(:destroy_many_success, :model => 'Types', :ids => "#{ids.to_sentence}")
    end
    redirect url(:types, :index)
  end
end
