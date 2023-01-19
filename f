#создай игру "Лабиринт"!
from pygame import *

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
    def update(self):
        presseds = key.get_pressed()
        if presseds[K_UP] and self.rect.y>5:
            self.rect.y -= self.speed
        if presseds[K_DOWN] and self.rect.y<470:
            self.rect.y += self.speed
        if presseds[K_LEFT] and self.rect.x>5:
            self.rect.x -= self.speed
        if presseds[K_RIGHT] and self.rect.x<680:
            self.rect.x += self.speed

class Enemy(GameSprite):
    def update(self):
        if self.rect.x <= 470:
            self.side = 'right'
        elif self.rect.x >= 630:
            self.side = 'left'

        if self.side == 'left':
            self.rect.x -= self.speed
        else:
            self.rect.x += self.speed

class Wall(sprite.Sprite):
    def __init__(self, rect_x, rect_y, width, height, col1=115, col2=0, col3=0):
        super().__init__()
        self.width = width
        self.height = height

        self.image = Surface((self.width, self.height))
        self.image.fill((col1, col2, col3))

        self.rect = self.image.get_rect()
        self.rect.x = rect_x
        self.rect.y = rect_y
    def reset(self):
        window.blit(self.image, (self.rect.x , self.rect.y))

window = display.set_mode((700, 500))
display.set_caption('догонялки')

background = transform.scale(
    image.load('background.jpg'), (700, 500)
)
window.blit(background, (0, 0))

clock = time.Clock()
fps = 60

font.init()
font = font.Font(None, 70)

win = font.render('YOU WON!', True, (255, 215,0))
lose = font.render('YOU LOSE!', True, (255, 25,0))

mixer.init()
mixer.music.load('jungles.ogg')
kick = mixer.Sound('kick.ogg')
money = mixer.Sound('money.ogg')
mixer.music.play()

p1 = Player('hero.png', 0, 0, 5)
en1 = Enemy('cyborg.png',300, 300, 2 )
wall1 = Wall(0, 350, 550, 20)
wall2 = Wall(300, 0, 400, 20)
wall3 = Wall(530, 110, 20 ,250)

money = GameSprite('treasure.png', 20, 420, 0)


game = True
finish = False
while game:
    for e in event.get():
        if e.type ==  QUIT:
            game = False

    if finish != True:
        window.blit(background, (0, 0))

        money.reset()

        wall1.reset()
        wall2.reset()
        wall3.reset()

        p1.update()
        p1.reset()

        en1.update()
        en1.reset()

        if sprite.collide_rect(p1, wall1) or sprite.collide_rect(p1, wall2) or sprite.collide_rect(p1, wall3)\
                or sprite.collide_rect(p1, en1):
            finish = True
            window.blit(lose, (200, 200))
            kick.play()
        if sprite.collide_rect(p1, money):
            finish = True
            window.blit(win, (200, 200))

    clock.tick(fps)
    display.update()


