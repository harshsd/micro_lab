#include<at89c5131.h>
#include<stdio.h>
//#include<reg51.h>
#include<Keypad_Updated.c>
void t1config();
void init_serial();
//void msdelay(unsigned int time);

unsigned char serial_data;

sbit parity = PSW^0;
sbit LED = P1^7;

void main()
{	
	keypad_init();
	port_init();
	lcd_init();
	//P1 = 0;
	serial_data = 0x75;
	init_serial();
	while(1)
	{
		lcd_init();
		msdelay(4);
		lcd_cmd(0x80);
		msdelay(4);
		lcd_char(serial_data);
		msdelay(100);
	}
}

void intr() interrupt 7
{
		serial_data = read_keypad();	
		lcd_init();
	  msdelay(4);
	  lcd_cmd(0x80);
	  msdelay(4);
	  lcd_write_string("Key is:");
	  msdelay(4);
	  lcd_char(serial_data);
	  msdelay(100);
}

// //void msdelay(unsigned int time)
// {
// 	int i,j;
// 	for(i=0;i<time;i++)
// 	{
// 		for(j=0;j<382;j++);
// 	}
	
// }

void t1config()
{
	TH1 = 204;//Value for 1200 baud rate
	TL1 = 204;//Same as above
	TMOD |= 0x20;
	TR1 = 1;
	//IE &= 0xF7;
	//IE |= 0x90;//Start interupts by setting EA ES and ET1
	EA =1;
	ES = 1;
	ET1 = 0;
}

void init_serial()	
{
	SCON |= 0xC0; //set bits SM0 and SM1 and clear the others.
	SBUF = serial_data;
	ACC = serial_data;
	ACC+=0;
	TB8 = ~parity;
	t1config(); //Call t1 config here. This sets up serial communication
	//REN = 1;	//Comment this if you are facing errors
}

void serial_isr(void) interrupt 4
{
	//msdelay(500);
	if(TI == 1)	//Check if previous transmission complete
	{
		SBUF = serial_data;
		ACC = serial_data;
		ACC += 0;
		TB8 = ~parity;
		//LED = ~LED;
		TI = 0;
	}

}
