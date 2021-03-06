/*
 UP : 56 -- 1
 RIGHT : 248 -- 2
 DOWN : 88 -- 4
 LEFT : 104 -- 8
 ENTER : 112
 */
parallelput (0)
%setscreen ("graphics:max;max,nobuttonbar,noecho,nocursor")
%setscreen ("graphics:628,413,nobuttonbar,noecho,nocursor")

%Windows
var scoreWindow : int := Window.Open ("noecho,nocursor") % hidden window to delay score count
var mainWindow : int := Window.Open ("graphics:628;413,nobuttonbar,noecho,nocursor,position:center,center,title:SIMON (v1.5.7) - Adam|Dante") % main window
Window.Hide (scoreWindow) %immediately hides scorecalc window
Window.Select (mainWindow) % selects main window

% Scale Variables - Scale the size of boxes and other things per max screen dimensions
var scaleX, scaleY : int
scaleX := maxx div 4
scaleY := maxy div 4

% Font Variables - Size must be revised per max screen dimensions
var simonFont : int := Font.New ("AnyMale:26")
var infoText : int := Font.New ("Arial:15")
var levelText : int := Font.New ("AnyMale:30")
var top10Text : int := Font.New ("Arial:10")
var top10Bold : int := Font.New ("Arial:10:bold")
var instructionText : int := Font.New ("Arial:20")
var titleText : int := Font.New ("Budmo Jiggler:82:bold")
var storedText : array 1 .. 26 of string
var textWidth : array 1 .. 26 of int

% Game Variables
var Level : int := 1                                        % stores level
var score : int := 0                                        % stores players score
var numCombo : int := Level + 2                             % stores amount of lights to be i nthe combination
var combination, userCombo : array 1 .. numCombo of int     % stores created combination and user inputs # based
var input : array char of boolean                           % stores keyboard input
var parget : int                                            % stores button input
var menuSelect : int := 1                                   % stores selected Menu item
var top10scores : array 1 .. 10 of int                      % stores top 10 scores
var top10names : array 1 .. 10 of string
var scan : int
var seKret : array 1 .. 8 of int
var konami, konamitrue : boolean := false
var menu1, menu2, menu3, menu4 : int := 0

%onscreen keyboard variables
var nameFont : int := Font.New ("Arial:15") % font
var keyboardHoriz : int := 5 % stores horizontal position
var keyboardVerti : int := 2 % stores vertical position
var gitName : array 1 .. 4 of string (1) % stores 4 characters of the name
var letterNumber : int := 0 % stores which letter is being entered
var confirmName : boolean := false % stores if name is confirmed or not

% Text in arrays, all is stored here
storedText (1) := "Enter your name:"
textWidth (1) := Font.Width (storedText (1), top10Text)
storedText (2) := "SIMON"
textWidth (2) := Font.Width (storedText (2), simonFont)
storedText (3) := "Score: 0"
textWidth (3) := Font.Width (storedText (3), infoText)
storedText (4) := "Level 1"
textWidth (4) := Font.Width (storedText (4), infoText)
storedText (5) := "Remember the colours that light up, then"
textWidth (5) := Font.Width (storedText (5), instructionText)
storedText (6) := "repeat those colours using the correct buttons!"
textWidth (6) := Font.Width (storedText (6), instructionText)
storedText (7) := "You'll have a chance to retry each level once"
textWidth (7) := Font.Width (storedText (7), infoText)
storedText (8) := "at a cost, but after that it's Game Over!"
textWidth (8) := Font.Width (storedText (8), infoText)
storedText (9) := "YOUR"
textWidth (9) := Font.Width (storedText (9), simonFont)
storedText (10) := "TURN"
textWidth (10) := Font.Width (storedText (10), simonFont)
storedText (11) := "Backspace"
textWidth (11) := Font.Width (storedText (11), nameFont)
storedText (12) := "Confirm"
textWidth (12) := Font.Width (storedText (12), instructionText)
storedText (13) := "TOP 10"
textWidth (13) := Font.Width (storedText (13), simonFont)
% 14 reserved for drawing temp name on screen during name select
storedText (15) := "Your final score was:"
textWidth (15) := Font.Width (storedText (15), infoText)
% 16 reserved for score display after game
storedText (17) := "Do you want to try again?"
textWidth (17) := Font.Width (storedText (17), infoText)
storedText (18) := "You got it wrong!"
textWidth (18) := Font.Width (storedText (18), infoText)
storedText (19) := "(You will lose 1000 points)"
textWidth (19) := Font.Width (storedText (19), top10Text)
storedText (20) := "Do you want to exit?"
textWidth (20) := Font.Width (storedText (20), infoText)
storedText (21) := "SIMON"
textWidth (21) := Font.Width (storedText (21), titleText)
storedText (22) := "Play"
textWidth (22) := Font.Width (storedText (22), levelText)
storedText (23) := "Leaderboard"
textWidth (23) := Font.Width (storedText (23), levelText)
storedText (24) := "Instructions"
textWidth (24) := Font.Width (storedText (24), levelText)
storedText (25) := "Exit"
textWidth (25) := Font.Width (storedText (25), levelText)
storedText (26) := "Yo gl ur on ur own"
textWidth (26) := Font.Width (storedText (26), instructionText)

proc resetNames % procedure to reset the variables used in entering name

    for storeBlank : 1 .. 4 % resets 4 chars
	gitName (storeBlank) := ""
    end for

    % resets other variables
    letterNumber := 0
    keyboardHoriz := 5
    keyboardVerti := 2
    confirmName := false

end resetNames

