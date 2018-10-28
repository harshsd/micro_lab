#include "at89c5131.h"
#include "stdio.h"
#include " lcd_test.c "


int flag=0;
int flag1=1;
sbit parity = PSW^0;
sbit LED = P1^4;
unsigned char read_keypad(void) ;
void delay_in_ms(unsigned int time);
void keypad_init(void);
unsigned char final_val=0;

   unsigned char key=0,row=0,col=0,no=0,no_1=0,temp=0;
	 unsigned int i=0;
	
void init_serial(void);

int main(){
	P1=0xf0;
keypad_init();
lcd_init();
port_init();
init_serial();	
	while(1);
}

void keypad_isr(void) interrupt 8
{
		
	unsigned char k=read_keypad();
	
	flag1=1;
	
	
	//lcd_cmd(0x80);
	lcd_char(k);
  //lcd_char('k');	
	//delay_in_ms(10);
	if(flag==1){
	
		if(flag1==1)
			
		{	
			TB8 = parity;

			SBUF=k;
			
		
		}
		

	}

	
	
	
	}

void ISR_Serial(void) interrupt 4
{
	unsigned char dat=0;
	if(TI == 1 && flag1==1)
	{
	TI = 0;
	flag1=0;
	}
	
	
	else if(RI==1){
	dat=SBUF;
	
		if(dat=='y'||dat=='Y'){
		flag=1;
			IEN1=0x01;
     lcd_cmd(0xc0);
			lcd_char('y');
		}
		
		else if(dat=='n'||dat=='N'){
		flag=0;
						IEN1=0x00;
    lcd_cmd(0xc0);
			lcd_char('n');
		}
	RI=0;

	}
	else{
	
	TI=0;
	
	}
}
void init_serial()
{
	TMOD |= 0x20;		
	
	TH1 = 0xCC;			

	
	SCON = 0xD0;
	
	
	ES = 1;				
	ET1 = 0;			
	EA = 1;				
	TR1 = 1;
	}

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
	 delay_in_ms(15);
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
	 
	 while(P1!= 0xF0);
	 //{ P1= 0xF0;}

	 
	  KBF=0x00;
	  while(KBF); //Wait till flag gets cleared
	 	 
	 return final_val;
}