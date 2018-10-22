module OtherFormatsBuilderPatch
  include Redmine::I18n

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
  
  module InstanceMethods   
    def spec_format_link_to(name, spec_format, options={})
      url = { :format => spec_format.to_s.downcase, :export_type => name}.merge(options.delete(:url) || {})
      #caption = options.delete(:caption) || name
      caption = options.delete(:caption) || l(:label_parametric_pdf_export_caption_text)
      html_options = { :class => spec_format.to_s.downcase, :rel => 'nofollow' }.merge(options)
      @view.content_tag('span', @view.link_to(caption, url, html_options))
    end
  end
end