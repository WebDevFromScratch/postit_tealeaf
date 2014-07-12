module ApplicationHelper
  def fix_url(obj)
    obj.url.start_with?("http://") ? obj.url : "http://#{obj.url}"
  end

  def pretty_date_time(dt)
    if logged_in? && !current_user.timezone.blank?
      dt = dt.in_time_zone(current_user.timezone)
    end
    #"#{dt.to_formatted_s(:long)} UTC" #this was my initial approach
    dt.strftime("%m/%d/%Y %l:%M%P %Z") #this is just time formatting, syntax
                                        #is given in the method docs
                                        #(check Time in Ruby/Rails)
  end

  
end
