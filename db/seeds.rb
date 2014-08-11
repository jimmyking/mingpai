# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#

menu1 = Menu.create(:name => "系统管理")
menu2 = Menu.create(:name => "用户管理", :parent_id => menu1.id)
menu3 = Menu.create(:name => "角色管理", :parent_id => menu1.id)
menu4 = Menu.create(:name => "菜单管理", :parent_id => menu1.id)

role = Role.new(:name => "管理员")
role.menus = [menu1,menu2,menu3,menu4]
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
