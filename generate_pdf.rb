require 'config/environment.rb'
require 'prawn'
require "prawn/measurement_extensions"

filename = ARGV[0]

directory = Directory.parse(File.read(filename))

page_number = 1
margin = 5.mm
Prawn::Document.generate("ward-directory.pdf", 
  :page_layout   => :landscape,
  :left_margin   => margin,
  :right_margin  => margin,
  :top_margin    => margin,
  :bottom_margin => margin
) do |pdf|
  pdf.start_new_page unless page_number == 1
  pdf.font "Times-Roman"
  
  header_height = pdf.font.height
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width, :height => header_height) do
    pdf.text "Ward Directory", :align => :left
  end
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width, :height => header_height) do
    pdf.text "page #{page_number}", :align => :center
  end
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.top], :width => pdf.bounds.width, :height => header_height) do
    pdf.text Date.today.to_s, :align => :right
  end
  
  pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - header_height - 5.mm], :width => pdf.bounds.width, :height => pdf.bounds.height - header_height) do
    row_height = pdf.bounds.height / 3
    col_width = pdf.bounds.width / 3
    col_margin = 20.mm
    directory.families[0..8].in_groups_of(3).each_with_index do |row_families, row|
      row_families.each_with_index do |family, col|
        pdf.bounding_box([pdf.bounds.left + (col_width * col) + (col_margin / 2), pdf.bounds.top - (row_height * row)], :width => col_width - col_margin, :height => row_height) do
          pdf.font_size = 12
          surname_height = pdf.font.height
          pdf.text family.surname, :align => :center
          
          pdf.font_size = 8
          photo_aspect_ratio = 1.5
          photo_width = pdf.bounds.width
          photo_height = photo_width / photo_aspect_ratio
          padding = 2.mm
          pdf.stroke_rectangle [(pdf.bounds.width - photo_width) / 2, pdf.bounds.top - surname_height], photo_width, photo_height
          
          pdf.bounding_box([0, pdf.bounds.top - surname_height  - photo_height - padding], :width => pdf.bounds.width, :height => row_height - photo_height - surname_height - padding) do
            pdf.text family.address.street
          end
        end
      end
    end
  end
  page_number += 1
end
