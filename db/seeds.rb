# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#

menu1 = Menu.create(:name => "系统管理")
menu2 = Menu.create(:name => "用户管理",:url => "/accounts", :parent_id => menu1.id)
menu3 = Menu.create(:name => "角色管理",:url => "/roles", :parent_id => menu1.id)
menu4 = Menu.create(:name => "菜单管理",:url => "/menus", :parent_id => menu1.id)
menu5 = Menu.create(:name => "字典管理")
menu6 = Menu.create(:name => "服务器管理",:url => "/games", :parent_id => menu5.id)
menu7 = Menu.create(:name => "订单类型管理",:url => "/types", :parent_id => menu5.id)
menu8 = Menu.create(:name => "异常类型管理",:url => "/issue_types", :parent_id => menu5.id)
menu9 = Menu.create(:name => "订单管理")
menu10 = Menu.create(:name => "新增订单",:url => "/orders", :parent_id => menu9.id)
menu11 = Menu.create(:name => "订单审核",:url => "/orders/new_orders", :parent_id => menu9.id)
menu12 = Menu.create(:name => "刷怪订单分配",:url => "/order_groups/brush", :parent_id => menu9.id)
menu13 = Menu.create(:name => "任务订单分配",:url => "/order_groups/task", :parent_id => menu9.id)
menu14 = Menu.create(:name => "刷怪团处理",:url => "/order_groups/brush_group", :parent_id => menu9.id)
menu15 = Menu.create(:name => "异常订单管理",:url => "/orders/issue_orders", :parent_id => menu9.id)
menu16 = Menu.create(:name => "团队完成列表",:url => "/orders/grouped_orders", :parent_id => menu9.id)
menu17 = Menu.create(:name => "订单查询",:url => "/orders/search", :parent_id => menu9.id)


role = Role.new(:name => "管理员")
role.menus = [menu2,menu3,menu4,menu6,menu7,menu8,menu10,menu11,menu12,menu13,menu14,menu15,menu16,menu17]
role.save

game = Game.create(:name => "剑网三")
dep1 = Department.create(:name => "双梦",:game_id => game.id)
dep2 = Department.create(:name => "幽月",:game_id => game.id)

type = Type.create(:name => "刷怪")
step1 = Step.create(:name => "20级别", :level => 20, :type_id => type.id)
step2 = Step.create(:name => "80级别", :level => 80, :type_id => type.id) 

Status.create(:name => "新订单")
Status.create(:name => "已审核")
Status.create(:name => "已分团")
Status.create(:name => "已开团")
Status.create(:name => "团结束")
Status.create(:name => "已完成")





email     = shell.ask "Which email do you want use for logging into admin?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => :admin, :role_id => role.id)

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""
