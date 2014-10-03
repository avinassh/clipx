class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: [:show, :edit, :update, :destroy, :print]

  # GET /articles
  # GET /articles.json
  def index
    @articles =
      if params[:q].present?
        Article.search(params[:q], {
          where: {
            user_id: current_user.id ,
            status: { not: "fetched" }
          },
          order: {
            created_at: :desc
          }
        })
      else
        Article.search(current_user.id, {
          fields: [ :user_id=>:exact ],
          where: {
            status:{ not: "fetched" }
          },
          order: {
            created_at: :desc
          }
        })
      end
      #render plain: @articles.size
    @fetcher_names = current_user.fetcher_names
  end

  def autocomplete
    render json: Article.autocomplete(params[:q], current_user.id)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  def print
    render "articles/print", layout: false
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /articles/source/pocket
  def source
    @source = params[:source]
    @articles = Article.search(@source, field: [:provider], where: {user_id: current_user.id}, order: {created_at: :desc})
    @fetcher_names = current_user.fetcher_names

    render 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
      raise 'Not Authorized' unless @article.user_id == current_user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:url, :title, :content, :image, :tags, :provider)
    end
end
