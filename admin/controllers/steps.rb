Mingpai::Admin.controllers :steps, :parent => :type do
  before { 
    @type = Type.find params[:type_id]
   }

  get :index do
    @title = "Steps"
    @type_id = params[:type_id]
    @steps = @type.steps
    @steps ||= []
    render 'steps/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'step')
    @step = Step.new
    render 'steps/new'
  end

  post :create do
    @step = Step.new(params[:step])
    @step.type= @type
    if @step.save
      @title = pat(:create_title, :model => "step #{@step.id}")
      flash[:success] = pat(:create_success, :model => 'Step')
      params[:save_and_continue] ? redirect(url(:steps, :index, :type_id => @type.id)) : redirect(url(:steps, :edit, :type_id => @type.id, :id => @step.id))
    else
      @title = pat(:create_title, :model => 'step')
      flash.now[:error] = pat(:create_error, :model => 'step')
      render 'steps/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "step #{params[:id]}")
    @step = Step.find(params[:id])
    if @step
      render 'steps/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'step', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "step #{params[:id]}")
    @step = Step.find(params[:id])
    if @step
      if @step.update_attributes(params[:step])
        flash[:success] = pat(:update_success, :model => 'Step', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:steps, :index, :type_id => @type.id)) :
          redirect(url(:steps, :edit, :type_id => @type.id, :id => @step.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'step')
        render 'steps/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'step', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Steps"
    step = Step.find(params[:id])
    if step
      group_task_count = OrderGroupTask.where("step_id = ? ",params[:id]).count
      order_task_count = OrderTask.where("step_id = ? ",params[:id]).count
      if group_task_count <=0 || order_task_count <0
        if step.destroy
          flash[:success] = pat(:delete_success, :model => 'Step', :id => "#{params[:id]}")
        else
          flash[:error] = pat(:delete_error, :model => 'step')
        end
      else
        flash[:error] ="该任务已存在对应的关联订单，无法删除"
      end
      redirect url(:steps, :index, :type_id => @type.id)
    else
      flash[:warning] = pat(:delete_warning, :model => 'step', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Steps"
    unless params[:step_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'step')
      redirect(url(:steps, :index, :type_id => @type.id))
    end
    ids = params[:step_ids].split(',').map(&:strip)
    steps = Step.find(ids)
    
    if Step.destroy steps
    
      flash[:success] = pat(:destroy_many_success, :model => 'Steps', :ids => "#{ids.to_sentence}")
    end
    redirect url(:steps, :index, :type_id => @type.id)
  end



  
end
