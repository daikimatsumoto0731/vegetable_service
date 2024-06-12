# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :vegetable

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }

  def duration_in_days
    return unless start_date && end_date

    (end_date - start_date).to_i
  end

  private

  def end_date_after_start_date
    return unless end_date < start_date

    errors.add(:end_date, 'must be after the start date')
  end
end
