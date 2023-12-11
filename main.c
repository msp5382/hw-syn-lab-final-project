#include <stdint.h>
#include <stdbool.h>
#include <math.h>

#define left_paddle (*(volatile uint32_t*)0x04000000)
#define right_paddle (*(volatile uint32_t*)0x05000000)

#define ball_x (*(volatile uint32_t*)0x06000000)
#define ball_y (*(volatile uint32_t*)0x07000000)

#define btn_up (*(volatile uint32_t*)0x08000000)
#define btn_down (*(volatile uint32_t*)0x09000000)
#define btn_left (*(volatile uint32_t*)0x0A000000)
#define btn_right (*(volatile uint32_t*)0x0B000000)

#define p1_score_d1 (*(volatile uint32_t*)0x0C000000)
#define p1_score_d2 (*(volatile uint32_t*)0x0D000000)
#define p2_score_d1 (*(volatile uint32_t*)0x0E000000)
#define p2_score_d2 (*(volatile uint32_t*)0x0F000000)

/* Private functions */
static void screen(void);

#define GAME_DELAY   4000
#define BALL_DELAY   6000
#define PADDLE_HEIGHT 50
#define PADDLE_WIDTH 10
#define MAX_X 640
#define MAX_Y 480
static uint32_t delay = GAME_DELAY;
static uint32_t ball_delay = BALL_DELAY;
static int ball_dx = 1;
static int ball_dy = 1;

void main()
{
	left_paddle = 25;
    right_paddle = 25;
    ball_x = 100;
    ball_y = 100;
    p1_score_d1 = 0;
    p1_score_d2 = 0;
    p2_score_d1 = 0;
    p2_score_d2 = 0;
	while (1)
	{
        screen();
    }
}

bool is_ball_from_left(void)
{
    return ball_dx < 0;
}

bool is_ball_from_right(void)
{
    return ball_dx > 0;
}

bool is_ball_collide_paddle_left(void)
{
    return ball_x <= 15 && (ball_y >= left_paddle && ball_y <= left_paddle + PADDLE_HEIGHT); // magic number
}

bool is_ball_collide_paddle_right(void)
{
    return ball_x >= 615 && (ball_y >= right_paddle && ball_y <= right_paddle + PADDLE_HEIGHT); // magic number
}

void increase_p1_score(void)
{
    p1_score_d2++;
    if (p1_score_d2 > 9)
    {
        p1_score_d2 = 0;
        p1_score_d1++;
    }
}

void increase_p2_score(void)
{
    p2_score_d2++;
    if (p2_score_d2 > 9)
    {
        p2_score_d2 = 0;
        p2_score_d1++;
    }
}

static void screen(void)
{
    --delay;
    --ball_delay;
    
    if (ball_delay == 0)
    {
        ball_delay = BALL_DELAY;
        ball_x += ball_dx;
        ball_y += ball_dy;
    }

    if (delay == 0)
    {
        delay = GAME_DELAY;

        if(p1_score_d1 == 9 && p1_score_d2 == 9)
        {
            p1_score_d1 = 0;
            p1_score_d2 = 0;
            p2_score_d1 = 0;
            p2_score_d2 = 0;
        }

        if(p2_score_d1 == 9 && p2_score_d2 == 9)
        {
            p1_score_d1 = 0;
            p1_score_d2 = 0;
            p2_score_d1 = 0;
            p2_score_d2 = 0;
        }

        // game loop
        // Update paddle positions based on button inputs
        if(btn_up == 1 && left_paddle > 0)
            left_paddle--;
        if(btn_down == 1 && left_paddle < 480 - PADDLE_HEIGHT)
            left_paddle++;

        if(btn_left == 1 && right_paddle > 0)
            right_paddle--;
        if(btn_right == 1 && right_paddle < 480 - PADDLE_HEIGHT)
            right_paddle++;
        
        // ball_x++;
        // if(ball_x > 640)
        //     ball_y++;
        //     ball_x = 0;
            
        // if(ball_y > 480)
        //     ball_y = 0;



        // if (ball_x <= 0 || ball_x >= max_x)
        //     ball_dx = -ball_dx;
        if (ball_y <= 25 || ball_y >= MAX_Y)
            ball_dy = -ball_dy;

        // check for paddle collision from left direction
        if (is_ball_from_left() && is_ball_collide_paddle_left())
            ball_dx = -ball_dx;

        // check for paddle collision from right direction
        if (is_ball_from_right() && is_ball_collide_paddle_right())
            ball_dx = -ball_dx;
        
        if (ball_x <= 0 || ball_x >= MAX_X)
        {
            if(is_ball_from_left())
                increase_p2_score();
            else
                increase_p1_score();
            // filp the ball
            ball_dx = -ball_dx;
            // spawn the ball in the middle
            ball_x = MAX_X / 2;
            ball_y = MAX_Y / 2;
        }
    }
}




