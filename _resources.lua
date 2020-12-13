--Carrega todos os recursos do jogo

--recursos (imagens)
playerShipImg = love.graphics.newImage("resource/image/spritesheet/player-ship.png")
backgroundImgs = {
	love.graphics.newImage("resource/image/background/game-background.png"),
	love.graphics.newImage("resource/image/background/stage-1.png"),
	love.graphics.newImage("resource/image/background/stage-2.png"),
	love.graphics.newImage("resource/image/background/stage-3.png"),
	love.graphics.newImage("resource/image/background/stage-bonus.png")
}
meteorImg1 = love.graphics.newImage("resource/image/sprite/meteor-1.png")
laserBoltsImg = love.graphics.newImage("resource/image/spritesheet/laser-bolts.png")
healthBarImg = love.graphics.newImage("resource/image/sprite/health-bar.png")
enemyShotImgs = {
	love.graphics.newImage("resource/image/sprite/shot.png")
}
enemyImgs = {
	love.graphics.newImage("resource/image/sprite/ship-1.png"),
	love.graphics.newImage("resource/image/sprite/ship-2.png"),
	love.graphics.newImage("resource/image/sprite/ship-3.png")
}
--

--recursos(fontes)
fontImg = love.graphics.newImageFont( "resource/image/font/font-20x20.png",
	" !\"#$%&'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[\\]^_{|}~ABCDEFGHIJKLMNOPQRSTUVWXYZ")
fontTitleImg = love.graphics.newImageFont( "resource/image/font/title-font.png",
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
--

--recursos(sons)
soundShot1 = love.audio.newSource("resource/sound/shot1.wav", "static")
soundShot2 = love.audio.newSource("resource/sound/shot2.wav", "static")
soundHit = love.audio.newSource("resource/sound/hit.wav", "static")
soundCrash = love.audio.newSource("resource/sound/asteroid-crash.mp3", "static")
soundDeath = love.audio.newSource("resource/sound/death.wav", "static")
gameSoundtrack = love.audio.newSource("resource/music/game-soundtrack.ogg", "stream")
menuSoundtrack = love.audio.newSource("resource/music/menu-soundtrack.ogg", "stream")
introSoundtrack = love.audio.newSource("resource/music/intro-soundtrack.ogg", "stream")
endSoundtrack = love.audio.newSource("resource/music/end-soundtrack.ogg", "stream")
--