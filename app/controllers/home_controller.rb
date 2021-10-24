class HomeController < ApplicationController
  def index
    search_params = if params[:user_id].present?
                      { user_id: params[:user_id] }
                    elsif params[:tag].present?
                      { tags: params[:tag] }
                    end
    return unless search_params.present?

    flickr_photos(search_params)
  end

  private

  def flickr_photos(search_params)
    @photos_information = Flickr.new.photos.search(search_params)
  rescue Flickr::FailedResponse
    flash.now[:alert] = "User dosn't exist."
  else
    flash.now[:alert] = "There's no photos for that value." if @photos_information.count.zero?
  end
end
