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

// #define reg_leds (*(volatile uint32_t*)0x03000000)
#define reg_seg (*(volatile uint32_t*)0x04000000)
// #define reg_w_reen (*(volatile uint32_t*)0x07000000)
#define w_x_buf (*(volatile uint32_t*)0x05000000)
#define w_y_buf (*(volatile uint32_t*)0x06000000)
#define HD 640
#define VD 480

// --------------------------------------------------------

/* Private functions */
static void screen(void);

#define LED_DELAY   242338  // Equivalent to 0.125 secs
static uint32_t delay = LED_DELAY;
// static uint16_t color = 0x0FA;

void main()
{
	// reg_leds = 0x0;
	reg_seg = 0x0; // Initialize segment display
    w_y_buf = 0x0;
    w_x_buf = 0x0;
	while (1)
	{
        w_y_buf++
        if (w_y_buf == VD)
        {
            w_y_buf = 0;
        }
        w_x_buf++
        if (w_x_buf == HD)
        {
            w_x_buf = 0;
        }
    }


// static void screen(void)
// {
//     --delay;
//     if (delay == 0)
//     {
//         delay = LED_DELAY;
//         reg_seg = reg_seg + 1;
//         if (reg_seg == 0x100)
//         {
//             reg_seg = 0x0;
//         }
//     }
// }