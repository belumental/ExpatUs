class Chat < ApplicationRecord
  include PgSearch::Model
  belongs_to :user

  pg_search_scope :search_by_title_and_synopsis,
    against: [:title, :category, :description, :location],
    using: {
    tsearch: { prefix: true }
  }
end
