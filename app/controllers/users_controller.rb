class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def index
    authorize User
    @q = policy_scope(User).ransack(params[:q])
    @users = @q.result

    render json: @users.map { |user| UserSerializer.call(user) }
  end

  def show
    authorize user

    render json: UserSerializer.call(user)
  end

  def create
    @user = User.create!(permitted_attributes(User))
    @user.confirm_success_url = "http://example.com/success" # Defina um URL fictício ou válido

    authorize user

    render json: UserSerializer.call(user), status: :created
  end

  def update
    authorize user
    user.update!(permitted_attributes(User))

    render json: UserSerializer.call(user), status: :ok
  end

  def destroy
    authorize user
    user.destroy

    head :no_content
  end

  private

  def user
    @user ||= User.find(params[:id])
  end
end