proc letterSelect (sel : int) % procedure used to select, is called when user hits enter/select. Selects based on currect x/y positioning on keyboard

    if keyboardVerti = 1 then

	if keyboardHoriz = 1 then
	    gitName (sel) := "A"
	elsif keyboardHoriz = 2 then
	    gitName (sel) := "B"
	elsif keyboardHoriz = 3 then
	    gitName (sel) := "C"
	elsif keyboardHoriz = 4 then
	    gitName (sel) := "D"
	elsif keyboardHoriz = 5 then
	    gitName (sel) := "E"
	elsif keyboardHoriz = 6 then
	    gitName (sel) := "F"
	elsif keyboardHoriz = 7 then
	    gitName (sel) := "G"
	elsif keyboardHoriz = 8 then
	    gitName (sel) := "H"
	elsif keyboardHoriz = 9 then
	    gitName (sel) := "I"
	elsif keyboardHoriz = 10 then
	    gitName (sel) := "J"
	end if

    elsif keyboardVerti = 2 then

	if keyboardHoriz = 1 then
	    gitName (sel) := "K"
	elsif keyboardHoriz = 2 then
	    gitName (sel) := "L"
	elsif keyboardHoriz = 3 then
	    gitName (sel) := "M"
	elsif keyboardHoriz = 4 then
	    gitName (sel) := "N"
	elsif keyboardHoriz = 5 then
	    gitName (sel) := "O"
	elsif keyboardHoriz = 6 then
	    gitName (sel) := "P"
	elsif keyboardHoriz = 7 then
	    gitName (sel) := "Q"
	elsif keyboardHoriz = 8 then
	    gitName (sel) := "R"
	elsif keyboardHoriz = 9 then
	    gitName (sel) := "S"
	elsif keyboardHoriz = 10 then
	    gitName (sel) := "T"
	end if

    elsif keyboardVerti = 3 then

	if keyboardHoriz = 1 then
	    gitName (sel) := "U"
	elsif keyboardHoriz = 2 then
	    gitName (sel) := "V"
	elsif keyboardHoriz = 3 then
	    gitName (sel) := "W"
	elsif keyboardHoriz = 4 then
	    gitName (sel) := "X"
	elsif keyboardHoriz = 5 then
	    gitName (sel) := "Y"
	elsif keyboardHoriz = 6 then
	    gitName (sel) := "Z"
	elsif keyboardHoriz = 7 then
	    gitName (sel) := "_"
	elsif keyboardHoriz = 8 then
	    gitName (sel) := "~"
	elsif keyboardHoriz = 9 then
	    gitName (sel) := "|"
	elsif keyboardHoriz = 10 then
	    gitName (sel) := "!"
	end if

    elsif keyboardVerti = 4 then

	if keyboardHoriz = 1 then
	    gitName (sel) := "1"
	elsif keyboardHoriz = 2 then
	    gitName (sel) := "2"
	elsif keyboardHoriz = 3 then
	    gitName (sel) := "3"
	elsif keyboardHoriz = 4 then
	    gitName (sel) := "4"
	elsif keyboardHoriz = 5 then
	    gitName (sel) := "5"
	elsif keyboardHoriz = 6 then
	    gitName (sel) := "6"
	elsif keyboardHoriz = 7 then
	    gitName (sel) := "7"
	elsif keyboardHoriz = 8 then
	    gitName (sel) := "8"
	elsif keyboardHoriz = 9 then
	    gitName (sel) := "9"
	elsif keyboardHoriz = 10 then
	    gitName (sel) := "0"
	end if

    elsif keyboardVerti = 5 then % backspace, sets last value to empty and selects the last position
	gitName (sel - 1) := ""
	letterNumber := letterNumber - 2
    elsif keyboardVerti = 6 then % enter, sets confirm to true
	confirmName := true
    end if

    drawfillbox (0, 0, maxx, maxy, black)
    storedText (14) := gitName (1) + gitName (2) + gitName (3) + gitName (4)
    textWidth (14) := Font.Width (gitName (1) + gitName (2) + gitName (3) + gitName (4), simonFont)
    Draw.Text (storedText (14), maxx div 2 - textWidth (14) div 2, 300, simonFont, white) % draws current name on screen
    drawbox (maxx div 2 - textWidth (14) div 2 - 4, 290, maxx div 2 + textWidth (14) div 2 + 4, 330, white)

end letterSelect

