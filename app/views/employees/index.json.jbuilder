json.array!(@employees) do |employee|
  json.extract! employee, :id, :name, :division, :authentication, :address
  json.url employee_url(employee, format: :json)
end
