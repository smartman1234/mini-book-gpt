require 'tokenizers'
require 'cosine_similarity'
require 'openai'

class QuestionsController < ApplicationController
  before_action :initialize_services, only: [:ask]
  before_action :find_question, only: [:ask]

  def ask
    begin
      if @previous_question
        @previous_question.ask_count += 1
        @previous_question.save

        render json: {
          id: @previous_question.id,
          type: 'cache',
          question: @question,
          answer: @previous_question.answer
        }
      else
        answer_with_context = @openai_service.get_answer(@question)
        if answer_with_context[:error]
          render json: {
            error: answer_with_context[:error]
          }, status: :bad_request
        else
          answer = answer_with_context[:answer]
          context = answer_with_context[:context]

          question_db = Question.create(question: @question, answer: answer, context: context)

          render json: {
            id: question_db.id,
            type: 'network',
            question: @question,
            answer: answer
          }
        end
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
      render json: {
        error: "Internal server error"
      }, status: :internal_server_error
    end
  end

  private
  def initialize_services
    @openai_service = OpenaiService.new
  end

  private
  def find_question
    
    @question = "What is The Minimalist Entrepreneur about?"
    @previous_question = Question.find_by(question: @question)
  end
end
