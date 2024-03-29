# frozen_string_literal: true

class TasksController < ApplicationController
  include Exportable

  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.only_parents.order(:due_date)
  end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'Tarefa foi criada com sucesso.'
    else
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Tarefa foi atualizada com sucesso.'
    else
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to tasks_url, notice: 'Tarefa foi removida com sucesso.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :due_date, :done, :parent_id)
  end
end
