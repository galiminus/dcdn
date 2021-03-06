class Api::ContentsController < ApiController
  before_action :authenticate_user, only: [:create]

  expose :contents, -> { Content.all }
  expose :content, fetch: -> {
    if params[:id].present?
      Content.find_by!(info_hash: params[:id])
    else
      Content.new(content_params)
    end
  }

  def index
    render json: contents
  end

  def create
    if content.save
      render json: content
    else
      render json: { error: "error" }
    end
  end

  def show
    render json: content
  end

  protected

  def content_params
    params.require(:content).permit(:key, :torrent_key, :title, :info_hash)
  end
end
