module Helpers
  def json(content)
    JSON.parse(content, symbolize_names: true)
  end
end