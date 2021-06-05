# HackMan

> Terminal-based Pac-Man like game

By [Jamie Lievesley](https://jamiegl.co.uk) (2012).

---

## Installation

Windows only!

### Installer Version

1. Execute:

```
HackMan-Setup.exe
```

2. Run HackMan from the installed location.

### Portable Version

1. Extract zip to desired location.

2. Execute:

```
hackman.exe
```

---

## Usage

Running HackMan will open a terminal window.

### Objective

                             You are Hack-Man ☻
                    You are hacking into a computer system

               Move Hack-Man ☻ around screen using W,A,S,D keys
                            Collect all data bits o
                    Avoid anti-viruses ±, you have 3 lives
                 Create power surges by collecting powerups ○
                     Collect batteries ó for bonus points

              As the game progresses the difficulty will increase
                              Aim for a highscore

### Keys:

#### In Menu

- `W`, `S` or `UP`, `DOWN` - navigate menu
- `SPACEBAR` or `ENTER` - confirm selected option
- `ESC` or `BACKSPACE` or `DEL` - return to previous screen

#### In Game

- `W`, `A`, `S`, `D` - move player
- `ESC` - pause

#### In Pause Menu

- `Q` - quit (to main menu)
- _Any other key_ - resume

#### Viewing Highscores Screen

- _Any key_ - Continue (to main menu)

#### Entering a New Highscore

1. Enter three letters or numbers for your name.
2. Press `ENTER` or `SPACEBAR` to submit.

---

## Custom Mazes

You can edit the maze file and create your own mazes.  
Some examples are provided in the download under the _mazes_ folder.  
In your HackMan installation folder, edit the file: _maze.txt_.  
It is recommended you backup this file first.

Syntax:

- `.` - empty
- space - empty
- `X` - wall
- `*` - data bit (coin)
- `?` - battery (fruit)
- `@` - powerup
- `P` - player start
- `T` - teleport
- `G` - ghost home
- `g` - ghost spawn
- `H` - ghost door

Rules:

- Case sensitive.
- Maze must be exactly 53 characters wide and up to 23 lines high.
- Hallways must be 1 cell high vertically, but **3** cells wide horizontally, with any non-dot characters centred. This is due to how characters are sized when rendered.

eg.

```
XXXXXXX
X.*..*.
X.@.XXX
X.*.XXX
```

- Maze should have a barrier wall (`X`) around the edges to stop the player going out of bounds (but it does not need to be located at the very edge cells).
- Exactly one player must exist (1 `P` per maze).
- Exactly one battery must exist (1 `?` per maze).
- Exactly three ghost homes must exist (3 `G`s per maze).
- Exactly one ghost spawn must exist (1 `g` per maze).
- Teleporters must be mirrored on either end of the same line, at the very start and very end of the line only (2 `T`s per line).

Notes:

- Ghost doors (`H`) are purely aesthetic and behave like walls.
- You can have teleporters (`T`s) on as many lines as you like (or none).
- You can have as many data bits (`*`s) and powerups (`@`s) as you like.

---

## Copyright & Licensing

Created in an education environment.

Licensed for use under the GNU General Public License v3.

Based upon original concept:  
Pac-Man - © Copyright Namco 1980.
