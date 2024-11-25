class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  has_many :stareds
end
