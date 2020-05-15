push = require 'push'

Class = require 'class'

require 'Ball'

require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


function love.load()

    love.graphics.setDefaultFilter('nearest','nearest')
    smallFont = love.graphics.newFont('font.ttf',8)
    scoreFont = love.graphics.newFont('font.ttf',32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT ,{

        fullscreen = false,
        resizable = false,
        vsync = true
    })
    
    player1Score = 0
    player2Score = 0
    servingplayer = 1
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2,4,4)
    paddle1 = Paddle(70,30,5,70)
    paddle2 = Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)
    paddle3 = Paddle(10,3,5,70)
    paddle4 = Paddle(10,VIRTUAL_HEIGHT-80,5,80)
    gameState = 'start'
    paddle1.dy = PADDLE_SPEED
end
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end    
end

function love.update(dt)
    
    if gameState == 'play' then
        if ball:collides(paddle1) then
            ball.dx = -1.03 * ball.dx
            if ball.x > paddle1.x then
                ball.x = ball.x + 5
            else
                ball.x = ball.x - 4
            end
        end

        if ball:collides(paddle2) then
            ball.dx = -1.03 * ball.dx
            ball.x = ball.x - 4
        end

        if ball:collides(paddle3) then
            ball.dx = -1.03 * ball.dx
            ball.x = ball.x + 5
        end

        if ball:collides(paddle4) then
            ball.dx = -1.03 * ball.dx
            ball.x = ball.x + 5
        end

        if ball.y < 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
    
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        if ball.x < 0 then
            player2Score = player2Score + 1
            ball:reset()
            gameState = 'start'
        end

        if ball.x > VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            ball:reset()
            gameState = 'start'
        end
    end
    -- if love.keyboard.isDown('w') then
    --     paddle1.dy = -PADDLE_SPEED
    -- elseif love.keyboard.isDown('s') then
    --     paddle1.dy = PADDLE_SPEED
    -- else 
    --     paddle1.dy = 0
    -- end
    if paddle1.y == VIRTUAL_HEIGHT - paddle1.height then
        paddle1.dy = -PADDLE_SPEED
    elseif paddle1.y == 0 then
        paddle1.dy = PADDLE_SPEED
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end
    if gameState == 'play' then
        ball:update(dt)
    end
    paddle1:update(dt)
    paddle2:update(dt)
end
function love.draw()
    push:apply('start')
    love.graphics.clear(40,45,52,255)
    love.graphics.setFont(smallFont)
    love.graphics.setFont(scoreFont)
    if gameState == 'start' then
        love.graphics.printf('Press Enter', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Your Score!', 0, 2, VIRTUAL_WIDTH, 'center')
    end
    --love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        --VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
    ball:render()
    paddle1:render()
    paddle2:render()
    paddle3:render()
    paddle4:render()
    push:apply('end')
end