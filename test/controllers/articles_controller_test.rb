require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @article = articles(:one)
    @article.url = 'http://stackoverflow.com/questions/4169971/adding-validates-uniqueness-of-to-a-model-fails-functional-tests'
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:default)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, article: { content: @article.content, heading: @article.heading, image: @article.image, provider: @article.provider, status: @article.status, tags: @article.tags, title: @article.title, url: @article.url, user_id: @article.user_id }
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @article
    assert_response :success
  end

  test "should update article" do
    patch :update, id: @article, article: { content: @article.content, heading: @article.heading, image: @article.image, provider: @article.provider, status: @article.status, tags: @article.tags, title: @article.title, url: @article.url, user_id: @article.user_id }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end

    assert_redirected_to articles_path
  end
end
