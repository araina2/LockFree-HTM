	.file	"bst_mcas.c"
	.text
	.p2align 4,,15
	.type	_ZL8get_ptstv.part.1, @function
_ZL8get_ptstv.part.1:
.LFB87:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movl	$30, %edi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	sysconf
	movslq	%eax, %rbx
	movl	$32, %eax
	movl	$1, %edi
	cmpq	$32, %rbx
	cmovb	%rax, %rbx
	movq	%rbx, %rsi
	call	calloc
	testq	%rax, %rax
	je	.L3
	movq	%rbx, %rsi
	movl	$1, %edi
	call	calloc
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L3
	movq	%rbx, %rsi
	movl	$1, %edi
	call	calloc
	testq	%rax, %rax
	je	.L3
	.p2align 4,,10
	.p2align 3
.L11:
	movl	_ZL14next_thread_id(%rip), %edx
	leal	1(%rdx), %ecx
	movl	%edx, %eax
	lock cmpxchgl	%ecx, _ZL14next_thread_id(%rip)
	cmpl	%eax, %edx
	jne	.L11
	movl	%edx, 0(%rbp)
	movl	$40960, %esi
	movl	$1, %edi
	call	calloc
	testq	%rax, %rax
	je	.L3
	movl	_ZL13mcas_ptst_key(%rip), %edi
	movq	%rax, 16(%rbp)
	addq	$40960, %rax
	movq	%rax, 24(%rbp)
	movq	%rbp, %rsi
	call	pthread_setspecific
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L3:
	.cfi_restore_state
	call	abort
	.cfi_endproc
.LFE87:
	.size	_ZL8get_ptstv.part.1, .-_ZL8get_ptstv.part.1
	.p2align 4,,15
	.type	_ZL10mcas_fixupPPvS_, @function
_ZL10mcas_fixupPPvS_:
.LFB75:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	%esi, %eax
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	andl	$3, %eax
	movq	%rdi, %rbp
	movl	$1, %r12d
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	cmpl	$3, %eax
	je	.L93
	.p2align 4,,10
	.p2align 3
.L20:
	cmpl	$2, %eax
	jne	.L72
	movq	%rsi, %rax
	andq	$-4, %rax
	movq	(%rax), %rbx
	movl	1032(%rbx), %edx
	leaq	1032(%rbx), %rcx
	jmp	.L52
	.p2align 4,,10
	.p2align 3
.L73:
	movl	%eax, %edx
.L52:
	leal	2(%rdx), %edi
	movl	%edx, %eax
	lock cmpxchgl	%edi, (%rcx)
	cmpl	%eax, %edx
	jne	.L73
	cmpq	0(%rbp), %rsi
	je	.L53
	movl	1032(%rbx), %edx
	jmp	.L55
	.p2align 4,,10
	.p2align 3
.L74:
	movl	%eax, %edx
.L55:
	movl	%edx, %esi
	movl	%edx, %eax
	subl	$2, %esi
	cmove	%r12d, %esi
	lock cmpxchgl	%esi, (%rcx)
	cmpl	%eax, %edx
	jne	.L74
	cmpl	$2, %edx
	je	.L94
.L56:
	movq	0(%rbp), %rsi
	movl	%esi, %eax
	andl	$3, %eax
	cmpl	$3, %eax
	jne	.L20
.L93:
	movq	%rsi, %r13
	andq	$-4, %r13
	movl	1032(%r13), %edx
	leaq	1032(%r13), %rbx
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L69:
	movl	%eax, %edx
.L21:
	leal	2(%rdx), %ecx
	movl	%edx, %eax
	lock cmpxchgl	%ecx, (%rbx)
	cmpl	%eax, %edx
	jne	.L69
	cmpq	0(%rbp), %rsi
	je	.L22
	movl	1032(%r13), %edx
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L70:
	movl	%eax, %edx
.L24:
	movl	%edx, %ecx
	movl	%edx, %eax
	subl	$2, %ecx
	cmove	%r12d, %ecx
	lock cmpxchgl	%ecx, (%rbx)
	cmpl	%eax, %edx
	jne	.L70
	cmpl	$2, %edx
	jne	.L56
	movl	_ZL13mcas_ptst_key(%rip), %edi
	call	pthread_getspecific
	testq	%rax, %rax
	je	.L95
.L26:
	movq	8(%rax), %rdx
	movq	%rdx, 1040(%r13)
	movq	%r13, 8(%rax)
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L94:
	movl	_ZL13mcas_ptst_key(%rip), %edi
	call	pthread_getspecific
	testq	%rax, %rax
	je	.L96
.L57:
	movq	8(%rax), %rdx
	movq	%rdx, 1040(%rbx)
	movq	%rbx, 8(%rax)
	jmp	.L56
.L72:
	xorl	%eax, %eax
.L18:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L53:
	.cfi_restore_state
	movl	(%rbx), %eax
	testl	%eax, %eax
	je	.L97
	movl	4(%rbx), %edi
	testl	%edi, %edi
	jle	.L75
	xorl	%eax, %eax
	cmpq	1048(%rbx), %rbp
	leaq	1072(%rbx), %rdx
	jne	.L63
	jmp	.L98
	.p2align 4,,10
	.p2align 3
.L64:
	addq	$24, %rdx
	cmpq	-24(%rdx), %rbp
	je	.L61
.L63:
	addl	$1, %eax
	cmpl	%eax, %edi
	jne	.L64
.L75:
	xorl	%edx, %edx
.L60:
	movq	%rsi, %rax
	lock cmpxchgq	%rdx, 0(%rbp)
.L59:
	movl	1032(%rbx), %edx
	movl	$1, %edi
	jmp	.L66
	.p2align 4,,10
	.p2align 3
.L77:
	movl	%eax, %edx
.L66:
	movl	%edx, %esi
	movl	%edx, %eax
	subl	$2, %esi
	cmove	%edi, %esi
	lock cmpxchgl	%esi, (%rcx)
	cmpl	%eax, %edx
	jne	.L77
	cmpl	$2, %edx
	je	.L99
.L91:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L96:
	.cfi_restore_state
	call	_ZL8get_ptstv.part.1
	jmp	.L57
.L22:
	movl	_ZL13mcas_ptst_key(%rip), %edi
	call	pthread_getspecific
	testq	%rax, %rax
	je	.L100
.L28:
	movl	0(%r13), %edx
	cmpl	$1, %edx
	je	.L101
	cmpl	$2, %edx
	je	.L102
	movslq	(%rax), %rax
	movq	%r13, %r12
	orq	$3, %r12
	leaq	8(%r13,%rax,8), %rbp
	orq	$2, %rbp
