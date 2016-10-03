module MapsHelper
  def network_option_list
    options_for_select(
      imiq_api.network_list.collect{ |org|
        [org['networkcode']]
      },
      current_search.networkcode
    )
  end

  def organization_option_list
    options_for_select(
      imiq_api.organization_list.collect{ |org|
        [org['description_with_code'], org['organizationcode']]
      },
      current_search.organizationcode
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
    [['Fifteen Minutes', 'fifteenmin'], ['Hourly','hourly'],['Daily', 'daily'],['Monthly', 'monthly'], ['Annual', 'annual']]
  end

  def geophysical_params(type = 'any')
    vars = {
      'daily'=> [
        ['Discharge', 'discharge'],
        ['Water Temperature', 'watertemp']
      ],
      'fifteenmin'=> [
        ['Water Temperature', 'watertemp']
      ],
      'hourly'=> [
      ],
      'monthly'=> [
      ],
      'annual'=> [
      ],
      'any'=> [
        ['Discharge', 'discharge'],
        ['Water Temperature', 'watertemp']
      ]
    }

    {
      'Exportable Summary Products' => [
        [ 'Air Temperature'                     , 'airtemp'             ],
        [ 'Relative Humidity'                   , 'rh'                  ],
        [ 'Wind Speed (only hourly,daily)'      , 'windspeed'           ],
        [ 'Wind Direction (only hourly,daily)'  , 'winddirection'       ],
        [ 'Precipitation'                       , 'precip'              ],
        [ 'Snow Depth'                          , 'snowdepth'           ],
        [ 'Snow Water Equivalent'               , 'swe'                 ],
        [ 'Discharge (only daily,monthly,annual)'      , 'discharge'           ],
        [ 'Water Temperature (only fifteen minute, daily)'      ,    'watertemp'           ]
      ],

      'Air' => [
        ["Barometric Pressure"              , "air_barometric_pressure"],
        ["Clouds"                           , "air_clouds"             ] ,
        ["Humidity"                         , "air_humidity"           ],
        ["Radiation, Longwave/Shortwave"    , "air_radiation_lwsw"     ],
        ["Radiation, PAR"                   , "radiation_par"          ],
        ["Temperature, Air"                 , "air_temperature"        ],
        ["Visibility"                       , "visibility"             ],
        ["Wind, Direction/Speed"            , "air_wind"                ]
      ],

      'Precipitation' => [
        ["Pan Evaporation"                  , "precipitation_pan_evaporation" ],
        ["Precipitation"                    , "precipitation_precipitation"   ],
        ["Snowfall"                         , "precipitation_snowfall"        ]
      ],

      'Snow' => [
        ["Ablation"                         , "snow_ablation"   ],
        ["Snow Depth"                       , "snow_depth"      ],
        ["Snow Water Equivalent"            , "snow_swe"        ],
        ["Snow Temperature"                 , "snow_temperature"]
      ],

      'Soil' => [
        ["Soil Albedo"                      , "soil_albedo"         ],
        ["Frost Free Days"                  , "soil_frost_free_days"],
        ["Soil Temperature"                 , "soil_temperature"    ],
        ["Thaw Depth"                       , "soil_thaw_depth"     ],
        ["Soil Water Content"               , "soil_water_content"  ]
      ],

      'Surface Water' => [
        ["Water Chemistry"                  , "sw_chemistry"        ],
        ["Discharge/Runoff"                 , "sw_discharge"        ],
        ["Fish Detected"                    , "sw_fish_detected"    ],
        ["Ice"                              , "sw_ice"              ],
        ["Physical Water Properties"        , "sw_physical"         ],
        ["Water Pressure"                   , "sw_pressure"         ],
        ["Radiation, PAR"                   , "air_radiation_par"   ],
        ["Surface Water Temperature"        , "sw_temperature"      ]
      ]

    }
  end
end
