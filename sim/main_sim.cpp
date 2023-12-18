// Project F: Racing the Beam - Bounce Verilator C++
// (C)2023 Will Green, open source software released under the MIT License
// Learn more at https://projectf.io/posts/racing-the-beam/

#include <stdio.h>
#include <SDL.h>
#include <verilated.h>
#include "Vtop.h"

// screen dimensions
const int H_RES = 320;
const int V_RES = 180;
const int FRAME_CYCLES_MAX = 1600000;  // 1600000 max number of cycles per frame

typedef struct Pixel {  // for SDL texture
    uint8_t a;  // transparency
    uint8_t b;  // blue
    uint8_t g;  // green
    uint8_t r;  // red
} Pixel;

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        printf("SDL init failed.\n");
        return 1;
    }

    Pixel screenbuffer[H_RES*V_RES];

    SDL_Window*   sdl_window   = NULL;
    SDL_Renderer* sdl_renderer = NULL;
    SDL_Texture*  sdl_texture  = NULL;

    sdl_window = SDL_CreateWindow("Bounce", SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED, H_RES, V_RES, SDL_WINDOW_SHOWN);
    if (!sdl_window) {
        printf("Window creation failed: %s\n", SDL_GetError());
        return 1;
    }

    sdl_renderer = SDL_CreateRenderer(sdl_window, -1,
        SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!sdl_renderer) {
        printf("Renderer creation failed: %s\n", SDL_GetError());
        return 1;
    }

    sdl_texture = SDL_CreateTexture(sdl_renderer, SDL_PIXELFORMAT_RGBA8888,
        SDL_TEXTUREACCESS_TARGET, H_RES, V_RES);
    if (!sdl_texture) {
        printf("Texture creation failed: %s\n", SDL_GetError());
        return 1;
    }

    // reference SDL keyboard state array: https://wiki.libsdl.org/SDL_GetKeyboardState
    const Uint8 *keyb_state = SDL_GetKeyboardState(NULL);

    printf("Simulation running. Press 'Q' in simulation window to quit.\n\n");

    // initialize Verilog module
    Vtop* top = new Vtop;

    // initialize inputs
    top->mclk = 0;
    top->clr = 0;
    top->center = 0;
    top->up = 0;
    top->down = 0;
    top->left = 0;
    top->right = 0;
    top->start_frame = 0;

    // reset
    top->clr = 1;
    top->mclk = 0;
    top->eval();
    top->mclk = 1;
    top->eval();
    top->clr = 0;
    top->mclk = 0;
    top->eval();

    // initialize frame rate
    uint64_t start_ticks = SDL_GetPerformanceCounter();
    uint64_t frame_count = 0;
    uint32_t frame_cycles = 0;

    bool left_pressed = false;
    bool right_pressed = false;
    bool up_pressed = false;
    bool down_pressed = false;
    bool space_pressed = false;

    // main loop
    while (1) {
        // cycle the clock
        top->mclk = 1;
        top->eval();
        top->mclk = 0;
        top->eval();
        top->start_frame = 0;


        // update pixel if valid
        if (top->pixel_valid) {
          uint16_t x = top->pixel_x;
          uint16_t y = top->pixel_y;
          // ensure pixel is within screen bounds
          if (x < H_RES && y < V_RES) {
            Pixel* p = &screenbuffer[y*H_RES + x];
            p->a = 0xFF;  // transparency
            // color is 4 bit, so shift to get full range
            p->b = top->b << 4;
            p->g = top->g << 4;
            p->r = top->r << 4;
          } else {
            printf("Pixel out of bounds: %d, %d\n", x, y);
          }
        }

        // update texture once per frame (when frame_done goes high) or when the frame times out
        bool timed_out = frame_cycles >= FRAME_CYCLES_MAX;
        if (top->frame_done || timed_out) {
            // check for quit event and keyboard input
            SDL_Event e;
            while (SDL_PollEvent(&e)) {
                if (e.type == SDL_QUIT) {
                    break;
                } else if (e.type == SDL_KEYDOWN) {
                    switch (e.key.keysym.sym) {
                        case SDLK_LEFT:
                            left_pressed = true;
                            break;
                        case SDLK_RIGHT:
                            right_pressed = true;
                            break;
                        case SDLK_UP:
                            up_pressed = true;
                            break;
                        case SDLK_DOWN:
                            down_pressed = true;
                            break;
                        case SDLK_SPACE:
                            space_pressed = true;
                            break;
                    }
                } else if (e.type == SDL_KEYUP) {
                    switch (e.key.keysym.sym) {
                        case SDLK_LEFT:
                            left_pressed = false;
                            break;
                        case SDLK_RIGHT:
                            right_pressed = false;
                            break;
                        case SDLK_UP:
                            up_pressed = false;
                            break;
                        case SDLK_DOWN:
                            down_pressed = false;
                            break;
                        case SDLK_SPACE:
                            space_pressed = false;
                            break;
                    }
                }

                // update inputs
                top->center = space_pressed;
                top->up = up_pressed;
                top->down = down_pressed;
                top->left = left_pressed;
                top->right = right_pressed;
            }

            if (keyb_state[SDL_SCANCODE_Q]) break;  // quit if user presses 'Q'

            SDL_UpdateTexture(sdl_texture, NULL, screenbuffer, H_RES*sizeof(Pixel));
            SDL_RenderClear(sdl_renderer);
            SDL_RenderCopy(sdl_renderer, sdl_texture, NULL, NULL);
            SDL_RenderPresent(sdl_renderer);

            if (timed_out) {
              printf("Frame timed out.\n");
            } else {
              printf("Frame %lu done in %u cycles.\n", frame_count, frame_cycles);
            }
            frame_count++;
            frame_cycles = 0;

            // request new frame
            top->start_frame = 1;
        }


        frame_cycles++;
    }

    // calculate frame rate
    uint64_t end_ticks = SDL_GetPerformanceCounter();
    double duration = ((double)(end_ticks-start_ticks))/SDL_GetPerformanceFrequency();
    double fps = (double)frame_count/duration;
    printf("Frames per second: %.1f\n", fps);

    top->final();  // simulation done

    SDL_DestroyTexture(sdl_texture);
    SDL_DestroyRenderer(sdl_renderer);
    SDL_DestroyWindow(sdl_window);
    SDL_Quit();
    return 0;
}