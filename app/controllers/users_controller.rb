class UsersController < ApplicationController
  whitelist_params :name, :password, :password_confirmation
end
