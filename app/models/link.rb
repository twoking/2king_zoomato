class Link < ApplicationRecord
  belongs_to :user
  before_create :generate_token
  after_update :check_validity


  def check_validity
    self.destroy if self.count >= 25
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
