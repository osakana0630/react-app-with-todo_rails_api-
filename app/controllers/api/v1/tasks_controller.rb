class Api::V1::TasksController < ApplicationController

  before_action :set_params, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]


  def index
    @tasks = Task.all.order(created_at: :desc)
    json_response "Index tasks successfully", true, {task: @tasks}, :ok
  end

  def show
    json_response "Show tasks successfully", true, {task: @task}, :ok
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save!
      json_response "Created task successfully", true, {task: @task}, :ok
    else
      json_response "Created task fail", false, {}, :unprocessable_entity
    end
  end

  def update
    if correct_user(@task.user)
      if @task.update(task_params)
        json_response "Updated tasks successfully", true, {task: @task}, :ok
      else
        json_response "Updated task fail", false, {}, :unprocessable_entity
      end
    end
  end

  def destroy
    if correct_user(@task.user)

      if @task.destroy
        json_response "Deleted task successfully", true, {}, :ok
      else
        json_response "Deleted task fail", false, {}, :unprocessable_entity
      end
    end
  end

  private

  def set_params
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name)
  end

end
