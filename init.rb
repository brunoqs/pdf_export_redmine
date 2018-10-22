require 'redmine'

# Patches to the Redmine core
require 'redmine_other_formats_builder_patch'
require 'redmine_issues_pdf_helper_patch'

Rails.configuration.to_prepare do
	Redmine::Views::OtherFormatsBuilder.send(:include, OtherFormatsBuilderPatch)
  
	Redmine::Export::PDF::IssuesPdfHelper.send(:include, IssuesPdfHelperPatch)
end

Redmine::Plugin.register :pdf_export do
  name 'Pdf Export plugin'
  author 'Bruno Queiroz'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/brunoqs/pdf_export'
  author_url 'https://brunoqs.github.io/'
end
