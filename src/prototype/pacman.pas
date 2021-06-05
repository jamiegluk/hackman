program pacman;
{Jamie Lievesley 04 Sep 2012}
{Pacman Test}

uses crt, keyboard;

{put global vars here, should only be arrays}
var
map :array[1..53, 1..23] of integer; {char/line or x/y or column/row}


{SETUP THE GAME}

procedure compileMapLine(line :string; lineNumber :integer);
          {changes text into int for 2D array of integers}
          {vars}
          var
          charCounter :integer;
          character :char;
          begin;
          {loop through each item}
          for charCounter := 1 to 53 do
              begin
              character := line[charCounter];
              case character of
                   '.' : map[charCounter, lineNumber] := 0; {empty space}
                   ' ' : map[charCounter, lineNumber] := 0; {empty space, again}
                   'X' : map[charCounter, lineNumber] := 1; {wall}
                   '*' : map[charCounter, lineNumber] := 2; {coin}
                   '?' : map[charCounter, lineNumber] := 3; {fruit}
                   '@' : map[charCounter, lineNumber] := 4; {powerup}
                   'P' : map[charCounter, lineNumber] := 5; {player start}
                   'T' : map[charCounter, lineNumber] := 6; {teleport}
                   'G' : map[charCounter, lineNumber] := 7; {ghost home}
                   'g' : map[charCounter, lineNumber] := 8; {ghost spawn}
                   'H' : map[charCounter, lineNumber] := 9; {ghost door}
                   else map[charCounter, lineNumber] := 0; {invalid character}
                   end;
              end;
          end; {END compileMapLine}

procedure loadMap;
          {load the text containing the map from file}
          {vars}
          var
          mapFile :text;
          filename, line :string;
          linenumber :integer;
          {start}
          begin;
          {assign filename to text}
          filename := 'map.txt';
          assignfile(mapFile, filename);
          reset(mapfile);
          lineNumber := 1;
          while not(eof(mapFile)) and (lineNumber <= 23) do
                begin
                readln(mapFile, line);
                compileMapLine(line, lineNumber);
                lineNumber := lineNumber + 1;
                end;
          closefile(mapFile)
          end; {END loadMap}

