volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */

unsigned char pixel_list[] = {
#include "../misc/pixels.txt"
};
unsigned num_pixels = sizeof(pixel_list)/2;
void vga_plot(unsigned x, unsigned y, unsigned colour)
{
    *vga = ((x & 0b11111111) << 16)|((y & 0b1111111) << 24)|(colour & 0b11111111);
}

int main()
{	
	unsigned char x,y,colour;
	for (int i  = 0; i < num_pixels; i+=1)
	{
		x = pixel_list[2*i];
		y = pixel_list[2*i+1];
		colour = 255;
		vga_plot(x,y,colour);
	}

	for (int i  = 0; i < num_pixels; i+=1)
	{
		unsigned char temp_x, temp_y;
		x = pixel_list[2*i];
		y = pixel_list[2*i+1];
		if(x < 80) temp_x = 80 - x;
		else temp_x = x - 80;

		if(y < 60) temp_y = 60 - y;
		else temp_y = y - 60;

		colour = 255 - 2*(temp_x + temp_y);

		if(colour < 0) colour = 0;
		vga_plot(x,y,colour);
	}
}
