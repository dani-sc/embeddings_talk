# frozen_string_literal: true

require "httparty"
require "json"

ELEVEN_LABS_API_KEY = "33181304b3d038e9990fa6719b21b178"
VOICE_ID = "2EiwWnXFnvU5JabPnv8n"

input_text = "Auf mir liegen Pilze, so rund und fein, mit Tomatensugo und Mozzarella, das muss so sein. Manchmal gibt's Knoblauch dazu, oh wie fein, oder Trüffelöl für einen Extra-Geschmackskick, ganz allein."

headers = {
  "Accept" => "audio/mpeg",
  "xi-api-key" => ELEVEN_LABS_API_KEY,
  "Content-Type" => "application/json"
}

body = {
  text: input_text,
  model_id: "eleven_multilingual_v2",
  voice_settings: {
    stability: 0.5,
    similarity_boost: 0.75
  }
}.to_json

response = HTTParty.post("https://api.elevenlabs.io/v1/text-to-speech/#{VOICE_ID}", headers:, body:)

File.binwrite("output.mp3", response.body)

puts "Audio wurde in output.mp3 gespeichert."
