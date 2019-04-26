class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum:
                     Settings.modelss.micropost_maximum}
  validate :picture_size

  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  scope :feed, (lambda do |user|
    where user_id: user.id
  end)


  private

  def picture_size
    return unless picture.size > Settings.modelss.micropost_byte.megabytes
    errors.add(:picture, "should be less than 5MB")
  end
end
