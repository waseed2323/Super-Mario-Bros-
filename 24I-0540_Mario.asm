INCLUDE Irvine32.inc

INCLUDELIB winmm.lib

mciSendStringA PROTO STDCALL :PTR BYTE, :PTR BYTE, :DWORD, :DWORD

.data

; ============================================
; SCREEN CONSTANTS
; ============================================
SCREEN_WIDTH = 80
SCREEN_HEIGHT = 25
GROUND_LEVEL = 21 

; ============================================
; COLOR DEFINITIONS
; ============================================
SKY_COLOR = white + (lightBlue * 16)
GROUND_COLOR = white + (green * 16)
MARIO_COLOR = blue + (lightBlue * 16) 
PLATFORM_COLOR = white + (brown * 16) 
PIPE_COLOR = white + (green * 16) 
BRICK_COLOR = white + (brown * 16) 
QUESTION_COLOR = yellow + (brown * 16) 
CLOUD_COLOR = white + (lightBlue * 16) 
COIN_COLOR = yellow + (lightBlue * 16) 
UNDERGROUND_COLOR = black + (red * 16) 
CASTLE_SKY_COLOR = black + (black * 16) 
CASTLE_WALL_COLOR = white + (gray * 16) 
CASTLE_GROUND_COLOR = white + (gray * 16) 
LAVA_COLOR = red + (black * 16) 
BOWSER_COLOR = green + (black * 16) 
AXE_COLOR = yellow + (black * 16) 

; ============================================
; STRINGS
; ============================================
strScore BYTE "Score: ",0
strCoins BYTE "Coins: ",0
strWorld BYTE "World: ",0
strTimer BYTE "Time: ",0
strLives BYTE "Lives: ",0
strRollNumber BYTE "Roll Number: 24I-0540",0
strTitle BYTE "SUPER MARIO BROS",0
strStart        BYTE "1. Start Game",0
strHighScore    BYTE "2. High Score",0
strLevels       BYTE "3. Select Level",0
strInstMenu     BYTE "4. Instructions",0
strExit         BYTE "5. Exit Game",0
strInstructions BYTE "Instructions",0
strPaused BYTE "PAUSED",0
strResume BYTE "1. Resume Game",0
strNewGame BYTE "2. New Game",0
strPauseExit BYTE "3. Exit",0
strPressKey BYTE "Press any key to continue...",0
strGameOver BYTE "GAME OVER",0
strGameOverReturn BYTE "1. Return to Main Menu",0
strGameOverExit BYTE "2. Exit Game",0
strLevelPassed BYTE "LEVEL PASSED!",0
strMovingToNext BYTE "Moving to next level...",0
strAllLevelsComplete BYTE "All Levels Complete!",0
strPressAnyKey BYTE "Press any key to continue...",0
strTimeBonus BYTE " Time Bonus",0
strEnterName BYTE "Enter your name: ",0
strLevelStart BYTE "Starting Level ",0
strNoHighScores BYTE "No high scores yet!",0

strInstTitle    BYTE "=== HOW TO PLAY ===",0
strControlsHead BYTE "-- CONTROLS --",0
strCtrlW        BYTE " W : Jump",0
strCtrlA        BYTE " A : Move Left",0
strCtrlS        BYTE " S : Enter Underground",0
strCtrlD        BYTE " D : Move Right",0
strCtrlP        BYTE " P : Pause Game",0
strMechHead     BYTE "-- MECHANICS --",0
strMechUnder    BYTE " - Stand on special Platforms & Press 'S' to go Underground!",0
strMechKill     BYTE " - Jump on Enemies to defeat them.",0
strMechGoal     BYTE " - Touch Flagpole (World 1/2) or Axe (Castle) to Win.",0
strItemHead     BYTE "-- SPECIAL ITEMS --",0
strItemGold     BYTE " [M] Golden Mushroom : Invincibility (Kill on touch) + Points",0
strItemSlow     BYTE " [S] Cyan Stopwatch  : Slow Motion Mode (10 Seconds)",0
strInstExit     BYTE "Press any key to return to Main Menu...",0

; ============================================
; PLAYER DATA
; ============================================
playerName BYTE 50 DUP(0) 
playerNameLength DWORD 0  

; ============================================
; GAME STATE
; ============================================
score DWORD 0
coins BYTE 0
world BYTE 1
level BYTE 1 
timer DWORD 90 
timerCounter BYTE 0 
lives BYTE 5
max_levels = 5 

; ============================================
; HIGH SCORE SYSTEM
; ============================================
highScore DWORD 0
highScoreName BYTE 50 DUP(0) 

max_highScores = 10
highScores DWORD max_highScores DUP(0) 
highScoreNames BYTE max_highScores * 50 DUP(0) 
numHighScores DWORD 0 
highScoreFileName BYTE "highscores.dat",0
scoreString BYTE 20 DUP(0)  
fileHandle DWORD ?  
colonStr BYTE ":",0
newlineStr BYTE 0Dh, 0Ah, 0  
fileLineBuffer BYTE 100 DUP(0)  

buffer          BYTE 5000 DUP(?) 
charBuf         BYTE ?           
currentName     BYTE 50 DUP(?)   
currentScoreStr BYTE 20 DUP(?)   
bytesRead       DWORD ?
strColon        BYTE ":",0
strNewLine      BYTE 0Dh,0Ah,0   

; ============================================
; GAME FLAGS AND STATE
; ============================================
isPaused BYTE 0
isJumping BYTE 0
jumpHeight BYTE 0
currentJump BYTE 0
gameOver DWORD 0 
levelPassed BYTE 0 

; ============================================
; FLAGPOLE & COMPLETION DATA
; ============================================
flagpoleX BYTE 75
flagpoleY BYTE 20
isSliding BYTE 0 

; ============================================
; GAME AREA BOUNDARIES
; ============================================
GAME_LEFT_WALL = 0
GAME_RIGHT_WALL = 77
GAME_TOP = 1
GAME_BOTTOM = 20
GROUND_START = 21
GROUND_END = 22 

; ============================================
; PLAYER POSITION
; ============================================
xPos BYTE 10
yPos BYTE 15 
marioFacingDirection BYTE 1 

; ============================================
; COIN SYSTEM
; ============================================
numCoins BYTE 10 
coinX BYTE 10 DUP(?) 
coinY BYTE 10 DUP(?) 
coinActive BYTE 10 DUP(1) 

inputChar BYTE ?

; ============================================
; RUNTIME ARRAY CAPACITIES
; ============================================
numPlatforms_init = 3        
numBlocks_init = 5           
numEnemies_init = 3          

; ============================================
; PLATFORM DATA
; ============================================
maxPlatforms = 10             
numPlatforms BYTE 0            
platX BYTE maxPlatforms DUP(0)
platY BYTE maxPlatforms DUP(0)
platW BYTE maxPlatforms DUP(0)

maxBlocks = 20                
numBlocks BYTE 0               
blockX BYTE maxBlocks DUP(0)
blockY BYTE maxBlocks DUP(0)
blockType BYTE maxBlocks DUP(0)

; ============================================
; PIPE DATA
; ============================================
maxPipes = 5                  
numPipes BYTE 0                
pipeX BYTE maxPipes DUP(0)
pipeY BYTE maxPipes DUP(0)    
pipeH BYTE maxPipes DUP(0)    
pipeWidth = 4                 

; ============================================
; HILL DATA
; ============================================
maxHills_init = 3
numHills BYTE maxHills_init 
hillX BYTE 20, 40, 65
hillH BYTE 2, 1, 2 

maxClouds_init = 4
numClouds BYTE maxClouds_init 
cloudX BYTE 10, 25, 45, 70
cloudY BYTE 3, 5, 4, 6

; ============================================
; ENEMY DATA
; ============================================
ENEMY_COLOR       = red   + (lightBlue * 16)   
KOOPA_COLOR       = black + (lightBlue * 16)   
SHELL_COLOR       = black + (lightBlue * 16)   
SUPER_MARIO_COLOR = yellow + (lightBlue * 16)  
maxEnemies = 5                
numEnemies BYTE 0              
enemyX BYTE maxEnemies DUP(0)
enemyY BYTE maxEnemies DUP(0)
enemyDir BYTE maxEnemies DUP(0)
enemyActive BYTE maxEnemies DUP(0)
enemyType BYTE maxEnemies DUP(0)
enemyPatrolStart BYTE maxEnemies DUP(0)
enemyPatrolEnd BYTE maxEnemies DUP(0)
enemyDeathTimer BYTE maxEnemies DUP(0)
enemyMoveCounter BYTE 0 
shellSpeed BYTE maxEnemies DUP(0) 

; ============================================
; BOWSER BOSS DATA
; ============================================
bowserHP BYTE 5 
bowserJumpTimer BYTE 0 
bowserFireTimer BYTE 0 
bowserFireballX BYTE 0 
bowserFireballY BYTE 0 
bowserFireballDir BYTE 0 

; ============================================
; AXE DATA (Level 4 Page 3)
; ============================================
axeActive BYTE 1 
axeX BYTE 70 
axeY BYTE 13 

; ============================================
; SUPER MARIO STATE
; ============================================
isSuper BYTE 0               
superFrames DWORD 0          
SUPER_DURATION_FRAMES = 300  

; ============================================
; MUSHROOM POWER-UP DATA
; ============================================
mushroomX BYTE 18            
mushroomY BYTE 15            
mushroomPage BYTE 1          
mushroomActive BYTE 1        

; ============================================
; GOLDEN MUSHROOM (INVINCIBILITY)
; ============================================
goldenMushroomX BYTE 0
goldenMushroomY BYTE 0
goldenMushroomActive BYTE 0
goldenMushroomCollected BYTE 0
isInvincible BYTE 0
invincibleTimer DWORD 0
INVINCIBLE_DURATION = 330
GOLDEN_MUSHROOM_COLOR = yellow + (black * 16)

; ============================================
; SLOW MOTION FEATURE (Creative Feature - 20 Marks)
; ============================================
slowMotionItemX BYTE 0
slowMotionItemY BYTE 0
slowMotionItemActive BYTE 0
slowMotionCollected BYTE 0
isSlowMotion BYTE 0
slowMotionTimer DWORD 0
currentDelay DWORD 30        
NORMAL_DELAY = 30
SLOW_DELAY = 100             ; Higher value = Slower game
SLOW_MO_DURATION = 300       ; 300 frames (approx 10 sec)
SLOW_MO_COLOR = cyan + (black * 16)

; ============================================
; PAGE NAVIGATION
; ============================================
currentPage BYTE 1 
pageChanged BYTE 0 

maxPages = 3 

; ============================================
; WORLD 1 PAGE 1 DATA
; ============================================
world1pg1_numBlocks = numBlocks_init
world1pg1_blockX BYTE 15, 25, 35, 45, 50
world1pg1_blockY BYTE 10, 12, 8, 14, 10
world1pg1_blockType BYTE 0, 1, 0, 1, 0

world1pg1_numPlatforms = numPlatforms_init
world1pg1_platX BYTE 20, 40, 60
world1pg1_platY BYTE 17, 13, 17
world1pg1_platW BYTE 10, 10, 10

world1pg1_numHills = maxHills_init
world1pg1_hillX BYTE 20, 40, 65
world1pg1_hillH BYTE 2, 1, 2

world1pg1_numClouds = maxClouds_init
world1pg1_cloudX BYTE 10, 25, 45, 70
world1pg1_cloudY BYTE 3, 5, 4, 6

world1pg1_numCoins = 10
world1pg1_coinX BYTE 15, 25, 35, 45, 55, 65, 20, 40, 50, 60
world1pg1_coinY BYTE 14, 12, 10, 8, 14, 12, 16, 10, 14, 8
world1pg1_coinActive BYTE 10 DUP(1)

world1pg1_numEnemies = numEnemies_init
world1pg1_enemyX BYTE 25, 45, 65
world1pg1_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM, GAME_BOTTOM
world1pg1_enemyDir BYTE 1, 0, 1
world1pg1_enemyActive BYTE 1, 1, 1
world1pg1_enemyType BYTE 0, 0, 0 
world1pg1_enemyPatrolStart BYTE 20, 40, 60
world1pg1_enemyPatrolEnd   BYTE 30, 50, 70

world1pg1_numPipes = 1
world1pg1_pipeX BYTE 70        
world1pg1_pipeY BYTE 20        
world1pg1_pipeH BYTE 2         

; ============================================
; WORLD 1 PAGE 2 DATA
; ============================================
world1pg2_numBlocks = 6
world1pg2_blockX BYTE 12, 22, 32, 48, 60, 70
world1pg2_blockY BYTE 16, 14, 12, 10, 8, 6
world1pg2_blockType BYTE 1, 0, 1, 0, 1, 0

world1pg2_numCoins = 10
world1pg2_coinX BYTE 12, 22, 32, 48, 60, 70, 18, 38, 58, 72
world1pg2_coinY BYTE 15, 13, 11, 9, 7, 5, 14, 12, 10, 8
world1pg2_coinActive BYTE 10 DUP(1)

world1pg2_numEnemies = 3
world1pg2_enemyX BYTE 28, 52, 68
world1pg2_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM, GAME_BOTTOM
world1pg2_enemyDir BYTE 0, 1, 0
world1pg2_enemyActive BYTE 1, 1, 1
world1pg2_enemyType BYTE 0, 0, 0 
world1pg2_enemyPatrolStart BYTE 24, 48, 64
world1pg2_enemyPatrolEnd BYTE   36, 60, 74
world1pg2_enemyDeathTimer BYTE 0, 0, 0

world1pg2_numPipes = 2
world1pg2_pipeX BYTE 25, 55    
world1pg2_pipeY BYTE 20, 20
world1pg2_pipeH BYTE 3, 2      

world1pg2_numPlatforms = 3
world1pg2_platX BYTE 18, 42, 66
world1pg2_platY BYTE 17, 14, 12
world1pg2_platW BYTE 8, 12, 8

world1pg2_numHills = 2
world1pg2_hillX BYTE 30, 62
world1pg2_hillH BYTE 1, 3

world1pg2_numClouds = 3
world1pg2_cloudX BYTE 10, 38, 64
world1pg2_cloudY BYTE 3, 5, 4

; ============================================
; WORLD 1 PAGE 3 DATA
; ============================================
world1pg3_numBlocks = 7
world1pg3_blockX BYTE 8, 18, 28, 38, 52, 62, 72
world1pg3_blockY BYTE 15, 13, 11, 9, 7, 9, 11
world1pg3_blockType BYTE 0, 1, 0, 1, 0, 1, 0

world1pg3_numCoins = 10
world1pg3_coinX BYTE 8, 18, 28, 38, 52, 62, 72, 14, 34, 58
world1pg3_coinY BYTE 14, 12, 10, 8, 6, 8, 10, 13, 11, 7
world1pg3_coinActive BYTE 10 DUP(1)

world1pg3_numEnemies = 3
world1pg3_enemyX BYTE 22, 46, 68
world1pg3_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM, GAME_BOTTOM
world1pg3_enemyDir BYTE 1, 0, 1
world1pg3_enemyActive BYTE 1, 1, 1
world1pg3_enemyType BYTE 0, 0, 0 
world1pg3_enemyPatrolStart BYTE 18, 42, 64
world1pg3_enemyPatrolEnd   BYTE 28, 52, 72
world1pg3_enemyDeathTimer BYTE 0, 0, 0

world1pg3_numPipes = 0

world1pg3_numPlatforms = 4
world1pg3_platX BYTE 12, 32, 50, 68
world1pg3_platY BYTE 16, 14, 12, 15
world1pg3_platW BYTE 6, 10, 8, 6

world1pg3_numHills = 3
world1pg3_hillX BYTE 20, 44, 66
world1pg3_hillH BYTE 2, 1, 2

world1pg3_numClouds = 4
world1pg3_cloudX BYTE 5, 25, 50, 70
world1pg3_cloudY BYTE 2, 4, 3, 5

; ============================================
; WORLD 2 PAGE 1 DATA
; ============================================
world2pg1_numBlocks = 7
world2pg1_blockX BYTE 8, 18, 28, 38, 50, 56, 62
world2pg1_blockY BYTE 14, 16, 12, 10, 16, 14, 12
world2pg1_blockType BYTE 0, 1, 0, 1, 0, 1, 0

world2pg1_numPlatforms = 3
world2pg1_platX BYTE 12, 32, 58
world2pg1_platY BYTE 18, 15, 13
world2pg1_platW BYTE 8, 10, 6

world2pg1_numHills = 2
world2pg1_hillX BYTE 18, 48
world2pg1_hillH BYTE 1, 3

world2pg1_numClouds = 3
world2pg1_cloudX BYTE 6, 30, 68
world2pg1_cloudY BYTE 4, 6, 3

world2pg1_numCoins = 10
world2pg1_coinX BYTE 14, 20, 26, 32, 38, 44, 50, 56, 60, 66
world2pg1_coinY BYTE 13, 11,  9, 14, 12, 10, 14, 12, 10,  8
world2pg1_coinActive BYTE 10 DUP(1)

world2pg1_numEnemies = 3
world2pg1_enemyX BYTE 22, 40, 62
world2pg1_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM, GAME_BOTTOM
world2pg1_enemyDir BYTE 1, 0, 1
world2pg1_enemyActive BYTE 1, 1, 1
world2pg1_enemyType BYTE 1, 0, 0 
world2pg1_enemyPatrolStart BYTE 18, 36, 58
world2pg1_enemyPatrolEnd   BYTE 26, 48, 70
world2pg1_enemyDeathTimer BYTE 0, 0, 0

world2pg1_numPipes = 0

; ============================================
; LEVEL 2 TRANSITION POINTS
; ============================================
level2EntryX BYTE 32  
level2EntryY BYTE 13  

level2ReturnX BYTE 0
level2ReturnY BYTE 0

; ============================================
; WORLD 2 PAGE 2 DATA
; ============================================
world2pg2_numBlocks = 3
world2pg2_blockX BYTE 12, 20, 60
world2pg2_blockY BYTE 16, 14, 16
world2pg2_blockType BYTE 0, 1, 0

world2pg2_numPlatforms = 3
world2pg2_platX BYTE 28, 52, 32
world2pg2_platY BYTE 10, 10, 14
world2pg2_platW BYTE 1, 1, 10

world2pg2_numHills = 1
world2pg2_hillX BYTE 18
world2pg2_hillH BYTE 2

world2pg2_numClouds = 2
world2pg2_cloudX BYTE 8, 68
world2pg2_cloudY BYTE 4, 6

world2pg2_numCoins = 6
world2pg2_coinX BYTE 34, 36, 38, 40, 44, 48
world2pg2_coinY BYTE 13, 12, 11, 13, 12, 11
world2pg2_coinActive BYTE 6 DUP(1)

world2pg2_numEnemies = 2
world2pg2_enemyX BYTE 22, 58
world2pg2_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM
world2pg2_enemyDir BYTE 1, 0
world2pg2_enemyActive BYTE 1, 1
world2pg2_enemyType BYTE 1, 0 
world2pg2_enemyPatrolStart BYTE 18, 54
world2pg2_enemyPatrolEnd   BYTE 30, 70
world2pg2_enemyDeathTimer BYTE 0, 0

world2pg2_numPipes = 0

world2pg3_numBlocks = 7
world2pg3_blockX BYTE 8, 18, 28, 38, 52, 62, 72
world2pg3_blockY BYTE 15, 13, 11, 9, 7, 9, 11
world2pg3_blockType BYTE 0, 1, 0, 1, 0, 1, 0

world2pg3_numCoins = 10
world2pg3_coinX BYTE 8, 18, 28, 38, 52, 62, 72, 14, 34, 58
world2pg3_coinY BYTE 14, 12, 10, 8, 6, 8, 10, 13, 11, 7
world2pg3_coinActive BYTE 10 DUP(1)

world2pg3_numEnemies = 3
world2pg3_enemyX BYTE 22, 46, 68
world2pg3_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM, GAME_BOTTOM
world2pg3_enemyDir BYTE 1, 0, 1
world2pg3_enemyActive BYTE 1, 1, 1
world2pg3_enemyType BYTE 0, 0, 0 
world2pg3_enemyPatrolStart BYTE 18, 42, 64
world2pg3_enemyPatrolEnd   BYTE 28, 52, 72
world2pg3_enemyDeathTimer BYTE 0, 0, 0

world2pg3_numPipes = 0

world2pg3_numPlatforms = 4
world2pg3_platX BYTE 12, 32, 50, 68
world2pg3_platY BYTE 16, 14, 12, 15
world2pg3_platW BYTE 6, 10, 8, 6

world2pg3_numHills = 3
world2pg3_hillX BYTE 20, 45, 65
world2pg3_hillH BYTE 2, 1, 2

world2pg3_numClouds = 4
world2pg3_cloudX BYTE 10, 30, 50, 70
world2pg3_cloudY BYTE 3, 5, 4, 6

world2pg4_numBlocks = 5
world2pg4_blockX BYTE 15, 30, 45, 60, 70
world2pg4_blockY BYTE 14, 12, 10, 14, 12
world2pg4_blockType BYTE 0, 1, 0, 1, 0

world2pg4_numPlatforms = 3
world2pg4_platX BYTE 20, 40, 65
world2pg4_platY BYTE 16, 14, 16
world2pg4_platW BYTE 8, 10, 8

world2pg4_numHills = 2
world2pg4_hillX BYTE 25, 55
world2pg4_hillH BYTE 2, 1

world2pg4_numClouds = 3
world2pg4_cloudX BYTE 10, 35, 65
world2pg4_cloudY BYTE 4, 5, 3

world2pg4_numCoins = 8
world2pg4_coinX BYTE 15, 30, 45, 60, 70, 22, 42, 67
world2pg4_coinY BYTE 13, 11, 9, 13, 11, 15, 13, 15
world2pg4_coinActive BYTE 8 DUP(1)

world2pg4_numEnemies = 2
world2pg4_enemyX BYTE 28, 58
world2pg4_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM
world2pg4_enemyDir BYTE 1, 0
world2pg4_enemyActive BYTE 1, 1
world2pg4_enemyType BYTE 1, 0 
world2pg4_enemyPatrolStart BYTE 24, 54
world2pg4_enemyPatrolEnd   BYTE 34, 64
world2pg4_enemyDeathTimer BYTE 0, 0

world2pg4_numPipes = 0

level2SecretEntryX BYTE 40  
level2SecretEntryY BYTE 13  

level2SecretReturnX BYTE 0
level2SecretReturnY BYTE 0

world2pg5_numBlocks = 7
world2pg5_blockX BYTE 8, 18, 28, 38, 52, 62, 72
world2pg5_blockY BYTE 15, 13, 11, 9, 7, 9, 11
world2pg5_blockType BYTE 0, 1, 0, 1, 0, 1, 0

world2pg5_numCoins = 10
world2pg5_coinX BYTE 8, 18, 28, 38, 52, 62, 72, 14, 34, 58
world2pg5_coinY BYTE 14, 12, 10, 8, 6, 8, 10, 13, 11, 7
world2pg5_coinActive BYTE 10 DUP(1)

world2pg5_numEnemies = 3
world2pg5_enemyX BYTE 22, 46, 68
world2pg5_enemyY BYTE GAME_BOTTOM, GAME_BOTTOM, GAME_BOTTOM
world2pg5_enemyDir BYTE 1, 0, 1
world2pg5_enemyActive BYTE 1, 1, 1
world2pg5_enemyType BYTE 0, 0, 0 
world2pg5_enemyPatrolStart BYTE 18, 42, 64
world2pg5_enemyPatrolEnd   BYTE 28, 52, 72
world2pg5_enemyDeathTimer BYTE 0, 0, 0

world2pg5_numPipes = 0

world2pg5_numPlatforms = 4
world2pg5_platX BYTE 12, 32, 50, 68
world2pg5_platY BYTE 16, 14, 12, 15
world2pg5_platW BYTE 6, 10, 8, 6