proc drawNames % draws all the letters

    Draw.Text (storedText (1), maxx div 2 - textWidth (1) div 2, maxy - 30, top10Text, white) %asks user for their name and updates it into the leaderboard

    var x1 : int := 84
    var x2 : int := 134
    var x3 : int := 184
    var x4 : int := 234
    var x5 : int := 284
    var x6 : int := 334
    var x7 : int := 384
    var x8 : int := 434
    var x9 : int := 484
    var x10 : int := 534
    var y1 : int := 260
    var y2 : int := 220
    var y3 : int := 180
    var y4 : int := 140
    var y5 : int := 100
    var y6 : int := 60

    Draw.Text ("A", x1, y1, nameFont, white)
    Draw.Text ("B", x2, y1, nameFont, white)
    Draw.Text ("C", x3, y1, nameFont, white)
    Draw.Text ("D", x4, y1, nameFont, white)
    Draw.Text ("E", x5, y1, nameFont, white)
    Draw.Text ("F", x6, y1, nameFont, white)
    Draw.Text ("G", x7, y1, nameFont, white)
    Draw.Text ("H", x8, y1, nameFont, white)
    Draw.Text ("I", x9, y1, nameFont, white)
    Draw.Text ("J", x10, y1, nameFont, white)

    Draw.Text ("K", x1, y2, nameFont, white)
    Draw.Text ("L", x2, y2, nameFont, white)
    Draw.Text ("M", x3, y2, nameFont, white)
    Draw.Text ("N", x4, y2, nameFont, white)
    Draw.Text ("O", x5, y2, nameFont, white)
    Draw.Text ("P", x6, y2, nameFont, white)
    Draw.Text ("Q", x7, y2, nameFont, white)
    Draw.Text ("R", x8, y2, nameFont, white)
    Draw.Text ("S", x9, y2, nameFont, white)
    Draw.Text ("T", x10, y2, nameFont, white)

    Draw.Text ("U", x1, y3, nameFont, white)
    Draw.Text ("V", x2, y3, nameFont, white)
    Draw.Text ("W", x3, y3, nameFont, white)
    Draw.Text ("X", x4, y3, nameFont, white)
    Draw.Text ("Y", x5, y3, nameFont, white)
    Draw.Text ("Z", x6, y3, nameFont, white)
    Draw.Text ("_", x7, y3, nameFont, white)
    Draw.Text ("~", x8, y3, nameFont, white)
    Draw.Text ("|", x9, y3, nameFont, white)
    Draw.Text ("!", x10, y3, nameFont, white)

    Draw.Text ("1", x1, y4, nameFont, white)
    Draw.Text ("2", x2, y4, nameFont, white)
    Draw.Text ("3", x3, y4, nameFont, white)
    Draw.Text ("4", x4, y4, nameFont, white)
    Draw.Text ("5", x5, y4, nameFont, white)
    Draw.Text ("6", x6, y4, nameFont, white)
    Draw.Text ("7", x7, y4, nameFont, white)
    Draw.Text ("8", x8, y4, nameFont, white)
    Draw.Text ("9", x9, y4, nameFont, white)
    Draw.Text ("0", x10, y4, nameFont, white)

    Draw.Text (storedText (11), maxx div 2 - textWidth (11) div 2, y5, nameFont, white)

    Draw.Text (storedText (12), maxx div 2 - textWidth (12) div 2, y6, instructionText, white)

    % draws selected letter
    if keyboardVerti = 1 then

	if keyboardHoriz = 1 then
	    Draw.Text ("A", x1, y1, nameFont, brightblue)
	elsif keyboardHoriz = 2 then
	    Draw.Text ("B", x2, y1, nameFont, brightblue)
	elsif keyboardHoriz = 3 then
	    Draw.Text ("C", x3, y1, nameFont, brightblue)
	elsif keyboardHoriz = 4 then
	    Draw.Text ("D", x4, y1, nameFont, brightblue)
	elsif keyboardHoriz = 5 then
	    Draw.Text ("E", x5, y1, nameFont, brightblue)
	elsif keyboardHoriz = 6 then
	    Draw.Text ("F", x6, y1, nameFont, brightblue)
	elsif keyboardHoriz = 7 then
	    Draw.Text ("G", x7, y1, nameFont, brightblue)
	elsif keyboardHoriz = 8 then
	    Draw.Text ("H", x8, y1, nameFont, brightblue)
	elsif keyboardHoriz = 9 then
	    Draw.Text ("I", x9, y1, nameFont, brightblue)
	elsif keyboardHoriz = 10 then
	    Draw.Text ("J", x10, y1, nameFont, brightblue)
	end if

    elsif keyboardVerti = 2 then

	if keyboardHoriz = 1 then
	    Draw.Text ("K", x1, y2, nameFont, brightblue)
	elsif keyboardHoriz = 2 then
	    Draw.Text ("L", x2, y2, nameFont, brightblue)
	elsif keyboardHoriz = 3 then
	    Draw.Text ("M", x3, y2, nameFont, brightblue)
	elsif keyboardHoriz = 4 then
	    Draw.Text ("N", x4, y2, nameFont, brightblue)
	elsif keyboardHoriz = 5 then
	    Draw.Text ("O", x5, y2, nameFont, brightblue)
	elsif keyboardHoriz = 6 then
	    Draw.Text ("P", x6, y2, nameFont, brightblue)
	elsif keyboardHoriz = 7 then
	    Draw.Text ("Q", x7, y2, nameFont, brightblue)
	elsif keyboardHoriz = 8 then
	    Draw.Text ("R", x8, y2, nameFont, brightblue)
	elsif keyboardHoriz = 9 then
	    Draw.Text ("S", x9, y2, nameFont, brightblue)
	elsif keyboardHoriz = 10 then
	    Draw.Text ("T", x10, y2, nameFont, brightblue)
	end if

    elsif keyboardVerti = 3 then

	if keyboardHoriz = 1 then
	    Draw.Text ("U", x1, y3, nameFont, brightblue)
	elsif keyboardHoriz = 2 then
	    Draw.Text ("V", x2, y3, nameFont, brightblue)
	elsif keyboardHoriz = 3 then
	    Draw.Text ("W", x3, y3, nameFont, brightblue)
	elsif keyboardHoriz = 4 then
	    Draw.Text ("X", x4, y3, nameFont, brightblue)
	elsif keyboardHoriz = 5 then
	    Draw.Text ("Y", x5, y3, nameFont, brightblue)
	elsif keyboardHoriz = 6 then
	    Draw.Text ("Z", x6, y3, nameFont, brightblue)
	elsif keyboardHoriz = 7 then
	    Draw.Text ("_", x7, y3, nameFont, brightblue)
	elsif keyboardHoriz = 8 then
	    Draw.Text ("~", x8, y3, nameFont, brightblue)
	elsif keyboardHoriz = 9 then
	    Draw.Text ("|", x9, y3, nameFont, brightblue)
	elsif keyboardHoriz = 10 then
	    Draw.Text ("!", x10, y3, nameFont, brightblue)
	end if

    elsif keyboardVerti = 4 then

	if keyboardHoriz = 1 then
	    Draw.Text ("1", x1, y4, nameFont, brightblue)
	elsif keyboardHoriz = 2 then
	    Draw.Text ("2", x2, y4, nameFont, brightblue)
	elsif keyboardHoriz = 3 then
	    Draw.Text ("3", x3, y4, nameFont, brightblue)
	elsif keyboardHoriz = 4 then
	    Draw.Text ("4", x4, y4, nameFont, brightblue)
	elsif keyboardHoriz = 5 then
	    Draw.Text ("5", x5, y4, nameFont, brightblue)
	elsif keyboardHoriz = 6 then
	    Draw.Text ("6", x6, y4, nameFont, brightblue)
	elsif keyboardHoriz = 7 then
	    Draw.Text ("7", x7, y4, nameFont, brightblue)
	elsif keyboardHoriz = 8 then
	    Draw.Text ("8", x8, y4, nameFont, brightblue)
	elsif keyboardHoriz = 9 then
	    Draw.Text ("9", x9, y4, nameFont, brightblue)
	elsif keyboardHoriz = 10 then
	    Draw.Text ("0", x10, y4, nameFont, brightblue)
	end if

    elsif keyboardVerti = 5 then
	Draw.Text (storedText (11), maxx div 2 - textWidth (11) div 2, y5, nameFont, brightblue)

    elsif keyboardVerti = 6 then
	Draw.Text (storedText (12), maxx div 2 - textWidth (12) div 2, y6, instructionText, brightblue)
    end if

