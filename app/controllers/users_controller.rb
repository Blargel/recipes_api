class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  permit_params :name, :password, :password_confirmation
end
