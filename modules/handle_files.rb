require 'json'
require_relative 'game_module'

module HandleFiles
  include GamesModule
  # WRITER
  def write_json(array, file_path)
    opts = {
      array_nl: "\n",
      object_nl: "\n",
      indent: '  ',
      space_before: ' ',
      space: ' '
    }
    File.write(file_path, JSON.generate(array, opts))
  end

  # READER
  def read_json(file_path)
    return unless File.exist?(file_path)

    file = File.read(file_path)
    JSON.parse(file)
  end

  def save_author
    array = []
    @authors.each do |author|
      array << {
        author_id: author.id,
        first_name: author.first_name,
        last_name: author.last_name,
        Items: author.items.map do |item|
                 {
                   publish_date: item.publish_date,
                   multiplayer: item.multiplayer,
                   last_played_at: item.last_played_at
                 }
               end
      }
    end
    write_json(array, './JSONdata/authors.json')
  end

  def load_author
    parse_file = read_json('./JSONdata/authors.json')
    parse_file.each do |author|
      person = Author.new(author['first_name'], author['last_name'])
      @authors << person
      author['Items'].each do |item|
        person.add_item(Game.new(item['publish_date'], item['multiplayer'], item['last_played_at']))
      end
    end
  end
end
