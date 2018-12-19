module control(clk_100mhz,clk_100hz,rst_n,sw_en,pause,clear,time_sec_h,time_sec_l,time_msec_h,time_msec_l,time_out);

	input clk_100hz,rst_n,sw_en,pause,clear;
	output time_sec_h,time_sec_l,time_msec_h,time_msec_l,time_out;

	wire clk_100hz,rst_n,sw_en,pause,clear;
	reg time_out,sw_en_1,pause_1;
	reg [2:0] time_sec_h,time_sec_h_1;
	reg [3:0] time_sec_l,time_sec_l_1;
	reg [3:0] time_msec_h,time_msec_h_1;
	reg [3:0] time_msec_l,time_msec_l_1;

	always @(posedge clk_100hz or negedge rst_n) begin //time_msec_l
		if (!rst_n)
			time_msec_l_1<=4'b0;
		else begin 
			if (sw_en_1) begin
			if (time_msec_l_1==4'b1001)
				time_msec_l_1<=4'b0;
			else 
				time_msec_l_1<=time_msec_l+4'b0001;
			end
			else if(clear)
				time_msec_l_1<=4'b0;
		end
	end

	always @(posedge clk_100hz or negedge rst_n) begin //time_msec_h
		if (!rst_n)
			time_msec_h_1<=4'b0;
		else begin
			if (sw_en_1) begin 
			if (time_msec_h_1==4'b1001 && time_msec_l_1==4'b1001)
				time_msec_h_1<=4'b0;
			else if(time_msec_l_1==4'b1001)
				time_msec_h_1<=time_msec_h_1+4'b0001;
			end
			else if(clear)
				time_msec_h_1<=4'b0;
		end
	end

	always @(posedge clk_100hz or negedge rst_n) begin //time_sec_l
		if (!rst_n)
			time_sec_l_1<=4'b0;
		else begin
			if (sw_en_1) begin 
			if (time_sec_l_1==4'b1001 && time_msec_h_1==4'b1001 && time_msec_l_1==4'b1001)
				time_sec_l_1<=4'b0;
			else if(time_msec_h_1==4'b1001)
				time_sec_l_1<=time_sec_l_1+4'b0001;
			end
			else if(clear)
				time_sec_l_1<=4'b0;
		end
	end

	always @(posedge clk_100hz or negedge rst_n) begin //time_sec_h
		if (!rst_n)
			time_sec_h_1<=3'b0;
		else begin
			if (sw_en_1) begin
			if (time_sec_h_1==3'b101 && time_sec_l_1==4'b1001 && time_msec_h_1==4'b1001 && time_msec_l_1==4'b1001)
				time_sec_h_1<=3'b0;
			else if(time_sec_l_1==4'b1001)
				time_sec_h_1<=time_sec_h_1+4'b0001;
			end
			else if (clear)
				time_sec_h_1<=4'b0;
		end
	end

	always @(posedge sw_en or negedge rst_n) begin
		if(!rst_n)
			sw_en_1=1'b0;
		else 
			sw_en_1=~sw_en_1;
	end

	always @(posedge pause or negedge rst_n) begin
		if(!rst_n)
			pause_1=1'b0;
		else 
			pause_1=~pause_1;
	end

	always @(posedge pause_1)begin
		if(!pause_1)
			{time_sec_h,time_sec_l,time_msec_h,time_msec_l}={time_sec_h_1,time_sec_l_1,time_msec_h_1,time_msec_l_1};
	end

	always @(posedge clk_100hz or negedge rst_n) begin
		if (!rst_n)
			time_out<=1'b0;
		else if ({time_sec_h_1,time_sec_l_1,time_msec_h_1,time_msec_l_1}=={3'b101,4'b1001,4'b1001,4'b1001})
			time_out<=1'b0;
		else if ({time_sec_h_1,time_sec_l_1,time_msec_h_1,time_msec_l_1}=={3'b001,4'b0000,4'b0000,4'b0000})
			time_out<=1'b1;
	end

endmodule