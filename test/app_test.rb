require "./test/test_helper"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def setup
    Employee.delete_all
    Employee.create name: "Dan", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00
    Employee.create name: "Frank", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00
    Employee.create name: "Bob", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00
  end

  def test_can_create_employee
    new_employee = post "/create_employee", { name: "Dan", email: "d@mail.com", phone: "914-555-5555", salary: 50000.00 }.to_json
    assert new_employee.ok?
    assert_equal "Dan", Employee.last.name
  end

  def test_can_list_all_employees
    list = get "/all_employees"
    assert list.ok?
    employee_info = JSON.parse(list.body)
    assert_equal "Dan", employee_info.first["name"]
    assert_equal "Bob", employee_info.last["name"]
    assert_equal 3, employee_info.count
  end

  def test_can_search_employee_by_name
    employee = get "/search_employee", name: "Dan"
    assert employee.ok?
    info = JSON.parse(employee.body)
    assert_equal Employee.first.name, info[0]["name"]
  end

  def test_can_delete_employee
    delete "/delete_employee", name: "Dan"
    assert_equal 2, Employee.all.count
    assert Employee.where(name: "Dan").empty?
  end

  def test_can_change_employee_name
    patch "/change_employee_name", name: "Dan", new_name: "Jill"
    binding.pry
    assert Employee.where(name: "Dan").empty?
    assert Employee.where(name: "Jill")
  end

end
