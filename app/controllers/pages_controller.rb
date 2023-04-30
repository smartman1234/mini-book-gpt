class PagesController < ApplicationController
  def home
    @question = Question.find_by(id: params[:id])
    if @question
      @serialized_question = {
        id: @question.id,
        question: @question.question,
        answer: @question.answer
      }.to_json
    end
  end
end
