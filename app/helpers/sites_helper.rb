module SitesHelper
  def summary_products_list(site)
    site.derived_variables.collect do |k,v|
      v.collect { |i| i[0].chomp } unless v.empty? or k.downcase == 'source'
    end.flatten.compact.uniq.sort
  end
end