.L36:
	movl	4(%r13), %edi
	testl	%edi, %edi
	jle	.L90
	leaq	1048(%r13), %rdx
	xorl	%ecx, %ecx
	jmp	.L43
	.p2align 4,,10
	.p2align 3
.L39:
	movl	0(%r13), %esi
	testl	%esi, %esi
	jne	.L103
	cmpq	%rax, %r12
	je	.L41
	movq	(%rdx), %rsi
	movq	%rbp, %rax
	lock cmpxchgq	%r12, (%rsi)
.L41:
	addl	$1, %ecx
	addq	$24, %rdx
	cmpl	%ecx, %edi
	je	.L90
.L43:
	movq	(%rdx), %rsi
	movq	8(%rdx), %rax
	lock cmpxchgq	%rbp, (%rsi)
	cmpq	8(%rdx), %rax
	je	.L39
	cmpq	%rax, %rbp
	je	.L39
	cmpq	%rax, %r12
	je	.L39
	movslq	%ecx, %rcx
	movq	%rax, %rsi
	leaq	(%rcx,%rcx,2), %rdx
	movq	1048(%r13,%rdx,8), %rdi
	call	_ZL10mcas_fixupPPvS_
	testl	%eax, %eax
	jne	.L36
	movl	$2, %edx
	jmp	.L38
	.p2align 4,,10
	.p2align 3
.L98:
	xorl	%eax, %eax
.L61:
	cltq
	leaq	(%rax,%rax,2), %rax
	movq	1056(%rbx,%rax,8), %rdx
	jmp	.L60
.L103:
	movslq	%ecx, %rcx
	leaq	(%rcx,%rcx,2), %rax
	leaq	0(%r13,%rax,8), %rax
	movq	1048(%rax), %rdx
	movq	1056(%rax), %rcx
	movq	%rbp, %rax
	lock cmpxchgq	%rcx, (%rdx)
.L90:
	movl	$1, %edx
.L38:
	xorl	%eax, %eax
	lock cmpxchgl	%edx, 0(%r13)
	cmpl	$1, 0(%r13)
	je	.L44
	movl	4(%r13), %ecx
	testl	%ecx, %ecx
	jle	.L32
	leaq	1048(%r13), %rdx
	xorl	%ecx, %ecx
.L47:
	movq	(%rdx), %rsi
	movq	8(%rdx), %rdi
	movq	%r12, %rax
	lock cmpxchgq	%rdi, (%rsi)
	addl	$1, %ecx
	addq	$24, %rdx
	cmpl	%ecx, 4(%r13)
	jg	.L47
.L32:
	movl	1032(%r13), %edx
	movl	$1, %esi
	jmp	.L31
	.p2align 4,,10
	.p2align 3
.L71:
	movl	%eax, %edx
.L31:
	movl	%edx, %ecx
	movl	%edx, %eax
	subl	$2, %ecx
	cmove	%esi, %ecx
	lock cmpxchgl	%ecx, (%rbx)
	cmpl	%eax, %edx
	jne	.L71
	cmpl	$2, %edx
	jne	.L91
	movl	_ZL13mcas_ptst_key(%rip), %edi
	call	pthread_getspecific
	testq	%rax, %rax
	je	.L104
.L51:
	movq	8(%rax), %rdx
	movq	%rdx, 1040(%r13)
	movq	%r13, 8(%rax)
	jmp	.L91
.L97:
	movq	%rbx, %rdx
	movq	%rsi, %rax
	orq	$3, %rdx
	lock cmpxchgq	%rdx, 0(%rbp)
	jmp	.L59
.L95:
	call	_ZL8get_ptstv.part.1
	jmp	.L26
.L99:
	movl	_ZL13mcas_ptst_key(%rip), %edi
	call	pthread_getspecific
	testq	%rax, %rax
	je	.L105
.L68:
	movq	8(%rax), %rdx
	movq	%rdx, 1040(%rbx)
	movq	%rbx, 8(%rax)
	movl	$1, %eax
	jmp	.L18
.L44:
	movl	4(%r13), %edx
	testl	%edx, %edx
	jle	.L32
	leaq	1048(%r13), %rdx
	xorl	%ecx, %ecx
.L46:
	movq	(%rdx), %rsi
	movq	16(%rdx), %rdi
	movq	%r12, %rax
	lock cmpxchgq	%rdi, (%rsi)
	addl	$1, %ecx
	addq	$24, %rdx
	cmpl	%ecx, 4(%r13)
	jg	.L46
	jmp	.L32
.L102:
	movl	4(%r13), %r8d
	movq	%r13, %rdi
	orq	$3, %rdi
	testl	%r8d, %r8d
	jle	.L32
	leaq	1048(%r13), %rdx
	xorl	%ecx, %ecx
.L35:
	movq	(%rdx), %rsi
	movq	8(%rdx), %r8
	movq	%rdi, %rax
	lock cmpxchgq	%r8, (%rsi)
	addl	$1, %ecx
	addq	$24, %rdx
	cmpl	%ecx, 4(%r13)
	jg	.L35
	jmp	.L32
.L101:
	movl	4(%r13), %r9d
	movq	%r13, %rdi
	xorl	%ecx, %ecx
	orq	$3, %rdi
	leaq	1048(%r13), %rdx
	testl	%r9d, %r9d
	jle	.L32
.L84:
	movq	(%rdx), %rsi
	movq	16(%rdx), %r8
	movq	%rdi, %rax
	lock cmpxchgq	%r8, (%rsi)
	addl	$1, %ecx
	addq	$24, %rdx
	cmpl	%ecx, 4(%r13)
	jg	.L84
	jmp	.L32
	.p2align 4,,10
	.p2align 3
.L100:
	call	_ZL8get_ptstv.part.1
	jmp	.L28
.L105:
	call	_ZL8get_ptstv.part.1
	jmp	.L68
.L104:
	call	_ZL8get_ptstv.part.1
	jmp	.L51
	.cfi_endproc
.LFE75:
	.size	_ZL10mcas_fixupPPvS_, .-_ZL10mcas_fixupPPvS_
	.p2align 4,,15
	.globl	_Z9mcas_initv
	.type	_Z9mcas_initv, @function
_Z9mcas_initv:
.LFB78:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	xorl	%esi, %esi
	movl	$_ZL13mcas_ptst_key, %edi
	call	pthread_key_create
	testl	%eax, %eax
	jne	.L109
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L109:
	.cfi_restore_state
	call	abort
	.cfi_endproc
.LFE78:
	.size	_Z9mcas_initv, .-_Z9mcas_initv
	.p2align 4,,15
	.globl	_Z4mcasiPPvS_S_z
	.type	_Z4mcasiPPvS_S_z, @function
