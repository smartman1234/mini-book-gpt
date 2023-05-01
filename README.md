# Mini-Book-GPT - https://mini-book-gpt.onrender.com/

Mini-Book-GPT is a Rails app that allows users to ask questions and get answers based on the content of "The Minimalist Entrepreneur" by Sahil Lavingia. The app uses OpenAI API to generate embeddings and answers, React for the frontend, and PostgreSQL for the database.

<img width="753" alt="image" src="https://user-images.githubusercontent.com/91294460/235437535-7c87484b-3285-43e9-a97f-cac584047074.png">

## Features

- Converts "The Minimalist Entrepreneur" `book.pdf` into `embeddings.csv` in the format: `Page, Text, Embedding, Tokens`
- `POST /ask` route to get answers based on the input question
- Stores generated questions and answers in a PostgreSQL database
- React-based frontend to interact with the /ask API
- Cosine similarity to find the most relevant section of the book
- Retry functionality for handling API limits
- OpenAI-service encapsulates request and logic to create a prompt and return an answer
- Error handling for UI and API calls
- I currently don't have a subscription for Resemble AI so I've used a sample one to show how I'd integrate the audio "/test_audio.mp3".

## Architecture Decisions

- Single CSV file for text, embeddings, and tokens for easier access
- Retry functionality in the PDF to embeddings script to handle API limits and incomplete embeddings.csv generation
- OpenAI-service to improve code readability and maintainability
- UI behavior and design decisions to provide a smooth user experience
- Error handling for UI and API calls to prevent blocking and ensure proper error responses

## Things To Improve

- Add tests for frontend and backend to ensure code quality and avoid potential bugs
- Improve prompt generation by using delimiters for sections to provide better context to OpenAI API
- To scale this app I'd like to take benefit of [Pinecone ecosystem within LangChain](https://python.langchain.com/en/latest/ecosystem/pinecone.html)
- Show proper feedback to user if something fails and what went wrong. Currently I handle it silently.
- Bundle and minify Frontend code better. There's lot more I can do to improve it so that it's served faster.


## Deployment

The app is hosted on Render: https://mini-book-gpt.onrender.com/

Please note that it's on the free-tier, so the first request may take some time. After the initial request, the app should work smoothly.

## Getting Started

1. Clone the repository
2. Install dependencies with `bundle install && yarn install`
3. Make sure PostgreSQL is installed on your machine
4. Set up the database with `rails db:create db:migrate`
5. Start the Rails server and React server with `bin/dev`
6. Navigate to http://localhost:3000 in your browser

## License

[MIT](https://choosealicense.com/licenses/mit/)
