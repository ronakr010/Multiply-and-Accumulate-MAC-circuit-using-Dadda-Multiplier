module dadda_mult (a,b,x,mult_out,cout);
	input [7:0] a,b;
	input [15:0] x;  ///accumulator
	output [15:0] mult_out; //// mult_out = a*b + c
	output cout; ////// if a*b + c comes of 17 bit
	
	reg pp [7:0][7:0];
	integer i,j;
	
	wire [15:0] badd1,badd2;
	
	wire [45:0] fa, cfa;
	wire [9:0] ha, cha;
	
	wire [31:0] bkung_ip1,bkung_ip2;
	wire [31:0] sum_bkung;
	
	wire cout_bkung;
	
	always @(*) begin
		for (j=0;j<8;j=j+1)
			for (i=0;i<8;i=i+1)
				pp[j][i] <= a[i] & b[j];
	end
	
	////////////////////////////////layer-0 (towards capacity 6)///////////////////////////////////
	half_adder hadd0 (pp[4][1],pp[5][0],ha[0],cha[0]);
	half_adder hadd1 (pp[5][1],pp[6][0],ha[1],cha[1]);
	half_adder hadd2 (pp[6][1],pp[7][0],ha[2],cha[2]);
	half_adder hadd3 (pp[1][7],x[8],ha[3],cha[3]);
	
	full_adder fadd0 (pp[2][4],pp[3][3],pp[4][2],fa[0],cfa[0]);
	full_adder fadd1 (pp[0][7],pp[1][6],pp[2][5],fa[1],cfa[1]);
	full_adder fadd2 (pp[3][4],pp[4][3],pp[5][2],fa[2],cfa[2]);
	full_adder fadd3 (pp[2][6],pp[3][5],pp[4][4],fa[3],cfa[3]);
	full_adder fadd4 (pp[5][3],pp[6][2],pp[7][1],fa[4],cfa[4]);
	full_adder fadd5 (pp[2][7],pp[3][6],pp[4][5],fa[5],cfa[5]);
	full_adder fadd6 (pp[5][4],pp[6][3],pp[7][2],fa[6],cfa[6]);
	full_adder fadd7 (pp[5][5],pp[6][4],pp[7][3],fa[7],cfa[7]);
	
	
////////////////////////////////layer-1 (towards capacity 4)///////////////////////////////////
	half_adder hadd4 (pp[2][1],pp[3][0],ha[4],cha[4]);
	half_adder hadd5 (pp[3][1],pp[4][0],ha[5],cha[5]);
	//half_adder hadd6 (pp[6][5],pp[7][4],ha[6],cha[6]);
	full_adder fadd_new1 (pp[6][5],pp[7][4],cfa[7],ha[6],cha[6]);
	
	full_adder fadd8 (pp[0][4],pp[1][3],pp[2][2],fa[8],cfa[8]);
	full_adder fadd9 (pp[2][3],pp[3][2],ha[0],fa[9],cfa[9]);
	full_adder fadd10 (x[5],pp[0][5],pp[1][4],fa[10],cfa[10]);
	full_adder fadd11 (x[6],pp[0][6],pp[1][5],fa[11],cfa[11]);
	full_adder fadd12 (fa[0],ha[1],cha[0],fa[12],cfa[12]);
	full_adder fadd13 (x[7],fa[1],fa[2],fa[13],cfa[13]);
	full_adder fadd14 (ha[2],cfa[0],cha[1],fa[14],cfa[14]);
	full_adder fadd15 (ha[3],fa[3],fa[4],fa[15],cfa[15]);
	full_adder fadd16 (cfa[1],cfa[2],cha[2],fa[16],cfa[16]);
	full_adder fadd17 (x[9],fa[5],fa[4],fa[17],cfa[17]);
	full_adder fadd18 (cha[3],cfa[3],cfa[4],fa[18],cfa[18]);
	full_adder fadd19 (x[10],pp[3][7],pp[4][6],fa[19],cfa[19]);
	full_adder fadd20 (fa[7],cfa[5],cfa[6],fa[20],cfa[20]);
	full_adder fadd21 (x[11],pp[4][7],pp[5][6],fa[21],cfa[21]);
	full_adder fadd22 (pp[5][7],pp[6][6],pp[7][5],fa[22],cfa[22]);
	
	
	