_Z4mcasiPPvS_S_z:
.LFB79:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%rdx, %r12
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movl	_ZL13mcas_ptst_key(%rip), %edi
	movq	%r8, 80(%rsp)
	movq	%r9, 88(%rsp)
	call	pthread_getspecific
	testq	%rax, %rax
	movq	%rax, %r14
	je	.L160
.L111:
	movq	8(%r14), %rax
	testq	%rax, %rax
	je	.L112
	cmpl	4(%rax), %ebx
	jne	.L115
	jmp	.L161
	.p2align 4,,10
	.p2align 3
.L155:
	cmpl	4(%rsi), %ebx
	je	.L162
	movq	%rsi, %rax
.L115:
	movq	1040(%rax), %rsi
	testq	%rsi, %rsi
	jne	.L155
.L112:
	leal	-3(%rbx,%rbx,2), %eax
	movq	16(%r14), %rsi
	leal	1072(,%rax,8), %r15d
	movslq	%r15d, %r15
	leaq	(%rsi,%r15), %rax
	cmpq	24(%r14), %rax
	movq	%rax, 16(%r14)
	jnb	.L163
.L134:
	movl	num_threads(%rip), %edx
	testl	%edx, %edx
	jle	.L128
	leaq	8(%rsi), %rax
	shrq	$3, %rax
	andl	$1, %eax
	cmpl	$6, %edx
	jg	.L164
	movl	%edx, %eax
.L121:
	cmpl	$1, %eax
	movq	%rsi, 8(%rsi)
	je	.L138
	cmpl	$2, %eax
	movq	%rsi, 16(%rsi)
	je	.L139
	cmpl	$3, %eax
	movq	%rsi, 24(%rsi)
	je	.L140
	cmpl	$4, %eax
	movq	%rsi, 32(%rsi)
	je	.L141
	cmpl	$5, %eax
	movq	%rsi, 40(%rsi)
	je	.L142
	movq	%rsi, 48(%rsi)
	movl	$6, %r8d
.L123:
	cmpl	%eax, %edx
	je	.L128
.L122:
	movl	%edx, %edi
	movl	%eax, %r10d
	subl	%eax, %edi
	leal	-2(%rdi), %ecx
	shrl	%ecx
	addl	$1, %ecx
	cmpl	$1, %edi
	leal	(%rcx,%rcx), %r9d
	je	.L125
	movq	%rsi, 8(%rsp)
	leaq	8(%rsi,%r10,8), %rdx
	xorl	%eax, %eax
	movq	8(%rsp), %xmm0
	punpcklqdq	%xmm0, %xmm0
	.p2align 4,,10
	.p2align 3
.L126:
	addl	$1, %eax
	addq	$16, %rdx
	movaps	%xmm0, -16(%rdx)
	cmpl	%eax, %ecx
	ja	.L126
	addl	%r9d, %r8d
	cmpl	%r9d, %edi
	je	.L128
.L125:
	movslq	%r8d, %r8
	movq	%rsi, 8(%rsi,%r8,8)
.L128:
	movl	%ebx, 4(%rsi)
	movl	$2, 1032(%rsi)
	.p2align 4,,10
	.p2align 3
.L120:
	leaq	160(%rsp), %rax
	cmpl	$1, %ebx
	movl	$0, (%rsi)
	movl	%ebx, 4(%rsi)
	leaq	1048(%rsi), %r9
	movq	%rbp, 1048(%rsi)
	movq	%rax, 32(%rsp)
	leaq	48(%rsp), %rax
	movq	%r12, 1056(%rsi)
	movq	%r13, 1064(%rsi)
	movl	$32, 24(%rsp)
	movq	%rax, 40(%rsp)
	jle	.L147
	leal	-2(%rbx), %edx
	movq	40(%rsp), %r10
	leaq	160(%rsp), %r8
	movl	$32, %eax
	leaq	3(%rdx,%rdx,2), %rdx
	leaq	(%r9,%rdx,8), %r11
	.p2align 4,,10
	.p2align 3
.L132:
	leaq	8(%r8), %rdi
	movl	%eax, %edx
	addq	$24, %r9
	addq	%r10, %rdx
	leal	8(%rax), %ecx
	cmpl	$47, %eax
	cmovbe	%r8, %rdi
	cmovbe	%rdx, %r8
	cmova	%eax, %ecx
	movq	(%r8), %rax
	leaq	8(%rdi), %rsi
	leal	8(%rcx), %edx
	movq	%rax, (%r9)
	movl	%ecx, %eax
	addq	%r10, %rax
	cmpl	$47, %ecx
	cmovbe	%rdi, %rsi
	cmovbe	%rax, %rdi
	cmova	%ecx, %edx
	movq	(%rdi), %rax
	leaq	8(%rsi), %r8
	movl	%edx, %ecx
	addq	%r10, %rcx
	cmpl	$47, %edx
	cmovbe	%rsi, %r8
	cmovbe	%rcx, %rsi
	movq	%rax, 8(%r9)
	leal	8(%rdx), %eax
	cmova	%edx, %eax
	movq	(%rsi), %rdx
	cmpq	%r11, %r9
	movq	%rdx, 16(%r9)
	jne	.L132
.L147:
	addq	$104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L162:
	.cfi_restore_state
	leaq	1040(%rax), %r14
.L116:
	movq	1040(%rsi), %rax
	movl	1032(%rsi), %edi
	leaq	1032(%rsi), %rdx
	movq	%rax, (%r14)
	jmp	.L129
	.p2align 4,,10
	.p2align 3
.L143:
	movl	%eax, %edi
.L129:
	leal	1(%rdi), %ecx
	movl	%edi, %eax
	lock cmpxchgl	%ecx, (%rdx)
	cmpl	%eax, %edi
	jne	.L143
	jmp	.L120
.L160:
	call	_ZL8get_ptstv.part.1
	movq	%rax, %r14
	jmp	.L111
.L164:
	testl	%eax, %eax
	jne	.L121
	xorl	%r8d, %r8d
	jmp	.L122
	.p2align 4,,10
	.p2align 3
.L163:
	movl	$40960, %esi
	movl	$1, %edi
	call	calloc
	testq	%rax, %rax
	je	.L165
	leaq	40960(%rax), %rdx
	addq	%rax, %r15
	movq	%rax, %rsi
	movq	%r15, 16(%r14)
	movq	%rdx, 24(%r14)
	jmp	.L134
.L161:
	addq	$8, %r14
	movq	%rax, %rsi
	jmp	.L116
.L142:
	movl	$5, %r8d
	jmp	.L123
.L141:
	movl	$4, %r8d
	jmp	.L123
.L140:
	movl	$3, %r8d
	jmp	.L123
.L139:
	movl	$2, %r8d
	jmp	.L123
.L138:
	movl	$1, %r8d
	jmp	.L123
.L165:
	call	abort
	.cfi_endproc
