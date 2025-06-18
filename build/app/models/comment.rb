class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true
  before_create :set_timestamps 

  private
  def set_timestamps
    self.created_at ||= Time.current
    self.updated_at ||= Time.current
  end
end
