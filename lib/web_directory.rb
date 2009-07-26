class WebDirectory < Directory
  autoload :Family, 'web_directory/family'
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
      f = page.form_with(:name => "loginForm")
      f['username'] = @config['username']
      f['password'] = @config['password'] || (
        puts "Please enter your password:"
        STDOUT.flush
        gets.chomp
      )
      homepage = f.submit
      raise RuntimeError, "failed to authenticate" if homepage.form_with(:name => "loginForm")
      homepage
    )
  end
  
  def admin_page
    @admin_page ||= (
      admin_link = homepage.link_with(:text => /Administrator Options/)
      raise RuntimeError, "not authenticated as an adminstrator (can't find the 'Administrator Options' link)" unless admin_link 
      agent.get(admin_link.href.scan(/^.+'(.+)'.*$/).flatten.first)
    )
  end
  
  def first_membership_directory_page
    @first_membership_directory_page ||= admin_page.link_with(:text => /Membership Directory/).click
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
  
  def families
    @families ||= (
      result = []
      membership_directory_pages.each do |page|
        result.concat families_on_page(page)
      end
      result
    )
  end
  
  def membership_directory_pages
    puts "fetching A"
    pages = [first_membership_directory_page]
    ('B'..'Z').each do |letter|
      puts "fetching #{letter}"
      pages << first_membership_directory_page.link_with(:text => letter).click
    end
    pages
  end
  
  def self.parse
    # unimplementing a method - code smell - base class needs to be subclassed
    raise NotImplemented
  end
end
