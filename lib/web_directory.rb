require 'mechanize'
require 'hpricot'
require 'yaml'
config = YAML.load_file(File.dirname(__FILE__) + '/../' + "config/ward_website.yml")
class WebDirectory
  MEMBERS_TABLE_XPATH = '//html/body/table[2]/tr/td[2]/table/tr[2]/td[2]/p/table/tr/td/table[3]'
  def initialize(config = {})
    @config = config
  end
  
  def agent
    @agent ||= WWW::Mechanize.new
  end
  
  def homepage
    @homepage ||= (
      page = agent.get("https://secure.lds.org/units/")
      f = page.forms.first
      f[username] = @config['username']
      f["password"] = @config['password']
      @home_page = f.submit
    )
  end
  
  def admin_page
    @admin_page ||= agent.get(home_page.link_with(:text => /Administrator Options/).href.scan(/^.+'(.+)'.*$/).flatten.first)
  end
  
  def membership_directory_page
    @membership_directory_page ||= admin_page.link_with(:text => /Membership Directory/).click
  end
  
  def families_on_page(page)
    doc = Hpricot(page.body)
    members_table = doc.search(MEMBERS_TABLE_XPATH)
    family_rows_groups = (members_table / ' > tr').split { |r| (r / '> td').first.attributes['colspan'] == '4' }[1..-1]
    family_rows_groups.map do |family_rows|
      surname = (family_rows.first / 'td')[0].inner_text
      change_link = ((family_rows.first / 'td').last / ('a')).first.attributes['href']
      head_household_name = (family_rows[1] / 'td / font').first.inner_text
      WebDirectory::Family.new(agent, change_link, :surname => surname, :parents => [Directory::Individual.new(head_household_name)])
    end
  end
end

class WebDirectory::Family < ::Directory::Family
  def initialize(agent, change_link, options = {})
    @agent, @change_link = agent, change_link
    super(options)
  end
end