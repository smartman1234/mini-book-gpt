require "tokenizers"
require "cosine_similarity"
require "openai"

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
          type: "cache",
          question: @question,
          answer: @previous_question.answer,
          audio_url: @previous_question.audio_url
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

          # Here I'd use Resemble AI api to fetch the audio file for the answer.
          # I currently don't have a subscription so I've used a sample one to
          # show I'd integrate the audio
          audio_url = "/test_audio.mp3"

          question_db = Question.create(
            question: @question,
            answer: answer,
            context: context,
            audio_url: audio_url
          )

          render json: {
            id: question_db.id,
            type: "network",
            question: @question,
            answer: answer,
            audio_url: audio_url
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
    @question = question_params[:question]
    @previous_question = Question.find_by(question: @question)
  end

  private
  def question_params
    params.permit(:question)
  end
end
