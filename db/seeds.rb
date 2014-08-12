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
menu7 = Menu.create(:name => "需求类型管理",:url => "/types", :parent_id => menu5.id)
menu8 = Menu.create(:name => "订单管理")
menu9 = Menu.create(:name => "新增订单",:url => "/orders", :parent_id => menu8.id)

role = Role.new(:name => "管理员")
role.menus = [menu2,menu3,menu4,menu6,menu7,menu9]
role.save



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
