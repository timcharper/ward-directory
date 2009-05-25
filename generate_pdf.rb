require 'config/environment.rb'
require 'prawn'
require "prawn/measurement_extensions"

filename = ARGV[0]
directory = Directory.parse(File.read(filename))
unused = directory.match_photos(Dir[File.join(ARGV[1], "*.jpg")])
unless unused.empty?
  puts "The following photos weren't used:"
  puts unused * "\n"
end
Directory.local_area_code = "801"

class DirectoryPDF
  FONT = "Times-Roman"
  EMAIL_COLOR = "0000ff"
  TEXT_COLOR = "000000"
  def initialize(filename, families)
    @filename = filename
    @families = families
  end
  
  def draw_family(pdf, family)
    photo_aspect_ratio = 1.5
    photo_width = pdf.bounds.width * 0.80
    photo_height = photo_width / photo_aspect_ratio
    padding = 0.mm

    pdf.stroke_rectangle [(pdf.bounds.width - photo_width) / 2, pdf.bounds.top], photo_width, photo_height
    pdf.font FONT, :size => 12, :style => :bold
    surname_height = pdf.font.height
    pdf.text family.surname, :at => [0, pdf.bounds.top - photo_height - padding - surname_height]
    pdf.font FONT, :size => 8, :style => :normal
    pdf.text family.address.street, :at => [pdf.bounds.right - pdf.font.width_of(family.address.street), pdf.bounds.top - photo_height - padding - surname_height]

    pdf.bounding_box([0, pdf.bounds.top - surname_height  - photo_height - padding], :width => pdf.bounds.width, :height => pdf.bounds.height - photo_height - surname_height) do
      y_offset = 0
      parent_indent = 3.mm
      family.parents.each do |parent|
        pdf.font FONT, :style => :bold, :size => 8
        parent_y = pdf.bounds.top - y_offset - pdf.font.height
        y_offset += pdf.font.height
        name_width = pdf.font.width_of(parent.name)
        pdf.text parent.name, :at => [parent_indent, parent_y]
        if not parent.phones.empty?
          pdf.font FONT, :style => :normal, :size => 7
          pdf.text " - #{parent.phones.map(&:to_s) * ', '}", :at => [name_width + parent_indent, parent_y]
        end
        if parent.email
          pdf.font FONT, :style => :normal, :size => 7
          pdf.fill_color EMAIL_COLOR
          
          pdf.text parent.email, :at => [pdf.bounds.width - pdf.font.width_of(parent.email), parent_y]
          pdf.fill_color TEXT_COLOR
        end
      end
      pdf.font FONT, :style => :normal, :size => 7
      pdf.bounding_box([parent_indent, pdf.bounds.top - y_offset - 1.mm], :width => pdf.bounds.width) do
        pdf.text family.children.map(&:name) * ", "
      end
    end
  end
  
  def page_header(pdf, page_number)
    pdf.font FONT, :size => 10
    
    @header_height = pdf.font.height + 1.mm
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width, :height => @header_height) do
      pdf.text "Ward Directory", :align => :left
    end
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width, :height => @header_height) do
      pdf.text "page #{page_number}", :align => :center
    end
    pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width, :height => @header_height) do
      pdf.text Date.today.to_s, :align => :right
    end
  end
  
  def render
    page_number = 1
    margin = 5.mm
    Prawn::Document.generate(@filename, 
      :page_layout   => :landscape,
      :left_margin   => margin,
      :right_margin  => margin,
      :top_margin    => margin,
      :bottom_margin => margin
    ) do |pdf|
      @families.in_groups_of(9).each do |page_families|
        pdf.start_new_page unless page_number == 1
        page_header(pdf, page_number)
  
        pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - @header_height], :width => pdf.bounds.width, :height => pdf.bounds.height - @header_height) do
          row_height = pdf.bounds.height / 3
          col_width = pdf.bounds.width / 3
          col_margin = 10.mm
          page_families[0..8].in_groups_of(3).each_with_index do |row_families, row|
            row_families.each_with_index do |family, col|
              next unless family
              pdf.bounding_box([pdf.bounds.left + (col_width * col) + (col_margin / 2), pdf.bounds.top - (row_height * row)], :width => col_width - col_margin, :height => row_height) do
                draw_family(pdf, family)
              end
            end
          end
        end
        page_number += 1
      end
    end
  end
end

DirectoryPDF.new("ward-directory.pdf", directory.families).render