.altmacro
.macro SAVE_GP n
    sw x\n, \n*8(sp)
.endm
.macro LOAD_GP n
    lw x\n, \n*8(sp)
.endm
    .section .text.trap
    .globl __alltraps
    .globl __restore
    .align 2
__alltraps:
    addi sp, sp, -34*8
    # save general-purpose registers
    sw x1, 1*8(sp)
    # skip sp(x2), we will save it later
    sw x3, 3*8(sp)
    # skip tp(x4), application does not use it
    # save x5~x31
    .set n, 5
    .rept 27
        SAVE_GP %n
        .set n, n+1
    .endr
    # we can use t0/t1/t2 freely, because they were saved on kernel stack
    csrr t1, mepc
    sw t0, 32*8(sp)
    sw t1, 33*8(sp)
    # read user stack from sscratch and save it on the kernel stack
    # csrr t2, sscratch
    sw t2, 2*8(sp)
    # set input argument of trap_handler(cx: &mut TrapContext)
    mv a0, sp
    call trap_handler

__restore:
    # restore uepc
    # lw t0, 32*8(sp)
    lw t1, 33*8(sp)
    # lw t2, 2*8(sp)
    # csrw sstatus, t0
    csrw mepc, t1
    # csrw sscratch, t2
    # restore general-purpuse registers except sp/tp
    lw x1, 1*8(sp)
    lw x3, 3*8(sp)
    .set n, 5
    .rept 27
        LOAD_GP %n
        .set n, n+1
    .endr
    # release TrapContext on stack
    addi sp, sp, 34*8
    mret
