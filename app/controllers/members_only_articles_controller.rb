class MembersOnlyArticlesController < ApplicationController
  before_action :authorize_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private

  def authorize_user
    head :unauthorized unless session[:user_id]
  end

  def record_not_authorized
    render json: { error: "Not authorized" }, status: :unauthorized
  end
end
