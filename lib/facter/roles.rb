require 'net/http'
require 'json'
require 'uri'

#url= "http://169.254.169.254/openstack/latest/meta_data.json"
#uri = URI.parse(url)
#http = Net::HTTP.new(uri.host,uri.port)
#response = http.get(uri.path)
#module RoleModule
#  def self.add_facts
#    if response.code == '200'
#      Facter.add("role") do
#        has_weight 100
#        setcode do
#          JSON.parse(response.body)['meta']['role']
#        end
#      end
#    else
#      Facter.add("role") do
#        setcode do
#          "desktop"
#        end
#      end
#    end
#  end
#end
#
module RoleModule
  def self.add_facts
    Facter.add("role") do
      productname = Facter.value(:productname)
      case productname
      when 'OpenStack Nova'
        has_weight 100
        setcode do
          url= "http://169.254.169.254/openstack/latest/meta_data.json"
          uri = URI.parse(url)
          http = Net::HTTP.new(uri.host,uri.port)
          response = http.get(uri.path)
          JSON.parse(response.body)['meta']['role']
        end
      when 'Dell XPS420'
        setcode do
          'desktop'
        end
      else 'ProLiant MicroServerr'
        setcode do
          'lab'
        end
      end
    end
  end
end

RoleModule.add_facts