end drawNames

proc nameKeyboard (whichLeader : int) % main procedure that controls all other name selection procs, called when user needs to enter name. whichLeader = position on leaderboard

    drawfillbox (0, 0, maxx, maxy, black)
    resetNames
    drawNames
    loop
	loop
	    parget := parallelget
	    if confirmName = true then % if user has confirmed their name, skips and exits loop
		exit
	    elsif parget = 56 then
		keyboardVerti := keyboardVerti - 1
		exit
	    elsif parget = 248 then
		if keyboardVerti > 4 then
		else
		    keyboardHoriz := keyboardHoriz + 1
		    exit
		end if
	    elsif parget = 104 then
		if keyboardVerti > 4 then
		else
		    keyboardHoriz := keyboardHoriz - 1
		    exit
		end if
	    elsif parget = 88 then
		keyboardVerti := keyboardVerti + 1
		exit
	    elsif parget = 112 then
		% used when user selects a character, controlls which char is selected
		if letterNumber = 0 then
		    letterNumber := 1
		    letterSelect (letterNumber)
		elsif letterNumber = 1 then
		    letterNumber := 2
		    letterSelect (letterNumber)
		elsif letterNumber = 2 then
		    letterNumber := 3
		    letterSelect (letterNumber)
		elsif letterNumber = 3 then
		    letterNumber := 4
		    letterSelect (letterNumber)
		elsif letterNumber = 4 then
		    letterNumber := 5
		    letterSelect (letterNumber)
		end if
		if letterNumber = 4 then
		    keyboardVerti := 6
		    drawNames
		end if
		drawNames
		delay (250)
	    end if
	end loop

	if confirmName = true then % exits if user has confirmed their name
	    exit
	end if

	% wrapping left / right / up / down
	if letterNumber = 4 then
	    if keyboardVerti = 4 then
		keyboardVerti := 6
	    elsif keyboardVerti = 7 then
		keyboardVerti := 5
	    end if

	else
	    if keyboardVerti = 0 then
		keyboardVerti := 6
	    elsif keyboardVerti = 7 then
		keyboardVerti := 1
	    end if

	    if keyboardHoriz = 11 then
		keyboardHoriz := 1
	    elsif keyboardHoriz = 0 then
		keyboardHoriz := 10
	    end if
	end if
	drawNames
	delay (200)
    end loop

    top10names (whichLeader) := gitName (1) + gitName (2) + gitName (3) + gitName (4) % puts each char together into 1 variable
end nameKeyboard

% gets top 10 variables
open : scan, "top10.txt", get
for filltop : 1 .. 10
    get : scan, top10names (filltop)
    get : scan, top10scores (filltop)
end for
close : scan

% Boolean Variables
var Loss : boolean := false
var Retry : boolean := false
var skipScore : boolean := false
var menuUpdate : boolean := true %stores if menu needs to update or not
var exitMidgame : boolean := false %stores if user is exiting midgame or not
var endGame : boolean := false %stores if user is ending program

proc CLEAR % clears the screen (black)
    drawfillbox (0, 0, maxx, maxy, black)
end CLEAR

% Resets basic game variables
proc resetVariables
    Level := 1
    Loss := false
    score := 0
    Retry := false
    exitMidgame := false
end resetVariables

proc drawBoxes     % Draws each box - used to reset -- ORDER: top, right, bottom, left
    drawfillbox (maxx div 2 - scaleX div 2, maxy div 2 + scaleY div 2, maxx div 2 + scaleX div 2, maxy div 2 + scaleY + scaleY div 2, brightred)
    drawfillbox (maxx div 2 + scaleX div 2, maxy div 2 + scaleY div 2, maxx div 2 + scaleX div 2 + scaleX, maxy div 2 - scaleY div 2, brightblue)
    drawfillbox (maxx div 2 - scaleX div 2, maxy div 2 - scaleY div 2, maxx div 2 + scaleX div 2, maxy div 2 - scaleY - scaleY div 2, yellow)
    drawfillbox (maxx div 2 - scaleX div 2, maxy div 2 + scaleY div 2, maxx div 2 - scaleX div 2 - scaleX, maxy div 2 - scaleY div 2, brightgreen)
end drawBoxes

% Builds the leaderboard
proc Leaderboard

    CLEAR
    drawbox (maxx - 100, maxy - 70, maxx - 45, maxy - 45, brightgreen)
    drawbox (maxx - 101, maxy - 71, maxx - 46, maxy - 46, brightgreen)
    Draw.Text ("EXIT", maxx - 86, maxy - 63, top10Text, white)

    Draw.Text (storedText (13), maxx div 2 - textWidth (13) div 2, maxy - 85, simonFont, white)
    if konamitrue = false then
	for drawtop10 : 1 .. 10
	    if top10names (drawtop10) = "A2Z" or top10names (drawtop10) = "EEL4" then
		Draw.Text (top10names (drawtop10), scaleX, 330 - drawtop10 * 30, top10Bold, yellow)
		Draw.Text (intstr (top10scores (drawtop10)), scaleX * 3 - scaleX div 4, 330 - drawtop10 * 30, top10Bold, yellow)
	    elsif top10names (drawtop10) = "VUNE" or top10names (drawtop10) = "BNTH" or top10names (drawtop10) = "PNDA" then
		Draw.Text (top10names (drawtop10), scaleX, 330 - drawtop10 * 30, top10Bold, white)
		Draw.Text (intstr (top10scores (drawtop10)), scaleX * 3 - scaleX div 4, 330 - drawtop10 * 30, top10Bold, white)
	    else
		Draw.Text (top10names (drawtop10), scaleX, 330 - drawtop10 * 30, top10Text, white)
		Draw.Text (intstr (top10scores (drawtop10)), scaleX * 3 - scaleX div 4, 330 - drawtop10 * 30, top10Text, white)
	    end if
	end for
    else
	for drawtop10 : 1 .. 10
	    Draw.Text (top10names (drawtop10), scaleX, 330 - drawtop10 * 30, top10Text, Rand.Int (32, 55))
	    Draw.Text (intstr (top10scores (drawtop10)), scaleX * 3 - scaleX div 4, 330 - drawtop10 * 30, top10Text, Rand.Int (32, 55))
	end for
    end if

    loop     % waits for user to clikc back and return to main menu
	parget := parallelget
	if parget = 104 then
	    menuUpdate := true     % requests the menu to update
	    exit
	else
	end if
    end loop
