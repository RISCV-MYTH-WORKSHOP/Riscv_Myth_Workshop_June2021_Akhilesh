\m4_TLV_version 1d: tl-x.org
\SV

   // =========================================
   // Welcome!  Try the tutorials via the menu.
   // =========================================
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/bd1f186fde018ff9e3fd80597b7397a1c862cf15/tlv_lib/calculator_shell_lib.tlv'])
   // Default Makerchip TL-Verilog Code Template
   
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   //Link to the Makerchip Sandbox
   //http://makerchip.com/sandbox/0kRfnh0k2/0mwhpYL
   
   |calc
      @1
         //Reset Signal.
         $reset = *reset;
         $valid_chk = ($reset||$valid);
      ?$valid_chk
         @1
            //Value2 and Select signals of MUX are random generated.
            $val2[31:0] = $rand2[3:0];
            $op[1:0] = $rand3[1:0];
            //Calculator Logic-Add, Difference, Multiply, Divide.
            $sum[31:0] = $val1[31:0] + $val2[31:0];
            $diff[31:0] = $val1[31:0] - $val2[31:0];
            $prod[31:0] = $val1[31:0] * $val2[31:0];
            $quot[31:0] = $val1[31:0] / $val2[31:0];
            
            //Output is again fed back to value1
            $val1[31:0] = ( >>2$out[31:0] );
            
            //Valid Bit Circuit:
            //If reset is set counter, starts counting from 1, from next cycle.
            $valid = $reset ? 0 : (1 + (>>1$valid));
            
         @2
            //MUX Circuit:
            //Output is selected as Add, Difference, Multiply, Divide on the basis
            //of select lines. If reset is set, output is 0.
            //if reset = 1, output = 0
            //if op = 0, Add operation
            //if op = 1, difference operation
            //if op = 2, Mutiply operation
            //if op = 3, Divide operation
            //Valid bit and Reset Circuit: ($reset || (!$valid))
            $out[31:0] = $reset ? 0 : (($op[1:0] == 2'b00) ? $sum[31:0] : (($op[1:0] == 2'b01) ? $diff[31:0] : (($op[1:0] == 2'b10) ? $prod[31:0] :$quot[31:0])));
            
         
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
