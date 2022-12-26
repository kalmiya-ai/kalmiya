# frozen_string_literal: true

class UsersController < ApplicationController
  def show; end

  def new
    @user = User.new(flash[:params])
    @errors = (flash[:errors] || {}).with_indifferent_access
  end

  def edit; end

  def create
    @user = User.create!(create_params)
    flash[:success] = t('.success')

    redirect_to action: :new
  rescue ActiveRecord::RecordInvalid => e
    flash[:errors] = e.record.errors
    flash[:params] = create_params.slice(:name, :email, :email_confirmation)

    redirect_to action: :new
  end

  def update; end

  def destroy; end

  private

  def create_params
    params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation)
  end
end
