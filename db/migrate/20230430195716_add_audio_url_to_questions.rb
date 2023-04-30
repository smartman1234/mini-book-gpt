class AddAudioUrlToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :audio_url, :string
  end
end
