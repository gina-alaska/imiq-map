module MapsHelper
  def network_option_list
    options_for_select(
      imiq_api.network_list.collect{ |org| 
        [org['networkcode']]
      }
    )
  end
  
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
  
  def timesteps
    [['Hourly','hourly'],['Daily', 'daily']]
  end
  
  def geophysical_params(type = 'any')
    vars = {
      'daily'=> [
        ['Discharge', 'discharge']  
      ],
      'hourly'=> [
      ],
      'any'=> [
        ['Discharge', 'discharge']
      ]   
    }
    
    [
      [ 'Air Temperature'       , 'air_temp'             ],            
      [ 'Relative Humidity'     , 'relative_humidity'    ],   
      [ 'Wind Speed'            , 'wind_speed'           ],         
      [ 'Wind Direction'        , 'wind_direction'       ],
      [ 'Precipitation'         , 'precipitation'        ],       
      [ 'Snow Depth'            , 'snow_depth'           ],         
      [ 'Snow Water Equivalent' , 'snow_water_equivalent']
    ] + (vars[type].present? ? vars[type] : [])
  end
end
