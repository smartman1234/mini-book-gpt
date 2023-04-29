require 'pdf-reader'
require 'csv'
require 'tokenizers'
require 'openai'
require 'dotenv'

Dotenv.load(File.join(File.dirname(__FILE__), '../.env'))

def count_tokens(text)
    $tokenizer ||= Tokenizers.from_pretrained('gpt2')
    return $tokenizer.encode(text).tokens.size
end

def openai_client
    openai_token = ENV['OPENAI_TOKEN']
    $openai_client ||= OpenAI::Client.new(access_token: openai_token)
end

def get_embedding(pdf_text)
    retries = 0
    begin
      response = openai_client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: pdf_text
        }
      )
      embedding = response['data'][0]['embedding']
    rescue StandardError => e
      retries += 1
      if retries <= 3
        puts "An error occurred: #{e}. Retrying..."
        sleep(10)
        retry
      else
        puts "Failed to get embedding after 3 retries"
        return nil
      end
    end
    return embedding
end

pdf_file_path = File.join(File.dirname(__FILE__), '../book.pdf')

CSV.open('embeddings.csv', 'w') do |csv|
    csv << ['Page', 'Text', 'Embedding', 'Tokens']

    PDF::Reader.open(pdf_file_path) do |reader|
        reader.pages.each_with_index do |page, i|
            pdf_text = page.text.delete("\n").squeeze(' ')

            unless pdf_text.empty?
                tokens = count_tokens(pdf_text)
                embedding = get_embedding(pdf_text)
                if embedding.nil?
                    puts "Skipping Page #{i+1}..."
                    next
                end

                csv << ["Page #{i+1}", pdf_text, embedding, tokens]
                puts "DONE with Page #{i+1}"
            end
        end
    end
end