world2pg5_numHills = 3
world2pg5_hillX BYTE 20, 45, 65
world2pg5_hillH BYTE 2, 1, 2

world2pg5_numClouds = 4
world2pg5_cloudX BYTE 10, 30, 50, 70
world2pg5_cloudY BYTE 3, 5, 4, 6

; ============================================
; WORLD 4 PAGE 1 DATA (CASTLE ENTRANCE)
; ============================================
world4pg1_numBlocks = 4
world4pg1_blockX BYTE 20, 35, 50, 65
world4pg1_blockY BYTE 12, 10, 14, 12
world4pg1_blockType BYTE 0, 0, 0, 0 

world4pg1_numPlatforms = 3
world4pg1_platX BYTE 0, 30, 60
world4pg1_platY BYTE 17, 17, 17 
world4pg1_platW BYTE 25, 25, 20

world4pg1_numHills = 0
world4pg1_hillX BYTE 0
world4pg1_hillH BYTE 0
world4pg1_numClouds = 0
world4pg1_cloudX BYTE 0
world4pg1_cloudY BYTE 0

world4pg1_numCoins = 5
world4pg1_coinX BYTE 20, 35, 50, 65, 42
world4pg1_coinY BYTE 11, 9, 13, 11, 13
world4pg1_coinActive BYTE 5 DUP(1)

world4pg1_numEnemies = 2
world4pg1_enemyX BYTE 40, 70
world4pg1_enemyY BYTE 16, 16 
world4pg1_enemyDir BYTE 1, 0
world4pg1_enemyActive BYTE 1, 1
world4pg1_enemyType BYTE 0, 0
world4pg1_enemyPatrolStart BYTE 30, 60
world4pg1_enemyPatrolEnd BYTE 55, 75
world4pg1_enemyDeathTimer BYTE 0, 0

world4pg1_numPipes = 0

; ============================================
; WORLD 4 PAGE 2 DATA (CASTLE)
; ============================================
world4pg2_numBlocks = 6
world4pg2_blockX BYTE 10, 25, 40, 55, 70, 15
world4pg2_blockY BYTE 8, 10, 8, 10, 8, 6
world4pg2_blockType BYTE 0, 0, 0, 0, 0, 0

world4pg2_numPlatforms = 2
world4pg2_platX BYTE 0, 45
world4pg2_platY BYTE 17, 17
world4pg2_platW BYTE 35, 35

world4pg2_numHills = 0
world4pg2_hillX BYTE 0
world4pg2_hillH BYTE 0
world4pg2_numClouds = 0
world4pg2_cloudX BYTE 0
world4pg2_cloudY BYTE 0

world4pg2_numCoins = 4
world4pg2_coinX BYTE 20, 40, 60, 30
world4pg2_coinY BYTE 15, 13, 15, 7
world4pg2_coinActive BYTE 4 DUP(1)

world4pg2_numEnemies = 1
world4pg2_enemyX BYTE 20
world4pg2_enemyY BYTE 16
world4pg2_enemyDir BYTE 1
world4pg2_enemyActive BYTE 1
world4pg2_enemyType BYTE 0
world4pg2_enemyPatrolStart BYTE 5
world4pg2_enemyPatrolEnd BYTE 30
world4pg2_enemyDeathTimer BYTE 0

world4pg2_numPipes = 0

; ============================================
; WORLD 4 PAGE 3 DATA (BOSS ARENA)
; ============================================
world4pg3_numBlocks = 0        
world4pg3_blockX BYTE 0
world4pg3_blockY BYTE 0
world4pg3_blockType BYTE 0

world4pg3_numPlatforms = 2
world4pg3_platX BYTE 0, 65
world4pg3_platY BYTE 17, 17
world4pg3_platW BYTE 60, 10

world4pg3_numHills = 0
world4pg3_hillX BYTE 0
world4pg3_hillH BYTE 0

world4pg3_numClouds = 0
world4pg3_cloudX BYTE 0
world4pg3_cloudY BYTE 0

world4pg3_numCoins = 0
world4pg3_coinX BYTE 0
world4pg3_coinY BYTE 0
world4pg3_coinActive BYTE 0

world4pg3_numEnemies = 1
world4pg3_enemyX BYTE 50
world4pg3_enemyY BYTE 16 
world4pg3_enemyDir BYTE 0 
world4pg3_enemyActive BYTE 1
world4pg3_enemyType BYTE 3 
world4pg3_enemyPatrolStart BYTE 40
world4pg3_enemyPatrolEnd BYTE 60
world4pg3_enemyDeathTimer BYTE 0

world4pg3_numPipes = 0

; ============================================
; LEVEL TIME LIMITS
; Time limits in seconds for each level
; ============================================
levelTimeLimits DWORD 90, 120, 150, 180, 200 

; ============================================
; AUDIO COMMAND STRINGS
; MCI system commands for playing sound files
; ============================================
cmdOpenIntro    BYTE "open intro.wav type mpegvideo alias intro",0
cmdOpenTheme    BYTE "open theme.wav type mpegvideo alias theme",0
cmdOpenUnder    BYTE "open under.wav type mpegvideo alias under",0
cmdOpenWin      BYTE "open win.wav type mpegvideo alias levelwin",0
cmdOpenGameOv   BYTE "open gameover.wav type mpegvideo alias gameover",0
cmdOpenJump     BYTE "open mario_jump.wav type mpegvideo alias jump",0
cmdOpenKill     BYTE "open kill.wav type mpegvideo alias kill",0
cmdOpenCoin     BYTE "open coin.wav type mpegvideo alias coin",0

cmdPlayIntro    BYTE "play intro repeat",0       
cmdPlayTheme    BYTE "play theme repeat",0
cmdPlayUnder    BYTE "play under repeat",0
cmdPlayWin      BYTE "play levelwin from 0",0    
cmdPlayGameOv   BYTE "play gameover from 0",0
cmdPlayJump     BYTE "play jump from 0",0
cmdPlayKill     BYTE "play kill from 0",0
cmdPlayCoin     BYTE "play coin from 0",0

cmdStopIntro    BYTE "stop intro",0
cmdStopTheme    BYTE "stop theme",0
cmdStopUnder    BYTE "stop under",0
cmdCloseAll     BYTE "close all",0 

currentMusic    DWORD 0 

.code

; ============================================
; Main program entry point
; Handles menu navigation and game initialization
; ============================================
main PROC
	call InitAudio       

	mainMenuLoop:
	call PlayIntroMusic  
	call Clrscr

		call ShowTitleScreen

		call ShowMainMenu

		cmp inputChar, '1'
		je startGameLabel

		cmp inputChar, '2'
		je showHighScoreLabel

		cmp inputChar, '3'
		je showLevelsLabel

		cmp inputChar, '4'
		je showInstructionsLabel

		cmp inputChar, '5'
		je exitGameLabel

		jmp mainMenuLoop 

	startGameLabel:
		mov level, 1
		call StartGame
		jmp mainMenuLoop

	showHighScoreLabel:
		call ShowHighScore
		jmp mainMenuLoop

	showLevelsLabel:
		call ShowLevels
		jmp mainMenuLoop

	showInstructionsLabel:
		call ShowInstructions
		jmp mainMenuLoop

	exitGameLabel:
	exit
main ENDP

; ============================================
; Initializes and runs the main game loop
; Handles player input, physics, collisions, and rendering
; ============================================
StartGame PROC
	call GetPlayerName

	mov currentMusic, 0

	call Clrscr
	mov dl, 0
	mov dh, 0
	call Gotoxy

	call Randomize

	; ==================================================
	; GLOBAL GAME RESET (Runs ONCE per Game Session)
	; ==================================================
	mov score, 0
	mov coins, 0
	mov lives, 5

	; ==================================================
	; LEVEL RESTART LOOP (Progression Point)
	; ==================================================
	RestartLevelLoop:

	call SetTimerForLevel 
	mov timerCounter, 0
	mov xPos, 10
	mov yPos, 15
	mov isSuper, 0              
	mov superFrames, 0          
	mov mushroomActive, 1       
	mov marioFacingDirection, 1 
	mov isPaused, 0
	mov isJumping, 0
	mov currentJump, 0
	mov enemyMoveCounter, 0 
	mov gameOver, 0 
	mov levelPassed, 0 
	mov isSliding, 0
	mov isInvincible, 0
	mov invincibleTimer, 0
	
	mov isSlowMotion, 0
	mov slowMotionTimer, 0
	mov currentDelay, NORMAL_DELAY
	mov slowMotionCollected, 0 
	
	mov currentPage, 1 

	mov ecx, world1pg1_numEnemies
	mov esi, 0
resetPg1Enemies:
		mov world1pg1_enemyActive[esi], 1
		inc esi
	loop resetPg1Enemies

	mov ecx, world1pg1_numCoins
	mov esi, 0
resetPg1Coins:
		mov world1pg1_coinActive[esi], 1
		inc esi
	loop resetPg1Coins

	mov ecx, world1pg2_numEnemies
	mov esi, 0
resetPg2Enemies:
		mov world1pg2_enemyActive[esi], 1
		inc esi
	loop resetPg2Enemies

	mov ecx, world1pg2_numCoins
	mov esi, 0
resetPg2Coins:
		mov world1pg2_coinActive[esi], 1
		inc esi
	loop resetPg2Coins

	mov ecx, world1pg3_numEnemies
	mov esi, 0
resetPg3Enemies:
		mov world1pg3_enemyActive[esi], 1
		inc esi
	loop resetPg3Enemies

	mov ecx, world1pg3_numCoins
	mov esi, 0
resetPg3Coins:
		mov world1pg3_coinActive[esi], 1
		inc esi
	loop resetPg3Coins

	mov ecx, world2pg1_numEnemies
	mov esi, 0
resetL2Pg1Enemies:
		mov world2pg1_enemyActive[esi], 1
		inc esi
	loop resetL2Pg1Enemies

	mov ecx, world2pg1_numCoins
	mov esi, 0
resetL2Pg1Coins:
		mov world2pg1_coinActive[esi], 1
		inc esi
	loop resetL2Pg1Coins

	mov ecx, world2pg2_numEnemies
	mov esi, 0
resetL2Pg2Enemies:
		mov world2pg2_enemyActive[esi], 1
		inc esi
	loop resetL2Pg2Enemies

	mov ecx, world2pg2_numCoins
	mov esi, 0
resetL2Pg2Coins:
		mov world2pg2_coinActive[esi], 1
		inc esi
	loop resetL2Pg2Coins

	mov ecx, world2pg3_numEnemies
	mov esi, 0
resetL2Pg3Enemies:
		mov world2pg3_enemyActive[esi], 1
		inc esi
	loop resetL2Pg3Enemies

	mov ecx, world2pg3_numCoins
	mov esi, 0
resetL2Pg3Coins:
		mov world2pg3_coinActive[esi], 1
		inc esi
	loop resetL2Pg3Coins

	mov ecx, world2pg4_numEnemies
	mov esi, 0
resetL2Pg4Enemies:
		mov world2pg4_enemyActive[esi], 1
		inc esi
	loop resetL2Pg4Enemies

	mov ecx, world2pg4_numCoins
	mov esi, 0
resetL2Pg4Coins:
		mov world2pg4_coinActive[esi], 1
		inc esi
	loop resetL2Pg4Coins

	mov ecx, world2pg5_numCoins
	mov esi, 0
resetL2Pg5Coins:
		mov world2pg5_coinActive[esi], 1
		inc esi
	loop resetL2Pg5Coins

	mov ecx, world4pg1_numEnemies
	mov esi, 0
resetL4Pg1Enemies:
		mov world4pg1_enemyActive[esi], 1
		inc esi
	loop resetL4Pg1Enemies

	mov ecx, world4pg1_numCoins
	mov esi, 0
resetL4Pg1Coins:
		mov world4pg1_coinActive[esi], 1
		inc esi
	loop resetL4Pg1Coins

	mov ecx, world4pg2_numEnemies
	mov esi, 0
resetL4Pg2Enemies:
		mov world4pg2_enemyActive[esi], 1
		inc esi
	loop resetL4Pg2Enemies

	mov ecx, world4pg2_numCoins
	mov esi, 0
resetL4Pg2Coins:
		mov world4pg2_coinActive[esi], 1
		inc esi
	loop resetL4Pg2Coins

	mov ecx, world4pg3_numEnemies
	mov esi, 0
resetL4Pg3Enemies:
		mov world4pg3_enemyActive[esi], 1
		inc esi
	loop resetL4Pg3Enemies


	mov al, level

	cmp al, 2
	je startLevel2Page1

	cmp al, 4
	je startLevel4Page1

	call LoadPage1
	jmp pagesLoaded

startLevel2Page1:
	mov currentPage, 1
	call LoadLevel2Page1
	jmp pagesLoaded

startLevel4Page1:
	mov currentPage, 1
	call LoadLevel4Page1
	jmp pagesLoaded

pagesLoaded:

	call DrawBackground
	mov al, level
	cmp al, 2
	je drawLevel2Layout
	cmp al, 4
	je drawLevel4Layout
	call DrawWorld1_1Layout 
	jmp layoutDrawn
drawLevel2Layout:
	call DrawWorld1_2Layout 
	jmp layoutDrawn
drawLevel4Layout:
	call DrawWorld1_1Layout 
layoutDrawn:
	call DrawPlatforms
	mov al, level
	cmp al, 4
	jne skipLavaDraw
	call DrawLava
skipLavaDraw:
	call DrawHUD 

	call DrawPlayer
	call DrawEnemies 
	call DrawAllCoins 
	call DrawSlowMotionItem

	call PlayLevelMusic

	mov al, level
	cmp al, 4
	jne skipAxeDraw
	mov al, currentPage
	cmp al, 3
	jne skipAxeDraw
	cmp axeActive, 1
	jne skipAxeDraw
	mov eax, AXE_COLOR
	call SetTextColor
	mov dl, axeX
	mov dh, axeY
	call Gotoxy
	mov al, 'P' 
	call WriteChar
skipAxeDraw:

	gameLoop:
		call ReadKey
		jz checkPaused
		mov inputChar, al

		cmp al, 27
		je pauseGame
		cmp al, 1Bh 
		je pauseGame

		cmp al, 'p'
		je pauseGame
		cmp al, 'P'
		je pauseGame

		jmp continueGame

		checkPaused:
		cmp isPaused, 1
		je gameLoop 

		continueGame:

		mov eax, currentDelay 
		call Delay

		inc timerCounter
		cmp timerCounter, 33
		jl skipTimerUpdate
		mov timerCounter, 0
		dec timer
		cmp timer, 0
		jle timeUp
		skipTimerUpdate:


		cmp pageChanged, 0
		je noPageChange

		mov al, currentPage
		cmp al, 1
		je loadPage1FromLoop
		cmp al, 2
		je loadPage2FromLoop
		cmp al, 3
		je loadPage3FromLoop
		cmp al, 4
		je loadPage4FromLoop
		cmp al, 5
		je loadPage5FromLoop
		jmp finishPageChange

loadPage1FromLoop:
		mov al, level
		cmp al, 2
		je loadL2Pg1FromLoop
		cmp al, 4
		je loadL4Pg1FromLoop
		call LoadPage1
		jmp redrawAfterPageChange
loadL2Pg1FromLoop:
		call LoadLevel2Page1
		jmp redrawAfterPageChange
loadL4Pg1FromLoop:
		call LoadLevel4Page1
		jmp redrawAfterPageChange

loadPage2FromLoop:
		mov al, level
		cmp al, 2
		je loadL2Pg2FromLoop
		cmp al, 4
		je loadL4Pg2FromLoop
		call LoadPage2
		jmp redrawAfterPageChange
loadL2Pg2FromLoop:
		call LoadLevel2Page2
		jmp redrawAfterPageChange
loadL4Pg2FromLoop:
		call LoadLevel4Page2
		jmp redrawAfterPageChange

loadPage3FromLoop:
		mov al, level
		cmp al, 2
		je loadL2Pg3FromLoop
		cmp al, 4
		je loadL4Pg3FromLoop
		call LoadPage3
		jmp redrawAfterPageChange
loadL2Pg3FromLoop:
		call LoadLevel2Page3
		jmp redrawAfterPageChange
loadL4Pg3FromLoop:
		call LoadLevel4Page3
		jmp redrawAfterPageChange
loadPage4FromLoop:
		mov al, level
		cmp al, 2
		je loadL2Pg4FromLoop
		jmp finishPageChange 
loadL2Pg4FromLoop:
		call LoadLevel2Page4
		jmp redrawAfterPageChange

loadPage5FromLoop:
		mov al, level
		cmp al, 2
		je loadL2Pg5FromLoop
		jmp finishPageChange 
loadL2Pg5FromLoop:
		call LoadLevel2Page5
		jmp redrawAfterPageChange

	redrawAfterPageChange:
		call PlayLevelMusic

		mov al, level
		cmp al, 2
		jne normalPageTransition
		mov al, currentPage
		cmp al, 3
		je specialPageTransition
		cmp al, 5
		je specialPageTransition
		jmp normalPageTransition
		specialPageTransition:
		call DrawBackground
		jmp afterBackgroundDrawn
	normalPageTransition:
		call ClearGameAreaOnly
		call DrawWallsAndGroundOnly
		jmp afterWallsDrawn
	afterBackgroundDrawn:
	afterWallsDrawn:
		mov al, level
		cmp al, 2
		je drawLevel2LayoutTransition
		cmp al, 4
		je drawLevel4LayoutTransition
		call DrawWorld1_1Layout 
		jmp layoutDrawnTransition
	drawLevel2LayoutTransition:
		call DrawWorld1_2Layout 
		jmp layoutDrawnTransition
	drawLevel4LayoutTransition:
		call DrawWorld1_1Layout 
	layoutDrawnTransition:
		call DrawPlatforms
		mov al, level
		cmp al, 4
		jne skipLavaDrawTransition
		call DrawLava
	skipLavaDrawTransition:
	call DrawAllCoins 
	call DrawGoldenMushroom
	call DrawSlowMotionItem
	call DrawEnemies
		mov al, level
		cmp al, 4
		jne skipAxeDrawTransition
		mov al, currentPage
		cmp al, 3
		jne skipAxeDrawTransition
		cmp axeActive, 1
		jne skipAxeDrawTransition
		mov eax, AXE_COLOR
		call SetTextColor
		mov dl, axeX
		mov dh, axeY
		call Gotoxy
		mov al, 'P'
		call WriteChar
	skipAxeDrawTransition:
		call DrawFlagpole 
		call DrawPlayer
		call DrawHUD
		mov dl, GAME_LEFT_WALL + 1
		mov dh, GAME_TOP + 1
		call Gotoxy

	finishPageChange:
		mov pageChanged, 0
		jmp handleInput 

	noPageChange:

		inc enemyMoveCounter
		cmp enemyMoveCounter, 3
		jl skipEnemyUpdate
		mov enemyMoveCounter, 0
		call UpdateEnemies
		skipEnemyUpdate:

		call CheckCoinCollection
		call CheckGoldenMushroomCollection
		call CheckSlowMotionCollection

		mov al, level
		cmp al, 4
		jne skipFireballCheck
		cmp bowserFireballX, 0
		je skipFireballCheck
		mov al, bowserFireballX
		mov bl, xPos
		cmp al, bl
		jne skipFireballCheck
		mov al, bowserFireballY
		mov bl, yPos
		cmp al, bl
		je fireballHitsMario
		dec bl
		cmp al, bl
		je fireballHitsMario
		jmp skipFireballCheck
		fireballHitsMario:
		dec lives
		cmp lives, 0
		jle fireballGameOver
		mov xPos, 10
		mov yPos, 15
		mov isJumping, 0
		mov currentJump, 0
		mov bowserFireballX, 0
		call DrawBackground
		mov al, level
		cmp al, 4
		je drawLevel4LayoutRespawnFireball
		call DrawWorld1_1Layout
		jmp layoutDrawnRespawnFireball
		drawLevel4LayoutRespawnFireball:
		call DrawWorld1_1Layout
		layoutDrawnRespawnFireball:
		call DrawPlatforms
		mov al, level
		cmp al, 4
		jne skipLavaRespawnFireball
		call DrawLava
		skipLavaRespawnFireball:
	call DrawAllCoins 
	call DrawGoldenMushroom
	call DrawSlowMotionItem
	call DrawEnemies
		call DrawPlayer
		call DrawHUD
		jmp handleInput
		fireballGameOver:
		mov gameOver, 1
		jmp showGameOverScreen
		skipFireballCheck:

		mov al, level
		cmp al, 4
		jne skipAxeCheck
		mov al, currentPage
		cmp al, 3
		jne skipAxeCheck
		cmp axeActive, 1
		jne skipAxeCheck
		mov al, xPos
		cmp al, axeX
		jne skipAxeCheck
		mov al, yPos
		cmp al, axeY
		je collectAxe
		dec al
		cmp al, axeY
		je collectAxe
		jmp skipAxeCheck
		collectAxe:
		mov axeActive, 0
		call PlayWinSound      

		add score, 5000        
		call DrawHUD           

		mov eax, CASTLE_SKY_COLOR
		call SetTextColor
		mov dl, axeX
		mov dh, axeY
		call Gotoxy
		mov al, ' '
		call WriteChar
		movzx ecx, numBlocks
		mov esi, 0
		collapseBridgeLoop:
			cmp ecx, 0
			je bridgeCollapsed
			mov al, blockY[esi]
			cmp al, 15 
			jne skipBridgeBlock
			mov eax, CASTLE_SKY_COLOR
			call SetTextColor
			mov dl, blockX[esi]
			mov dh, blockY[esi]
			call Gotoxy
			mov al, ' '
			call WriteChar
			mov blockY[esi], 0
			dec numBlocks
			skipBridgeBlock:
			inc esi
			dec ecx
			jmp collapseBridgeLoop
		bridgeCollapsed:
		movzx ecx, numEnemies
		mov esi, 0
		findBowser:
			cmp ecx, 0
			je skipAxeCheck
			mov al, enemyType[esi]
			cmp al, 3
			je bowserFound
			inc esi
			dec ecx
			jmp findBowser
		bowserFound:
		mov enemyActive[esi], 0
		call UpdateEnemy
		mov levelPassed, 1
		skipAxeCheck:

		call CheckMushroomCollection

		call CheckShellEnemyCollision

		call CheckEnemyCollision

		cmp gameOver, 2 
		je handleRespawn

		cmp gameOver, 1 
		je showGameOverScreen

		cmp levelPassed, 1
		je showLevelPassedScreen

		mov eax, superFrames
		cmp eax, 0
		jle skipSuperTimer
		dec eax
		mov superFrames, eax
		cmp eax, 0
		jne skipSuperTimer

		cmp isSuper, 1
		jne skipSuperTimer

		mov isSuper, 0
		call DrawPlayer

		skipSuperTimer:
		cmp invincibleTimer, 0
		jle skipInvincibleTimer
		dec invincibleTimer
		cmp invincibleTimer, 0
		jg skipInvincibleTimer
		mov isInvincible, 0
		call DrawPlayer

	skipInvincibleTimer:

	cmp slowMotionTimer, 0
	jle skipSlowTimer
	dec slowMotionTimer
	cmp slowMotionTimer, 0
	jg skipSlowTimer

	mov isSlowMotion, 0
	mov currentDelay, NORMAL_DELAY

	skipSlowTimer:

	cmp timerCounter, 0
		je updateHUD
		jmp skipHUDUpdate
		updateHUD:
		call DrawHUD
		skipHUDUpdate:


		jmp continueGameFlow

		handleRespawn:
		mov xPos, 10
		mov yPos, 15
		mov isJumping, 0
		mov currentJump, 0
		mov gameOver, 0 

		call DrawBackground

		mov al, level
		cmp al, 2
		je drawLevel2LayoutRespawn
		cmp al, 4
		je drawLevel4LayoutRespawn 

		call DrawWorld1_1Layout
		jmp layoutDrawnRespawn

	drawLevel2LayoutRespawn:
		call DrawWorld1_2Layout
		jmp layoutDrawnRespawn

	drawLevel4LayoutRespawn:       
		call DrawWorld1_1Layout    

	layoutDrawnRespawn:
		call DrawPlatforms

		mov al, level
		cmp al, 4
		jne skipLavaRespawn
		call DrawLava
		skipLavaRespawn:

	call DrawAllCoins 
	call DrawGoldenMushroom
	call DrawEnemies

		mov al, level
		cmp al, 4
		jne skipAxeRespawn
		mov al, currentPage
		cmp al, 3
		jne skipAxeRespawn
		cmp axeActive, 1
		jne skipAxeRespawn
		mov eax, AXE_COLOR
		call SetTextColor
		mov dl, axeX
		mov dh, axeY
		call Gotoxy
		mov al, 'P'
		call WriteChar
		skipAxeRespawn:

		call DrawPlayer
		call DrawHUD 

		jmp handleInput

		continueGameFlow:

		cmp isJumping, 1
		je handleJump

		call UpdatePlayer
		inc yPos

		mov bl, 1 
		cmp isSuper, 1
		jne checkCeilNormal
		mov bl, 2 
		checkCeilNormal:

		mov al, yPos
		sub al, bl 

		cmp al, GAME_TOP
		jle hitCeiling 

		cmp yPos, GAME_BOTTOM
		jg hitGround

		cmp xPos, GAME_LEFT_WALL + 1
		jle hitLeftWall

		cmp xPos, GAME_RIGHT_WALL
		jge hitRightWall

		call CheckLandOnBlocks
		cmp al, 1
		je landedOnBlock

	movzx ecx, numPlatforms
		mov esi, 0
		checkPlats:
			mov al, platY[esi]
			cmp yPos, al
			jne nextPlat

			mov al, platX[esi]
			cmp xPos, al
			jl nextPlat 

			add al, platW[esi]
			cmp xPos, al
			jg nextPlat 

			dec yPos 
			jmp gravityOK

			nextPlat:
			inc esi
		loop checkPlats

		cmp isJumping, 1
		jne noJumpCollision
		call CheckHitBlockFromBelow
		cmp al, 1
		je hitBlockFromBelow
		noJumpCollision:

		jmp checkGroundLimit

		hitBlockFromBelow:
		mov isJumping, 0
		mov currentJump, 0
		jmp gravityOK

		hitCeiling:
		cmp isSuper, 1
		je bounceSuper
		mov yPos, GAME_TOP + 2 
		jmp finishBounce
		bounceSuper:
		mov yPos, GAME_TOP + 3 
		finishBounce:
		mov isJumping, 0 
		mov currentJump, 0 
		jmp gravityOK

		hitLeftWall:
		jmp gravityOK

		hitRightWall:
		jmp gravityOK

		landedOnBlock:
		dec yPos 
		mov isJumping, 0
		mov currentJump, 0
		jmp gravityOK

		hitGround:
		mov al, level
		cmp al, 4
		jne normalGroundHit
		call CheckStandingOnPlatformOrBlock
		cmp al, 1
		je normalGroundHit 
		mov gameOver, 1
		jmp showGameOverScreen

