module Viki
  class Movie
    def initialize(json)
      @id = json["id"]
      @title = json["title"]
      @description = json["description"]
      @created_at = json["created_at"]
      @uri = json["uri"]
      @origin_country = json["origin_country"]
      @image = json["image"]
      @formats = json["formats"]
      @subtitles = json["subtitles"]
      @genres = json["genres"]
    end

    attr_reader :id, :title, :description, :created_at, :uri, :origin_country, :image, :formats,
                :subtitles, :genres
  end
end
