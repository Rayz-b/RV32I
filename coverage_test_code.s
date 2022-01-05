addi x31, x0, 1 #generate powers of 2 such that xn = 2^(n)
slli x31, x31, 31
srli x30, x31, 1
srli x29, x30, 1
srli x28, x29, 1
srli x27, x28, 1
srli x26, x27, 1
srli x25, x26, 1
srli x24, x25, 1
srli x23, x24, 1
srli x22, x23, 1
srli x21, x22, 1
srli x20, x21, 1
srli x19, x20, 1
srli x18, x19, 1
srli x17, x18, 1
srli x16, x17, 1
srli x15, x16, 1
srli x14, x15, 1
srli x13, x14, 1
srli x12, x13, 1
srli x11, x12, 1
srli x10, x11, 1
srli x9, x10, 1
srli x8, x9, 1
srli x7, x8, 1
srli x6, x7, 1
srli x5, x6, 1
srli x4, x5, 1
srli x3, x4, 1
srli x2, x3, 1
srli x1, x2, 1
srli x0, x1, 1

#alu testing
add x1,x2,x3
add x2,x31,x5

sub x3,x2,x5
sub x4,x31,x2

or x4,x3,x2
or x1,x31,x2

and x5,x3,x2
and x6,x31,x2

xor x7,x5,x0
xor x8,x31,x1

slt x9, x7,x5
slt x10, x5,x7

sltu x11,x12,x13
sltu x12,x13,x12

sra x13,x31,x1
sra x14,x15,x1

sw x2, 0(x0)
sw x3, 4(x0)
sw x4, 8(x0)
sw x5, 12(x0)

lw x8, 8(x0)

addi x1,x0,1
addi x2,x0,2
beq x0,x1, failed_branch
beq x0,x0, branch
addi x0,x0, 0
addi x0,x0, 0
addi x0,x0, 0
branch:
    addi x4, x0, 4
    bne x0,x0, failed_branch
    bne x1,x0, branch2

addi x0,x0, 0
addi x0,x0, 0
addi x0,x0, 0
branch2:
    addi x5,x0,5
    blt x0,x0, failed_branch
    blt x0,x5, branch3

addi x0,x0, 0
addi x0,x0, 0
addi x0,x0, 0

branch3:
    addi x6,x0,6
    bge x0,x5, failed_branch
    bge x5,x0, continue

failed_branch:
    addi x10, x0,111
    j failed_branch

continue:
    addi x13,x4,1
jal x0,jump_ahead
addi x0,x0, 0
addi x0,x0, 0
jump_ahead:
    addi x27,x0, 27
    addi x28,x0, 28

    
