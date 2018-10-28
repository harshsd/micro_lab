#include <at89c5131.h>
#include <stdio.h>
#include <lcd_test.c>

void setup();

unsigned int overflow = 0;
unsigned int lower_bit = 0;
unsigned int upper_bit = 0;
unsigned int t=0;


void main()
{
	setup();

	while(1)
	{
		lcd_init();
		lcd_cmd(0x80);
		lcd_char(overflow);
		lcd_cmd(0x85);
		lcd_char(upper_bit);
		lcd_cmdkjl(0x88);
		lcd_char(lower_bit);
		msdelay(1);

	}

}

void setup()
{
	//ie = 0x83;
	EA = 1;
	IT0 = 1;
	ET0 = 1;
	TMOD = 0x09;
	IT0 = 1;
	TR0 = 1;
}

void timer_isr(void) interrupt 1
{
	TR0 = 0;
	t +=1;
	TH0 = 0;
	TL0 = 0;
	TR0 = 1;
}

void interrupt_isr(void) interrupt 0
{
	TR0 = 0;
	lower_bit = TL0;
	upper_bit = TH0;
	overflow = t;
	TL0 = 0;
	TH0 = 0;
	t = 0;
	TR0 = 1;
}