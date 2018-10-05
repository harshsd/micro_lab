//-----------------------------------------------------------------------------
// Blinky.c
//-----------------------------------------------------------------------------
//Author: Maheshwar Mangat
//Release 1.0 - 22-July-2013
//-Initial Revision
//
// Program Description:
//
// This program flashes the P1.4 RED LED on the Pt-51 target board at interval of 1 sec.
//
// How To Test:
//
// 1) Download code to a 'Pt-51' target board
// 2) Run the code and if the P1.4 LED blinks, the code works
//
//
//
// Target: AT89C5131A
// Tool chain: Keil C51
// Command Line: None
//
//
//-----------------------------------------------------------------------------
// Include necessary header files here
//-----------------------------------------------------------------------------
#include <AT89C5131.h> // All SFR declarations for AT89C5131
//-----------------------------------------------------------------------------
// Global Declarations
//-----------------------------------------------------------------------------
sbit LED = P1^7; //assigning label to P1^7 as "LED"
//-----------------------------------------------------------------------------
// Function prototypes
//-----------------------------------------------------------------------------
void delayms(unsigned int ms_sec);
//-----------------------------------------------------------------------------
// main() Routine
//-----------------------------------------------------------------------------
void main (void)
{
P1=0x000; // port pin P1.3 as output
LED=0; //Initialise LED to 0;
while (1) // Loop forever
{
LED=~LED; // To toggle the LED
delayms(1000);
}
}
//-----------------------------------------------------------------------------
// Function definitions
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// void delayms(unsigned int ms_sec)
//-----------------------------------------------------------------------------
//
// Return Value : None
// Parameters : ms_sec as a value of delay in milliseconds
//
void delayms(unsigned int ms_sec)
{
unsigned int i,j;
for (i=0;i<ms_sec;i++)
{
for (j=0;j<355;j++) 
	//This loop runs 355 times which approximately gives 1ms delay with 24MHz system clock.
{
//do nothing
}
}
}
//-----------------------------------------------------------------------------
// End Of File
//-----------------------------------------------------------------------------