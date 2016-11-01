require_relative "dependencies"

class App < Sinatra::Base

  post "/create_employee" do
    text = request.body.read
    unless text.empty?
      post_hash = JSON.parse(text)
      params.merge!(post_hash)
    end
    content_type("application/json")
    Employee.create!(name: params["name"], email: params["email"], phone: params["phone"], salary: params["salary"])
  end

  get "/all_employees" do
    Employee.all.to_json
  end

  get "/search_employee" do
    Employee.where(name: params["name"]).to_json
  end

  delete "/delete_employee" do
    Employee.where(name: params["name"]).delete_all
  end

  patch "/change_employee_name" do
    Employee.find_by(name: params["name"]).update(name: params["new_name"])
  end

  run! if app_file == $PROGRAM_NAME

end
