module MapsHelper
  def organization_option_list
    options_for_select(
      imiq_api.organization_list.collect{ |org| 
        [org['description_with_code'], org['organizationcode']]
      }
    )
  end
end
