class RenScraper
  require "capybara"
  require "selenium-webdriver"
  require "capybara/dsl"
  include Capybara::DSL
  attr_accessor :session

  def register_auto_dl_driver
    Capybara.register_driver :selenium do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.dir'] = "#{Dir.getwd}/downloads"
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = "text/csv, application/x-unknown"
      Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
    end
  end

  def create_session
    Capybara.run_server = false
    Capybara.current_driver = :selenium
    @session = Capybara::Session.new(:selenium)
  end
  
  def prepare
    register_auto_dl_driver
    create_session
  end
  
  def get_to_psp_page
    url = "https://hosted133.renlearn.com/2812548/Public/RPM/Login/Login.aspx?srcID=t"
    session.visit(url)
    session.fill_in "tbUserName", :with => "A.cox"
    session.fill_in "tbPassword", :with => "?+&3P7yp24q9&e>"
    session.click_button "Log In"
    # Open navigation menu
    # session.find(:xpath, "//*[@id='ctl00_cp_Content_rptMenu_ctl00_spMenuBtnText']").click
    # Click on the link to go to the students, staff, parents page
    begin
      retry_count = 0
      until session.all(:xpath, "//a[@href='SIS/StaffStudentsParents/StaffStudentsParents.aspx']").length > 0
        sleep 2
      end
    rescue
      if retry_count < 1
        retry_count = 1
        retry
      end
    end
    session.first(:xpath, "//a[@href='SIS/StaffStudentsParents/StaffStudentsParents.aspx']").click
  end
  
  def get_to_export_school_list
    # Click on the export link
    session.find(:xpath, "//*[@id='m_lnkExportStudentData']").click
  end
  
  def export_school_data
    # Check boxes for STAR Math and Reading and click next button
    session.check("m_FlatFileGrid_ctl04_m_Select4")
    session.check("m_FlatFileGrid_ctl05_m_Select4")
    session.find("#m_wnButtons_Next").click
    # Fill in form fields and click on next button
    session.fill_in("m_txtFlatFileStartDate", :with => "7/1/2014")
    session.fill_in("m_txtFlatFileEndDate", :with => "6/30/2015")
    session.find("#m_wnButtons_Next").click
    # Wait for exports to be created
    begin
      retry_count = 0
      until session.all("a", :text => "Download").length > 1
        sleep 2
      end
    rescue
      if retry_count < 1
        retry_count = 1
        retry
      end
    end
    # Click on each export link to download
    session.all("a", :text => "Download").each do |link| link.click end
  end
  
  def return_to_export_school_list
    session.click_button("Done")
    get_to_export_school_list
  end
  
  def export_school_from_list(index)
    # Click on the school's export link
    begin
      retry_count = 0
      until session.all("a", :text => "Export").length > index
        sleep 2
      end
    rescue
      if retry_count < 1
        retry_count = 1
        retry
      end
    end
    session.all("a", :text => "Export")[index].click
    export_school_data
    return_to_export_school_list
  end
end

