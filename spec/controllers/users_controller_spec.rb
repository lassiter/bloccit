require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:new_user_attributes) do
    {
        name: "Blochead",
        email: "blochead@bloc.io",
        password: "blochead",
        password_confirmation: "blochead"
    }
  end
  let(:my_topic) { create(:topic) }
  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:my_post) { create(:post, user: my_user) }
  let(:my_comment) { create(:comment, post: my_post, user: my_user) }
  let(:other_comment) { create(:comment, post: my_post, user: other_user) }

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "instantiates a new user" do
      get :new
      expect(assigns(:user)).to_not be_nil
    end
  end

  describe "POST create" do
    it "returns an http redirect" do
      post :create, params: { user: new_user_attributes }
      expect(response).to have_http_status(:redirect)
    end

    it "creates a new user" do
      expect{
        post :create, params: { user: new_user_attributes }
      }.to change(User, :count).by(1)
    end

    it "sets user name properly" do
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).name).to eq new_user_attributes[:name]
    end

    it "sets user email properly" do
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).email).to eq new_user_attributes[:email]
    end

    it "sets user password properly" do
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).password).to eq new_user_attributes[:password]
    end

    it "sets user password_confirmation properly" do
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).password_confirmation).to eq new_user_attributes[:password_confirmation]
    end
    it "logs the user in after sign up" do
      post :create, params: { user: new_user_attributes }
      expect(session[:user_id]).to eq assigns(:user).id
    end
  end

  describe 'GET show' do
    it 'if the user has posts it will return favorites' do
      5.times { create(:post, user: my_user)}
      get :show, params: { id: my_user }
      favs = Post.where({id: my_user.favorites}).count 
      expect(@controller.return_favorites.count).to eq(favs)
    end
    it 'if the user has no posts it will return nothing' do
      get :show, params: { id: my_user }
      expect(@controller.return_favorites.count).to eq(0)
    end
  end

  describe "not signed in" do
    let(:factory_user) { create(:user) }

    before do
      post :create, params: { user: new_user_attributes }
    end
    it "returns http success" do
      get :show, params: { id: factory_user.id }
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, params: { id: factory_user.id }
      expect(response).to render_template :show
    end

    it "assigns factory_user to @user" do
      get :show, params: { id: factory_user.id }
      expect(assigns(:user)).to eq(factory_user)
    end
  end


    # describe '#return_favorites' do #mentor
    #   it 'will return all favorited posts of the user' do

    #     @user = my_user 
    #     puts @user
    #     5.times { create(:post, user: @user)}
    #     puts @user.favorites
    #     puts @user.posts
    #     # puts  @user.favorites.count
    #     favs = Post.where({id: @user.favorites}).count
    #     expect(@user.return_favorites).to eq(favs)
    #     # UsersController.new.send(:return_favorites, @user).should == favs
    #   end
    #   # it 'if the user has no favorites, it will return nothing' do
    #   #   favs = Post.where({id: my_post.id}).favorites.count
    #   #   expect(other_user.favorites.count).to eq(0)
    #   # end
    # end

end
