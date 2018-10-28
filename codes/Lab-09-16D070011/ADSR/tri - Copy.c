#include <at89c5131.h>
#include <stdio.h>

void delay(int delay_in_ms);
void SPI_init();
void SPI_send(char onebyte);
void SPI_send2(char hbyte, char lbyte);
void Timer_Init();

unsigned char low,high,serial_data;

sbit csb = P3^4;
sbit fs = P3^5;

unsigned int list1[] = {2047, 2831, 3495, 3939, 4095, 3939, 3495, 2831, 2047, 1263, 599, 155, 0, 155, 599, 1263, 2047};
bit rising = 1;
bit transmit_completed = 0;

unsigned int c,t=0;

void main(void)
{
	Timer_Init();
	SPI_init();
	while(1)
	{
		SPI_send2(high,low);
		//delay(10);
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

void Timer_Init()
{
	// Set Timer0 to work in up counting 16 bit mode. Counts upto 
	// 65536 depending upon the calues of TH0 and TL0
	// The timer counts 65536 processor cycles. A processor cycle is 
	// 12 clocks. FOr 24 MHz, it takes 65536/2 uS to overflow
    
	TH0 = 0x48;//Initialize TH0
	TL0 = 0xe4;//Initialize TL0
	TMOD = 0x01;//Configure TMOD 
	ET0 = 1;//Set ET0
	TR0 = 1;//Set TR0
}

void Timer0_ISR(void) interrupt 1
{
	TR0 = 0;
	TH0 = 0xFE;
	TL0 = 0x20;
	if(t<15)
		{	t=t+1;c=list1[t];}
	else
		{t=0;c=list1[t];}
	
	high = (c/256)/2;
	low = (c%256)/2;
	TR0 = 1;
}