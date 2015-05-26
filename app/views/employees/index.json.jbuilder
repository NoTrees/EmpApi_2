json.array!(@employees) do |employee|
  json.extract! employee, :id, :name, :division, :address, :is_admin
  json.url employee_url(employee, format: :json)
end
