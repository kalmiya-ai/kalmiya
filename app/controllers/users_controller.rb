# frozen_string_literal: true

class UsersController < ApplicationController
  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.create!(create_params)

    flash[:success] = t('.success')
    redirect_to action: :new
  end

  def update; end

  def destroy; end

  private

  def create_params
    params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation)
  end
end
