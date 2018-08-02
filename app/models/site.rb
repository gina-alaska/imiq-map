require 'json'

class Site
  FIELDS = %w{ organizations }
  def initialize(data = {})
    @attributes = data
  end

  def read_attribute(name)
    @attributes[name.to_s]
  end

  def updated_at
    date = read_attribute(:updated_at)
    return if date.nil?
    DateTime.parse(date)
  end

  def has_field?(name)
    FIELDS.include?(name.to_s) || @attributes.has_key?(name.to_s)
  end

  def organizations
    @attributes['source']['organization']
  end

  def networks
    super.join(', ')
  end

  def cache_key
    [siteid, updated_at.to_i].join('-')
  end

  def [](field)
    @attributes[field]
  end

  def method_missing(field)
    if has_field?(field)
      read_attribute(field)
    else
      super
    end
  end
  
  def metadata_blurb
    "#{@attributes['sitename']}:
    Siteid: #{@attributes['siteid']}
    Sitecode: #{@attributes['sitecode']}
    Location(lat,long,elev):  #{@attributes['lat']},#{@attributes['lng']},#{@attributes['elevation']},
    Variables: #{@attributes['variables']}
    Begin Date: #{@attributes['begin_date']}
    End_Date: #{@attributes['end_date']}
    networks: #{networks}
    Organization: #{organizations}
    Source Link: #{@attributes['source']['sourcelink']}
    Contact: 
        Name: #{@attributes['source']['contactname']}
        Phone:  #{@attributes['source']['phone']}
        Email:  #{@attributes['source']['email']}
        Address:  #{@attributes['source']['address']}
                  #{@attributes['source']['city']}, #{@attributes['source']['state']}
                  #{@attributes['source']['zipcode']}
    Citation:  #{@attributes['source']['citation']}"
  end 
end