end Leaderboard

% Updates the top 10 scores - call after a game is finished
proc updateTop
    for UPDATE : 1 .. 10
	% runs through each score to check if player's score is higher
	if score > top10scores (UPDATE) then                         % if the score is better than the currently selected top score
	    if UPDATE = 10 then                                      % if it is the 10th best score, replace it and asks for users name
		top10scores (10) := score
		CLEAR
		Draw.Text (storedText (1), maxx div 2 - textWidth (1) div 2, maxy div 2 - scaleY div 7, top10Text, white)     %asks user for their name and updates it into the leaderboard
		nameKeyboard (UPDATE)
		open : scan, "top10.txt", put
		for writetop : 1 .. 10
		    put : scan, top10names (writetop)
		    put : scan, top10scores (writetop)
		end for
		close : scan
		exit
	    else
		% if it is not the 10th best score, runs through each score in reverse order, shifting the list down appropriately
		for decreasing howMany : 9 .. UPDATE
		    top10scores (howMany + 1) := top10scores (howMany)     % moves old 9th to 10th, old 8th to 9th, etc
		    top10names (howMany + 1) := top10names (howMany)     % same as above but with the names
		end for
		top10scores (UPDATE) := score                        % after all other scores have shifted, places the current score into the top 10 in it's respectful place
		CLEAR
		Draw.Text (storedText (1), maxx div 2 - textWidth (1) div 2, maxy div 2 - scaleY div 7, top10Text, white)     %asks user for their name and updates it into the leaderboard
		nameKeyboard (UPDATE)
		open : scan, "top10.txt", put
		for writetop : 1 .. 10
		    put : scan, top10names (writetop)
		    put : scan, top10scores (writetop)
		end for
		close : scan
		exit     % exits UPDATE for loop
	    end if

	end if
    end for
    Leaderboard     % shows the user the updated leaderboard
end updateTop

proc gameOver     %shows the user their final score
    CLEAR
    Draw.Text (storedText (15), maxx div 2 - textWidth (15) div 2, maxy div 2 + 20, infoText, white)
    storedText (16) := intstr (score)
    textWidth (16) := Font.Width (storedText (16), infoText)
    Draw.Text (storedText (16), maxx div 2 - textWidth (16) div 2, maxy div 2 - 10, infoText, white)
    delay (1250)
    updateTop     % calls update to check if user's score is top 10
end gameOver

%% intructions must be revised
proc Instructions     % shows instructions to user
    CLEAR
    if konamitrue = false then

	Draw.Text (storedText (5), maxx div 2 - textWidth (5) div 2, maxy div 2 + 30, instructionText, white)
	Draw.Text (storedText (6), maxx div 2 - textWidth (6) div 2, maxy div 2, instructionText, white)
	Draw.Text (storedText (7), maxx div 2 - textWidth (7) div 2, 75, infoText, white)
	Draw.Text (storedText (8), maxx div 2 - textWidth (8) div 2, 50, infoText, white)
	drawbox (maxx - 100, maxy - 70, maxx - 45, maxy - 45, brightgreen)
	drawbox (maxx - 101, maxy - 71, maxx - 46, maxy - 46, brightgreen)
	Draw.Text ("EXIT", maxx - 86, maxy - 63, top10Text, white)

    else
	Draw.Text (storedText (26), maxx div 2 - textWidth (26) div 2, maxy div 2 + 30, instructionText, white)
	drawbox (maxx - 100, maxy - 70, maxx - 45, maxy - 45, brightgreen)
	drawbox (maxx - 101, maxy - 71, maxx - 46, maxy - 46, brightgreen)
	Draw.Text ("EXIT", maxx - 86, maxy - 63, top10Text, white)

    end if

    loop
	parget := parallelget
	if parget = 104 then
	    menuUpdate := true     % requests for a menu update
	    exit
	else
	end if
    end loop
end Instructions

proc drawSIMON             % Draws the main structure of each level
    CLEAR
    storedText (3) := "Score: " + intstr (score)
    textWidth (3) := Font.Width (storedText (3), infoText)
    storedText (4) := "Level " + intstr (Level)
    textWidth (4) := Font.Width (storedText (4), infoText)
    drawBoxes     %calls drawBoxes to fill screen
    Draw.Text (storedText (2), maxx div 2 - textWidth (2) div 2, maxy div 2 - scaleY div 7, simonFont, white)     % displays SIMON in the middle of the boxes
    Draw.Text (storedText (4), maxx div 2 - textWidth (4) div 2, maxy - scaleY div 3, infoText, white)     % displays the level the player is on
    Draw.Text (storedText (3), maxx div 2 - textWidth (3) div 2, scaleY div 5, infoText, white)     %displays the player's score
end drawSIMON

