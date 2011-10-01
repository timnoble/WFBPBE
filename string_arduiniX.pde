
// Arduinix 6 Bulb ( IN-17 ) 
// - Also supports Hour and Min. time set.
// 
// This code runs a six bulb setup and displays a prototype clock setup.
// NOTE: the delay is setup for IN-17 nixie bulbs.
//
// by Jeremy Howa
// www.robotpirate.com
// www.arduinix.com
// 2008 - 2009
//
// Last Edit Aug 29, 2009
//

// SN74141 : True Table
//D C B A #
//L,L,L,L 0
//L,L,L,H 1
//L,L,H,L 2
//L,L,H,H 3
//L,H,L,L 4
//L,H,L,H 5
//L,H,H,L 6
//L,H,H,H 7
//H,L,L,L 8
//H,L,L,H 9

#define DEBUG_ON   false

//from readstring_serial
String readString;

// SN74141 (1)
int ledPin_0_a = 2;                
int ledPin_0_b = 3;
int ledPin_0_c = 4;
int ledPin_0_d = 5;
// SN74141 (2)
int ledPin_1_a = 6;                
int ledPin_1_b = 7;
int ledPin_1_c = 8;
int ledPin_1_d = 9;

// anod pins
int ledPin_a_1 = 10;
int ledPin_a_2 = 11;
int ledPin_a_3 = 12;
int ledPin_a_4 = 13;

void setup() 
{
  pinMode(ledPin_0_a, OUTPUT);      
  pinMode(ledPin_0_b, OUTPUT);      
  pinMode(ledPin_0_c, OUTPUT);      
  pinMode(ledPin_0_d, OUTPUT);    
  
  pinMode(ledPin_1_a, OUTPUT);      
  pinMode(ledPin_1_b, OUTPUT);      
  pinMode(ledPin_1_c, OUTPUT);      
  pinMode(ledPin_1_d, OUTPUT);      
  
  pinMode(ledPin_a_1, OUTPUT);      
  pinMode(ledPin_a_2, OUTPUT);      
  pinMode(ledPin_a_3, OUTPUT);     
  pinMode(ledPin_a_4, OUTPUT); 
    
  Serial.begin(9600);
  //from readstring_serial to keep track of which is which board
  Serial.println("serial test yo1");
    
}

////////////////////////////////////////////////////////////////////////
//
// DisplayNumberSet
// Use: Passing anod number, and number for bulb 1 and bulb 2, this function
//      looks up the truth table and opens the correct outs from the arduino
//      to light the numbers given to this funciton (num1,num2).
//      On a 6 nixie bulb setup.
//
////////////////////////////////////////////////////////////////////////
void DisplayNumberSet( int anod, int num1, int num2 )
{
  int anodPin;
  int a,b,c,d;
  
  // set defaults.
  a=0;b=0;c=0;d=0; // will display a zero.
  anodPin =  ledPin_a_1;     // default on first anod.
  
  // Select what anod to fire.
  switch( anod )
  {
    case 0:    anodPin =  ledPin_a_1;    break;
    case 1:    anodPin =  ledPin_a_2;    break;
    case 2:    anodPin =  ledPin_a_3;    break;
    case 3:    anodPin =  ledPin_a_4;    break;
  }  
  
  // Load the a,b,c,d.. to send to the SN74141 IC (1)
  switch( num1 )
  {
    case 0: a=0;b=0;c=0;d=0;break;
    case 1: a=1;b=0;c=0;d=0;break;
    case 2: a=0;b=1;c=0;d=0;break;
    case 3: a=1;b=1;c=0;d=0;break;
    case 4: a=0;b=0;c=1;d=0;break;
    case 5: a=1;b=0;c=1;d=0;break;
    case 6: a=0;b=1;c=1;d=0;break;
    case 7: a=1;b=1;c=1;d=0;break;
    case 8: a=0;b=0;c=0;d=1;break;
    case 9: a=1;b=0;c=0;d=1;break;
  }  
  
  // Write to output pins.
  digitalWrite(ledPin_0_d, d);
  digitalWrite(ledPin_0_c, c);
  digitalWrite(ledPin_0_b, b);
  digitalWrite(ledPin_0_a, a);

  // Load the a,b,c,d.. to send to the SN74141 IC (2)
  switch( num2 )
  {
    case 0: a=0;b=0;c=0;d=0;break;
    case 1: a=1;b=0;c=0;d=0;break;
    case 2: a=0;b=1;c=0;d=0;break;
    case 3: a=1;b=1;c=0;d=0;break;
    case 4: a=0;b=0;c=1;d=0;break;
    case 5: a=1;b=0;c=1;d=0;break;
    case 6: a=0;b=1;c=1;d=0;break;
    case 7: a=1;b=1;c=1;d=0;break;
    case 8: a=0;b=0;c=0;d=1;break;
    case 9: a=1;b=0;c=0;d=1;break;
  }
  
  // Write to output pins
  digitalWrite(ledPin_1_d, d);
  digitalWrite(ledPin_1_c, c);
  digitalWrite(ledPin_1_b, b);
  digitalWrite(ledPin_1_a, a);

  // Turn on this anod.
  digitalWrite(anodPin, HIGH);   

  // Delay
  // NOTE: With the differnce in Nixie bulbs you may have to change
  //       this delay to set the update speed of the bulbs. If you 
  //       dont wait long enough the bulb will be dim or not light at all
  //       you want to set this delay just right so that you have 
  //       nice bright output yet quick enough so that you can multiplex with
  //       more bulbs.
  delay(2);
  
  // Shut off this anod.
  digitalWrite(anodPin, LOW);
}

////////////////////////////////////////////////////////////////////////
//
// DisplayNumberString
// Use: passing an array that is 8 elements long will display numbers
//      on a 6 nixie bulb setup.
// Added 2 more digits (TN)
//
////////////////////////////////////////////////////////////////////////
void DisplayNumberString( int* array )
{
  // bank 1 (bulb 0,4)
  DisplayNumberSet(0,array[0],array[4]);   
  // bank 2 (bulb 1,5)
  DisplayNumberSet(1,array[1],array[5]);   
  // bank 3 (bulb 2,6)
  DisplayNumberSet(2,array[2],array[6]);   
  // bank 4 (bulb 3, 7)
  DisplayNumberSet(3,array[3],array[7]);
}



////////////////////////////////////////////////////////////////////////
//
//
////////////////////////////////////////////////////////////////////////
void loop()     
{
  // serial read into string code
   while (Serial.available()) {
	  delay(10);
	    if (Serial.available() >0) {
	  char c = Serial.read();
	  readString += c;}
	  }

	if (readString.length() >0) {
	Serial.println(readString);

	readString="";

	}
// not sure if needed
//  char c;
//      c = Serial.read(); // assume it reads N
//      y = c -'0'; // or else it will be 78



  // debug happens here, available toggle switch style?
if( DEBUG_ON )
  {

  }

  // Fill in the Number array used to display on the tubes.
  int NumberArray[8]={0,0,0,0,0,0,0,0};
  NumberArray[0] = 1; //use variables here
  NumberArray[1] = 2;
  NumberArray[2] = 3;
  NumberArray[3] = 4;
  NumberArray[4] = 5;
  NumberArray[5] = 6;
  NumberArray[6] = 7;
  NumberArray[7] = 8;

  // Display.
  DisplayNumberString( NumberArray );
}

