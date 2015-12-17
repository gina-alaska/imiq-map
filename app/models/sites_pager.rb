class SitesPager
  def initialize(sites)
    @sites = sites
  end

  def headers
    @sites.headers
  end

  def each(&block)
    @sites.each do |params|
      site = Site.new(params)
      yield site
    end
  end

  def entry_name
    'site'
  end

  def offset_value
    headers['x-records-offset'].to_i
  end

  def first_page?
    headers['x-page'].to_i == 1
  end

  def last_page?
    headers['x-page'].to_i == total_pages
  end

  def limit_value
    headers['x-records-limit'].to_i
  end

  def total_count
    headers['x-total-records'].to_i
  end

  def total_pages
    headers['x-total-pages'].to_i
  end

  def current_page
    headers['x-page'].to_i
  end

  def next_page
    [current_page + 1, total_count].min
  end

  def prev_page
    [current_page - 1, 0].max
  end
end
