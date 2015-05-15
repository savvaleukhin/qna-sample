require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
  it { should validate_presence_of :value }
  it { should belong_to :user }
  it { should validate_inclusion_of(:value).in_array(%w(1 -1)) }

  it 'Uniqueness of vote' do
    user = create(:user)
    question = create(:question, user: user)
    create(:vote, user_id: user.id, votable_id: question.id, votable_type: question.class.name)

    should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])
  end
end
