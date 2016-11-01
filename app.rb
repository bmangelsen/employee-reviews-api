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
    "Your employees are:"
    Employee.all.to_json
  end

  get "/search_employee" do
    Employee.where(name: params["name"]).to_json
  end

  patch "/employee" do
  end

  delete "/employee" do
  end


  run! if app_file == $PROGRAM_NAME

end
