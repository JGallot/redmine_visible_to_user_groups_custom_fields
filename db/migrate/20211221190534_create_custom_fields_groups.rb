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

class CreateCustomFieldsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_fields_user_groups, :id => false do |t|
      t.column :custom_field_id, :integer, :null => false
      t.column :group_id, :integer, :null => false
    end
    add_index :custom_fields_user_groups, [:custom_field_id, :group_id], :unique => true, :name => :custom_fields_groups_ids
  end
end