proc drawYOU             % Draws the main structure of each level
    CLEAR
    storedText (3) := "Score: " + intstr (score)
    textWidth (3) := Font.Width (storedText (3), infoText)
    storedText (4) := "Level " + intstr (Level)
    textWidth (4) := Font.Width (storedText (4), infoText)
    drawBoxes     %calls drawBoxes to fill screen
    Draw.Text (storedText (9), maxx div 2 - textWidth (9) div 2, maxy div 2 + 9, simonFont, white)     % displays YOUR TURN in the middle of the boxes
    Draw.Text (storedText (10), maxx div 2 - textWidth (10) div 2, maxy div 2 - 35, simonFont, white)     % displays YOUR TURN in the middle of the boxes
    Draw.Text (storedText (4), maxx div 2 - textWidth (4) div 2, maxy - scaleY div 3, infoText, white)     % displays the level the player is on
    Draw.Text (storedText (3), maxx div 2 - textWidth (3) div 2, scaleY div 5, infoText, white)     %displays the player's score
    drawbox (maxx - 100, 70, maxx - 45, 45, grey)
    drawbox (maxx - 101, 71, maxx - 46, 46, grey)
    Draw.Text ("PAUSE", maxx - 95, 53, top10Text, white)
end drawYOU

proc wrongCombo
    CLEAR
    storedText (19) := "(You will lose " + intstr(Level * 500) + " points)"
    textWidth (19) := Font.Width (storedText (19), top10Text)
    Draw.Text (storedText (18), maxx div 2 - textWidth (18) div 2, maxy div 2 + 40, infoText, white)
    delay (1000)
    Draw.Text (storedText (17), maxx div 2 - textWidth (17) div 2, maxy div 2 + 10, infoText, white)
    Draw.Text (storedText (19), maxx div 2 - textWidth (19) div 2, maxy div 2 - 12, top10Text, white)
    drawbox (maxx div 2 - 150, maxy - 300, maxx div 2 - 50, maxy - 250, brightgreen)
    drawbox (maxx div 2 - 151, maxy - 301, maxx div 2 - 51, maxy - 251, brightgreen)
    Draw.Text ("YES", maxx div 2 + 74, maxy - 285, instructionText, white)
    drawbox (maxx div 2 + 50, maxy - 300, maxx div 2 + 150, maxy - 250, brightblue)
    drawbox (maxx div 2 + 51, maxy - 301, maxx div 2 + 151, maxy - 251, brightblue)
    Draw.Text ("NO", maxx div 2 - 120, maxy - 285, instructionText, white)

    loop
	parget := parallelget
	if parget = 104 then
	    % player doesn't want to continue
	    Loss := true     % variable used to exit loops later
	    gameOver     %calls game over to display final score and leaderboard
	    exit
	elsif parget = 248 then
	    % player wants to continue
	    score := score - (Level * 500)   %subtracts from their current score and limits their lowest score to 0
	    if score < 0 then
		score := 0
	    else
	    end if
	    Retry := true     % variable used to reqest another attempt
	    exit
	end if
    end loop
end wrongCombo

