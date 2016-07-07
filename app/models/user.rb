class User < ApplicationRecord
  validate :cannot_change_age_when_inactive, on: :update

  validates_presence_of :age

  before_destroy do
    cannot_remove_active_user
    throw(:abort) if errors.present?
  end

  def cannot_remove_active_user
    return true if !active?
    errors.add(:active, 'cannot remove active user')
    false
  end

  def cannot_change_age_when_inactive
    errors.add(:age, 'cannot change age when inactive') if age_changed? && !active?
  end
end
