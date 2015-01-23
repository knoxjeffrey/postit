module ApplicationHelper
  
  #prepend http:// to url if it is missing
  def url_with_protocol(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end
  
  #modify date presentation.
  #
  #example Jan 4th, 2015 20:52 UTC
  def display_friendly_date(date)
    if logged_in? && !current_user.time_zone.blank?
      date = date.in_time_zone(current_user.time_zone)
    end
    
    date.strftime("%b #{date.day.ordinalize}, %Y %H:%M %Z")
  end
  
end