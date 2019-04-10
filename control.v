module control(clk_100mhz, clk_100hz, rst_n, sw_en, pause, clear, time_sec_h, time_sec_l, time_msec_h, time_msec_l, time_out);

input clk_100hz, rst_n, sw_en, pause, clear;
output time_sec_h, time_sec_l, time_msec_h, time_msec_l, time_out;

wire clk_100hz, rst_n, sw_en, pause, clear;
reg time_out, sw_en_1, pause_1;
reg [2 : 0] time_sec_h, time_sec_h_1;
reg [3 : 0] time_sec_l, time_sec_l_1;
reg [3 : 0] time_msec_h, time_msec_h_1;
reg [3 : 0] time_msec_l, time_msec_l_1;

always @(posedge clk_100hz OR negedge rst_n) BEGIN
//time_msec_l
IF (!rst_n)
 time_msec_l_1 <= 4'b0;
 ELSE
	 BEGIN
		 IF (sw_en_1) BEGIN
		 IF (time_msec_l_1 == 4'b1001)
			 time_msec_l_1 <= 4'b0;
		 ELSE
			 time_msec_l_1 <= time_msec_l + 4'b0001;
		 END
		 ELSE IF (clear)
			 time_msec_l_1 <= 4'b0;
		 END
	 END

	 always @(posedge clk_100hz OR negedge rst_n) BEGIN
	 //time_msec_h
	 IF (!rst_n)
		 time_msec_h_1 <= 4'b0;
	 ELSE BEGIN
		 IF (sw_en_1) BEGIN
		 IF (time_msec_h_1 == 4'b1001 & & time_msec_l_1 == 4'b1001)
			 time_msec_h_1 <= 4'b0;
		 ELSE IF (time_msec_l_1 == 4'b1001)
			 time_msec_h_1 <= time_msec_h_1 + 4'b0001;
		 END
		 ELSE IF (clear)
			 time_msec_h_1 <= 4'b0;
		 END
	 END

	 always @(posedge clk_100hz OR negedge rst_n) BEGIN
	 //time_sec_l
	 IF (!rst_n)
		 time_sec_l_1 <= 4'b0;
	 ELSE BEGIN
		 IF (sw_en_1) BEGIN
		 IF (time_sec_l_1 == 4'b1001 & & time_msec_h_1 == 4'b1001 & & time_msec_l_1 == 4'b1001)
			 time_sec_l_1 <= 4'b0;
		 ELSE IF (time_msec_h_1 == 4'b1001)
			 time_sec_l_1 <= time_sec_l_1 + 4'b0001;
		 END
		 ELSE IF (clear)
			 time_sec_l_1 <= 4'b0;
		 END
	 END

	 always @(posedge clk_100hz OR negedge rst_n) BEGIN
	 //time_sec_h
	 IF (!rst_n)
		 time_sec_h_1 <= 3'b0;
	 ELSE BEGIN
		 IF (sw_en_1) BEGIN
		 IF (time_sec_h_1 == 3'b101 & & time_sec_l_1 == 4'b1001 & & time_msec_h_1 == 4'b1001 & & time_msec_l_1 == 4'b1001)
			 time_sec_h_1 <= 3'b0;
		 ELSE IF (time_sec_l_1 == 4'b1001)
			 time_sec_h_1 <= time_sec_h_1 + 4'b0001;
		 END
		 ELSE IF (clear)
			 time_sec_h_1 <= 4'b0;
		 END
	 END

	 always @(posedge sw_en OR negedge rst_n) BEGIN
	 IF (!rst_n)
		 sw_en_1 = 1'b0;
	 ELSE
		 sw_en_1 = ~sw_en_1;
	 END

	 always @(posedge pause OR negedge rst_n) BEGIN
	 IF (!rst_n)
		 pause_1 = 1'b0;
	 ELSE
		 pause_1 = ~pause_1;
	 END

	 always @(posedge pause_1)BEGIN
	 IF (!pause_1)
		 time_sec_h, time_sec_l, time_msec_h, time_msec_l} = {time_sec_h_1, time_sec_l_1, time_msec_h_1, time_msec_l_1};
	 END

	 always @(posedge clk_100hz OR negedge rst_n) BEGIN
	 IF (!rst_n)
		 time_out <= 1'b0;
	 ELSE IF ({time_sec_h_1, time_sec_l_1, time_msec_h_1, time_msec_l_1} == {3'b101, 4'b1001, 4'b1001, 4'b1001})
		 time_out <= 1'b0;
	 ELSE IF ({time_sec_h_1, time_sec_l_1, time_msec_h_1, time_msec_l_1} == {3'b001, 4'b0000, 4'b0000, 4'b0000})
		 time_out <= 1'b1;
	 END

	 endmodule