procedure MAIN (level : int)
    delay (500)
    CLEAR
    Draw.Text ("Level " + intstr (level), maxx div 2 - scaleX div 2 + scaleX div 10, maxy div 2 - scaleY div 7, levelText, white)     %displays the level to the player
    delay (2000)
    parallelput (0)
    CLEAR

    % Refreshes Screen
    drawSIMON
    delay (1000)

    % Refreshes Variables
    var numCombo : int := level + 2                             % stores amount of lights to be i nthe combination
    var combination, userCombo : array 1 .. numCombo of int             % stores created combination and user inputs # based
    var scoreTrack : int := level * 1000                %total score to subtract from (score is calculated by subtracting periodically from this variable)

    % Creates combination
    for numCreate : 1 .. numCombo
	combination (numCreate) := Rand.Int (1, 4)
    end for

    %shows combination to the player
    for drawCombo : 1 .. numCombo
	if combination (drawCombo) = 1 then
	    drawfilloval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, white)
	    drawoval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, black)
	    parallelput (1)
	elsif combination (drawCombo) = 2 then
	    drawfilloval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
	    drawoval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
	    parallelput (2)
	elsif combination (drawCombo) = 3 then
	    drawfilloval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, white)
	    drawoval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, black)
	    parallelput (8)
	elsif combination (drawCombo) = 4 then
	    drawfilloval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
	    drawoval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
	    parallelput (4)
	end if
	delay ((100 div Level) * 10 + 700)
	parallelput (0)
	drawBoxes
	delay (500)
    end for

    drawYOU

    %gets combination from player
    for getCombo : 1 .. numCombo

	loop
	    parget := parallelget
	    if parget = 56 then
		userCombo (getCombo) := 1
		parallelput (1)
		drawfilloval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, black)
		exit
	    elsif parget = 248 then
		userCombo (getCombo) := 2
		parallelput (2)
		drawfilloval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
		exit

	    elsif parget = 104 then
		userCombo (getCombo) := 4
		parallelput (4)
		drawfilloval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
		exit

	    elsif parget = 88 then
		userCombo (getCombo) := 3
		parallelput (8)
		drawfilloval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, black)
		exit

	    elsif parget = 112 then
		% if user wants to exit, they can click enter key
		drawfillbox (maxx div 2 - scaleX, maxy div 2 - 50, maxx div 2 + scaleX, maxy div 2 + 50, white)
		drawbox (maxx div 2 - scaleX, maxy div 2 - 50, maxx div 2 + scaleX, maxy div 2 + 50, brightblue)
		Draw.Text (storedText (20), maxx div 2 - textWidth (20) div 2, maxy div 2 + 24, infoText, black)
		drawfillbox (maxx div 2 + scaleX - 10, maxy - 200, maxx div 2 + 40, maxy - 250, brightblue)
		Draw.Text ("YES", maxx div 2 + 74, maxy div 2 - 26, infoText, white)
		drawfillbox (maxx div 2 - scaleX + 10, maxy - 200, maxx div 2 - 40, maxy - 250, brightgreen)
		Draw.Text ("NO", maxx div 2 - 108, maxy div 2 - 26, infoText, white)

		loop
		    parget := parallelget
		    % if user wants to exit
		    if parget = 248 then
			exitMidgame := true     % variable used to skip through loops
			parallelput (0)
			exit
		    elsif parget = 104 then
			% user does not wish to quit
			CLEAR
			drawYOU     % redraws screen and resumes
			parallelput (0)
			delay (500)
			exit
		    end if
		end loop
		if exitMidgame = true then     % if user requested to exit match, quits out of the key tracking loop
		    exit
		else
		end if
	    else     % if player clicks nothing, score will be subtracted
		Window.Select (scoreWindow)
		if scoreTrack = 0 then
		else
		    scoreTrack := scoreTrack - 2
		end if
		put scoreTrack
		Window.Select (mainWindow)
	    end if
	end loop

	if exitMidgame = false then
	    delay (200)
	    parallelput (0)
	    if userCombo (getCombo) = combination (getCombo) then
		drawBoxes
	    else
		wrongCombo
		exit
	    end if
	    drawBoxes
	else
	    exit
	end if
    end for
    /**/

    if Retry = true then
	delay (500)
	CLEAR
	Draw.Text ("Level " + intstr (level), maxx div 2 - scaleX div 2 + scaleX div 10, maxy div 2 - scaleY div 7, levelText, white)
	delay (2000)
	CLEAR
	drawSIMON
	delay (500)
	for drawCombo : 1 .. numCombo
	    if combination (drawCombo) = 1 then
		drawfilloval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, black)
		parallelput (1)
	    elsif combination (drawCombo) = 2 then
		drawfilloval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
		parallelput (2)
	    elsif combination (drawCombo) = 3 then
		drawfilloval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, black)
		parallelput (8)
	    elsif combination (drawCombo) = 4 then
		drawfilloval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
		parallelput (4)
	    end if
	    delay ((100 div Level) * 10 + 700)
	    parallelput (0)
	    drawBoxes
	    delay (500)
	end for
	/**/

	drawYOU

	%gets combination from player
	for getCombo : 1 .. numCombo

	    loop
		parget := parallelget
		if parget = 56 then
		    parallelput (1)
		    userCombo (getCombo) := 1
		    drawfilloval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, white)
		    drawoval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, black)
		    exit

		elsif parget = 248 then
		    parallelput (2)
		    userCombo (getCombo) := 2
		    drawfilloval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		    drawoval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
		    exit

		elsif parget = 104 then
		    parallelput (4)
		    userCombo (getCombo) := 4
		    drawfilloval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		    drawoval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)
		    exit

		elsif parget = 88 then
		    parallelput (8)
		    userCombo (getCombo) := 3
		    drawfilloval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, white)
		    drawoval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, black)
		    exit

		elsif parget = 112 then

		    drawfillbox (maxx div 2 - scaleX, maxy div 2 - 50, maxx div 2 + scaleX, maxy div 2 + 50, white)
		    drawbox (maxx div 2 - scaleX, maxy div 2 - 50, maxx div 2 + scaleX, maxy div 2 + 50, brightblue)
		    Draw.Text (storedText (20), maxx div 2 - textWidth (20) div 2, maxy div 2 + 24, infoText, black)
		    drawfillbox (maxx div 2 + scaleX - 10, maxy - 200, maxx div 2 + 40, maxy - 250, brightblue)
		    Draw.Text ("YES", maxx div 2 + 74, maxy div 2 - 26, infoText, white)
		    drawfillbox (maxx div 2 - scaleX + 10, maxy - 200, maxx div 2 - 40, maxy - 250, brightgreen)
		    Draw.Text ("NO", maxx div 2 - 108, maxy div 2 - 26, infoText, white)

		    loop
			parget := parallelget
			if parget = 248 then
			    exitMidgame := true
			    parallelput (0)
			    exit
			elsif parget = 104 then
			    CLEAR
			    drawYOU
			    delay (500)
			    parallelput (0)
			    exit
			end if
		    end loop
		    if exitMidgame = true then
			exit
		    else
		    end if
		else
		    Window.Select (scoreWindow)
		    if scoreTrack = 0 then
		    else
			scoreTrack := scoreTrack - 1
		    end if
		    put scoreTrack
		    Window.Select (mainWindow)
		end if

	    end loop

	    if exitMidgame = false then
		delay (200)
		parallelput (0)
		if userCombo (getCombo) = combination (getCombo) then
		    drawBoxes
		else
		    CLEAR
		    Draw.Text (storedText (18), maxx div 2 - textWidth (18) div 2, maxy div 2 + 40, infoText, white)
		    delay (1250)
		    Loss := true
		    gameOver
		    exit
		end if
	    else
		exit
	    end if
	end for
	Retry := false
    else
    end if

    if exitMidgame = false then
	if Loss = true then
	else
	    delay(250)
	    for x : 1 .. 3
		drawfilloval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2, maxy div 2 + scaleY, scaleY div 3, scaleY div 3, black)
		parallelput (1)

		delay (125)
		drawBoxes
		parallelput (2)
		drawfilloval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2 + scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)

		delay (125)
		drawBoxes
		parallelput (8)
		drawfilloval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2, maxy div 2 - scaleY, scaleY div 3, scaleY div 3, black)

		delay (125)
		drawBoxes
		parallelput (4)
		drawfilloval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, white)
		drawoval (maxx div 2 - scaleX, maxy div 2, scaleY div 3, scaleY div 3, black)

		delay (125)
		drawBoxes
	    end for
	    parallelput (15)
	    score := (500 * level) + scoreTrack + score
	    Level := Level + 1
	    MAIN (Level)
	end if
    else
	exitMidgame := false
    end if
end MAIN

proc konamiReset
    for x : 1 .. 8
	seKret (x) := 0
    end for
    konami := false
    konamitrue := false
end konamiReset

