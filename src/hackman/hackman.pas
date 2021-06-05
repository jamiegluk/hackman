program hackman;
{Jamie Lievesley 29 Oct 2012}
{HackMan Project}

uses crt, keyboard;

{Define records here}
type
    {x, y coordinate}
    coord =
        record
            x :integer{1..53};
            y :integer{1..23};
        end; {END coord}

type
    {Holds info about a single ghost}
    ghostData =
        record
            loc :coord;
            direction :integer{1..4};
            alive :boolean;
            shocked :boolean;
            ticks :integer;
        end; {END ghostData}

type
    {Holds info about fixed ghost spawn locations}
    _ghostSpawnData =
        record
            spawn :coord;
            home1 :coord;
            home2 :coord;
            home3 :coord;
        end; {END ghostSpawnData}

type
    {Single highscore}
    highscoreRecord =
        record
            name :string;
            score :integer;
        end; {END highscoreRecord}

{Put global vars here, should only be arrays}
var maze :array[1..53, 1..23] of integer; {char/line or x/y or column/row}
var ghostDataList : array[1..4] of ghostData; {array of ghostData for 4 ghosts}
var highscores :array[1..10] of highscoreRecord; {all highscores}


{SETUP THE GAME}

{Displays only the title for the main menu}
procedure drawMainMenuTitle();
        begin;

        TextColor(LightGreen);
        GoToXY(1, 7);
        writeln('         _     _ _______ _______ _     _     _______ _______ __   _ ');
        writeln('         |_____| |_____| |       |____/  ___ |  |  | |_____| | \  |  ');
        writeln('         |     | |     | |_____  |    \_     |  |  | |     | |  \_|  ');
        TextColor(White);

        end; {END drawMainMenuTitle}

{displays the menu options for the main menu}
procedure drawMenuOptions(menuOption :integer);
        begin;

        GoToXY(30, 12);
        if menuOption = 1 then
            writeln('>  Start  Game  <')
        else
            writeln('   Start  Game   ');

        GoToXY(30, 13);
        if menuOption = 2 then
            writeln('>  High Scores  <')
        else
            writeln('   High Scores   ');

        GoToXY(30, 14);
        if menuOption = 3 then
            writeln('>     Help      <')
        else
            writeln('      Help       ');

        end; {END drawMenuOptions}

{writes the highscores array to file}
procedure saveHighscores;

        {vars}
        var hsFile :text;
        var filename :string;
        var counter :integer;

        begin;
        {assign filename to text}
        filename := 'highscores';
        assignfile(hsFile, filename);
        rewrite(hsfile);
        for counter := 1 to 10 do
            begin;
            writeln(hsFile, highscores[counter].name);
            writeln(hsFile, highscores[counter].score);
            end;
        closefile(hsFile)

        end; {END saveHighscores}

