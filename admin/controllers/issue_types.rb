Mingpai::Admin.controllers :issue_types do
  get :index do
    @title = "Issue_types"
    @issue_types = IssueType.all
    render 'issue_types/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'issue_type')
    @issue_type = IssueType.new
    render 'issue_types/new'
  end

  post :create do
    @issue_type = IssueType.new(params[:issue_type])
    if @issue_type.save
      @title = pat(:create_title, :model => "issue_type #{@issue_type.id}")
      flash[:success] = pat(:create_success, :model => 'IssueType')
      params[:save_and_continue] ? redirect(url(:issue_types, :index)) : redirect(url(:issue_types, :edit, :id => @issue_type.id))
    else
      @title = pat(:create_title, :model => 'issue_type')
      flash.now[:error] = pat(:create_error, :model => 'issue_type')
      render 'issue_types/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "issue_type #{params[:id]}")
    @issue_type = IssueType.find(params[:id])
    if @issue_type
      render 'issue_types/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'issue_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "issue_type #{params[:id]}")
    @issue_type = IssueType.find(params[:id])
    if @issue_type
      if @issue_type.update_attributes(params[:issue_type])
        flash[:success] = pat(:update_success, :model => 'Issue_type', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:issue_types, :index)) :
          redirect(url(:issue_types, :edit, :id => @issue_type.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'issue_type')
        render 'issue_types/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'issue_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Issue_types"
    issue_type = IssueType.find(params[:id])
    if issue_type
      order_count = Order.where("issue_type_id = ? ",params[:id]).count
      if order_count <= 0
        if issue_type.destroy
          flash[:success] = pat(:delete_success, :model => 'Issue_type', :id => "#{params[:id]}")
        else
          flash[:error] = pat(:delete_error, :model => 'issue_type')
        end
      else
        flash[:error] = "当前存在对应类型的订单，无法删除"
      end
      
      redirect url(:issue_types, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'issue_type', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Issue_types"
    unless params[:issue_type_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'issue_type')
      redirect(url(:issue_types, :index))
    end
    ids = params[:issue_type_ids].split(',').map(&:strip)
    issue_types = IssueType.find(ids)
    
    if IssueType.destroy issue_types
    
      flash[:success] = pat(:destroy_many_success, :model => 'Issue_types', :ids => "#{ids.to_sentence}")
    end
    redirect url(:issue_types, :index)
  end
end