////////////////////////////////layer-2 (towards capacity 3)///////////////////////////////////
	half_adder hadd7 (pp[1][1],pp[2][0],ha[7],cha[7]);
	//half_adder hadd8 (pp[6][7],pp[7][6],ha[8],cha[8]);
	full_adder fadd_new (pp[6][7],pp[7][6],cfa[22],ha[8],cha[8]);
	
	full_adder fadd23 (pp[0][3],pp[1][2],ha[4],fa[23],cfa[23]);
	full_adder fadd24 (fa[8],ha[5],cha[4],fa[24],cfa[24]);
	full_adder fadd25 (fa[10],cfa[8],cha[5],fa[25],cfa[25]);
	full_adder fadd26 (fa[12],cfa[9],cfa[10],fa[26],cfa[26]);
	full_adder fadd27 (fa[14],cfa[11],cfa[12],fa[27],cfa[27]);
	full_adder fadd28 (fa[16],cfa[13],cfa[14],fa[28],cfa[28]);
	full_adder fadd29 (fa[18],cfa[15],cfa[16],fa[29],cfa[29]);
	full_adder fadd30 (fa[20],cfa[17],cfa[18],fa[30],cfa[30]);
	full_adder fadd31 (ha[6],cfa[19],cfa[20],fa[31],cfa[31]);
	full_adder fadd32 (fa[22],cfa[21],cha[6],fa[32],cfa[32]);
	
////////////////////////////////layer-3 (towards capacity 2)///////////////////////////////////
	half_adder hadd9 (pp[0][1],pp[1][0],ha[9],cha[9]);
	
	full_adder fadd33 (x[2],pp[0][2],ha[7],fa[33],cfa[33]);
	full_adder fadd34 (x[3],fa[23],cha[7],fa[34],cfa[34]);
	full_adder fadd35 (x[4],fa[24],cfa[23],fa[35],cfa[35]);
	full_adder fadd36 (fa[9],fa[25],cfa[24],fa[36],cfa[36]);
	full_adder fadd37 (fa[11],fa[26],cfa[25],fa[37],cfa[37]);
	full_adder fadd38 (fa[13],fa[27],cfa[26],fa[38],cfa[38]);
	full_adder fadd39 (fa[15],fa[28],cfa[27],fa[39],cfa[39]);
	full_adder fadd40 (fa[17],fa[29],cfa[28],fa[40],cfa[40]);
	full_adder fadd41 (fa[19],fa[30],cfa[29],fa[41],cfa[41]);
	full_adder fadd42 (fa[21],fa[31],cfa[30],fa[42],cfa[42]);
	full_adder fadd43 (x[12],fa[32],cfa[31],fa[43],cfa[43]);
	full_adder fadd44 (x[13],ha[8],cfa[32],fa[44],cfa[44]);
	full_adder fadd45 (x[14],pp[7][7],cha[9],fa[45],cfa[45]);

