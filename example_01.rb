# frozen_string_literal: true

require "httparty"
require "json"
require "pry"

HEADERS = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer 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"
}.freeze

class OpenAIChat
  BASE_URL = "https://api.openai.com/v1/chat/completions"

  def self.chat(prompt)
    body = {
      model: "gpt-4",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7
    }.to_json

    response = HTTParty.post(BASE_URL, headers: HEADERS, body:)
    json_response = JSON.parse(response.body)
    json_response["choices"][0]["message"]["content"]
  end
end

query = "Was ist auf einer Pizza Funghi drauf?"

prompt = "Du agierst als Chatbot für unsere Pizzeria und antwortest in kurzen Reimen. " \
         "Du verhältst dich, als ob du eine Pizza wärst, und sprichst in der ersten Person. " \
         "Ein Kunde fragt dich: ### #{query} ### " \
         "Was antwortest du?"
chat_response = OpenAIChat.chat(prompt)
puts chat_response
