Mingpai::Admin.controllers :roles do
  get :index do
    @title = "Roles"
    @roles = Role.all
    render 'roles/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'role')
    @role = Role.new
    render 'roles/new'
  end

  post :create do
    @role = Role.new(params[:role])
    if @role.save
      @title = pat(:create_title, :model => "role #{@role.id}")
      flash[:success] = pat(:create_success, :model => 'Role')
      params[:save_and_continue] ? redirect(url(:roles, :index)) : redirect(url(:roles, :edit, :id => @role.id))
    else
      @title = pat(:create_title, :model => 'role')
      flash.now[:error] = pat(:create_error, :model => 'role')
      render 'roles/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "role #{params[:id]}")
    @role = Role.find(params[:id])
    if @role
      render 'roles/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'role', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "role #{params[:id]}")
    @role = Role.find(params[:id])
    if @role
      if @role.update_attributes(params[:role])
        flash[:success] = pat(:update_success, :model => 'Role', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:roles, :index)) :
          redirect(url(:roles, :edit, :id => @role.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'role')
        render 'roles/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'role', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Roles"
    role = Role.find(params[:id])
    if role
      if role.destroy
        flash[:success] = pat(:delete_success, :model => 'Role', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'role')
      end
      redirect url(:roles, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'role', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Roles"
    unless params[:role_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'role')
      redirect(url(:roles, :index))
    end
    ids = params[:role_ids].split(',').map(&:strip)
    roles = Role.find(ids)
    
    if Role.destroy roles
    
      flash[:success] = pat(:destroy_many_success, :model => 'Roles', :ids => "#{ids.to_sentence}")
    end
    redirect url(:roles, :index)
  end

  get :roles_menus, :with => :id do
    @role = Role.find(params[:id])
    @all_sub_menus = Menu.sub_scope.order("parent_id,id")
    @my_menus = @role.menus.map { |m| m.id}
    render 'roles/menus'
  end
  
  put :update_menus, :with => :id do
    
    
    
    unless params[:menus_ids]
      flash[:error] = "请给当前角色赋予权限"
      redirect(url(:roles, :roles_menus,:id => params[:id]))
    end
    
    new_menus = params[:menus_ids].map {|m| Menu.find(m)}
    
    role = Role.find(params[:id])
    role.menus = new_menus
    role.save
    flash[:success] = "更新成功"
    redirect(url(:roles, :roles_menus,:id => params[:id]))
    
  end
end
