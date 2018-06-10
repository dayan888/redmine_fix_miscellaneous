Redmine::Plugin.register :redmine_fix_miscellaneous do
  name 'Fix Misc plugin'
  author 'Dayan'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/dayan888/redmine_fix_miscellaneous'
  author_url 'https://github.com/dayan888/'

  settings default: {notes_date_to_issue_list: true, add_br_for_list: true}, partial: 'settings/misc_settings'
end

require_dependency 'fix_miscellaneous_hooks'
require_dependency 'issue_patch'
