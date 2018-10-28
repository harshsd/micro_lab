#include "at89c5131.h"
#include "stdio.h"
sbit RS=P0^0;
sbit RW=P0^1;
sbit EN=P0^2;
void lcd_init(void);
void lcd_cmd(unsigned int i);
void lcd_char(unsigned char ch);
void lcd_write_string(unsigned char *s);
void port_init(void);
sbit led = P1^7;
char sertemp = 'E';
char key ;
void keypad_init(void)
{
      P1=0xF0;
 //     P1|=0x0F;
      KBE=0xF0;  //MOV 0x9D,#0xF0  ;KBE
      KBLS=0x0F;   //MOV 0x9C,#0x0F  ;KBLS
		  KBF=00; //0x9E,#00    ;KBF
				while(KBF);
      IEN1=0x01;   //MOV 0xB1,#0x01  ;IE1
		  EA=1;
}	
void delay_in_ms(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<382;j++);
	}
}

unsigned char read_keypad(void)
{

   unsigned char key=0,row=0,col=0,no=0,no_1=0,temp=0;
	 unsigned int i=0;
	 unsigned char final_val=0;
	
	 P1= 0xF0;
	
   temp=((~P1) & 0xF0)>>4; //row
	 i=0;
	 while(i<=3)
	 {
      if(((temp>>i)&0x01)==1)
      {
				row=i;
				break;
			}
      i++;			
   }
   P1=0x0F;
   temp=((~P1) & 0x0F); //col 
   i=0;
	 while(i<=3)
	 {
      if(((temp>>i) & 0x01)==1)
      {
				col=i;			
				break;
			}
      i++;			
   }
	 //col=i;
	 no=(4*row)+col;
	 //delay_in_ms(15);
	 P1=0xF0;
   temp=((~P1) & 0xF0)>>4; //row 
	 i=0;
	 while(i<=3)
	 {
      if(((temp>>i) & 0x01)==1)
      {
				row=i;	
			  break;
			}
      i++;			
   }
   P1=0x0F;
	 temp=((~P1)&0x0F);
   i=0;
	 while(i<=3)
	 {
      if(((temp>>i) & 0x01)==1)
      {
				col=i;	
				break;
			}
      i++;			
   }	 
	 //col=i;
   no_1=4*row+col;
   if(no==no_1)
	 {
		  final_val=no;
	 }
	 final_val += 48;
   
	 if(final_val > 57 && final_val < 65)
		final_val += 7;
	 
	 P1=0xF0;
	 
	 while(P1!= 0xF0)
	 		 P1= 0xF0;
	 
	  KBF=0x00;
	  while(KBF); //Wait till flag gets cleared
	 	 
	 return final_val;
}	


void delay_ms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<382;d++);
		delay--;
	}
}


int write =1;
int rec = 0;
void isr_serial(void) interrupt 4
{
	EA = 0;
	if(TI == 1)TI = 0;
	if(RI == 1){
		RI = 0;
		rec = 1;
		sertemp = SBUF;
		//if(sertemp == 'Y')write = 1;
		//if(sertemp == 'N')write = 0;
		
	}
	EA = 1;
	return;
}

unsigned char recieve_data(){
	while(RI == 0);
	RI = 0;
	return SBUF;
}

void send_data(unsigned char str){
	if(write == 1){
		ACC = 0;
		ACC = ACC + str;
		TB8 = PSW^0;
		
		SBUF = str;
		//write = 0;
	}
	return;
}

void send_string(char* str, int n){
	int count = 0;
	while(count < n){
		send_data(*str);
		str = str + 1;
		count = count + 1;
	}
}
int pressed = 0;
void Keypad_isr(void) interrupt 7
{
	key = read_keypad();
	pressed = 1;
	send_data(key);
	//lcd_cmd(0x80);
	//lcd_char(key);
}
void init_serial(){
	TMOD = 0x20; //timer 1 mode 2
	SCON = 0xC0;// parity mode,clk from timer,ren disabled
	TH1 = 0xCC;//1200 baud rate
	TH0 = 0xCC;
	TCON |= 0x40;//
	EA = 1;
	ES = 1; //serial interrupts enabled 
	SCON |= 0xD0;
	return;
}


char temp = 0;
char s1[24] = "Press Y to recieve data\n";
char s2[16] = "Press N to stop\n";
void main(){///////////////////////////////////////main
init_serial();
keypad_init();
lcd_init();
while(1){
		//ES = 0;
		send_string(s1,24);
		while(rec == 0);
		temp = sertemp;
		if(temp == 'Y')write = 1;
	w1:while(pressed =0);
		send_string(s2,16);
		ES =1;
		delay_in_ms(2000);
		if(sertemp == 1){
			write = 0;
		}else{
			goto w1;
		}
		
}
}

void msdelay(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<382;j++);
	}
}
void lcd_cmd(unsigned int i)
{
	RS=0;
	RW=0;
	EN=1;
	P2=i;
	msdelay(10);
	EN=0;
}
void lcd_char(unsigned char ch)
{
	RS=1;
	RW=0;
	EN=1;
	P2=ch;
	msdelay(10);
	EN=0;
}
void lcd_write_string(unsigned char *s)
{
	while(*s!='\0')
	{
		lcd_char(*s++);
	}
}
void lcd_init(void)
{
	//port_init();
	lcd_cmd(0x38);
	msdelay(4);
	lcd_cmd(0x06);
	msdelay(4);
	lcd_cmd(0x0C);
	msdelay(4);
	lcd_cmd(0x01);
	msdelay(4);
	lcd_cmd(0x80);
}
void port_init(void)
{
	P2=0x00;
	EN=0;
	RS=0;
	RW=0;
}
	
