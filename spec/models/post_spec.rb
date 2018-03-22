require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:name) { RandomData.random_sentence }
  let(:description) { RandomData.random_paragraph }
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }

  let(:topic) { Topic.create!(name: name, description: description) }

  let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }
  let(:user_comment) { Comment.new(body: 'Comment Body', post: post, user: another_user) }
  let(:post) { topic.posts.create!(title: title, body: body, user: user) }
  let(:another_user) { User.create!(name: "Another User", email: "anotheruser@bloccit.com", password: "helloworld") }
  let(:another_user_comment) { Comment.new(body: 'Comment Body', post: post, user: another_user) }

  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:votes) }
  it { is_expected.to have_many(:favorites) }
  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:topic) }

  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }

  describe "attributes" do
    it "has title and body attributes" do
      expect(post).to have_attributes(title: title, body: body, user: user)
    end
  end
  context "voting" do
    before do
      3.times { post.votes.create!(value: 1, user: user) }
      2.times { post.votes.create!(value: -1, user: user) }
      @up_votes = post.votes.where(value: 1).count
      @down_votes = post.votes.where(value: -1).count
    end
  

    describe "#up_votes" do
      it "counts the number of votes with value = 1" do
        expect( post.up_votes ).to eq(@up_votes)
      end
    end

    describe "#down_votes" do
      it "counts the number of votes with value = -1" do
        expect( post.down_votes ).to eq(@down_votes)
      end
    end

    describe "#points" do
      it "returns the sum of all down and up votes" do
        expect( post.points ).to eq(@up_votes - @down_votes)
      end
    end

    describe "#update_rank" do
      it "calculates the correct rank" do
        post.update_rank
        expect(post.rank).to eq (post.points + (post.created_at - Time.new(1970,1,1)) / 1.day.seconds)
      end

      it "updates the rank when an up vote is created" do
        old_rank = post.rank
        post.votes.create!(value: 1, user: user)
        expect(post.rank).to eq (old_rank + 1)
      end

      it "updates the rank when a down vote is created" do
        old_rank = post.rank
        post.votes.create!(value: -1, user: user)
        expect(post.rank).to eq (old_rank - 1)
      end
    end
    describe "#create_vote" do
      it "calls #create_vote when a post is created" do
        post = topic.posts.new(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
        expect(post).to receive(:create_vote)
        post.save
      end
      it "associates the vote with the owner of the post" do
        expect(post.votes.first.user).to eq(post.user)
      end
    end
  end
  # describe '#after_create' do # optional test

  #   it 'creates a favorite for the post and user' do
  #     favorite = Favorite.create!(post: post, user: user)
  #     expect(favorite.post).to equal(user.posts) #content matches but not ActiveID
  #     expect(favorite.user.body).to equal(post.users.body) #content matches but not ActiveID
  #   end
  #   it 'notifies the post creator that they have favorited the post' do
  #     # favorite = user.favorites.create(post: post)
  #     expect(FavoriteMailer).to receive(:new_post).with(post).and_return(double(deliver_now: true))
  #   end
  #   it 'notifies the post creator of another user\'s comment' do
  #     # favorite = another_user.favorites.create(post: post)
  #     expect(FavoriteMailer).to receive(:new_post).with(post).and_return(double(deliver_now: true))
  #   end
  # end
end

