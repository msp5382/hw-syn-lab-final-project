/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include <stdint.h>
#include <stdbool.h>

#define left_paddle (*(volatile uint32_t*)0x04000000)
#define right_paddle (*(volatile uint32_t*)0x05000000)

#define ball_x (*(volatile uint32_t*)0x06000000)
#define ball_y (*(volatile uint32_t*)0x07000000)

#define btn_up (*(volatile uint32_t*)0x08000000)
#define btn_down (*(volatile uint32_t*)0x09000000)
#define btn_left (*(volatile uint32_t*)0x0A000000)
#define btn_right (*(volatile uint32_t*)0x0B000000)


/* Private functions */
static void screen(void);

#define GAME_DELAY   5000
#define PADDLE_HEIGHT 50
static uint32_t delay = GAME_DELAY;

void main()
{
	left_paddle = 0x0;
    right_paddle = 0x0;
    ball_x = 0x0;
    ball_y = 0x0;
	while (1)
	{
        screen();
    }
}

static void screen(void)
{
    --delay;
    if (delay == 0)
    {
        delay = GAME_DELAY;

        // game loop
        // Update paddle positions based on button inputs
        if(btn_up == 1 && left_paddle > PADDLE_HEIGHT)
            left_paddle--;
        if(btn_down == 1 && left_paddle < 480 - PADDLE_HEIGHT)
            left_paddle++;

        if(btn_left == 1 && right_paddle > PADDLE_HEIGHT)
            right_paddle--;
        if(btn_right == 1 && right_paddle < 480 - PADDLE_HEIGHT)
            right_paddle++;
        

        // // Update ball position based on last position and direction
        // // Ball movement variables
        // static int ball_dx = 1;
        // static int ball_dy = 1;
        // static const int max_x = 640;
        // static const int max_y = 480;
        // static const int paddle_width = 10;
        // static const int paddle_height = 50;

        // // Update ball position
        // ball_x += ball_dx;
        // ball_y += ball_dy;

        // // Check for collisions with walls
        // if (ball_x <= 0 || ball_x >= max_x)
        //     ball_dx = -ball_dx;
        // if (ball_y <= 0 || ball_y >= max_y)
        //     ball_dy = -ball_dy;

        // // Check for collisions with paddles
        // if ((ball_dx < 0 && ball_x <= left_paddle + paddle_width && ball_y >= left_paddle && ball_y <= left_paddle + paddle_height) ||
        //     (ball_dx > 0 && ball_x >= right_paddle - paddle_width && ball_y >= right_paddle && ball_y <= right_paddle + paddle_height))
        // {
        //     ball_dx = -ball_dx;
        // }
    }
}




