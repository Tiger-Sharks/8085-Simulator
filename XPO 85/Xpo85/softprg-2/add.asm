          cpu 8085
          org 6940h
          lhld 2100h
          mov a,h   ; move 1st 16 bits num in register a & b
		  mov b,l
		  lhld 2102h
		  mov d,h   ; move 2nd 16 bits num in register d & e
		  mov e,l
		  add d     ; add 1st 8 bits num
		  mov h,a   
		  mov a,b
		  adc e     ; add 2nd 8 bits num with carry from previous addition
		  mov l,a
		  shld 2104h; store the results at memory location
		  rst 1
          