normalGroundHit:
		mov yPos, GAME_BOTTOM 

		checkGroundLimit:
		cmp yPos, GAME_BOTTOM
		jle gravityOK
		mov yPos, GAME_BOTTOM

		gravityOK:
		call DrawPlayer
		jmp handleInput

		handleJump:
		mov al, currentJump
		cmp al, jumpHeight
		jge endJump

		mov bl, 1 
		cmp isSuper, 1
		jne calcHeadJump
		mov bl, 2 
		calcHeadJump:
		mov al, yPos
		sub al, bl 

		cmp al, GAME_TOP + 1
		jle hitCeilingInJump

		call UpdatePlayer
		dec yPos              
		inc currentJump

		movzx ecx, numPlatforms
		mov esi, 0
	checkPlatCeilingInJump:
		cmp ecx, 0
		je donePlatCeilingInJump
		mov al, platY[esi]
		mov bh, al          
		mov dl, yPos
		dec dl              
		cmp dl, bh
		jne nextPlatCeilingInJump
		mov al, platX[esi]
		mov bl, al          
		mov dl, xPos
		cmp dl, bl
		jl nextPlatCeilingInJump
		mov al, platW[esi]
		add bl, al          
		cmp dl, bl
		jge nextPlatCeilingInJump
		inc yPos            
		mov isJumping, 0
		mov currentJump, 0
		jmp drawJumpResult

	nextPlatCeilingInJump:
		inc esi
		dec ecx
		jnz checkPlatCeilingInJump

	donePlatCeilingInJump:

drawJumpResult:
		call DrawPlayer
		cmp currentJump, 3
		jge canStopEarly
		jmp handleInput

		canStopEarly:
		jmp handleInput

		hitCeilingInJump:
		cmp isSuper, 1
		je bounceSuperJump
		mov yPos, GAME_TOP + 2 
		jmp finishBounceJump
		bounceSuperJump:
		mov yPos, GAME_TOP + 3 
		finishBounceJump:

		mov isJumping, 0
		mov currentJump, 0
		call DrawPlayer
		jmp handleInput

		endJump:
		mov isJumping, 0
		mov currentJump, 0
		jmp handleInput

		handleInput:
		cmp inputChar, 27
		je pauseGame
		cmp inputChar, 'p'
		je pauseGame
		cmp inputChar, 'P'
		je pauseGame

		cmp inputChar,"x"
		je exitGame

		cmp inputChar,"w"
		je moveUp

		cmp inputChar,"s"
		je moveDown

		cmp inputChar,"a"
		je moveLeft

		cmp inputChar,"d"
		je moveRight

		jmp noInput

		moveUp:
		cmp isJumping, 1
		je noInput
		call PlayJumpSound 
		mov isJumping, 1
		mov currentJump, 0
		mov jumpHeight, 7 
		jmp handleInput

		moveDown:
		mov al, level
		cmp al, 2
		jne normalMoveDown
		mov al, currentPage
		cmp al, 2
		jne checkPage4Secret
		mov al, xPos
		cmp al, level2EntryX
		jl normalMoveDown       
		mov bl, level2EntryX
		add bl, 4               
		cmp al, bl
		jg normalMoveDown       
		mov al, yPos
		cmp al, level2EntryY
		jne normalMoveDown
		mov al, xPos
		mov level2ReturnX, al
		mov al, yPos
		mov level2ReturnY, al
		mov xPos, 10
		mov yPos, 15
		mov currentPage, 3
		mov pageChanged, 1
		jmp noInput

		checkPage4Secret:
		cmp al, 4
		jne normalMoveDown
		mov al, xPos
		cmp al, level2SecretEntryX
		jl normalMoveDown       
		mov bl, level2SecretEntryX
		add bl, 4               
		cmp al, bl
		jg normalMoveDown       
		mov al, yPos
		cmp al, level2SecretEntryY
		jne normalMoveDown
		mov al, xPos
		mov level2SecretReturnX, al
		mov al, yPos
		mov level2SecretReturnY, al
		mov xPos, 10
		mov yPos, 15
		mov currentPage, 5
		mov pageChanged, 1
		jmp noInput

normalMoveDown:
		cmp yPos, GAME_BOTTOM
		jge noInput

		movzx ecx, numPlatforms
		mov esi, 0
checkDownPlat:
		cmp ecx, 0
		je doFastFall
		mov al, platY[esi]
		mov bh, al          
		mov dl, yPos
		inc dl              
		cmp dl, bh
		jne nextDownPlat
		mov al, platX[esi]
		mov bl, al          
		mov dl, xPos
		cmp dl, bl
		jl nextDownPlat
		mov al, platW[esi]
		add bl, al          
		cmp dl, bl
		jge nextDownPlat
		jmp noInput

nextDownPlat:
		inc esi
		dec ecx
		jnz checkDownPlat

	movzx ecx, numPipes
	cmp ecx, 0
	je doFastFall
	mov esi, 0

checkDownPipe:
	mov al, pipeY[esi]
	sub al, pipeH[esi]
	mov bh, al          

	mov dl, yPos
	inc dl
	cmp dl, bh
	jne nextDownPipe

	mov al, pipeX[esi]
	mov bl, al          
	mov dl, xPos
	cmp dl, bl
	jl nextDownPipe
	add bl, 3           
	cmp dl, bl
	jg nextDownPipe

	jmp noInput
nextDownPipe:
	inc esi
	dec ecx
	jnz checkDownPipe

doFastFall:
		call UpdatePlayer
		inc yPos
		call DrawPlayer
		jmp noInput

		moveLeft:
		cmp xPos, GAME_LEFT_WALL + 2
		jg doMoveLeft        

		mov al, level
		cmp al, 2
		jne checkPageFlipLeft
		mov al, currentPage
		cmp al, 3
		je noInput 
		cmp al, 5
		je noInput 

		checkPageFlipLeft:
		mov al, currentPage
		cmp al, 1
		jle noInput          

		mov al, level
		cmp al, 2
		jne normalPageFlipLeft

		mov al, currentPage
		cmp al, 4
		jne normalPageFlipLeft

		mov currentPage, 2
		mov xPos, GAME_RIGHT_WALL - 2
		mov pageChanged, 1
		jmp noInput

		normalPageFlipLeft:
		dec currentPage
		mov xPos, GAME_RIGHT_WALL - 2  
		mov pageChanged, 1             
		jmp noInput

		doMoveLeft:
		call CheckBlockCollisionLeft
		cmp al, 1
		je noInput 

		call UpdatePlayer   
		dec xPos            
		mov marioFacingDirection, 0 

		call DrawPlayer
		jmp noInput

		moveRight:
		mov al, level
		cmp al, 2
		jne skipL2UndergroundExit
		mov al, currentPage
		cmp al, 3
		jne checkSecretRoomExit
		cmp xPos, GAME_RIGHT_WALL - 1
		jl skipL2UndergroundExit 
		mov al, level2ReturnX
		cmp al, 0
		je skipL2UndergroundExit 
		mov xPos, al
		mov al, level2ReturnY
		cmp al, 0
		je skipL2UndergroundExit 
		mov yPos, al
		mov currentPage, 2
		mov pageChanged, 1
		jmp noInput

		checkSecretRoomExit:
		cmp al, 5
		jne skipL2UndergroundExit
		cmp xPos, GAME_RIGHT_WALL - 1
		jl skipL2UndergroundExit 
		mov al, level2SecretReturnX
		cmp al, 0
		je skipL2UndergroundExit 
		mov xPos, al
		mov al, level2SecretReturnY
		cmp al, 0
		je skipL2UndergroundExit 
		mov yPos, al
		mov currentPage, 4
		mov pageChanged, 1
		jmp noInput

skipL2UndergroundExit:
		mov al, level
		cmp al, 2
		je checkFlagL2
		mov al, currentPage
		cmp al, maxPages
		jne checkPageBoundary
		jmp checkFlagDist
		
		checkFlagL2:
		mov al, currentPage
		cmp al, 4
		jne checkPageBoundary

		checkFlagDist:
		mov al, xPos
		inc al
		cmp al, flagpoleX
		jne checkPageBoundary
		
		call PlayWinSound
		
		
		mov al, yPos
		cmp al, 8
		jle flagTop
		cmp al, 18
		jl flagMid
		jmp flagBot
		
		flagTop:
		add score, 5000
		jmp flagScoreDone
		
		flagMid:
		add score, 2000
		jmp flagScoreDone
		
		flagBot:
		add score, 100
		
		flagScoreDone:
		call DrawHUD
		mov levelPassed, 1
		jmp noInput

		checkPageBoundary:
		cmp xPos, GAME_RIGHT_WALL - 1
		jl doMoveRight       

		mov al, level
		cmp al, 2
		jne normalPageFlipRight
		mov al, currentPage
		cmp al, 2
		jne normalPageFlipRight
		mov currentPage, 4
		mov xPos, GAME_LEFT_WALL + 2
		mov pageChanged, 1
		jmp noInput

normalPageFlipRight:
	mov al, level
	cmp al, 2
	jne checkLevel1LastPageFlip
	
	mov al, currentPage
	cmp al, 4
	jge noInput 
	jmp doPageFlip

checkLevel1LastPageFlip:
	mov al, currentPage
	cmp al, maxPages
	jge noInput 

doPageFlip:
	inc currentPage
	mov xPos, GAME_LEFT_WALL + 2   
	mov pageChanged, 1             
	jmp noInput

	doMoveRight:
		call CheckBlockCollisionRight
		cmp al, 1
		je noInput 

		call UpdatePlayer   
		inc xPos            
		mov marioFacingDirection, 1 

		call DrawPlayer
		jmp noInput

		noInput:
		mov inputChar, 0
	jmp gameLoop

		pauseGame:
		call ShowPauseMenu
		cmp inputChar, '1'
		je resumeGame
		cmp inputChar, '2'
		je newGameFromPause
		cmp inputChar, '3'
		je exitGame

		resumeGame:
		mov isPaused, 0
		call DrawBackground
		mov al, level
		cmp al, 2
		je drawLevel2LayoutResume
		call DrawWorld1_1Layout 
		jmp layoutDrawnResume
	drawLevel2LayoutResume:
		call DrawWorld1_2Layout 
	layoutDrawnResume:
		call DrawPlatforms
	call DrawAllCoins 
	call DrawGoldenMushroom
	call DrawEnemies
		call DrawPlayer
		call DrawHUD
		jmp gameLoop

		newGameFromPause:
		jmp exitGame

		timeUp:
		mov gameOver, 1
		jmp showGameOverScreen

	showGameOverScreen:
		call PlayGameOverSound 
		call ShowGameOver
		cmp inputChar, '1'
		je returnToMainMenu
		cmp inputChar, '2'
		je exitGame
		jmp exitGame

	showLevelPassedScreen:
		processLevelComplete:
		call ShowLevelPassed

		mov al, level
		cmp al, 1
		je goToLevel2
		cmp al, 2
		je goToLevel4

		jmp returnToMainMenu

		goToLevel2:
		mov level, 2
		jmp RestartLevelLoop 

		goToLevel4:
		mov level, 4
		jmp RestartLevelLoop

	returnToMainMenu:
		ret

	exitGame:
	ret
StartGame ENDP

; ============================================
; Displays the game title screen with roll number
; ============================================
ShowTitleScreen PROC
	call Clrscr

	mov eax, SKY_COLOR
	call SetTextColor

	mov dh, 0
	titleSkyLoop:
		cmp dh, SCREEN_HEIGHT
		jge titleDone
		mov dl, 0
		call Gotoxy
		mov ecx, SCREEN_WIDTH
		titleSkyLine:
			mov al, ' '
			call WriteChar
		loop titleSkyLine
		inc dh
		jmp titleSkyLoop

	titleDone:
	mov eax, yellow + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET strTitle
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strRollNumber
	call WriteString

	mov eax, white + (lightBlue * 16)
	call SetTextColor
	mov dl, 15
	mov dh, 5
	call Gotoxy
	mov al, '('
	call WriteChar
	mov al, ')'
	call WriteChar

	mov dl, 60
	mov dh, 6
	call Gotoxy
	mov al, '('
	call WriteChar
	mov al, ')'
	call WriteChar

	mov eax, GROUND_COLOR
	call SetTextColor
	mov dl, 0
	mov dh, 20
	call Gotoxy
	mov ecx, SCREEN_WIDTH
	titleGround:
		mov al, '='
		call WriteChar
	loop titleGround

	mov dl, 25
	mov dh, 15
	call Gotoxy
	mov eax, white + (black * 16)
	call SetTextColor
	mov edx, OFFSET strPressKey
	call WriteString

	call ReadChar
	ret
ShowTitleScreen ENDP

; ============================================
; Displays main menu and handles user selection
; ============================================
ShowMainMenu PROC
	call Clrscr

	mov eax, SKY_COLOR
	call SetTextColor

	mov dh, 0
	menuSkyLoop:
		cmp dh, SCREEN_HEIGHT
		jge menuDone
		mov dl, 0
		call Gotoxy
		mov ecx, SCREEN_WIDTH
		menuSkyLine:
			mov al, ' '
			call WriteChar
		loop menuSkyLine
		inc dh
		jmp menuSkyLoop

	menuDone:
	mov eax, yellow + (black * 16)
	call SetTextColor
	mov dl, 35
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET strStart
	call WriteString

	mov dl, 35
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strHighScore
	call WriteString

	mov dl, 35
	mov dh, 12
	call Gotoxy
	mov edx, OFFSET strLevels
	call WriteString

	mov dl, 35
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET strInstMenu
	call WriteString

	mov dl, 35
	mov dh, 16
	call Gotoxy
	mov edx, OFFSET strExit
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 18
	call Gotoxy
	mov edx, OFFSET strPressKey
	call WriteString

	menuInput:
		call ReadChar
		cmp al, '1'
		je menuSelected
		cmp al, '2'
		je menuSelected
		cmp al, '3'
		je menuSelected
		cmp al, '4'
		je menuSelected
		cmp al, '5'
		je menuSelected
		jmp menuInput

	menuSelected:
	mov inputChar, al
	ret
ShowMainMenu ENDP

; ============================================
; Displays game controls and instructions
; ============================================
ShowInstructions PROC
    call Clrscr
    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, 0
    fillInstScreen:
        cmp dh, SCREEN_HEIGHT
        jge instScreenFilled
        mov dl, 0
        call Gotoxy
        mov ecx, SCREEN_WIDTH
        fillInstRow:
            mov al, ' '
            call WriteChar
        loop fillInstRow
        inc dh
        jmp fillInstScreen
    instScreenFilled:
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 32
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET strInstTitle
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET strControlsHead
    call WriteString
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET strCtrlW
    call WriteString
    mov dl, 10
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET strCtrlA
    call WriteString
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET strCtrlS
    call WriteString
    mov dl, 10
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET strCtrlD
    call WriteString
    mov dl, 45
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET strCtrlP
    call WriteString
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET strMechHead
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET strMechUnder
    call WriteString
    mov dl, 10
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET strMechKill
    call WriteString
    mov dl, 10
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET strMechGoal
    call WriteString
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET strItemHead
    call WriteString
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 17
    call Gotoxy
    mov edx, OFFSET strItemGold
    call WriteString
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET strItemSlow
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET strInstExit
    call WriteString
    mov ecx, 5
    flushInst:
        call ReadKey
        jnz flushInst
    call ReadChar
    ret
ShowInstructions ENDP

ShowPauseMenu PROC
	mov isPaused, 1

	mov eax, black + (black * 16)
	call SetTextColor

	mov dh, 8
	drawOverlayRows:
		cmp dh, 17
		jge overlayDone
		mov dl, 25
		call Gotoxy
		mov ecx, 30
		drawOverlayLine:
			mov al, ' '
			call WriteChar
		loop drawOverlayLine
		inc dh
		jmp drawOverlayRows
	overlayDone:

	mov eax, white + (gray * 16)
	call SetTextColor

	mov dl, 25
	mov dh, 8
	call Gotoxy
	mov ecx, 30
	drawTopBorder:
		mov al, '='
		call WriteChar
	loop drawTopBorder

	mov dl, 25
	mov dh, 16
	call Gotoxy
	mov ecx, 30
	drawBottomBorder:
		mov al, '='
		call WriteChar
	loop drawBottomBorder

	mov dh, 9
	drawSideBorders:
		cmp dh, 16
		jge bordersDone
		mov dl, 25
		call Gotoxy
		mov al, '|'
		call WriteChar
		mov dl, 54
		call Gotoxy
		mov al, '|'
		call WriteChar
		inc dh
		jmp drawSideBorders
	bordersDone:

	mov eax, yellow + (black * 16)
	call SetTextColor
	mov dl, 40
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strPaused
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor

	mov dl, 30
	mov dh, 12
	call Gotoxy
	mov edx, OFFSET strResume
	call WriteString

	mov dl, 30
	mov dh, 13
	call Gotoxy
	mov edx, OFFSET strNewGame
	call WriteString

	mov dl, 30
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET strPauseExit
	call WriteString

	pauseInput:
		call ReadChar
		cmp al, '1'
		je pauseSelected
		cmp al, '2'
		je pauseSelected
		cmp al, '3'
		je pauseSelected
		cmp al, 27 
		je resumeWithESC
		jmp pauseInput

	resumeWithESC:
		mov al, '1' 
		jmp pauseSelected

	pauseSelected:
	mov inputChar, al
	ret
ShowPauseMenu ENDP

ShowHighScore PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	call LoadHighScores

	call Clrscr

	mov eax, white + (black * 16)
	call SetTextColor

	mov dl, 30
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET strHighScore
	call WriteString

	mov ecx, numHighScores
	cmp ecx, 0
	je noScoresYet

	mov esi, 0
	mov dh, 10  

	displayScoresLoop:
		cmp esi, ecx
		jge scoresDisplayed

		push ecx
		push edx

		mov eax, esi
		mov ebx, 50
		mul ebx
		mov edi, OFFSET highScoreNames
		add edi, eax  

		pop edx  
		push edx  
		mov dl, 20
		call Gotoxy

		mov edx, edi
		call WriteString

		mov al, ' '
		call WriteChar
		mov al, ':'
		call WriteChar
		mov al, ' '
		call WriteChar

		mov eax, esi
		mov ebx, 4
		mul ebx
		mov edx, OFFSET highScores
		add edx, eax
		mov eax, [edx]  
		call WriteInt

		pop edx  
		pop ecx  
		inc esi
		inc dh  
		jmp displayScoresLoop

	scoresDisplayed:
	jmp showPressKey

	noScoresYet:
	mov dl, 25
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strNoHighScores
	call WriteString

	showPressKey:
	mov dl, 25
	mov dh, 22
	call Gotoxy
	mov edx, OFFSET strPressKey
	call WriteString

	call ReadChar

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
ShowHighScore ENDP

UpdateHighScores PROC
	pushad

	call LoadHighScores

	mov eax, numHighScores
	cmp eax, max_highScores
	jge check_if_worthy     

	jmp add_new_score

check_if_worthy:
	mov esi, 9
	mov eax, esi
	mov ebx, 4
	mul ebx
	mov edx, OFFSET highScores
	add edx, eax
	mov ebx, [edx]          

	mov eax, score          
	cmp eax, ebx
	jle skip_save           

	mov numHighScores, 9    
	jmp add_new_score

add_new_score:
	mov esi, numHighScores

	mov eax, esi
	mov ebx, 4
	mul ebx
	mov edx, OFFSET highScores
	add edx, eax
	mov eax, score
	mov [edx], eax          

	mov eax, esi
	mov ebx, 50
	mul ebx
	mov edi, OFFSET highScoreNames
	add edi, eax            

	push esi
	mov esi, OFFSET playerName
	mov ecx, 50
copy_name_loop:
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	loop copy_name_loop
	pop esi

	inc numHighScores

	call SortHighScores

	cmp numHighScores, max_highScores
	jle save_now
	mov numHighScores, max_highScores

save_now:
	call SaveHighScores

skip_save:
	popad
	ret
UpdateHighScores ENDP

SortHighScores PROC
	pushad

	mov ecx, numHighScores
	dec ecx                 
	cmp ecx, 0
	jle sort_done           

outer_loop:
	push ecx                
	mov esi, 0              

inner_loop:
	mov eax, esi
	mov ebx, 4
	mul ebx
	mov edx, OFFSET highScores
	add edx, eax
	mov eax, [edx]          
	mov ebx, [edx+4]        
	cmp eax, ebx
	jge no_swap             

	mov [edx+4], eax
	mov [edx], ebx

	pushad
	mov eax, esi
	mov ebx, 50
	mul ebx
	mov edi, OFFSET highScoreNames
	add edi, eax            
	mov esi, edi
	add esi, 50             

	mov ecx, 50
