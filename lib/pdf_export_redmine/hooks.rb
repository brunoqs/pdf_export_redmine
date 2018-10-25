module PdfExportRedmine
	class Hooks < Redmine::Hook::ViewListener
		render_on :view_issues_index_bottom,
		:partial => 'pdf_export_redmine/hooks/view_issues_full_pdf'
	end
end