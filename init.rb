require 'redmine'

# Patches to the Redmine core
#require 'redmine_other_formats_builder_patch'
#require 'redmine_pdf_export_patch'

#Rails.configuration.to_prepare do
#	Redmine::Views::OtherFormatsBuilder.send(:include, OtherFormatsBuilderPatch)
  
#	Redmine::Export::PDF.send(:include, PDFExportPatch)
#end

Redmine::Plugin.register :pdf_export do

  permission :pdf_export, { :pdf_controller => [:all_issues_to_pdf,] }, :public => true
  name 'Pdf Export plugin'
  author 'Bruno Queiroz'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