swap_names_bytes:
	mov al, [edi]
	mov bl, [esi]
	mov [edi], bl
	mov [esi], al
	inc edi
	inc esi
	loop swap_names_bytes

	popad

no_swap:
	inc esi
	loop inner_loop         
	pop ecx                 
	loop outer_loop         

sort_done:
	popad
	ret
SortHighScores ENDP

LoadHighScores PROC
	pushad

	mov numHighScores, 0

	mov edx, OFFSET highScoreFileName
	call OpenInputFile
	cmp eax, INVALID_HANDLE_VALUE
	je load_fail
	mov fileHandle, eax

read_file_loop:
	cmp numHighScores, max_highScores
	jge close_load_file

	mov edi, OFFSET currentName
	mov ecx, 0 

read_name_char:
	push ecx
	push edi
	call ReadCharFromFile   
	pop edi
	pop ecx
	jc close_load_file      

	cmp al, ':'
	je name_done

	mov [edi], al
	inc edi
	inc ecx
	cmp ecx, 49             
	jl read_name_char
	jmp read_name_char      

name_done:
	mov byte ptr [edi], 0   

	push edi
	push ecx
	mov edi, OFFSET currentScoreStr
	mov ecx, 20
	clear_score_buf:
		mov BYTE PTR [edi], 0
		inc edi
		loop clear_score_buf
	pop ecx
	pop edi

	mov edi, OFFSET currentScoreStr
	mov ecx, 0

read_score_char:
	push ecx
	push edi
	call ReadCharFromFile
	pop edi
	pop ecx
	jc score_done_eof       
	cmp al, 0Dh             
	je read_score_char      
	cmp al, 0Ah             
	je score_done
	mov [edi], al
	inc edi
	inc ecx                 
	cmp ecx, 19             
	jl read_score_char
	jmp score_done          

score_done:
	mov byte ptr [edi], 0   

	call StoreLoadedData
	jmp read_file_loop

score_done_eof:
	mov byte ptr [edi], 0
	call StoreLoadedData
	jmp close_load_file

close_load_file:
	mov eax, fileHandle
	call CloseFile

load_fail:
	popad
	ret
LoadHighScores ENDP

ReadCharFromFile PROC
	push edx
	push ecx

	mov edx, OFFSET charBuf
	mov ecx, 1
	mov eax, fileHandle
	call ReadFromFile
	cmp eax, 0              
	je read_eof             

	mov al, charBuf
	clc                     
	jmp read_ret

read_eof:
	stc                     

read_ret:
	pop ecx
	pop edx
	ret
ReadCharFromFile ENDP

StoreLoadedData PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov edi, OFFSET currentScoreStr
	cmp BYTE PTR [edi], 0
	je skip_invalid_score   

	mov al, [edi]
	cmp al, '0'
	jl skip_invalid_score   
	cmp al, '9'
	jg skip_invalid_score   

	mov edx, OFFSET currentScoreStr
	call ParseStringToInt   

	push eax                

	mov esi, numHighScores

	mov eax, esi
	mov ecx, 4
	mul ecx
	mov edx, OFFSET highScores
	add edx, eax
	pop eax                 
	mov [edx], eax          

	mov eax, esi
	mov ecx, 50
	mul ecx
	mov edi, OFFSET highScoreNames
	add edi, eax            

	push esi
	mov esi, OFFSET currentName
	mov ecx, 50
copy_loaded_name:
	mov al, [esi]
	mov [edi], al
	inc esi
	inc edi
	loop copy_loaded_name
	pop esi

	inc numHighScores

store_done:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

skip_invalid_score:
	jmp store_done
StoreLoadedData ENDP

ParseStringToInt PROC
	push ebx
	push ecx
	push edx
	push esi

	mov esi, edx
	mov eax, 0  
	mov ebx, 10  

parse_loop:
	mov dl, [esi]
	cmp dl, 0  
	je parse_done
	cmp dl, 13  
	je parse_done
	cmp dl, 10  
	je parse_done
	cmp dl, '0'
	jl parse_done
	cmp dl, '9'
	jg parse_done

	push edx     
	movzx ecx, dl  
	sub cl, '0'    

	mov edx, 0
	mul ebx      

	movzx edx, cl  
	add eax, edx   

	pop edx      
	inc esi
	jmp parse_loop

parse_done:
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
ParseStringToInt ENDP

SaveHighScores PROC
	pushad  

	mov eax, numHighScores
	cmp eax, 0
	jle saveError  
	cmp eax, max_highScores
	jg saveError  

	mov edx, OFFSET highScoreFileName
	call CreateOutputFile
	cmp eax, INVALID_HANDLE_VALUE
	je saveError  
	cmp eax, 0
	je saveError
	mov fileHandle, eax

	mov esi, 0  

	writeLoop:
		cmp esi, numHighScores
		jge closeFileLabel
		cmp esi, max_highScores
		jge closeFileLabel

		push esi
		mov eax, esi
		mov edx, 50
		mul edx
		mov edi, OFFSET highScoreNames
		add edi, eax  

		push edi
		mov ecx, 0  
		mov edx, edi  
		countNameLen:
			cmp BYTE PTR [edi], 0
			je nameLenDone
			inc edi
			inc ecx
			cmp ecx, 50
			jl countNameLen
		nameLenDone:
		pop edi  
		pop esi

		mov eax, fileHandle
		mov edx, edi  
		call WriteToFile

		mov eax, fileHandle
		mov edx, OFFSET strColon
		mov ecx, 1
		call WriteToFile

		push esi
		mov eax, esi
		mov edx, 4
		mul edx
		mov edi, OFFSET highScores
		add edi, eax
		mov eax, [edi]  

		mov edx, OFFSET scoreString
		call IntToStringSimple
		pop esi

		push esi
		mov edi, OFFSET scoreString
		mov ecx, 0  
		countScoreLen:
			cmp BYTE PTR [edi], 0
			je scoreLenDone
			inc edi
			inc ecx
			cmp ecx, 20
			jl countScoreLen
		scoreLenDone:
		pop esi

		mov eax, fileHandle
		mov edx, OFFSET scoreString
		call WriteToFile

		mov eax, fileHandle
		mov edx, OFFSET strNewLine
		mov ecx, 2  
		call WriteToFile

		inc esi
		jmp writeLoop

	closeFileLabel:
	mov eax, fileHandle
	call CloseFile

	saveError:
	popad  
	ret
SaveHighScores ENDP

IntToStringSimple PROC
	push ebx
	push ecx
	push edi

	mov edi, edx  
	mov ebx, 10   
	mov ecx, 0    

	cmp eax, 0
	jne convertLoop
	mov BYTE PTR [edi], '0'
	inc edi
	mov BYTE PTR [edi], 0
	jmp done

	convertLoop:
		cmp eax, 0
		je reverseDigits
		mov edx, 0  
		div ebx      
		add dl, '0'  
		push dx      
		inc ecx
		jmp convertLoop

	reverseDigits:
		cmp ecx, 0
		je done
		pop ax
		mov [edi], al
		inc edi
		dec ecx
		jmp reverseDigits

	done:
	mov BYTE PTR [edi], 0  
	pop edi
	pop ecx
	pop ebx
	ret
IntToStringSimple ENDP

ConvertIntToString PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov edi, OFFSET scoreString
	mov esi, edi
	mov ebx, 10
	mov ecx, 0

	cmp eax, 0
	jne convertLoop
	mov BYTE PTR [edi], '0'
	inc edi
	mov BYTE PTR [edi], 0
	mov eax, 1
	jmp convertDone

	convertLoop:
		cmp eax, 0
		je reverseString
		mov edx, 0
		div ebx  
		add dl, '0'
		push edx  
		inc ecx
		jmp convertLoop

	reverseString:
		cmp ecx, 0
		je convertDone
		pop edx
		mov [edi], dl
		inc edi
		dec ecx
		jmp reverseString

	convertDone:
	mov BYTE PTR [edi], 0  
	mov eax, edi
	sub eax, esi  

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
ConvertIntToString ENDP


SaveHighScoreName PROC
	push eax
	push ecx
	push esi
	push edi

	mov esi, OFFSET playerName
	mov edi, OFFSET highScoreName
	mov ecx, 50  

	copyName:
		mov al, [esi]
		mov [edi], al
		inc esi
		inc edi
		cmp al, 0  
		je nameCopied
		dec ecx
		cmp ecx, 0
		jne copyName

	nameCopied:
	mov BYTE PTR [edi], 0

	pop edi
	pop esi
	pop ecx
	pop eax
	ret
SaveHighScoreName ENDP

GetPlayerName PROC
	push eax
	push edx
	push ecx
	push esi

	call Clrscr

	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strEnterName
	call WriteString

	mov dl, 30
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET strLevelStart
	call WriteString
	movzx eax, level
	call WriteInt

	mov dl, 30
	mov dh, 13
	call Gotoxy

	mov edx, OFFSET playerName
	mov ecx, 49  
	call ReadString

	mov playerNameLength, eax

	mov esi, OFFSET playerName
	add esi, eax
	mov BYTE PTR [esi], 0  

	cmp eax, 0
	jne nameEntered
	mov playerName[0], 'P'
	mov playerName[1], 'l'
	mov playerName[2], 'a'
	mov playerName[3], 'y'
	mov playerName[4], 'e'
	mov playerName[5], 'r'
	mov playerName[6], 0
	mov playerNameLength, 6

	nameEntered:
	pop esi
	pop ecx
	pop edx
	pop eax
	ret
GetPlayerName ENDP


strLevelsTitle BYTE "SELECT LEVEL",0
strLevel1 BYTE "1. Level 1 - World 1-1",0
strLevel2 BYTE "2. Level 2 - World 1-2",0
strLevel3 BYTE "3. Level 3 - (Coming soon)",0
strLevel4 BYTE "4. Level 4 - World 1-4 (Castle)",0
strLevelNotImpl BYTE "Level not implemented yet. Press any key to return.",0

ShowLevels PROC
	call Clrscr

	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 33
	mov dh, 5
	call Gotoxy
	mov edx, OFFSET strLevelsTitle
	call WriteString

	mov dl, 30
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET strLevel1
	call WriteString

	mov dl, 30
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strLevel2
	call WriteString

	mov dl, 30
	mov dh, 12
	call Gotoxy
	mov edx, OFFSET strLevel3
	call WriteString

	mov dl, 30
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET strLevel4
	call WriteString

	mov dl, 25
	mov dh, 18
	call Gotoxy
	mov edx, OFFSET strPressKey
	call WriteString

levelInput:
	call ReadChar
	cmp al, '1'
	je selectLevel1
	cmp al, '2'
	je selectLevel2
	cmp al, '3'
	je levelNotImplemented
	cmp al, '4'
	je selectLevel4
	jmp endShowLevels

selectLevel1:
	mov level, 1
	call StartGame
	jmp endShowLevels

selectLevel2:
	mov level, 2
	call StartGame
	jmp endShowLevels

selectLevel4:
	mov level, 4
	call StartGame
	jmp endShowLevels

levelNotImplemented:
	call Clrscr
	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 10
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strLevelNotImpl
	call WriteString
	call ReadChar

endShowLevels:
	ret
ShowLevels ENDP

ShowGameOver PROC
	call Clrscr

	mov eax, black + (black * 16)
	call SetTextColor

	mov dh, 0
	fillScreen:
		cmp dh, SCREEN_HEIGHT
		jge screenFilled
		mov dl, 0
		call Gotoxy
		mov ecx, SCREEN_WIDTH
		fillRow:
			mov al, ' '
			call WriteChar
		loop fillRow
		inc dh
		jmp fillScreen
	screenFilled:

	mov eax, red + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET strGameOver
	call WriteString

	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strScore
	call WriteString
	mov eax, score
	call WriteInt

	cmp BYTE PTR playerName[0], 0
	jne nameIsValidGO
	mov playerName[0], 'P'
	mov playerName[1], 'l'
	mov playerName[2], 'a'
	mov playerName[3], 'y'
	mov playerName[4], 'e'
	mov playerName[5], 'r'
	mov playerName[6], 0
	mov playerNameLength, 6

	nameIsValidGO:
	call UpdateHighScores


	mov dl, 30
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET strGameOverReturn
	call WriteString

	mov dl, 30
	mov dh, 15
	call Gotoxy
	mov edx, OFFSET strGameOverExit
	call WriteString

	menuInput:
		call ReadChar
		cmp al, '1'
		je menuSelected
		cmp al, '2'
		je menuSelected
		jmp menuInput

	menuSelected:
	mov inputChar, al
	ret
ShowGameOver ENDP

ShowLevelPassed PROC
	; 1. Clear Screen & Draw Background
	call Clrscr

	mov eax, black + (black * 16)
	call SetTextColor

	mov dh, 0
	fillScreenLP:
		cmp dh, SCREEN_HEIGHT
		jge screenFilledLP
		mov dl, 0
		call Gotoxy
		mov ecx, SCREEN_WIDTH
		fillRowLP:
			mov al, ' '
			call WriteChar
		loop fillRowLP
		inc dh
		jmp fillScreenLP
	screenFilledLP:

	mov eax, green + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET strLevelPassed
	call WriteString

	mov eax, timer
	mov ebx, 50
	mul ebx       
	add score, eax 

	cmp BYTE PTR playerName[0], 0
	jne nameIsValidLP
	mov playerName[0], 'P'
	mov playerName[1], 'l'
	mov playerName[2], 'a'
	mov playerName[3], 'y'
	mov playerName[4], 'e'
	mov playerName[5], 'r'
	mov playerName[6], 0
	mov playerNameLength, 6
	nameIsValidLP:
	call UpdateHighScores

	mov eax, white + (black * 16)
	call SetTextColor
	mov dl, 30
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET strScore
	call WriteString
	mov eax, score
	call WriteInt

	mov dl, 30
	mov dh, 12
	call Gotoxy
	mov al, '+'
	call WriteChar
	mov eax, timer
	mov ebx, 50
	mul ebx
	call WriteInt
	mov edx, OFFSET strTimeBonus
	call WriteString

	movzx eax, level
	cmp eax, 4
	jge allLevelsComplete

	mov dl, 25
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET strMovingToNext
	call WriteString
	jmp doDelay

	allLevelsComplete:
	mov dl, 25
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET strAllLevelsComplete
	call WriteString

	doDelay:
	mov eax, 3000
	call Delay

	mov ecx, 10
	flushLoop:
		call ReadKey
		jnz flushLoop
	ret
ShowLevelPassed ENDP

SetTimerForLevel PROC
	push eax
	push ebx
	push esi

	movzx eax, level
	dec eax 

	cmp eax, max_levels
	jge useMaxLevel
	cmp eax, 0
	jl useLevel1

	mov ebx, 4
	mul ebx 

	mov esi, OFFSET levelTimeLimits
	add esi, eax
	mov eax, [esi]
	mov timer, eax
	jmp timerSet

	useLevel1:
	mov timer, 90 
	jmp timerSet

	useMaxLevel:
	mov esi, OFFSET levelTimeLimits
	mov eax, max_levels
	dec eax
	mov ebx, 4
	mul ebx
	add esi, eax
	mov eax, [esi]
	mov timer, eax

	timerSet:
	pop esi
	pop ebx
	pop eax
	ret
SetTimerForLevel ENDP

DrawHUD PROC
	pushad 

	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 1
	call Gotoxy
	mov edx, OFFSET strScore
	call WriteString
	mov ecx, 5
	clearScore:
		mov al, ' '
		call WriteChar
	loop clearScore
	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 1
	call Gotoxy
	mov edx, OFFSET strScore
	call WriteString
	mov eax, score
	call WriteInt

	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 3
	call Gotoxy
	mov edx, OFFSET strCoins
	call WriteString
	mov ecx, 3
	clearCoins:
		mov al, ' '
		call WriteChar
	loop clearCoins
	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 3
	call Gotoxy
	mov edx, OFFSET strCoins
	call WriteString
	movzx eax, coins
	call WriteInt

	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 5
	call Gotoxy
	mov edx, OFFSET strWorld
	call WriteString
	movzx eax, world
	call WriteInt
	mov al, '-'
	call WriteChar
	movzx eax, level
	call WriteInt

	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 7
	call Gotoxy
	mov edx, OFFSET strTimer
	call WriteString
	mov ecx, 4
	clearTimer:
		mov al, ' '
		call WriteChar
	loop clearTimer
	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 7
	call Gotoxy
	mov edx, OFFSET strTimer
	call WriteString
	mov eax, timer
	call WriteInt

	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 9
	call Gotoxy
	mov edx, OFFSET strLives
	call WriteString
	mov ecx, 2
	clearLives:
		mov al, ' '
		call WriteChar
	loop clearLives
	mov dl, GAME_RIGHT_WALL + 2
	mov dh, 9
	call Gotoxy
	mov edx, OFFSET strLives
	call WriteString
	movzx eax, lives
	call WriteInt

	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy

	popad 
	ret
DrawHUD ENDP

; ============================================
; Draws the player character at current position
; Handles both normal and super Mario states
; ============================================
DrawPlayer PROC
	push edx
	push eax

	cmp isInvincible, 1
	je setupGoldColors

	mov al, level
	cmp al, 4
	je useCastleMarioColor

	cmp al, 2
	jne useNormalMarioColor
	mov al, currentPage
	cmp al, 3
	je useRedMarioColor
	cmp al, 5
	je useRedMarioColor
	jmp useNormalMarioColor

	useCastleMarioColor:
	mov eax, blue + (black * 16)
	jmp marioColorSet
	useRedMarioColor:
	mov eax, blue + (red * 16)
	jmp marioColorSet
	useNormalMarioColor:
	mov eax, MARIO_COLOR
	jmp marioColorSet

	setupGoldColors:
	mov al, level
	cmp al, 4
	je goldMarioBlack

	cmp al, 2
	jne goldMarioBlue
	mov al, currentPage
	cmp al, 3
	je goldMarioRed
	cmp al, 5
	je goldMarioRed
	jmp goldMarioBlue

	goldMarioBlack:
	mov eax, yellow + (black * 16)
	jmp marioColorSet
	goldMarioRed:
	mov eax, yellow + (red * 16)
	jmp marioColorSet
	goldMarioBlue:
	mov eax, yellow + (lightBlue * 16)

marioColorSet:
	call SetTextColor

	cmp isSuper, 1
	jne drawNormalMario

	mov dl, xPos
	mov dh, yPos
	dec dh
	dec dh
	call Gotoxy
	mov al, "X"
	call WriteChar

	mov dl, xPos
	mov dh, yPos
	dec dh
	call Gotoxy
	mov al, "X"
	call WriteChar

	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, "X"
	call WriteChar
	jmp doneDrawMario

drawNormalMario:
	mov dl, xPos
	mov dh, yPos
	dec dh
	call Gotoxy
	mov al, "X"
	call WriteChar

	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, "X"
	call WriteChar

doneDrawMario:
	pop eax
	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy
	pop edx
	ret
DrawPlayer ENDP

; ============================================
; Erases player from old position before movement
; Uses appropriate background color based on level
; ============================================
UpdatePlayer PROC
	push edx
	push eax

	mov al, level
	cmp al, 4
	je useCastleEraseColor
	cmp al, 2
	jne useSkyColorErase
	mov al, currentPage
	cmp al, 3
	je useRedEraseColor
	cmp al, 5
	je useRedEraseColor
	jmp useSkyColorErase
useCastleEraseColor:
	mov eax, CASTLE_SKY_COLOR
	jmp eraseColorSet
useRedEraseColor:
	mov eax, black + (red * 16)
	jmp eraseColorSet
useSkyColorErase:
	mov eax, SKY_COLOR
eraseColorSet:
	call SetTextColor

	cmp isSuper, 1
	jne clearNormalMario

	mov dl, xPos
	mov dh, yPos
	dec dh
	dec dh
	call EraseTileSafe 

	mov dl, xPos
	mov dh, yPos
	dec dh
	call EraseTileSafe

	mov dl, xPos
	mov dh, yPos
	call EraseTileSafe
	jmp doneClearMario

clearNormalMario:
	mov dl, xPos
	mov dh, yPos
	dec dh
	call EraseTileSafe

	mov dl, xPos
	mov dh, yPos
	call EraseTileSafe

doneClearMario:
	pop eax
	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy

	pop edx
	ret
UpdatePlayer ENDP

; ============================================
; Redraws background elements if needed
; ============================================
EraseTileSafe PROC
	push eax

	cmp dh, GAME_TOP
	jle redrawCeilingTile

	cmp dl, GAME_LEFT_WALL
	je redrawWallTile

	cmp dl, GAME_RIGHT_WALL + 1
	je redrawWallTile

	call Gotoxy
	mov al, " "
	call WriteChar

	push eax
	mov al, level
	cmp al, 4
	je skipBGRedraw
	call RedrawHillsAtPosition
	call RedrawCloudsAtPosition
	skipBGRedraw:
	pop eax

	jmp eraseTileDone

redrawCeilingTile:
	call SetWallColorForLevel
	call Gotoxy
	mov al, '='
	call WriteChar
	jmp eraseTileDone

redrawWallTile:
	call SetWallColorForLevel
	call Gotoxy
	mov al, '='
	call WriteChar

eraseTileDone:
	pop eax
	ret
EraseTileSafe ENDP

; ============================================
; Sets wall color based on current level
; Castle levels use gray, others use brown
; ============================================
SetWallColorForLevel PROC
	push eax
	mov al, level
	cmp al, 4
	je setGrayWall
	mov eax, white + (brown * 16)
	jmp applyWallColor
setGrayWall:
	mov eax, CASTLE_WALL_COLOR
applyWallColor:
	call SetTextColor
	pop eax
	ret
SetWallColorForLevel ENDP

DrawPlatforms PROC
    mov al, level
    cmp al, 4
    je useCastlePlatColor

    mov eax, PLATFORM_COLOR
    jmp setPlatColor
useCastlePlatColor:
    mov eax, CASTLE_WALL_COLOR
setPlatColor:
    call SetTextColor

    movzx ecx, numPlatforms
    mov esi, 0

    drawLoop:
        mov dh, platY[esi] 
        mov dl, platX[esi] 

        push ecx
        mov cl, platW[esi] 
        mov ch, 0

        drawBrick:
            call Gotoxy
            mov al, '='
            call WriteChar
            inc dl
        loop drawBrick

        pop ecx
        inc esi
    loop drawLoop

    push edx
    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP + 1
    call Gotoxy
    pop edx
    ret
DrawPlatforms ENDP


SpawnAllCoins PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi

	movzx ecx, numCoins
	mov esi, 0

	spawnCoinLoop:
		mov eax, GAME_RIGHT_WALL - GAME_LEFT_WALL - 3
		call RandomRange
		add eax, GAME_LEFT_WALL + 2
		mov coinX[esi], al

		mov eax, GAME_BOTTOM - GAME_TOP - 2
		call RandomRange
		add eax, GAME_TOP + 2
		mov coinY[esi], al

		mov coinActive[esi], 1

		inc esi
	loop spawnCoinLoop

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
SpawnAllCoins ENDP

DrawAllCoins PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    movzx ecx, numCoins
    cmp ecx, 0
    je coinsDone
    cmp ecx, 10
    jg coinsDone

    mov al, level
    cmp al, 4
    je useCastleCoinColor

    cmp al, 2
    jne useNormalCoinColor
    mov al, currentPage
    cmp al, 3
    je useRedCoinColor
    cmp al, 5
    je useRedCoinColor
    jmp useNormalCoinColor

useCastleCoinColor:
    mov eax, yellow + (black * 16)
    jmp coinColorSet

useRedCoinColor:
    mov eax, yellow + (red * 16)
    jmp coinColorSet

useNormalCoinColor:
    mov eax, COIN_COLOR

