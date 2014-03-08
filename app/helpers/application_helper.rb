module ApplicationHelper
  def show_flash_messages
    flash.collect { |type, msg|
      content_tag(:div, "
      <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>
      #{msg}".html_safe, class: "alert alert-#{type}")
    }.join('').html_safe
  end
end
