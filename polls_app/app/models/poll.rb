class Poll < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :author_id, presence: true

  belongs_to(
    :author,
    class_name: 'User',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :questions,
    class_name: 'Question',
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    through: :questions,
    source: :answer_choices
  )
end
