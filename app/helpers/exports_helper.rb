module ExportsHelper
  def params_list(site)
    list = []

    if site['derived_variables']['fifteenmin'].size > 0
      list += site['derived_variables']['fifteenmin'].map { |v| v[0] }
    end

    if site['derived_variables']['hourly'].size > 0
      list += site['derived_variables']['hourly'].map { |v| v[0] }
    end

    if site['derived_variables']['daily'].size > 0
      list += site['derived_variables']['daily'].map { |v| v[0] }
    end

    if site['derived_variables']['monthly'].size > 0
      list += site['derived_variables']['monthly'].map { |v| v[0] }
    end

    if site['derived_variables']['annual'].size > 0
      list += site['derived_variables']['annual'].map { |v| v[0] }
    end

    list.sort.uniq.try(:join, ', ')
  end
end
