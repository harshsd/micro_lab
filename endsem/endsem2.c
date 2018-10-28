#include<at89c5131.h>
#include<stdio.h>

unsigned char valStr[5];

sbit led = P3^7;
float x,y,p,q,i;
float dat;
unsigned int count = 0;

void timer_init();
void init_serial();
void transmit_value(float val);

void main(void)
{
	init_serial();
	x = 0;
	y = 0;
	p = 0;
	q = 2.5;
	timer_init();
	while(1);
}

void init_serial()
{
	SCON |= 0xC0;
	TH1 = 255;
	TL1 = 255;
	PCON &= ~(0x80);
	TMOD |= 0x20;
	EA = 1;
	//ES = 1;
	ES = 0;
	ET1 = 0;
	TR1 = 1;
}

void timer_init()
{
	TMOD |= 0x01;
	TH0 = 0xD5;//CF
	TL0 = 0x2C;//2C
	ET0 = 1;
	EA = 1;
	led = 0;
	TR0 = 1;
}

void Timer0_ISR(void) interrupt 1
{
	TR0 = 0;
	x = ((0.98078)*p) + ((0.19509)*q);
	y = ((0.98078)*q) - ((0.19509)*p);
	p = x;
	q = y;
	i = p+2.5;
	transmit_value(i);
	TH0 = 0xD5;
	TL0 = 0x1C;
	led = ~led;
	TR0 = 1;
}

void transmit_value(float val)
{
	sprintf(valStr,"%1.3f\n",val);
	count = 0;
	while(count<5)
	{
		dat = valStr[count];
		ACC = 0;
		ACC = ACC + dat;
		TB8 = PSW^0;
		SBUF = dat;
		while (TI==0);
		TI = 0;
		count = count + 1;
	}
	dat = '\n';
	ACC = 0;
	ACC = ACC + dat;
	TB8 = PSW^0;
	SBUF = dat;
	while(TI==0);
	TI = 0;
	return;
}