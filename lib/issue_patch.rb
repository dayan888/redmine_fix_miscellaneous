require_dependency 'issue'
require 'method_source'

class Issue
    def last_notes_date
        if @last_notes_date
            @last_notes_date
        end
    end

    def self.add_to_load_visible_last_notes
        if issues.any?
            issues.each do |issue|
                journal = journals.detect {|j| j.journalized_id == issue.id}
                issue.instance_variable_set("@last_notes_date", journal.try(:created_on) || '')
            end
        end
    end

    def self.load_visible_last_notes_with_modules(issues, user=User.current)
        if Setting.plugin_redmine_fix_miscellaneous['notes_date_to_issue_list']
            puts "load_visible_last_notes_with_modules"
            eval @@load_visible_last_notes
        else
            load_visible_last_notes_without_modules(issues, user)
        end
    end

    class <<self
        def extract(src)
            srcArr = src.split("\n")
            srcArr.delete_at(-1)
            srcArr.delete_at(0)
            srcArr.join("\n")
        end

        begin
            @@load_visible_last_notes = Issue.extract(Issue.method(:load_visible_last_notes).source)
            add_to_load_visible_last_notes = Issue.extract(Issue.method(:add_to_load_visible_last_notes).source)
            @@load_visible_last_notes += "\n" + add_to_load_visible_last_notes

            alias_method :load_visible_last_notes_without_modules, :load_visible_last_notes
            alias_method :load_visible_last_notes, :load_visible_last_notes_with_modules
        rescue Exception => e
            logger.fatal e
            logger.fatal e.backtrace.join("\n")
        end
    end
end  

