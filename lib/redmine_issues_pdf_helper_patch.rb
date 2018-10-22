include Redmine::Export::PDF::IssuesPdfHelper

module IssuesPdfHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      alias_method_chain :issues_to_pdf, :full_pdf
    end   
  end
  
  module InstanceMethods
    include Redmine::I18n
    include Redmine::Export::PDF

      def issues_to_pdf_with_full_pdf(issues, project, query)
        # export_type is filled by view template thanks to spec_format_link_to
        (params['export_type'] == 'Full PDF') ? all_issues_to_pdf(issues, project, query) : issues_to_pdf_without_full_pdf(issues, project, query)
      end
  
      def all_issues_to_pdf(issues, project, query)  
        pdf = ITCPDF.new(current_language)
        title = project ? "#{project} - #{l(:label_issue_plural)}" : "#{l(:label_issue_plural)}"
        pdf.SetTitle(title)
        pdf.AliasNbPages
        pdf.footer_date = format_date(Date.today)
        pdf.AddPage("L")
        row_height = 7
        
        # title
        pdf.SetFontStyle('B',11)    
        pdf.Cell(190,10, title)
        pdf.Ln
        
        # headers
        pdf.SetFontStyle('B',10)
        pdf.SetFillColor(230, 230, 230)
        pdf.Cell(15, row_height, "#", 0, 0, 'L', 1)
        pdf.Cell(30, row_height, l(:field_tracker), 0, 0, 'L', 1)
        pdf.Cell(30, row_height, l(:field_status), 0, 0, 'L', 1)
        pdf.Cell(30, row_height, l(:field_priority), 0, 0, 'L', 1)
        pdf.Cell(40, row_height, l(:field_assigned_to), 0, 0, 'L', 1)
        pdf.Cell(25, row_height, l(:field_updated_on), 0, 0, 'L', 1)
        pdf.Cell(0, row_height, l(:field_subject), 0, 0, 'L', 1)
        pdf.Line(10, pdf.GetY, 287, pdf.GetY)
        pdf.Ln
        pdf.Line(10, pdf.GetY, 287, pdf.GetY)
        pdf.SetY(pdf.GetY() + 1)
        
        # rows
        pdf.SetFontStyle('',9)
        pdf.SetFillColor(255, 255, 255)
        group = false
        issues.each do |issue|
          if query.grouped? && issue.send(query.group_by) != group
            group = issue.send(query.group_by)
            pdf.SetFontStyle('B',10)
            pdf.Cell(0, row_height, "#{group.blank? ? 'None' : group.to_s}", 0, 1, 'L')
            pdf.Line(10, pdf.GetY, 287, pdf.GetY)
            pdf.SetY(pdf.GetY() + 0.5)
            pdf.Line(10, pdf.GetY, 287, pdf.GetY)
            pdf.SetY(pdf.GetY() + 1)
            pdf.SetFontStyle('',9)
          end
          pdf.Cell(15, row_height, issue.id.to_s, 0, 0, 'L', 1)
          pdf.Cell(30, row_height, issue.tracker.name, 0, 0, 'L', 1)
          pdf.Cell(30, row_height, issue.status.name, 0, 0, 'L', 1)
          pdf.Cell(30, row_height, issue.priority.name, 0, 0, 'L', 1)
          pdf.Cell(40, row_height, issue.assigned_to ? issue.assigned_to.to_s : '', 0, 0, 'L', 1)
          pdf.Cell(25, row_height, format_date(issue.updated_on), 0, 0, 'L', 1)
          pdf.RDMMultiCell(0, row_height, (project == issue.project ? issue.subject : "#{issue.project} - #{issue.subject}"))
          pdf.Line(10, pdf.GetY, 287, pdf.GetY)
          pdf.SetY(pdf.GetY() + 1)
        end
        
        issues.each do |issue|
          pdf.SetTitle("#{issue.project} - ##{issue.tracker} #{issue.id}")
          pdf.AliasNbPages
          pdf.footer_date = format_date(Date.today)
          pdf.AddPage
          
          pdf.SetFontStyle('B',11)    
          pdf.Cell(190,10, "#{issue.project} - #{issue.tracker} # #{issue.id}: #{issue.subject}")
          pdf.Ln
          
          y0 = pdf.GetY
          
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_status) + ":","LT")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, issue.status.to_s,"RT")
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_priority) + ":","LT")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, issue.priority.to_s,"RT")        
          pdf.Ln
            
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_author) + ":","L")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, issue.author.to_s,"R")
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_category) + ":","L")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, issue.category.to_s,"R")
          pdf.Ln   
          
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_created_on) + ":","L")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, format_date(issue.created_on),"R")
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_assigned_to) + ":","L")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, issue.assigned_to.to_s,"R")
          pdf.Ln
          
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_updated_on) + ":","LB")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, format_date(issue.updated_on),"RB")
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_due_date) + ":","LB")
          pdf.SetFontStyle('',9)
          pdf.Cell(60,5, format_date(issue.due_date),"RB")
          pdf.Ln
            
          for custom_value in issue.custom_values
            pdf.SetFontStyle('B',9)
            pdf.Cell(35,5, custom_value.custom_field.name + ":","L")
            pdf.SetFontStyle('',9)
            #pdf.RDMMultiCell(155,5, (show_value custom_value),"R")
          end
            
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_subject) + ":","LTB")
          pdf.SetFontStyle('',9)
          pdf.Cell(155,5, issue.subject,"RTB")
          pdf.Ln    
          
          pdf.SetFontStyle('B',9)
          pdf.Cell(35,5, l(:field_description) + ":")
          pdf.SetFontStyle('',9)
          pdf.RDMMultiCell(155,5, issue.description,"BR")
          
          pdf.Line(pdf.GetX, y0, pdf.GetX, pdf.GetY)
          pdf.Line(pdf.GetX, pdf.GetY, 170, pdf.GetY)
          pdf.Ln
          
          if issue.changesets.any? && User.current.allowed_to?(:view_changesets, issue.project)
            pdf.SetFontStyle('B',9)
            pdf.Cell(190,5, l(:label_associated_revisions), "B")
            pdf.Ln
            for changeset in issue.changesets
              pdf.SetFontStyle('B',8)
              pdf.Cell(190,5, format_time(changeset.committed_on) + " - " + changeset.author.to_s)
              pdf.Ln
              unless changeset.comments.blank?
                pdf.SetFontStyle('',8)
                pdf.RDMMultiCell(190,5, changeset.comments)
              end   
              pdf.Ln
            end
          end
          
          pdf.SetFontStyle('B',9)
          pdf.Cell(190,5, l(:label_history), "B")
          pdf.Ln  

          
          if issue.attachments.any?
            pdf.SetFontStyle('B',9)
            pdf.Cell(190,5, l(:label_attachment_plural), "B")
            pdf.Ln
            for attachment in issue.attachments
              pdf.SetFontStyle('',8)
              pdf.Cell(80,5, attachment.filename)
              pdf.Cell(20,5, number_to_human_size(attachment.filesize),0,0,"R")
              pdf.Cell(25,5, format_date(attachment.created_on),0,0,"R")
              pdf.Cell(65,5, attachment.author.name,0,0,"R")
              pdf.Ln
            end
          end
        end
        
        pdf.Output
      end

  end
end
