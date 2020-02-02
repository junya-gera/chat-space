class UsersController < ApplicationController
  before_action :move_to_edit, except: [:edit]


  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def move_to_edit
    redirect_to action :edit unless user_signed_in?
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
