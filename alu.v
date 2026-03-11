`include "ctrl_encode_def.v"

module alu(A, B, ALUOp, C, Zero);
   input  signed [31:0] A, B;
   input         [4:0]  ALUOp;
   output signed [31:0] C;
   output Zero;  //condition flag: set if condition is true for B-type instruction
   
   reg [31:0] C;
   integer    i;
       
   always @( * ) begin
      case ( ALUOp )
      `ALUOp_lui:C=B;
      `ALUOp_add:C=A+B; 
      `ALUOp_sub:C=A-B;  //and beq
      `ALUOp_xor:C=A^B;
      `ALUOp_or:C=A|B;
      `ALUOp_and:C=A&B;
      `ALUOp_sll:C=A<<B;
      `ALUOp_srl:C=A>>B;
      `ALUOp_sra:C=A>>>B;
      //`ALUOp_beq: C = A - B; // Zero = 1 作为 branch flag, b系列指令C的取值和条件真值相反
      `ALUOp_bne: C = (A == B) ? 32'b1 : 32'b0; // 明确一点写明 32 位
      `ALUOp_blt: C = (A >= B) ? 32'b1 : 32'b0;
      `ALUOp_bge: C = (A <= B) ? 32'b1 : 32'b0;
      `ALUOp_bltu: C = ($unsigned(A) >= $unsigned(B)) ? 32'b1 : 32'b0;
      `ALUOp_bgeu: C = ($unsigned(A) <= $unsigned(B)) ? 32'b1 : 32'b0;
      `ALUOp_slt: C = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
      `ALUOp_sltu: C = ($unsigned(A) < $unsigned(B)) ? 32'b1 : 32'b0;
      default: C=A;
      endcase
   end // end always
   
   assign Zero = (C == 32'b0);  

endmodule