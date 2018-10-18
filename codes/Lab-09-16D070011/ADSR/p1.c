#include <at89c5131.h>
#include <stdio.h>

void delay(int delay_in_ms);
void SPI_init();
void SPI_send(char onebyte);
void SPI_send2(char hbyte, char lbyte);

unsigned char serial_data;

sbit csb = P3^4;
sbit fs = P3^5;

bit transmit_completed = 0;

void main(void)
{
	SPI_init();
	while(1)
	{
		SPI_send2(0x00,0x00);
		delay(100);
		SPI_send2(0x04,0x00);
		delay(100);
		SPI_send2(0x08,0x00);
		delay(100);
		SPI_send2(0x0F,0xFF);
		delay(100);
	}
}

void delay(int delay_in_ms)
{
	int d=0;
	while(delay_in_ms>0)
	{
		for(d=0;d<382;d++);
		delay_in_ms--;
	}
	return;	
}

void SPI_init()
{
	csb = 1;
	fs = 1;	                  	// DISABLE ADC SLAVE SELECT-CS 
	SPCON |= 0x20;               	 	// P1.1(SSBAR) is available as standard I/O pin 
	SPCON |= 0x01;                	// Fclk Periph/4 AND Fclk Periph=12MHz ,HENCE SCK IE. BAUD RATE=3000KHz 
	SPCON |= 0x10;               	 	// Master mode 
	SPCON |= 0x08;               	// CPOL=1; transmit mode example|| SCK is 0 at idle state
	SPCON &= ~0x04;                	// CPHA=0; transmit mode example 
	IEN1 |= 0x04;                	 	// enable spi interrupt 
	EA=1;                         	// enable interrupts 
	SPCON |= 0x40;                	// run spi;ENABLE SPI INTERFACE SPEN= 1 
//	IPH0 |=0x10;
//	IPL0 |=0x10;
}

void SPI_send(char onebyte)		
{
	transmit_completed = 0;
	SPDAT = onebyte;
	while(!transmit_completed);
	return;
}

void SPI_send2(char hbyte,char lbyte)
{
	fs = 1;
	csb = 0;
	fs = 0;
	SPI_send(hbyte);
	SPI_send(lbyte);
	fs = 1;
	csb = 1;
	return;
}

void it_SPI(void) interrupt 9 /* interrupt address is 0x004B, (Address -3)/8 = interrupt no.*/
{
	switch	( SPSTA )         /* read and clear spi status register */
	{
		case 0x80:	
			serial_data=SPDAT;   /* read receive data */		//needs to be read to clear the trigger
			transmit_completed=1;/* set software flag */
 		break;

		case 0x10:
			
		break;
	
		case 0x40:
		break;
	}
}
