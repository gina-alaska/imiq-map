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
        ['Discharge', 'discharge'],
        ['Water Temperature', 'watertemp']
      ],
      'hourly'=> [
      ],
      'any'=> [
        ['Discharge', 'discharge'],
        ['Water Temperature', 'watertemp']
      ]
    }

    { 
      'Exportable' => [
        [ 'Air Temperature'                 , 'airtemp'             ],
        [ 'Relative Humidity'               , 'rh'                  ],
        [ 'Wind Speed'                      , 'windspeed'           ],
        [ 'Wind Direction'                  , 'winddirection'       ],
        [ 'Precipitation'                   , 'precip'              ],
        [ 'Snow Depth'                      , 'snowdepth'           ],
        [ 'Snow Water Equivalent'           , 'swe'                 ],
        [ 'Discharge (only daily)'          , 'discharge'           ],
        [ 'Water Temperature (only daily)'  , 'watertemp'           ]
      ],
      
      'Other' => [
        ["Ablation", "ablation"], ["Snowfall precipitation", "snowfall_precip"]
      ],
      
      'Water' => [
        ["Dissolved oxygen", "dissolved_oxygen"]
      ]
    }
  end
end