{for the sake of requiring a binary search at advanced higher}
procedure binarySearchScores(textToFind :string; var found :boolean);

        {vars}
        var counter :integer;

        begin;
        {TODO - put binary search in here}
        {uses linear search until I have access to Mrs Collings's source at school}
        found := false;
        for counter := 1 to 10 do
            begin
            if highscores[counter].name = textToFind then
                begin
                found := true;
                break;
                end;
            end;

        end; {END binarySearch}

{for the sake of including a bubble sort at advanced higher}
procedure bubbleSortScores;

        {vars}
        var i, j :integer;
        var tmp :highscoreRecord;

        begin;
        {TODO - put bubble sort in here}
        {cant do until I have access to Mrs Collings's source at school}
        for i := 9 downto 1 do
            for j := 1 to i do
                if highscores[j].score < highscores[j + 1].score then
                    begin
                    tmp := highscores[j];
                    highscores[j] := highscores[j + 1];
                    highscores[j + 1] := tmp;
                end;

        end; {END bubbleSortScores}


{handles new highscores at the end of the game}
procedure handleFinalScore(score :integer);

        {vars}
        var name :string;
        var letter :char;
        var found :boolean;
        const alphas = ['A'..'Z', 'a'..'z'];

        begin;
        {check if score is at least more than (or equal to) the lowest one}
        if score >= highscores[10].score then
            begin

            {get name}
            ClrScr;
            TextColor(LightGreen);
            GoToXY(26, 10);
            writeln('Enter your name (3 letters):');
            name := '';
            while true do
                begin

                {redraw text}
                TextColor(Black);
                TextBackground(White);
                GoToXY(37, 11);
                write('     ');
                GoToXY(38, 11);
                write(name);
                if length(name) < 3 then
                    write('_');

                {check if name already in highscores}
                binarySearchScores(name, found);
                GoToXY(24, 13);
                TextColor(Yellow);
                TextBackground(Black);
                if found then
                    write('Name found in current highscores')
                else
                    write('                                ');

                letter := ReadKey;

                {add a letter}
                if letter in alphas then
                    begin
                    if length(name) < 3 then
                        name += upcase(letter);
                    end
                {delete a letter}
                else if letter = #8 then {backsace}
                    begin
                    if length(name) = 1 then
                        name := ''
                    else if length(name) = 2 then
                        name := name[1]
                    else if length(name) = 3 then
                        name := name[1] + name[2];
                    end
                {confirm}
                else if (letter = #13) or (letter = ' ') then
                    begin
                    if length(name) = 3 then
                        break;
                    end;

                end;
            TextBackground(Black);

            {add highscore, overwrite current lowest}
            highscores[10].name := name;
            highscores[10].score := score;

            {sort scores}
            bubbleSortScores;

            end;
        end; {END handleFinalScore}

{loads the highscores array from file}
procedure loadHighscores;

        {vars}
        var hsFile :text;
        var filename :string;
        var counter :integer;

        begin;
        {assign filename to text}
        filename := 'highscores';
        assignfile(hsFile, filename);
        reset(hsfile);
        for counter := 1 to 10 do
            begin;
            readln(hsFile, highscores[counter].name);
            readln(hsFile, highscores[counter].score);
            end;
        closefile(hsFile)

        end; {END saveHighscores}

{Adds zeros to the start to ensure there are at least 5 digits}
procedure zeroPadScore(scoreInt :integer; var scoreStr :string);
        begin;

        str(scoreInt, scoreStr);
        if scoreInt > 9999 then
           {do nothing}
        else if scoreInt > 999 then
           scoreStr := '0' + scoreStr
        else if scoreInt > 99 then
           scoreStr := '00' + scoreStr
        else if scoreInt > 9 then
           scoreStr := '000' + scoreStr
        else if scoreInt > 0 then
           scoreStr := '0000' + scoreStr
        else
           scoreStr := '00000';

        end; {END zeroPadScore}

{Displays the high score table}
procedure showHighScores();

        {vars}
        var counter :integer;
        var score :string;

        begin;
        ClrScr;
        TextColor(LightGreen);
        GoToXY(30, 6);
        writeln('Hack-Man High Scores');
        TextColor(White);
        for counter := 1 to 10 do
            begin
            GoToXY(33, counter + 7);
            write(counter, ': ');
            GoToXY(38, counter + 7);
            zeroPadScore(highscores[counter].score, score);
            writeln(highscores[counter].name, '  ', score);
            end; {end for}
        TextColor(White);
        {Wait for user to press any key}
        ReadKey;
        ClrScr;
        drawMainMenuTitle;

        end; {END showHighScores}

{forward declaration for drawCell}
procedure drawCell(cell :integer);
          forward;

{Displays the game help}
procedure showHelp();
        begin;

        ClrScr;

        {title}
        TextColor(LightGreen);
        GoToXY(33, 4);
        writeln('Hack-Man Help');

        {text}
        TextColor(White);

        GoToXY(31, 6);
        write('You are Hack-Man ');
        drawCell(5);
        GoToXY(21, 7);
        write('You are hacking into a computer system');

        GoToXY(16, 9);
        write('Move Hack-Man ');
        drawCell(5);
        write(' around screen using W,A,S,D keys');
        GoToXY(29, 10);
        write('Collect all data bits ');
        drawCell(2);
        write('');
        GoToXY(21, 11);
        write('Avoid anti-viruses ');
        drawCell(7);
        write(', you have 3 lives');
        GoToXY(18, 12);
        write('Create power surges by collecting powerups ');
        drawCell(4);
        GoToXY(22, 13);
        write('Collect batteries ');
        drawCell(3);
        write(' for bonus points');

        GoToXY(15, 15);
        writeln('As the game progresses the difficulty will increase');
        GoToXY(31, 16);
        writeln('Aim for a highscore');

        {copyright}
        TextColor(Yellow);
        GoToXY(28, 19);
        writeln('(c)', ' Jamie Lievesley 2012');
        GoToXY(9, 20);
        writeln('Based upon Pac-Man by Namco, no copyright infringement intended');

        {Wait for user to press any key}
        ReadKey;

        ClrScr;
        TextColor(White);
        drawMainMenuTitle;

        end; {END showHelp}

{handle user input on main menu}
procedure handleMenuInput(var inMainMenu :boolean; var menuOption :integer);

        {vars}
        var key :char;

        begin;
        {deal with key pressed}
        key := ReadKey;
        if (key = 'W') or (key = 'w') or (key = 'S') or (key = 's') or (key = #72) or (key = #80) then
            begin

            if (key = 'W') or (key = 'w') or (key = #72) then
                {up pressed}
                begin
                menuOption -= 1;
                if menuOption < 1 then
                menuOption := 3;
                end
            else if (key = 'S') or (key = 's') or (key = #80) then
                {down pressed}
                begin
                menuOption += 1;
                if menuOption > 3 then
                menuOption := 1;
                end;

            end
        else if (key = ' ') or (key = #13) then
            if menuOption = 1 then
                inMainMenu := false
            else if menuOption = 2 then
                showHighScores
            else
                showhelp;

        {redraw menu}
        drawMenuOptions(menuOption);

        end; {END handleMenuInput}

{changes text into int for 2D array of integers}
procedure compileMazeLine(line :string; lineNumber :integer);

        {vars}
        var charCounter :integer;
        var character :char;

        begin;
        {loop through each item}
        for charCounter := 1 to 53 do
            begin

            character := line[charCounter];
            case character of
                '.' : maze[charCounter, lineNumber] := 0; {empty space}
                ' ' : maze[charCounter, lineNumber] := 0; {empty space, again}
                'X' : maze[charCounter, lineNumber] := 1; {wall}
                '*' : maze[charCounter, lineNumber] := 2; {coin}
                '?' : maze[charCounter, lineNumber] := 3; {fruit}
                '@' : maze[charCounter, lineNumber] := 4; {powerup}
                'P' : maze[charCounter, lineNumber] := 5; {player start}
                'T' : maze[charCounter, lineNumber] := 6; {teleport}
                'G' : maze[charCounter, lineNumber] := 7; {ghost home}
                'g' : maze[charCounter, lineNumber] := 8; {ghost spawn}
                'H' : maze[charCounter, lineNumber] := 9; {ghost door}
                else maze[charCounter, lineNumber] := 0; {invalid character}
                end; {end case}

            end; {end for}

        end; {END compileMazeLine}

{load the text containing the maze from file}
procedure loadMaze;

        {vars}
        var mazeFile :text;
        var filename, line :string;
        var linenumber :integer;

        begin;
        {assign filename to text}
        filename := 'maze.txt';
        assignfile(mazeFile, filename);
        reset(mazefile);
        lineNumber := 1;
        while not(eof(mazeFile)) and (lineNumber <= 23) do
            begin
            readln(mazeFile, line);
            compileMazeLine(line, lineNumber);
            lineNumber := lineNumber + 1;
            end; {end while}
        closefile(mazeFile)

        end; {END loadMaze}

{draws a single maze cell to screen}
procedure drawCell(cell :integer);
        begin;

        TextColor(White);
        TextBackground(Black);
        if cell = 0 then {empty space}
            begin
            write(' ');
            end
        else if cell = 1 then {wall}
            begin
            TextBackground(Green);
            write(' ');
            end
        else if cell = 2 then {coin}
            begin
            TextColor(White);
            write(#111);
            end
        else if cell = 3 then {fruit}
            begin
            TextColor(Magenta);
            write(#162);
            end
        else if cell = 4 then {powerup}
            begin
            TextColor(LightCyan);
            Textbackground(Blue);
            write(#9);
            end
        else if cell = 5 then {player start}
            begin
            TextColor(Yellow);
            write(#2);
            end
        else if cell = 6 then {teleport}
            begin
            write(' ');
            end
        else if cell = 7 then {ghost home}
            begin
            TextColor(Red);
            write(#241);
            end
        else if cell = 8 then {ghost spawn}
            begin
            write(' ');
            end
        else if cell = 9 then {ghost door}
            begin
            TextBackground(15);
            write(' ');
            end;

        {reset colours for future drawing}
        TextColor(White);
        TextBackground(Black);

        end; {END drawCell}

{displays the maze on screen}
procedure drawMaze;

        var columnCounter, rowCounter, cell :integer;

        begin;
        {loop through each item}
        {FOR1} for rowCounter := 1 to 23 do
            begin

            {FOR2} for columnCounter := 1 to 53 do
                begin;
                cell := maze[columnCounter, rowCounter];
                drawCell(cell);
                end; {end FOR2}
            writeln; {end of row}

            end; {end FOR1}

        end; {END drawMaze}

{draws the score, lives etc}
procedure drawHud;
        begin;

        {HIGH SCORE TITLE}
        {line2}
        TextColor(LightMagenta);
        GoToXY(56, 2);
        write('HIGH ');
        {line3}
        GoToXY(56, 3);
        write('SCORE');

        {HIGH SCORE}
        {line 5, 6, 7, 8, 9}
        TextColor(White);
        GoToXY(58, 5);
        write(0);
        GoToXY(58, 6);
        write(0);
        GoToXY(58, 7);
        write(0);
        GoToXY(58, 8);
        write(0);
        GoToXY(58, 9);
        write(0);
        {line 11}
        TextColor(LightMagenta);
        GoToXY(56, 11);

        {GAME SCORE TITLE}
        write('GAME ');
        {line 12}
        GoToXY(56, 12);
        write('SCORE');

        {GAME SCORE}
        {line 14, 15, 16, 17, 18}
        TextColor(White);
        GoToXY(58, 14);
        write(0);
        GoToXY(58, 15);
        write(0);
        GoToXY(58, 16);
        write(0);
        GoToXY(58, 17);
        write(0);
        GoToXY(58, 18);
        write(0);

        {LEVEL}
        {line 20}
        GoToXY(57, 20);
        TextColor(LightMagenta);
        write('LV1');

        {LIVES}
        {line 22}
        GoToXY(58, 22);
        TextColor(Yellow);
        write(#2);
        {line 23}
        GoToXY(58, 23);
        write(#2);
        {line 24}
        GoToXY(58, 24);
        write(#2);

        end; {END drawHud}

{finds the player and ghost spawns in the maze}
procedure findSpriteLocations(var playerSpawn, fruitSpawn :coord;
                                var ghostSpawnData :_ghostSpawnData;
                                var coinCount :integer);

        var xCount, yCount, cell , ghostHomesFound :integer;

        begin;
        ghostHomesFound := 0;
        coinCount := 0;

        {loop through using linear search}
        {FOR1} for xCount := 1 to 53 do
            {FOR2} for yCount := 1 to 23 do
                begin

                cell := maze[xCount, yCount];
                if cell = 5 then {player spawn}
                    begin
                    playerSpawn.x := xCount;
                    playerSpawn.y := yCount;
                    end
                else if cell = 8 then {ghost spawn}
                    begin
                    ghostSpawnData.spawn.x := xCount;
                    ghostSpawnData.spawn.y := yCount;
                    end
                else if cell = 3 then {fruit}
                    begin
                    fruitSpawn.x := xCount;
                    fruitSpawn.y := yCount;
                    end
                else if cell = 2 then {coin}
                    coinCount := coinCount + 1
                else if cell = 7 then {a ghost home - 1 of 3}
                    begin
                    if ghostHomesFound = 0 then
                        begin
                        ghostSpawnData.home1.x := xCount;
                        ghostSpawnData.home1.y := yCount;
                        end
                    else if ghostHomesFound = 1 then
                        begin
                        ghostSpawnData.home2.x := xCount;
                        ghostSpawnData.home2.y := yCount;
                        end
                    else if ghostHomesFound = 2 then
                        begin
                        ghostSpawnData.home3.x := xCount;
                        ghostSpawnData.home3.y := yCount;
                        end;
                    ghostHomesFound := ghostHomesFound + 1;
                    end; {end else}

                end; {end FOR2}

        end; {END findSpriteLocations}


{PLAY GAME}

{teleports the player to other side}
procedure teleportPlayer(var newX :integer);
        {can only be done horizontally on very edge}
        {will always teleprt to opposite edge at same Y coord only}

        begin;
        if newX = 1 then
            newX := 53
        else if newX = 53 then
            newX := 1;

        end; {END teleportPlayer}

{works out if a cell is an intersection in the maze}
procedure isAtIntersection(loc :coord; direction :integer; var valid :boolean);

        var cell1, cell2 :coord;

        begin;

        valid := false;

        {get cells to check}
        {dont check cells along current direction, but check 2 other adjacent ones}
        {1/2/3/4 RIGHT/DOWN/LEFT/UP}
        if (direction = 1) or (direction = 3) then {RIGHT/LEFT}
            begin

            {get cells above and below}
            cell1.x := loc.x;
            cell1.y := loc.y - 1;
            cell2.x := loc.x;
            cell2.y := loc.y + 1;

            {check cells, work for 3 wide columns}
            {above --- or -*-}
            if not(maze[cell1.x -1, cell1.y] = 1) and
                    not(maze[cell1.x, cell1.y] = 1) and
                    not(maze[cell1.x +1, cell1.y] = 1) then
                valid := true;

            {below --- or -*-}
            if not(maze[cell2.x -1, cell2.y] = 1) and
                    not(maze[cell2.x, cell2.y] = 1) and
                    not(maze[cell2.x +1, cell2.y] = 1) then
                valid := true;

            end {end if}
        else if (direction = 2) or (direction = 4) then {DOWN/UP}
            begin

            {get cells before and after}
            cell1.y := loc.y;
            cell1.x := loc.x - 1;
            cell2.y := loc.y;
            cell2.x := loc.x + 1;

            {check cells}
            if not(maze[cell1.x, cell1.y] = 1) then
                if not(maze[cell1.x - 1, cell1.y] = 1) then
                    valid := true;
            if maze[cell2.x, cell2.y] = 0 then
                if not(maze[cell1.x + 1, cell1.y] = 1) then
                    valid := true;

            end; {end else}

        end; {END isAtIntersection}

{advances a cell based on direction given}
procedure moveCellInDirection(direction : integer; var loc :coord);
        begin

        case direction of
            1 : loc.x += 1;
            2 : loc.y += 1;
            3 : loc.x -= 1;
            4 : loc.y -= 1;
        end;

        end; {END moveCellInDirection}

{checks if a move direction is valid}
procedure isValidMoveDirection(direction : integer; loc :coord; var valid :boolean);
        begin;

        valid := false;

        {get new cell}
        moveCellInDirection(direction, loc);

        {check cell and surroundings}
        {1/2/3/4 RIGHT/DOWN/LEFT/UP}
        {IF1} if (direction = 2) or (direction = 4) then {DOWN/UP}
            begin

            {check cells, work for 3 wide columns}
            {IF2} if not(maze[loc.x -1, loc.y] = 1) and
                not( (maze[loc.x, loc.y] = 1) or (maze[loc.x, loc.y] = 9) ) and
                not(maze[loc.x +1, loc.y] = 1) then
                valid := true;

            end {end IF1}
        else {IF3} if (direction = 1) or (direction = 3) then {RIGHT/LEFT}
            begin

            {check cells, work for 3 wide columns}
            {check the cell and next cell after it}
            {IF4} if not(maze[loc.x, loc.y] = 1) then
                {IF5} if direction = 1 then
                    begin
                    if not(maze[loc.x + 1, loc.y] = 1) then
                        valid := true;
                    end {end IF5}
                else
                    if not(maze[loc.x - 1, loc.y] = 1) then
                        valid := true;

            end; {end IF3}

        {check for out of bounds coords}
        if (loc.x > 53) or (loc.x < 1) or (loc.y > 23) or (loc.y < 1) then
            valid := false;

        end; {END isValidMoveDirection}

{helps make ghosts avoid other ghosts}
procedure isNotMovingIntoGhost(direction : integer; loc :coord; var valid :boolean);

        var counter :integer;

        begin;

        valid := true;

        {get new cell}
        moveCellInDirection(direction, loc);

        {check for clash with other ghost locations}
        for counter := 1 to 4 do
            if (loc.x = ghostDataList[counter].loc.x) and (loc.y = ghostDataList[counter].loc.y) then
                begin;
                valid := false;
                break;
                end;

        end; {END isNotMovingIntoGhost}

{flashes the board when powerup is captured}
procedure boardFlashBlue;

        var counter, columnCounter, rowCounter, cell :integer;

        begin;
        {loop through each item}
        {FOR1} for counter := 1 to 3 do
            begin
            {FOR2} for rowCounter := 1 to 23 do
                begin
                {FOR3} for columnCounter := 1 to 53 do
                    begin
                    cell := maze[columnCounter,rowCounter];
                    if cell = 1 then
                       {draw blue cell}
                       begin

                       GoToXY(columnCounter, rowCounter);
                       TextBackground(Blue);
                       write(' ');

                       end {end if}
                    end; {end FOR3}
                end; {end FOR2}
            Delay(200);
            {FOR4} for rowCounter := 1 to 23 do
                begin
                {FOR5} for columnCounter := 1 to 53 do
                    begin
                    cell := maze[columnCounter,rowCounter];
                    if cell = 1 then
                       {draw green cell}
                       begin
                       GoToXY(columnCounter, rowCounter);
                       drawCell(cell);
                       end {end if}
                    end; {end FOR5}
                end; {end FOR4}
            Delay(200);
            end; {end FOR1}

        end; {END boardFlashBlue}

{moves the player in the specified direction}
procedure movePlayer(var playerLoc :coord; nextDirection :integer;
                         var direction, score, coinCount, shockTicks :integer;
                         var fruitSpawned, shockTimerActive :boolean);

        var cell, counter :integer;
        var valid :boolean;

        begin;

        {remove old player char}
        GoToXY(playerLoc.x, playerLoc.y); {move cursor to old cell}
        TextBackground(Black);
        TextColor(White);
        write(' '); {draw blank space}
        GoToXY(1, 24); {put cursor back}

        {check if players chosen direction is valid}
        isValidMoveDirection(nextDirection, playerLoc, valid);
        if valid then
            direction := nextDirection;

        {change position}
        isValidMoveDirection(direction, playerLoc, valid);
        if valid then
            begin

            {get new coordinates}
            moveCellInDirection(direction, playerLoc);

            {check for obstacles}
            cell := maze[playerLoc.x, playerLoc.y];
            case cell of
                2 : begin {coin}
                    coinCount := coinCount - 1;
                    score := score + 10;
                    maze[playerLoc.x, playerLoc.y] := 0; {replace cell with empty space}
                    end;
                3 : begin {fruit}
                    score := score + 100;
                    writeln('GOT FRUIT                                     ');
                    maze[playerLoc.x, playerLoc.y] := 0; {replace cell with empty space}
                    fruitSpawned := false; {start fruit spawning again}
                    end;
                4 : begin {powerup}
                    score := score + 50;
                    for counter := 1 to 4 do
                        ghostDataList[counter].shocked := true;
                    shockTicks := 1;
                    shockTimerActive := true;
                    writeln('GOT POWERUP                                   ');
                    boardFlashBlue;
                    maze[playerLoc.x, playerLoc.y] := 0; {replace cell with empty space}
                    end;
                6 : begin {teleport to other side}
                    teleportPlayer(playerLoc.x);
                    end;
            end; {end case}

            end; {end if}


        {redraw player}
        GoToXY(playerLoc.x, playerLoc.y); {move cursor to new cell}
        drawCell(5);

        end; {END movePlayer}

{finds the best direction to take at an intersection to reach location}
procedure ghostFindBestRoute(ghostLoc, findLoc :coord;
                                 var direction, smallestDistance :integer);

        var cellLoc :coord;
        var distanceRight, distanceDown, distanceLeft, distanceUp :integer;
        var valid :boolean;

        begin;

        distanceRight := 54;
        distanceDown := 54;
        distanceLeft := 54;
        distanceUp := 54;

        {1/2/3/4 RIGHT/DOWN/LEFT/UP}

        {right}
        isValidMoveDirection(1, ghostLoc, valid);
        if valid then
            begin
            distanceRight := findLoc.x - ghostLoc.x;
            if not(direction = 3) then
                direction := 1;
            end;

        {down}
        isValidMoveDirection(2, ghostLoc, valid);
        if valid then
            begin;
            distanceDown := findLoc.y - ghostLoc.y;
            if not(direction = 4) then
                direction := 2;
            end;

        {left}
        isValidMoveDirection(3, ghostLoc, valid);
        if valid then
            begin;
            distanceLeft := ghostLoc.x - findLoc.x;
            if not(direction = 1) then
                direction := 3;
            end;

        {up}
        isValidMoveDirection(4, ghostLoc, valid);
        if valid then
            begin;
            distanceUp := ghostLoc.y - findLoc.y;
            if not(direction = 2) then
                direction := 4;
            end;

        {find smallest distance}
        smallestDistance := 54;
        if (distanceRight < smallestDistance) and (distanceRight > 0) then
            begin
            smallestDistance := distanceRight;
            direction := 1;
            end;
        if (distanceDown < smallestDistance) and (distanceDown > 0) then
            begin
            smallestDistance := distanceDown;
            direction := 2;
            end;
        if (distanceLeft < smallestDistance) and (distanceLeft > 0) then
            begin
            smallestDistance := distanceLeft;
            direction := 3;
            end;
        if (distanceUp < smallestDistance) and (distanceUp > 0) then
            begin
            smallestDistance := distanceUp;
            direction := 4;
            end;

        end; {END ghostFindBestRoute}

{picks a random direction (integer 1-4)}
procedure getRandomDirection(loc :coord; var direction :integer);

        var valid :boolean;
        var newDirection :integer;

        begin
        {loop until unblocked direction chosen}
        valid := false;
        repeat
            begin;
            newDirection := Random(4) + 1;
            if not( (((direction = 1) and (newDirection = 3)) or ((direction = 1) and (newDirection = 3))) or
                    (((direction = 2) and (newDirection = 4)) or ((direction = 2) and (newDirection = 4))) ) then
                isValidMoveDirection(newDirection, loc, valid);
            end;
        until valid; {end repeat}
        direction := newDirection;

        end; {END getRandomDirection}

{handles the ghost's AI}
procedure moveGhost(counter :integer; playerLoc :coord);

         {vars}
         var gx, gy, cell, nextCell, distance :integer;
         var inters, valid, valid2 :boolean;

         begin;

        {remove ghost}
        gx := ghostDataList[counter].loc.x;
        gy := ghostDataList[counter].loc.y;
        GoToXY(gx, gy); {move cursor to old cell}
        cell := maze[gx, gy];
        drawCell(cell);{redraw cell character}

        {change position}
        isAtIntersection(ghostDataList[counter].loc, ghostDataList[counter].direction, inters);
        if inters then
            begin
            {pick a route}
            ghostFindBestRoute(ghostDataList[counter].loc, playerLoc, ghostDataList[counter].direction, distance);
            isValidMoveDirection(ghostDataList[counter].direction, ghostDataList[counter].loc, valid);
            isNotMovingIntoGhost(ghostDataList[counter].direction, ghostDataList[counter].loc, valid2);
            if not(valid and valid2) or ghostDataList[counter].shocked then {distance > 8 then}
                {pick a random direction}
                getRandomDirection(ghostDataList[counter].loc, ghostDataList[counter].direction);
            end;

        {move the ghost}
        moveCellInDirection(ghostDataList[counter].direction, ghostDataList[counter].loc);

        {check for need to readjust}
        nextCell := maze[ghostDataList[counter].loc.x, ghostDataList[counter].loc.y];
        if nextCell = 6 then
            {let ghost use the teleport}
            teleportPlayer(ghostDataList[counter].loc.x);


        {redraw ghost}
        gx := ghostDataList[counter].loc.x;
        gy := ghostDataList[counter].loc.y;
        GoToXY(gx, gy); {move cursor to new cell}
        if ghostDataList[counter].shocked then
           {blue ghost}
           begin
           TextColor(Cyan);
           write(#241);
           end
        else
            {normal ghost}
            drawCell(7);

        end; {END moveGhost}

{spawns a dead ghost}
procedure spawnGhost(counter :integer; ghostSpawnData :_ghostSpawnData);
        begin;

        {remove old ghost char}
        GoToXY(ghostDataList[counter].loc.x, ghostDataList[counter].loc.y); {move cursor to old cell}
        TextBackground(Black);
        TextColor(White);
        write(' '); {draw blank space}
        GoToXY(1, 24); {put cursor back}

        {move ghost to spawn}
        ghostDataList[counter].loc := ghostSpawnData.spawn;

        ghostDataList[counter].shocked := false;
        if Random(2) = 0 then
            ghostDataList[counter].direction := 1
        else
            ghostDataList[counter].direction := 3;
        ghostDataList[counter].ticks := 1;
        ghostDataList[counter].alive := true;

        {draw spawned ghost}
        GoToXY(ghostDataList[counter].loc.x, ghostDataList[counter].loc.y); {move cursor to new cell}
        drawCell(7);

        end; {END spawnGhost}

{shows the player flashing, when they die or end level}
procedure flashPlayer(playerLoc :coord);

          var counter :integer;

          begin
          for counter := 1 to 4 do
              begin
              GotoXY(playerLoc.x, playerLoc.y);
              drawCell(5);
              Delay(250);
              GotoXY(playerLoc.x, playerLoc.y);
              drawCell( maze[playerLoc.x, playerLoc.y] );
              Delay(250);
              end; {end for}

          end; {END flashPlayer}

{resets the spawners and sprites to their start positions}
procedure resetSprites(var playerLoc :coord; playerSpawn :coord;
                          ghostSpawnData :_ghostSpawnData;
                          var ghostSpawnTicks, direction, nextDirection :integer);

          var counter :integer;

          begin
          playerLoc := playerSpawn;
          GotoXY(playerSpawn.x, playerSpawn.y);
          drawCell(5);
          for counter := 1 to 4 do
              begin
              if Random(2) = 0 then
                  ghostDataList[counter].direction := 1
              else
                  ghostDataList[counter].direction := 3;
              ghostDataList[counter].ticks := 1;
              ghostDataList[counter].alive := false;
              ghostDataList[counter].shocked := false;
              GotoXY(ghostDataList[counter].loc.x, ghostDataList[counter].loc.y);
              drawCell( maze[ghostDataList[counter].loc.x, ghostDataList[counter].loc.y] );
          end; {end for}
          ghostDataList[1].loc := ghostSpawnData.spawn;
          ghostDataList[2].loc := ghostSpawnData.home1;
          ghostDataList[3].loc := ghostSpawnData.home2;
          ghostDataList[4].loc := ghostSpawnData.home3;
          for counter := 1 to 4 do
              begin
              GotoXY(ghostDataList[counter].loc.x, ghostDataList[counter].loc.y);
              drawCell(7);
              end; {end for}
          ghostSpawnTicks := 999; {spawn ghost immediately}
          direction := 1;
          nextDirection := 1;

          end; {END resetSprites}

{puts all the coins back after level complete}
procedure refillCoins(var coinCount :integer);

        var xCount, yCount, cell :integer;

        begin;

        loadMaze;
        GoToXY(1, 1);
        drawMaze;
        {count coins}
        coinCount := 0;
        {loop through using linear search}
        {FOR1} for xCount := 1 to 53 do
            {FOR2} for yCount := 1 to 20 do
                begin
                cell := maze[xCount, yCount];
                if cell = 2 then {coin}
                    begin
                    coinCount += 1;
                    end; {end if}
                end; {end FOR2}

        end; {END refillCoins}

{redraws the score, lives etc}
procedure updateHUD(score, lives, level :integer);

        var digit, hs :integer;

        begin;

        {HIGH SCORE}
        {line 5, 6, 7, 8, 9}
        TextColor(White);
        hs := highscores[1].score;
        if hs > 9999 then
            begin
            digit := hs div 10000;
            GoToXY(58, 5);
            write(digit);
            hs := hs - digit * 10000;
            end;
        if hs > 999 then
            begin
            digit := hs div 1000;
            GoToXY(58, 6);
            write(digit);
            hs := hs - digit * 1000;
            end;
        if hs > 99 then
            begin
            digit := hs div 100;
            GoToXY(58, 7);
            write(digit);
            hs := hs - digit * 100;
            end;
        if hs > 9 then
            begin
            digit := hs div 10;
            GoToXY(58, 8);
            write(digit);
            hs := hs - digit * 10;
            end;
        if hs > 0 then
            write(hs);

        {GAME SCORE}
        {line 14, 15, 16, 17, 18}
        TextColor(White);
        if score > 9999 then
            begin
            digit := score div 10000;
            GoToXY(58, 14);
            write(digit);
            score := score - digit * 10000;
            end;
        if score > 999 then
            begin
            digit := score div 1000;
            GoToXY(58, 15);
            write(digit);
            score := score - digit * 1000;
            end;
        if score > 99 then
            begin
            digit := score div 100;
            GoToXY(58, 16);
            write(digit);
            score := score - digit * 100;
            end;
        if score > 9 then
            begin
            digit := score div 10;
            GoToXY(58, 17);
            write(digit);
            score := score - digit * 10;
            end;
        if score > 0 then
            write(score);

        {LEVEL}
        {line 20}
        GoToXY(59, 20);
        TextColor(LightMagenta);
        write(level);

        {LIVES}
        {line 22}
        GoToXY(58, 22);
         TextColor(Yellow);
        if lives > 0 then
            write(#2)
        else
            write(' ');
        {line 23}
        GoToXY(58, 23);
        if lives > 1 then
            write(#2)
        else
            write(' ');
        {line 24}
        GoToXY(58, 24);
        if lives > 2 then
            write(#2)
        else
            write(' ');

        end; {END updateHUD}

{get input without waiting for it}
procedure nonBlockingKeyInput(var key :char);

        var keyEvent :TKeyEvent;

        begin;

        keyEvent := PollKeyEvent;
        if not(keyEvent = 0) then
            begin
            keyEvent := GetKeyEvent;
            keyEvent := TranslateKeyEvent(keyEvent);
            key := GetKeyEventChar(keyEvent);
            end {end if}
        else
            key := '!';

        end; {END nonBlockingKeyInput}

{handle playing the game}
procedure startGame(playerSpawn, fruitSpawn :coord;
                        ghostSpawnData :_ghostSpawnData;
                        coinCount :integer; var score :integer);

        {vars}
        var key :char;
        var playerLoc :coord;
        var counter, lives, level, direction, nextDirection :integer;
        var playerTicks, fruitTicks, ghostSpawnTicks, ghostSpeed, playerSpeed :integer;
        var shockTicks, fruitCount :integer;
        var fruitSpawned, shockTimerActive, ingame :boolean;

        {start}
        begin;

        {initialise vars}
        direction := 1; {1/2/3/4 - RIGHT/DOWN/LEFT/UP - # 77/80/75/72}
        nextDirection := 1;
        playerLoc := playerSpawn;
        for counter := 1 to 4 do {set up ghost data for each ghost}
            begin
            if Random(2) = 0 then
                ghostDataList[counter].direction := 1
            else
                ghostDataList[counter].direction := 3;
            ghostDataList[counter].ticks := 1;
            ghostDataList[counter].alive := false;
            ghostDataList[counter].shocked := false;
            end; {end for}
        ghostDataList[1].loc := ghostSpawnData.spawn;
        ghostDataList[2].loc := ghostSpawnData.home1;
        ghostDataList[3].loc := ghostSpawnData.home2;
        ghostDataList[4].loc := ghostSpawnData.home3;
        score := 0;
        lives := 3;
        level := 1;
        fruitCount := 0;
        playerSpeed := 10;
        ghostSpeed := 15;
        playerTicks := 1;
        fruitTicks := 1;
        shockTicks := 1;
        ghostSpawnTicks := 999; {spawn a ghost immediately}
        ingame := true;
        fruitSpawned := false;
        shockTimerActive := false;
        InitKeyboard;
        key := '!'; {an unlikely key char that is of no use}

        {inform of pause/quit key}
        GoToXY(1, 24); {put cursor to text line}
        writeln('PRESS ESC TO PAUSE OR QUIT                    ');

        {wait 1.5 seconds before start}
        Delay(1500);

        {information text line}
        GoToXY(1, 24); {put cursor to text line}
        writeln('HACKMAN - USE WASD TO MOVE                    ');

        {loop for game & pause menu}
        {REP1} repeat
            begin
            {game clock loop}
            {REP2} repeat
                begin

                {detect key input (non-blocking)}
                nonBlockingKeyInput(key);
                if (key = 'd') or (key = 'D') then {right}
                    nextDirection := 1
                else if (key = 's') or (key = 'S') then {down}
                    nextDirection := 2
                else if (key = 'a') or (key = 'A') then {left}
                    nextDirection := 3
                else if (key = 'w') or (key = 'W') then {up}
                    nextDirection := 4

                else if key = '1' then {DEBUG - decrement lives}
                    lives -= 1
                else if key = '2' then {DEBUG - add 100 score}
                    score += 100;

                {spawn fruit}
                if fruitTicks >= 2000 then    {wait 2000 ticks (20 secs) between spawning fruit}
                    begin

                    {only spawn the fruit 4 times per level}
                    if fruitCount < 5 then
                        begin
                        fruitCount += 1;

                        {put the fruit into the maze}
                        maze[fruitSpawn.x, fruitSpawn.y] := 3;
                        
                        {draw the fruit to screen}
                        GoToXY(fruitSpawn.x, fruitSpawn.y);
                        drawCell(3);
                        GoToXY(1, 24); {put cursor back}

                        end;

                    {reset the fruit spawner and pause until captured}
                    fruitTicks := 1;
                    fruitSpawned := true;

                    end; {end if}

                {deshockify ghosts}
                if shockTicks >= 800 then    {wait 800 ticks (8 secs) before deshockifying ghosts}
                    begin

                    {for each ghost}
                    for counter := 1 to 4 do
                        ghostDataList[counter].shocked := false;

                    {reset the timer}
                    shockTicks := 1;
                    shockTimerActive := false;

                    end; {end if}

                {move player}
                if (((direction = 1) or (direction = 3)) and (playerTicks >= playerSpeed)) or          {wait 10 ticks (100ms) for left/right}
                        (((direction = 2) or (direction = 4)) and (playerTicks >= (playerSpeed * 2))) then     {wait 20 ticks (200ms) for up/down}
                    begin
                    movePlayer(playerLoc, nextDirection, direction, score, coinCount, shockTicks, fruitSpawned, shockTimerActive);
                    playerTicks := 1;
                    end; {end if}
                GoToXY(1, 24); {put cursor back}

                {move ghosts}
                for counter := 1 to 4 do {for each ghost}
                    begin
                    {if ghost is alive}
                    {IF1} if ghostDataList[counter].alive then
                        {if ticks have passed, axis dependant}
                        {IF2} if (((ghostDataList[counter].direction = 1) or (ghostDataList[counter].direction = 3)) and (ghostDataList[counter].ticks >= ghostSpeed)) or          {wait 15 ticks (150ms) for left/right}
                                (((ghostDataList[counter].direction = 2) or (ghostDataList[counter].direction = 4)) and (ghostDataList[counter].ticks >= (ghostSpeed * 2))) then     {wait 25 ticks (250ms) for up/down}
                            begin
                            moveGhost(counter, playerLoc);
                            {reset ghost move ticks}
                            ghostDataList[counter].ticks := 1;
                            end; {end IF2}
                    end; {end for}
                GoToXY(1, 24); {put cursor back}

                {spawn ghosts}
                if ghostSpawnTicks >= 200 then    {wait 200 ticks (2 secs) between spawning ghosts}
                    begin

                    {for each ghost}
                    for counter := 1 to 4 do
                        if ghostDataList[counter].alive = false then
                            begin
                            spawnGhost(counter, ghostSpawnData);
                            break;
                            end; {end if}

                    {reset the ghost spawner}
                    ghostSpawnTicks := 1;

                    end; {end if}

                {handle ghost hitting player}
                for counter := 1 to 4 do {for each ghost}
                    begin

                    {IF1} if (ghostDataList[counter].loc.x = playerLoc.x) and
                           (ghostDataList[counter].loc.y = playerLoc.y) and
                           ghostDataList[counter].alive then
                       begin

                       {IF2} if not(ghostDataList[counter].shocked) then
                           begin
                           {standard, kill player}
                           flashPlayer(playerLoc);
                           resetSprites(playerLoc, playerSpawn, ghostSpawnData,
                                         ghostSpawnTicks, direction, nextDirection);
                           lives -= 1;
                           GoToXY(1, 24); {put cursor back}
                           break;
                           end {end IF2}
                       else
                           begin
                           {powerup in use, eat ghost}
                           flashPlayer(playerLoc);
                           score += 200;
                           ghostDataList[counter].alive := false;
                           end; {end else}

                       end; {end IF1}
                   end; {end for}

                {check for a level complete}
                if coinCount < 1 then
                    begin
                    writeln('LEVEL COMPLETE                                ');
                    flashPlayer(playerLoc);
                    resetSprites(playerLoc, playerSpawn, ghostSpawnData,
                                    ghostSpawnTicks, direction, nextDirection);
                    refillCoins(coinCount);
                    level += 1;
                    fruitCount := 0;
                    playerSpeed := (playerSpeed * 10) div 11;
                    ghostSpeed := (ghostSpeed * 10) div 13;
                    GoToXY(1, 24); {put cursor back}
                    end; {end if}

                {update HUD}
                TextColor(White);
                TextBackground(Black);
                updateHUD(score, lives, level);
                GoToXY(1, 24); {put cursor back}

                {check for a game over}
                if lives < 1 then
                    begin
                    ingame := false;
                    break; {skip pause menu}
                    end; {end if}

                {handle clock timer (a 'tick' lasts 10ms)}
                Delay(10);
                playerTicks += 1;
                ghostSpawnTicks += 1;
                for counter := 1 to 4 do
                    ghostDataList[counter].ticks += 1;
                if not(fruitSpawned) then
                    fruitTicks += 1;
                if shockTimerActive then
                    shockTicks += 1;

                end; {end REP2}
            until key = #27; {until REP2} {esc pushed}

            {pause game}
            if key = #27 then
                begin
                TextColor(Yellow);
                write('GAME PAUSED: ');
                TextColor(Cyan);
                write('Q');
                TextColor(White);
                write(' = QUIT, ');
                TextColor(Cyan);
                write('ANY OTHER KEY');
                TextColor(White);
                write(' = RESUME  ');
                GoToXY(1, 24); {put cursor back}
                key := '!';
                repeat
                    nonBlockingKeyInput(key)
                until not(key = '!');
                if (key = 'q') or (key = 'Q') then
                   ingame := false;
                writeln('                                              ');
                end; {end if}

            end; {end REP1}
        until ingame = false; {until REP1}

        end; {END startGame}


{ALL}

{do it all}
procedure all;

        {vars}
        var coinCount, menuOption, score :integer;
        var inMainMenu :boolean;
        var ghostSpawnData :_ghostSpawnData;
        var playerSpawn, fruitSpawn  :coord;

        begin;
        {code}

        {initialise random, so it returns a different sequence each time}
        Randomize;

        {load the highscores}
        loadHighscores;

        {repeat gaming forever - return to start menu after game ends}
        while true do
            begin

            {main menu}
            inMainMenu := true;
            menuOption := 1;
            CursorOff; {hide cursor}
            drawMainMenuTitle;
            menuOption := 1;
            drawMenuOptions(menuOption);
            while inMainMenu do
                handleMenuInput(inMainMenu, menuOption);

            ClrScr; {clear the screen}

            {setup and start game}
            loadMaze;
            findSpriteLocations(playerSpawn, fruitSpawn, ghostSpawnData, coinCount);
            maze[fruitSpawn.x, fruitSpawn.y] := 0; {take the fruit out of maze, it will spawn in}
            drawMaze;
            drawHUD;
            maze[playerSpawn.x, playerSpawn.y] := 0; {take the player out of maze, they will spawn in}
            startGame(playerSpawn, fruitSpawn, ghostSpawnData, coinCount, score);

            ClrScr; {hide cursor}
            DoneKeyboard; {disable keyboard module, enable readkey again}

            {do highscores}
            handleFinalScore(score);
            saveHighscores;
            showHighscores;

            end; {end while}

        end; {END all}

begin; {beginning of the end}
all; {do all}
end. {END program}


