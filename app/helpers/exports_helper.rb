module ExportsHelper
  def params_list(site)
    list = []
    
    if site['derived_variables']['daily'].size > 0
      list += site['derived_variables']['daily'].map { |v| v[0] }
    end
      
    if site['derived_variables']['hourly'].size > 0
      list += site['derived_variables']['hourly'].map { |v| v[0] }
    end
      
    list.try(:join, ', ')
  end
end
