class WebDirectory::Family < ::Directory::Family
  MAX_WIDTH = 180
  MAX_HEIGHT = 135
  def initialize(agent, change_link, options = {})
    @agent, @change_link = agent, change_link
    super(options)
  end
  
  def upload_photo
    return unless photo
    image = Magick::Image.read(photo).first
    resized_image_data = image.resize_to_fill(MAX_WIDTH, MAX_HEIGHT).to_blob
    change_form_page = @agent.get(@change_link)
    # clear the image if already uploaded
    change_form_page = change_form_page.link_with(:text => 'Change').click if change_form_page.link_with(:text => 'Change')
    
    form = change_form_page.forms.first
    upload_field = form.file_uploads.first
    upload_field.file_name = photo_filename
    upload_field.file_data = resized_image_data
    upload_field.mime_type = 'image/jpeg'
    
    # Javascript was doing this stuff, so we gotta emulate it
    form['FamilyNumber'] = form.field_with(:name => /^\d+$/).name # the field with all numbers is a membership record number. The first one is the family number.
    form['Submit'] = "Submit"
    form['RawUploadImageName'] = photo_filename
    
    result = form.submit
    
    result.body
    true
  end
  
  def photo_filename
    File.basename(photo)
  end
end