class Department < ApplicationRecord
  belongs_to :manager, class_name: 'User', optional: true
  belongs_to :superior, class_name: 'Department', optional: true
  has_many :sub_departments, class_name: 'Department', foreign_key: 'superior_id'
  has_many :users_departments
  has_many :users, through: :users_departments

  def all_users
    sub_depts = sub_departments.flat_map(&:all_users)
    (users + sub_depts).uniq
  end

  # Return this department id plus all descendant department ids
  def subtree_ids
    ids = []
    stack = [self]
    while stack.any?
      d = stack.pop
      next if d.nil? || ids.include?(d.id)
      ids << d.id
      stack.concat(d.sub_departments.to_a)
    end
    ids
  end
end
