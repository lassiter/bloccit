class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end
  def create
    @question = Question.new(question_params)
    # @question.title = params[:question][:title]
    # @question.body = params[:question][:body]
    # @question.resolved = params[:question][:boolean]

    if @question.save
      flash[:notice] = "Question was saved."
      redirect_to @question
    else
      flash.now[:alert] = "There was an error saving the question. Please try again."
      render :new  
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.assign_attributes(question_params)
    # @question.title = params[:question][:title]
    # @question.body = params[:question][:body]
    # @question.resolved = params[:question][:resolved]
    puts "The Question Resolved Value is: #{@question.resolved}"
    if @question.save
      flash[:notice] = "Question was updated."
      redirect_to @question
    else
      flash.now[:alert] = "There was an error saving the question. Please try again."
      render :edit
    end
  end

   def destroy
     @question = Question.find(params[:id])
 
 # #8
     if @question.destroy
       flash[:notice] = "\"#{@question.title}\" was deleted successfully."
       redirect_to posts_path
     else
       flash.now[:alert] = "There was an error deleting the question."
       render :show
     end
   end

   private

   def question_params
      params.require(:question).permit(:title, :body, :resolved)
   end


end


