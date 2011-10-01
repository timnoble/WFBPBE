/* Board Fade
simple demo for board lights
*/
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by


/*
 PROGMEM string demo
 How to store a table of strings in program memory (flash), 
 and retrieve them.

 Information summarized from:
 http://www.nongnu.org/avr-libc/user-manual/pgmspace.html

 Setting up a table (array) of strings in program memory is slightly complicated, but
 here is a good template to follow. 

 Setting up the strings is a two-step process. First define the strings.

*/

#include <avr/pgmspace.h>
prog_char jack_0[] PROGMEM = "Nothing Selected";   // "jack 0" etc are strings to store - change to suit.
prog_char jack_1[] PROGMEM = "Cape Verde";
prog_char jack_2[] PROGMEM = "Afghanistan";
prog_char jack_3[] PROGMEM = "Central African Republic";
prog_char jack_4[] PROGMEM = "Albania";
prog_char jack_5[] PROGMEM = "chad";
prog_char jack_6[] PROGMEM = "Algeria";
prog_char jack_7[] PROGMEM = "Chile";
prog_char jack_8[] PROGMEM = "Andorra";
prog_char jack_9[] PROGMEM = "China";
prog_char jack_10[] PROGMEM = "Angola";
prog_char jack_11[] PROGMEM = "Colombia";
prog_char jack_12[] PROGMEM = "Antigua and Barbuda";
prog_char jack_13[] PROGMEM = "Comorros";
prog_char jack_14[] PROGMEM = "Argentina";
prog_char jack_15[] PROGMEM = "Congo, Democratic Republic of";
prog_char jack_16[] PROGMEM = "Armenia";
prog_char jack_17[] PROGMEM = "Congo, Republic of";
prog_char jack_18[] PROGMEM = "Aruba";




// Then set up a table to refer to your strings.

PROGMEM const char *jack_table[] = 	   // change "jack_table" name to suit
{   
  jack_0,
  jack_1,
  jack_2,
  jack_3,
  jack_4,
  jack_5,
  jack_6,
  jack_7,
  jack_8,
  jack_9,
  jack_10,
  jack_11,
  jack_12,
  jack_13,
  jack_14,
  jack_15,
  jack_16,
  jack_17,
  jack_18,
  };

char buffer[60];    // make sure this is large enough for the largest string it must hold


/*
AnalogCountry_Combos
Version 0.1

Connection more then one Country to a single analog pin. Utilizing
software debounce to prevent registering multiple Country press

Based on AnalogButton_Combos v0.1
Created By: Michael Pilcher
February 24, 2010

*/
//#include <LiquidCrystal.h>
//LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

int j = 2; // integer used in scanning the array designating column number
int p = 1; // integer used in scanning the array column number for analog pin number
//2-dimensional array for asigning the Country position to a particular set (analog pin),
// position in that set and and their high and low limits. expected names/range values in comments
int Country[19][4] = {{1, 1, 647, 690,}, // Country 1, board 1, Afghanistan, 667 sensor reading
			   {2, 1, 609, 646}, // Country 2, pin 1, 626 
			   {3, 1, 691, 740}, // Country 3, pin 1, 713
			   {4, 1, 578, 608}, // Country 4, pin 1, 590
			   {5, 1, 741, 781}, // Country 5, pin 1, 767
			   {6, 1, 545, 577}, // Country 6, pin 1, 558
			   {7, 1, 782, 810}, // Country 7, pin 1, 795
			   {8, 1, 517, 544}, // Country 8, 529
			   {9, 1, 811, 842}, // Country 9, 826
			   {10, 1, 479, 516}, // Country 10, 503
			   {11, 1, 843, 877}, // Country 11, 859
			   {12, 1, 440, 478}, // Country 12, 458
			   {13, 1, 878, 914}, // Country 13, 895
			   {14, 1, 391, 439}, // Country 14, 420
			   {15, 1, 915, 954}, // Country 15, 934
			   {16, 1, 375, 390}, // Country 16, 388
			   {17, 1, 955, 1022}, // Country 17, 976
			   {18, 1, 300, 374}, // Country 18, 361
                           {0, 1, 0, 299}, // Not attached 
};







const int analogpin_1 = 4; // analog pin to read the Countries
int jackPosition = 0;  // for reporting the Country jackPosition
int jackValCounter = 0; // how many times we have seen new value
long time = 0;  // the last time the output pin was sampled
int debounce_count = 50; // number of millis/samples to consider before declaring a debounced input
int current_state = 0;  // the debounced input value
int BoardVal;
int x = 0;
int y = 0;

void setup()
{
  //board led pins get set to shine
      pinMode(3, OUTPUT);
      pinMode(4, OUTPUT);
      pinMode(5, OUTPUT);
      pinMode(6, OUTPUT);
      pinMode(7, OUTPUT);
    
    
  //lcd.begin(16, 2);
  //lcd.setCursor(x,y);
  //lcd.write(255);
  
    // initialize serial communications at 9600 bps:
    Serial.begin(9600); 
}

void loop()
{
  //Fade demo for board lights
  //
  
 // set the brightness of pin 9:
  analogWrite(3, brightness);    
  analogWrite(4, 255 - brightness);   
   analogWrite(5, brightness);   
   analogWrite(6, 255 - brightness);    
   analogWrite(7, brightness);      
  // change the brightness for next time through the loop:
  brightness = brightness + fadeAmount;

  // reverse the direction of the fading at the ends of the fade: 
  if (brightness == 0 || brightness == 255) {
    fadeAmount = -fadeAmount ; 
  }     
  // wait for 30 milliseconds to see the dimming effect    
  delay(30);                            

//
//End fade demo
//

  
   // If we have gone on to the next millisecond
   if (millis() != time)
  {
    // check analog pin for the Country value and save it to BoardVal
    BoardVal = analogRead(analogpin_1);
    if(BoardVal == current_state && jackValCounter >0)
    {
	jackValCounter--;
    }
    if(BoardVal != current_state)
    {
	jackValCounter++;
    }
    // If BoardVal has shown the same value for long enough let's switch it
    if (jackValCounter >= debounce_count)
    {
	jackValCounter = 0;
	current_state = BoardVal;
	//Checks which Country has been jacked into
	if (BoardVal > 0)
	{
	  BoardCheck();
	}
    }

    time = millis();
  }
}


void BoardCheck()
{
  // loop for scanning the board array.
  for(int i = 0; i <= 18; i++)
  {
    // checks the BoardVal against the high and low vales in the array
    if(BoardVal >= Country[i][j] && BoardVal <= Country[i][j+1])
    {
	// stores the country number to a variable
	jackPosition = Country[i][0];
	Action();
    }
  }
}

void Action()
{
  const char *countryName = jack_table[jackPosition];  
  // print the results to the serial monitor:
  Serial.print("sensor = " );                       
  Serial.print(BoardVal);      
  Serial.print("\t output as jackPosition = ");      
  Serial.println(jackPosition);   //all ~178 possibilities over multiple analog pins
  Serial.print("Country = " );

  // PROGMEM string table lookup
  //
    /* Using the string table in program memory requires the use of special functions to retrieve the data.
     The strcpy_P function copies a string from program space to a string in RAM ("buffer"). 
     Make sure your receiving string in RAM  is large enough to hold whatever
     you are retrieving from program space. */


    strcpy_P(buffer, (char*)pgm_read_word(&(jack_table[jackPosition]))); // Necessary casts and dereferencing, just copy. 
    Serial.println( buffer );
    delay( 500 );

}


