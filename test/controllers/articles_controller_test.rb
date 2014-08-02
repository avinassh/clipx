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
      post :create, article: { content: @article.content, image: @article.image, provider: @article.provider, tags: @article.tags, title: @article.title, url: @article.url}
    end

    assert_redirected_to article_path(assigns(:article))
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
  end

  test "should show all articles" do
    article_count = users(:default).articles.count
    get :index, { :format => :json }
    assert_response :success
    articles = JSON.parse(@response.body)
    assert_equal article_count, articles.count
  end

  test "should get edit" do
    get :edit, id: @article
    assert_response :success
  end

  test "should update article" do
    patch :update, id: @article, article: { content: 'New content', image: @article.image, provider: @article.provider, tags: @article.tags, title: @article.title, url: @article.url }
    assert_redirected_to article_path(assigns(:article))
    @article.reload
    assert_equal 'New content', @article.content
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end

    assert_redirected_to articles_path
  end

  test "should ignore user_id & status fields" do
    wrong_user_id = users(:default).id+1

    # We handle both cases because they have different implementations
    # For :create
    post :create, article: { content: @article.content, image: @article.image, provider: @article.provider, tags: @article.tags, title: @article.title, url: @article.url, user_id: wrong_user_id, status: "invallid"}
    assert_equal Article.last.user_id, users(:default).id
    assert_equal Article.last.status, 'fetched'

    # For :update
    patch :update, id: @article, article: { user_id: wrong_user_id, status: 'invalid' }
    @article.reload
    assert_equal @article.user_id, users(:default).id
    assert_equal @article.status, 'fetched'
  end
end