proc konamiCheck (konamiGet : int)
    if konamitrue = false then
	seKret (1) := seKret (2)
	seKret (2) := seKret (3)
	seKret (3) := seKret (4)
	seKret (4) := seKret (5)
	seKret (5) := seKret (6)
	seKret (6) := seKret (7)
	seKret (7) := seKret (8)
	seKret (8) := konamiGet

	if seKret (1) = 1 then
	    if seKret (2) = 1 then
		if seKret (3) = 2 then
		    if seKret (4) = 2 then
			if seKret (5) = 3 then
			    if seKret (6) = 4 then
				if seKret (7) = 3 then
				    if seKret (8) = 4 then
					konami := true
				    end if
				end if
			    end if
			end if
		    end if
		end if
	    end if
	end if
    end if
end konamiCheck

proc GameMenu
    konamiReset
    loop
	if menuUpdate = true then
	    CLEAR
	    if konamitrue = false then
		menu1 := 12
		menu2 := 9
		menu3 := 14
		menu4 := 10
		storedText (21) := "SIMON"
		textWidth (21) := Font.Width (storedText (21), titleText)

	    else
		menu1 := Rand.Int (32, 55)
		menu2 := Rand.Int (32, 55)
		menu3 := Rand.Int (32, 55)
		menu4 := Rand.Int (32, 55)
		storedText (21) := "SUPERSIMON"
		textWidth (21) := Font.Width (storedText (21), titleText)

	    end if
	    if menuSelect = 1 then
		Draw.Text (storedText (22), maxx div 2 - textWidth (22) div 2, maxy div 2 + 25, levelText, menu1)
		Draw.Text (storedText (23), maxx div 2 - textWidth (23) div 2, maxy div 2 - 25, levelText, grey)
		Draw.Text (storedText (24), maxx div 2 - textWidth (24) div 2, maxy div 2 - 75, levelText, grey)
		Draw.Text (storedText (25), maxx div 2 - textWidth (25) div 2, maxy div 2 - 125, levelText, grey)
		Draw.Text (storedText (21), maxx div 2 - textWidth (21) div 2, maxy - 100, titleText, menu1)
		parallelput (1)

	    elsif menuSelect = 2 then
		Draw.Text (storedText (22), maxx div 2 - textWidth (22) div 2, maxy div 2 + 25, levelText, grey)
		Draw.Text (storedText (23), maxx div 2 - textWidth (23) div 2, maxy div 2 - 25, levelText, menu2)
		Draw.Text (storedText (24), maxx div 2 - textWidth (24) div 2, maxy div 2 - 75, levelText, grey)
		Draw.Text (storedText (25), maxx div 2 - textWidth (25) div 2, maxy div 2 - 125, levelText, grey)
		Draw.Text (storedText (21), maxx div 2 - textWidth (21) div 2, maxy - 100, titleText, menu2)
		parallelput (2)

	    elsif menuSelect = 3 then
		Draw.Text (storedText (22), maxx div 2 - textWidth (22) div 2, maxy div 2 + 25, levelText, grey)
		Draw.Text (storedText (23), maxx div 2 - textWidth (23) div 2, maxy div 2 - 25, levelText, grey)
		Draw.Text (storedText (24), maxx div 2 - textWidth (24) div 2, maxy div 2 - 75, levelText, menu3)
		Draw.Text (storedText (25), maxx div 2 - textWidth (25) div 2, maxy div 2 - 125, levelText, grey)
		Draw.Text (storedText (21), maxx div 2 - textWidth (21) div 2, maxy - 100, titleText, menu3)
		parallelput (8)

	    elsif menuSelect = 4 then
		Draw.Text (storedText (22), maxx div 2 - textWidth (22) div 2, maxy div 2 + 25, levelText, grey)
		Draw.Text (storedText (23), maxx div 2 - textWidth (23) div 2, maxy div 2 - 25, levelText, grey)
		Draw.Text (storedText (24), maxx div 2 - textWidth (24) div 2, maxy div 2 - 75, levelText, grey)
		Draw.Text (storedText (25), maxx div 2 - textWidth (25) div 2, maxy div 2 - 125, levelText, menu4)
		Draw.Text (storedText (21), maxx div 2 - textWidth (21) div 2, maxy - 100, titleText, menu4)
		parallelput (4)

	    end if
	    drawbox (maxx - 100, 70, maxx - 45, 45, grey)
	    drawbox (maxx - 101, 71, maxx - 46, 46, grey)
	    Draw.Text ("SELECT", maxx - 98, 53, top10Text, white)
	    drawbox (maxx - 100, 115, maxx - 45, 90, yellow)
	    drawbox (maxx - 101, 116, maxx - 46, 91, yellow)
	    Draw.Text ("DOWN", maxx - 94, 98, top10Text, white)
	    drawbox (maxx - 100, 160, maxx - 45, 135, 12)
	    drawbox (maxx - 101, 161, maxx - 46, 136, 12)
	    Draw.Text ("UP", maxx - 82, 143, top10Text, white)
	    delay (275)
	    menuUpdate := false
	end if
	parget := parallelget
	if parget = 56 then
	    konamiCheck (1)
	    if menuSelect = 1 then
	    else
		menuSelect := menuSelect - 1
		menuUpdate := true
	    end if
	elsif parget = 112 then
	    parallelput (15)
	    if konami = true then
		konamitrue := true
		konami := false
		menuUpdate := true
	    elsif menuSelect = 1 then
		resetVariables     % forces variables to reset before starting
		MAIN (Level)
		konamiReset
		menuUpdate := true
	    elsif menuSelect = 2 then
		Leaderboard
	    elsif menuSelect = 3 then
		Instructions
	    elsif menuSelect = 4 then
		endGame := true
		exit
	    end if
	elsif parget = 88 then
	    konamiCheck (2)
	    if menuSelect = 4 then
	    else
		menuSelect := menuSelect + 1
		menuUpdate := true
	    end if
	elsif parget = 104 then
	    konamiCheck (3)
	    menuUpdate := true
	elsif parget = 248 then
	    konamiCheck (4)
	    menuUpdate := true
	else
	end if
    end loop

end GameMenu
loop
    GameMenu
    if endGame = true then
	Window.Close (mainWindow)
	Window.Close (scoreWindow)
	exit
    else
    end if
end loop
parallelput (0)
