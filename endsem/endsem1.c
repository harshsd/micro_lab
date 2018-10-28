#include<at89c5131.h>
#include<stdio.h>

unsigned char valStr[5];
unsigned int count,index = 0;
float dat;
float dat_arr[5] = (1.555,3.110,4,665,6.220,7.775);

void init_serial();
void transmit_value(float val);

void main(void)
{
	init_serial();
	while(1)
	{
		index = 0;
		while(index<5)
		{
			transmit_value(1.555);
			transmit_value(3.110);
			transmit_value(4.665);
			transmit_value(6.220);
			transmit_value(7.775);
		}
	}
}

void init_serial()
{
	SCON |= 0xC0;
	TH1 = 204;
	TL1 = 204;
	PCON &= ~(0x80);
	TMOD |= 0x20;
	EA = 1;
	//ES = 1;
	ES = 0;
	ET1 = 0;
	TR1 = 1;
}

void transmit_value(float val)
{
	sprintf(valStr,"%1.3f\n",val);
	count = 0;
	while(count<6)
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
	return;
}
