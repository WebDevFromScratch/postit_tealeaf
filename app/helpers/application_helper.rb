module ApplicationHelper
  def fix_url(obj)
    obj.url.start_with?("http://") ? obj.url : "http://#{obj.url}"
  end

  def pretty_date_time(obj)
    "#{obj.created_at.to_formatted_s(:long)} UTC"
  end
end
