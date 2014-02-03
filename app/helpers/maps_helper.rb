module MapsHelper
  def organization_option_list
    options_for_select(
      imiq_api.organization_list.collect{ |org| 
        [org['description_with_code'], org['organizationcode']]
      }
    )
  end
  
  def format_geolocation(location) 
    results = location.match(/(-{0,1}\d+\.\d+) (-{0,1}\d+\.\d+)/)
    if results.nil?
      ''
    else
      "(#{results[2].to_f.round(3)}, #{results[1].to_f.round(3)})"
    end
  end
end
