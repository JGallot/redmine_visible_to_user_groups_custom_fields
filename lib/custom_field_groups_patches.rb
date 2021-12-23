# Redmine Visible to User Groups Custom Fields - A Redmine Plugin
# Copyright (C) 2021  Frederico Camara
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require_dependency 'group'
require_dependency 'issue_custom_field'

class Group
  unloadable
  has_and_belongs_to_many :issue_custom_fields, :join_table => "#{table_name_prefix}custom_fields_groups#{table_name_suffix}", :foreign_key => "group_id"
end

class IssueCustomField
  unloadable
  IssueCustomField.safe_attributes 'group_ids'

  has_and_belongs_to_many :groups, :join_table => "#{table_name_prefix}custom_fields_groups#{table_name_suffix}", :foreign_key => "custom_field_id"
end

module CustomFieldsGroups
  module CustomFieldPatch
    def validate_custom_field
      super

      # Ignore Roles blank error if any group is selected
      if groups.present?
        i = errors.delete(:base)
        if i.present?
          i = i - [l(:label_role_plural) + ' ' + l('activerecord.errors.messages.blank')]
          i.each do |s|
            errors.add(:base, s)
          end
        end
      end
    end

    def visible?
      user=User.current
      super || groups.map{|g| g.users}.flatten.include?(user)
    end
  end
end

IssueCustomField.send(:prepend, CustomFieldsGroups::CustomFieldPatch)