.LFE79:
	.size	_Z4mcasiPPvS_S_z, .-_Z4mcasiPPvS_S_z
	.p2align 4,,15
	.globl	_Z9set_allocv
	.type	_Z9set_allocv, @function
_Z9set_allocv:
.LFB81:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$1, %edx
	xorl	%eax, %eax
	lock cmpxchgl	%edx, _ZZ9set_allocvE11mcas_inited(%rip)
	testl	%eax, %eax
	je	.L172
.L167:
	movl	$64, %edi
	call	malloc
	movq	%rax, %rdx
	movq	$1, (%rax)
	movq	$0, 8(%rax)
	orq	$1, %rdx
	movq	$-1, 32(%rax)
	movq	%rdx, 16(%rax)
	leaq	32(%rax), %rdx
	orq	$1, %rdx
	movq	%rdx, 24(%rax)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L172:
	.cfi_restore_state
	xorl	%esi, %esi
	movl	$_ZL13mcas_ptst_key, %edi
	call	pthread_key_create
	testl	%eax, %eax
	je	.L167
	call	abort
	.cfi_endproc
.LFE81:
	.size	_Z9set_allocv, .-_Z9set_allocv
	.p2align 4,,15
	.globl	_Z10set_updateP6set_stmPvi
	.type	_Z10set_updateP6set_stmPvi, @function
_Z10set_updateP6set_stmPvi:
.LFB82:
	.cfi_startproc
.L175:
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	xorl	%r15d, %r15d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	leaq	2(%rsi), %r12
	leaq	24(%r13), %r14
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdx, 8(%rsp)
	movl	%ecx, (%rsp)
	call	_Z14critical_enterv
	movq	%rax, 16(%rsp)
	jmp	.L226
	.p2align 4,,10
	.p2align 3
.L177:
	movq	%r14, %rdi
	call	_ZL10mcas_fixupPPvS_
.L226:
	movq	24(%r13), %rsi
	testb	$2, %sil
	jne	.L177
	movq	%rsi, %rbx
	movq	%r13, %rbp
	andq	$-5, %rbx
	testb	$1, %bl
	jne	.L179
	.p2align 4,,10
	.p2align 3
