json.configurations @configurations do |configuration|
  json.id configuration.id
  json.name configuration.name
  json.desc configuration.description
  json.url configuration.url
end