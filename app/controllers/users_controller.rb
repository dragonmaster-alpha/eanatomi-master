class UsersController < ApplicationController
  before_action :require_login, :set_user

  def edit
    @client_types = ClientType.all.map do |type|
      [t(type, scope: [:application, :client_types]), type]
    end
  end

  def update
    if @user.update(user_params)
      redirect_to :users, notice: t('users.update')
    else
      render 'edit'
    end
  end

  private

    def set_user
      @user = context.user
    end

    def user_params
      params[:user].permit(:name, :client_type, :phone, :email, :attention, :vat_number, :address, :zip_code, :city, :att)
    end

end
