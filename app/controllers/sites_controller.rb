class SitesController < ApplicationController
  def index
    @sites = fetch_sites(params[:page])

    respond_to do |format|
      format.html
      format.js
      format.csv {
        attributes = %w{ siteid sitecode sitename organizations networks state county geolocation begin_date end_date comments }

        output = CSV.generate(headers: true) do |csv|
          csv << attributes

          pager = current_search.fetch(1, 100)
          add_sites(csv, pager, attributes)

          (2..[pager.total_pages,2].min).each do |page|
            pager = current_search.fetch(page, 100)
            add_sites(csv, pager, attributes)
          end
        end

        render text: output
      }
    end
  end

  def show
    @site = OpenStruct.new(imiq_api.site(params[:id]))

    respond_to do |format|
      format.html { render layout: false }
      format.js
    end
  end

  protected

  def fetch_sites(page = 1)
    # SitesPager.new(imiq_api.sites(current_search.params, page || 1, 50))
    current_search.fetch(page || 1, 50)
  end
  helper_method :fetch_sites

  def add_sites(csv, pager, attributes)
    pager.each do |site|
      csv << attributes.map{ |attr| site.send(attr) }
    end
  end
end
