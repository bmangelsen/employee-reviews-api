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

  # def test_can_delete_employee
  #   employee = delete "/delete_employee", name: "Dan"
  #   assert employee.ok?
  #   
  # end


  def test_declares_its_name
    skip
    response = get "/"
    assert response.ok?
    assert_equal "I am Groot", response.body
  end

  def test_it_handles_and_returns_json
    skip
    hash = { name: "bob" }
    response = post("/api/echo", hash.to_json, { "CONTENT_TYPE" => "application/json" })

    assert response.ok?
    payload = JSON.parse(response.body)
    assert_equal({ "name" => "bob" }, payload)
  end
end
