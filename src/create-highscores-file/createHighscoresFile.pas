program createHighscoresFile;
{Jamie Lievesley 04 Jan 2012}
{HackMan Project - Create Original Highscores File}

{Define records here}
type
    {Single highscore}
    highscoreRecord =
        record
            name :string;
            score :integer;
        end; {END highscoreRecord}

{Put global vars here, should only be arrays}
var scores :array[1..10] of highscoreRecord; {all highscores}


{put the default scores and names into the array}
procedure fillArray;
        begin;

        scores[1].name := 'WIN';
        scores[1].score := 99990;
        scores[2].name := 'BOS';
        scores[2].score := 90000;
        scores[3].name := 'ACE';
        scores[3].score := 55000;
        scores[4].name := 'NOM';
        scores[4].score := 30000;
        scores[5].name := 'BOB';
        scores[5].score := 15000;
        scores[6].name := 'AMY';
        scores[6].score := 10000;
        scores[7].name := 'JIM';
        scores[7].score := 07000;
        scores[8].name := 'MAX';
        scores[8].score := 03000;
        scores[9].name := 'SAL';
        scores[9].score := 01000;
        scores[10].name := 'BAD';
        scores[10].score := 00500;

        end; {END fillArray}

{writes the scores array to file}
procedure writeFile;

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
            writeln(hsFile, scores[counter].name);
            writeln(hsFile, scores[counter].score);
            end;
        closefile(hsFile)

        end; {END writeFile}


{ALL}

{do it all}
procedure all;
        begin;
        fillArray;
        writeFile;
        writeln('DONE');
        readln;
        end; {END all}

begin; {beginning of the end}
all; {do all}
end. {END program}


