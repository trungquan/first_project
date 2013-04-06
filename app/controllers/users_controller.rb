class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:show, :index, :edit, :update]
  before_filter :correct_user_or_admin, only: :edit

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user
  		flash[:success] = "User created"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      if current_user?(@user)
        redirect_to current_user
      else
        redirect_to @user
      end
    else
      render 'edit'
    end
  end

  def index
    @users = User.all    
  end

  private
    def signed_in_user
      unless signed_in?
        redirect_to signin_path, notice:"Please sign in"
      end     
    end

    def correct_user_or_admin
      @user = User.find(params[:id])
      redirect_to(root_path) if (!current_user?(@user) && !current_user.admin?)
    end

end
