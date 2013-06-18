# encoding: utf-8

# Наверное много ошибок (но работает) и кривого использования языковых средств. Дочитаю книжку - перекомичу.

class Song
  attr_accessor :track_number
  attr_reader :title, :author, :album, :length

  def initialize(track_number, title, author, album, length)
    @track_number = track_number
    @title = title
    @author = author
    @album = album
    @length = length
  end
end

class Playlist
  attr_accessor :current_song
  attr_reader :songs

  def initialize(songs = [])
    @songs = songs

    if songs.length > 0
      current_song = 0
    else
      current_song = nil
    end
  end

  def clear
    songs.clear
  end
end

class MusicRecord
  attr_reader :songs

  def initialize(songs = [])
    @songs = songs
  end
end

class GramophoneRecord < MusicRecord
end

class CompactDiskRecord < MusicRecord
end

class JukeBox
  attr_reader :play_list, :song_cost, :turned_on, :balance
  @@income_count = 0.0 #предположим, нужна статистика количества прибыли по всем музыкальным автоматам

  def initialize(turned_on = false, song_cost = 0.0, play_list = Playlist.new)
    @turned_on = turned_on
    @song_cost = song_cost
    @play_list = play_list
    @balance = 0.0
  end

  def self.income_count
    @@income_count
  end

  def press_power_button
    if turned_on
      turned_on = false
    else
      turned_on = true
    end
  end

  def show_balance()
    puts "Баланс музыкального автомата - #{@balance} у.е."
  end

  def pay(income = 0.0)
    if income > 0.0
      @balance += income
      @@income_count += income
    end
  end

  def show_playlist
    song_number = 0
    while song_number < play_list.songs.length      
      puts "#{song_number + 1}.#{play_list.songs[song_number].author} - #{play_list.songs[song_number].title}"
      song_number += 1
    end
  end

  def select_song(song_number)
    if play_list.songs.length >= song_number - 1
      play_list.current_song = song_number - 1
    else
      play_list.current_song = nil
      puts "Такой песни нет в музыкальном автомате"
    end
  end

  def play_song
    if @balance >= @song_cost
      if play_list.current_song != nil
        @balance -= @song_cost

        puts "Слушаем песню \"#{play_list.songs[play_list.current_song].title}\" исполнителя #{play_list.songs[play_list.current_song].author} из альбома \"#{play_list.songs[play_list.current_song].album}\"."

        song_hours = play_list.songs[play_list.current_song].length / 3600
        song_minutes = play_list.songs[play_list.current_song].length / 60
        song_seconds = play_list.songs[play_list.current_song].length % 60

        puts "Прошло #{song_hours}h #{song_minutes}m #{song_seconds}s ..."
      else
        puts "Песня не выбрана"
      end
    else
      puts "На балансе не хватает денег, чтобы прослушать песню"
    end
  end
end