////////////////////////////////layer-4 (towards capacity 2)///////////////////////////////////
	
	assign badd1 = {x[15],fa[45],fa[44],fa[43],fa[42],fa[41],fa[40],fa[39],fa[38],fa[37],fa[36],fa[35],fa[34],
	fa[33],x[1],x[0]};
	assign badd2 = {cfa[45],cfa[44],cfa[43],cfa[42],cfa[41],cfa[40],cfa[39],cfa[38],cfa[37],cfa[36],cfa[35],
	cfa[34],cfa[33],cha[9],ha[9],pp[0][0]};
	
	assign bkung_ip1 = {16'b0,badd1};
	assign bkung_ip2 = {16'b0,badd2};
////////////////////////////////layer-5 (towards final result)///////////////////////////////////
	
	bkung final_add (bkung_ip1, bkung_ip2, 1'b0, sum_bkung, cout_bkung);
	
	assign mult_out = sum_bkung[15:0];
	assign cout = sum_bkung[16];
	
endmodule


module bkung (a, b, cin, s, cout);

input [31:0] a , b;
input cin;
output [31:0] s;
output cout;

wire [32:1] carry;
////////////////propagating_p_and_g///////////////  
wire [31:0] g1, p1;
wire [15:0] g2, p2;
wire [7:0] g3, p3;
wire [3:0] g4, p4;
wire [1:0] g5, p5;
wire g6, p6;
//////////generating_initial_g_carry/////////////
wire g1_carry, g2_carry, g3_carry, g4_carry, g5_carry, g6_carry;

genvar i;

/////////////////level-1/////////////////////////  

and_gate i0 (a[0],b[0],g1_carry);
xor_gate ii0 (a[0],b[0],p1[0]);
or_and_gate iii0 (g1_carry,p1[0],cin,carry[1]);

generate
    for(i = 1; i<32; i=i+1) begin: B1
      and_gate g (a[i],b[i],g1[i]);
	  xor_gate p (a[i],b[i],p1[i]);
    end
endgenerate

/////////////////level-2/////////////////////////  

or_and_gate i1 (g1[1], p1[1],g1[0],g2_carry);
or_and_gate ii1 (g2_carry,p2[0],cin,carry[2]);
and_gate iii1 (p1[1],p1[0],p2[0]);

generate
    for(i = 1; i<16; i=i+1) begin: B2
      or_and_gate g (g1[i*2 + 1],p1[2*i + 1],g1[2*i],g2[i]);
	  and_gate p (p1[2*i + 1],p1[2*i],p2[i]);
    end
endgenerate

/////////////////level-3/////////////////////////  

or_and_gate i2 (g2[1], p2[1],g2[0],g3_carry);
or_and_gate ii2 (g3_carry,p3[0],cin,carry[4]);
and_gate iii2 (p2[1],p2[0],p3[0]);

generate
    for(i = 1; i<8; i=i+1) begin: B3
      or_and_gate g (g2[i*2 + 1],p2[2*i + 1],g2[2*i],g3[i]);
	  and_gate p (p2[2*i + 1],p2[2*i],p3[i]);
    end
endgenerate

/////////////////level-4/////////////////////////  

or_and_gate i3 (g3[1], p3[1],g3[0],g4_carry);
or_and_gate ii3 (g4_carry,p4[0],cin,carry[8]);
and_gate iii3 (p3[1],p3[0],p4[0]);

generate
    for(i = 1; i<4; i=i+1) begin: B4
      or_and_gate g (g3[i*2 + 1],p3[2*i + 1],g3[2*i],g4[i]);
	  and_gate p (p3[2*i + 1],p3[2*i],p4[i]);
    end
endgenerate

/////////////////level-5/////////////////////////  

or_and_gate i4 (g4[1], p4[1],g4[0],g5_carry);
or_and_gate ii4 (g5_carry,p5[0],cin,carry[16]);
and_gate iii4 (p4[1],p4[0],p5[0]);

generate
    for(i = 1; i<2; i=i+1) begin: B5
      or_and_gate g (g4[i*2 + 1],p4[2*i + 1],g4[2*i],g5[i]);
	  and_gate p (p4[2*i + 1],p4[2*i],p5[i]);
    end
endgenerate

/////////////////level-6/////////////////////////  

or_and_gate i5 (g5[1], p5[1],g5[0],g6_carry);
or_and_gate ii5 (g6_carry,p6,cin,carry[32]);
and_gate iii5 (p5[1],p5[0],p6);

//generate
//    for(i = 1; i<2; i++) begin
//      or_and_gate g (g5[i*2 + 1],p5[2*i + 1],g5[2*i],g6[i]);
//	  and_gate p (p5[2*i + 1],p5[2*i],p6[i]);
//    end
//endgenerate

////////////carry_calculation//////////////////
assign g1[0] = carry[1];
assign g2[0] = carry[2];
assign g3[0] = carry[4];
assign g4[0] = carry[8];
assign g5[0] = carry[16];
assign g6 = carry[32];
assign cout = g6;

or_and_gate carry3 (g1[2],p1[2],carry[2],carry[3]);
or_and_gate carry5 (g1[4],p1[4],carry[4],carry[5]);
or_and_gate carry7 (g1[6],p1[6],carry[6],carry[7]);
or_and_gate carry9 (g1[8],p1[8],carry[8],carry[9]);

or_and_gate carry11 (g1[10],p1[10],carry[10],carry[11]);
or_and_gate carry13 (g1[12],p1[12],carry[12],carry[13]);
or_and_gate carry15 (g1[14],p1[14],carry[14],carry[15]);
or_and_gate carry17 (g1[16],p1[16],carry[16],carry[17]);

or_and_gate carry19 (g1[18],p1[18],carry[18],carry[19]);
or_and_gate carry21 (g1[20],p1[20],carry[20],carry[21]);
or_and_gate carry23 (g1[22],p1[22],carry[22],carry[23]);
or_and_gate carry25 (g1[24],p1[24],carry[24],carry[25]);

or_and_gate carry27 (g1[26],p1[26],carry[26],carry[27]);
or_and_gate carry29 (g1[28],p1[28],carry[28],carry[29]);
or_and_gate carry31 (g1[30],p1[30],carry[30],carry[31]);

or_and_gate carry6  (g2[2],p2[2],carry[4],carry[6]);
or_and_gate carry10 (g2[4],p2[4],carry[8],carry[10]);
or_and_gate carry14 (g2[6],p2[6],carry[12],carry[14]);
or_and_gate carry18 (g2[8],p2[8],carry[16],carry[18]);
or_and_gate carry22 (g2[10],p2[10],carry[20],carry[22]);
or_and_gate carry26 (g2[12],p2[12],carry[24],carry[26]);
or_and_gate carry30 (g2[14],p2[14],carry[28],carry[30]);

or_and_gate carry12 (g3[2],p3[2],carry[8],carry[12]);
or_and_gate carry20 (g3[4],p3[4],carry[16],carry[20]);
or_and_gate carry24 (g3[5],p3[5],carry[20],carry[24]);
or_and_gate carry28 (g3[6],p3[6],carry[24],carry[28]);

////////////////sum_calculation/////////////////////////

xor_gate s0 (p1[0],cin,s[0]);
generate
    for(i = 1; i<32; i=i+1) begin: B6
      xor_gate s1 (p1[i],carry[i],s[i]);
    end
endgenerate

endmodule

module xor_gate (input a, input b, output c);
	assign #5 c = a ^ b ;
endmodule


module or_and_gate ( input a, input b, input c, output d);
	assign #5 d = a | ( b & c);
endmodule

module and_gate (input a, input b, output c);
	assign #5 c = a&b;
endmodule

module half_adder (input a, input b, output sum, output cout);
	xor_gate xor0 (a,b,sum);
	and_gate and0 (a,b,cout);

endmodule

module full_adder (input a, input b, input cin, output sum, output cout);
	wire sum0,cout0,cout1,cout2;
	
	xor_gate xor1 (a,b,sum0);
	xor_gate xor2 (sum0,cin,sum);
	
	and_gate and1 (a,b,cout0);
	and_gate and2 (a,cin,cout1);
	and_gate and3 (cin,b,cout2);
	
	assign #5 cout = ( cout0 | cout1 | cout2 );
endmodule
