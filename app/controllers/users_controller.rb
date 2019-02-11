class UsersController < ApplicationController
  permit_params :name, :password, :password_confirmation
end
