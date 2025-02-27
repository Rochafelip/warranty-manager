class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :authenticate_user!

  def index
    authorize User
    @q = policy_scope(User).ransack(params[:q])
    @users = @q.result

    render json: @users.map { |user| UserSerializer.call(user) }
  rescue Pundit::NotAuthorizedError
    render json: { error: I18n.t('errors.user_policy.index?') }, status: :forbidden
  end

  def show
    authorize user

    render json: UserSerializer.call(user)
  end

  def create
    @user = User.create!(permitted_attributes(User))

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