coinColorSet:
    call SetTextColor

    mov esi, 0

    drawCoinLoop:
        mov al, coinActive[esi]
        cmp al, 0
        je skipCoinDraw

        mov dl, coinX[esi]
        mov dh, coinY[esi]
        call Gotoxy
        mov al, 'O'
        call WriteChar

        skipCoinDraw:
        inc esi
    loop drawCoinLoop

    coinsDone:
    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP + 1
    call Gotoxy

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawAllCoins ENDP

DrawLava PROC
    pushad

    mov al, level
    cmp al, 4
    jne lavaDone

    mov eax, LAVA_COLOR
    call SetTextColor

    mov dl, GAME_LEFT_WALL + 1

lavaXLoop:
    cmp dl, GAME_RIGHT_WALL
    jge lavaDone

    movzx ecx, numPlatforms
    cmp ecx, 0
    je drawTheLava 

    mov esi, 0
    checkPlatLoop:
        mov al, platY[esi]
        cmp al, 17
        jne nextPlatCheck

        mov al, platX[esi]
        cmp dl, al
        jl nextPlatCheck 

        add al, platW[esi]
        cmp dl, al
        jl skipLavaDraw 

    nextPlatCheck:
        inc esi
        loop checkPlatLoop

drawTheLava:
    mov dh, GROUND_START 
    call Gotoxy
    mov al, '~'
    call WriteChar

skipLavaDraw:
    inc dl
    jmp lavaXLoop

lavaDone:
    popad
    ret
DrawLava ENDP


DrawMushroom PROC
	push eax
	push edx

	mov al, level
	cmp al, 2
	jne noMushroomDraw

	mov al, currentPage
	cmp al, mushroomPage
	jne noMushroomDraw

	mov al, mushroomActive
	cmp al, 1
	jne noMushroomDraw

	mov eax, yellow + (lightBlue * 16)
	call SetTextColor

	mov dl, mushroomX
	mov dh, mushroomY
	call Gotoxy
	mov al, "M"
	call WriteChar

noMushroomDraw:
	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy

	pop edx
	pop eax
	ret
DrawMushroom ENDP

CheckMushroomCollection PROC
	push eax
	push edx

	mov al, level
	cmp al, 2
	jne noMushroomCollect

	mov al, currentPage
	cmp al, mushroomPage
	jne noMushroomCollect

	mov al, mushroomActive
	cmp al, 1
	jne noMushroomCollect

	mov al, xPos
	cmp al, mushroomX
	jne noMushroomCollect
	mov al, yPos
	cmp al, mushroomY
	jne noMushroomCollect

	mov mushroomActive, 0      

	call UpdatePlayer
	mov isSuper, 1
	mov superFrames, SUPER_DURATION_FRAMES

	mov eax, SUPER_MARIO_COLOR
	call SetTextColor

	call DrawPlayer

noMushroomCollect:
	pop edx
	pop eax
	ret
CheckMushroomCollection ENDP

CheckCoinCollection PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi

	movzx ecx, numCoins
	cmp ecx, 0          
	je coinsCheckDone   

	mov esi, 0

	checkCoinLoop:
		mov al, coinActive[esi]
		cmp al, 0
		je nextCoin

		mov bl, coinX[esi]
		mov bh, coinY[esi]

		mov dl, xPos
		mov dh, yPos

		cmp dl, bl
		jne checkHead

		cmp dh, bh
		je collectCoin

		checkHead:
		mov dl, xPos
		mov dh, yPos
		dec dh 

		cmp dl, bl
		jne nextCoin

		cmp dh, bh
		je collectCoin

		jmp nextCoin

		collectCoin:
		mov coinActive[esi], 0

		mov al, level
		cmp al, 2
		je storeCoinLevel2
		cmp al, 4
		je storeCoinLevel4 

		mov al, currentPage
		cmp al, 1
		je storeCoinPg1_W1
		cmp al, 2
		je storeCoinPg2_W1
		cmp al, 3
		je storeCoinPg3_W1
		jmp coinStateStored

		storeCoinPg1_W1:
		mov world1pg1_coinActive[esi], 0
		jmp coinStateStored

		storeCoinPg2_W1:
		mov world1pg2_coinActive[esi], 0
		jmp coinStateStored

		storeCoinPg3_W1:
		mov world1pg3_coinActive[esi], 0
		jmp coinStateStored

		storeCoinLevel4:
		mov al, currentPage
		cmp al, 1
		je storeCoinPg1_W4
		cmp al, 2
		je storeCoinPg2_W4
		jmp coinStateStored

		storeCoinPg1_W4:
		mov world4pg1_coinActive[esi], 0
		jmp coinStateStored
		storeCoinPg2_W4:
		mov world4pg2_coinActive[esi], 0
		jmp coinStateStored

		storeCoinLevel2:
		mov al, currentPage
		cmp al, 1
		je storeCoinPg1_W2
		cmp al, 2
		je storeCoinPg2_W2
		cmp al, 3
		je storeCoinPg3_W2
		cmp al, 4
		je storeCoinPg4_W2
		cmp al, 5
		je storeCoinPg5_W2
		jmp coinStateStored

		storeCoinPg1_W2:
		mov world2pg1_coinActive[esi], 0
		jmp coinStateStored

		storeCoinPg2_W2:
		mov world2pg2_coinActive[esi], 0
		jmp coinStateStored

		storeCoinPg3_W2:
		mov world2pg3_coinActive[esi], 0
		jmp coinStateStored

		storeCoinPg4_W2:
		mov world2pg4_coinActive[esi], 0
		jmp coinStateStored

		storeCoinPg5_W2:
		mov world2pg5_coinActive[esi], 0
		jmp coinStateStored

		coinStateStored:

		push eax

		mov al, level
		cmp al, 4
		je useCastleCoinEraseColor
		cmp al, 2
		jne useSkyColorCoinErase
		mov al, currentPage
		cmp al, 3
		je useRedCoinEraseColor
		cmp al, 5
		je useRedCoinEraseColor
		jmp useSkyColorCoinErase
		useCastleCoinEraseColor:
		mov eax, CASTLE_SKY_COLOR
		jmp coinEraseColorSet
		useRedCoinEraseColor:
		mov eax, black + (red * 16)
		jmp coinEraseColorSet
	useSkyColorCoinErase:
		mov eax, SKY_COLOR
	coinEraseColorSet:
		call SetTextColor
		mov dl, coinX[esi]
		mov dh, coinY[esi]
		call Gotoxy
		mov al, ' '
		call WriteChar
		pop eax

		call PlayCoinSound

		add score, 200 
		inc coins

		call DrawHUD

		nextCoin:
		inc esi
		dec ecx
		jnz checkCoinLoop

	coinsCheckDone:
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
CheckCoinCollection ENDP

DrawGoldenMushroom PROC
	push eax
	push edx

	cmp goldenMushroomActive, 1
	jne doneDrawGold

	mov al, level
	cmp al, 4
	je goldOnBlack

	cmp al, 2
	jne goldOnBlue
	mov al, currentPage
	cmp al, 3
	je goldOnRed
	cmp al, 5
	je goldOnRed
	jmp goldOnBlue

	goldOnBlack:
	mov eax, yellow + (black * 16)
	jmp setGoldColor

	goldOnRed:
	mov eax, yellow + (red * 16)
	jmp setGoldColor

	goldOnBlue:
	mov eax, yellow + (lightBlue * 16)

	setGoldColor:
	call SetTextColor

	mov dl, goldenMushroomX
	mov dh, goldenMushroomY
	call Gotoxy
	mov al, 'M'
	call WriteChar

	doneDrawGold:
	pop edx
	pop eax
	ret
DrawGoldenMushroom ENDP

CheckGoldenMushroomCollection PROC
	push eax
	push edx

	cmp goldenMushroomActive, 1
	jne doneCheckGold

	mov al, xPos
	cmp al, goldenMushroomX
	jne doneCheckGold
	mov al, yPos
	cmp al, goldenMushroomY
	jne doneCheckGold

	mov goldenMushroomActive, 0
	mov goldenMushroomCollected, 1
	add score, 1000
	call DrawHUD
	mov isInvincible, 1
	mov invincibleTimer, INVINCIBLE_DURATION
	call DrawPlayer
	call PlayWinSound

	doneCheckGold:
	pop edx
	pop eax
	ret
CheckGoldenMushroomCollection ENDP

; ============================================
; Draws the Slow Motion item ('S' in Cyan)
; ============================================
DrawSlowMotionItem PROC
	push eax
	push edx

	cmp slowMotionItemActive, 1
	jne doneDrawSlow

	mov al, level
	cmp al, 4
	je useCastleSlowColor
	mov eax, SLOW_MO_COLOR 
	jmp setSlowColor

	useCastleSlowColor:
	mov eax, cyan + (black * 16) 

	setSlowColor:
	call SetTextColor

	mov dl, slowMotionItemX
	mov dh, slowMotionItemY
	call Gotoxy
	mov al, 'S'
	call WriteChar

	doneDrawSlow:
	pop edx
	pop eax
	ret
DrawSlowMotionItem ENDP

; ============================================
; Checks collision with Slow Motion item
; Activates slow motion for 10 seconds
; ============================================
CheckSlowMotionCollection PROC
	push eax
	push edx

	cmp slowMotionItemActive, 1
	jne doneCheckSlow

	mov al, xPos
	cmp al, slowMotionItemX
	jne doneCheckSlow
	mov al, yPos
	cmp al, slowMotionItemY
	jne doneCheckSlow

	mov slowMotionItemActive, 0
	mov slowMotionCollected, 1

	mov isSlowMotion, 1
	mov slowMotionTimer, SLOW_MO_DURATION
	mov currentDelay, SLOW_DELAY 

	add score, 500
	call DrawHUD
	call PlayCoinSound 

	doneCheckSlow:
	pop edx
	pop eax
	ret
CheckSlowMotionCollection ENDP

LoadPage1 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world1pg1_numBlocks
	mov esi, 0
copyBlocksPg1:
		mov al, world1pg1_blockX[esi]
		mov blockX[esi], al
		mov al, world1pg1_blockY[esi]
		mov blockY[esi], al
		mov al, world1pg1_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksPg1
	mov al, world1pg1_numBlocks
	mov numBlocks, al

	mov ecx, world1pg1_numPlatforms
	mov esi, 0
copyPlatformsPg1:
		mov al, world1pg1_platX[esi]
		mov platX[esi], al
		mov al, world1pg1_platY[esi]
		mov platY[esi], al
		mov al, world1pg1_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsPg1
	mov al, world1pg1_numPlatforms
	mov numPlatforms, al

	mov ecx, world1pg1_numHills
	mov esi, 0
copyHillsPg1:
		mov al, world1pg1_hillX[esi]
		mov hillX[esi], al
		mov al, world1pg1_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsPg1
	mov al, world1pg1_numHills
	mov numHills, al

	mov ecx, world1pg1_numClouds
	mov esi, 0
copyCloudsPg1:
		mov al, world1pg1_cloudX[esi]
		mov cloudX[esi], al
		mov al, world1pg1_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsPg1
	mov al, world1pg1_numClouds
	mov numClouds, al

	mov ecx, world1pg1_numEnemies
	mov esi, 0
copyEnemiesPg1:
		mov al, world1pg1_enemyX[esi]
		mov enemyX[esi], al
		mov al, world1pg1_enemyY[esi]
		mov enemyY[esi], al
		mov al, world1pg1_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world1pg1_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world1pg1_enemyType[esi]
		mov enemyType[esi], al
		mov al, world1pg1_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world1pg1_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesPg1
	mov al, world1pg1_numEnemies
	mov numEnemies, al

	mov ecx, world1pg1_numCoins
	mov esi, 0
	copyCoinsPg1:
		mov al, world1pg1_coinX[esi]
		mov coinX[esi], al
		mov al, world1pg1_coinY[esi]
		mov coinY[esi], al
		mov al, world1pg1_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsPg1
	mov al, world1pg1_numCoins
	mov numCoins, al

	mov ecx, world1pg1_numPipes
	mov numPipes, cl 
	cmp ecx, 0
	je skipPipesPg1
	mov esi, 0
copyPipesPg1:
	mov al, world1pg1_pipeX[esi]
	mov pipeX[esi], al
	mov al, world1pg1_pipeY[esi]
	mov pipeY[esi], al
	mov al, world1pg1_pipeH[esi]
	mov pipeH[esi], al
	inc esi
	loop copyPipesPg1
skipPipesPg1:

	mov goldenMushroomActive, 0
	
	cmp slowMotionCollected, 1
	je skipSpawnSlowMoPg1
	
	mov slowMotionItemActive, 1
	mov slowMotionItemX, 60
	mov slowMotionItemY, 12
	jmp doneSpawnSlowMoPg1
	
	skipSpawnSlowMoPg1:
	mov slowMotionItemActive, 0
	
	doneSpawnSlowMoPg1:
	
	mov currentPage, 1 

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadPage1 ENDP

LoadPage2 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world1pg2_numBlocks
	mov esi, 0
	copyBlocks:
		mov al, world1pg2_blockX[esi]
		mov blockX[esi], al
		mov al, world1pg2_blockY[esi]
		mov blockY[esi], al
		mov al, world1pg2_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocks
	mov al, world1pg2_numBlocks
	mov numBlocks, al

	mov ecx, world1pg2_numCoins
	mov esi, 0
	copyCoins:
		mov al, world1pg2_coinX[esi]
		mov coinX[esi], al
		mov al, world1pg2_coinY[esi]
		mov coinY[esi], al
		mov al, world1pg2_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoins

	mov ecx, world1pg2_numEnemies
	mov esi, 0
	copyEnemies:
		mov al, world1pg2_enemyX[esi]
		mov enemyX[esi], al
		mov al, world1pg2_enemyY[esi]
		mov enemyY[esi], al
		mov al, world1pg2_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world1pg2_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world1pg2_enemyType[esi]
		mov enemyType[esi], al
		mov al, world1pg2_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world1pg2_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemies
	mov al, world1pg2_numEnemies
	mov numEnemies, al

	mov ecx, world1pg2_numPlatforms
	mov esi, 0
	copyPlatforms:
		mov al, world1pg2_platX[esi]
		mov platX[esi], al
		mov al, world1pg2_platY[esi]
		mov platY[esi], al
		mov al, world1pg2_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatforms
	mov al, world1pg2_numPlatforms
	mov numPlatforms, al

	mov ecx, world1pg2_numHills
	mov esi, 0
	copyHills:
		mov al, world1pg2_hillX[esi]
		mov hillX[esi], al
		mov al, world1pg2_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHills
	mov al, world1pg2_numHills
	mov numHills, al

	mov ecx, world1pg2_numClouds
	mov esi, 0
	copyClouds:
		mov al, world1pg2_cloudX[esi]
		mov cloudX[esi], al
		mov al, world1pg2_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyClouds
	mov al, world1pg2_numClouds
	mov numClouds, al

	mov ecx, world1pg2_numPipes
	mov numPipes, cl 
	cmp ecx, 0
	je skipPipesPg2
	mov esi, 0
copyPipesPg2:
	mov al, world1pg2_pipeX[esi]
	mov pipeX[esi], al
	mov al, world1pg2_pipeY[esi]
	mov pipeY[esi], al
	mov al, world1pg2_pipeH[esi]
	mov pipeH[esi], al
	inc esi
	loop copyPipesPg2
skipPipesPg2:

	mov goldenMushroomActive, 0
	
	cmp slowMotionCollected, 1
	je skipSpawnSlowMo
	
	mov slowMotionItemActive, 1
	mov slowMotionItemX, 35
	mov slowMotionItemY, 15
	jmp doneSpawnSlowMo
	
	skipSpawnSlowMo:
	mov slowMotionItemActive, 0
	
	doneSpawnSlowMo:
	
	mov currentPage, 2

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadPage2 ENDP

LoadPage3 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world1pg3_numBlocks
	mov esi, 0
copyBlocksPg3:
		mov al, world1pg3_blockX[esi]
		mov blockX[esi], al
		mov al, world1pg3_blockY[esi]
		mov blockY[esi], al
		mov al, world1pg3_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksPg3
	mov al, world1pg3_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world1pg3_numCoins
	mov esi, 0
copyCoinsPg3:
		mov al, world1pg3_coinX[esi]
		mov coinX[esi], al
		mov al, world1pg3_coinY[esi]
		mov coinY[esi], al
		mov al, world1pg3_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsPg3

	mov ecx, world1pg3_numEnemies
	mov esi, 0
copyEnemiesPg3:
		mov al, world1pg3_enemyX[esi]
		mov enemyX[esi], al
		mov al, world1pg3_enemyY[esi]
		mov enemyY[esi], al
		mov al, world1pg3_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world1pg3_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world1pg3_enemyType[esi]
		mov enemyType[esi], al
		mov al, world1pg3_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world1pg3_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesPg3
	mov al, world1pg3_numEnemies
	mov numEnemies, al

	mov ecx, world1pg3_numPlatforms
	mov esi, 0
copyPlatformsPg3:
		mov al, world1pg3_platX[esi]
		mov platX[esi], al
		mov al, world1pg3_platY[esi]
		mov platY[esi], al
		mov al, world1pg3_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsPg3
	mov al, world1pg3_numPlatforms
	mov numPlatforms, al

	mov ecx, world1pg3_numHills
	mov esi, 0
copyHillsPg3:
		mov al, world1pg3_hillX[esi]
		mov hillX[esi], al
		mov al, world1pg3_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsPg3
	mov al, world1pg3_numHills
	mov numHills, al

	mov ecx, world1pg3_numClouds
	mov esi, 0
copyCloudsPg3:
		mov al, world1pg3_cloudX[esi]
		mov cloudX[esi], al
		mov al, world1pg3_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsPg3
	mov al, world1pg3_numClouds
	mov numClouds, al

	mov goldenMushroomActive, 0
	mov slowMotionItemActive, 0
	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadPage3 ENDP


LoadLevel2Page1 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world2pg1_numBlocks
	mov esi, 0
copyBlocksLvl2Pg1:
		mov al, world2pg1_blockX[esi]
		mov blockX[esi], al
		mov al, world2pg1_blockY[esi]
		mov blockY[esi], al
		mov al, world2pg1_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksLvl2Pg1
	mov al, world2pg1_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world2pg1_numPlatforms
	mov esi, 0
copyPlatformsLvl2Pg1:
		mov al, world2pg1_platX[esi]
		mov platX[esi], al
		mov al, world2pg1_platY[esi]
		mov platY[esi], al
		mov al, world2pg1_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsLvl2Pg1
	mov al, world2pg1_numPlatforms
	mov numPlatforms, al

	mov ecx, world2pg1_numHills
	mov esi, 0
copyHillsLvl2Pg1:
		mov al, world2pg1_hillX[esi]
		mov hillX[esi], al
		mov al, world2pg1_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsLvl2Pg1
	mov al, world2pg1_numHills
	mov numHills, al

	mov ecx, world2pg1_numClouds
	mov esi, 0
copyCloudsLvl2Pg1:
		mov al, world2pg1_cloudX[esi]
		mov cloudX[esi], al
		mov al, world2pg1_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsLvl2Pg1
	mov al, world2pg1_numClouds
	mov numClouds, al

	mov ecx, world2pg1_numEnemies
	mov esi, 0
copyEnemiesLvl2Pg1:
		mov al, world2pg1_enemyX[esi]
		mov enemyX[esi], al
		mov al, world2pg1_enemyY[esi]
		mov enemyY[esi], al
		mov al, world2pg1_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world2pg1_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world2pg1_enemyType[esi]
		mov enemyType[esi], al
		mov al, world2pg1_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world2pg1_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesLvl2Pg1
	mov al, world2pg1_numEnemies
	mov numEnemies, al

	mov ecx, world2pg1_numCoins
	mov esi, 0
copyCoinsLvl2Pg1:
		mov al, world2pg1_coinX[esi]
		mov coinX[esi], al
		mov al, world2pg1_coinY[esi]
		mov coinY[esi], al
		mov al, world2pg1_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsLvl2Pg1
	mov al, world2pg1_numCoins
	mov numCoins, al

	mov goldenMushroomActive, 0
	
	cmp slowMotionCollected, 1
	je skipSpawnSlowMoL2P1
	
	mov slowMotionItemActive, 1
	mov slowMotionItemX, 35
	mov slowMotionItemY, 12
	jmp doneSpawnSlowMoL2P1
	
	skipSpawnSlowMoL2P1:
	mov slowMotionItemActive, 0
	
	doneSpawnSlowMoL2P1:

	mov currentPage, 1

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel2Page1 ENDP

LoadLevel2Page2 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world2pg2_numBlocks
	mov esi, 0
copyBlocksLvl2Pg2:
		mov al, world2pg2_blockX[esi]
		mov blockX[esi], al
		mov al, world2pg2_blockY[esi]
		mov blockY[esi], al
		mov al, world2pg2_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksLvl2Pg2
	mov al, world2pg2_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world2pg2_numPlatforms
	mov esi, 0
copyPlatformsLvl2Pg2:
		mov al, world2pg2_platX[esi]
		mov platX[esi], al
		mov al, world2pg2_platY[esi]
		mov platY[esi], al
		mov al, world2pg2_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsLvl2Pg2
	mov al, world2pg2_numPlatforms
	mov numPlatforms, al

	mov ecx, world2pg2_numHills
	mov esi, 0
copyHillsLvl2Pg2:
		mov al, world2pg2_hillX[esi]
		mov hillX[esi], al
		mov al, world2pg2_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsLvl2Pg2
	mov al, world2pg2_numHills
	mov numHills, al

	mov ecx, world2pg2_numClouds
	mov esi, 0
copyCloudsLvl2Pg2:
		mov al, world2pg2_cloudX[esi]
		mov cloudX[esi], al
		mov al, world2pg2_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsLvl2Pg2
	mov al, world2pg2_numClouds
	mov numClouds, al

	mov ecx, world2pg2_numEnemies
	mov esi, 0
copyEnemiesLvl2Pg2:
		mov al, world2pg2_enemyX[esi]
		mov enemyX[esi], al
		mov al, world2pg2_enemyY[esi]
		mov enemyY[esi], al
		mov al, world2pg2_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world2pg2_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world2pg2_enemyType[esi]
		mov enemyType[esi], al
		mov al, world2pg2_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world2pg2_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesLvl2Pg2
	mov al, world2pg2_numEnemies
	mov numEnemies, al

	mov ecx, world2pg2_numCoins
	mov esi, 0
copyCoinsLvl2Pg2:
		mov al, world2pg2_coinX[esi]
		mov coinX[esi], al
		mov al, world2pg2_coinY[esi]
		mov coinY[esi], al
		mov al, world2pg2_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsLvl2Pg2
	mov al, world2pg2_numCoins
	mov numCoins, al

	cmp goldenMushroomCollected, 1
	je skipSpawnMushroomL2

	mov goldenMushroomActive, 1
	mov goldenMushroomX, 40
	mov goldenMushroomY, 13
	jmp doneSpawnMushroomL2

	skipSpawnMushroomL2:
	mov goldenMushroomActive, 0

	doneSpawnMushroomL2:

	mov slowMotionItemActive, 0
	mov currentPage, 2

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel2Page2 ENDP

LoadLevel2Page3 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world2pg3_numBlocks
	cmp ecx, 0
	je skipBlocksLvl2Pg3
	mov esi, 0
copyBlocksLvl2Pg3:
		mov al, world2pg3_blockX[esi]
		mov blockX[esi], al
		mov al, world2pg3_blockY[esi]
		mov blockY[esi], al
		mov al, world2pg3_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksLvl2Pg3
skipBlocksLvl2Pg3:
	mov al, world2pg3_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world2pg3_numPlatforms
	mov esi, 0