.L230:
	cmpq	(%rbx), %r12
	jnb	.L180
	movq	16(%rbx), %rsi
	testb	$2, %sil
	je	.L185
	leaq	16(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L182:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	16(%rbx), %rsi
	testb	$2, %sil
	jne	.L182
.L185:
	andq	$-5, %rsi
	movq	%rbx, %rbp
	movq	%rsi, %rbx
.L232:
	testb	$1, %bl
	je	.L230
.L179:
	movq	%rbx, %rdx
	andq	$-2, %rdx
	movq	(%rdx), %rax
	cmpq	%rax, %r12
	je	.L226
	testq	%r15, %r15
	je	.L231
.L197:
	cmpq	0(%rbp), %r12
	jbe	.L193
	cmpq	%rax, %r12
	ja	.L226
	movq	%rbp, %rax
	movq	%rbx, 24(%r15)
	addq	$24, %rbp
	orq	$1, %rax
	movq	%rax, 16(%r15)
.L194:
	movq	%rbx, %rax
	lock cmpxchgq	%r15, 0(%rbp)
	cmpq	%rax, %rbx
	jne	.L226
	xorl	%ecx, %ecx
	jmp	.L195
	.p2align 4,,10
	.p2align 3
.L180:
	jbe	.L184
	movq	24(%rbx), %rsi
	testb	$2, %sil
	je	.L185
	leaq	24(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L186:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	24(%rbx), %rsi
	testb	$2, %sil
	jne	.L186
	andq	$-5, %rsi
	movq	%rbx, %rbp
	movq	%rsi, %rbx
	jmp	.L232
.L184:
	movq	8(%rbx), %rcx
	leaq	8(%rbx), %rbp
	jmp	.L227
	.p2align 4,,10
	.p2align 3
.L189:
	movq	%rcx, %rsi
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	8(%rbx), %rcx
.L227:
	testb	$2, %cl
	jne	.L189
	testq	%rcx, %rcx
	je	.L226
	movl	(%rsp), %eax
	testl	%eax, %eax
	jne	.L233
.L191:
	testq	%r15, %r15
	je	.L195
	movl	_ZL5gc_id(%rip), %edx
	movq	16(%rsp), %rdi
	movq	%r15, %rsi
	movq	%rcx, (%rsp)
	call	_Z7gc_freeP7ptst_stPvi
	movq	(%rsp), %rcx
.L195:
	movq	16(%rsp), %rdi
	movq	%rcx, (%rsp)
	call	_Z7gc_exitP7ptst_st
	movq	(%rsp), %rcx
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	movq	%rcx, %rax
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L233:
	.cfi_restore_state
	movq	8(%rsp), %rdx
	movq	%rcx, %rax
	lock cmpxchgq	%rdx, 8(%rbx)
	cmpq	%rax, %rcx
	je	.L191
	movq	%rax, %rcx
	jmp	.L227
.L193:
	cmpq	%rax, %r12
	jb	.L226
	movq	%rbp, %rax
	movq	%rbx, 16(%r15)
	addq	$16, %rbp
	orq	$1, %rax
	movq	%rax, 24(%r15)
	jmp	.L194
.L231:
	movl	_ZL5gc_id(%rip), %esi
	movq	16(%rsp), %rdi
	movq	%rdx, 24(%rsp)
	call	_Z8gc_allocP7ptst_sti
	movq	24(%rsp), %rdx
	movq	%r12, (%rax)
	movq	%rax, %r15
	movq	8(%rsp), %rax
	movq	%rax, 8(%r15)
	movq	(%rdx), %rax
	jmp	.L197
	.cfi_endproc
.LFE82:
	.size	_Z10set_updateP6set_stmPvi, .-_Z10set_updateP6set_stmPvi
	.p2align 4,,15
	.globl	_Z10set_removeP6set_stm
	.type	_Z10set_removeP6set_stm, @function
_Z10set_removeP6set_stm:
.LFB83:
	.cfi_startproc
.L236:
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	leaq	2(%rsi), %r15
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	call	_Z14critical_enterv
	movq	%rax, 32(%rsp)
	leaq	24(%r13), %rax
	movq	%rax, %r12
	jmp	.L395
	.p2align 4,,10
	.p2align 3
.L238:
	movq	%r12, %rdi
	call	_ZL10mcas_fixupPPvS_
.L395:
	movq	24(%r13), %rsi
	testb	$2, %sil
	jne	.L238
	movq	%rsi, %rbx
	movq	%r13, %r14
	andq	$-5, %rbx
	testb	$1, %bl
	jne	.L240
	.p2align 4,,10
	.p2align 3
.L403:
	cmpq	(%rbx), %r15
	jnb	.L241
	movq	16(%rbx), %rsi
	testb	$2, %sil
	je	.L246
	leaq	16(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L243:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	16(%rbx), %rsi
	testb	$2, %sil
	jne	.L243
.L246:
	andq	$-5, %rsi
	movq	%rbx, %r14
	movq	%rsi, %rbx
.L404:
	testb	$1, %bl
	je	.L403
.L240:
	andq	$-2, %rbx
	cmpq	(%rbx), %r15
	je	.L395
.L250:
	xorl	%r14d, %r14d
.L248:
	movq	32(%rsp), %rdi
	call	_Z7gc_exitP7ptst_st
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r14, %rax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L241:
	.cfi_restore_state
	jbe	.L245
	movq	24(%rbx), %rsi
	testb	$2, %sil
	je	.L246
	leaq	24(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L247:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	24(%rbx), %rsi
	testb	$2, %sil
	jne	.L247
	andq	$-5, %rsi
	movq	%rbx, %r14
	movq	%rsi, %rbx
	jmp	.L404
.L245:
	movq	8(%rbx), %rbp
	testb	$2, %bpl
	je	.L304
	leaq	8(%rbx), %rax
	movq	%rbp, %rsi
	movq	%rax, %rbp
	.p2align 4,,10
	.p2align 3
.L249:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	8(%rbx), %rsi
	testb	$2, %sil
	jne	.L249
	movq	%rsi, %rbp
.L304:
	testq	%rbp, %rbp
	je	.L250
	movq	16(%rbx), %r9
	testb	$2, %r9b
	movl	%r9d, %r11d
	je	.L251
	leaq	16(%rbx), %rax
	movq	%r15, 8(%rsp)
	movq	%r9, %rsi
	movq	%rax, %r15
	.p2align 4,,10
	.p2align 3
.L252:
	movq	%r15, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	16(%rbx), %rsi
	testb	$2, %sil
	movl	%esi, %r11d
	jne	.L252
	movq	8(%rsp), %r15
	movq	%rsi, %r9
.L251:
	testb	$4, %r11b
	jne	.L395
	movq	24(%rbx), %rdx
	testb	$2, %dl
	movl	%edx, 8(%rsp)
	je	.L254
	leaq	24(%rbx), %rax
	movq	%rdx, %rsi
	movq	%rax, 16(%rsp)
.L255:
	movq	16(%rsp), %rdi
	movl	%r11d, 40(%rsp)
	movq	%r9, 24(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	24(%rbx), %rsi
	movq	24(%rsp), %r9
	movl	40(%rsp), %r11d
	testb	$2, %sil
	movl	%esi, 8(%rsp)
	jne	.L255
	movq	%rsi, %rdx
.L254:
	testb	$4, 8(%rsp)
	jne	.L395
	movq	(%rbx), %rax
	cmpq	%rax, (%r14)
	jbe	.L257
	movq	16(%rbx), %rsi
	leaq	16(%r14), %rax
	leaq	16(%rbx), %r14
	movq	%rax, 16(%rsp)
	testb	$2, %sil
	je	.L258
.L262:
	movq	%r14, %rdi
	movq	%rdx, 48(%rsp)
	movl	%r11d, 40(%rsp)
	movq	%r9, 24(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	16(%rbx), %rsi
	movq	24(%rsp), %r9
	movl	40(%rsp), %r11d
	movq	48(%rsp), %rdx
	testb	$2, %sil
	jne	.L262
.L258:
	movq	%rsi, %rcx
	andq	$-5, %rcx
	testb	$1, %cl
	jne	.L306
	movq	%rbx, 24(%rsp)
	movq	%rcx, %r14
	movq	%r12, %rcx
	movq	%rbp, %r12
	movq	%rbx, %rbp
	movq	%r9, %rbx
.L269:
	movq	24(%r14), %rsi
	testb	$2, %sil
	je	.L264
	leaq	24(%r14), %rax
	movq	%rax, 40(%rsp)
.L268:
	movq	40(%rsp), %rdi
	movq	%rcx, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movl	%r11d, 48(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	24(%r14), %rsi
	movl	48(%rsp), %r11d
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rcx
	testb	$2, %sil
	jne	.L268
.L264:
	andq	$-5, %rsi
	testb	$1, %sil
	jne	.L390
	movq	%r14, 24(%rsp)
	movq	%rsi, %r14
	jmp	.L269
.L257:
	movq	%rdx, %rcx
	leaq	24(%r14), %rax
	andq	$-5, %rcx
	testb	$1, %cl
	movq	%rax, 16(%rsp)
	jne	.L305
	movq	%rbx, 24(%rsp)
	movq	%rcx, %r14
	movq	%r12, %rcx
	movq	%rbp, %r12
	movq	%rbx, %rbp
	movq	%r9, %rbx
.L290:
	movq	16(%r14), %rsi
	testb	$2, %sil
	je	.L285
	leaq	16(%r14), %rax
	movq	%rax, 40(%rsp)
.L289:
	movq	40(%rsp), %rdi
	movq	%rcx, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movl	%r11d, 48(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	16(%r14), %rsi
	movl	48(%rsp), %r11d
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rcx
	testb	$2, %sil
	jne	.L289
.L285:
	andq	$-5, %rsi
	testb	$1, %sil
	jne	.L392
	movq	%r14, 24(%rsp)
	movq	%rsi, %r14
	jmp	.L290
.L305:
	movq	%rbx, %rcx
	movq	$0, 24(%rsp)
.L260:
	movq	16(%rbx), %rsi
	leaq	16(%rbx), %r14
	testb	$2, %sil
	je	.L287
.L291:
	movq	%r14, %rdi
	movq	%rcx, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movl	%r11d, 48(%rsp)
	movq	%r9, 40(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	16(%rbx), %rsi
	movq	40(%rsp), %r9
	movl	48(%rsp), %r11d
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rcx
	testb	$2, %sil
	jne	.L291
.L287:
	andq	$-5, %rsi
	testb	$1, %sil
	jne	.L405
	movq	%r12, %r8
	movq	%rsi, %r14
	movq	%rbp, %r12
	movq	%rbx, %rbp
	movq	%r9, %rbx
.L295:
	movq	24(%r14), %rsi
	testb	$2, %sil
	je	.L293
	leaq	24(%r14), %rax
	movq	%rax, 40(%rsp)
.L294:
	movq	40(%rsp), %rdi
	movq	%r8, 72(%rsp)
	movq	%rcx, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movl	%r11d, 48(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	24(%r14), %rsi
	movl	48(%rsp), %r11d
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rcx
	movq	72(%rsp), %r8
	testb	$2, %sil
	jne	.L294
.L293:
	andq	$-5, %rsi
	testb	$1, %sil
	jne	.L406
	movq	%rsi, %r14
	jmp	.L295
.L392:
	movq	%rbx, %r9
	movq	%rbp, %rbx
	movq	%r12, %rbp
	movq	%rcx, %r12
	movq	%r14, %rcx
	jmp	.L260
.L306:
	movq	%rbx, %rcx
	movq	$0, 24(%rsp)
.L263:
	movq	24(%rbx), %rsi
	leaq	24(%rbx), %r14
	testb	$2, %sil
	je	.L266
.L270:
	movq	%r14, %rdi
	movq	%rcx, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movl	%r11d, 48(%rsp)
	movq	%r9, 40(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	24(%rbx), %rsi
	movq	40(%rsp), %r9
	movl	48(%rsp), %r11d
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rcx
	testb	$2, %sil
	jne	.L270
.L266:
	andq	$-5, %rsi
	testb	$1, %sil
	jne	.L407
	movq	%r12, %r8
	movq	%rsi, %r14
	movq	%rbp, %r12
	movq	%rbx, %rbp
	movq	%r9, %rbx
.L274:
	movq	16(%r14), %rsi
	testb	$2, %sil
	je	.L272
	leaq	16(%r14), %rax
	movq	%rax, 40(%rsp)
.L273:
	movq	40(%rsp), %rdi
	movq	%r8, 72(%rsp)
	movq	%rcx, 64(%rsp)
	movq	%rdx, 56(%rsp)
	movl	%r11d, 48(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	16(%r14), %rsi
	movl	48(%rsp), %r11d
	movq	56(%rsp), %rdx
	movq	64(%rsp), %rcx
	movq	72(%rsp), %r8
	testb	$2, %sil
	jne	.L273
.L272:
	andq	$-5, %rsi
	testb	$1, %sil
	jne	.L408
	movq	%rsi, %r14
	jmp	.L274
.L390:
	movq	%rbx, %r9
	movq	%rbp, %rbx
	movq	%r12, %rbp
	movq	%rcx, %r12
	movq	%r14, %rcx
	jmp	.L263
.L405:
	movq	%rbx, %r8
.L292:
	andl	$1, %r11d
	je	.L296
	testb	$1, 8(%rsp)
	jne	.L409
	cmpq	%rcx, %rbx
	je	.L395
	movq	%rbx, %rax
	addq	$16, %rcx
	pushq	%r9
	.cfi_def_cfa_offset 152
	orq	$1, %rax
	leaq	8(%rbx), %rsi
	pushq	%rax
	.cfi_def_cfa_offset 160
	pushq	%rcx
	.cfi_def_cfa_offset 168
.L398:
	pushq	%rdx
	.cfi_def_cfa_offset 176
.L396:
	movq	%rdx, %rax
	pushq	%rbx
	.cfi_def_cfa_offset 184
	pushq	56(%rsp)
	.cfi_def_cfa_offset 192
	orq	$4, %rax
	leaq	16(%rbx), %r8
	xorl	%ecx, %ecx
	pushq	%rax
	.cfi_def_cfa_offset 200
	leaq	24(%rbx), %rax
	pushq	%rdx
	.cfi_def_cfa_offset 208
	movl	$5, %edi
	movq	%rbp, %rdx
	pushq	%rax
	.cfi_def_cfa_offset 216
	movq	%r9, %rax
	orq	$4, %rax
	pushq	%rax
	.cfi_def_cfa_offset 224
	xorl	%eax, %eax
	call	_Z4mcasiPPvS_S_z
	addq	$80, %rsp
	.cfi_def_cfa_offset 144
.L277:
	testl	%eax, %eax
	je	.L395
	movl	_ZL5gc_id(%rip), %edx
	movq	32(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%rbp, %r14
	call	_Z7gc_freeP7ptst_stPvi
	jmp	.L248
.L406:
	movq	%rbx, %r9
	movq	%rbp, %rbx
	movq	%r12, %rbp
	movq	%r8, %r12
	movq	%r14, %r8
	jmp	.L292
.L409:
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	leaq	8(%rbx), %rsi
	pushq	%rdx
	.cfi_def_cfa_offset 160
.L400:
	movq	%rdx, %rax
	pushq	%rbx
	.cfi_def_cfa_offset 168
	pushq	40(%rsp)
	.cfi_def_cfa_offset 176
	orq	$4, %rax
	leaq	16(%rbx), %r8
	xorl	%ecx, %ecx
	pushq	%rax
	.cfi_def_cfa_offset 184
	leaq	24(%rbx), %rax
	pushq	%rdx
	.cfi_def_cfa_offset 192
	movl	$4, %edi
	movq	%rbp, %rdx
	pushq	%rax
	.cfi_def_cfa_offset 200
	movq	%r9, %rax
	orq	$4, %rax
	pushq	%rax
	.cfi_def_cfa_offset 208
	xorl	%eax, %eax
	call	_Z4mcasiPPvS_S_z
	addq	$64, %rsp
	.cfi_def_cfa_offset 144
	jmp	.L277
.L296:
	testb	$1, 8(%rsp)
	je	.L298
	cmpq	%r8, %rbx
	je	.L395
	movq	%rbx, %rax
	addq	$24, %r8
	pushq	%rdx
	.cfi_remember_state
	.cfi_def_cfa_offset 152
	orq	$1, %rax
	leaq	8(%rbx), %rsi
	pushq	%rax
	.cfi_def_cfa_offset 160
	pushq	%r8
	.cfi_def_cfa_offset 168
	pushq	%r9
	.cfi_def_cfa_offset 176
	jmp	.L396
.L407:
	.cfi_restore_state
	movq	%rbx, %r8
.L271:
	testb	$1, 8(%rsp)
	je	.L275
	andl	$1, %r11d
	jne	.L410
	cmpq	%rcx, %rbx
	je	.L395
	movq	%rbx, %rax
	addq	$24, %rcx
	pushq	%rdx
	.cfi_remember_state
	.cfi_def_cfa_offset 152
	orq	$1, %rax
	leaq	8(%rbx), %rsi
	pushq	%rax
	.cfi_def_cfa_offset 160
	pushq	%rcx
	.cfi_def_cfa_offset 168
	pushq	%r9
	.cfi_def_cfa_offset 176
	jmp	.L396
.L298:
	.cfi_restore_state
	cmpq	%rcx, %rbx
	je	.L395
	cmpq	%r8, %rbx
	je	.L395
	cmpq	24(%rsp), %rbx
	je	.L299
	movq	24(%rcx), %rax
	leaq	24(%rcx), %r14
	testb	$2, %al
	movl	%eax, %esi
	je	.L300
.L302:
	movq	%rax, %rsi
	movq	%r14, %rdi
	movq	%r8, 56(%rsp)
	movq	%rcx, 48(%rsp)
	movq	%rdx, 40(%rsp)
	movq	%r9, 8(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	48(%rsp), %rcx
	movq	8(%rsp), %r9
	movq	40(%rsp), %rdx
	movq	56(%rsp), %r8
	movq	24(%rcx), %rax
	testb	$2, %al
	movl	%eax, %esi
	jne	.L302
.L300:
	testb	$4, %sil
	jne	.L395
	movq	%r9, %r10
	leaq	16(%rbx), %r11
	movq	%rdx, %rdi
	orq	$4, %rdi
	orq	$4, %r10
	addq	$24, %r8
	movq	%rdi, 40(%rsp)
	movq	%r10, 48(%rsp)
	movq	%rbx, %rdi
	movq	%r11, 56(%rsp)
	leaq	16(%rcx), %r10
	movq	%rcx, %r11
	orq	$1, %r11
	orq	$1, %rdi
	andl	$1, %esi
	movq	%rax, %rsi
	movq	%r10, 64(%rsp)
	leaq	24(%rbx), %r14
	cmovne	%r11, %rsi
	leaq	24(%rcx), %r10
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	movq	%rsi, 16(%rsp)
	pushq	%rcx
	.cfi_def_cfa_offset 160
	leaq	8(%rbx), %rsi
	pushq	%rbx
	.cfi_def_cfa_offset 168
	pushq	40(%rsp)
	.cfi_def_cfa_offset 176
	pushq	72(%rsp)
	.cfi_def_cfa_offset 184
	pushq	%rdx
	.cfi_def_cfa_offset 192
	pushq	%r14
	.cfi_def_cfa_offset 200
	pushq	104(%rsp)
	.cfi_def_cfa_offset 208
	pushq	%r9
	.cfi_def_cfa_offset 216
	pushq	128(%rsp)
	.cfi_def_cfa_offset 224
	pushq	%r11
	.cfi_def_cfa_offset 232
	pushq	%rdi
	.cfi_def_cfa_offset 240
	pushq	%r8
	.cfi_def_cfa_offset 248
	pushq	%r9
	.cfi_def_cfa_offset 256
	movq	%rcx, %r9
	pushq	%rdi
	.cfi_def_cfa_offset 264
	pushq	184(%rsp)
	.cfi_def_cfa_offset 272
	pushq	%rdx
	.cfi_def_cfa_offset 280
	pushq	%rax
	.cfi_def_cfa_offset 288
	pushq	%r10
	.cfi_def_cfa_offset 296
	pushq	160(%rsp)
	.cfi_def_cfa_offset 304
	movq	184(%rsp), %rax
	leaq	16(%rax), %r8
.L399:
	xorl	%ecx, %ecx
	movq	%rbp, %rdx
	movl	$8, %edi
	xorl	%eax, %eax
	call	_Z4mcasiPPvS_S_z
	addq	$160, %rsp
	.cfi_def_cfa_offset 144
	jmp	.L277
.L408:
	movq	%rbx, %r9
	movq	%rbp, %rbx
	movq	%r12, %rbp
	movq	%r8, %r12
	movq	%r14, %r8
	jmp	.L271
.L299:
	movq	%rdx, %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	movq	%rbx, %rax
	orq	$4, %rdi
	pushq	%rcx
	.cfi_def_cfa_offset 160
	pushq	%rbx
	.cfi_def_cfa_offset 168
	pushq	40(%rsp)
	.cfi_def_cfa_offset 176
	pushq	%rdi
	.cfi_def_cfa_offset 184
	orq	$1, %rax
	pushq	%rdx
	.cfi_def_cfa_offset 192
	leaq	24(%rbx), %rdx
	addq	$24, %r8
	leaq	8(%rbx), %rsi
	pushq	%rdx
	.cfi_def_cfa_offset 200
	movq	%r9, %rdx
	orq	$4, %rdx
	pushq	%rdx
	.cfi_def_cfa_offset 208
	leaq	16(%rbx), %rdx
	pushq	%r9
	.cfi_def_cfa_offset 216
	pushq	%rdx
	.cfi_def_cfa_offset 224
	movq	%rcx, %rdx
	orq	$1, %rdx
	pushq	%rdx
	.cfi_def_cfa_offset 232
	pushq	%rax
	.cfi_def_cfa_offset 240
	pushq	%r8
	.cfi_def_cfa_offset 248
	leaq	16(%rcx), %r8
	pushq	%r9
	.cfi_def_cfa_offset 256
	movq	%rax, %r9
.L397:
	xorl	%ecx, %ecx
	movq	%rbp, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	_Z4mcasiPPvS_S_z
	addq	$112, %rsp
	.cfi_def_cfa_offset 144
	jmp	.L277
.L410:
	subq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 152
	leaq	8(%rbx), %rsi
	pushq	%r9
	.cfi_def_cfa_offset 160
	jmp	.L400
.L275:
	.cfi_restore_state
	andl	$1, %r11d
	je	.L279
	cmpq	%r8, %rbx
	je	.L395
	movq	%rbx, %rax
	addq	$16, %r8
	pushq	%r9
	.cfi_remember_state
	.cfi_def_cfa_offset 152
	orq	$1, %rax
	leaq	8(%rbx), %rsi
	pushq	%rax
	.cfi_def_cfa_offset 160
	pushq	%r8
	.cfi_def_cfa_offset 168
	jmp	.L398
.L279:
	.cfi_restore_state
	cmpq	%rcx, %rbx
	je	.L395
	cmpq	%r8, %rbx
	je	.L395
	cmpq	24(%rsp), %rbx
	je	.L280
	movq	16(%rcx), %rax
	leaq	16(%rcx), %r14
	testb	$2, %al
	movl	%eax, %esi
	je	.L281
.L283:
	movq	%rax, %rsi
	movq	%r14, %rdi
	movq	%r8, 56(%rsp)
	movq	%rcx, 48(%rsp)
	movq	%rdx, 40(%rsp)
	movq	%r9, 8(%rsp)
	call	_ZL10mcas_fixupPPvS_
	movq	48(%rsp), %rcx
	movq	8(%rsp), %r9
	movq	40(%rsp), %rdx
	movq	56(%rsp), %r8
	movq	16(%rcx), %rax
	testb	$2, %al
	movl	%eax, %esi
	jne	.L283
.L281:
	testb	$4, %sil
	jne	.L395
	movq	%r9, %r10
	leaq	16(%rbx), %r11
	movq	%rdx, %rdi
	orq	$4, %rdi
	orq	$4, %r10
	addq	$16, %r8
	movq	%rdi, 40(%rsp)
	movq	%r10, 48(%rsp)
	movq	%rbx, %rdi
	movq	%r11, 56(%rsp)
	leaq	24(%rcx), %r10
	movq	%rcx, %r11
	orq	$1, %r11
	orq	$1, %rdi
	andl	$1, %esi
	movq	%rax, %rsi
	movq	%r10, 64(%rsp)
	leaq	24(%rbx), %r14
	cmovne	%r11, %rsi
	leaq	16(%rcx), %r10
	subq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 152
	movq	%rsi, 16(%rsp)
	pushq	%rcx
	.cfi_def_cfa_offset 160
	leaq	8(%rbx), %rsi
	pushq	%rbx
	.cfi_def_cfa_offset 168
	pushq	40(%rsp)
	.cfi_def_cfa_offset 176
	pushq	72(%rsp)
	.cfi_def_cfa_offset 184
	pushq	%rdx
	.cfi_def_cfa_offset 192
	pushq	%r14
	.cfi_def_cfa_offset 200
	pushq	104(%rsp)
	.cfi_def_cfa_offset 208
	pushq	%r9
	.cfi_def_cfa_offset 216
	pushq	128(%rsp)
	.cfi_def_cfa_offset 224
	pushq	%r11
	.cfi_def_cfa_offset 232
	pushq	%rdi
	.cfi_def_cfa_offset 240
	pushq	%r8
	.cfi_def_cfa_offset 248
	pushq	%rdx
	.cfi_def_cfa_offset 256
	pushq	%rdi
	.cfi_def_cfa_offset 264
	pushq	184(%rsp)
	.cfi_def_cfa_offset 272
	pushq	%r9
	.cfi_def_cfa_offset 280
	pushq	%rax
	.cfi_def_cfa_offset 288
	movq	%rcx, %r9
	pushq	%r10
	.cfi_def_cfa_offset 296
	pushq	160(%rsp)
	.cfi_def_cfa_offset 304
	movq	184(%rsp), %rax
	leaq	24(%rax), %r8
	jmp	.L399
.L280:
	.cfi_restore_state
	movq	%rdx, %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	movq	%rbx, %rax
	orq	$4, %rdi
	pushq	%rcx
	.cfi_def_cfa_offset 160
	pushq	%rbx
	.cfi_def_cfa_offset 168
	pushq	40(%rsp)
	.cfi_def_cfa_offset 176
	pushq	%rdi
	.cfi_def_cfa_offset 184
	leaq	24(%rbx), %rdi
	pushq	%rdx
	.cfi_def_cfa_offset 192
	orq	$1, %rax
	addq	$16, %r8
	pushq	%rdi
	.cfi_def_cfa_offset 200
	movq	%r9, %rdi
	leaq	8(%rbx), %rsi
	orq	$4, %rdi
	pushq	%rdi
	.cfi_def_cfa_offset 208
	leaq	16(%rbx), %rdi
	pushq	%r9
	.cfi_def_cfa_offset 216
	movq	%rax, %r9
	pushq	%rdi
	.cfi_def_cfa_offset 224
	movq	%rcx, %rdi
	orq	$1, %rdi
	pushq	%rdi
	.cfi_def_cfa_offset 232
	pushq	%rax
	.cfi_def_cfa_offset 240
	pushq	%r8
	.cfi_def_cfa_offset 248
	leaq	24(%rcx), %r8
	pushq	%rdx
	.cfi_def_cfa_offset 256
	jmp	.L397
	.cfi_endproc
.LFE83:
	.size	_Z10set_removeP6set_stm, .-_Z10set_removeP6set_stm
	.p2align 4,,15
	.globl	_Z10set_lookupP6set_stm
	.type	_Z10set_lookupP6set_stm, @function
_Z10set_lookupP6set_stm:
.LFB84:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	leaq	2(%rsi), %r12
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	call	_Z14critical_enterv
	movq	24(%rbx), %rsi
	movq	%rax, %r13
	testb	$2, %sil
	je	.L412
	leaq	24(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L413:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	24(%rbx), %rsi
	testb	$2, %sil
	jne	.L413
	.p2align 4,,10
	.p2align 3
.L412:
	movq	%rsi, %rbx
	andq	$-5, %rbx
	testb	$1, %bl
	jne	.L415
.L444:
	cmpq	(%rbx), %r12
	jnb	.L416
	movq	16(%rbx), %rsi
	testb	$2, %sil
	je	.L412
	leaq	16(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L418:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	16(%rbx), %rsi
	testb	$2, %sil
	jne	.L418
	movq	%rsi, %rbx
	andq	$-5, %rbx
	testb	$1, %bl
	je	.L444
.L415:
	andq	$-2, %rbx
	cmpq	(%rbx), %r12
	jne	.L426
.L420:
.L424:
	movq	8(%rbx), %rsi
	testb	$2, %sil
	je	.L423
	leaq	8(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L425:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	8(%rbx), %rsi
	testb	$2, %sil
	jne	.L425
.L423:
	movq	%r13, %rdi
	movq	%rsi, 8(%rsp)
	call	_Z7gc_exitP7ptst_st
	movq	8(%rsp), %rsi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	movq	%rsi, %rax
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L416:
	.cfi_restore_state
	jbe	.L424
	movq	24(%rbx), %rsi
	testb	$2, %sil
	je	.L412
	leaq	24(%rbx), %rbp
	.p2align 4,,10
	.p2align 3
.L422:
	movq	%rbp, %rdi
	call	_ZL10mcas_fixupPPvS_
	movq	24(%rbx), %rsi
	testb	$2, %sil
	jne	.L422
	jmp	.L412
.L426:
	xorl	%esi, %esi
	jmp	.L423
	.cfi_endproc
.LFE84:
	.size	_Z10set_lookupP6set_stm, .-_Z10set_lookupP6set_stm
	.p2align 4,,15
	.globl	_Z19_init_set_subsystemv
	.type	_Z19_init_set_subsystemv, @function
_Z19_init_set_subsystemv:
.LFB85:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$32, %edi
	call	_Z16gc_add_allocatori
	movl	%eax, _ZL5gc_id(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE85:
	.size	_Z19_init_set_subsystemv, .-_Z19_init_set_subsystemv
	.local	_ZZ9set_allocvE11mcas_inited
	.comm	_ZZ9set_allocvE11mcas_inited,4,4
	.local	_ZL5gc_id
	.comm	_ZL5gc_id,4,4
	.local	_ZL14next_thread_id
	.comm	_ZL14next_thread_id,4,4
	.globl	p1
	.bss
	.align 32
	.type	p1, @object
	.size	p1, 128
p1:
	.zero	128
	.globl	p0
	.align 32
	.type	p0, @object
	.size	p0, 128
p0:
	.zero	128
	.local	_ZL13mcas_ptst_key
	.comm	_ZL13mcas_ptst_key,4,4
	.ident	"GCC: (GNU) 6.1.0"
	.section	.note.GNU-stack,"",@progbits
