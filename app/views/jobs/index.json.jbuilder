json.array!(@jobs) do |job|
  json.extract! job, :id, :name, :code, :description, :is_deleted
  json.url job_url(job, format: :json)
end
