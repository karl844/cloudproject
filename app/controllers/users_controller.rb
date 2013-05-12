class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
    if params[:search]
    @users = User.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
    else
    @users = User.find(:all)
    end
  end

  def new
    @title = "Sign Up"
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def create
       @user = User.new(params[:user])
       if @user.save
          sign_in @user
	  redirect_to @user, :flash => { :success => "Hello " + @user.name.upcase + " Welcome to The Classroom"}
       else
	  @title = "Sign Up"
	  render 'new'
       end
  end

  def edit
    @title = "Edit User"
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "'Your profile was updated!"}
    else
      @title = "Edit User"
      render 'edit'    
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, :flash => { :success => "#{@user.name} was deleted!" }
  end

  private
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if !current_user.admin? || current_user?(@user)
  end
end

















