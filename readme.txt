PROJECT:         SUPER MARIO BROS (Assembly x86)
COURSE:          Computer Organization & Assembly Language
NAME:		 Waseed e Mustafa

1. PROJECT DESCRIPTION

This project is a complete recreation of "Super Mario Bros" developed in x86 Assembly Language (MASM) using the Irvine32 library. It features a custom-built physics engine, side-scrolling gameplay (via page flipping), 
enemy AI, a boss battle, and a fully integrated audio system.

The game is optimized for stability and demonstrates advanced assembly concepts such as memory management, collision detection, and Windows API 
integration for sound.

2. GAMEPLAY & LEVEL PROGRESSION

The game features a continuous progression system where the player maintains
their Score and Lives across levels.

> LEVEL 1: WORLD 1-1 (The Beginning)
  - Standard platforming with Goombas.
  - Introduces basic mechanics: Jumping, Coins, and Power-ups.

> LEVEL 2: WORLD 1-2 (The Underground)
  - Features darker visuals and Koopa Troopas.
  - Contains a Secret Room (Page 5) accessed via hidden mechanics.
  - Contains the Golden Mushroom (Roll No Feature).

> LEVEL 4: WORLD 1-4 (Castle Fortress)
  - The final boss stage with lava pits (Instant Death) and darker theme.
  - Boss Fight: Bowser (AI jumps, moves, and shoots fireballs).
  - Win Condition: Reach the Axe ('P') behind Bowser to collapse the bridge.

3. CONTROLS

  [ W ]  : Jump
  [ A ]  : Move Left
  [ S ]  : Go Underground
  [ D ]  : Move Right
  [ P ]  : Pause Game / Resume
  [ ESC] : Exit / Pause Menu

4. IMPLEMENTED FEATURES (Rubric Compliance)

[1] ROLL NUMBER CUSTOMIZATION (Ends in 0):
    - "Super Power Mario": Player starts with 5 Lives (instead of 3).
    - "Golden Mushroom": A special Yellow 'M' found in Levels 2 & 4.
      Effect: Grants 1000 Points + 10 Seconds of Invincibility (Kill enemies on touch).

[2] FREE CREATIVE FEATURE (20 Marks):
    - "Slow Motion Mode" (The Stopwatch):
      A Cyan 'S' item found in levels (e.g., Level 1 Page 1 & 2).
      Effect: Collecting it slows down the entire game logic (Gravity, Enemies, Projectiles) for 10 seconds, allowing precision movement.

[3] SCORING SYSTEM (Per Project Document):
    - Coins: 200 Points each.
    - Enemy Kill: 100 Points.
    - Flagpole: Variable Score based on height (Top: 5000, Mid: 2000, Low: 100).
    - Time Bonus: Remaining Time x 50 added to score upon level completion.

[4] SOUND SYSTEM:
    - Background Music: Continuous looping music for Intro, Overworld, and Underground.
    - Sound Effects: Overlapping SFX for Jumps, Kills, Coins, and Winning.
    - Technology: Uses Windows MCI (winmm.lib) for high-quality audio.

[5] FILE HANDLING:
    - High Scores: Top 10 scores are saved to "highscores.dat".
    - Data Persistence: Names and scores are sorted and stored automatically.
    - If name is not entered then it will show "Player" instead on name.

5. HOW TO RUN

1. Open the project in Visual Studio (configured for MASM).
2. Verify that the following Audio Files are present in the 
   same folder as the generated .exe (Debug folder):
     - intro.wav
     - theme.wav
     - under.wav
     - mario_jump.wav
     - kill.wav
     - coin.wav
     - gameover.wav
     - win.wav
3. Build the solution and Run.

6. DEVELOPMENT NOTES

- The game uses a "Page Flipping" scrolling mechanic. Moving to the right
  edge of the screen loads the next section of the level.
- Level 4 (Castle) disables the ground floor rendering to simulate a
  dangerous bridge over lava.
- Bowser's AI is designed to track the player's X coordinate and fire
  projectiles periodically.
- You cannot defeat the boss just by jumping on it but you have to dodge the boss and collect the axe.