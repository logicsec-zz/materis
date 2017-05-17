module ApplicationHelper
  def current_url(new_params)
    url_for :params => params.merge(new_params)
  end

  def build_validated_field(form_name, field, name, message, pattern, type, value, id = nil)
    html = ""
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    if type == 'password'
      html << password_field_tag("#{form_name}[#{field}]", value, :class => '', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    elsif type == 'file'
      html << file_field_tag("#{form_name}[#{field}]", :required => '', :pattern => pattern, :placeholder => name, :id => id)
    elsif type == 'radio'
      html << radio_button_tag("#{form_name}[#{field}]", value, :class => '', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    elsif type == 'checkbox'
      html << check_box_tag("#{form_name}[#{field}]", value, :class => '', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    elsif type == 'text_area'
      html << text_area_tag("#{form_name}[#{field}]", value, :class => '', :required => '', :pattern => pattern, :placeholder => name,:rows=>1, :id => id)
    elsif type == 'date_field'
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'date-input ', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    elsif type == 'date_only_field'
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'date-only-input', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    elsif type == 'time-field'
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'time-field', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    else
      html << text_field_tag("#{form_name}[#{field}]", value, :class => '', :required => '', :pattern => pattern, :placeholder => name, :id => id)
    end
    return html.html_safe
  end

  def build_field(form_name, field, name, type, value)
    html = ""
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    if type == 'password'
      html << password_field_tag("#{form_name}[#{field}]", value, :class => '', :placeholder => name)
    elsif type == 'file'
      html << file_field_tag("#{form_name}[#{field}]", :class => '')
    elsif type == 'radio'
      html << radio_button_tag("#{form_name}[#{field}]", value, :class => '', :placeholder => name)
    elsif type == 'checkbox'
      html << check_box_tag("#{form_name}[#{field}]", value, :class => '', :placeholder => name)
    elsif type == 'text_area'
      html << text_area_tag("#{form_name}[#{field}]", value, :class => '', :placeholder => name,:rows=>1)
    else
      html << text_field_tag("#{form_name}[#{field}]", value, :class => '', :placeholder => name)
    end
    return html.html_safe
  end

  def build_validated_select(form_name, field, name, message, pattern, multiple, value, options)
    html = ""
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    html << select_tag("#{form_name}[#{field}]", options_for_select(options, value), {:multiple => multiple})
    return html.html_safe
  end

  def build_select(form_name, field, name,  multiple, value, options)
    html = ""
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    html << select_tag("#{form_name}[#{field}]", options_for_select(options, value), {:multiple => multiple})
    return html.html_safe
  end

  def current_class?(test_path)
    return 'menu_active' if request.path == test_path
  end
end