copyPlatformsLvl2Pg3:
		mov al, world2pg3_platX[esi]
		mov platX[esi], al
		mov al, world2pg3_platY[esi]
		mov platY[esi], al
		mov al, world2pg3_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsLvl2Pg3
	mov al, world2pg3_numPlatforms
	mov numPlatforms, al

	mov ecx, world2pg3_numHills
	cmp ecx, 0
	je skipHillsLvl2Pg3
	mov esi, 0
copyHillsLvl2Pg3:
		mov al, world2pg3_hillX[esi]
		mov hillX[esi], al
		mov al, world2pg3_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsLvl2Pg3
skipHillsLvl2Pg3:
	mov al, world2pg3_numHills
	mov numHills, al

	mov ecx, world2pg3_numClouds
	cmp ecx, 0
	je skipCloudsLvl2Pg3
	mov esi, 0
copyCloudsLvl2Pg3:
		mov al, world2pg3_cloudX[esi]
		mov cloudX[esi], al
		mov al, world2pg3_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsLvl2Pg3
skipCloudsLvl2Pg3:
	mov al, world2pg3_numClouds
	mov numClouds, al

	mov ecx, world2pg3_numEnemies
	cmp ecx, 0
	je skipEnemiesLvl2Pg3 
	mov esi, 0
copyEnemiesLvl2Pg3:
		mov al, world2pg3_enemyX[esi]
		mov enemyX[esi], al
		mov al, world2pg3_enemyY[esi]
		mov enemyY[esi], al
		mov al, world2pg3_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world2pg3_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world2pg3_enemyType[esi]
		mov enemyType[esi], al
		mov al, world2pg3_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world2pg3_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesLvl2Pg3
skipEnemiesLvl2Pg3:
	mov al, world2pg3_numEnemies
	mov numEnemies, al

	mov ecx, world2pg3_numCoins
	cmp ecx, 0
	je skipCoinsLvl2Pg3 
	mov esi, 0
copyCoinsLvl2Pg3:
		mov al, world2pg3_coinX[esi]
		mov coinX[esi], al
		mov al, world2pg3_coinY[esi]
		mov coinY[esi], al
		mov al, world2pg3_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsLvl2Pg3
skipCoinsLvl2Pg3:
	mov al, world2pg3_numCoins
	mov numCoins, al

	mov goldenMushroomActive, 0

	mov goldenMushroomActive, 0
	mov slowMotionItemActive, 0

	mov currentPage, 3

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel2Page3 ENDP

LoadLevel2Page4 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world2pg4_numBlocks
	cmp ecx, 0
	je skipBlocksLvl2Pg4
	mov esi, 0
copyBlocksLvl2Pg4:
		mov al, world2pg4_blockX[esi]
		mov blockX[esi], al
		mov al, world2pg4_blockY[esi]
		mov blockY[esi], al
		mov al, world2pg4_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksLvl2Pg4
skipBlocksLvl2Pg4:
	mov al, world2pg4_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world2pg4_numPlatforms
	cmp ecx, 0
	je skipPlatformsLvl2Pg4
	mov esi, 0
copyPlatformsLvl2Pg4:
		mov al, world2pg4_platX[esi]
		mov platX[esi], al
		mov al, world2pg4_platY[esi]
		mov platY[esi], al
		mov al, world2pg4_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsLvl2Pg4
skipPlatformsLvl2Pg4:
	mov al, world2pg4_numPlatforms
	mov numPlatforms, al

	mov ecx, world2pg4_numHills
	cmp ecx, 0
	je skipHillsLvl2Pg4
	mov esi, 0
copyHillsLvl2Pg4:
		mov al, world2pg4_hillX[esi]
		mov hillX[esi], al
		mov al, world2pg4_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsLvl2Pg4
skipHillsLvl2Pg4:
	mov al, world2pg4_numHills
	mov numHills, al

	mov ecx, world2pg4_numClouds
	cmp ecx, 0
	je skipCloudsLvl2Pg4
	mov esi, 0
copyCloudsLvl2Pg4:
		mov al, world2pg4_cloudX[esi]
		mov cloudX[esi], al
		mov al, world2pg4_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsLvl2Pg4
skipCloudsLvl2Pg4:
	mov al, world2pg4_numClouds
	mov numClouds, al

	mov ecx, world2pg4_numEnemies
	cmp ecx, 0
	je skipEnemiesLvl2Pg4
	mov esi, 0
copyEnemiesLvl2Pg4:
		mov al, world2pg4_enemyX[esi]
		mov enemyX[esi], al
		mov al, world2pg4_enemyY[esi]
		mov enemyY[esi], al
		mov al, world2pg4_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world2pg4_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world2pg4_enemyType[esi]
		mov enemyType[esi], al
		mov al, world2pg4_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world2pg4_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesLvl2Pg4
skipEnemiesLvl2Pg4:
	mov al, world2pg4_numEnemies
	mov numEnemies, al

	mov ecx, world2pg4_numCoins
	cmp ecx, 0
	je skipCoinsLvl2Pg4
	mov esi, 0
copyCoinsLvl2Pg4:
		mov al, world2pg4_coinX[esi]
		mov coinX[esi], al
		mov al, world2pg4_coinY[esi]
		mov coinY[esi], al
		mov al, world2pg4_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsLvl2Pg4
skipCoinsLvl2Pg4:
	mov al, world2pg4_numCoins
	mov numCoins, al

	mov goldenMushroomActive, 0
	
	cmp slowMotionCollected, 1
	je skipSpawnSlowMoL2P4
	
	mov slowMotionItemActive, 1
	mov slowMotionItemX, 50
	mov slowMotionItemY, 10
	jmp doneSpawnSlowMoL2P4
	
	skipSpawnSlowMoL2P4:
	mov slowMotionItemActive, 0
	
	doneSpawnSlowMoL2P4:
	mov currentPage, 4

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel2Page4 ENDP

LoadLevel2Page5 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world2pg5_numBlocks
	cmp ecx, 0
	je skipBlocksLvl2Pg5
	mov esi, 0
copyBlocksLvl2Pg5:
		mov al, world2pg5_blockX[esi]
		mov blockX[esi], al
		mov al, world2pg5_blockY[esi]
		mov blockY[esi], al
		mov al, world2pg5_blockType[esi]
		mov blockType[esi], al
		inc esi
	loop copyBlocksLvl2Pg5
skipBlocksLvl2Pg5:
	mov al, world2pg5_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world2pg5_numPlatforms
	mov esi, 0
copyPlatformsLvl2Pg5:
		mov al, world2pg5_platX[esi]
		mov platX[esi], al
		mov al, world2pg5_platY[esi]
		mov platY[esi], al
		mov al, world2pg5_platW[esi]
		mov platW[esi], al
		inc esi
	loop copyPlatformsLvl2Pg5
	mov al, world2pg5_numPlatforms
	mov numPlatforms, al

	mov ecx, world2pg5_numHills
	cmp ecx, 0
	je skipHillsLvl2Pg5
	mov esi, 0
copyHillsLvl2Pg5:
		mov al, world2pg5_hillX[esi]
		mov hillX[esi], al
		mov al, world2pg5_hillH[esi]
		mov hillH[esi], al
		inc esi
	loop copyHillsLvl2Pg5
skipHillsLvl2Pg5:
	mov al, world2pg5_numHills
	mov numHills, al

	mov ecx, world2pg5_numClouds
	cmp ecx, 0
	je skipCloudsLvl2Pg5
	mov esi, 0
copyCloudsLvl2Pg5:
		mov al, world2pg5_cloudX[esi]
		mov cloudX[esi], al
		mov al, world2pg5_cloudY[esi]
		mov cloudY[esi], al
		inc esi
	loop copyCloudsLvl2Pg5
skipCloudsLvl2Pg5:
	mov al, world2pg5_numClouds
	mov numClouds, al

	mov ecx, world2pg5_numEnemies
	cmp ecx, 0
	je skipEnemiesLvl2Pg5 
	mov esi, 0
copyEnemiesLvl2Pg5:
		mov al, world2pg5_enemyX[esi]
		mov enemyX[esi], al
		mov al, world2pg5_enemyY[esi]
		mov enemyY[esi], al
		mov al, world2pg5_enemyDir[esi]
		mov enemyDir[esi], al
		mov al, world2pg5_enemyActive[esi]
		mov enemyActive[esi], al
		mov al, world2pg5_enemyType[esi]
		mov enemyType[esi], al
		mov al, world2pg5_enemyPatrolStart[esi]
		mov enemyPatrolStart[esi], al
		mov al, world2pg5_enemyPatrolEnd[esi]
		mov enemyPatrolEnd[esi], al
		inc esi
	loop copyEnemiesLvl2Pg5
skipEnemiesLvl2Pg5:
	mov numEnemies, 0

	mov ecx, world2pg5_numCoins
	cmp ecx, 0
	je skipCoinsLvl2Pg5 
	mov esi, 0
copyCoinsLvl2Pg5:
		mov al, world2pg5_coinX[esi]
		mov coinX[esi], al
		mov al, world2pg5_coinY[esi]
		mov coinY[esi], al
		mov al, world2pg5_coinActive[esi]
		mov coinActive[esi], al
		inc esi
	loop copyCoinsLvl2Pg5
skipCoinsLvl2Pg5:
	mov al, world2pg5_numCoins
	mov numCoins, al

	mov goldenMushroomActive, 0
	mov slowMotionItemActive, 0

	mov currentPage, 5

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel2Page5 ENDP


LoadLevel4Page1 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world4pg1_numBlocks
	mov esi, 0
copyBlocksLvl4Pg1:
	mov al, world4pg1_blockX[esi]
	mov blockX[esi], al
	mov al, world4pg1_blockY[esi]
	mov blockY[esi], al
	mov al, world4pg1_blockType[esi]
	mov blockType[esi], al
	inc esi
	loop copyBlocksLvl4Pg1
	mov al, world4pg1_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world4pg1_numPlatforms
	mov esi, 0
copyPlatformsLvl4Pg1:
	mov al, world4pg1_platX[esi]
	mov platX[esi], al
	mov al, world4pg1_platY[esi]
	mov platY[esi], al
	mov al, world4pg1_platW[esi]
	mov platW[esi], al
	inc esi
	loop copyPlatformsLvl4Pg1
	mov al, world4pg1_numPlatforms
	mov numPlatforms, al

	mov numHills, 0

	mov numClouds, 0

	mov ecx, world4pg1_numEnemies
	mov esi, 0
copyEnemiesLvl4Pg1:
	mov al, world4pg1_enemyX[esi]
	mov enemyX[esi], al
	mov al, world4pg1_enemyY[esi]
	mov enemyY[esi], al
	mov al, world4pg1_enemyDir[esi]
	mov enemyDir[esi], al
	mov al, world4pg1_enemyActive[esi]
	mov enemyActive[esi], al
	mov al, world4pg1_enemyType[esi]
	mov enemyType[esi], al
	mov al, world4pg1_enemyPatrolStart[esi]
	mov enemyPatrolStart[esi], al
	mov al, world4pg1_enemyPatrolEnd[esi]
	mov enemyPatrolEnd[esi], al
	inc esi
	loop copyEnemiesLvl4Pg1
	mov al, world4pg1_numEnemies
	mov numEnemies, al

	mov ecx, world4pg1_numCoins
	mov esi, 0
copyCoinsLvl4Pg1:
	mov al, world4pg1_coinX[esi]
	mov coinX[esi], al
	mov al, world4pg1_coinY[esi]
	mov coinY[esi], al
	mov al, world4pg1_coinActive[esi]
	mov coinActive[esi], al
	inc esi
	loop copyCoinsLvl4Pg1
	mov al, world4pg1_numCoins
	mov numCoins, al

	mov currentPage, 1

	mov goldenMushroomActive, 0
	mov slowMotionItemActive, 0

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel4Page1 ENDP

LoadLevel4Page2 PROC
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, world4pg2_numBlocks
	mov esi, 0
copyBlocksLvl4Pg2:
	mov al, world4pg2_blockX[esi]
	mov blockX[esi], al
	mov al, world4pg2_blockY[esi]
	mov blockY[esi], al
	mov al, world4pg2_blockType[esi]
	mov blockType[esi], al
	inc esi
	loop copyBlocksLvl4Pg2
	mov al, world4pg2_numBlocks
	mov numBlocks, al

	mov numPipes, 0

	mov ecx, world4pg2_numPlatforms
	mov esi, 0
copyPlatformsLvl4Pg2:
	mov al, world4pg2_platX[esi]
	mov platX[esi], al
	mov al, world4pg2_platY[esi]
	mov platY[esi], al
	mov al, world4pg2_platW[esi]
	mov platW[esi], al
	inc esi
	loop copyPlatformsLvl4Pg2
	mov al, world4pg2_numPlatforms
	mov numPlatforms, al

	mov numHills, 0

	mov numClouds, 0

	mov ecx, world4pg2_numEnemies
	mov esi, 0
copyEnemiesLvl4Pg2:
	mov al, world4pg2_enemyX[esi]
	mov enemyX[esi], al
	mov al, world4pg2_enemyY[esi]
	mov enemyY[esi], al
	mov al, world4pg2_enemyDir[esi]
	mov enemyDir[esi], al
	mov al, world4pg2_enemyActive[esi]
	mov enemyActive[esi], al
	mov al, world4pg2_enemyType[esi]
	mov enemyType[esi], al
	mov al, world4pg2_enemyPatrolStart[esi]
	mov enemyPatrolStart[esi], al
	mov al, world4pg2_enemyPatrolEnd[esi]
	mov enemyPatrolEnd[esi], al
	inc esi
	loop copyEnemiesLvl4Pg2
	mov al, world4pg2_numEnemies
	mov numEnemies, al

	mov ecx, world4pg2_numCoins
	mov esi, 0
copyCoinsLvl4Pg2:
	mov al, world4pg2_coinX[esi]
	mov coinX[esi], al
	mov al, world4pg2_coinY[esi]
	mov coinY[esi], al
	mov al, world4pg2_coinActive[esi]
	mov coinActive[esi], al
	inc esi
	loop copyCoinsLvl4Pg2
	mov al, world4pg2_numCoins
	mov numCoins, al

	cmp goldenMushroomCollected, 1
	je skipSpawnMushroomL4

	mov goldenMushroomActive, 1
	mov goldenMushroomX, 50
	mov goldenMushroomY, 16
	jmp doneSpawnMushroomL4

	skipSpawnMushroomL4:
	mov goldenMushroomActive, 0

	doneSpawnMushroomL4:

	mov slowMotionItemActive, 0
	mov currentPage, 2

	pop esi
	pop ecx
	pop ebx
	pop eax
	ret
LoadLevel4Page2 ENDP

LoadLevel4Page3 PROC
    push eax
    push ebx
    push ecx
    push esi

    mov ecx, world4pg3_numPlatforms
    mov esi, 0
copyPlatformsLvl4Pg3:
    mov al, world4pg3_platX[esi]
    mov platX[esi], al
    mov al, world4pg3_platY[esi]
    mov platY[esi], al
    mov al, world4pg3_platW[esi]
    mov platW[esi], al
    inc esi
    loop copyPlatformsLvl4Pg3
    mov al, world4pg3_numPlatforms
    mov numPlatforms, al

    mov numBlocks, 0
    mov numPipes, 0
    mov numHills, 0
    mov numClouds, 0
    mov numCoins, 0

    mov ecx, world4pg3_numEnemies
    mov esi, 0
copyEnemiesLvl4Pg3:
    mov al, world4pg3_enemyX[esi]
    mov enemyX[esi], al
    mov al, world4pg3_enemyY[esi]
    mov enemyY[esi], al
    mov al, world4pg3_enemyDir[esi]
    mov enemyDir[esi], al
    mov al, world4pg3_enemyActive[esi]
    mov enemyActive[esi], al
    mov al, world4pg3_enemyType[esi]
    mov enemyType[esi], al
    mov al, world4pg3_enemyPatrolStart[esi]
    mov enemyPatrolStart[esi], al
    mov al, world4pg3_enemyPatrolEnd[esi]
    mov enemyPatrolEnd[esi], al
    inc esi
    loop copyEnemiesLvl4Pg3
    mov al, world4pg3_numEnemies
    mov numEnemies, al

    mov bowserHP, 5
    mov bowserJumpTimer, 0
    mov bowserFireTimer, 0
    mov bowserFireballX, 0
    mov axeActive, 1 
	mov goldenMushroomActive, 0
	mov slowMotionItemActive, 0

    mov currentPage, 3

    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
LoadLevel4Page3 ENDP

DrawBackground PROC
    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, 0
    clearEntireConsole:
        cmp dh, SCREEN_HEIGHT
        jge consoleCleared
        mov dl, 0
        call Gotoxy
        mov ecx, SCREEN_WIDTH
        clearConsoleRow:
            mov al, ' '
            call WriteChar
        loop clearConsoleRow
        inc dh
        jmp clearEntireConsole
    consoleCleared:

    mov al, level
    cmp al, 4
    je useCastleWallColorLeft
    mov eax, white + (brown * 16) 
    jmp wallColorSetLeft
useCastleWallColorLeft:
    mov eax, CASTLE_WALL_COLOR 
wallColorSetLeft:
    call SetTextColor

    mov dl, GAME_LEFT_WALL
    mov dh, GAME_TOP
    drawLeftWall:
        cmp dh, GROUND_END
        jg leftWallDone
        call Gotoxy
        mov al, '='
        call WriteChar
        inc dh
        jmp drawLeftWall
    leftWallDone:

    mov al, level
    cmp al, 4
    je useCastleWallColorRight
    mov eax, white + (brown * 16) 
    jmp wallColorSetRight
useCastleWallColorRight:
    mov eax, CASTLE_WALL_COLOR 
wallColorSetRight:
    call SetTextColor
    mov dl, GAME_RIGHT_WALL + 1
    mov dh, GAME_TOP
    drawRightWall:
        cmp dh, GROUND_END
        jg rightWallDone
        call Gotoxy
        mov al, '='
        call WriteChar
        inc dh
        jmp drawRightWall
    rightWallDone:

    mov al, level
    cmp al, 4
    je useCastleCeilingColor
    mov eax, white + (brown * 16) 
    jmp ceilingColorSet
useCastleCeilingColor:
    mov eax, CASTLE_WALL_COLOR 
ceilingColorSet:
    call SetTextColor
    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP
    call Gotoxy
    mov ecx, GAME_RIGHT_WALL - GAME_LEFT_WALL
    drawCeiling:
        mov al, '='
        call WriteChar
    loop drawCeiling

    mov al, level
    cmp al, 4
    je useCastleBackground
    cmp al, 2
    jne useSkyColorBG
    mov al, currentPage
    cmp al, 3
    je useRedBackground
    cmp al, 5
    je useRedBackground
    jmp useSkyColorBG
    useRedBackground:
    mov eax, UNDERGROUND_COLOR
    jmp backgroundColorSetBG
useCastleBackground:
    mov eax, CASTLE_SKY_COLOR
    jmp backgroundColorSetBG
useSkyColorBG:
    mov eax, SKY_COLOR
backgroundColorSetBG:
    call SetTextColor

    mov dh, GAME_TOP
    inc dh          
    drawSkyLoop:
        cmp dh, GAME_BOTTOM
        jg drawGround

        mov dl, GAME_LEFT_WALL + 1
        call Gotoxy

        mov ecx, GAME_RIGHT_WALL - GAME_LEFT_WALL
        printSkyLine:
            mov al, ' '
            call WriteChar
        loop printSkyLine

        inc dh
        jmp drawSkyLoop

    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, GAME_TOP
    clearRightArea:
        cmp dh, GAME_BOTTOM
        jg rightAreaCleared
        mov dl, GAME_RIGHT_WALL + 2
        call Gotoxy
        mov ecx, SCREEN_WIDTH - (GAME_RIGHT_WALL + 2)
        clearRightCols:
            mov al, ' '
            call WriteChar
        loop clearRightCols
        inc dh
        jmp clearRightArea
    rightAreaCleared:

    drawGround:

    mov al, level
    cmp al, 4
    je finishBackground 

    mov eax, GROUND_COLOR
    call SetTextColor

    mov dh, GROUND_START
    drawGroundLoop:
        cmp dh, GROUND_END
        jg finishBackground

        mov dl, 0
        call Gotoxy

        mov ecx, SCREEN_WIDTH
        printGroundLine:
            mov al, '=' 
            call WriteChar
        loop printGroundLine

        inc dh
        jmp drawGroundLoop

    finishBackground:
    mov eax, black + (black * 16)
    call SetTextColor
    mov dh, 0
    mov dl, 0
    call Gotoxy
    mov ecx, SCREEN_WIDTH
    clearTopRowBG:
        mov al, ' '
        call WriteChar
    loop clearTopRowBG

    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP + 1
    call Gotoxy
    ret
DrawBackground ENDP

ClearGameAreaOnly PROC
    push eax
    push ecx
    push edx

    mov eax, black + (black * 16)
    call SetTextColor

    mov dh, GAME_TOP

    clearGameRows:
        cmp dh, GAME_BOTTOM
        jg gameAreaCleared
        mov dl, GAME_LEFT_WALL + 1
        call Gotoxy
        mov ecx, GAME_RIGHT_WALL - GAME_LEFT_WALL
        clearGameCols:
            mov al, ' '
            call WriteChar
        loop clearGameCols
        inc dh
        jmp clearGameRows
    gameAreaCleared:

    mov dh, GAME_TOP

    clearRightArea:
        cmp dh, GAME_BOTTOM
        jg rightAreaCleared
        mov dl, GAME_RIGHT_WALL + 2
        call Gotoxy
        mov ecx, SCREEN_WIDTH - (GAME_RIGHT_WALL + 2)

        clearRightCols:
            mov al, ' '
            call WriteChar
        loop clearRightCols
        inc dh
        jmp clearRightArea

    rightAreaCleared:

    pop edx
    pop ecx
    pop eax
    ret
ClearGameAreaOnly ENDP

DrawWallsAndGroundOnly PROC
    push eax
    push edx
    push ecx

    mov al, level
    cmp al, 4
    je useCastleWallColorOnly
    mov eax, white + (brown * 16) 
    jmp wallColorSetOnly
useCastleWallColorOnly:
    mov eax, CASTLE_WALL_COLOR  
wallColorSetOnly:
    call SetTextColor

    mov dl, GAME_LEFT_WALL
    mov dh, GAME_TOP
    drawLeftWallOnly:
        cmp dh, GROUND_END
        jg leftWallDoneOnly
        call Gotoxy
        mov al, '='
        call WriteChar
        inc dh
        jmp drawLeftWallOnly
    leftWallDoneOnly:

    mov dl, GAME_RIGHT_WALL + 1
    mov dh, GAME_TOP
    drawRightWallOnly:
        cmp dh, GROUND_END
        jg rightWallDoneOnly
        call Gotoxy
        mov al, '='
        call WriteChar
        inc dh
        jmp drawRightWallOnly
    rightWallDoneOnly:

    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP
    call Gotoxy
    mov ecx, GAME_RIGHT_WALL - GAME_LEFT_WALL
    drawCeilingOnly:
        mov al, '='
        call WriteChar
    loop drawCeilingOnly

    mov al, level
    cmp al, 4
    je useCastleBGOnly          
    cmp al, 2
    jne useSkyColorOnly         
    mov al, currentPage
    cmp al, 3
    je useRedBGOnly
    cmp al, 5
    je useRedBGOnly
    jmp useSkyColorOnly

useCastleBGOnly:
    mov eax, CASTLE_SKY_COLOR
    jmp bgColorSetOnly

useRedBGOnly:
    mov eax, UNDERGROUND_COLOR
    jmp bgColorSetOnly

useSkyColorOnly:
    mov eax, SKY_COLOR

