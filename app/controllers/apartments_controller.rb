class ApartmentsController < ApplicationController
  before_action :require_sign_in!, except: [:index, :show]
  before_action :set_apartment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @apartments = Apartment.where(status: "published").order(created_at: :desc)
  end

  def show
  end

  def new
    @apartment = current_user.apartments.build
  end

  def create
    @apartment = current_user.apartments.build(apartment_params)
    @apartment.status ||= "published"
    if @apartment.save
      redirect_to @apartment, notice: "Apartment created"
    else
      flash.now[:alert] = @apartment.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @apartment.update(apartment_params)
      redirect_to @apartment, notice: "Apartment updated"
    else
      flash.now[:alert] = @apartment.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @apartment.destroy
    redirect_to root_path, notice: "Apartment deleted"
  end

  private

  def set_apartment
    @apartment = Apartment.find(params[:id])
  end

  def authorize_owner!
    redirect_to root_path, alert: "Not authorized" unless @apartment.user_id == current_user&.id
  end

  def apartment_params
    params.require(:apartment).permit(
      :title, :description, :latitude, :longitude, :price_cents, :size_sqm, :rooms,
      :address, :city, :country, :floor, :year_built, :amenities, :status, :available_from
    )
  end

  def require_sign_in!
    redirect_to sign_in_path, alert: "Please sign in" unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