class GramophoneJukeBox < JukeBox
  def initialize(turned_on = false, song_cost = 0.0)
    @turned_on = turned_on
    @song_cost = song_cost
    @play_list = Playlist.new
    @balance = 0.0

    init
  end

  private

    # В этом методе мы заполняем плейлист песнями с дисков, которые находятся в музыкальном автомате.
    # Хардкод, но по задумке, диски находятся внутри автомата. Можно было бы считать их из файла, но время поджимает =)
    # Да и не пользовательское это дело - заполнять музыкальный автомат тестовыми данными.
    def init
      first_disk_songs = Array.new()
      first_disk_songs << Song.new("1", "6.00", "Dream Theater", "Awake", 331)
      first_disk_songs << Song.new("2", "Caught in a Web", "Dream Theater", "Awake", 328)
      first_disk_songs << Song.new("3", "Innocence Faded", "Dream Theater", "Awake", 343)
      first_disk_songs << Song.new("4", "A Mind Beside Itself: I. Erotomania", "Dream Theater", "Awake", 405)
      first_disk_songs << Song.new("5", "A Mind Beside Itself: II. Voices", "Dream Theater", "Awake", 593)
      first_disk_songs << Song.new("6", "A Mind Beside Itself: III. The Silent Man", "Dream Theater", "Awake", 228)
      first_disk_songs << Song.new("7", "The Mirror", "Dream Theater", "Awake", 365)
      first_disk_songs << Song.new("8", "Lie", "Dream Theater", "Awake", 394)
      first_disk_songs << Song.new("9", "Lifting Shadows off a Dream", "Dream Theater", "Awake", 365)
      first_disk_songs << Song.new("10", "Scarred", "Dream Theater", "Awake", 660)
      first_disk_songs << Song.new("11", "Space-Dye Vest", "Dream Theater", "Awake", 449)
      
      # Кто-то перепутал, и положил в отсек музыкального автомата, который проигрывает только пластинки, компакт-диск!!!
      disk1 = CompactDiskRecord.new(first_disk_songs)
      load_disk(disk1)

      # Меняем испорченный диск...
      disk1 = GramophoneRecord.new(first_disk_songs)
      load_disk(disk1)

      second_disk_songs = Array.new()
      second_disk_songs << Song.new("1", "Addicted!", "Devin Townsend Project", "Addicted", 337)
      second_disk_songs << Song.new("2", "Universe in a Ball!", "Devin Townsend Project", "Addicted", 249)
      second_disk_songs << Song.new("3", "Bend It Like Bender!", "Devin Townsend Project", "Addicted", 217)
      second_disk_songs << Song.new("4", "Supercrush!", "Devin Townsend Project", "Addicted", 313)
      second_disk_songs << Song.new("5", "Hyperdrive!", "Devin Townsend Project", "Addicted", 216)
      second_disk_songs << Song.new("6", "Resolve!", "Devin Townsend Project", "Addicted", 192)
      second_disk_songs << Song.new("7", "Ih-Ah!", "Devin Townsend Project", "Addicted", 225)
      second_disk_songs << Song.new("8", "The Way Home!", "Devin Townsend Project", "Addicted", 194)
      second_disk_songs << Song.new("9", "Numbered!", "Devin Townsend Project", "Addicted", 295)
      second_disk_songs << Song.new("10", "Awake!!", "Devin Townsend Project", "Addicted", 584)

      disk2 = GramophoneRecord.new(second_disk_songs)
      load_disk(disk2)
    end

    def load_disk(disk)
      if disk.is_a? GramophoneRecord
        playlist_last_song_number = play_list.songs.length > 0 ? play_list.songs[play_list.songs.length - 1].track_number : 0

        0.upto(disk.songs.length - 1) do |i|
          disk.songs[i].track_number = i + playlist_last_song_number
          play_list.songs << disk.songs[i]
        end
      else
        puts "Умеем проигрывать только пластинки."
      end
    end
end

