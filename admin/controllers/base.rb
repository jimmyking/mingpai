Mingpai::Admin.controllers :base do
  get :index, :map => "/" do
    @current_account.my_menus.each do |item|
      puts item[:root].name
    end
    render "base/index"
  end
end
