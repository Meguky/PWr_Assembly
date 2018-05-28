.data
status_word: .short 0
control_word: .short 0
.text

.global sprawdz, zmiana, dzielenie
.type sprawdz, @function
.type zmiana, @function
.type dzielenie, @function

sprawdz:
   	push %rbp
	movq %rsp, %rbp

	movq $0, %rax
	fstcw control_word
	movq control_word, %rax

	and $0x3F, %rax

	movq %rbp, %rsp
	pop %rbp
	ret

zmiana:
	push %rbp
	movq %rsp, %rbp

	movq $0, %rax
	fstcw control_word
	movq control_word, %rax

	cmp $0, %rdi
	jl koniec	
	je niepoprawna_operacja
	cmp $1, %rdi
	je zdenormalizowany_operand
	cmp $2, %rdi
	je dzielenie_przez_zero
	cmp $3, %rdi
	je overflow
	cmp $4, %rdi
	je underflow
	cmp $5, %rdi
	je blad_precyzji
 	jg koniec

	niepoprawna_operacja:
	xor $0x1, %rax
	jmp koniec

	zdenormalizowany_operand:
	xor $0x2, %rax
	jmp koniec

	dzielenie_przez_zero:
	xor $0x4, %rax
	jmp koniec

	overflow:
	xor $0x8, %rax
	jmp koniec

	underflow:
	xor $0x10, %rax
	jmp koniec

	blad_precyzji:
	xor $0x20, %rax
	jmp koniec

	koniec:
	
	movq %rax, control_word
	fldcw control_word

	movq %rbp, %rsp
	pop %rbp
	ret	

dzielenie:
	push %rbp
	movq %rsp, %rbp
	
	fldz
	fldz
	fdiv %st(1), %st(0)
	
	movq $0, %rax
	fstsw status_word
	movq status_word, %rax

	and $0x3F, %rax	

	movq %rbp, %rsp
	pop %rbp
	ret

	

