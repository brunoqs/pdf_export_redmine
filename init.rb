require 'redmine'

# Patches to the Redmine core
require 'redmine_other_formats_builder_patch'
require 'redmine_issues_pdf_helper_patch'

require_dependency 'pdf_export_redmine/hooks'

Rails.configuration.to_prepare do
	Redmine::Views::OtherFormatsBuilder.send(:include, OtherFormatsBuilderPatch)
  
	Redmine::Export::PDF::IssuesPdfHelper.send(:include, IssuesPdfHelperPatch)
end

Redmine::Plugin.register :pdf_export_redmine do
  name 'Pdf Export Redmine plugin'
  author 'Bruno Queiroz'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/brunoqs/pdf_export'
  author_url 'https://brunoqs.github.io/'
end
