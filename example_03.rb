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

class OpenAiEmbedding
  BASE_URL = "https://api.openai.com/v1/embeddings"

  def self.get_embedding(text)
    body = { input: text, model: "text-embedding-ada-002" }.to_json
    response = HTTParty.post(BASE_URL, headers: HEADERS, body:)
    json_response = JSON.parse(response.body)
    json_response["data"][0]["embedding"]
  end

  def self.cosine_similarity(vec1, vec2)
    dot_product = vec1.zip(vec2).sum { |v1, v2| v1 * v2 }
    magnitude1 = Math.sqrt(vec1.sum { |v| v**2 })
    magnitude2 = Math.sqrt(vec2.sum { |v| v**2 })

    dot_product / (magnitude1 * magnitude2)
  end

  def self.find_most_similar_paragraph(query_embedding, paragraphs)
    best_paragraph = nil
    best_similarity = -Float::INFINITY

    paragraphs.each do |paragraph|
      paragraph_embedding = OpenAiEmbedding.get_embedding(paragraph)
      similarity = OpenAiEmbedding.cosine_similarity(query_embedding, paragraph_embedding)

      if similarity > best_similarity
        best_similarity = similarity
        best_paragraph = paragraph
      end
    end

    best_paragraph
  end
end

# rubocop:disable Metrics/LineLength
paragraphs = [
  "Pizza, ein kulinarisches Geschenk aus Italien, ist weltweit bekannt für ihre köstliche Kombination aus knusprigem Teig, schmelzendem Käse und vielfältigen Belägen.",
  "Unsere Margherita-Pizza wird traditionell mit frischem Tomatensugo, Mozzarella und Basilikum hergestellt. Es wird gesagt, dass sie nach der Königin Margherita von Savoyen benannt wurde, wobei die Farben Rot, Weiß und Grün die italienische Flagge repräsentieren.",
  "Für die Fleischliebhaber gibt es die Pizza Salami, reichlich belegt mit pikanter Salami, Tomatensugo und Mozzarella. Manchmal fügen wir auch ein paar Chiliflocken hinzu, um etwas Wärme zu erzeugen.",
  "Die Pizza Funghi besteht aus saftigen Champignons, Tomatensugo und Mozzarella. Manchmal wird sie mit Knoblauch oder Trüffelöl verfeinert, um einen zusätzlichen Geschmackskick zu geben.",
  "Für diejenigen, die das Meer lieben, haben wir die Pizza Frutti di Mare. Sie wird mit einer Mischung aus Meeresfrüchten wie Garnelen, Muscheln und Tintenfisch zubereitet, alle frisch und mit einer Zitronennote verfeinert.",
  "Die Pizza Vegetariana ist eine farbenfrohe Mischung aus frischem Gemüse wie Paprika, Zwiebeln, Oliven und Brokkoli. Sie ist nicht nur lecker, sondern auch gesund!"
]
# rubocop:enable Metrics/LineLength

query = "Was ist auf einer Pizza Funghi drauf?"
query_embedding = OpenAiEmbedding.get_embedding(query)

best_paragraph = OpenAiEmbedding.find_most_similar_paragraph(query_embedding, paragraphs)
puts "Relevantester Absatz: #{best_paragraph}"