bgColorSetOnly:
    call SetTextColor

    mov dh, GAME_TOP
    inc dh          
    drawSkyLoopOnly:
        cmp dh, GAME_BOTTOM
        jg checkGroundLevel4 

        mov dl, GAME_LEFT_WALL + 1
        call Gotoxy
        mov ecx, GAME_RIGHT_WALL - GAME_LEFT_WALL
        
		printSkyLineOnly:
            mov al, ' '
            call WriteChar
        loop printSkyLineOnly

        inc dh
        jmp drawSkyLoopOnly

    checkGroundLevel4:
    mov al, level
    cmp al, 4
    je finishWallsGround 

    drawGroundOnly:
		mov eax, GROUND_COLOR
		call SetTextColor

	    mov dh, GROUND_START
    
	drawGroundLoopOnly:
        cmp dh, GROUND_END
        jg finishWallsGround

        mov dl, 0
        call Gotoxy
        mov ecx, SCREEN_WIDTH
        
		printGroundLineOnly:
            mov al, '='
            call WriteChar
        
		loop printGroundLineOnly

        inc dh
        jmp drawGroundLoopOnly

    finishWallsGround:
    
		mov eax, black + (black * 16)
		call SetTextColor
		mov dh, GAME_TOP
   
   clearRightAreaOnly:
        cmp dh, GAME_BOTTOM
        jg rightAreaClearedOnly
        mov dl, GAME_RIGHT_WALL + 2
        call Gotoxy
        mov ecx, SCREEN_WIDTH - (GAME_RIGHT_WALL + 2)
   
   clearRightColsOnly:
		mov al, ' '
        call WriteChar
        
		loop clearRightColsOnly
        inc dh
        jmp clearRightAreaOnly
   
   rightAreaClearedOnly:

    mov dh, 0
    mov dl, 0
    call Gotoxy
    mov ecx, SCREEN_WIDTH
   
   clearTopRowOnly:
        mov al, ' '
        call WriteChar
   
   loop clearTopRowOnly

    mov eax, black + (black * 16)
    call SetTextColor

    pop ecx
    pop edx
    pop eax
    ret
DrawWallsAndGroundOnly ENDP

DrawWorld1_1Layout PROC
	call DrawBlocks

	call DrawPipes

	call DrawHills

	call DrawClouds

	ret
DrawWorld1_1Layout ENDP

DrawWorld1_2Layout PROC
	call DrawBlocks

	call DrawPipes

	mov al, currentPage
	cmp al, 3
	je skipHillsClouds
	cmp al, 5
	je skipHillsClouds

	call DrawHills

	call DrawClouds

	skipHillsClouds:
	ret
DrawWorld1_2Layout ENDP

DrawBlocks PROC
    movzx ecx, numBlocks
    cmp ecx, 0
    je blocksDone
    cmp ecx, maxBlocks
    jg blocksDone

    mov esi, 0

    blockLoop:
        mov dl, blockX[esi]
        mov dh, blockY[esi]
        mov bl, blockType[esi]

        call Gotoxy

        cmp bl, 0
        je drawBrickBlock

        mov eax, QUESTION_COLOR
        call SetTextColor
        mov al, '?'
        call WriteChar
        jmp blockDone

        drawBrickBlock:
        mov al, level
        cmp al, 4
        je useCastleBrickColor

        mov eax, BRICK_COLOR
        jmp setBrickColor

        useCastleBrickColor:
        mov eax, CASTLE_WALL_COLOR

        setBrickColor:
        call SetTextColor
        mov al, '#'
        call WriteChar

        blockDone:
        inc esi
    loop blockLoop

    blocksDone:
    push edx
    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP + 1
    call Gotoxy
    pop edx
    ret
DrawBlocks ENDP

DrawPipes PROC
    movzx ecx, numPipes
    cmp ecx, 0
    je pipesDone

    mov eax, PIPE_COLOR
    call SetTextColor

    mov esi, 0

    pipeLoop:
        push ecx  

        movzx ecx, pipeH[esi]  
        mov dl, pipeX[esi]     
        mov dh, pipeY[esi]     

        drawStem:
            push ecx

            call Gotoxy
            mov al, '|'
            call WriteChar

            add dl, 3          
            call Gotoxy
            mov al, '|'
            call WriteChar

            sub dl, 3
            dec dh             
            pop ecx
            loop drawStem

        call Gotoxy
        mov al, '['
        call WriteChar
        inc dl
        call Gotoxy
        mov al, '_'
        call WriteChar
        inc dl
        call Gotoxy
        mov al, '_'
        call WriteChar
        inc dl
        call Gotoxy
        mov al, ']'
        call WriteChar

        pop ecx  
        inc esi
        loop pipeLoop

    pipesDone:
    push edx
    mov dl, GAME_LEFT_WALL + 1
    mov dh, GAME_TOP + 1
    call Gotoxy
    pop edx
    ret
DrawPipes ENDP

DrawHills PROC
	movzx ecx, numHills
	cmp ecx, 0
	je hillsDone 
	cmp ecx, 3
	jg hillsDone 

	mov eax, GROUND_COLOR
	call SetTextColor

	mov esi, 0

	hillLoop:
		mov dl, hillX[esi]
		mov bl, hillH[esi]

		mov dh, GROUND_START
		dec dh 

		mov bh, 0
	
	drawHillHeight:
		cmp bh, bl
		jge hillDone

		call Gotoxy
		mov al, '/'
		call WriteChar
		mov al, '\'
		call WriteChar

		dec dh
		inc bh
		jmp drawHillHeight

		hillDone:
			inc esi
	loop hillLoop

	hillsDone:
	push edx
	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy
	pop edx
	ret
DrawHills ENDP

DrawHillAtIndex PROC
	push eax
	push ebx
	push edx

	mov al, level
	cmp al, 2
	jne useNormalHillColorIndex
	mov al, currentPage
	cmp al, 3
	je useRedHillColorIndex
	cmp al, 5
	je useRedHillColorIndex
	jmp useNormalHillColorIndex
	
	useRedHillColorIndex:
		mov eax, GROUND_COLOR
		and eax, 0Fh 
		or eax, (red * 16) 
		jmp hillColorSetIndex
	
	useNormalHillColorIndex:
		mov eax, GROUND_COLOR
		hillColorSetIndex:
		call SetTextColor

	mov bl, hillH[esi] 
	cmp bl, 0
	jle hillIndexDone

	mov bh, 0
hillIndexLoop:
	cmp bh, bl
	jge hillIndexDone

	mov dh, GROUND_START
	dec dh
	sub dh, bh

	mov dl, hillX[esi]
	call Gotoxy
	mov al, '/'
	call WriteChar

	mov dl, hillX[esi]
	inc dl
	mov dh, GROUND_START
	dec dh
	sub dh, bh
	call Gotoxy
	mov al, '\'
	call WriteChar

	inc bh
	jmp hillIndexLoop

hillIndexDone:
	pop edx
	pop ebx
	pop eax
	ret
DrawHillAtIndex ENDP

DrawClouds PROC
	movzx ecx, numClouds
	cmp ecx, 0
	je cloudsDone 
	cmp ecx, 4
	jg cloudsDone 

	mov al, level
	cmp al, 2
	jne useNormalCloudColor
	mov al, currentPage
	cmp al, 3
	jne useNormalCloudColor
	mov eax, white + (red * 16)
	jmp cloudColorSet
useNormalCloudColor:
	mov eax, CLOUD_COLOR
cloudColorSet:
	call SetTextColor

	mov esi, 0

	cloudLoop:
		mov dl, cloudX[esi]
		mov dh, cloudY[esi]

		call Gotoxy

		mov al, '('
		call WriteChar
		inc dl
		call Gotoxy
		mov al, ')'
		call WriteChar

		dec dl
		dec dh
		call Gotoxy
		mov al, '('
		call WriteChar
		inc dl
		call Gotoxy
		mov al, '_'
		call WriteChar
		inc dl
		call Gotoxy
		mov al, ')'
		call WriteChar

		inc esi
	loop cloudLoop

	cloudsDone:
	push edx
	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy
	pop edx
	ret
DrawClouds ENDP

RedrawStaticElements PROC
	push edx
	call DrawBlocks
	call DrawPipes
	call DrawAllCoins 
	call DrawGoldenMushroom
	call DrawSlowMotionItem
	call DrawEnemies
	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy
	pop edx
	ret
RedrawStaticElements ENDP

CheckBlockCollisionLeft PROC
    push ebx
    push ecx
    push edx
    push esi

    mov al, 0 

    movzx ecx, numBlocks
    cmp ecx, 0
    je collisionDoneLeft 
    cmp ecx, maxBlocks
    jg collisionDoneLeft 

    mov esi, 0
    checkBlocksLeft:
        mov bl, blockX[esi]
        mov bh, blockY[esi]

        mov dl, xPos
        dec dl      
        cmp dl, bl
        jne nextBlockLeft

        mov dl, yPos
        cmp dl, bh
        je collisionFoundLeft
        dec dl      
        cmp dl, bh
        je collisionFoundLeft

        nextBlockLeft:
        inc esi
    loop checkBlocksLeft

    movzx ecx, numPipes
    cmp ecx, 0
    je checkPipesDoneLeft
    mov esi, 0

    checkPipesLeft:

        mov bl, pipeX[esi]
        add bl, 3       

        mov dl, xPos
        dec dl          

        cmp dl, bl
        jne nextPipeLeft

        mov bh, pipeY[esi]
        sub bh, pipeH[esi] 

        mov dl, yPos    
        cmp dl, bh
        jle nextPipeLeft 

        jmp collisionFoundLeft

        nextPipeLeft:
        inc esi
        cmp esi, ecx
        jl checkPipesLeft

    checkPipesDoneLeft:

    jmp collisionDoneLeft

    collisionFoundLeft:
    mov al, 1

    collisionDoneLeft:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckBlockCollisionLeft ENDP

CheckBlockCollisionRight PROC
	push ebx
	push ecx
	push edx
	push esi

	mov al, 0 

	movzx ecx, numBlocks
	cmp ecx, 0
	je collisionDoneRight 
	cmp ecx, maxBlocks
	jg collisionDoneRight 

	mov esi, 0
	checkBlocksRight:
		mov bl, blockX[esi]
		mov bh, blockY[esi]

		mov dl, xPos
		inc dl 
		cmp dl, bl
		jne nextBlockRight

		mov dl, yPos
		cmp dl, bh
		je collisionFoundRight
		dec dl
		cmp dl, bh
		je collisionFoundRight

		nextBlockRight:
		inc esi
	loop checkBlocksRight

	movzx ecx, numPipes
	cmp ecx, 0
	je checkPipesDoneRight
	mov esi, 0

	checkPipesRight:

		mov bl, pipeX[esi]

		mov dl, xPos
		inc dl          

		cmp dl, bl
		jne nextPipeRight

		mov bh, pipeY[esi]
		sub bh, pipeH[esi] 

		mov dl, yPos
		cmp dl, bh
		jle nextPipeRight 

		jmp collisionFoundRight

		nextPipeRight:
		inc esi
		cmp esi, ecx
		jl checkPipesRight

	checkPipesDoneRight:

	jmp collisionDoneRight

	collisionFoundRight:
	mov al, 1

	collisionDoneRight:
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
CheckBlockCollisionRight ENDP

CheckAllStaticCollisionVertical PROC
	push ebx
	push ecx
	push edx
	push esi

	mov al, 0 

	movzx ecx, numBlocks
	cmp ecx, 0          
	je collisionDoneAllVert
	mov esi, 0
	checkAllBlocksVert:
		mov bl, blockX[esi]
		mov bh, blockY[esi]

		mov dl, xPos
		cmp dl, bl
		jne nextAllBlockVert

		mov dl, yPos
		cmp dl, bh
		je collisionFoundAllVert
		dec dl
		cmp dl, bh
		je collisionFoundAllVert

		nextAllBlockVert:
		inc esi
	loop checkAllBlocksVert

	jmp collisionDoneAllVert

	collisionFoundAllVert:
	mov al, 1

	collisionDoneAllVert:
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
CheckAllStaticCollisionVertical ENDP

CheckLandOnBlocks PROC
    push ebx
    push ecx
    push edx
    push esi

    mov al, 0 

    cmp isJumping, 1
    je notLandingOnBlock

    movzx ecx, numBlocks
    cmp ecx, 0          
    je notLandingOnBlock

    mov esi, 0
    checkLandBlocks:
		mov bl, blockX[esi]
		mov bh, blockY[esi]

		mov dl, xPos
		cmp dl, bl
		jne nextLandBlock

		mov dl, yPos
		cmp dl, bh
		jne nextLandBlock

		mov al, 1
		jmp landingDoneBlock

		nextLandBlock:
		inc esi
	loop checkLandBlocks

	movzx ecx, numPipes
	cmp ecx, 0
	je checkPipesLandDone
	mov esi, 0

	checkLandPipes:

		mov bl, pipeX[esi] 
		mov bh, bl
		add bh, 3          

		mov dl, xPos
		cmp dl, bl
		jl nextPipeLand    
		cmp dl, bh
		jg nextPipeLand    

		mov bl, pipeY[esi]
		sub bl, pipeH[esi] 

		mov dl, yPos
		cmp dl, bl
		jne nextPipeLand

		mov al, 1
		jmp landingDoneBlock

		nextPipeLand:
		inc esi
		cmp esi, ecx
		jl checkLandPipes

	checkPipesLandDone:

	notLandingOnBlock:
	landingDoneBlock:
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
CheckLandOnBlocks ENDP

CheckStandingOnPlatformOrBlock PROC
	push ebx
	push ecx
	push edx
	push esi

	mov al, 0 

	movzx ecx, numPlatforms
	mov esi, 0
checkPlatformStanding:
	cmp ecx, 0
	je checkBlockStanding
	mov bl, platY[esi]
	mov bh, platX[esi]

	mov dl, yPos
	cmp dl, bl
	jne nextPlatformStanding

	mov dl, xPos
	cmp dl, bh
	jl nextPlatformStanding
	mov bl, platW[esi]
	add bh, bl
	cmp dl, bh
	jge nextPlatformStanding

	mov al, 1
	jmp standingDone

nextPlatformStanding:
	inc esi
	dec ecx
	jmp checkPlatformStanding

checkBlockStanding:
	movzx ecx, numBlocks
	mov esi, 0
checkBlockStand:
	cmp ecx, 0
	je standingDone
	mov bl, blockY[esi]
	mov bh, blockX[esi]

	mov dl, yPos
	dec bl 
	cmp dl, bl
	jne nextBlockStand

	mov dl, xPos
	cmp dl, bh
	jne nextBlockStand

	mov al, 1
	jmp standingDone

nextBlockStand:
	inc esi
	dec ecx
	jmp checkBlockStand

standingDone:
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
CheckStandingOnPlatformOrBlock ENDP

CheckHitBlockFromBelow PROC
	push ebx
	push ecx
	push edx
	push esi

	mov al, 0 

	cmp isJumping, 1
	jne notHittingFromBelow

	movzx ecx, numBlocks
	mov esi, 0

	checkHitBlocksBelow:
		mov bl, blockX[esi]
		mov bh, blockY[esi]

		mov dl, xPos
		cmp dl, bl
		jne nextHitBlockBelow

		mov dl, yPos
		dec dl
		cmp dl, bh
		jne nextHitBlockBelow

		jmp hittingFromBelow

		nextHitBlockBelow:
		inc esi
	loop checkHitBlocksBelow

	notHittingFromBelow:
	hittingDoneBelow:
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret

	hittingFromBelow:
	mov al, 1
	jmp hittingDoneBelow
CheckHitBlockFromBelow ENDP


DrawEnemies PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi

	movzx ecx, numEnemies
	cmp ecx, 0
	je enemiesDone
	cmp ecx, maxEnemies
	jg enemiesDone

	mov al, level
	cmp al, 4
	je useCastleEnemyColor 

	cmp al, 2
	jne useNormalEnemyColor
	mov al, currentPage
	cmp al, 3
	je useRedEnemyColor
	cmp al, 5
	je useRedEnemyColor
	jmp useNormalEnemyColor

useCastleEnemyColor:
	mov eax, red + (black * 16)
	jmp enemyColorSet

useRedEnemyColor:
	mov eax, white + (red * 16)
	jmp enemyColorSet

useNormalEnemyColor:
	mov eax, ENEMY_COLOR

enemyColorSet:
	call SetTextColor

	mov esi, 0

	drawEnemyLoop:
		mov al, enemyActive[esi]
		cmp al, 0
		je skipEnemyDraw

		mov dl, enemyX[esi]
		mov dh, enemyY[esi]
		push edx  
		call Gotoxy

		mov al, enemyType[esi]
		cmp al, 1
		je drawKoopa
		cmp al, 3
		je drawBowser

		mov al, 'G'
		call WriteChar
		pop edx  
		jmp skipEnemyDraw

		drawBowser:
		mov eax, BOWSER_COLOR
		call SetTextColor
		mov al, 'B'
		call WriteChar
		mov al, level
		cmp al, 4
		je restoreCastleColor
		jmp restoreNormalColor
		restoreCastleColor:
		mov eax, red + (black * 16)
		jmp setRestoredColor
		restoreNormalColor:
		mov eax, ENEMY_COLOR
		setRestoredColor:
		call SetTextColor
		pop edx
		jmp skipEnemyDraw

		drawKoopa:
		mov al, enemyActive[esi]
		cmp al, 2 
		je drawShell
		cmp al, 3 
		je drawShell

		mov al, level
		cmp al, 2
		jne useNormalKoopaColor
		mov al, currentPage
		cmp al, 3
		je useRedKoopaColor
		cmp al, 5
		je useRedKoopaColor
		jmp useNormalKoopaColor

		useRedKoopaColor:

		mov eax, black + (red * 16)
		jmp koopaColorSet

		useNormalKoopaColor:
		mov eax, KOOPA_COLOR

		koopaColorSet:
		call SetTextColor
		mov al, 'K'
		call WriteChar
		pop edx  
		jmp skipEnemyDraw

		drawShell:
		mov al, level
		cmp al, 2
		jne useNormalShellColor
		mov al, currentPage
		cmp al, 3
		je useRedShellColor
		cmp al, 5
		je useRedShellColor
		jmp useNormalShellColor
		useRedShellColor:
		mov eax, black + (red * 16)
		jmp shellColorSet
		useNormalShellColor:
		mov eax, SHELL_COLOR
		shellColorSet:
		call SetTextColor
		mov al, 'S'
		call WriteChar
		pop edx  

		skipEnemyDraw:
		inc esi
		dec ecx
		jnz drawEnemyLoop

	enemiesDone:

	mov dl, GAME_LEFT_WALL + 1
	mov dh, GAME_TOP + 1
	call Gotoxy

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
DrawEnemies ENDP

RedrawHillsAtPosition PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi

	mov bl, dl  
	mov bh, dh  

	movzx ecx, numHills
	cmp ecx, 0
	je redrawHillsDone
	cmp ecx, 3
	jg redrawHillsDone

	mov al, level
	cmp al, 2
	jne useNormalHillColorRedraw
	mov al, currentPage
	cmp al, 3
	je useRedHillColorRedraw
	cmp al, 5
	je useRedHillColorRedraw
	jmp useNormalHillColorRedraw
	useRedHillColorRedraw:
	mov eax, GROUND_COLOR
	and eax, 0Fh 
	or eax, (red * 16) 
	jmp hillColorSetRedraw
	useNormalHillColorRedraw:
	mov eax, GROUND_COLOR
	hillColorSetRedraw:
	call SetTextColor

	mov esi, 0

	redrawHillLoop:
		mov dl, hillX[esi]

		cmp bl, dl
		je checkHillY
		inc dl
		cmp bl, dl
		jne nextHillRedraw

		checkHillY:

		mov dh, GROUND_START
		dec dh  

		mov al, bh  
		cmp al, dh
		jg nextHillRedraw  

		mov cl, hillH[esi]  
		mov dh, GROUND_START
		sub dh, cl  

		cmp al, dh
		jl nextHillRedraw  

		call DrawHillAtIndex
		jmp redrawHillsDone

		nextHillRedraw:
		inc esi
		dec ecx
		jnz redrawHillLoop

	redrawHillsDone:
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
RedrawHillsAtPosition ENDP

RedrawCloudsAtPosition PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi

	mov bl, dl  
	mov bh, dh  

	movzx ecx, numClouds
	cmp ecx, 0
	je redrawCloudsDone
	cmp ecx, 4
	jg redrawCloudsDone

	mov al, level
	cmp al, 2
	jne useNormalCloudColorRedraw
	mov al, currentPage
	cmp al, 3
	je useRedCloudColorRedraw
	cmp al, 5
	je useRedCloudColorRedraw
	jmp useNormalCloudColorRedraw
	useRedCloudColorRedraw:
	mov eax, white + (red * 16)
	jmp cloudColorSetRedraw

useNormalCloudColorRedraw:
	mov eax, CLOUD_COLOR

cloudColorSetRedraw:
	call SetTextColor

	mov esi, 0

	redrawCloudLoop:
		mov dl, cloudX[esi]
		mov dh, cloudY[esi]


		cmp bl, dl
		jne checkCloudX1
		cmp bh, dh
		jne checkCloudTop
		call Gotoxy
		mov al, '('
		call WriteChar
		jmp redrawCloudsDone

		checkCloudX1:
		inc dl
		cmp bl, dl
		jne checkCloudTop
		cmp bh, dh
		jne checkCloudTop
		call Gotoxy
		mov al, ')'
		call WriteChar
		jmp redrawCloudsDone

		checkCloudTop:
		mov dl, cloudX[esi]  
		mov dh, cloudY[esi]  
		dec dh  

		cmp bl, dl
		jne checkCloudTopX1
		cmp bh, dh
		jne checkCloudTopX2
		call Gotoxy
		mov al, '('
		call WriteChar
		jmp redrawCloudsDone

		checkCloudTopX1:
		inc dl
		cmp bl, dl
		jne checkCloudTopX2
		cmp bh, dh
		jne checkCloudTopX2
		call Gotoxy
		mov al, '_'
		call WriteChar
		jmp redrawCloudsDone

		checkCloudTopX2:
		inc dl
		cmp bl, dl
		jne nextCloudRedraw
		cmp bh, dh
		jne nextCloudRedraw
		call Gotoxy
		mov al, ')'
		call WriteChar
		jmp redrawCloudsDone

		nextCloudRedraw:
		inc esi
		dec ecx
		jnz redrawCloudLoop

	redrawCloudsDone:
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
RedrawCloudsAtPosition ENDP

; ============================================
; Draws the flagpole at the end of levels
; Pole with flag at top and base block
; ============================================
DrawFlagpole PROC
	push eax
	push edx
	push ecx
	
	mov al, level
	cmp al, 2
	je checkL2Pole
	mov al, currentPage
	cmp al, maxPages
	jne poleDone
	jmp drawPoleNow
	
	checkL2Pole:
	mov al, currentPage
	cmp al, 4
	jne poleDone
	
	drawPoleNow:
	mov eax, white + (green * 16)
	call SetTextColor
	
	mov dl, flagpoleX
	mov dh, flagpoleY
	mov ecx, 12
	
	drawPoleLoop:
		call Gotoxy
		mov al, '|'
		call WriteChar
		dec dh
		loop drawPoleLoop
		
	mov eax, red + (black * 16)
	call SetTextColor
	
	mov dl, flagpoleX
	call Gotoxy
	mov al, '>'
	call WriteChar
	
	mov dl, flagpoleX
	inc dh
	call Gotoxy
	mov al, '>'
	call WriteChar
	
	mov eax, white + (brown * 16)
	call SetTextColor
	mov dl, flagpoleX
	mov dh, flagpoleY
	call Gotoxy
	mov al, '#'
	call WriteChar
	
	poleDone:
	pop ecx
	pop edx
	pop eax
	ret
DrawFlagpole ENDP

UpdateEnemy PROC
	push eax
	push ebx
	push ecx
	push edx

	mov al, level
	cmp al, 4
	je useCastleEnemyErase

	cmp al, 2
	jne useSkyColorEnemyErase
	mov al, currentPage
	cmp al, 3
	je useRedEnemyEraseColor
	cmp al, 5
	je useRedEnemyEraseColor
	jmp useSkyColorEnemyErase

