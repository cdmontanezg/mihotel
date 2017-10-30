class NotificationController < ApplicationController
  respond_to :json

  # def index
  #   respond_to do |format|
  #     format.json { render json: Notification.paginate(page: params[:page], per_page: 2) }
  #     format.html
  #   end
  # end

  def index
    respond_to do |format|
      format.json { render json: Notification.where(hotel_id: params[:hotel_id]) }
      format.html
    end
  end

  def count
    respond_with Notification.count('DISTINCT id');
  end

  def create
    respond_with Notification.create(notification_params)
  end

  def destroy
    respond_with Notification.destroy(params[:id])
  end

  def show
    respond_to do |format|
      format.json { render json: Notification.find(params[:id]) }
      format.html
    end
  end

  private
  def notification_params
    params.require(:notification).permit(:nombre_huesped, :descripcion, :fecha, :canal)
  end
end