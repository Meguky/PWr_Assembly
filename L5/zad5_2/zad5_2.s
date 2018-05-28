.data

.text

.global log
.type log, @function

log:
   	push %rbp
	movq %rsp, %rbp

	movq %rdi, %r8
	movq %rsi, %r9

	movq $0, %rsi
	petla:
	
		cmp %rsi, %r9
		je koniec
		inc %rsi
		g
	

	movq %rbp, %rsp
	pop %rbp
	ret