useCastleEnemyErase:
	mov eax, CASTLE_SKY_COLOR 
	jmp enemyEraseColorSet

useRedEnemyEraseColor:
	mov eax, black + (red * 16)
	jmp enemyEraseColorSet

useSkyColorEnemyErase:
	mov eax, SKY_COLOR

enemyEraseColorSet:
	call SetTextColor

	mov dl, enemyX[esi]
	mov dh, enemyY[esi]
	push edx
	call Gotoxy
	mov al, ' ' 
	call WriteChar

	pop edx
	call RedrawHillsAtPosition 
	call RedrawCloudsAtPosition

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
UpdateEnemy ENDP

UpdateEnemies PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    movzx ecx, numEnemies
    cmp ecx, 0
    je enemiesUpdateDone
    mov esi, 0

    updateEnemyLoop:
        mov al, enemyActive[esi]
        cmp al, 0
        je checkDeathAnimation

        cmp al, 2
        je enemyMoveDone 

        mov al, enemyType[esi]
        cmp al, 3
        je updateBowser

        call UpdateEnemy 

        mov al, enemyActive[esi]
        cmp al, 3
        je moveKickedShell

        mov al, enemyDir[esi]
        cmp al, 0
        je moveEnemyLeft

        mov al, enemyX[esi]
        inc al
        mov enemyX[esi], al
        mov bl, enemyPatrolEnd[esi]
        cmp al, bl
        jle enemyMoveDone
        mov enemyX[esi], bl 
        mov enemyDir[esi], 0 
        jmp enemyMoveDone

        moveEnemyLeft:
        mov al, enemyX[esi]
        dec al
        mov enemyX[esi], al
        mov bl, enemyPatrolStart[esi]
        cmp al, bl
        jge enemyMoveDone
        mov enemyX[esi], bl 
        mov enemyDir[esi], 1 
        jmp enemyMoveDone

        moveKickedShell:
        mov al, enemyDir[esi]
        cmp al, 0
        je shellLeft
        inc enemyX[esi]
        jmp checkShellBounds
        shellLeft:
        dec enemyX[esi]
        checkShellBounds:
        mov al, enemyX[esi]
        cmp al, GAME_RIGHT_WALL
        jge killShell
        cmp al, GAME_LEFT_WALL
        jle killShell
        jmp enemyMoveDone
        killShell:
        mov enemyActive[esi], 0
        call UpdateEnemy

        push eax
        mov al, level
        cmp al, 2
        je storeWallDeathL2

        mov al, currentPage
        cmp al, 1
        je killWallPg1W1
        cmp al, 2
        je killWallPg2W1
        cmp al, 3
        je killWallPg3W1
        jmp doneWallDeath

        killWallPg1W1:
        mov world1pg1_enemyActive[esi], 0
        jmp doneWallDeath
        killWallPg2W1:
        mov world1pg2_enemyActive[esi], 0
        jmp doneWallDeath
        killWallPg3W1:
        mov world1pg3_enemyActive[esi], 0
        jmp doneWallDeath

        storeWallDeathL2:
        mov al, currentPage
        cmp al, 1
        je killWallL2Pg1
        cmp al, 2
        je killWallL2Pg2
        cmp al, 3
        je killWallL2Pg3
        cmp al, 4
        je killWallL2Pg4
        cmp al, 5
        je killWallL2Pg5
        jmp doneWallDeath

        killWallL2Pg1:
        mov world2pg1_enemyActive[esi], 0
        jmp doneWallDeath
        killWallL2Pg2:
        mov world2pg2_enemyActive[esi], 0
        jmp doneWallDeath
        killWallL2Pg3:
        mov world2pg3_enemyActive[esi], 0
        jmp doneWallDeath
        killWallL2Pg4:
        mov world2pg4_enemyActive[esi], 0
        jmp doneWallDeath
        killWallL2Pg5:
        mov world2pg5_enemyActive[esi], 0

        doneWallDeath:
        pop eax
        jmp nextEnemy

        updateBowser:
        mov al, level
        cmp al, 4
        jne nextEnemy
        mov al, currentPage
        cmp al, 3
        jne nextEnemy

        mov al, enemyX[esi]
        cmp al, GAME_LEFT_WALL + 1
        jl bowserInvalidCoords
        cmp al, GAME_RIGHT_WALL
        jg bowserInvalidCoords
        mov al, enemyY[esi]
        cmp al, GAME_TOP
        jl bowserInvalidCoords
        cmp al, GAME_BOTTOM
        jg bowserInvalidCoords

        call UpdateEnemy 
        jmp bowserCoordsValid

        bowserInvalidCoords:
        mov enemyX[esi], 50
        mov enemyY[esi], 16
        call UpdateEnemy

        bowserCoordsValid:
        inc bowserJumpTimer
        cmp bowserJumpTimer, 50
        jl bowserGravity

        mov bowserJumpTimer, 0

        mov al, enemyY[esi]
        cmp al, 16 
        jne bowserGravity

        mov enemyY[esi], 13
        jmp bowserMoveAI

        bowserGravity:
        mov al, enemyY[esi]
        cmp al, 16
        jge bowserMoveAI
        inc enemyY[esi] 

        bowserMoveAI:
        mov al, enemyMoveCounter
        cmp al, 0
        jne bowserFireAI 

        mov al, enemyX[esi]
        mov bl, xPos
        cmp al, bl
        jl moveBowserR
        jg moveBowserL
        jmp bowserFireAI

        moveBowserR:
        inc al
        mov bl, enemyPatrolEnd[esi]
        cmp al, bl
        jg bowserFireAI
        mov enemyX[esi], al
        mov enemyDir[esi], 1
        jmp bowserFireAI

        moveBowserL:
        dec al
        mov bl, enemyPatrolStart[esi]
        cmp al, bl
        jl bowserFireAI
        mov enemyX[esi], al
        mov enemyDir[esi], 0

        bowserFireAI:
        inc bowserFireTimer
        cmp bowserFireTimer, 100 
        jl bowserDraw

        cmp bowserFireballX, 0
        jne bowserDraw 

        mov al, enemyX[esi]
        cmp al, GAME_LEFT_WALL + 1
        jl bowserDraw 
        cmp al, GAME_RIGHT_WALL
        jg bowserDraw 

        mov bowserFireballX, al
        mov al, enemyY[esi]
        cmp al, GAME_TOP
        jl bowserDraw 
        cmp al, GAME_BOTTOM
        jg bowserDraw 

        sub al, 1 
        cmp al, GAME_TOP
        jl bowserDraw 
        mov bowserFireballY, al
        mov al, enemyDir[esi]
        mov bowserFireballDir, al
        mov bowserFireTimer, 0

        bowserDraw:
        mov dl, enemyX[esi]
        mov dh, enemyY[esi]

        cmp dl, GAME_LEFT_WALL + 1
        jl bowserDone 
        cmp dl, GAME_RIGHT_WALL
        jg bowserDone 
        cmp dh, GAME_TOP
        jl bowserDone 
        cmp dh, GAME_BOTTOM
        jg bowserDone 

        mov eax, BOWSER_COLOR
        call SetTextColor
        call Gotoxy
        mov al, 'B'
        call WriteChar

        cmp bowserFireballX, 0
        je bowserDone

        mov dl, bowserFireballX
        mov dh, bowserFireballY
        cmp dl, GAME_LEFT_WALL + 1
        jle skipEraseFire
        cmp dl, GAME_RIGHT_WALL
        jge skipEraseFire
        cmp dh, GAME_TOP
        jl skipEraseFire
        cmp dh, GAME_BOTTOM
        jg skipEraseFire

        call Gotoxy
        mov eax, CASTLE_SKY_COLOR
        call SetTextColor
        mov al, ' '
        call WriteChar
        skipEraseFire:

        mov al, bowserFireballDir
        cmp al, 0
        je fireLeft
        inc bowserFireballX
        jmp checkFireBounds
        fireLeft:
        dec bowserFireballX

        checkFireBounds:
        mov al, bowserFireballX
        cmp al, GAME_LEFT_WALL + 1
        jle killFireball
        cmp al, GAME_RIGHT_WALL
        jge killFireball

        mov dl, bowserFireballX
        mov dh, bowserFireballY
        cmp dh, GAME_TOP
        jl killFireball
        cmp dh, GAME_BOTTOM
        jg killFireball

        mov eax, red + (black * 16)
        call SetTextColor
        call Gotoxy
        mov al, '*'
        call WriteChar
        jmp bowserDone

        killFireball:
        mov bowserFireballX, 0

        bowserDone:
        jmp nextEnemy

        enemyMoveDone:

        mov dl, enemyX[esi]
        mov dh, enemyY[esi]
        call Gotoxy

        mov al, enemyType[esi]
        cmp al, 1
        je checkKoopaState

        mov al, level
        cmp al, 4
        je colorGoombaCastle
        cmp al, 2
        jne colorGoombaNormal
        mov al, currentPage
        cmp al, 3
        je colorGoombaUnder
        cmp al, 5
        je colorGoombaUnder
        jmp colorGoombaNormal

        colorGoombaCastle:
        mov eax, red + (black * 16)
        jmp setGoombaColor
        colorGoombaUnder:
        mov eax, white + (red * 16)
        jmp setGoombaColor
        colorGoombaNormal:
        mov eax, ENEMY_COLOR
        setGoombaColor:
        call SetTextColor
        mov al, 'G'
        call WriteChar
        jmp nextEnemy

        checkKoopaState:
        mov al, enemyActive[esi]
        cmp al, 2 
        je drawShell
        cmp al, 3 
        je drawShell

        mov al, level
        cmp al, 4
        je colorKoopaCastle
        cmp al, 2
        jne colorKoopaNormal
        mov al, currentPage
        cmp al, 3
        je colorKoopaUnder
        cmp al, 5
        je colorKoopaUnder
        jmp colorKoopaNormal

        colorKoopaCastle:
        mov eax, lightGray + (black * 16) 
        jmp setKoopaColor
        colorKoopaUnder:
        mov eax, black + (red * 16)
        jmp setKoopaColor
        colorKoopaNormal:
        mov eax, KOOPA_COLOR 
        setKoopaColor:
        call SetTextColor
        mov al, 'K'
        call WriteChar
        jmp nextEnemy

        drawShell:
        mov al, level
        cmp al, 4
        je colorShellCastle
        cmp al, 2
        jne colorShellNormal
        mov al, currentPage
        cmp al, 3
        je colorShellUnder
        cmp al, 5
        je colorShellUnder
        jmp colorShellNormal

        colorShellCastle:
        mov eax, lightGray + (black * 16)
        jmp setShellColor
        colorShellUnder:
        mov eax, black + (red * 16)
        jmp setShellColor
        colorShellNormal:
        mov eax, SHELL_COLOR
        setShellColor:
        call SetTextColor
        mov al, 'S'
        call WriteChar
        jmp nextEnemy

        checkDeathAnimation:
        mov al, enemyDeathTimer[esi]
        cmp al, 0
        je nextEnemy
        dec al
        mov enemyDeathTimer[esi], al
        call UpdateEnemy

        nextEnemy:
        inc esi
        dec ecx
        jnz updateEnemyLoop

    enemiesUpdateDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateEnemies ENDP

CheckShellEnemyCollision PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	movzx ecx, numEnemies
	cmp ecx, 0
	je shellCollisionDone
	mov esi, 0

	checkShellLoop:
		mov al, enemyActive[esi]
		cmp al, 3
		jne nextShellCheck

		mov edi, 0
		checkOtherEnemies:
			cmp edi, esi
			je skipOtherEnemy

			mov al, enemyActive[edi]
			cmp al, 1
			jne skipOtherEnemy

			mov al, enemyY[esi]
			mov bl, enemyY[edi]
			cmp al, bl
			jne skipOtherEnemy

			mov al, enemyX[esi]
			mov bl, enemyX[edi]

			sub al, bl
			jns distPositive
			neg al

			distPositive:
			cmp al, 2
			jg skipOtherEnemy

			mov enemyActive[edi], 0

			push esi
			mov esi, edi
			call UpdateEnemy
			pop esi

			call PlayKillSound

			add score, 100 
			
			call DrawHUD

			mov al, level
			cmp al, 2
			je storeKillL2

			mov al, currentPage
			cmp al, 1
			je killPg1W1
			cmp al, 2
			je killPg2W1
			cmp al, 3
			je killPg3W1
			jmp skipOtherEnemy

			killPg1W1:
			mov world1pg1_enemyActive[edi], 0
			jmp skipOtherEnemy
			killPg2W1:
			mov world1pg2_enemyActive[edi], 0
			jmp skipOtherEnemy
			killPg3W1:
			mov world1pg3_enemyActive[edi], 0
			jmp skipOtherEnemy

			storeKillL2:
			mov al, currentPage
			cmp al, 1
			je killPg1W2
			cmp al, 2
			je killPg2W2
			cmp al, 3
			je killPg3W2
			cmp al, 4
			je killPg4W2
			cmp al, 5
			je killPg5W2
			jmp skipOtherEnemy

			killPg1W2:
			mov world2pg1_enemyActive[edi], 0
			jmp skipOtherEnemy
			killPg2W2:
			mov world2pg2_enemyActive[edi], 0
			jmp skipOtherEnemy
			killPg3W2:
			mov world2pg3_enemyActive[edi], 0
			jmp skipOtherEnemy
			killPg4W2:
			mov world2pg4_enemyActive[edi], 0
			jmp skipOtherEnemy
			killPg5W2:
			mov world2pg5_enemyActive[edi], 0

			skipOtherEnemy:
			inc edi
			cmp edi, maxEnemies
			jl checkOtherEnemies

		nextShellCheck:
		inc esi
		dec ecx
		jnz checkShellLoop

	shellCollisionDone:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
CheckShellEnemyCollision ENDP

CheckEnemyCollision PROC
	push eax
	push ebx
	push ecx
	push edx
	push esi

	movzx ecx, numEnemies
	cmp ecx, 0
	je collisionDone
	mov esi, 0

	checkEnemyLoop:
		mov al, enemyActive[esi]
		cmp al, 0
		je nextEnemyCheck

		mov bl, enemyX[esi]
		mov bh, enemyY[esi]

		mov dl, xPos
		mov dh, yPos

		cmp dl, bl
		jne nextEnemyCheck


		mov al, enemyActive[esi]
		cmp al, 2
		je handleStationaryShell
		cmp al, 3
		je handleKickedShell

		mov al, bh
		dec al          
		cmp dh, al      
		je stompEnemy

		cmp dh, bh      
		je sideCollision

		mov al, dh
		dec al          
		cmp al, bh      
		je sideCollision

		jmp nextEnemyCheck

	handleStationaryShell:
		cmp dh, bh      
		je kickIt
		mov al, dh
		dec al          
		cmp al, bh      
		je kickIt
		jmp nextEnemyCheck

		kickIt:
		jmp kickShell

	handleKickedShell:
		cmp dh, bh      
		je shellHitsMario
		mov al, dh
		dec al          
		cmp al, bh      
		je shellHitsMario
		jmp nextEnemyCheck

		stompEnemy:
		cmp isJumping, 1
		je nextEnemyCheck 

		mov al, enemyType[esi]
		cmp al, 1
		je stompKoopa
		cmp al, 3
		je stompBowser

		call PlayKillSound 
		mov enemyActive[esi], 0
		jmp updateEnemyStateStomp

		stompBowser:
		mov isJumping, 1
		mov currentJump, 3
		jmp nextEnemyCheck

		stompKoopa:
		call PlayKillSound 
		mov enemyActive[esi], 2
		
		add score, 100
		
		mov isJumping, 1
		mov currentJump, 3
		jmp updateEnemyStateStomp 

		updateEnemyStateStomp:
		mov al, level
		cmp al, 2
		je storeEnemyLevel2
		cmp al, 4
		je storeEnemyLevel4

		mov al, currentPage
		cmp al, 1
		je storeEnemyPg1_W1
		cmp al, 2
		je storeEnemyPg2_W1
		cmp al, 3
		je storeEnemyPg3_W1
		jmp enemyStateStored

		storeEnemyLevel4:
		mov al, currentPage
		cmp al, 1
		je storeEnemyPg1_W4
		cmp al, 2
		je storeEnemyPg2_W4
		cmp al, 3
		je storeEnemyPg3_W4
		jmp enemyStateStored

		storeEnemyPg1_W4:
		mov world4pg1_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg2_W4:
		mov world4pg2_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg3_W4:
		mov world4pg3_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg1_W1:
		mov world1pg1_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg2_W1:
		mov world1pg2_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg3_W1:
		mov world1pg3_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyLevel2:
		mov al, currentPage
		cmp al, 1
		je storeEnemyPg1_W2
		cmp al, 2
		je storeEnemyPg2_W2
		cmp al, 3
		je storeEnemyPg3_W2
		cmp al, 4
		je storeEnemyPg4_W2
		cmp al, 5
		je storeEnemyPg5_W2
		jmp enemyStateStored

		storeEnemyPg1_W2:
		mov world2pg1_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg2_W2:
		mov world2pg2_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg3_W2:
		mov world2pg3_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg4_W2:
		mov world2pg4_enemyActive[esi], 0
		jmp enemyStateStored

		storeEnemyPg5_W2:
		mov world2pg5_enemyActive[esi], 0

		enemyStateStored:
		mov enemyDeathTimer[esi], 5 

		call UpdateEnemy

		add score, 100
		call DrawHUD

		mov isJumping, 1
		mov currentJump, 0
		mov jumpHeight, 3 

		jmp nextEnemyCheck

		sideCollision:
		mov al, enemyActive[esi]
		cmp al, 0
		je nextEnemyCheck 

		cmp al, 2
		je kickShell 

		cmp al, 3
		je shellHitsMario 

		cmp al, 1
		jne nextEnemyCheck 

		cmp isInvincible, 1
		je killEnemyTouch

		dec lives
		cmp lives, 0
		jle gameOverCollision

		mov gameOver, 2 
		jmp collisionDone

		killEnemyTouch:
		call PlayKillSound
		mov enemyActive[esi], 0
		jmp updateEnemyStateStomp 

		kickShell:
		mov al, marioFacingDirection
		cmp al, 1
		je kickShellRight 

		mov enemyDir[esi], 0 
		mov enemyActive[esi], 3 
		jmp saveKickedState

		kickShellRight:
		mov enemyDir[esi], 1 
		mov enemyActive[esi], 3 

		saveKickedState:
		push eax
		mov al, level
		cmp al, 2
		je storeKickL2

		mov al, currentPage
		cmp al, 1
		je saveKickPg1W1
		cmp al, 2
		je saveKickPg2W1
		cmp al, 3
		je saveKickPg3W1
		jmp doneSaveKick

		saveKickPg1W1:
		mov world1pg1_enemyActive[esi], 3
		jmp doneSaveKick
		saveKickPg2W1:
		mov world1pg2_enemyActive[esi], 3
		jmp doneSaveKick
		saveKickPg3W1:
		mov world1pg3_enemyActive[esi], 3
		jmp doneSaveKick

		storeKickL2:
		mov al, currentPage
		cmp al, 1
		je saveKickL2Pg1
		cmp al, 2
		je saveKickL2Pg2
		cmp al, 3
		je saveKickL2Pg3
		cmp al, 4
		je saveKickL2Pg4
		cmp al, 5
		je saveKickL2Pg5
		jmp doneSaveKick

		saveKickL2Pg1:
		mov world2pg1_enemyActive[esi], 3
		jmp doneSaveKick
		saveKickL2Pg2:
		mov world2pg2_enemyActive[esi], 3
		jmp doneSaveKick
		saveKickL2Pg3:
		mov world2pg3_enemyActive[esi], 3
		jmp doneSaveKick
		saveKickL2Pg4:
		mov world2pg4_enemyActive[esi], 3
		jmp doneSaveKick
		saveKickL2Pg5:
		mov world2pg5_enemyActive[esi], 3

		doneSaveKick:
		pop eax
		jmp nextEnemyCheck

		shellHitsMario:
		dec lives
		cmp lives, 0
		jle gameOverCollision
		mov gameOver, 2
		jmp collisionDone

		gameOverCollision:
		mov gameOver, 1 
		jmp collisionDone 

		nextEnemyCheck:
		inc esi
		dec ecx
		jnz checkEnemyLoop

	collisionDone:

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
CheckEnemyCollision ENDP

; ============================================
; Initializes audio system and loads all sound files
; Must be called once at program start
; ============================================
InitAudio PROC
	push eax
	INVOKE mciSendStringA, OFFSET cmdOpenIntro, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenTheme, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenUnder, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenWin, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenGameOv, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenJump, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenKill, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdOpenCoin, 0, 0, 0
	pop eax
	ret
InitAudio ENDP

; ============================================
; Stops all currently playing background music tracks
; ============================================
StopAllMusic PROC
	push eax
	INVOKE mciSendStringA, OFFSET cmdStopIntro, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdStopTheme, 0, 0, 0
	INVOKE mciSendStringA, OFFSET cmdStopUnder, 0, 0, 0
	mov currentMusic, 0
	pop eax
	ret
StopAllMusic ENDP

; ============================================
; Plays the intro/menu music in a loop
; ============================================
PlayIntroMusic PROC
	cmp currentMusic, 1
	je skipIntro

	call StopAllMusic
	INVOKE mciSendStringA, OFFSET cmdPlayIntro, 0, 0, 0
	mov currentMusic, 1
skipIntro:
	ret
PlayIntroMusic ENDP

; ============================================
; Selects and plays appropriate background music
; Based on current level and page (theme or underground)
; ============================================
PlayLevelMusic PROC
	push eax
	push ebx

	mov ebx, 2 

	mov al, level
	cmp al, 2
	jne checkCastle

	mov al, currentPage
	cmp al, 3
	je setUnder
	cmp al, 5
	je setUnder
	jmp checkChange

checkCastle:
	cmp al, 4
	jne checkChange
	jmp setUnder 

setUnder:
	mov ebx, 3 

checkChange:
	cmp currentMusic, ebx
	je musicDone 

	call StopAllMusic
	mov currentMusic, ebx

	cmp ebx, 2
	je playTheme
	cmp ebx, 3
	je playUnder
	jmp musicDone

playTheme:
	INVOKE mciSendStringA, OFFSET cmdPlayTheme, 0, 0, 0
	jmp musicDone

playUnder:
	INVOKE mciSendStringA, OFFSET cmdPlayUnder, 0, 0, 0

musicDone:
	pop ebx
	pop eax
	ret
PlayLevelMusic ENDP

; ============================================
; Plays jump sound effect 
; ============================================
PlayJumpSound PROC
	pushad              
	INVOKE mciSendStringA, OFFSET cmdPlayJump, 0, 0, 0
	popad               
	ret
PlayJumpSound ENDP

; ============================================
; Plays enemy kill sound effect 
; ============================================
PlayKillSound PROC
	pushad              
	INVOKE mciSendStringA, OFFSET cmdPlayKill, 0, 0, 0
	popad
	ret
PlayKillSound ENDP

PlayCoinSound PROC
	pushad
	INVOKE mciSendStringA, OFFSET cmdPlayCoin, 0, 0, 0
	popad
	ret
PlayCoinSound ENDP

; ============================================
; Plays level complete victory sound
; Stops background music to play victory theme
; ============================================
PlayWinSound PROC
	pushad
	call StopAllMusic   
	INVOKE mciSendStringA, OFFSET cmdPlayWin, 0, 0, 0
	popad
	ret
PlayWinSound ENDP

; ============================================
; Plays game over sound effect
; Stops background music to play game over theme
; ============================================
PlayGameOverSound PROC
	pushad
	call StopAllMusic
	INVOKE mciSendStringA, OFFSET cmdPlayGameOv, 0, 0, 0
	popad
	ret
PlayGameOverSound ENDP

END main