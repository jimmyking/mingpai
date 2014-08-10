Mingpai::Admin.controllers :games do
  get :index do
    @title = "Games"
    @games = Game.all
    render 'games/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'game')
    @game = Game.new
    render 'games/new'
  end

  post :create do
    @game = Game.new(params[:game])
    if @game.save
      @title = pat(:create_title, :model => "game #{@game.id}")
      flash[:success] = pat(:create_success, :model => 'Game')
      params[:save_and_continue] ? redirect(url(:games, :index)) : redirect(url(:games, :edit, :id => @game.id))
    else
      @title = pat(:create_title, :model => 'game')
      flash.now[:error] = pat(:create_error, :model => 'game')
      render 'games/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "game #{params[:id]}")
    @game = Game.find(params[:id])
    if @game
      render 'games/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'game', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "game #{params[:id]}")
    @game = Game.find(params[:id])
    if @game
      if @game.update_attributes(params[:game])
        flash[:success] = pat(:update_success, :model => 'Game', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:games, :index)) :
          redirect(url(:games, :edit, :id => @game.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'game')
        render 'games/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'game', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Games"
    game = Game.find(params[:id])
    if game
      if game.destroy
        flash[:success] = pat(:delete_success, :model => 'Game', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'game')
      end
      redirect url(:games, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'game', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Games"
    unless params[:game_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'game')
      redirect(url(:games, :index))
    end
    ids = params[:game_ids].split(',').map(&:strip)
    games = Game.find(ids)
    
    if Game.destroy games
    
      flash[:success] = pat(:destroy_many_success, :model => 'Games', :ids => "#{ids.to_sentence}")
    end
    redirect url(:games, :index)
  end
end
