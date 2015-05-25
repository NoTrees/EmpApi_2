json.array!(@work_times) do |work_time|
  json.extract! @work_times, :id, :employee_id, :time_of_scan, :time_flag, :work_date
  json.url work_times_url(work_time, format: :json)
end
