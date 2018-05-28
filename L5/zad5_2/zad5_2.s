.data
minus: .double -1.0
.text

.global logarytm
.type logarytm, @function

logarytm:

push %rbp
	movq %rsp, %rbp
	
	sub $8, %rsp
	movsd %xmm0, (%rsp)	

	fldl (%rsp)
	fld1	
	fldz
	fld1
	

	#st0 wyraz
	#st1 suma ciagu
	#st2 licznik
	#st3 liczba 

	movq %rdi, %r9

	petla:
		
		
		fmul %st(3), %st #terazniejsza potega x * x
		fld %st		 #skopiowanie potegi i zachowanie jej w st(1) (przesunęcie)		
		
		#st0 wyraz do dodania		
		#st1 potega do nastepnej iteracji
		#st2 suma ciagu
		#st3 licznik
		#st4 liczba 
		
		
		#mianownik	
		fdiv %st(3), %st	
		faddp %st, %st(2)	
		fld1
		faddp %st, %st(3)
		fldl minus
		fmulp %st, %st(1) 

		dec %rdi		
		cmp $0, %rdi
		jg petla
		


	koniec:
	fstp %st
	fstpl (%rsp)
	movsd (%rsp), %xmm0
	movq %rbp, %rsp
	pop %rbp
	ret
	