class CDJukeBox < JukeBox
  def initialize(turned_on = false, song_cost = 0.0)
    @turned_on = turned_on
    @song_cost = song_cost
    @play_list = Playlist.new
    @balance = 0.0

    init
  end

  private

    # В этом методе мы заполняем плейлист песнями с дисков, которые находятся в музыкальном автомате.
    def init
      first_disk_songs = Array.new()
      first_disk_songs << Song.new("1", "Addicted!", "Devin Townsend Project", "Addicted", 337)
      first_disk_songs << Song.new("2", "Universe in a Ball!", "Devin Townsend Project", "Addicted", 249)
      first_disk_songs << Song.new("3", "Bend It Like Bender!", "Devin Townsend Project", "Addicted", 217)
      first_disk_songs << Song.new("4", "Supercrush!", "Devin Townsend Project", "Addicted", 313)
      first_disk_songs << Song.new("5", "Hyperdrive!", "Devin Townsend Project", "Addicted", 216)
      first_disk_songs << Song.new("6", "Resolve!", "Devin Townsend Project", "Addicted", 192)
      first_disk_songs << Song.new("7", "Ih-Ah!", "Devin Townsend Project", "Addicted", 225)
      first_disk_songs << Song.new("8", "The Way Home!", "Devin Townsend Project", "Addicted", 194)
      first_disk_songs << Song.new("9", "Numbered!", "Devin Townsend Project", "Addicted", 295)
      first_disk_songs << Song.new("10", "Awake!!", "Devin Townsend Project", "Addicted", 584)
      
      # Кто-то перепутал, и положил в отсек музыкального автомата, который проигрывает только компакт-диски, граммпластинку!!!
      disk1 = GramophoneRecord.new(first_disk_songs)
      load_disk(disk1)

      # Меняем испорченный диск...
      disk1 = CompactDiskRecord.new(first_disk_songs)
      load_disk(disk1)

      second_disk_songs = Array.new()
      second_disk_songs << Song.new("1", "6.00", "Dream Theater", "Awake", 331)
      second_disk_songs << Song.new("2", "Caught in a Web", "Dream Theater", "Awake", 328)
      second_disk_songs << Song.new("3", "Innocence Faded", "Dream Theater", "Awake", 343)
      second_disk_songs << Song.new("4", "A Mind Beside Itself: I. Erotomania", "Dream Theater", "Awake", 405)
      second_disk_songs << Song.new("5", "A Mind Beside Itself: II. Voices", "Dream Theater", "Awake", 593)
      second_disk_songs << Song.new("6", "A Mind Beside Itself: III. The Silent Man", "Dream Theater", "Awake", 228)
      second_disk_songs << Song.new("7", "The Mirror", "Dream Theater", "Awake", 365)
      second_disk_songs << Song.new("8", "Lie", "Dream Theater", "Awake", 394)
      second_disk_songs << Song.new("9", "Lifting Shadows off a Dream", "Dream Theater", "Awake", 365)
      second_disk_songs << Song.new("10", "Scarred", "Dream Theater", "Awake", 660)
      second_disk_songs << Song.new("11", "Space-Dye Vest", "Dream Theater", "Awake", 449)

      disk2 = CompactDiskRecord.new(second_disk_songs)
      load_disk(disk2)
  end

  def load_disk(disk)
    if disk.is_a? CompactDiskRecord
      playlist_last_song_number = play_list.songs.length > 0 ? play_list.songs[play_list.songs.length - 1].track_number : 0

      0.upto(disk.songs.length - 1) do |i|
        disk.songs[i].track_number = i + playlist_last_song_number
        play_list.songs << disk.songs[i]
      end
    else
      puts "Умеем проигрывать только компакт-диски."
    end
  end
end

# Работаем с музыкальным автоматом-грамофоном
gjb = GramophoneJukeBox.new(false, 0.5)

gjb.press_power_button

gjb.show_balance
gjb.show_playlist

gjb.pay(1.5)
gjb.show_balance

gjb.play_song
gjb.select_song(1)
gjb.play_song

gjb.select_song(10)
gjb.play_song

gjb.select_song(28)
gjb.play_song

gjb.select_song(15)
gjb.play_song

gjb.select_song(1)
gjb.play_song

gjb.show_balance

gjb.press_power_button

# Работаем с музыкальным автоматом - проигрывателем компакт дисков
cdjb = CDJukeBox.new(false, 0.5)

cdjb.press_power_button

cdjb.show_balance
cdjb.show_playlist

cdjb.pay(5.0)
cdjb.show_balance

cdjb.play_song
cdjb.select_song(1)
cdjb.play_song

cdjb.select_song(5)
cdjb.play_song

cdjb.select_song(7)
cdjb.play_song

cdjb.select_song(16)
cdjb.play_song

cdjb.select_song(30)
cdjb.play_song

cdjb.select_song(12)
cdjb.play_song

cdjb.show_balance

cdjb.press_power_button

# Готовим отчет о прибыли
puts "За время использования арендованных музыканьных автоматов прибыль составила #{JukeBox.income_count} у.е."