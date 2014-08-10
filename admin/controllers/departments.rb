Mingpai::Admin.controllers :departments, :parent => :game do

  before do
    @game = Game.find(params[:game_id])
  end

  get :index do
    @title = "Departments"
    @departments = Department.all
    render 'departments/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'department')
    @department = Department.new
    render 'departments/new'
  end

  post :create do
    @department = Department.new(params[:department])
    if @department.save
      @title = pat(:create_title, :model => "department #{@department.id}")
      flash[:success] = pat(:create_success, :model => 'Department')
      params[:save_and_continue] ? redirect(url(:departments, :index, :game_id => @game.id)) : redirect(url(:departments, :edit, :game_id => @game.id, :id => @department.id))
    else
      @title = pat(:create_title, :model => 'department')
      flash.now[:error] = pat(:create_error, :model => 'department')
      render 'departments/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "department #{params[:id]}")
    @department = Department.find(params[:id])
    if @department
      render 'departments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'department', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "department #{params[:id]}")
    @department = Department.find(params[:id])
    if @department
      if @department.update_attributes(params[:department])
        flash[:success] = pat(:update_success, :model => 'Department', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:departments, :index, :game_id => @game.id)) :
          redirect(url(:departments, :edit, :game_id => @game.id, :id => @department.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'department')
        render 'departments/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'department', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Departments"
    department = Department.find(params[:id])
    if department
      if department.destroy
        flash[:success] = pat(:delete_success, :model => 'Department', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'department')
      end
      redirect url(:departments, :index, :game_id => @game.id)
    else
      flash[:warning] = pat(:delete_warning, :model => 'department', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Departments"
    unless params[:department_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'department')
      redirect(url(:departments, :index, :game_id => @game.id))
    end
    ids = params[:department_ids].split(',').map(&:strip)
    departments = Department.find(ids)
    
    if Department.destroy departments
    
      flash[:success] = pat(:destroy_many_success, :model => 'Departments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:departments, :index, :game_id => @game.id)
  end
end
