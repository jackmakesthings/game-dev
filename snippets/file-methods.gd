extends Node

var playerName = "Player"
var timezone = 4 # default to PST; EST is 8; UTC is 12
var saveFile = File.new()
var saveFilePath = "user://save.txt"

var saveStr # string containing the player name and timezone, separated by a comma

func _ready():
   print( "Querying save data..." )
   
   if ( saveFile.file_exists( saveFilePath ) ): # if the file exists, read it
      print( "Save file exists, opening..." )
      readSave()
   else:
      print( "No save file found, creating..." ) # else create it with default values
      writeSave()
   

func readSave():
   print( "Reading save..." )
   saveFile.open( saveFilePath , File.READ ) # open the file
   
   saveStr = saveFile.get_line() # get the save string
   saveStr = saveStr.split(",",true) # split the string into an array at the comma(s)
   
   playerName = saveStr.get(0) # player name is the first value
   timezone = int(saveStr.get(1)) #timezone is the second
   # more values could be added, if needed
   
   saveFile.close() # close the file

func writeSave():
   print( "Writing to save file" )
   saveFile.open( saveFilePath , File.WRITE ) # open the file
   
   saveStr = playerName + "," + str(timezone) # add the correct values to the save string
   saveFile.store_line(saveStr) # write the save string to the file
   
   saveFile.close() # close the file