# frozen_string_literal: true

require "httparty"
require "json"

ELEVEN_LABS_API_KEY = "33181304b3d038e9990fa6719b21b178"
VOICE_ID = "2EiwWnXFnvU5JabPnv8n"

input_text = "Ich, eine Pizza Funghi, bestehe aus saftigen Champignons, Tomatensugo und Mozzarella."

default_settings_response = HTTParty.get(
  "https://api.elevenlabs.io/v1/voices/settings/default",
  headers: { "Accept" => "application/json" }
)
settings = default_settings_response.parsed_response
stability = settings["stability"]
similarity_boost = settings["similarity_boost"]

headers = {
  "Accept" => "audio/mpeg",
  "xi-api-key" => ELEVEN_LABS_API_KEY,
  "Content-Type" => "application/json"
}

body = {
  text: input_text,
  model_id: "eleven_multilingual_v2",
  voice_settings: {
    stability:,
    similarity_boost:
  }
}.to_json

response = HTTParty.post("https://api.elevenlabs.io/v1/text-to-speech/#{VOICE_ID}", headers:, body:)

File.binwrite("output.mp3", response.body)

puts "Audio wurde in output.mp3 gespeichert."