procedure drawMap;
          {displays the map on screen}
          {vars}
          var
		  columnCounter, rowCounter, cell :integer;
          begin;
          {loop through each item}
          for rowCounter := 1 to 23 do
                begin
		        for columnCounter := 1 to 53 do
		              begin;
				      cell := map[columnCounter, rowCounter];
                      TextColor(White);
                      TextBackground(Black);
				      if cell = 0 then {empty space}
                            begin
                            write(' ');
                            end
					  else if cell = 1 then {wall}
                            begin
                            TextBackground(Cyan);
                            write(' ');
                            end
					  else if cell = 2 then {coin}
                            begin
                            TextColor(White);
                            write(#111);
                            end
					  else if cell = 3 then {fruit}
                            begin
                            TextColor(Red);
                            write(#162);
                            end
                      else if cell = 4 then {powerup}
                            begin
                            TextColor(Green);
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
                            TextBackground(Brown);
                            write(#1);
                            end
                      else if cell = 8 then {ghost spawn}
                            begin
                            TextBackground(Red);
                            write(#1);
                            end
                      else if cell = 9 then {ghost door}
                            begin
                            TextBackground(Magenta);
                            write(' ');
                            end;
				      end;
                writeln; {end of row}
                end
          end; {END drawMap}

procedure findSpriteLocations(var playerSpawnX, playerSpawnY, ghostHome1X,
                                    ghostHome1Y, ghostHome2X, ghostHome2Y,
                                    ghostHome3X, ghostHome3Y, ghostSpawnX,
                                    ghostSpawnY, fruitX, fruitY,
                                    coinCount :integer);
          {finds the player and ghost spawns in the map}
          {vars}
          var
          xCount, yCount, cell , ghostHomesFound, powerUpsFound :integer;
          {start}
          begin;
          ghostHomesFound := 0;
          powerUpsFound := 0;
          coinCount := 0;
          {loop through using linear search}
          for xCount := 1 to 53 do
              for yCount := 1 to 20 do
                  begin
                  cell := map[xCount, yCount];
                  if cell = 5 then {player spawn}
                     begin
                     playerSpawnX := xCount;
                     playerSpawnY := yCount;
                     end
                  else if cell = 8 then {ghost spawn}
                     begin
                     ghostSpawnX := xCount;
                     ghostSpawnY := yCount;
                     end
                  else if cell = 3 then {fruit}
                     begin
                     fruitX := xCount;
                     fruitY := yCount;
                     end
                  else if cell = 2 then {coin}
                     coinCount := coinCount + 1
                  else if cell = 7 then {a ghost home - 1 of 3}
                     begin
                     if ghostHomesFound = 0 then
                        begin
                        ghostHome1X := xCount;
                        ghostHome1Y := yCount;
                        end
                     else if ghostHomesFound = 1 then
                        begin
                        ghostHome2X := xCount;
                        ghostHome2Y := yCount;
                        end
                     else if ghostHomesFound = 2 then
                        begin
                        ghostHome3X := xCount;
                        ghostHome3Y := yCount;
                        end;
                     ghostHomesFound := ghostHomesFound + 1;
                     end;
                  end;
          end; {END findSpriteLocations}


{PLAY GAME}

procedure teleportPlayer(var newX :integer);
          {teleports the player to other side}
          {can only be done horizontally on very edge}
          {will always teleprt to opposite edge at same Y coord only}
          {start}
          begin;
          if newX = 1 then
             newX := 53
          else if newX = 53 then
             newX := 1;
          end; {END teleportPlayer}

procedure movePlayer(var playerX, playerY, direction, oldDirection,
                         nextDirection, score, coinCount :integer);
           forward;

procedure readjustForThreeWide(newX, newY, oldDirection :integer; var direction, nextDirection :integer);
          {where columns are three wide only the middle one can be used}
          {if coordinates are not centre, then signal to move on next tick}
          begin;
          if (map[newX - 1, newY] = 1) and (map[newX + 3, newY] = 1) and (map[newX, newY] = 0) then
               {too far to the left}
               begin
               nextDirection := direction;
               direction := oldDirection;
               end
          else if (map[newX + 1, newY] = 1) and (map[newX - 3, newY] = 1) and (map[newX, newY] = 0) then
               {too far to the right}
               begin
               nextDirection := direction;
               direction := oldDirection;
               end
          end; {END readjustForThreeWide}

procedure readjustForThreeWide2(var newX, newY, direction, oldDirection :integer);
          {where columns are three wide only the middle one can be used}
          {if coordinates are not centre, then move player to centre}
          begin;
          if (map[newX - 1, newY] = 1) and (map[newX, newY] = 0) then
               {too far to the left}
               begin
               newX := newX + 1;
               if (direction = 1) or (direction = 3) then
                  direction := oldDirection;
               end
          else if (map[newX + 1, newY] = 1) and (map[newX, newY] = 0) then
               {too far to the right}
               begin
               newX := newX - 1;
               if (direction = 1) or (direction = 3) then
                  direction := oldDirection;
               end;
          end; {END readjustForThreeWide2}

procedure movePlayer(var playerX, playerY, direction, oldDirection,
                         nextDirection, score, coinCount :integer);
          {moves the player in the specified direction}
          {vars}
          var
          newX, newY, cell :integer;
          {start}
          begin;

          {get new coordinates}
          newX := playerX;
          newY := playerY;
          case direction of
               1 : newX := playerX + 1;
               2 : newY := playerY + 1;
               3 : newX := playerX - 1;
               4 : newY := playerY - 1;
               end;

           {fix for 3 wide empty space columns whengoing up or down}
           {if (direction = 2) or (direction = 4) then
              begin
              readjustForThreeWide(playerX, playerY, oldDirection, direction, nextDirection);
              if not(nextDirection = -1) then
                 case direction of
                      1 : newX := playerX + 1;
                      2 : newY := playerY + 1;
                      3 : newX := playerX - 1;
                      4 : newY := playerY - 1;
                      end;
              end;}
           readjustForThreeWide2(newX, newY, direction, oldDirection);

          {check for obstacles}
          cell := map[newX, newY];
          case cell of
               1 : begin {wall, continue in old direction, use old coords}
                   direction := oldDirection;
                   newX := playerX;
                   newY := playerY;
                   end;
               9 : begin {ghost door, continue in old direction, use old coords}
                   direction := oldDirection;
                   newX := playerX;
                   newY := playerY;
                   end;
               3 : writeln('GOT FRUIT                '); {TEMP} {capture fruit}
               4 : writeln('GOT POWERUP              '); {TEMP} {capture powerup}
               6 : teleportPlayer(newX); {teleport to other side}
               end;

          {redraw player}
          map[playerX, playerY] := 0; {replace cell with empty space}
          GoToXY(playerX + 1, playerY); {move cursor 1 in front of old cell}
          write(#8); {erase last character}
          TextBackground(Black);
          TextColor(White);
          write(' '); {draw blank space}
          GoToXY(newX + 1, newY); {move cursor 1 in front of new cell}
          write(#8); {erase last character}
          TextColor(Yellow);
          write(#2); {draw player}

          {move cursor so it doesn't blink and annoy}
          GoToXY(1, 24);

          {set up new player coords}
          playerX := newX;
          playerY := newY;

          end; {END movePlayer}

procedure nonBlockingKeyInput(var key :char);
          {get input without waiting for it}
          {vars}
          var
          keyEvent :TKeyEvent;
          {start}
          begin;
          keyEvent := PollKeyEvent;
          if not(keyEvent = 0) then
             begin
             keyEvent := GetKeyEvent;
             keyEvent := TranslateKeyEvent(keyEvent);
             key := GetKeyEventChar(keyEvent);
             end
          else
              key := ' ';
          end; {END nonBlockingKeyInput}

procedure waitForSpaceKeyInput;
          {wait for space bar}
          var
          keyEvent :TKeyEvent;
          {start}
          begin;
          repeat
                keyEvent := GetKeyEvent;
                keyEvent := TranslateKeyEvent(keyEvent);
          until GetKeyEventChar(keyEvent) = ' ';
          end; {END waitForSpaceKeyKeyInput}

procedure startGame(var playerSpawnX, playerSpawnY, ghostHome1X,
                                    ghostHome1Y, ghostHome2X, ghostHome2Y,
                                    ghostHome3X, ghostHome3Y, ghostSpawnX,
                                    ghostSpawnY, fruitX, fruitY,
                                    coinCount :integer);
          {handle playing the game}
          {vars}
          var
          key :char;
          direction, playerX, playerY, ghost1X, ghost1Y, ghost2X :integer;
          ghost2Y, ghost3X, ghost3Y, ghost4X, ghost4Y, oldDirection :integer;
          score, nextDirection :integer;
          {start}
          begin;

          {initialise vars}
          direction := 1; {1/2/3/4 - RIGHT/DOWN/LEFT/UP - # 77/80/75/72}
          playerX := playerSpawnX;
          playerY := playerSpawnY;
          ghost1X := ghostSpawnX;
          ghost1Y := ghostSpawnX;
          ghost2X := ghostHome1X;
          ghost2Y := ghostHome1X;
          ghost3X := ghostHome2X;
          ghost3Y := ghostHome2X;
          ghost4X := ghostHome3X;
          ghost4Y := ghostHome3X;
          score := 0;
          key := ' ';
          nextDirection := -1;
          InitKeyboard;
          CursorOff;

          {wait for space}
          writeln('PUSH SPACEBAR TO START   ');
          waitForSpaceKeyInput();
          GoToXY(1, 24);
          writeln('                         ');

          repeat
                {if next direction is set then apply to current direction}
                if not(nextDirection = -1) then
                   begin
                   direction := nextDirection;
                   nextDirection := -1;
                   end
                else
                    begin
                    {detect key input}
                    nonBlockingKeyInput(key);
                    if (key = 'd') then {right}
                       direction := 1
                    else if (key = 's') then {down}
                       direction := 2
                    else if (key = 'a') then {left}
                       direction := 3
                    else if (key = 'w') then {up}
                       direction := 4;
                    end;

                {move player}
                movePlayer(playerX, playerY, direction, oldDirection,
                           nextDirection, score, coinCount);
                oldDirection := direction;
                Sound(10);

                {wait for a suitable time dependant on which axis}
                if(direction = 1) or (direction = 3) then
                    Delay(100)
                else
                    Delay(200);

          until key = #27 {esc pushed}
          end; {END startGame}


{ALL}

procedure all;
          {do it all}
          {vars}
          var
          playerSpawnX, playerSpawnY, ghostHome1X, ghostHome1Y :integer;
          ghostHome2X, ghostHome2Y, ghostHome3X, ghostHome3Y :integer;
          ghostSpawnX, ghostSpawnY, fruitX, fruitY, coinCount :integer;
          begin;
          {procedures}
          loadMap;
          drawMap;
          findSpriteLocations(playerSpawnX, playerSpawnY, ghostHome1X,
                                      ghostHome1Y, ghostHome2X, ghostHome2Y,
                                      ghostHome3X, ghostHome3Y, ghostSpawnX,
                                      ghostSpawnY, fruitX, fruitY, coinCount);
          startGame(playerSpawnX, playerSpawnY, ghostHome1X, ghostHome1Y,
                          ghostHome2X, ghostHome2Y, ghostHome3X, ghostHome3Y,
                          ghostSpawnX, ghostSpawnY, fruitX, fruitY, coinCount);
          {wait for user to close}
          readln;
          end; {END all}

begin;
all;
end.


