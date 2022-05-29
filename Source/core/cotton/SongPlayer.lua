class("SongPlayer", {
    currentSong = nil,
    currentSongName = nil,
    volume = 1.0
}).extends()

function SongPlayer:init()
end

function SongPlayer:once(fileName)
    if fileName == self.currentSongName then
        return
    end

    self.currentSongName = fileName
    self.currentSong = playdate.sound.fileplayer.new("sounds/" .. self.currentSongName)
    self.currentSong:setVolume(self.volume)
    self.currentSong:play(1)
end

function SongPlayer:loop(fileName)
    if fileName == self.currentSongName then
        return
    end

    self.currentSongName = fileName
    self.currentSong = playdate.sound.fileplayer.new("sounds/" .. self.currentSongName)
    self.currentSong:setVolume(self.volume)
    self.currentSong:play(0)
end

function SongPlayer:stop()
    self.currentSong:stop()
    self.currentSongName = nil
end
