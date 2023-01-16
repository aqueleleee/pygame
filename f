#создай игру "Лабиринт"!
from pygame import *

window = display.set_mode((700, 500))
display.set_caption('догонялки')

background = transform.scale(
    image.load('background.jpg'), (700, 500)
)
window.blit(background, (0, 0))

clock = time.Clock()
fps = 60

game = True

mixer.init()
mixer.music.load('jungles.ogg')
mixer.music.play()

class GameSprite(sprite.Sprite):
    def __init__(self, model, cordx, cordy, speed, size=(65, 65)):
        super().__init__()
        self.model =  transform.scale(image.load(model), (size))
        self.rect = self.model.get_rect()
        self.speed = speed
        self.rect.x = cordx
        self.rect.y = cordy
        self.size = size
        

    def reset(self):
        window.blit(self.model, (self.rect.x, self.rect.y))

class Player(GameSprite):

    def go_up(self):
        if presseds[K_UP] and self.rect.y>5:
            self.rect.y -= self.speed

    def go_down(self):
        if presseds[K_DOWN] and self.rect.y<480:
            self.rect.y += self.speed

    def go_left(self):
        if presseds[K_LEFT] and self.rect.x>5:
            self.rect.x -= self.speed

    def go_right(self):
        if presseds[K_RIGHT] and self.rect.x<680:
            self.rect.x += self.speed
    
class Enemy(GameSprite):
    def go_right(self, x):
        while self.rect.x < self.rect.x + x:
            self.rect.x += self.speed


    def go_left(self, x):
        while self.rect.x > self.rect.x - 100:
            self.rect.x -= self.speed


en1 = Enemy('cyborg.png', 180, 300, 2, (80, 80))
p1 = Player('hero.png', 159, 355, 5)

window.blit(background, (0, 0))
while game:
    presseds = key.get_pressed()
    p1.go_right()
    p1.go_up()
    p1.go_down()
    p1.go_left()
    p1.reset()

    for e in event.get():
        if e.type ==  QUIT:
            game = False

    clock.tick(fps)
    display.update()

